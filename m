Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D97B3C433EF
	for <mm-commits@archiver.kernel.org>; Sun, 10 Oct 2021 21:37:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AECD8610C7
	for <mm-commits@archiver.kernel.org>; Sun, 10 Oct 2021 21:37:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232590AbhJJVjX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 10 Oct 2021 17:39:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:59492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230271AbhJJVjX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 10 Oct 2021 17:39:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1AB5F60F24;
        Sun, 10 Oct 2021 21:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633901844;
        bh=3xLirvN6ieuft6FsJv5hFCSpbNH81dsVzFGYR+RJWZE=;
        h=Date:From:To:Subject:From;
        b=d0zdHgg3/uFgM+Mjt6mM7ME1JD2v9sURoUqpsGjRlelwzzwbRrGn/+n6ULOI1ld2u
         7z1GqwUinud+clQHeqiuZAFvc3z2nJUqjupfn5eDvL8s/VBhEBhA/nuGtRVe2r6FHH
         adpWuP/SpXp+tfY7UqugKZoTZXrpDJUhP/Y5hngA=
Date:   Sun, 10 Oct 2021 14:37:23 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, catalin.marinas@arm.com, dvyukov@google.com,
        elver@google.com, gregkh@linuxfoundation.org,
        mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        wangkefeng.wang@huawei.com, will@kernel.org
Subject:  +
 kasan-arm64-fix-pcpu_page_first_chunk-crash-with-kasan_vmalloc.patch added
 to -mm tree
Message-ID: <20211010213723.h0vWxYv06%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: arm64: fix pcpu_page_first_chunk crash with KASAN_VMALLOC
has been added to the -mm tree.  Its filename is
     kasan-arm64-fix-pcpu_page_first_chunk-crash-with-kasan_vmalloc.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-arm64-fix-pcpu_page_first_chunk-crash-with-kasan_vmalloc.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-arm64-fix-pcpu_page_first_chunk-crash-with-kasan_vmalloc.patch

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
Subject: kasan: arm64: fix pcpu_page_first_chunk crash with KASAN_VMALLOC

With KASAN_VMALLOC and NEED_PER_CPU_PAGE_FIRST_CHUNK, it crashes,

Unable to handle kernel paging request at virtual address ffff7000028f2000
...
swapper pgtable: 64k pages, 48-bit VAs, pgdp=0000000042440000
[ffff7000028f2000] pgd=000000063e7c0003, p4d=000000063e7c0003, pud=000000063e7c0003, pmd=000000063e7b0003, pte=0000000000000000
Internal error: Oops: 96000007 [#1] PREEMPT SMP
Modules linked in:
CPU: 0 PID: 0 Comm: swapper Not tainted 5.13.0-rc4-00003-gc6e6e28f3f30-dirty #62
Hardware name: linux,dummy-virt (DT)
pstate: 200000c5 (nzCv daIF -PAN -UAO -TCO BTYPE=--)
pc : kasan_check_range+0x90/0x1a0
lr : memcpy+0x88/0xf4
sp : ffff80001378fe20
...
Call trace:
 kasan_check_range+0x90/0x1a0
 pcpu_page_first_chunk+0x3f0/0x568
 setup_per_cpu_areas+0xb8/0x184
 start_kernel+0x8c/0x328

The vm area used in vm_area_register_early() has no kasan shadow memory,
Let's add a new kasan_populate_early_vm_area_shadow() function to populate
the vm area shadow memory to fix the issue.

Link: https://lkml.kernel.org/r/20210910053354.26721-4-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: Marco Elver <elver@google.com> (for KASAN parts)
Acked-by: Andrey Konovalov <andreyknvl@gmail.com> (for KASAN parts)
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/kasan_init.c |   16 ++++++++++++++++
 include/linux/kasan.h      |    6 ++++++
 mm/kasan/init.c            |    5 +++++
 mm/vmalloc.c               |    1 +
 4 files changed, 28 insertions(+)

--- a/arch/arm64/mm/kasan_init.c~kasan-arm64-fix-pcpu_page_first_chunk-crash-with-kasan_vmalloc
+++ a/arch/arm64/mm/kasan_init.c
@@ -287,6 +287,22 @@ static void __init kasan_init_depth(void
 	init_task.kasan_depth = 0;
 }
 
+#ifdef CONFIG_KASAN_VMALLOC
+void __init kasan_populate_early_vm_area_shadow(void *start, unsigned long size)
+{
+	unsigned long shadow_start, shadow_end;
+
+	if (!is_vmalloc_or_module_addr(start))
+		return;
+
+	shadow_start = (unsigned long)kasan_mem_to_shadow(start);
+	shadow_start = ALIGN_DOWN(shadow_start, PAGE_SIZE);
+	shadow_end = (unsigned long)kasan_mem_to_shadow(start + size);
+	shadow_end = ALIGN(shadow_end, PAGE_SIZE);
+	kasan_map_populate(shadow_start, shadow_end, NUMA_NO_NODE);
+}
+#endif
+
 void __init kasan_init(void)
 {
 	kasan_init_shadow();
--- a/include/linux/kasan.h~kasan-arm64-fix-pcpu_page_first_chunk-crash-with-kasan_vmalloc
+++ a/include/linux/kasan.h
@@ -434,6 +434,8 @@ void kasan_release_vmalloc(unsigned long
 			   unsigned long free_region_start,
 			   unsigned long free_region_end);
 
+void kasan_populate_early_vm_area_shadow(void *start, unsigned long size);
+
 #else /* CONFIG_KASAN_VMALLOC */
 
 static inline int kasan_populate_vmalloc(unsigned long start,
@@ -451,6 +453,10 @@ static inline void kasan_release_vmalloc
 					 unsigned long free_region_start,
 					 unsigned long free_region_end) {}
 
+static inline void kasan_populate_early_vm_area_shadow(void *start,
+						       unsigned long size)
+{ }
+
 #endif /* CONFIG_KASAN_VMALLOC */
 
 #if (defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)) && \
--- a/mm/kasan/init.c~kasan-arm64-fix-pcpu_page_first_chunk-crash-with-kasan_vmalloc
+++ a/mm/kasan/init.c
@@ -279,6 +279,11 @@ int __ref kasan_populate_early_shadow(co
 	return 0;
 }
 
+void __init __weak kasan_populate_early_vm_area_shadow(void *start,
+						       unsigned long size)
+{
+}
+
 static void kasan_free_pte(pte_t *pte_start, pmd_t *pmd)
 {
 	pte_t *pte;
--- a/mm/vmalloc.c~kasan-arm64-fix-pcpu_page_first_chunk-crash-with-kasan_vmalloc
+++ a/mm/vmalloc.c
@@ -2291,6 +2291,7 @@ void __init vm_area_register_early(struc
 	vm->addr = (void *)addr;
 	vm->next = *p;
 	*p = vm;
+	kasan_populate_early_vm_area_shadow(vm->addr, vm->size);
 }
 
 static void vmap_init_free_space(void)
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

slub-add-back-check-for-free-nonslab-objects.patch
vmalloc-choose-a-better-start-address-in-vm_area_register_early.patch
arm64-support-page-mapping-percpu-first-chunk-allocator.patch
kasan-arm64-fix-pcpu_page_first_chunk-crash-with-kasan_vmalloc.patch
mm-nommu-kill-arch_get_unmapped_area.patch
kallsyms-remove-arch-specific-text-and-data-check.patch
kallsyms-fix-address-checks-for-kernel-related-range.patch
sections-move-and-rename-core_kernel_data-to-is_kernel_core_data.patch
sections-move-is_kernel_inittext-into-sectionsh.patch
x86-mm-rename-__is_kernel_text-to-is_x86_32_kernel_text.patch
sections-provide-internal-__is_kernel-and-__is_kernel_text-helper.patch
mm-kasan-use-is_kernel-helper.patch
extable-use-is_kernel_text-helper.patch
powerpc-mm-use-core_kernel_text-helper.patch
microblaze-use-is_kernel_text-helper.patch
alpha-use-is_kernel_text-helper.patch

