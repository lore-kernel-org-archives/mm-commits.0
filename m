Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84F29C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 13 Jan 2022 20:45:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234586AbiAMUpA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 13 Jan 2022 15:45:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230515AbiAMUo5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jan 2022 15:44:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B79ABC061574
        for <mm-commits@vger.kernel.org>; Thu, 13 Jan 2022 12:44:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1A16C61024
        for <mm-commits@vger.kernel.org>; Thu, 13 Jan 2022 20:44:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55B03C36AEB;
        Thu, 13 Jan 2022 20:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642106696;
        bh=csUEr7/OVnALSNy+8iPCoF19T7vj9+R2LG94hQJZcPI=;
        h=Date:From:To:Subject:From;
        b=DmClRCMMhb2XdzP6vyYavl4H32D3IVNupimfG7CMT+R4NmqxSoQ+JtPFmIuWshCWB
         8MZqkHK3nWieClrBoyu1mEfwLdHVYHVpBPlU9f1FHmvlpcfg/hAqo6olF/i5CvkhBt
         dzH9d5pB0huDMnEdxfhsaxreE2IHWcqtexYbNV54=
Date:   Thu, 13 Jan 2022 12:44:55 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, npiggin@gmail.com,
        uladzislau.rezki@sony.com, xuyu@linux.alibaba.com
Subject:  [alternative-merged]
 mm-vmalloc-allocate-small-pages-for-area-pages.patch removed from -mm tree
Message-ID: <20220113204455.fTZkS_3Wq%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: allocate small pages for area->pages
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-allocate-small-pages-for-area-pages.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Xu Yu <xuyu@linux.alibaba.com>
Subject: mm/vmalloc: allocate small pages for area->pages

The area->pages stores the struct pages allocated for vmalloc mappings.
The allocated memory can be hugepage if arch has HAVE_ARCH_HUGE_VMALLOC
set, while area->pages itself does not have to be hugepage backed.

Suppose that we want to vmalloc 1026M of memory, then area->pages is
2052K in size, which is large than PMD_SIZE when the pagesize is 4K.
Currently, 4096K will be allocated for area->pages, wherein 2044K is
wasted.

This introduces __vmalloc_node_no_huge, and makes area->pages backed by
small pages, because I think to allocate hugepage for area->pages is
unnecessary and vulnerable to abuse.

[akpm@linux-foundation.org: tweak code layout]
Link: https://lkml.kernel.org/r/dd04f516643fde4206c1fe93818526a768125c75.1638870169.git.xuyu@linux.alibaba.com
Signed-off-by: Xu Yu <xuyu@linux.alibaba.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Uladzislau Rezki <uladzislau.rezki@sony.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmalloc.h |    2 ++
 mm/vmalloc.c            |   19 +++++++++++++++----
 2 files changed, 17 insertions(+), 4 deletions(-)

--- a/include/linux/vmalloc.h~mm-vmalloc-allocate-small-pages-for-area-pages
+++ a/include/linux/vmalloc.h
@@ -157,6 +157,8 @@ extern void *__vmalloc_node_range(unsign
 			const void *caller) __alloc_size(1);
 void *__vmalloc_node(unsigned long size, unsigned long align, gfp_t gfp_mask,
 		int node, const void *caller) __alloc_size(1);
+void *__vmalloc_node_no_huge(unsigned long size, unsigned long align,
+		gfp_t gfp_mask, int node, const void *caller) __alloc_size(1);
 void *vmalloc_no_huge(unsigned long size) __alloc_size(1);
 
 extern void vfree(const void *addr);
--- a/mm/vmalloc.c~mm-vmalloc-allocate-small-pages-for-area-pages
+++ a/mm/vmalloc.c
@@ -2930,20 +2930,23 @@ static void *__vmalloc_area_node(struct
 	unsigned long addr = (unsigned long)area->addr;
 	unsigned long size = get_vm_area_size(area);
 	unsigned long array_size;
-	unsigned int nr_small_pages = size >> PAGE_SHIFT;
+	unsigned int nr_small_pages, max_small_pages;
 	unsigned int page_order;
 	unsigned int flags;
 	int ret;
 
-	array_size = (unsigned long)nr_small_pages * sizeof(struct page *);
+	nr_small_pages = size >> PAGE_SHIFT;
+	max_small_pages = ALIGN(size, 1UL << page_shift) >> PAGE_SHIFT;
+
+	array_size = (unsigned long)max_small_pages * sizeof(struct page *);
 	gfp_mask |= __GFP_NOWARN;
 	if (!(gfp_mask & (GFP_DMA | GFP_DMA32)))
 		gfp_mask |= __GFP_HIGHMEM;
 
 	/* Please note that the recursion is strictly bounded. */
 	if (array_size > PAGE_SIZE) {
-		area->pages = __vmalloc_node(array_size, 1, nested_gfp, node,
-					area->caller);
+		area->pages = __vmalloc_node_no_huge(array_size, 1, nested_gfp,
+						     node, area->caller);
 	} else {
 		area->pages = kmalloc_node(array_size, nested_gfp, node);
 	}
@@ -3157,6 +3160,14 @@ void *__vmalloc_node(unsigned long size,
 	return __vmalloc_node_range(size, align, VMALLOC_START, VMALLOC_END,
 				gfp_mask, PAGE_KERNEL, 0, node, caller);
 }
+
+void *__vmalloc_node_no_huge(unsigned long size, unsigned long align,
+			     gfp_t gfp_mask, int node, const void *caller)
+{
+	return __vmalloc_node_range(size, align, VMALLOC_START, VMALLOC_END,
+				gfp_mask, PAGE_KERNEL, VM_NO_HUGE_VMAP, node, caller);
+}
+
 /*
  * This is only for performance analysis of vmalloc and stress purpose.
  * It is required by vmalloc test module, therefore do not use it other
_

Patches currently in -mm which might be from xuyu@linux.alibaba.com are


