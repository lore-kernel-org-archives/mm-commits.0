Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D27EC433F5
	for <mm-commits@archiver.kernel.org>; Wed, 24 Nov 2021 21:50:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245606AbhKXVxo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Nov 2021 16:53:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:53546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244474AbhKXVxo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Nov 2021 16:53:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3A3461038;
        Wed, 24 Nov 2021 21:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637790634;
        bh=NP/Jl16Tlj9cS7H1KYhmol9LnD+LKPsXXC3WQ3u1eTI=;
        h=Date:From:To:Subject:From;
        b=wqpEgu06XX7PV74SSt6jf7Yi0iNQROfniLzrmGnoLt3lZ53TCFxhCizJfzKf3/mkm
         TDxclON9xDh+tTq8edgpVwndJQ+q0P3m1BBfRnYthfHHi03fhuAHrPsAGgtLZYcUBm
         jn3ea3CaXrKnfcwd6VAYJVFfpZTOOkN2nriaDxk4=
Date:   Wed, 24 Nov 2021 13:50:33 -0800
From:   akpm@linux-foundation.org
To:     agordeev@linux.ibm.com, borntraeger@linux.ibm.com, bp@alien8.de,
        catalin.marinas@arm.com, dave.hansen@linux.intel.com,
        dvyukov@google.com, glider@google.com, gor@linux.ibm.com,
        hca@linux.ibm.com, liuyongqiang13@huawei.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        tglx@linutronix.de, wangkefeng.wang@huawei.com, will@kernel.org
Subject:  + mm-defer-kmemleak-object-creation-of-module_alloc.patch
 added to -mm tree
Message-ID: <20211124215033.Z7ZL3fBbR%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: defer kmemleak object creation of module_alloc()
has been added to the -mm tree.  Its filename is
     mm-defer-kmemleak-object-creation-of-module_alloc.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-defer-kmemleak-object-creation-of-module_alloc.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-defer-kmemleak-object-creation-of-module_alloc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: defer kmemleak object creation of module_alloc()

Yongqiang reports a kmemleak panic when performing module insmod/rmmod
with KASAN enabled(without KASAN_VMALLOC) on x86[1].

When the module area allocates memory, its kmemleak_object is created
successfully, but the KASAN shadow memory of the module allocation is not
ready, so when kmemleak scans the module's pointer, it will panic due to
no shadow memory with KASAN check.

module_alloc
  __vmalloc_node_range
    kmemleak_vmalloc
				kmemleak_scan
				  update_checksum
  kasan_module_alloc
    kmemleak_ignore

Note, there is no problem if KASAN_VMALLOC enabled, the module's area
entire shadow memory is preallocated.  Thus, the bug only exits on ARCH
which supports dynamic allocation of module area per module load, for now,
only x86/arm64/s390 are involved.

Add a VM_DEFER_KMEMLEAK flags, defer vmalloc'ed object register of
kmemleak in module_alloc() to fix this issue.

[1] https://lore.kernel.org/all/6d41e2b9-4692-5ec4-b1cd-cbe29ae89739@huawei.com/
Link: https://lkml.kernel.org/r/20211124142034.192078-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reported-by: Yongqiang Liu <liuyongqiang13@huawei.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/kernel/module.c |    4 ++--
 arch/s390/kernel/module.c  |    5 +++--
 arch/x86/kernel/module.c   |    7 ++++---
 include/linux/kasan.h      |    4 ++--
 include/linux/vmalloc.h    |    7 +++++++
 mm/kasan/shadow.c          |    9 +++++++--
 mm/vmalloc.c               |    3 ++-
 7 files changed, 27 insertions(+), 12 deletions(-)

--- a/arch/arm64/kernel/module.c~mm-defer-kmemleak-object-creation-of-module_alloc
+++ a/arch/arm64/kernel/module.c
@@ -36,7 +36,7 @@ void *module_alloc(unsigned long size)
 		module_alloc_end = MODULES_END;
 
 	p = __vmalloc_node_range(size, MODULE_ALIGN, module_alloc_base,
-				module_alloc_end, gfp_mask, PAGE_KERNEL, 0,
+				module_alloc_end, gfp_mask, PAGE_KERNEL, VM_DEFER_KMEMLEAK,
 				NUMA_NO_NODE, __builtin_return_address(0));
 
 	if (!p && IS_ENABLED(CONFIG_ARM64_MODULE_PLTS) &&
@@ -58,7 +58,7 @@ void *module_alloc(unsigned long size)
 				PAGE_KERNEL, 0, NUMA_NO_NODE,
 				__builtin_return_address(0));
 
-	if (p && (kasan_module_alloc(p, size) < 0)) {
+	if (p && (kasan_module_alloc(p, size, gfp_mask) < 0)) {
 		vfree(p);
 		return NULL;
 	}
--- a/arch/s390/kernel/module.c~mm-defer-kmemleak-object-creation-of-module_alloc
+++ a/arch/s390/kernel/module.c
@@ -37,14 +37,15 @@
 
 void *module_alloc(unsigned long size)
 {
+	gfp_t gfp_mask = GFP_KERNEL;
 	void *p;
 
 	if (PAGE_ALIGN(size) > MODULES_LEN)
 		return NULL;
 	p = __vmalloc_node_range(size, MODULE_ALIGN, MODULES_VADDR, MODULES_END,
-				 GFP_KERNEL, PAGE_KERNEL_EXEC, 0, NUMA_NO_NODE,
+				 gfp_mask, PAGE_KERNEL_EXEC, VM_DEFER_KMEMLEAK, NUMA_NO_NODE,
 				 __builtin_return_address(0));
-	if (p && (kasan_module_alloc(p, size) < 0)) {
+	if (p && (kasan_module_alloc(p, size, gfp_mask) < 0)) {
 		vfree(p);
 		return NULL;
 	}
--- a/arch/x86/kernel/module.c~mm-defer-kmemleak-object-creation-of-module_alloc
+++ a/arch/x86/kernel/module.c
@@ -67,6 +67,7 @@ static unsigned long int get_module_load
 
 void *module_alloc(unsigned long size)
 {
+	gfp_t gfp_mask = GFP_KERNEL;
 	void *p;
 
 	if (PAGE_ALIGN(size) > MODULES_LEN)
@@ -74,10 +75,10 @@ void *module_alloc(unsigned long size)
 
 	p = __vmalloc_node_range(size, MODULE_ALIGN,
 				    MODULES_VADDR + get_module_load_offset(),
-				    MODULES_END, GFP_KERNEL,
-				    PAGE_KERNEL, 0, NUMA_NO_NODE,
+				    MODULES_END, gfp_mask,
+				    PAGE_KERNEL, VM_DEFER_KMEMLEAK, NUMA_NO_NODE,
 				    __builtin_return_address(0));
-	if (p && (kasan_module_alloc(p, size) < 0)) {
+	if (p && (kasan_module_alloc(p, size, gfp_mask) < 0)) {
 		vfree(p);
 		return NULL;
 	}
--- a/include/linux/kasan.h~mm-defer-kmemleak-object-creation-of-module_alloc
+++ a/include/linux/kasan.h
@@ -474,12 +474,12 @@ static inline void kasan_populate_early_
  * allocations with real shadow memory. With KASAN vmalloc, the special
  * case is unnecessary, as the work is handled in the generic case.
  */
-int kasan_module_alloc(void *addr, size_t size);
+int kasan_module_alloc(void *addr, size_t size, gfp_t gfp_mask);
 void kasan_free_shadow(const struct vm_struct *vm);
 
 #else /* (CONFIG_KASAN_GENERIC || CONFIG_KASAN_SW_TAGS) && !CONFIG_KASAN_VMALLOC */
 
-static inline int kasan_module_alloc(void *addr, size_t size) { return 0; }
+static inline int kasan_module_alloc(void *addr, size_t size, gfp_t gfp_mask) { return 0; }
 static inline void kasan_free_shadow(const struct vm_struct *vm) {}
 
 #endif /* (CONFIG_KASAN_GENERIC || CONFIG_KASAN_SW_TAGS) && !CONFIG_KASAN_VMALLOC */
--- a/include/linux/vmalloc.h~mm-defer-kmemleak-object-creation-of-module_alloc
+++ a/include/linux/vmalloc.h
@@ -28,6 +28,13 @@ struct notifier_block;		/* in notifier.h
 #define VM_MAP_PUT_PAGES	0x00000200	/* put pages and free array in vfree */
 #define VM_NO_HUGE_VMAP		0x00000400	/* force PAGE_SIZE pte mapping */
 
+#if defined(CONFIG_KASAN) && (defined(CONFIG_KASAN_GENERIC) || \
+	defined(CONFIG_KASAN_SW_TAGS)) && !defined(CONFIG_KASAN_VMALLOC)
+#define VM_DEFER_KMEMLEAK	0x00000800	/* defer kmemleak object creation */
+#else
+#define VM_DEFER_KMEMLEAK	0
+#endif
+
 /*
  * VM_KASAN is used slightly differently depending on CONFIG_KASAN_VMALLOC.
  *
--- a/mm/kasan/shadow.c~mm-defer-kmemleak-object-creation-of-module_alloc
+++ a/mm/kasan/shadow.c
@@ -498,7 +498,7 @@ void kasan_release_vmalloc(unsigned long
 
 #else /* CONFIG_KASAN_VMALLOC */
 
-int kasan_module_alloc(void *addr, size_t size)
+int kasan_module_alloc(void *addr, size_t size, gfp_t gfp_mask)
 {
 	void *ret;
 	size_t scaled_size;
@@ -520,9 +520,14 @@ int kasan_module_alloc(void *addr, size_
 			__builtin_return_address(0));
 
 	if (ret) {
+		struct vm_struct *vm = find_vm_area(addr);
 		__memset(ret, KASAN_SHADOW_INIT, shadow_size);
-		find_vm_area(addr)->flags |= VM_KASAN;
+		vm->flags |= VM_KASAN;
 		kmemleak_ignore(ret);
+
+		if (vm->flags & VM_DELAY_KMEMLEAK)
+			kmemleak_vmalloc(vm, size, gfp_mask);
+
 		return 0;
 	}
 
--- a/mm/vmalloc.c~mm-defer-kmemleak-object-creation-of-module_alloc
+++ a/mm/vmalloc.c
@@ -3074,7 +3074,8 @@ again:
 	clear_vm_uninitialized_flag(area);
 
 	size = PAGE_ALIGN(size);
-	kmemleak_vmalloc(area, size, gfp_mask);
+	if (!(vm_flags & VM_DEFER_KMEMLEAK))
+		kmemleak_vmalloc(area, size, gfp_mask);
 
 	return addr;
 
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-defer-kmemleak-object-creation-of-module_alloc.patch

