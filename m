Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16815C7EE29
	for <mm-commits@archiver.kernel.org>; Thu, 25 May 2023 19:34:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240138AbjEYTd7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 May 2023 15:33:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241418AbjEYTd4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 May 2023 15:33:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67E92195
        for <mm-commits@vger.kernel.org>; Thu, 25 May 2023 12:33:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 44C606391F
        for <mm-commits@vger.kernel.org>; Thu, 25 May 2023 19:31:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B82BC433EF;
        Thu, 25 May 2023 19:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685043093;
        bh=ANjlCyVnx/BR5tlpGHRpzntB5uIN+qEJnBftP13c9XA=;
        h=Date:To:From:Subject:From;
        b=de8NkEgOr88uZ4oKnizM4spEer+Y99c7kOQ6Ca8am5QW0eHKZYlhm17jB0vY79Jte
         xlD1GeCTI0s9p1US3YLyjb0SDmdiNV2p4gbmgqgxb+wQ4pmfSSgOO5ds2AuxxtSezM
         YclMldB09n4lXI5Cnk5CSToHvw+0Pa2HdGPAW4sU=
Date:   Thu, 25 May 2023 12:31:32 -0700
To:     mm-commits@vger.kernel.org, urezki@gmail.com, lstoakes@gmail.com,
        hch@lst.de, bhe@redhat.com, tglx@linutronix.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-avoid-iterating-over-per-cpu-vmap-blocks-twice.patch added to mm-unstable branch
Message-Id: <20230525193133.9B82BC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: avoid iterating over per CPU vmap blocks twice
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-avoid-iterating-over-per-cpu-vmap-blocks-twice.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-avoid-iterating-over-per-cpu-vmap-blocks-twice.patch

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
Cc: Baoquan He <bhe@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
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

mm-vmalloc-prevent-stale-tlbs-in-fully-utilized-blocks.patch
mm-vmalloc-avoid-iterating-over-per-cpu-vmap-blocks-twice.patch
mm-vmalloc-prevent-flushing-dirty-space-over-and-over.patch
mm-vmalloc-check-free-space-in-vmap_block-lockless.patch
mm-vmalloc-add-missing-read-write_once-annotations.patch
mm-vmalloc-dont-purge-usable-blocks-unnecessarily.patch

