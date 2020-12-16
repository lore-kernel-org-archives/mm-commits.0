Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E70E6C4361B
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:02:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9644322EBF
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:02:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbgLPRB6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Dec 2020 12:01:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:58418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726825AbgLPRB5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Dec 2020 12:01:57 -0500
Date:   Wed, 16 Dec 2020 09:01:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608138076;
        bh=65KF7Md+NUm4/hLlYv0lISB1kE/OwDdF3/oWV8Ri11Y=;
        h=From:To:Subject:From;
        b=zEFGks1BRMU5FhSt6bNSP2QS0SC1KsNUDdl7Adr2WXx5lBz8WngqwU1B2AtYJR69S
         PQD/c4Vq4f+LvNa+u3iH/gy4h6tMysk6VLYGhkbzGPpP9M/aJ2UbmtdedZzVrmep8P
         6OuYYg6WcFrgxLKcZWWaNRKYZ41ZbWWZr1lsL9VE=
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  [obsolete] linux-next-rejects.patch removed from -mm tree
Message-ID: <20201216170116.VxarP_fGi%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/Kconfig                      |    1 
 drivers/misc/lkdtm/Makefile             |    1 
 lib/Makefile                            |    2 
 mm/highmem.c                            |  157 ++++++++++++++++++++++
 tools/testing/selftests/lkdtm/tests.txt |    1 
 5 files changed, 162 insertions(+)

--- a/arch/riscv/Kconfig~linux-next-rejects
+++ a/arch/riscv/Kconfig
@@ -27,6 +27,7 @@ config RISCV
 	select ARCH_HAS_GIGANTIC_PAGE
 	select ARCH_HAS_KCOV
 	select ARCH_HAS_MMIOWB
+	select ARCH_STACKWALK
 	select ARCH_HAS_PTE_SPECIAL
 	select ARCH_HAS_SET_DIRECT_MAP
 	select ARCH_HAS_SET_MEMORY
--- a/drivers/misc/lkdtm/Makefile~linux-next-rejects
+++ a/drivers/misc/lkdtm/Makefile
@@ -11,6 +11,7 @@ lkdtm-$(CONFIG_LKDTM)		+= usercopy.o
 lkdtm-$(CONFIG_LKDTM)		+= stackleak.o
 lkdtm-$(CONFIG_LKDTM)		+= cfi.o
 lkdtm-$(CONFIG_LKDTM)		+= fortify.o
+lkdtm-$(CONFIG_PPC_BOOK3S_64)	+= powerpc.o
 
 KASAN_SANITIZE_rodata.o		:= n
 KASAN_SANITIZE_stackleak.o	:= n
--- a/lib/Makefile~linux-next-rejects
+++ a/lib/Makefile
@@ -354,3 +354,5 @@ obj-$(CONFIG_BITS_TEST) += bits_kunit.o
 obj-$(CONFIG_CMDLINE_KUNIT_TEST) += cmdline_kunit.o
 obj-$(CONFIG_LINEAR_RANGES_TEST) += linear_ranges_kunit.o
 obj-$(CONFIG_LIST_KUNIT_TEST) += list_kunit.o
+
+obj-$(CONFIG_GENERIC_LIB_DEVMEM_IS_ALLOWED) += devmem_is_allowed.o
--- a/mm/highmem.c~linux-next-rejects
+++ a/mm/highmem.c
@@ -420,6 +420,163 @@ EXPORT_SYMBOL(zero_user_segments);
 
 #include <asm/kmap_size.h>
 
+static DEFINE_PER_CPU(int, __kmap_local_idx);
+
+/*
+ * With DEBUG_HIGHMEM the stack depth is doubled and every second
+ * slot is unused which acts as a guard page
+ */
+#ifdef CONFIG_DEBUG_HIGHMEM
+# define KM_INCR	2
+#else
+# define KM_INCR	1
+#endif
+
+static inline int kmap_local_idx_push(void)
+{
+	int idx = __this_cpu_add_return(__kmap_local_idx, KM_INCR) - 1;
+
+	WARN_ON_ONCE(in_irq() && !irqs_disabled());
+	BUG_ON(idx >= KM_MAX_IDX);
+	return idx;
+}
+
+static inline int kmap_local_idx(void)
+{
+	return __this_cpu_read(__kmap_local_idx) - 1;
+}
+
+static inline void kmap_local_idx_pop(void)
+{
+	int idx = __this_cpu_sub_return(__kmap_local_idx, KM_INCR);
+
+	BUG_ON(idx < 0);
+}
+
+#ifndef arch_kmap_local_post_map
+# define arch_kmap_local_post_map(vaddr, pteval)	do { } while (0)
+#endif
+
+#ifndef arch_kmap_local_pre_unmap
+# define arch_kmap_local_pre_unmap(vaddr)		do { } while (0)
+#endif
+
+#ifndef arch_kmap_local_post_unmap
+# define arch_kmap_local_post_unmap(vaddr)		do { } while (0)
+#endif
+
+#ifndef arch_kmap_local_map_idx
+#define arch_kmap_local_map_idx(idx, pfn)	kmap_local_calc_idx(idx)
+#endif
+
+#ifndef arch_kmap_local_unmap_idx
+#define arch_kmap_local_unmap_idx(idx, vaddr)	kmap_local_calc_idx(idx)
+#endif
+
+#ifndef arch_kmap_local_high_get
+static inline void *arch_kmap_local_high_get(struct page *page)
+{
+	return NULL;
+}
+#endif
+
+/* Unmap a local mapping which was obtained by kmap_high_get() */
+static inline bool kmap_high_unmap_local(unsigned long vaddr)
+{
+#ifdef ARCH_NEEDS_KMAP_HIGH_GET
+	if (vaddr >= PKMAP_ADDR(0) && vaddr < PKMAP_ADDR(LAST_PKMAP)) {
+		kunmap_high(pte_page(pkmap_page_table[PKMAP_NR(vaddr)]));
+		return true;
+	}
+#endif
+	return false;
+}
+
+static inline int kmap_local_calc_idx(int idx)
+{
+	return idx + KM_MAX_IDX * smp_processor_id();
+}
+
+static pte_t *__kmap_pte;
+
+static pte_t *kmap_get_pte(void)
+{
+	if (!__kmap_pte)
+		__kmap_pte = virt_to_kpte(__fix_to_virt(FIX_KMAP_BEGIN));
+	return __kmap_pte;
+}
+
+void *__kmap_local_pfn_prot(unsigned long pfn, pgprot_t prot)
+{
+	pte_t pteval, *kmap_pte = kmap_get_pte();
+	unsigned long vaddr;
+	int idx;
+
+	preempt_disable();
+	idx = arch_kmap_local_map_idx(kmap_local_idx_push(), pfn);
+	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
+	BUG_ON(!pte_none(*(kmap_pte - idx)));
+	pteval = pfn_pte(pfn, prot);
+	set_pte_at(&init_mm, vaddr, kmap_pte - idx, pteval);
+	arch_kmap_local_post_map(vaddr, pteval);
+	preempt_enable();
+
+	return (void *)vaddr;
+}
+EXPORT_SYMBOL_GPL(__kmap_local_pfn_prot);
+
+void *__kmap_local_page_prot(struct page *page, pgprot_t prot)
+{
+	void *kmap;
+
+	if (!PageHighMem(page))
+		return page_address(page);
+
+	/* Try kmap_high_get() if architecture has it enabled */
+	kmap = arch_kmap_local_high_get(page);
+	if (kmap)
+		return kmap;
+
+	return __kmap_local_pfn_prot(page_to_pfn(page), prot);
+}
+EXPORT_SYMBOL(__kmap_local_page_prot);
+
+void kunmap_local_indexed(void *vaddr)
+{
+	unsigned long addr = (unsigned long) vaddr & PAGE_MASK;
+	pte_t *kmap_pte = kmap_get_pte();
+	int idx;
+
+	if (addr < __fix_to_virt(FIX_KMAP_END) ||
+	    addr > __fix_to_virt(FIX_KMAP_BEGIN)) {
+		/*
+		 * Handle mappings which were obtained by kmap_high_get()
+		 * first as the virtual address of such mappings is below
+		 * PAGE_OFFSET. Warn for all other addresses which are in
+		 * the user space part of the virtual address space.
+		 */
+		if (!kmap_high_unmap_local(addr))
+			WARN_ON_ONCE(addr < PAGE_OFFSET);
+		return;
+	}
+
+	preempt_disable();
+	idx = arch_kmap_local_unmap_idx(kmap_local_idx(), addr);
+	WARN_ON_ONCE(addr != __fix_to_virt(FIX_KMAP_BEGIN + idx));
+
+	arch_kmap_local_pre_unmap(addr);
+	pte_clear(&init_mm, addr, kmap_pte - idx);
+	arch_kmap_local_post_unmap(addr);
+	kmap_local_idx_pop();
+	preempt_enable();
+}
+EXPORT_SYMBOL(kunmap_local_indexed);
+#endif
+
+#ifdef CONFIG_KMAP_LOCAL
+
+#include <asm/kmap_size.h>
+
 /*
  * With DEBUG_KMAP_LOCAL the stack depth is doubled and every second
  * slot is unused which acts as a guard page
--- a/tools/testing/selftests/lkdtm/tests.txt~linux-next-rejects
+++ a/tools/testing/selftests/lkdtm/tests.txt
@@ -69,3 +69,4 @@ USERCOPY_KERNEL
 STACKLEAK_ERASING OK: the rest of the thread stack is properly erased
 CFI_FORWARD_PROTO
 FORTIFIED_STRSCPY
+PPC_SLB_MULTIHIT Recovered
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-fix-initialization-of-struct-page-for-holes-in-memory-layout-checkpatch-fixes.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
kmap-stupid-hacks-to-make-it-compile.patch
epoll-wire-up-syscall-epoll_pwait2-fix.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages-fix.patch
arch-mm-wire-up-memfd_secret-system-call-were-relevant-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

