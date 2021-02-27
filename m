Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48B19C4332B
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:31:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1BCF064F2A
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:31:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbhB0CbS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Feb 2021 21:31:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:51610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230132AbhB0Ca5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Feb 2021 21:30:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E10C64F13;
        Sat, 27 Feb 2021 02:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614393032;
        bh=vs69OuqvZrstaFsoVWcutyluJISfqpWtqFHxwUShHBQ=;
        h=Date:From:To:Subject:From;
        b=hyFmN0hiaF9S26gKrJ2XT41fZ4kKnKm/LneznWXOdDycuwSGMUr989cbX9sjaixLI
         GQpaXdRxxzRopNU/mOXWWcxgWBuE0fZl4jwPY23Rjd32lJOnA2KhubW33P6PTSG5/P
         whmfYa+zVHKEINghvMIRds2SaQdaWK0Q5p5DL/Gg=
Date:   Fri, 26 Feb 2021 18:30:31 -0800
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
Subject:  [merged] x86-kfence-enable-kfence-for-x86.patch removed
 from -mm tree
Message-ID: <20210227023031.kF8WwpOgx%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: x86, kfence: enable KFENCE for x86
has been removed from the -mm tree.  Its filename was
     x86-kfence-enable-kfence-for-x86.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexander Potapenko <glider@google.com>
Subject: x86, kfence: enable KFENCE for x86

Add architecture specific implementation details for KFENCE and enable
KFENCE for the x86 architecture. In particular, this implements the
required interface in <asm/kfence.h> for setting up the pool and
providing helper functions for protecting and unprotecting pages.

For x86, we need to ensure that the pool uses 4K pages, which is done
using the set_memory_4k() helper function.

[elver@google.com: add missing copyright and description header]
  Link: https://lkml.kernel.org/r/20210118092159.145934-2-elver@google.com
Link: https://lkml.kernel.org/r/20201103175841.3495947-3-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Signed-off-by: Alexander Potapenko <glider@google.com>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Co-developed-by: Marco Elver <elver@google.com>
Reviewed-by: Jann Horn <jannh@google.com>
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
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: SeongJae Park <sjpark@amazon.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig              |    1 
 arch/x86/include/asm/kfence.h |   70 ++++++++++++++++++++++++++++++++
 arch/x86/mm/fault.c           |    5 ++
 3 files changed, 76 insertions(+)

--- /dev/null
+++ a/arch/x86/include/asm/kfence.h
@@ -0,0 +1,70 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * x86 KFENCE support.
+ *
+ * Copyright (C) 2020, Google LLC.
+ */
+
+#ifndef _ASM_X86_KFENCE_H
+#define _ASM_X86_KFENCE_H
+
+#include <linux/bug.h>
+#include <linux/kfence.h>
+
+#include <asm/pgalloc.h>
+#include <asm/pgtable.h>
+#include <asm/set_memory.h>
+#include <asm/tlbflush.h>
+
+/*
+ * The page fault handler entry function, up to which the stack trace is
+ * truncated in reports.
+ */
+#define KFENCE_SKIP_ARCH_FAULT_HANDLER "asm_exc_page_fault"
+
+/* Force 4K pages for __kfence_pool. */
+static inline bool arch_kfence_init_pool(void)
+{
+	unsigned long addr;
+
+	for (addr = (unsigned long)__kfence_pool; is_kfence_address((void *)addr);
+	     addr += PAGE_SIZE) {
+		unsigned int level;
+
+		if (!lookup_address(addr, &level))
+			return false;
+
+		if (level != PG_LEVEL_4K)
+			set_memory_4k(addr, 1);
+	}
+
+	return true;
+}
+
+/* Protect the given page and flush TLB. */
+static inline bool kfence_protect_page(unsigned long addr, bool protect)
+{
+	unsigned int level;
+	pte_t *pte = lookup_address(addr, &level);
+
+	if (WARN_ON(!pte || level != PG_LEVEL_4K))
+		return false;
+
+	/*
+	 * We need to avoid IPIs, as we may get KFENCE allocations or faults
+	 * with interrupts disabled. Therefore, the below is best-effort, and
+	 * does not flush TLBs on all CPUs. We can tolerate some inaccuracy;
+	 * lazy fault handling takes care of faults after the page is PRESENT.
+	 */
+
+	if (protect)
+		set_pte(pte, __pte(pte_val(*pte) & ~_PAGE_PRESENT));
+	else
+		set_pte(pte, __pte(pte_val(*pte) | _PAGE_PRESENT));
+
+	/* Flush this CPU's TLB. */
+	flush_tlb_one_kernel(addr);
+	return true;
+}
+
+#endif /* _ASM_X86_KFENCE_H */
--- a/arch/x86/Kconfig~x86-kfence-enable-kfence-for-x86
+++ a/arch/x86/Kconfig
@@ -151,6 +151,7 @@ config X86
 	select HAVE_ARCH_JUMP_LABEL_RELATIVE
 	select HAVE_ARCH_KASAN			if X86_64
 	select HAVE_ARCH_KASAN_VMALLOC		if X86_64
+	select HAVE_ARCH_KFENCE
 	select HAVE_ARCH_KGDB
 	select HAVE_ARCH_MMAP_RND_BITS		if MMU
 	select HAVE_ARCH_MMAP_RND_COMPAT_BITS	if MMU && COMPAT
--- a/arch/x86/mm/fault.c~x86-kfence-enable-kfence-for-x86
+++ a/arch/x86/mm/fault.c
@@ -9,6 +9,7 @@
 #include <linux/kdebug.h>		/* oops_begin/end, ...		*/
 #include <linux/extable.h>		/* search_exception_tables	*/
 #include <linux/memblock.h>		/* max_low_pfn			*/
+#include <linux/kfence.h>		/* kfence_handle_page_fault	*/
 #include <linux/kprobes.h>		/* NOKPROBE_SYMBOL, ...		*/
 #include <linux/mmiotrace.h>		/* kmmio_handler, ...		*/
 #include <linux/perf_event.h>		/* perf_sw_event		*/
@@ -680,6 +681,10 @@ page_fault_oops(struct pt_regs *regs, un
 	if (IS_ENABLED(CONFIG_EFI))
 		efi_crash_gracefully_on_page_fault(address);
 
+	/* Only not-present faults should be handled by KFENCE. */
+	if (!(error_code & X86_PF_PROT) && kfence_handle_page_fault(address))
+		return;
+
 oops:
 	/*
 	 * Oops. The kernel tried to access some bad page. We'll have to
_

Patches currently in -mm which might be from glider@google.com are


