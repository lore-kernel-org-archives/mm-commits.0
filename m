Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61FDEC433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:39:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 452E960FBF
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:39:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233479AbhKEUm2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:42:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:37198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232269AbhKEUm2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:42:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E0D5F6056B;
        Fri,  5 Nov 2021 20:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144788;
        bh=Zk+BrwYZCFK61Dq1skpN7K27Yt3m+OHUlfiO6EiaMkY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=IpBe62TDm2yFyRmRqh2nUEOvdA8rxTx17q3XHYr0OzFYo4r6RkDWks7WY7aAPgiB3
         sxnZZl/QxMLc9M+YxmmTiZGDldEqNJTqg9/8lGeKZ9MFewXhZUh2qI7Sqn30cQ2+sq
         5rPw+IRqVpoqRzr0ptbqiqz37zwrTM1MNjXdHA3s=
Date:   Fri, 05 Nov 2021 13:39:47 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@gmail.com,
        catalin.marinas@arm.com, dvyukov@google.com, elver@google.com,
        gregkh@linuxfoundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        torvalds@linux-foundation.org, wangkefeng.wang@huawei.com,
        will@kernel.org
Subject:  [patch 098/262] kasan: arm64: fix pcpu_page_first_chunk
 crash with KASAN_VMALLOC
Message-ID: <20211105203947.iTqM9LZ0I%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

[wangkefeng.wang@huawei.com: fix redefinition of 'kasan_populate_early_vm_area_shadow']
  Link: https://lkml.kernel.org/r/20211011123211.3936196-1-wangkefeng.wang@huawei.com
Link: https://lkml.kernel.org/r/20210910053354.26721-4-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: Marco Elver <elver@google.com>		[KASAN]
Acked-by: Andrey Konovalov <andreyknvl@gmail.com>	[KASAN]
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/kasan_init.c |   16 ++++++++++++++++
 include/linux/kasan.h      |    6 ++++++
 mm/kasan/shadow.c          |    5 +++++
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
@@ -436,6 +436,8 @@ void kasan_release_vmalloc(unsigned long
 			   unsigned long free_region_start,
 			   unsigned long free_region_end);
 
+void kasan_populate_early_vm_area_shadow(void *start, unsigned long size);
+
 #else /* CONFIG_KASAN_VMALLOC */
 
 static inline int kasan_populate_vmalloc(unsigned long start,
@@ -453,6 +455,10 @@ static inline void kasan_release_vmalloc
 					 unsigned long free_region_start,
 					 unsigned long free_region_end) {}
 
+static inline void kasan_populate_early_vm_area_shadow(void *start,
+						       unsigned long size)
+{ }
+
 #endif /* CONFIG_KASAN_VMALLOC */
 
 #if (defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)) && \
--- a/mm/kasan/shadow.c~kasan-arm64-fix-pcpu_page_first_chunk-crash-with-kasan_vmalloc
+++ a/mm/kasan/shadow.c
@@ -254,6 +254,11 @@ core_initcall(kasan_memhotplug_init);
 
 #ifdef CONFIG_KASAN_VMALLOC
 
+void __init __weak kasan_populate_early_vm_area_shadow(void *start,
+						       unsigned long size)
+{
+}
+
 static int kasan_populate_vmalloc_pte(pte_t *ptep, unsigned long addr,
 				      void *unused)
 {
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
