Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35DECC7EE25
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:32:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233027AbjFIXcU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:32:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232688AbjFIXb2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:31:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E15D63C23
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:29:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7EB5E65CF2
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:29:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D77C6C433EF;
        Fri,  9 Jun 2023 23:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353352;
        bh=A+QXzgM+S+UR2vlqsL08aul87GcGIrEyfsCaenlKM3M=;
        h=Date:To:From:Subject:From;
        b=19gYglJH7/+L0XV3iv3CcwP1O3irLF22lDmsCtIZXcGdVAJai8Am7OLdelHb+o40R
         nT3fNxHFPtdiC0VtCO7g4GxJk9aTbXxDYyeVz6x3JcbmofemZl9xklWBEdLHOubMYj
         4bK+Y24w0HaOW4iBuGevr/FGT9nX86Qui51h6+So=
Date:   Fri, 09 Jun 2023 16:29:12 -0700
To:     mm-commits@vger.kernel.org, urezki@gmail.com, lstoakes@gmail.com,
        hch@lst.de, bhe@redhat.com, tglx@linutronix.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-avoid-iterating-over-per-cpu-vmap-blocks-twice.patch removed from -mm tree
Message-Id: <20230609232912.D77C6C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/vmalloc: avoid iterating over per CPU vmap blocks twice
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-avoid-iterating-over-per-cpu-vmap-blocks-twice.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Thomas Gleixner <tglx@linutronix.de>
Subject: mm/vmalloc: avoid iterating over per CPU vmap blocks twice
Date: Thu, 25 May 2023 14:57:04 +0200 (CEST)

_vunmap_aliases() walks the per CPU xarrays to find partially unmapped
blocks and then walks the per cpu free lists to purge fragmented blocks.

Arguably that's waste of CPU cycles and cache lines as the full xarray
walk already touches every block.

Avoid this double iteration:

  - Split out the code to purge one block and the code to free the local
    purge list into helper functions.

  - Try to purge the fragmented blocks in the xarray walk before looking at
    their dirty space.

Link: https://lkml.kernel.org/r/20230525124504.633469722@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   70 ++++++++++++++++++++++++++++++++-----------------
 1 file changed, 46 insertions(+), 24 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-avoid-iterating-over-per-cpu-vmap-blocks-twice
+++ a/mm/vmalloc.c
@@ -2086,39 +2086,54 @@ static void free_vmap_block(struct vmap_
 	kfree_rcu(vb, rcu_head);
 }
 
+static bool purge_fragmented_block(struct vmap_block *vb,
+		struct vmap_block_queue *vbq, struct list_head *purge_list)
+{
+	if (vb->free + vb->dirty != VMAP_BBMAP_BITS ||
+	    vb->dirty == VMAP_BBMAP_BITS)
+		return false;
+
+	/* prevent further allocs after releasing lock */
+	vb->free = 0;
+	/* prevent purging it again */
+	vb->dirty = VMAP_BBMAP_BITS;
+	vb->dirty_min = 0;
+	vb->dirty_max = VMAP_BBMAP_BITS;
+	spin_lock(&vbq->lock);
+	list_del_rcu(&vb->free_list);
+	spin_unlock(&vbq->lock);
+	list_add_tail(&vb->purge, purge_list);
+	return true;
+}
+
+static void free_purged_blocks(struct list_head *purge_list)
+{
+	struct vmap_block *vb, *n_vb;
+
+	list_for_each_entry_safe(vb, n_vb, purge_list, purge) {
+		list_del(&vb->purge);
+		free_vmap_block(vb);
+	}
+}
+
 static void purge_fragmented_blocks(int cpu)
 {
 	LIST_HEAD(purge);
 	struct vmap_block *vb;
-	struct vmap_block *n_vb;
 	struct vmap_block_queue *vbq = &per_cpu(vmap_block_queue, cpu);
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(vb, &vbq->free, free_list) {
-
-		if (!(vb->free + vb->dirty == VMAP_BBMAP_BITS && vb->dirty != VMAP_BBMAP_BITS))
+		if (vb->free + vb->dirty != VMAP_BBMAP_BITS ||
+		    vb->dirty == VMAP_BBMAP_BITS)
 			continue;
 
 		spin_lock(&vb->lock);
-		if (vb->free + vb->dirty == VMAP_BBMAP_BITS && vb->dirty != VMAP_BBMAP_BITS) {
-			vb->free = 0; /* prevent further allocs after releasing lock */
-			vb->dirty = VMAP_BBMAP_BITS; /* prevent purging it again */
-			vb->dirty_min = 0;
-			vb->dirty_max = VMAP_BBMAP_BITS;
-			spin_lock(&vbq->lock);
-			list_del_rcu(&vb->free_list);
-			spin_unlock(&vbq->lock);
-			spin_unlock(&vb->lock);
-			list_add_tail(&vb->purge, &purge);
-		} else
-			spin_unlock(&vb->lock);
+		purge_fragmented_block(vb, vbq, &purge);
+		spin_unlock(&vb->lock);
 	}
 	rcu_read_unlock();
-
-	list_for_each_entry_safe(vb, n_vb, &purge, purge) {
-		list_del(&vb->purge);
-		free_vmap_block(vb);
-	}
+	free_purged_blocks(&purge);
 }
 
 static void purge_fragmented_blocks_allcpus(void)
@@ -2226,12 +2241,13 @@ static void vb_free(unsigned long addr,
 
 static void _vm_unmap_aliases(unsigned long start, unsigned long end, int flush)
 {
+	LIST_HEAD(purge_list);
 	int cpu;
 
 	if (unlikely(!vmap_initialized))
 		return;
 
-	might_sleep();
+	mutex_lock(&vmap_purge_lock);
 
 	for_each_possible_cpu(cpu) {
 		struct vmap_block_queue *vbq = &per_cpu(vmap_block_queue, cpu);
@@ -2241,7 +2257,14 @@ static void _vm_unmap_aliases(unsigned l
 		rcu_read_lock();
 		xa_for_each(&vbq->vmap_blocks, idx, vb) {
 			spin_lock(&vb->lock);
-			if (vb->dirty && vb->dirty != VMAP_BBMAP_BITS) {
+
+			/*
+			 * Try to purge a fragmented block first. If it's
+			 * not purgeable, check whether there is dirty
+			 * space to be flushed.
+			 */
+			if (!purge_fragmented_block(vb, vbq, &purge_list) &&
+			    vb->dirty && vb->dirty != VMAP_BBMAP_BITS) {
 				unsigned long va_start = vb->va->va_start;
 				unsigned long s, e;
 
@@ -2257,9 +2280,8 @@ static void _vm_unmap_aliases(unsigned l
 		}
 		rcu_read_unlock();
 	}
+	free_purged_blocks(&purge_list);
 
-	mutex_lock(&vmap_purge_lock);
-	purge_fragmented_blocks_allcpus();
 	if (!__purge_vmap_area_lazy(start, end) && flush)
 		flush_tlb_kernel_range(start, end);
 	mutex_unlock(&vmap_purge_lock);
_

Patches currently in -mm which might be from tglx@linutronix.de are


