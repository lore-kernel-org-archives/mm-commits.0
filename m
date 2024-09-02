Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B3443155
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247681; cv=none; b=PrrH2nz2FyYL95EnG6QJCZm/QbMJxSlV4rRk2abdiarTxyOWL0xCCt+k9EpCpFOFD5itt4HYOz4+4YRhUbrKttVRq9QJkucv6yfGzVXRqQNor+K2de9IyUHkJKAPS0vPN4O8UfFgqMcyNwdCd2QeD39uxMREZB2ZQ2mS9apJwo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247681; c=relaxed/simple;
	bh=tuECogRW/9hPBgODGn6+Tfd2rdrCG/oqZi4JGWHjtvc=;
	h=Date:To:From:Subject:Message-Id; b=pO1kz9iMZG5n0v5F4XNIVMogDcuD+lIenAftkVChzxGcV8SBGaNNjjlopw1nldlY+C80FWpNN1M2ZBBV1g2QPJOmVIrqnLGL0kqH1RbMEL8aTw7pELMWZ9WKFbXA1c/rE59qBISiFqlRDdBbzsU37xlxxfgg/4S4BGkYFl0yUrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=y6IRNQO6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="y6IRNQO6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C702C4CEC2;
	Mon,  2 Sep 2024 03:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247681;
	bh=tuECogRW/9hPBgODGn6+Tfd2rdrCG/oqZi4JGWHjtvc=;
	h=Date:To:From:Subject:From;
	b=y6IRNQO6aR2AgKUkDhm4du6Yoa+eru0IX7Bqb+wO1hbvPZgrqIw0JvDOBKt1JPZ79
	 1PSnjbBNw3wtkvoVI+U1WUTRTd5Gj1LWm4spjIcg6ongYRcWxiSzJ3FCeJHHV8512q
	 VkYl2ZSUJVeRAcOddf4iaVHGB2zQUgrcvVsxLucU=
Date: Sun, 01 Sep 2024 20:28:01 -0700
To: mm-commits@vger.kernel.org,hughd@google.com,21cnbao@gmail.com,yuzhao@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-remove-boilerplate.patch removed from -mm tree
Message-Id: <20240902032801.9C702C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/swap: remove boilerplate
has been removed from the -mm tree.  Its filename was
     mm-swap-remove-boilerplate.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yu Zhao <yuzhao@google.com>
Subject: mm/swap: remove boilerplate
Date: Wed, 10 Jul 2024 20:13:17 -0600

Remove boilerplate by using a macro to choose the corresponding lock and
handler for each folio_batch in cpu_fbatches.

[yuzhao@google.com: handle zero-length local_lock_t]
  Link: https://lkml.kernel.org/r/Zq_0X04WsqgUnz30@google.com
[yuzhao@google.com: fix "BUG: using smp_processor_id() in preemptible"]
  Link: https://lkml.kernel.org/r/ZqNHHMiHn-9vy_II@google.com
Link: https://lkml.kernel.org/r/20240711021317.596178-6-yuzhao@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Tested-by: Hugh Dickins <hughd@google.com>
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
+		offsetof(struct cpu_fbatches, op) >= offsetof(struct cpu_fbatches, lock_irq)	\
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

mm-contig_alloc-support-__gfp_comp.patch
mm-cma-add-cma_allocfree_folio.patch
mm-cma-add-cma_allocfree_folio-fix.patch
mm-hugetlb-use-__gfp_comp-for-gigantic-folios.patch
mm-free-zapped-tail-pages-when-splitting-isolated-thp.patch
mm-remap-unused-subpages-to-shared-zeropage-when-splitting-isolated-thp.patch

