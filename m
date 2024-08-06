Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 049B8157487
	for <mm-commits@vger.kernel.org>; Tue,  6 Aug 2024 21:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722978473; cv=none; b=l5DOIzfbvu4YpvJM1yziFjNybxKrtOvK137CARNPAcjwcF9SG8HfDW2BgK96rsD3Az0pJjm7FdEvKOHkUEiF1gSPAFv0+MTbVdyoc+CtMXotGHlPKMNQsmueKVyaQ6cgMNbFYu96wNKlXD1I1Xsux0WuVI06cU+CpuTPnke2Drw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722978473; c=relaxed/simple;
	bh=cpPKmSWBJKSMqyTGf05PB2TEXDPfy1M8JiLnzM7rudo=;
	h=Date:To:From:Subject:Message-Id; b=qly5zNLIvPlu+/NKo/gIrg29C9gXfJizbKXwjF+J+67WhHsqYEey0QFYrvNZk4vBOL5tYK72IOv5m4EFv8AFg1VFXoaCivsiz2DeMyx5IIiuFtIQkSmpQ9y6awUeib4sBcRIWKTfrwgeWo1ejegkU2/Xkt9WW2sdfQUFf4mieHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Cidyb5DQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Cidyb5DQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88734C32786;
	Tue,  6 Aug 2024 21:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722978472;
	bh=cpPKmSWBJKSMqyTGf05PB2TEXDPfy1M8JiLnzM7rudo=;
	h=Date:To:From:Subject:From;
	b=Cidyb5DQGPLE7NlCfY8oNjMd1Qp8kiqv8t8u5P+T5153RyhSILur7aviMTQPAYfhx
	 oIDcaHz6HzwnYS21IX7P4A/ox+1mctfk7cpCyzrnqg0VahXZfrxeDAif1Q4+8GIqAT
	 Qorcudi1X4+qxjaFLeD6QpbXP4KrVmVotuPANO3g=
Date: Tue, 06 Aug 2024 14:07:52 -0700
To: mm-commits@vger.kernel.org,hughd@google.com,21cnbao@gmail.com,yuzhao@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-remove-boilerplate.patch added to mm-unstable branch
Message-Id: <20240806210752.88734C32786@smtp.kernel.org>
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

[yuzhao@google.com: fix "BUG: using smp_processor_id() in preemptible"]
  Link: https://lkml.kernel.org/r/ZqNHHMiHn-9vy_II@google.com
Link: https://lkml.kernel.org/r/20240711021317.596178-6-yuzhao@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Barry Song <21cnbao@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |  111 +++++++++++++++++-----------------------------------
 1 file changed, 38 insertions(+), 73 deletions(-)

--- a/mm/swap.c~mm-swap-remove-boilerplate
+++ a/mm/swap.c
@@ -220,16 +220,43 @@ static void folio_batch_move_lru(struct
 	folios_put(fbatch);
 }
 
-static void folio_batch_add_and_move(struct folio_batch *fbatch,
-		struct folio *folio, move_fn_t move_fn)
+static void __folio_batch_add_and_move(struct folio_batch __percpu *fbatch,
+		struct folio *folio, move_fn_t move_fn,
+		bool on_lru, bool disable_irq)
 {
-	if (folio_batch_add(fbatch, folio) && !folio_test_large(folio) &&
-	    !lru_cache_disabled())
+	unsigned long flags;
+
+	folio_get(folio);
+
+	if (on_lru && !folio_test_clear_lru(folio)) {
+		folio_put(folio);
 		return;
+	}
+
+	if (disable_irq)
+		local_lock_irqsave(&cpu_fbatches.lock_irq, flags);
+	else
+		local_lock(&cpu_fbatches.lock);
+
+	if (!folio_batch_add(this_cpu_ptr(fbatch), folio) || folio_test_large(folio) ||
+	    lru_cache_disabled())
+		folio_batch_move_lru(this_cpu_ptr(fbatch), move_fn);
 
-	folio_batch_move_lru(fbatch, move_fn);
+	if (disable_irq)
+		local_unlock_irqrestore(&cpu_fbatches.lock_irq, flags);
+	else
+		local_unlock(&cpu_fbatches.lock);
 }
 
+#define folio_batch_add_and_move(folio, op, on_lru)						\
+	__folio_batch_add_and_move(								\
+		&cpu_fbatches.op,								\
+		folio,										\
+		op,										\
+		on_lru,										\
+		offsetof(struct cpu_fbatches, op) > offsetof(struct cpu_fbatches, lock_irq)	\
+	)
+
 static void lru_move_tail(struct lruvec *lruvec, struct folio *folio)
 {
 	if (folio_test_unevictable(folio))
@@ -250,23 +277,11 @@ static void lru_move_tail(struct lruvec
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
@@ -355,21 +370,10 @@ static void folio_activate_drain(int cpu
 
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
@@ -513,8 +517,6 @@ EXPORT_SYMBOL(folio_mark_accessed);
  */
 void folio_add_lru(struct folio *folio)
 {
-	struct folio_batch *fbatch;
-
 	VM_BUG_ON_FOLIO(folio_test_active(folio) &&
 			folio_test_unevictable(folio), folio);
 	VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
@@ -524,11 +526,7 @@ void folio_add_lru(struct folio *folio)
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
 
@@ -702,22 +700,11 @@ void lru_add_drain_cpu(int cpu)
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
@@ -730,21 +717,10 @@ void deactivate_file_folio(struct folio
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
@@ -756,22 +732,11 @@ void folio_deactivate(struct folio *foli
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
mm-swap-remove-boilerplate-fix.patch

