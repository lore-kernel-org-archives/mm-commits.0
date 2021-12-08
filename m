Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92BBFC433F5
	for <mm-commits@archiver.kernel.org>; Wed,  8 Dec 2021 00:22:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235439AbhLHA0H (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Dec 2021 19:26:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242795AbhLHAZ6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 7 Dec 2021 19:25:58 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98FFCC0617A1
        for <mm-commits@vger.kernel.org>; Tue,  7 Dec 2021 16:22:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D546DCE1ECD
        for <mm-commits@vger.kernel.org>; Wed,  8 Dec 2021 00:22:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D85F4C341C5;
        Wed,  8 Dec 2021 00:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638922944;
        bh=fRsCv1P0ykVHvpuxag50O1reZYxC0GxlD8lg3NmxizQ=;
        h=Date:From:To:Subject:From;
        b=rSsJPysr+hxDT3JK5u+yF/2R9QLk0MvXy6WFKEvY3xy2yGo00HUxfiVqJDIccKkBX
         FHTsreRlD6XJt6R6wC6uhXIkjSvnuG2ixScZY2UI9dGoyKWjdFZcJZeiuH869x1Nwg
         nB3NEMRiACv4ukXVFQ1Uy5/iOGeenkZYTcJbMMVs=
Date:   Tue, 07 Dec 2021 16:22:23 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, npiggin@gmail.com,
        uladzislau.rezki@sony.com, xuyu@linux.alibaba.com
Subject:  + mm-vmalloc-allocate-small-pages-for-area-pages.patch
 added to -mm tree
Message-ID: <20211208002223.apFcxcH-N%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: allocate small pages for area->pages
has been added to the -mm tree.  Its filename is
     mm-vmalloc-allocate-small-pages-for-area-pages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-allocate-small-pages-for-area-pages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-allocate-small-pages-for-area-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Link: https://lkml.kernel.org/r/dd04f516643fde4206c1fe93818526a768125c75.1638870169.git.xuyu@linux.alibaba.com
Signed-off-by: Xu Yu <xuyu@linux.alibaba.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Uladzislau Rezki <uladzislau.rezki@sony.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmalloc.h |    2 ++
 mm/vmalloc.c            |   15 ++++++++++++---
 2 files changed, 14 insertions(+), 3 deletions(-)

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
@@ -2928,19 +2928,20 @@ static void *__vmalloc_area_node(struct
 	unsigned long size = get_vm_area_size(area);
 	unsigned long array_size;
 	unsigned int nr_small_pages = size >> PAGE_SHIFT;
+	unsigned int max_small_pages = ALIGN(size, 1UL << page_shift) >> PAGE_SHIFT;
 	unsigned int page_order;
 	unsigned int flags;
 	int ret;
 
-	array_size = (unsigned long)nr_small_pages * sizeof(struct page *);
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
@@ -3147,6 +3148,14 @@ void *__vmalloc_node(unsigned long size,
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

mm-vmalloc-allocate-small-pages-for-area-pages.patch

