Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29045C433E0
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:38:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFB6A206C3
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597027131;
	bh=oFVcTonJLi77CC5eNXnHvQXf4Oo2+Pguj7vsytVjBnc=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=z51GOI5c1iWLNEt1LHb0cPMAIzokHxp2nKXQr6yA2cqaxkf+yRPQcrDMocePfn9Vj
	 9jaMy2VVxiw3os68KYnuCBg61WW8EU8Bs5nx8Cczl9oNeXPvHQSk5/EQkdHEseIUeI
	 eP/AsTHgNUKn/spRLmampHpqOTjM1X6rR6m9LaEc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbgHJCiu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:38:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:42102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726426AbgHJCiu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:38:50 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 748422065D;
        Mon, 10 Aug 2020 02:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597027129;
        bh=oFVcTonJLi77CC5eNXnHvQXf4Oo2+Pguj7vsytVjBnc=;
        h=Date:From:To:Subject:From;
        b=aOI2nvHz9SqH1IpnRhOIn091x8IwyYS8i8fn0QmDD5WyXpvw0PKxc0HJDx960y+C3
         wgCjEBXak+ZS5R9XXLAadGSX94Aw914LODWR1sBY4hkzBovLDdGoqhL42a4ejgcJSN
         VV3Cg9D/PcH/ArGtL6FWtMndMEkR34xwwhWBk8Ho=
Date:   Sun, 09 Aug 2020 19:38:49 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, william.kucharski@oracle.com,
        willy@infradead.org
Subject:  [merged] vmalloc-convert-to-xarray.patch removed from -mm
 tree
Message-ID: <20200810023849.mdb5o83qB%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: vmalloc: convert to XArray
has been removed from the -mm tree.  Its filename was
     vmalloc-convert-to-xarray.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: vmalloc: convert to XArray

The radix tree of vmap blocks is simpler to express as an XArray.  Reduces
both the text and data sizes of the object file and eliminates a user of
the radix tree preload API.

Link: http://lkml.kernel.org/r/20200603171448.5894-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   40 +++++++++++-----------------------------
 1 file changed, 11 insertions(+), 29 deletions(-)

--- a/mm/vmalloc.c~vmalloc-convert-to-xarray
+++ a/mm/vmalloc.c
@@ -25,7 +25,7 @@
 #include <linux/list.h>
 #include <linux/notifier.h>
 #include <linux/rbtree.h>
-#include <linux/radix-tree.h>
+#include <linux/xarray.h>
 #include <linux/rcupdate.h>
 #include <linux/pfn.h>
 #include <linux/kmemleak.h>
@@ -1514,12 +1514,11 @@ struct vmap_block {
 static DEFINE_PER_CPU(struct vmap_block_queue, vmap_block_queue);
 
 /*
- * Radix tree of vmap blocks, indexed by address, to quickly find a vmap block
+ * XArray of vmap blocks, indexed by address, to quickly find a vmap block
  * in the free path. Could get rid of this if we change the API to return a
  * "cookie" from alloc, to be passed to free. But no big deal yet.
  */
-static DEFINE_SPINLOCK(vmap_block_tree_lock);
-static RADIX_TREE(vmap_block_tree, GFP_ATOMIC);
+static DEFINE_XARRAY(vmap_blocks);
 
 /*
  * We should probably have a fallback mechanism to allocate virtual memory
@@ -1576,13 +1575,6 @@ static void *new_vmap_block(unsigned int
 		return ERR_CAST(va);
 	}
 
-	err = radix_tree_preload(gfp_mask);
-	if (unlikely(err)) {
-		kfree(vb);
-		free_vmap_area(va);
-		return ERR_PTR(err);
-	}
-
 	vaddr = vmap_block_vaddr(va->va_start, 0);
 	spin_lock_init(&vb->lock);
 	vb->va = va;
@@ -1595,11 +1587,12 @@ static void *new_vmap_block(unsigned int
 	INIT_LIST_HEAD(&vb->free_list);
 
 	vb_idx = addr_to_vb_idx(va->va_start);
-	spin_lock(&vmap_block_tree_lock);
-	err = radix_tree_insert(&vmap_block_tree, vb_idx, vb);
-	spin_unlock(&vmap_block_tree_lock);
-	BUG_ON(err);
-	radix_tree_preload_end();
+	err = xa_insert(&vmap_blocks, vb_idx, vb, gfp_mask);
+	if (err) {
+		kfree(vb);
+		free_vmap_area(va);
+		return ERR_PTR(err);
+	}
 
 	vbq = &get_cpu_var(vmap_block_queue);
 	spin_lock(&vbq->lock);
@@ -1613,12 +1606,8 @@ static void *new_vmap_block(unsigned int
 static void free_vmap_block(struct vmap_block *vb)
 {
 	struct vmap_block *tmp;
-	unsigned long vb_idx;
 
-	vb_idx = addr_to_vb_idx(vb->va->va_start);
-	spin_lock(&vmap_block_tree_lock);
-	tmp = radix_tree_delete(&vmap_block_tree, vb_idx);
-	spin_unlock(&vmap_block_tree_lock);
+	tmp = xa_erase(&vmap_blocks, addr_to_vb_idx(vb->va->va_start));
 	BUG_ON(tmp != vb);
 
 	free_vmap_area_noflush(vb->va);
@@ -1724,7 +1713,6 @@ static void *vb_alloc(unsigned long size
 static void vb_free(unsigned long addr, unsigned long size)
 {
 	unsigned long offset;
-	unsigned long vb_idx;
 	unsigned int order;
 	struct vmap_block *vb;
 
@@ -1734,14 +1722,8 @@ static void vb_free(unsigned long addr,
 	flush_cache_vunmap(addr, addr + size);
 
 	order = get_order(size);
-
 	offset = (addr & (VMAP_BLOCK_SIZE - 1)) >> PAGE_SHIFT;
-
-	vb_idx = addr_to_vb_idx(addr);
-	rcu_read_lock();
-	vb = radix_tree_lookup(&vmap_block_tree, vb_idx);
-	rcu_read_unlock();
-	BUG_ON(!vb);
+	vb = xa_load(&vmap_blocks, addr_to_vb_idx(addr));
 
 	unmap_kernel_range_noflush(addr, size);
 
_

Patches currently in -mm which might be from willy@infradead.org are

mm-store-compound_nr-as-well-as-compound_order.patch
mm-move-page-flags-include-to-top-of-file.patch
mm-add-thp_order.patch
mm-add-thp_size.patch
mm-replace-hpage_nr_pages-with-thp_nr_pages.patch
mm-add-thp_head.patch
mm-introduce-offset_in_thp.patch
poison-remove-obsolete-comment.patch

