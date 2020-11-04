Return-Path: <SRS0=Jp7A=EK=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DED90C2D0A3
	for <mm-commits@archiver.kernel.org>; Wed,  4 Nov 2020 00:41:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 949C022409
	for <mm-commits@archiver.kernel.org>; Wed,  4 Nov 2020 00:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604450482;
	bh=fER7KbFenMwLgbwZrrxI6DCiBHoAwc3lqjVtiqu97Jw=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=u0L7A4tD/681n8X9g581kWaLgAnLZozy1CP9ABeH74qjPs9lYG1p7sCjiTsuRecJP
	 NSRmFNG2eYQM/kYlAVv1z1xS8ADluBuleeTKJMem1KExQwNMcGQnOmqTMy88kBY6G0
	 9a9AJ2aBG/deQtuAMjpAgfr7YICK3Nf+PnMg20kE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729188AbgKDAlW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 3 Nov 2020 19:41:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:50580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725811AbgKDAlW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 3 Nov 2020 19:41:22 -0500
Received: from X1 (unknown [208.106.6.120])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0779122403;
        Wed,  4 Nov 2020 00:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604450481;
        bh=fER7KbFenMwLgbwZrrxI6DCiBHoAwc3lqjVtiqu97Jw=;
        h=Date:From:To:Subject:From;
        b=K94R/D5C5AtxvtKQRKe9VvCCzBYCjVXvjh5lThLd7DeezeCmDJvKR8ziGgoyb5pDb
         S+hlY7d552SW2EHK/h1YXJ31D3T4/ZS2HHa4i/4EZq7TD4r48mVoWKb/G60DXWEa2s
         t0ShdHvp41gi2NE5E0GXmBYSV8BYboC5aWMk4ITM=
Date:   Tue, 03 Nov 2020 16:41:19 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, will@kernel.org, vbabka@suse.cz,
        tglx@linutronix.de, sjpark@amazon.de, rientjes@google.com,
        peterz@infradead.org, penberg@kernel.org, paulmck@kernel.org,
        mingo@redhat.com, mark.rutland@arm.com, luto@kernel.org,
        keescook@chromium.org, joern@purestorage.com, jannh@google.com,
        iamjoonsoo.kim@lge.com, hpa@zytor.com, hdanton@sina.com,
        gregkh@linuxfoundation.org, elver@google.com, edumazet@google.com,
        dvyukov@google.com, dave.hansen@linux.intel.com, corbet@lwn.net,
        cl@linux.com, catalin.marinas@arm.com, bp@alien8.de,
        aryabinin@virtuozzo.com, andreyknvl@google.com, glider@google.com
Subject:  + x86-kfence-enable-kfence-for-x86.patch added to -mm tree
Message-ID: <20201104004119.0UsTH%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: x86, kfence: enable KFENCE for x86
has been added to the -mm tree.  Its filename is
     x86-kfence-enable-kfence-for-x86.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/x86-kfence-enable-kfence-for-x86.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/x86-kfence-enable-kfence-for-x86.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexander Potapenko <glider@google.com>
Subject: x86, kfence: enable KFENCE for x86

Add architecture specific implementation details for KFENCE and enable
KFENCE for the x86 architecture. In particular, this implements the
required interface in <asm/kfence.h> for setting up the pool and
providing helper functions for protecting and unprotecting pages.

For x86, we need to ensure that the pool uses 4K pages, which is done
using the set_memory_4k() helper function.

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
 arch/x86/include/asm/kfence.h |   65 ++++++++++++++++++++++++++++++++
 arch/x86/mm/fault.c           |    5 ++
 3 files changed, 71 insertions(+)

--- /dev/null
+++ a/arch/x86/include/asm/kfence.h
@@ -0,0 +1,65 @@
+/* SPDX-License-Identifier: GPL-2.0 */
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
@@ -145,6 +145,7 @@ config X86
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
@@ -725,6 +726,10 @@ no_context(struct pt_regs *regs, unsigne
 	if (IS_ENABLED(CONFIG_EFI))
 		efi_recover_from_page_fault(address);
 
+	/* Only not-present faults should be handled by KFENCE. */
+	if (!(error_code & X86_PF_PROT) && kfence_handle_page_fault(address))
+		return;
+
 oops:
 	/*
 	 * Oops. The kernel tried to access some bad page. We'll have to
_

Patches currently in -mm which might be from glider@google.com are

mm-add-kernel-electric-fence-infrastructure.patch
x86-kfence-enable-kfence-for-x86.patch
mm-kfence-insert-kfence-hooks-for-slab.patch
mm-kfence-insert-kfence-hooks-for-slub.patch
kfence-kasan-make-kfence-compatible-with-kasan.patch

