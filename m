Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0986C433F5
	for <mm-commits@archiver.kernel.org>; Sun, 10 Oct 2021 21:37:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F84360F24
	for <mm-commits@archiver.kernel.org>; Sun, 10 Oct 2021 21:37:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232631AbhJJVjU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 10 Oct 2021 17:39:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:59466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230271AbhJJVjU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 10 Oct 2021 17:39:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED5B760E74;
        Sun, 10 Oct 2021 21:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633901841;
        bh=/at2Qmg7wadSfU39N7dkYAlRTm5cAUCOr/6oBSWrFEI=;
        h=Date:From:To:Subject:From;
        b=GgO/1+vJPnNXp3jI33iVyPN3AETkWBHNIU7sI80JdS8PHRuRhkIko+NX/5UD1+Rlk
         mfLDVJ7tlSjBlVPwUZactm9AHhrggyViMqQ44j1R8MuW0XYU4vLwzHnpUscG8Tzri6
         gOHRgVkMYNkcFjqSJX1NayzINT98zwOkx8AFgvOg=
Date:   Sun, 10 Oct 2021 14:37:20 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, catalin.marinas@arm.com, dvyukov@google.com,
        elver@google.com, gregkh@linuxfoundation.org,
        mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        wangkefeng.wang@huawei.com, will@kernel.org
Subject:  +
 arm64-support-page-mapping-percpu-first-chunk-allocator.patch added to -mm
 tree
Message-ID: <20211010213720.dmzKRLFf4%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm64: support page mapping percpu first chunk allocator
has been added to the -mm tree.  Its filename is
     arm64-support-page-mapping-percpu-first-chunk-allocator.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/arm64-support-page-mapping-percpu-first-chunk-allocator.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/arm64-support-page-mapping-percpu-first-chunk-allocator.patch

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
Subject: arm64: support page mapping percpu first chunk allocator

Percpu embedded first chunk allocator is the firstly option, but it
could fails on ARM64, eg,
  "percpu: max_distance=0x5fcfdc640000 too large for vmalloc space 0x781fefff0000"
  "percpu: max_distance=0x600000540000 too large for vmalloc space 0x7dffb7ff0000"
  "percpu: max_distance=0x5fff9adb0000 too large for vmalloc space 0x5dffb7ff0000"

then we could meet "WARNING: CPU: 15 PID: 461 at vmalloc.c:3087
pcpu_get_vm_areas+0x488/0x838" and the system could not boot successfully.

Let's implement page mapping percpu first chunk allocator as a fallback to
the embedding allocator to increase the robustness of the system.

Link: https://lkml.kernel.org/r/20210910053354.26721-3-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Marco Elver <elver@google.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/Kconfig       |    4 +
 drivers/base/arch_numa.c |   82 ++++++++++++++++++++++++++++++++-----
 2 files changed, 76 insertions(+), 10 deletions(-)

--- a/arch/arm64/Kconfig~arm64-support-page-mapping-percpu-first-chunk-allocator
+++ a/arch/arm64/Kconfig
@@ -1042,6 +1042,10 @@ config NEED_PER_CPU_EMBED_FIRST_CHUNK
 	def_bool y
 	depends on NUMA
 
+config NEED_PER_CPU_PAGE_FIRST_CHUNK
+	def_bool y
+	depends on NUMA
+
 source "kernel/Kconfig.hz"
 
 config ARCH_SPARSEMEM_ENABLE
--- a/drivers/base/arch_numa.c~arm64-support-page-mapping-percpu-first-chunk-allocator
+++ a/drivers/base/arch_numa.c
@@ -14,6 +14,7 @@
 #include <linux/of.h>
 
 #include <asm/sections.h>
+#include <asm/pgalloc.h>
 
 struct pglist_data *node_data[MAX_NUMNODES] __read_mostly;
 EXPORT_SYMBOL(node_data);
@@ -168,22 +169,83 @@ static void __init pcpu_fc_free(void *pt
 	memblock_free_early(__pa(ptr), size);
 }
 
+#ifdef CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK
+static void __init pcpu_populate_pte(unsigned long addr)
+{
+	pgd_t *pgd = pgd_offset_k(addr);
+	p4d_t *p4d;
+	pud_t *pud;
+	pmd_t *pmd;
+
+	p4d = p4d_offset(pgd, addr);
+	if (p4d_none(*p4d)) {
+		pud_t *new;
+
+		new = memblock_alloc(PAGE_SIZE, PAGE_SIZE);
+		if (!new)
+			goto err_alloc;
+		p4d_populate(&init_mm, p4d, new);
+	}
+
+	pud = pud_offset(p4d, addr);
+	if (pud_none(*pud)) {
+		pmd_t *new;
+
+		new = memblock_alloc(PAGE_SIZE, PAGE_SIZE);
+		if (!new)
+			goto err_alloc;
+		pud_populate(&init_mm, pud, new);
+	}
+
+	pmd = pmd_offset(pud, addr);
+	if (!pmd_present(*pmd)) {
+		pte_t *new;
+
+		new = memblock_alloc(PAGE_SIZE, PAGE_SIZE);
+		if (!new)
+			goto err_alloc;
+		pmd_populate_kernel(&init_mm, pmd, new);
+	}
+
+	return;
+
+err_alloc:
+	panic("%s: Failed to allocate %lu bytes align=%lx from=%lx\n",
+	      __func__, PAGE_SIZE, PAGE_SIZE, PAGE_SIZE);
+}
+#endif
+
 void __init setup_per_cpu_areas(void)
 {
 	unsigned long delta;
 	unsigned int cpu;
-	int rc;
+	int rc = -EINVAL;
 
-	/*
-	 * Always reserve area for module percpu variables.  That's
-	 * what the legacy allocator did.
-	 */
-	rc = pcpu_embed_first_chunk(PERCPU_MODULE_RESERVE,
-				    PERCPU_DYNAMIC_RESERVE, PAGE_SIZE,
-				    pcpu_cpu_distance,
-				    pcpu_fc_alloc, pcpu_fc_free);
+	if (pcpu_chosen_fc != PCPU_FC_PAGE) {
+		/*
+		 * Always reserve area for module percpu variables.  That's
+		 * what the legacy allocator did.
+		 */
+		rc = pcpu_embed_first_chunk(PERCPU_MODULE_RESERVE,
+					    PERCPU_DYNAMIC_RESERVE, PAGE_SIZE,
+					    pcpu_cpu_distance,
+					    pcpu_fc_alloc, pcpu_fc_free);
+#ifdef CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK
+		if (rc < 0)
+			pr_warn("PERCPU: %s allocator failed (%d), falling back to page size\n",
+				   pcpu_fc_names[pcpu_chosen_fc], rc);
+#endif
+	}
+
+#ifdef CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK
+	if (rc < 0)
+		rc = pcpu_page_first_chunk(PERCPU_MODULE_RESERVE,
+					   pcpu_fc_alloc,
+					   pcpu_fc_free,
+					   pcpu_populate_pte);
+#endif
 	if (rc < 0)
-		panic("Failed to initialize percpu areas.");
+		panic("Failed to initialize percpu areas (err=%d).", rc);
 
 	delta = (unsigned long)pcpu_base_addr - (unsigned long)__per_cpu_start;
 	for_each_possible_cpu(cpu)
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

