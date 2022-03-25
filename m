Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50756C4321E
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:11:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357183AbiCYBMc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:12:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357176AbiCYBM2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:12:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 540E5BD2D5
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:10:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D79B66185C
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:10:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AD80C340EC;
        Fri, 25 Mar 2022 01:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648170653;
        bh=CUSIp31jQY79Hz/KQV6Utdw7A9FW4h4aJCST8yeHzj4=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=xsU2rsvKeoHAsi3isBlhJDpmzUyIsqsaRke6zTJ0d3qmUkaOD+6WPKX3/5wSzC4k4
         3DCYmsSHqWv8gHt+Thb+0vhgpaBq6p91Kp5IeeXpoN48exg8pV0FOcbtvhiEOaAxkj
         4rkjMA9vxelRorgeZbxrXDEvZ3giYy+2sBbFJEgs=
Date:   Thu, 24 Mar 2022 18:10:52 -0700
To:     will@kernel.org, vincenzo.frascino@arm.com, ryabinin.a.a@gmail.com,
        pcc@google.com, mark.rutland@arm.com, glider@google.com,
        eugenis@google.com, elver@google.com, dvyukov@google.com,
        catalin.marinas@arm.com, andreyknvl@google.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 046/114] kasan, x86, arm64, s390: rename functions for modules shadow
Message-Id: <20220325011053.3AD80C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan, x86, arm64, s390: rename functions for modules shadow

Rename kasan_free_shadow to kasan_free_module_shadow and
kasan_module_alloc to kasan_alloc_module_shadow.

These functions are used to allocate/free shadow memory for kernel modules
when KASAN_VMALLOC is not enabled.  The new names better reflect their
purpose.

Also reword the comment next to their declaration to improve clarity.

Link: https://lkml.kernel.org/r/36db32bde765d5d0b856f77d2d806e838513fe84.1643047180.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/kernel/module.c |    2 +-
 arch/s390/kernel/module.c  |    2 +-
 arch/x86/kernel/module.c   |    2 +-
 include/linux/kasan.h      |   14 +++++++-------
 mm/kasan/shadow.c          |    4 ++--
 mm/vmalloc.c               |    2 +-
 6 files changed, 13 insertions(+), 13 deletions(-)

--- a/arch/arm64/kernel/module.c~kasan-x86-arm64-s390-rename-functions-for-modules-shadow
+++ a/arch/arm64/kernel/module.c
@@ -58,7 +58,7 @@ void *module_alloc(unsigned long size)
 				PAGE_KERNEL, 0, NUMA_NO_NODE,
 				__builtin_return_address(0));
 
-	if (p && (kasan_module_alloc(p, size, gfp_mask) < 0)) {
+	if (p && (kasan_alloc_module_shadow(p, size, gfp_mask) < 0)) {
 		vfree(p);
 		return NULL;
 	}
--- a/arch/s390/kernel/module.c~kasan-x86-arm64-s390-rename-functions-for-modules-shadow
+++ a/arch/s390/kernel/module.c
@@ -45,7 +45,7 @@ void *module_alloc(unsigned long size)
 	p = __vmalloc_node_range(size, MODULE_ALIGN, MODULES_VADDR, MODULES_END,
 				 gfp_mask, PAGE_KERNEL_EXEC, VM_DEFER_KMEMLEAK, NUMA_NO_NODE,
 				 __builtin_return_address(0));
-	if (p && (kasan_module_alloc(p, size, gfp_mask) < 0)) {
+	if (p && (kasan_alloc_module_shadow(p, size, gfp_mask) < 0)) {
 		vfree(p);
 		return NULL;
 	}
--- a/arch/x86/kernel/module.c~kasan-x86-arm64-s390-rename-functions-for-modules-shadow
+++ a/arch/x86/kernel/module.c
@@ -78,7 +78,7 @@ void *module_alloc(unsigned long size)
 				    MODULES_END, gfp_mask,
 				    PAGE_KERNEL, VM_DEFER_KMEMLEAK, NUMA_NO_NODE,
 				    __builtin_return_address(0));
-	if (p && (kasan_module_alloc(p, size, gfp_mask) < 0)) {
+	if (p && (kasan_alloc_module_shadow(p, size, gfp_mask) < 0)) {
 		vfree(p);
 		return NULL;
 	}
--- a/include/linux/kasan.h~kasan-x86-arm64-s390-rename-functions-for-modules-shadow
+++ a/include/linux/kasan.h
@@ -433,17 +433,17 @@ static inline void kasan_populate_early_
 		!defined(CONFIG_KASAN_VMALLOC)
 
 /*
- * These functions provide a special case to support backing module
- * allocations with real shadow memory. With KASAN vmalloc, the special
- * case is unnecessary, as the work is handled in the generic case.
+ * These functions allocate and free shadow memory for kernel modules.
+ * They are only required when KASAN_VMALLOC is not supported, as otherwise
+ * shadow memory is allocated by the generic vmalloc handlers.
  */
-int kasan_module_alloc(void *addr, size_t size, gfp_t gfp_mask);
-void kasan_free_shadow(const struct vm_struct *vm);
+int kasan_alloc_module_shadow(void *addr, size_t size, gfp_t gfp_mask);
+void kasan_free_module_shadow(const struct vm_struct *vm);
 
 #else /* (CONFIG_KASAN_GENERIC || CONFIG_KASAN_SW_TAGS) && !CONFIG_KASAN_VMALLOC */
 
-static inline int kasan_module_alloc(void *addr, size_t size, gfp_t gfp_mask) { return 0; }
-static inline void kasan_free_shadow(const struct vm_struct *vm) {}
+static inline int kasan_alloc_module_shadow(void *addr, size_t size, gfp_t gfp_mask) { return 0; }
+static inline void kasan_free_module_shadow(const struct vm_struct *vm) {}
 
 #endif /* (CONFIG_KASAN_GENERIC || CONFIG_KASAN_SW_TAGS) && !CONFIG_KASAN_VMALLOC */
 
--- a/mm/kasan/shadow.c~kasan-x86-arm64-s390-rename-functions-for-modules-shadow
+++ a/mm/kasan/shadow.c
@@ -498,7 +498,7 @@ void kasan_release_vmalloc(unsigned long
 
 #else /* CONFIG_KASAN_VMALLOC */
 
-int kasan_module_alloc(void *addr, size_t size, gfp_t gfp_mask)
+int kasan_alloc_module_shadow(void *addr, size_t size, gfp_t gfp_mask)
 {
 	void *ret;
 	size_t scaled_size;
@@ -534,7 +534,7 @@ int kasan_module_alloc(void *addr, size_
 	return -ENOMEM;
 }
 
-void kasan_free_shadow(const struct vm_struct *vm)
+void kasan_free_module_shadow(const struct vm_struct *vm)
 {
 	if (vm->flags & VM_KASAN)
 		vfree(kasan_mem_to_shadow(vm->addr));
--- a/mm/vmalloc.c~kasan-x86-arm64-s390-rename-functions-for-modules-shadow
+++ a/mm/vmalloc.c
@@ -2547,7 +2547,7 @@ struct vm_struct *remove_vm_area(const v
 		va->vm = NULL;
 		spin_unlock(&vmap_area_lock);
 
-		kasan_free_shadow(vm);
+		kasan_free_module_shadow(vm);
 		free_unmap_vmap_area(va);
 
 		return vm;
_
