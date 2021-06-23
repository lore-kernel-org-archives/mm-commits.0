Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5A92C48BC2
	for <mm-commits@archiver.kernel.org>; Wed, 23 Jun 2021 23:57:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C09EE6120D
	for <mm-commits@archiver.kernel.org>; Wed, 23 Jun 2021 23:57:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbhFWX7z (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Jun 2021 19:59:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:52540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229726AbhFWX7z (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 23 Jun 2021 19:59:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B9FB160D07;
        Wed, 23 Jun 2021 23:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624492657;
        bh=RBLAivvEi5+REI2DYaNodwNteUVRvK9WcUajGoqWSGg=;
        h=Date:From:To:Subject:From;
        b=jJhuRyBxf4FyRV1r/KkLi5Db1DNtoe96R0jbgV0aGA1OcjQy+kTgKnWRT6QGAwd26
         NexA32RFSJR+75AGCaqiTnrgmdGw8Sx0yQmJxbui2It5l3G2Znz1vNFkeZBXilz/c3
         qoTCUQBpB0g7JeXvQ3Ld8iiljibQkV504r5xSb5I=
Date:   Wed, 23 Jun 2021 16:57:36 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, davidgow@google.com, dja@axtens.net,
        dvyukov@google.com, mm-commits@vger.kernel.org, npiggin@gmail.com,
        urezki@gmail.com
Subject:  + mm-vmalloc-unbreak-kasan-vmalloc-support.patch added to
 -mm tree
Message-ID: <20210623235736.eVBhUscfd%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: unbreak kasan vmalloc support
has been added to the -mm tree.  Its filename is
     mm-vmalloc-unbreak-kasan-vmalloc-support.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-unbreak-kasan-vmalloc-support.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-unbreak-kasan-vmalloc-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Daniel Axtens <dja@axtens.net>
Subject: mm/vmalloc: unbreak kasan vmalloc support

In commit 121e6f3258fe ("mm/vmalloc: hugepage vmalloc mappings"),
__vmalloc_node_range was changed such that __get_vm_area_node was no
longer called with the requested/real size of the vmalloc allocation, but
rather with a rounded-up size.

This means that __get_vm_area_node called kasan_unpoision_vmalloc() with a
rounded up size rather than the real size.  This led to it allowing access
to too much memory and so missing vmalloc OOBs and failing the kasan kunit
tests.

Pass the real size and the desired shift into __get_vm_area_node.  This
allows it to round up the size for the underlying allocators while still
unpoisioning the correct quantity of shadow memory.

Adjust the other call-sites to pass in PAGE_SHIFT for the shift value.

Link: https://lkml.kernel.org/r/20210617081330.98629-1-dja@axtens.net
Link: https://bugzilla.kernel.org/show_bug.cgi?id=213335
Fixes: 121e6f3258fe ("mm/vmalloc: hugepage vmalloc mappings")
Signed-off-by: Daniel Axtens <dja@axtens.net>
Tested-by: David Gow <davidgow@google.com>
Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Tested-by: Andrey Konovalov <andreyknvl@gmail.com>
Acked-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-unbreak-kasan-vmalloc-support
+++ a/mm/vmalloc.c
@@ -2344,15 +2344,16 @@ static void clear_vm_uninitialized_flag(
 }
 
 static struct vm_struct *__get_vm_area_node(unsigned long size,
-		unsigned long align, unsigned long flags, unsigned long start,
-		unsigned long end, int node, gfp_t gfp_mask, const void *caller)
+		unsigned long align, unsigned long shift, unsigned long flags,
+		unsigned long start, unsigned long end, int node,
+		gfp_t gfp_mask, const void *caller)
 {
 	struct vmap_area *va;
 	struct vm_struct *area;
 	unsigned long requested_size = size;
 
 	BUG_ON(in_interrupt());
-	size = PAGE_ALIGN(size);
+	size = ALIGN(size, 1ul << shift);
 	if (unlikely(!size))
 		return NULL;
 
@@ -2384,8 +2385,8 @@ struct vm_struct *__get_vm_area_caller(u
 				       unsigned long start, unsigned long end,
 				       const void *caller)
 {
-	return __get_vm_area_node(size, 1, flags, start, end, NUMA_NO_NODE,
-				  GFP_KERNEL, caller);
+	return __get_vm_area_node(size, 1, PAGE_SHIFT, flags, start, end,
+				  NUMA_NO_NODE, GFP_KERNEL, caller);
 }
 
 /**
@@ -2401,7 +2402,8 @@ struct vm_struct *__get_vm_area_caller(u
  */
 struct vm_struct *get_vm_area(unsigned long size, unsigned long flags)
 {
-	return __get_vm_area_node(size, 1, flags, VMALLOC_START, VMALLOC_END,
+	return __get_vm_area_node(size, 1, PAGE_SHIFT, flags,
+				  VMALLOC_START, VMALLOC_END,
 				  NUMA_NO_NODE, GFP_KERNEL,
 				  __builtin_return_address(0));
 }
@@ -2409,7 +2411,8 @@ struct vm_struct *get_vm_area(unsigned l
 struct vm_struct *get_vm_area_caller(unsigned long size, unsigned long flags,
 				const void *caller)
 {
-	return __get_vm_area_node(size, 1, flags, VMALLOC_START, VMALLOC_END,
+	return __get_vm_area_node(size, 1, PAGE_SHIFT, flags,
+				  VMALLOC_START, VMALLOC_END,
 				  NUMA_NO_NODE, GFP_KERNEL, caller);
 }
 
@@ -2902,9 +2905,9 @@ void *__vmalloc_node_range(unsigned long
 	}
 
 again:
-	size = PAGE_ALIGN(size);
-	area = __get_vm_area_node(size, align, VM_ALLOC | VM_UNINITIALIZED |
-				vm_flags, start, end, node, gfp_mask, caller);
+	area = __get_vm_area_node(real_size, align, shift, VM_ALLOC |
+				  VM_UNINITIALIZED | vm_flags, start, end, node,
+				  gfp_mask, caller);
 	if (!area) {
 		warn_alloc(gfp_mask, NULL,
 			   "vmalloc size %lu allocation failure: "
@@ -2923,6 +2926,7 @@ again:
 	 */
 	clear_vm_uninitialized_flag(area);
 
+	size = PAGE_ALIGN(size);
 	kmemleak_vmalloc(area, size, gfp_mask);
 
 	return addr;
_

Patches currently in -mm which might be from dja@axtens.net are

mm-vmalloc-unbreak-kasan-vmalloc-support.patch

