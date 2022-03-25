Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05D8AC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:11:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350924AbiCYBNS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:13:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357196AbiCYBM4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:12:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33092BD2CD
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:11:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0BF6B82708
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:11:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DE02C340EE;
        Fri, 25 Mar 2022 01:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648170680;
        bh=kssK74LenpGbAMX5VZT9hmykFcAqbyvnUGIT/cxXepg=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=UthHvowNQpAJDu3i5s7WnJ7n/75PbDy2vLwQTNXsHf3I/tcgNS0n8A7KetO9syMno
         hPciAjnuvMOJaz0Rdhu0p33pEBk2Kqvr530VHtMw6+HHc2FHdBVOxE9cGlz9VAK+Wo
         PsJakZYJ+Q1vwErrCt7coL9PUrCnQgNCCMkK7DoI=
Date:   Thu, 24 Mar 2022 18:11:20 -0700
To:     will@kernel.org, vincenzo.frascino@arm.com, ryabinin.a.a@gmail.com,
        pcc@google.com, mark.rutland@arm.com, glider@google.com,
        eugenis@google.com, elver@google.com, dvyukov@google.com,
        catalin.marinas@arm.com, andreyknvl@google.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 055/114] kasan, vmalloc: unpoison VM_ALLOC pages after mapping
Message-Id: <20220325011120.9DE02C340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan, vmalloc: unpoison VM_ALLOC pages after mapping

Make KASAN unpoison vmalloc mappings after they have been mapped in when
it's possible: for vmalloc() (indentified via VM_ALLOC) and vm_map_ram().

The reasons for this are:

- For vmalloc() and vm_map_ram(): pages don't get unpoisoned in case
  mapping them fails.
- For vmalloc(): HW_TAGS KASAN needs pages to be mapped to set tags via
  kasan_unpoison_vmalloc().

As a part of these changes, the return value of __vmalloc_node_range() is
changed to area->addr.  This is a non-functional change, as
__vmalloc_area_node() returns area->addr anyway.

Link: https://lkml.kernel.org/r/fcb98980e6fcd3c4be6acdcb5d6110898ef28548.1643047180.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Acked-by: Marco Elver <elver@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

--- a/mm/vmalloc.c~kasan-vmalloc-unpoison-vm_alloc-pages-after-mapping
+++ a/mm/vmalloc.c
@@ -2231,14 +2231,15 @@ void *vm_map_ram(struct page **pages, un
 		mem = (void *)addr;
 	}
 
-	mem = kasan_unpoison_vmalloc(mem, size);
-
 	if (vmap_pages_range(addr, addr + size, PAGE_KERNEL,
 				pages, PAGE_SHIFT) < 0) {
 		vm_unmap_ram(mem, count);
 		return NULL;
 	}
 
+	/* Mark the pages as accessible, now that they are mapped. */
+	mem = kasan_unpoison_vmalloc(mem, size);
+
 	return mem;
 }
 EXPORT_SYMBOL(vm_map_ram);
@@ -2466,7 +2467,14 @@ static struct vm_struct *__get_vm_area_n
 
 	setup_vmalloc_vm(area, va, flags, caller);
 
-	area->addr = kasan_unpoison_vmalloc(area->addr, requested_size);
+	/*
+	 * Mark pages for non-VM_ALLOC mappings as accessible. Do it now as a
+	 * best-effort approach, as they can be mapped outside of vmalloc code.
+	 * For VM_ALLOC mappings, the pages are marked as accessible after
+	 * getting mapped in __vmalloc_node_range().
+	 */
+	if (!(flags & VM_ALLOC))
+		area->addr = kasan_unpoison_vmalloc(area->addr, requested_size);
 
 	return area;
 }
@@ -3075,7 +3083,7 @@ void *__vmalloc_node_range(unsigned long
 			const void *caller)
 {
 	struct vm_struct *area;
-	void *addr;
+	void *ret;
 	unsigned long real_size = size;
 	unsigned long real_align = align;
 	unsigned int shift = PAGE_SHIFT;
@@ -3137,10 +3145,13 @@ again:
 		prot = arch_vmap_pgprot_tagged(prot);
 
 	/* Allocate physical pages and map them into vmalloc space. */
-	addr = __vmalloc_area_node(area, gfp_mask, prot, shift, node);
-	if (!addr)
+	ret = __vmalloc_area_node(area, gfp_mask, prot, shift, node);
+	if (!ret)
 		goto fail;
 
+	/* Mark the pages as accessible, now that they are mapped. */
+	area->addr = kasan_unpoison_vmalloc(area->addr, real_size);
+
 	/*
 	 * In this function, newly allocated vm_struct has VM_UNINITIALIZED
 	 * flag. It means that vm_struct is not fully initialized.
@@ -3152,7 +3163,7 @@ again:
 	if (!(vm_flags & VM_DEFER_KMEMLEAK))
 		kmemleak_vmalloc(area, size, gfp_mask);
 
-	return addr;
+	return area->addr;
 
 fail:
 	if (shift > PAGE_SHIFT) {
@@ -3836,7 +3847,10 @@ retry:
 	}
 	spin_unlock(&vmap_area_lock);
 
-	/* mark allocated areas as accessible */
+	/*
+	 * Mark allocated areas as accessible. Do it now as a best-effort
+	 * approach, as they can be mapped outside of vmalloc code.
+	 */
 	for (area = 0; area < nr_vms; area++)
 		vms[area]->addr = kasan_unpoison_vmalloc(vms[area]->addr,
 							 vms[area]->size);
_
