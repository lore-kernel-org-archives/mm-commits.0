Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADCAE41C92
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247679; cv=none; b=IHoTcfUluhlM9lhg/tqZnIcnlgRFoQvpGk9zxJ1J2/TltXuhScpoPZ9qT7jdHGEDImZdoLpE5YKiRIhWjvabzSS/Qv/WyuaKzfnTodHyHgIKVXbE7VDRI60gsHiwunr+Dcx4e195/mCLKpYht/UlkI6j97qGAA7srAOwCUMK5g4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247679; c=relaxed/simple;
	bh=X3hfX+6nAAsXTo3CTq/s4sVlZTrWFOORiJvZgaupyk0=;
	h=Date:To:From:Subject:Message-Id; b=uXqn/XlvYD0fDB/eVLAy9UggZtjWXDlnmE4JUbMgBfxKlrcDQ8+UM9W1tO3apkWOB7mRn0CZAS0qPz93L7c4G8ik4E3BjGln9SmxFl7BMOKEOmccfDqJEZxDgSOueWPBX1h/bs/Aakk+rqYjPLraXLA1EtH7RFV4nAo/XlP6wig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DDOf8Mul; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DDOf8Mul"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83A60C4CEC2;
	Mon,  2 Sep 2024 03:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247679;
	bh=X3hfX+6nAAsXTo3CTq/s4sVlZTrWFOORiJvZgaupyk0=;
	h=Date:To:From:Subject:From;
	b=DDOf8MulBZyNyUvX2ND7tlqbrwy/kaZrTDnHJJRoZ98/M1SxNxKyRZe1Mfc2cGr6L
	 YTnbAThoQBqc6K3/FBD0fgEtJvhpXKXeSirDnC9s22YSFIAT51n5YBsj92OpgP44T7
	 kg9n+BoWXcyu2EIzknhEj6ra9WY7zhqx/4z5GqHA=
Date: Sun, 01 Sep 2024 20:27:59 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-fold-lru_rotate-into-cpu_fbatches.patch removed from -mm tree
Message-Id: <20240902032759.83A60C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/swap: fold lru_rotate into cpu_fbatches
has been removed from the -mm tree.  Its filename was
     mm-swap-fold-lru_rotate-into-cpu_fbatches.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yu Zhao <yuzhao@google.com>
Subject: mm/swap: fold lru_rotate into cpu_fbatches
Date: Wed, 10 Jul 2024 20:13:15 -0600

Fold lru_rotate into cpu_fbatches, and rename the folio_batch and the lock
protecting it to lru_move_tail and lock_irq respectively so that all the
boilerplate can be removed at the end of this series.

Also remove data_race() around folio_batch_count(), which is out of place:
all folio_batch_count() calls on remote cpu_fbatches are subject to
data_race(), and therefore data_race() should be inside
folio_batch_count().

Link: https://lkml.kernel.org/r/20240711021317.596178-4-yuzhao@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |   36 ++++++++++++++++--------------------
 1 file changed, 16 insertions(+), 20 deletions(-)

--- a/mm/swap.c~mm-swap-fold-lru_rotate-into-cpu_fbatches
+++ a/mm/swap.c
@@ -47,20 +47,11 @@
 int page_cluster;
 const int page_cluster_max = 31;
 
-/* Protecting only lru_rotate.fbatch which requires disabling interrupts */
-struct lru_rotate {
-	local_lock_t lock;
-	struct folio_batch fbatch;
-};
-static DEFINE_PER_CPU(struct lru_rotate, lru_rotate) = {
-	.lock = INIT_LOCAL_LOCK(lock),
-};
-
-/*
- * The following folio batches are grouped together because they are protected
- * by disabling preemption (and interrupts remain enabled).
- */
 struct cpu_fbatches {
+	/*
+	 * The following folio batches are grouped together because they are protected
+	 * by disabling preemption (and interrupts remain enabled).
+	 */
 	local_lock_t lock;
 	struct folio_batch lru_add;
 	struct folio_batch lru_deactivate_file;
@@ -69,9 +60,14 @@ struct cpu_fbatches {
 #ifdef CONFIG_SMP
 	struct folio_batch lru_activate;
 #endif
+	/* Protecting the following batches which require disabling interrupts */
+	local_lock_t lock_irq;
+	struct folio_batch lru_move_tail;
 };
+
 static DEFINE_PER_CPU(struct cpu_fbatches, cpu_fbatches) = {
 	.lock = INIT_LOCAL_LOCK(lock),
+	.lock_irq = INIT_LOCAL_LOCK(lock_irq),
 };
 
 static void __page_cache_release(struct folio *folio, struct lruvec **lruvecp,
@@ -267,10 +263,10 @@ void folio_rotate_reclaimable(struct fol
 		return;
 	}
 
-	local_lock_irqsave(&lru_rotate.lock, flags);
-	fbatch = this_cpu_ptr(&lru_rotate.fbatch);
+	local_lock_irqsave(&cpu_fbatches.lock_irq, flags);
+	fbatch = this_cpu_ptr(&cpu_fbatches.lru_move_tail);
 	folio_batch_add_and_move(fbatch, folio, lru_move_tail_fn);
-	local_unlock_irqrestore(&lru_rotate.lock, flags);
+	local_unlock_irqrestore(&cpu_fbatches.lock_irq, flags);
 }
 
 void lru_note_cost(struct lruvec *lruvec, bool file,
@@ -668,15 +664,15 @@ void lru_add_drain_cpu(int cpu)
 	if (folio_batch_count(fbatch))
 		folio_batch_move_lru(fbatch, lru_add_fn);
 
-	fbatch = &per_cpu(lru_rotate.fbatch, cpu);
+	fbatch = &fbatches->lru_move_tail;
 	/* Disabling interrupts below acts as a compiler barrier. */
 	if (data_race(folio_batch_count(fbatch))) {
 		unsigned long flags;
 
 		/* No harm done if a racing interrupt already did this */
-		local_lock_irqsave(&lru_rotate.lock, flags);
+		local_lock_irqsave(&cpu_fbatches.lock_irq, flags);
 		folio_batch_move_lru(fbatch, lru_move_tail_fn);
-		local_unlock_irqrestore(&lru_rotate.lock, flags);
+		local_unlock_irqrestore(&cpu_fbatches.lock_irq, flags);
 	}
 
 	fbatch = &fbatches->lru_deactivate_file;
@@ -825,7 +821,7 @@ static bool cpu_needs_drain(unsigned int
 
 	/* Check these in order of likelihood that they're not zero */
 	return folio_batch_count(&fbatches->lru_add) ||
-		data_race(folio_batch_count(&per_cpu(lru_rotate.fbatch, cpu))) ||
+		folio_batch_count(&fbatches->lru_move_tail) ||
 		folio_batch_count(&fbatches->lru_deactivate_file) ||
 		folio_batch_count(&fbatches->lru_deactivate) ||
 		folio_batch_count(&fbatches->lru_lazyfree) ||
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-contig_alloc-support-__gfp_comp.patch
mm-cma-add-cma_allocfree_folio.patch
mm-cma-add-cma_allocfree_folio-fix.patch
mm-hugetlb-use-__gfp_comp-for-gigantic-folios.patch
mm-free-zapped-tail-pages-when-splitting-isolated-thp.patch
mm-remap-unused-subpages-to-shared-zeropage-when-splitting-isolated-thp.patch

