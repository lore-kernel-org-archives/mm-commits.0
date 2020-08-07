Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6F69C433DF
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:24:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97C99221E5
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781448;
	bh=j60hILS+04q1X42aFjjEsmWXOjtlkE+HTO7X96Y6vtE=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=vBAk+oGmEjWWxtbaQo/hEQGsjVz2LhDdpiR5jJ6zHlooSxe0PSdkQdBL/jL3PPXVK
	 s86Y/k3Pa9WPzwCCJlN3BMLbk1U89lEUnY7BBf9Uf/kE8Ekgo6yGv3PrhlijcMjlUg
	 PZTGVV2Ag4MgCo/02hJgkwoAJlFOFTlEYnpUVvVU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726149AbgHGGYI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:24:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:33084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725893AbgHGGYH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:24:07 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3FBAF22C9F;
        Fri,  7 Aug 2020 06:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781446;
        bh=j60hILS+04q1X42aFjjEsmWXOjtlkE+HTO7X96Y6vtE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ceD+U38X51DHvCQCAg9NMfyAwn2XQBiAfrbG/Lv2/kcUuIuXXQGZW+U5d+08ClH6Q
         l9qvBMatxf5txBXEiQJQ1meQ0ItnuBXGX+S6PcaTBAgFPHH6kFYs3aRH5gZUb/B70r
         oVwGyZ4kgrATsWEtTNqCZ38AnRD+NcCR/fLDHLrc=
Date:   Thu, 06 Aug 2020 23:24:05 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        william.kucharski@oracle.com, willy@infradead.org
Subject:  [patch 121/163] vmalloc: convert to XArray
Message-ID: <20200807062405.J29JzBXLB%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
