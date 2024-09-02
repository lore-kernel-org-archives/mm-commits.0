Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5A502D613
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247680; cv=none; b=rd2+iMyQDZA8QCKc6KE1NDWMI2//BYFZOANhcJYfK9R4ZMKubYOclcLxd7ZvA0Rl916nHImG118TUBNF0Ai7v9zPkBqhjEdZkbMlaiJpSRcAH8dw0YrEcoNHe9AXUeS1GECrKcvXKV7Mzui/RMctZkciBdc5MvtqFTTRlPjFupc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247680; c=relaxed/simple;
	bh=g3kS9qausfqBM2xqLJzDE8y31fGlmvDb9ikmM4hw+oo=;
	h=Date:To:From:Subject:Message-Id; b=XevUUe38wy7juNT9BgNcnK7Ycd1ibSL9yPKqF+tb5h9YmzL4hXpn6zFUtM0g4Xi1KW5sim1G1saZccMkAz4zPcPUIOIbjR+U0jX9HulDews3Su6+b3OIq/cclM0ZUOfzybRXU8PDrCj4t7WoU41oMQz5xE2N4rwfHTCWiWtYu9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Kjok2LCw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Kjok2LCw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CCF4C4CEC2;
	Mon,  2 Sep 2024 03:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247680;
	bh=g3kS9qausfqBM2xqLJzDE8y31fGlmvDb9ikmM4hw+oo=;
	h=Date:To:From:Subject:From;
	b=Kjok2LCwdZg3vXVrt4o1R4EWxGYNoqZOU3+IysIAK2D5h+q+NolaZMGrpJVvLi6v6
	 w4LeX7mi+2dSdIS815vpz4e4KQhbK/JtMR+O/nOjKxE4SV5Z1OfJTE+1ShEjOHz9aw
	 XmpJNPtSijfpZ6EjiqQed+j8+xuRoFkCHJe1aEA4=
Date: Sun, 01 Sep 2024 20:28:00 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-remove-remaining-_fn-suffix.patch removed from -mm tree
Message-Id: <20240902032800.8CCF4C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/swap: remove remaining _fn suffix
has been removed from the -mm tree.  Its filename was
     mm-swap-remove-remaining-_fn-suffix.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yu Zhao <yuzhao@google.com>
Subject: mm/swap: remove remaining _fn suffix
Date: Wed, 10 Jul 2024 20:13:16 -0600

Remove remaining _fn suffix from cpu_fbatches handlers, which are already
self-explanatory.

Link: https://lkml.kernel.org/r/20240711021317.596178-5-yuzhao@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

--- a/mm/swap.c~mm-swap-remove-remaining-_fn-suffix
+++ a/mm/swap.c
@@ -160,7 +160,7 @@ EXPORT_SYMBOL(put_pages_list);
 
 typedef void (*move_fn_t)(struct lruvec *lruvec, struct folio *folio);
 
-static void lru_add_fn(struct lruvec *lruvec, struct folio *folio)
+static void lru_add(struct lruvec *lruvec, struct folio *folio)
 {
 	int was_unevictable = folio_test_clear_unevictable(folio);
 	long nr_pages = folio_nr_pages(folio);
@@ -230,7 +230,7 @@ static void folio_batch_add_and_move(str
 	folio_batch_move_lru(fbatch, move_fn);
 }
 
-static void lru_move_tail_fn(struct lruvec *lruvec, struct folio *folio)
+static void lru_move_tail(struct lruvec *lruvec, struct folio *folio)
 {
 	if (folio_test_unevictable(folio))
 		return;
@@ -265,7 +265,7 @@ void folio_rotate_reclaimable(struct fol
 
 	local_lock_irqsave(&cpu_fbatches.lock_irq, flags);
 	fbatch = this_cpu_ptr(&cpu_fbatches.lru_move_tail);
-	folio_batch_add_and_move(fbatch, folio, lru_move_tail_fn);
+	folio_batch_add_and_move(fbatch, folio, lru_move_tail);
 	local_unlock_irqrestore(&cpu_fbatches.lock_irq, flags);
 }
 
@@ -527,7 +527,7 @@ void folio_add_lru(struct folio *folio)
 	folio_get(folio);
 	local_lock(&cpu_fbatches.lock);
 	fbatch = this_cpu_ptr(&cpu_fbatches.lru_add);
-	folio_batch_add_and_move(fbatch, folio, lru_add_fn);
+	folio_batch_add_and_move(fbatch, folio, lru_add);
 	local_unlock(&cpu_fbatches.lock);
 }
 EXPORT_SYMBOL(folio_add_lru);
@@ -571,7 +571,7 @@ void folio_add_lru_vma(struct folio *fol
  * written out by flusher threads as this is much more efficient
  * than the single-page writeout from reclaim.
  */
-static void lru_deactivate_file_fn(struct lruvec *lruvec, struct folio *folio)
+static void lru_deactivate_file(struct lruvec *lruvec, struct folio *folio)
 {
 	bool active = folio_test_active(folio);
 	long nr_pages = folio_nr_pages(folio);
@@ -612,7 +612,7 @@ static void lru_deactivate_file_fn(struc
 	}
 }
 
-static void lru_deactivate_fn(struct lruvec *lruvec, struct folio *folio)
+static void lru_deactivate(struct lruvec *lruvec, struct folio *folio)
 {
 	long nr_pages = folio_nr_pages(folio);
 
@@ -628,7 +628,7 @@ static void lru_deactivate_fn(struct lru
 	__count_memcg_events(lruvec_memcg(lruvec), PGDEACTIVATE, nr_pages);
 }
 
-static void lru_lazyfree_fn(struct lruvec *lruvec, struct folio *folio)
+static void lru_lazyfree(struct lruvec *lruvec, struct folio *folio)
 {
 	long nr_pages = folio_nr_pages(folio);
 
@@ -662,7 +662,7 @@ void lru_add_drain_cpu(int cpu)
 	struct folio_batch *fbatch = &fbatches->lru_add;
 
 	if (folio_batch_count(fbatch))
-		folio_batch_move_lru(fbatch, lru_add_fn);
+		folio_batch_move_lru(fbatch, lru_add);
 
 	fbatch = &fbatches->lru_move_tail;
 	/* Disabling interrupts below acts as a compiler barrier. */
@@ -671,21 +671,21 @@ void lru_add_drain_cpu(int cpu)
 
 		/* No harm done if a racing interrupt already did this */
 		local_lock_irqsave(&cpu_fbatches.lock_irq, flags);
-		folio_batch_move_lru(fbatch, lru_move_tail_fn);
+		folio_batch_move_lru(fbatch, lru_move_tail);
 		local_unlock_irqrestore(&cpu_fbatches.lock_irq, flags);
 	}
 
 	fbatch = &fbatches->lru_deactivate_file;
 	if (folio_batch_count(fbatch))
-		folio_batch_move_lru(fbatch, lru_deactivate_file_fn);
+		folio_batch_move_lru(fbatch, lru_deactivate_file);
 
 	fbatch = &fbatches->lru_deactivate;
 	if (folio_batch_count(fbatch))
-		folio_batch_move_lru(fbatch, lru_deactivate_fn);
+		folio_batch_move_lru(fbatch, lru_deactivate);
 
 	fbatch = &fbatches->lru_lazyfree;
 	if (folio_batch_count(fbatch))
-		folio_batch_move_lru(fbatch, lru_lazyfree_fn);
+		folio_batch_move_lru(fbatch, lru_lazyfree);
 
 	folio_activate_drain(cpu);
 }
@@ -716,7 +716,7 @@ void deactivate_file_folio(struct folio
 
 	local_lock(&cpu_fbatches.lock);
 	fbatch = this_cpu_ptr(&cpu_fbatches.lru_deactivate_file);
-	folio_batch_add_and_move(fbatch, folio, lru_deactivate_file_fn);
+	folio_batch_add_and_move(fbatch, folio, lru_deactivate_file);
 	local_unlock(&cpu_fbatches.lock);
 }
 
@@ -743,7 +743,7 @@ void folio_deactivate(struct folio *foli
 
 	local_lock(&cpu_fbatches.lock);
 	fbatch = this_cpu_ptr(&cpu_fbatches.lru_deactivate);
-	folio_batch_add_and_move(fbatch, folio, lru_deactivate_fn);
+	folio_batch_add_and_move(fbatch, folio, lru_deactivate);
 	local_unlock(&cpu_fbatches.lock);
 }
 
@@ -770,7 +770,7 @@ void folio_mark_lazyfree(struct folio *f
 
 	local_lock(&cpu_fbatches.lock);
 	fbatch = this_cpu_ptr(&cpu_fbatches.lru_lazyfree);
-	folio_batch_add_and_move(fbatch, folio, lru_lazyfree_fn);
+	folio_batch_add_and_move(fbatch, folio, lru_lazyfree);
 	local_unlock(&cpu_fbatches.lock);
 }
 
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-contig_alloc-support-__gfp_comp.patch
mm-cma-add-cma_allocfree_folio.patch
mm-cma-add-cma_allocfree_folio-fix.patch
mm-hugetlb-use-__gfp_comp-for-gigantic-folios.patch
mm-free-zapped-tail-pages-when-splitting-isolated-thp.patch
mm-remap-unused-subpages-to-shared-zeropage-when-splitting-isolated-thp.patch

