Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A82FD16A95B
	for <mm-commits@vger.kernel.org>; Wed, 24 Jul 2024 19:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721849591; cv=none; b=ZnvGtTr4WQ5XPERFOFamNSAqVyIAktsU1/tXuRRIeOCWV3FUyBNxXjE/bG+3dYSE1UdkoLtH/nAyJgST6SjjLcU6CMeTCx9iWsRQUGbcsDxh9G8WeBkFdMOO0wSh1R9RsR6YucRBOxqua4nyumGbH6YrSv0P5VsMo10UNierhTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721849591; c=relaxed/simple;
	bh=ri6D3d9nGvPxuKh//uXb8D3elQgpzoPEihe5gO07RA0=;
	h=Date:To:From:Subject:Message-Id; b=KFEcH3/yzZ/NxOOmVo+uKRqql+EMDJEnlq1J1K7lC16yfk6kY3NOUKVeo+bDizbIPuMvx08Q5o4uhRlXHi2mfgVb39wCqp1i07G4oSUu5TDw2hAy28ttAaEXoo/6ryEZnhekQfRIb0v2cE9TPuTCULjgly7ki61h9Sfpk7jINLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HHjrEgwH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HHjrEgwH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7451DC32781;
	Wed, 24 Jul 2024 19:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721849591;
	bh=ri6D3d9nGvPxuKh//uXb8D3elQgpzoPEihe5gO07RA0=;
	h=Date:To:From:Subject:From;
	b=HHjrEgwHL9nV75XA1VoofClVfft+PoLB+nqlsVpHWatIjlOspkUszYjfP93HnqVID
	 Q1ScevRU77DOP8Z7LddvSAzKlXcvEdks1bJ67fQ4NjSwAHkZ9q11HHBz0fpKeXHt4W
	 X31qVb4A84AkVmZf87LrhonGVeVg19l7cO1asz7k=
Date: Wed, 24 Jul 2024 12:33:10 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-remove-boilerplate.patch added to mm-unstable branch
Message-Id: <20240724193311.7451DC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/swap: remove boilerplate
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-remove-boilerplate.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-remove-boilerplate.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Yu Zhao <yuzhao@google.com>
Subject: mm/swap: remove boilerplate
Date: Wed, 10 Jul 2024 20:13:17 -0600

Remove boilerplate by using a macro to choose the corresponding lock and
handler for each folio_batch in cpu_fbatches.

Link: https://lkml.kernel.org/r/20240711021317.596178-6-yuzhao@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |  107 +++++++++++++++++-----------------------------------
 1 file changed, 37 insertions(+), 70 deletions(-)

--- a/mm/swap.c~mm-swap-remove-boilerplate
+++ a/mm/swap.c
@@ -220,16 +220,45 @@ static void folio_batch_move_lru(struct
 	folios_put(fbatch);
 }
 
-static void folio_batch_add_and_move(struct folio_batch *fbatch,
-		struct folio *folio, move_fn_t move_fn)
+static void __folio_batch_add_and_move(struct folio_batch *fbatch,
+		struct folio *folio, move_fn_t move_fn,
+		bool on_lru, bool disable_irq)
 {
+	unsigned long flags;
+
+	folio_get(folio);
+
+	if (on_lru && !folio_test_clear_lru(folio)) {
+		folio_put(folio);
+		return;
+	}
+
 	if (folio_batch_add(fbatch, folio) && !folio_test_large(folio) &&
 	    !lru_cache_disabled())
 		return;
 
+	if (disable_irq)
+		local_lock_irqsave(&cpu_fbatches.lock_irq, flags);
+	else
+		local_lock(&cpu_fbatches.lock);
+
 	folio_batch_move_lru(fbatch, move_fn);
+
+	if (disable_irq)
+		local_unlock_irqrestore(&cpu_fbatches.lock_irq, flags);
+	else
+		local_unlock(&cpu_fbatches.lock);
 }
 
+#define folio_batch_add_and_move(folio, op, on_lru)						\
+	__folio_batch_add_and_move(								\
+		this_cpu_ptr(&cpu_fbatches.op),							\
+		folio,										\
+		op,										\
+		on_lru,										\
+		offsetof(struct cpu_fbatches, op) > offsetof(struct cpu_fbatches, lock_irq)	\
+	)
+
 static void lru_move_tail(struct lruvec *lruvec, struct folio *folio)
 {
 	if (folio_test_unevictable(folio))
@@ -250,23 +279,11 @@ static void lru_move_tail(struct lruvec
  */
 void folio_rotate_reclaimable(struct folio *folio)
 {
-	struct folio_batch *fbatch;
-	unsigned long flags;
-
 	if (folio_test_locked(folio) || folio_test_dirty(folio) ||
 	    folio_test_unevictable(folio))
 		return;
 
-	folio_get(folio);
-	if (!folio_test_clear_lru(folio)) {
-		folio_put(folio);
-		return;
-	}
-
-	local_lock_irqsave(&cpu_fbatches.lock_irq, flags);
-	fbatch = this_cpu_ptr(&cpu_fbatches.lru_move_tail);
-	folio_batch_add_and_move(fbatch, folio, lru_move_tail);
-	local_unlock_irqrestore(&cpu_fbatches.lock_irq, flags);
+	folio_batch_add_and_move(folio, lru_move_tail, true);
 }
 
 void lru_note_cost(struct lruvec *lruvec, bool file,
@@ -355,21 +372,10 @@ static void folio_activate_drain(int cpu
 
 void folio_activate(struct folio *folio)
 {
-	struct folio_batch *fbatch;
-
 	if (folio_test_active(folio) || folio_test_unevictable(folio))
 		return;
 
-	folio_get(folio);
-	if (!folio_test_clear_lru(folio)) {
-		folio_put(folio);
-		return;
-	}
-
-	local_lock(&cpu_fbatches.lock);
-	fbatch = this_cpu_ptr(&cpu_fbatches.lru_activate);
-	folio_batch_add_and_move(fbatch, folio, lru_activate);
-	local_unlock(&cpu_fbatches.lock);
+	folio_batch_add_and_move(folio, lru_activate, true);
 }
 
 #else
@@ -513,8 +519,6 @@ EXPORT_SYMBOL(folio_mark_accessed);
  */
 void folio_add_lru(struct folio *folio)
 {
-	struct folio_batch *fbatch;
-
 	VM_BUG_ON_FOLIO(folio_test_active(folio) &&
 			folio_test_unevictable(folio), folio);
 	VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
@@ -524,11 +528,7 @@ void folio_add_lru(struct folio *folio)
 	    lru_gen_in_fault() && !(current->flags & PF_MEMALLOC))
 		folio_set_active(folio);
 
-	folio_get(folio);
-	local_lock(&cpu_fbatches.lock);
-	fbatch = this_cpu_ptr(&cpu_fbatches.lru_add);
-	folio_batch_add_and_move(fbatch, folio, lru_add);
-	local_unlock(&cpu_fbatches.lock);
+	folio_batch_add_and_move(folio, lru_add, false);
 }
 EXPORT_SYMBOL(folio_add_lru);
 
@@ -702,22 +702,11 @@ void lru_add_drain_cpu(int cpu)
  */
 void deactivate_file_folio(struct folio *folio)
 {
-	struct folio_batch *fbatch;
-
 	/* Deactivating an unevictable folio will not accelerate reclaim */
 	if (folio_test_unevictable(folio))
 		return;
 
-	folio_get(folio);
-	if (!folio_test_clear_lru(folio)) {
-		folio_put(folio);
-		return;
-	}
-
-	local_lock(&cpu_fbatches.lock);
-	fbatch = this_cpu_ptr(&cpu_fbatches.lru_deactivate_file);
-	folio_batch_add_and_move(fbatch, folio, lru_deactivate_file);
-	local_unlock(&cpu_fbatches.lock);
+	folio_batch_add_and_move(folio, lru_deactivate_file, true);
 }
 
 /*
@@ -730,21 +719,10 @@ void deactivate_file_folio(struct folio
  */
 void folio_deactivate(struct folio *folio)
 {
-	struct folio_batch *fbatch;
-
 	if (folio_test_unevictable(folio) || !(folio_test_active(folio) || lru_gen_enabled()))
 		return;
 
-	folio_get(folio);
-	if (!folio_test_clear_lru(folio)) {
-		folio_put(folio);
-		return;
-	}
-
-	local_lock(&cpu_fbatches.lock);
-	fbatch = this_cpu_ptr(&cpu_fbatches.lru_deactivate);
-	folio_batch_add_and_move(fbatch, folio, lru_deactivate);
-	local_unlock(&cpu_fbatches.lock);
+	folio_batch_add_and_move(folio, lru_deactivate, true);
 }
 
 /**
@@ -756,22 +734,11 @@ void folio_deactivate(struct folio *foli
  */
 void folio_mark_lazyfree(struct folio *folio)
 {
-	struct folio_batch *fbatch;
-
 	if (!folio_test_anon(folio) || !folio_test_swapbacked(folio) ||
 	    folio_test_swapcache(folio) || folio_test_unevictable(folio))
 		return;
 
-	folio_get(folio);
-	if (!folio_test_clear_lru(folio)) {
-		folio_put(folio);
-		return;
-	}
-
-	local_lock(&cpu_fbatches.lock);
-	fbatch = this_cpu_ptr(&cpu_fbatches.lru_lazyfree);
-	folio_batch_add_and_move(fbatch, folio, lru_lazyfree);
-	local_unlock(&cpu_fbatches.lock);
+	folio_batch_add_and_move(folio, lru_lazyfree, true);
 }
 
 void lru_add_drain(void)
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-hugetlb_vmemmap-dont-synchronize_rcu-without-hvo.patch
mm-swap-reduce-indentation-level.patch
mm-swap-rename-cpu_fbatches-activate.patch
mm-swap-fold-lru_rotate-into-cpu_fbatches.patch
mm-swap-remove-remaining-_fn-suffix.patch
mm-swap-remove-boilerplate.patch

