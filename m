Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69879C48BC2
	for <mm-commits@archiver.kernel.org>; Sun, 27 Jun 2021 21:54:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51F3061C35
	for <mm-commits@archiver.kernel.org>; Sun, 27 Jun 2021 21:54:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231817AbhF0V40 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 27 Jun 2021 17:56:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:55114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231694AbhF0V40 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 27 Jun 2021 17:56:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C2DE61C34;
        Sun, 27 Jun 2021 21:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624830840;
        bh=Y3CbN9jVzP5SQRIrRKCjJTtvgOnOYrGZCtXFSffqBLM=;
        h=Date:From:To:Subject:From;
        b=nlKa06ESHFSuZSrO7JHT/N09uwABPh6Hi9rYMSTibG2MCV+XZ7wQDJUzWUELwJy4c
         yodBr2DRc9pqPDLuBc5bbkL6GFcYJ10TJDTZMcwlwD5n74YcT7DuIaK6Bg5tdPwFow
         KXicLRwz07JQXl32L/mkY94s/H8tkKpXJ6gIlWU4=
Date:   Sun, 27 Jun 2021 14:54:00 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, davidgow@google.com, dja@axtens.net,
        dvyukov@google.com, mm-commits@vger.kernel.org, npiggin@gmail.com,
        urezki@gmail.com
Subject:  [merged] mm-vmalloc-unbreak-kasan-vmalloc-support.patch
 removed from -mm tree
Message-ID: <20210627215400.QXy60qV3f%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: unbreak kasan vmalloc support
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-unbreak-kasan-vmalloc-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

kasan-allow-an-architecture-to-disable-inline-instrumentation.patch
kasan-allow-architectures-to-provide-an-outline-readiness-check.patch
mm-define-default-max_ptrs_per_-in-include-pgtableh.patch
kasan-use-max_ptrs_per_-for-early-shadow-tables.patch

