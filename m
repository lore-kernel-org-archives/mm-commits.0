Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE7F9C77B7A
	for <mm-commits@archiver.kernel.org>; Thu, 25 May 2023 19:33:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241255AbjEYTdm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 May 2023 15:33:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241003AbjEYTdl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 May 2023 15:33:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3260AE74
        for <mm-commits@vger.kernel.org>; Thu, 25 May 2023 12:33:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DFC9260B6C
        for <mm-commits@vger.kernel.org>; Thu, 25 May 2023 19:31:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45CFFC433D2;
        Thu, 25 May 2023 19:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685043101;
        bh=bC3w1N66LJNPK65LSfjYG8SQK19Aa+rC40nxfXBpKgs=;
        h=Date:To:From:Subject:From;
        b=Rssq/PzuJdK2IimvrDjXwAlpbW4oim/WAuoqpL3uqq8x84X93OyL5Yp2wHSz0LxdE
         GGw7s/3juD7UOOHET+2USzMevCiY2XzNmsUM129yf+S39sMSxgiG0cH33nIaryfDnj
         iMtF+KUV2tAEhxrCgHeoMhpatimueJbjYblevUfw=
Date:   Thu, 25 May 2023 12:31:40 -0700
To:     mm-commits@vger.kernel.org, urezki@gmail.com, lstoakes@gmail.com,
        hch@lst.de, bhe@redhat.com, tglx@linutronix.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-dont-purge-usable-blocks-unnecessarily.patch added to mm-unstable branch
Message-Id: <20230525193141.45CFFC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: dont purge usable blocks unnecessarily
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-dont-purge-usable-blocks-unnecessarily.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-dont-purge-usable-blocks-unnecessarily.patch

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
Subject: mm/vmalloc: dont purge usable blocks unnecessarily
Date: Thu, 25 May 2023 14:57:09 +0200 (CEST)

Purging fragmented blocks is done unconditionally in several contexts:

  1) From drain_vmap_area_work(), when the number of lazy to be freed
     vmap_areas reached the threshold

  2) Reclaiming vmalloc address space from pcpu_get_vm_areas()

  3) _vm_unmap_aliases()

#1 There is no reason to zap fragmented vmap blocks unconditionally, simply
   because reclaiming all lazy areas drains at least

      32MB * fls(num_online_cpus())

   per invocation which is plenty.

#2 Reclaiming when running out of space or due to memory pressure makes a
   lot of sense

#3 _unmap_aliases() requires to touch everything because the caller has no
   clue which vmap_area used a particular page last and the vmap_area lost
   that information too.

   Except for the vfree + VM_FLUSH_RESET_PERMS case, which removes the
   vmap area first and then cares about the flush. That in turn requires
   a full walk of _all_ vmap areas including the one which was just
   added to the purge list.

   But as this has to be flushed anyway this is an opportunity to combine
   outstanding TLB flushes and do the housekeeping of purging freed areas,
   but like #1 there is no real good reason to zap usable vmap blocks
   unconditionally.

Add a @force_purge argument to the newly split out block purge function and
if not true only purge fragmented blocks which have less than 1/4 of their
capacity left.

Rename purge_vmap_area_lazy() to reclaim_and_purge_vmap_areas() to make it
clear what the function does.

Link: https://lkml.kernel.org/r/20230525124504.864005691@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Baoquan He <bhe@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-dont-purge-usable-blocks-unnecessarily
+++ a/mm/vmalloc.c
@@ -791,7 +791,7 @@ get_subtree_max_size(struct rb_node *nod
 RB_DECLARE_CALLBACKS_MAX(static, free_vmap_area_rb_augment_cb,
 	struct vmap_area, rb_node, unsigned long, subtree_max_size, va_size)
 
-static void purge_vmap_area_lazy(void);
+static void reclaim_and_purge_vmap_areas(void);
 static BLOCKING_NOTIFIER_HEAD(vmap_notify_list);
 static void drain_vmap_area_work(struct work_struct *work);
 static DECLARE_WORK(drain_vmap_work, drain_vmap_area_work);
@@ -1649,7 +1649,7 @@ retry:
 
 overflow:
 	if (!purged) {
-		purge_vmap_area_lazy();
+		reclaim_and_purge_vmap_areas();
 		purged = 1;
 		goto retry;
 	}
@@ -1785,9 +1785,10 @@ out:
 }
 
 /*
- * Kick off a purge of the outstanding lazy areas.
+ * Reclaim vmap areas by purging fragmented blocks and purge_vmap_area_list.
  */
-static void purge_vmap_area_lazy(void)
+static void reclaim_and_purge_vmap_areas(void)
+
 {
 	mutex_lock(&vmap_purge_lock);
 	purge_fragmented_blocks_allcpus();
@@ -1908,6 +1909,12 @@ static struct vmap_area *find_unlink_vma
 
 #define VMAP_BLOCK_SIZE		(VMAP_BBMAP_BITS * PAGE_SIZE)
 
+/*
+ * Purge threshold to prevent overeager purging of fragmented blocks for
+ * regular operations: Purge if vb->free is less than 1/4 of the capacity.
+ */
+#define VMAP_PURGE_THRESHOLD	(VMAP_BBMAP_BITS / 4)
+
 #define VMAP_RAM		0x1 /* indicates vm_map_ram area*/
 #define VMAP_BLOCK		0x2 /* mark out the vmap_block sub-type*/
 #define VMAP_FLAGS_MASK		0x3
@@ -2087,12 +2094,17 @@ static void free_vmap_block(struct vmap_
 }
 
 static bool purge_fragmented_block(struct vmap_block *vb,
-		struct vmap_block_queue *vbq, struct list_head *purge_list)
+		struct vmap_block_queue *vbq, struct list_head *purge_list,
+		bool force_purge)
 {
 	if (vb->free + vb->dirty != VMAP_BBMAP_BITS ||
 	    vb->dirty == VMAP_BBMAP_BITS)
 		return false;
 
+	/* Don't overeagerly purge usable blocks unless requested */
+	if (!force_purge && vb->free < VMAP_PURGE_THRESHOLD)
+		return false;
+
 	/* prevent further allocs after releasing lock */
 	WRITE_ONCE(vb->free, 0);
 	/* prevent purging it again */
@@ -2132,7 +2144,7 @@ static void purge_fragmented_blocks(int
 			continue;
 
 		spin_lock(&vb->lock);
-		purge_fragmented_block(vb, vbq, &purge);
+		purge_fragmented_block(vb, vbq, &purge, true);
 		spin_unlock(&vb->lock);
 	}
 	rcu_read_unlock();
@@ -2269,7 +2281,7 @@ static void _vm_unmap_aliases(unsigned l
 			 * not purgeable, check whether there is dirty
 			 * space to be flushed.
 			 */
-			if (!purge_fragmented_block(vb, vbq, &purge_list) &&
+			if (!purge_fragmented_block(vb, vbq, &purge_list, false) &&
 			    vb->dirty_max && vb->dirty != VMAP_BBMAP_BITS) {
 				unsigned long va_start = vb->va->va_start;
 				unsigned long s, e;
@@ -4175,7 +4187,7 @@ recovery:
 overflow:
 	spin_unlock(&free_vmap_area_lock);
 	if (!purged) {
-		purge_vmap_area_lazy();
+		reclaim_and_purge_vmap_areas();
 		purged = true;
 
 		/* Before "retry", check if we recover. */
_

Patches currently in -mm which might be from tglx@linutronix.de are

mm-vmalloc-prevent-stale-tlbs-in-fully-utilized-blocks.patch
mm-vmalloc-avoid-iterating-over-per-cpu-vmap-blocks-twice.patch
mm-vmalloc-prevent-flushing-dirty-space-over-and-over.patch
mm-vmalloc-check-free-space-in-vmap_block-lockless.patch
mm-vmalloc-add-missing-read-write_once-annotations.patch
mm-vmalloc-dont-purge-usable-blocks-unnecessarily.patch

