Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5ADAC76195
	for <mm-commits@archiver.kernel.org>; Fri, 17 Mar 2023 19:01:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbjCQTBL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 17 Mar 2023 15:01:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbjCQTBG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Mar 2023 15:01:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 124E89EC2
        for <mm-commits@vger.kernel.org>; Fri, 17 Mar 2023 12:00:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DCCD161230
        for <mm-commits@vger.kernel.org>; Fri, 17 Mar 2023 19:00:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32FC0C4339C;
        Fri, 17 Mar 2023 19:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679079642;
        bh=oEsn4BjWKpqyfDWzVnHyDalzN7DCtm/edbYsw/E48fE=;
        h=Date:To:From:Subject:From;
        b=cXbctOqzjcUSHe+OovLEh1n6ekedG0Q7AjllR2X5/GAmpjodcLXchz4excbcUvAnQ
         DKo8/DYR85ivO9N+HI315gnk96fkmEUpHv7mddvUzvvqppw6sX+TcQJhDuZFEbyExt
         M635Q2SOdQpWIQkwbSY0D0eS7OyfcOK8zA7EvT54=
Date:   Fri, 17 Mar 2023 12:00:41 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        wangkefeng.wang@huawei.com, robin.murphy@arm.com,
        quic_pkondeti@quicinc.com, mark.rutland@arm.com,
        jianyong.wu@arm.com, james.morse@arm.com, glider@google.com,
        elver@google.com, dvyukov@google.com, catalin.marinas@arm.com,
        quic_zhenhuah@quicinc.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mmkfence-decouple-kfence-from-page-granularity-mapping-judgement.patch added to mm-unstable branch
Message-Id: <20230317190042.32FC0C4339C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,kfence: decouple kfence from page granularity mapping judgement
has been added to the -mm mm-unstable branch.  Its filename is
     mmkfence-decouple-kfence-from-page-granularity-mapping-judgement.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmkfence-decouple-kfence-from-page-granularity-mapping-judgement.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Zhenhua Huang <quic_zhenhuah@quicinc.com>
Subject: mm,kfence: decouple kfence from page granularity mapping judgement
Date: Fri, 17 Mar 2023 23:29:34 +0800

Kfence only needs its pool to be mapped as page granularity, if it is
inited early.  Previous judgement was a bit over protected.  From [1],
Mark suggested to "just map the KFENCE region a page granularity".  So I
decouple it from judgement and do page granularity mapping for kfence pool
only.  Need to be noticed that late init of kfence pool still requires
page granularity mapping.

Page granularity mapping in theory cost more(2M per 1GB) memory on arm64
platform.  Like what I've tested on QEMU(emulated 1GB RAM) with
gki_defconfig, also turning off rodata protection:

Before:
[root@liebao ]# cat /proc/meminfo
MemTotal:         999484 kB
After:
[root@liebao ]# cat /proc/meminfo
MemTotal:        1001480 kB

To implement this, also relocate the kfence pool allocation before the
linear mapping setting up, arm64_kfence_alloc_pool is to allocate phys
addr, __kfence_pool is to be set after linear mapping set up.

Link: https://lore.kernel.org/linux-arm-kernel/Y+IsdrvDNILA59UN@FVFF77S0Q05N/ [1]
Link: https://lkml.kernel.org/r/1679066974-690-1-git-send-email-quic_zhenhuah@quicinc.com
Signed-off-by: Zhenhua Huang <quic_zhenhuah@quicinc.com>
Suggested-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: James Morse <james.morse@arm.com>
Cc: Jianyong Wu <jianyong.wu@arm.com>
Cc: Pavankumar Kondeti <quic_pkondeti@quicinc.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/arch/arm64/include/asm/kfence.h~mmkfence-decouple-kfence-from-page-granularity-mapping-judgement
+++ a/arch/arm64/include/asm/kfence.h
@@ -19,4 +19,14 @@ static inline bool kfence_protect_page(u
 	return true;
 }
 
+#ifdef CONFIG_KFENCE
+extern bool kfence_early_init;
+static inline bool arm64_kfence_can_set_direct_map(void)
+{
+	return !kfence_early_init;
+}
+#else /* CONFIG_KFENCE */
+static inline bool arm64_kfence_can_set_direct_map(void) { return false; }
+#endif /* CONFIG_KFENCE */
+
 #endif /* __ASM_KFENCE_H */
--- a/arch/arm64/mm/mmu.c~mmkfence-decouple-kfence-from-page-granularity-mapping-judgement
+++ a/arch/arm64/mm/mmu.c
@@ -24,6 +24,7 @@
 #include <linux/mm.h>
 #include <linux/vmalloc.h>
 #include <linux/set_memory.h>
+#include <linux/kfence.h>
 
 #include <asm/barrier.h>
 #include <asm/cputype.h>
@@ -38,6 +39,7 @@
 #include <asm/ptdump.h>
 #include <asm/tlbflush.h>
 #include <asm/pgalloc.h>
+#include <asm/kfence.h>
 
 #define NO_BLOCK_MAPPINGS	BIT(0)
 #define NO_CONT_MAPPINGS	BIT(1)
@@ -525,12 +527,67 @@ static int __init enable_crash_mem_map(c
 }
 early_param("crashkernel", enable_crash_mem_map);
 
+#ifdef CONFIG_KFENCE
+
+bool __ro_after_init kfence_early_init = !!CONFIG_KFENCE_SAMPLE_INTERVAL;
+
+/* early_param() will be parsed before map_mem() below. */
+static int __init parse_kfence_early_init(char *arg)
+{
+	int val;
+
+	if (get_option(&arg, &val))
+		kfence_early_init = !!val;
+	return 0;
+}
+early_param("kfence.sample_interval", parse_kfence_early_init);
+
+static phys_addr_t __init arm64_kfence_alloc_pool(void)
+{
+	phys_addr_t kfence_pool;
+
+	if (!kfence_early_init)
+		return 0;
+
+	kfence_pool = memblock_phys_alloc(KFENCE_POOL_SIZE, PAGE_SIZE);
+	if (!kfence_pool) {
+		pr_err("failed to allocate kfence pool\n");
+		kfence_early_init = false;
+		return 0;
+	}
+
+	/* Temporarily mark as NOMAP. */
+	memblock_mark_nomap(kfence_pool, KFENCE_POOL_SIZE);
+
+	return kfence_pool;
+}
+
+static void __init arm64_kfence_map_pool(phys_addr_t kfence_pool, pgd_t *pgdp)
+{
+	if (!kfence_pool)
+		return;
+
+	/* KFENCE pool needs page-level mapping. */
+	__map_memblock(pgdp, kfence_pool, kfence_pool + KFENCE_POOL_SIZE,
+			pgprot_tagged(PAGE_KERNEL),
+			NO_BLOCK_MAPPINGS | NO_CONT_MAPPINGS);
+	memblock_clear_nomap(kfence_pool, KFENCE_POOL_SIZE);
+	__kfence_pool = phys_to_virt(kfence_pool);
+}
+#else /* CONFIG_KFENCE */
+
+static inline phys_addr_t arm64_kfence_alloc_pool(void) { return 0; }
+static inline void arm64_kfence_map_pool(phys_addr_t kfence_pool, pgd_t *pgdp) { }
+
+#endif /* CONFIG_KFENCE */
+
 static void __init map_mem(pgd_t *pgdp)
 {
 	static const u64 direct_map_end = _PAGE_END(VA_BITS_MIN);
 	phys_addr_t kernel_start = __pa_symbol(_stext);
 	phys_addr_t kernel_end = __pa_symbol(__init_begin);
 	phys_addr_t start, end;
+	phys_addr_t early_kfence_pool;
 	int flags = NO_EXEC_MAPPINGS;
 	u64 i;
 
@@ -543,6 +600,8 @@ static void __init map_mem(pgd_t *pgdp)
 	 */
 	BUILD_BUG_ON(pgd_index(direct_map_end - 1) == pgd_index(direct_map_end));
 
+	early_kfence_pool = arm64_kfence_alloc_pool();
+
 	if (can_set_direct_map())
 		flags |= NO_BLOCK_MAPPINGS | NO_CONT_MAPPINGS;
 
@@ -608,6 +667,8 @@ static void __init map_mem(pgd_t *pgdp)
 		}
 	}
 #endif
+
+	arm64_kfence_map_pool(early_kfence_pool, pgdp);
 }
 
 void mark_rodata_ro(void)
--- a/arch/arm64/mm/pageattr.c~mmkfence-decouple-kfence-from-page-granularity-mapping-judgement
+++ a/arch/arm64/mm/pageattr.c
@@ -11,6 +11,7 @@
 #include <asm/cacheflush.h>
 #include <asm/set_memory.h>
 #include <asm/tlbflush.h>
+#include <asm/kfence.h>
 
 struct page_change_data {
 	pgprot_t set_mask;
@@ -22,12 +23,14 @@ bool rodata_full __ro_after_init = IS_EN
 bool can_set_direct_map(void)
 {
 	/*
-	 * rodata_full, DEBUG_PAGEALLOC and KFENCE require linear map to be
+	 * rodata_full and DEBUG_PAGEALLOC require linear map to be
 	 * mapped at page granularity, so that it is possible to
 	 * protect/unprotect single pages.
+	 *
+	 * KFENCE pool requires page-granular mapping if initialized late.
 	 */
 	return (rodata_enabled && rodata_full) || debug_pagealloc_enabled() ||
-		IS_ENABLED(CONFIG_KFENCE);
+		arm64_kfence_can_set_direct_map();
 }
 
 static int change_page_range(pte_t *ptep, unsigned long addr, void *data)
--- a/mm/kfence/core.c~mmkfence-decouple-kfence-from-page-granularity-mapping-judgement
+++ a/mm/kfence/core.c
@@ -818,6 +818,10 @@ void __init kfence_alloc_pool(void)
 	if (!kfence_sample_interval)
 		return;
 
+	/* if the pool has already been initialized by arch, skip the below. */
+	if (__kfence_pool)
+		return;
+
 	__kfence_pool = memblock_alloc(KFENCE_POOL_SIZE, PAGE_SIZE);
 
 	if (!__kfence_pool)
_

Patches currently in -mm which might be from quic_zhenhuah@quicinc.com are

mmkfence-decouple-kfence-from-page-granularity-mapping-judgement.patch

