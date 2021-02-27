Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 504F5C43331
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:31:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3166964F46
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:31:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbhB0CbT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Feb 2021 21:31:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:51608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230183AbhB0Ca6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Feb 2021 21:30:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E73A64F2B;
        Sat, 27 Feb 2021 02:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614393035;
        bh=xvax4gRuOsuwLi83uk0LMdz4CbqUjkwLT1n5aIIXr38=;
        h=Date:From:To:Subject:From;
        b=dnOh0av85673RGvVCr9QTx5F8fnRygTSwBQKmYdeSCE/r7qyEoNm/Ls5aVrwF9Niq
         jsO5380p6USQjujVgdk8mYQLnnJ9wdMXfdWeCh+LVGqZtx7Xe3GT3umHS+ylHAvRSt
         q50KCakweIaVb2t3H3IuDhKnDmjuSt9LsUmwwJlU=
Date:   Fri, 26 Feb 2021 18:30:34 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com, bp@alien8.de,
        catalin.marinas@arm.com, cl@linux.com, corbet@lwn.net,
        dave.hansen@linux.intel.com, dvyukov@google.com,
        edumazet@google.com, elver@google.com, glider@google.com,
        gregkh@linuxfoundation.org, hdanton@sina.com, hpa@zytor.com,
        iamjoonsoo.kim@lge.com, jannh@google.com, joern@purestorage.com,
        keescook@chromium.org, luto@kernel.org, mark.rutland@arm.com,
        mingo@redhat.com, mm-commits@vger.kernel.org, paulmck@kernel.org,
        penberg@kernel.org, peterz@infradead.org, rientjes@google.com,
        sjpark@amazon.de, tglx@linutronix.de, vbabka@suse.cz,
        will@kernel.org
Subject:  [merged] arm64-kfence-enable-kfence-for-arm64.patch
 removed from -mm tree
Message-ID: <20210227023034.CI55w2OSF%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm64, kfence: enable KFENCE for ARM64
has been removed from the -mm tree.  Its filename was
     arm64-kfence-enable-kfence-for-arm64.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Marco Elver <elver@google.com>
Subject: arm64, kfence: enable KFENCE for ARM64

Add architecture specific implementation details for KFENCE and enable
KFENCE for the arm64 architecture. In particular, this implements the
required interface in <asm/kfence.h>.

KFENCE requires that attributes for pages from its memory pool can
individually be set. Therefore, force the entire linear map to be mapped
at page granularity. Doing so may result in extra memory allocated for
page tables in case rodata=full is not set; however, currently
CONFIG_RODATA_FULL_DEFAULT_ENABLED=y is the default, and the common case
is therefore not affected by this change.

[elver@google.com: add missing copyright and description header]
  Link: https://lkml.kernel.org/r/20210118092159.145934-3-elver@google.com
Link: https://lkml.kernel.org/r/20201103175841.3495947-4-elver@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Signed-off-by: Marco Elver <elver@google.com>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Co-developed-by: Alexander Potapenko <glider@google.com>
Reviewed-by: Jann Horn <jannh@google.com>
Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christopher Lameter <cl@linux.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hillf Danton <hdanton@sina.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Joern Engel <joern@purestorage.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: SeongJae Park <sjpark@amazon.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/Kconfig              |    1 +
 arch/arm64/include/asm/kfence.h |   24 ++++++++++++++++++++++++
 arch/arm64/mm/fault.c           |    4 ++++
 arch/arm64/mm/mmu.c             |    8 +++++++-
 4 files changed, 36 insertions(+), 1 deletion(-)

--- /dev/null
+++ a/arch/arm64/include/asm/kfence.h
@@ -0,0 +1,24 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * arm64 KFENCE support.
+ *
+ * Copyright (C) 2020, Google LLC.
+ */
+
+#ifndef __ASM_KFENCE_H
+#define __ASM_KFENCE_H
+
+#include <asm/cacheflush.h>
+
+#define KFENCE_SKIP_ARCH_FAULT_HANDLER "el1_sync"
+
+static inline bool arch_kfence_init_pool(void) { return true; }
+
+static inline bool kfence_protect_page(unsigned long addr, bool protect)
+{
+	set_memory_valid(addr, 1, !protect);
+
+	return true;
+}
+
+#endif /* __ASM_KFENCE_H */
--- a/arch/arm64/Kconfig~arm64-kfence-enable-kfence-for-arm64
+++ a/arch/arm64/Kconfig
@@ -140,6 +140,7 @@ config ARM64
 	select HAVE_ARCH_KASAN if !(ARM64_16K_PAGES && ARM64_VA_BITS_48)
 	select HAVE_ARCH_KASAN_SW_TAGS if HAVE_ARCH_KASAN
 	select HAVE_ARCH_KASAN_HW_TAGS if (HAVE_ARCH_KASAN && ARM64_MTE)
+	select HAVE_ARCH_KFENCE
 	select HAVE_ARCH_KGDB
 	select HAVE_ARCH_MMAP_RND_BITS
 	select HAVE_ARCH_MMAP_RND_COMPAT_BITS if COMPAT
--- a/arch/arm64/mm/fault.c~arm64-kfence-enable-kfence-for-arm64
+++ a/arch/arm64/mm/fault.c
@@ -10,6 +10,7 @@
 #include <linux/acpi.h>
 #include <linux/bitfield.h>
 #include <linux/extable.h>
+#include <linux/kfence.h>
 #include <linux/signal.h>
 #include <linux/mm.h>
 #include <linux/hardirq.h>
@@ -389,6 +390,9 @@ static void __do_kernel_fault(unsigned l
 	} else if (addr < PAGE_SIZE) {
 		msg = "NULL pointer dereference";
 	} else {
+		if (kfence_handle_page_fault(addr))
+			return;
+
 		msg = "paging request";
 	}
 
--- a/arch/arm64/mm/mmu.c~arm64-kfence-enable-kfence-for-arm64
+++ a/arch/arm64/mm/mmu.c
@@ -1465,7 +1465,13 @@ int arch_add_memory(int nid, u64 start,
 	int ret, flags = 0;
 
 	VM_BUG_ON(!mhp_range_allowed(start, size, true));
-	if (rodata_full || debug_pagealloc_enabled())
+
+	/*
+	 * KFENCE requires linear map to be mapped at page granularity, so that
+	 * it is possible to protect/unprotect single pages in the KFENCE pool.
+	 */
+	if (rodata_full || debug_pagealloc_enabled() ||
+	    IS_ENABLED(CONFIG_KFENCE))
 		flags = NO_BLOCK_MAPPINGS | NO_CONT_MAPPINGS;
 
 	__create_pgd_mapping(swapper_pg_dir, start, __phys_to_virt(start),
_

Patches currently in -mm which might be from elver@google.com are


