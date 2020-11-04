Return-Path: <SRS0=Jp7A=EK=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D19AFC388F7
	for <mm-commits@archiver.kernel.org>; Wed,  4 Nov 2020 00:41:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9EF432242A
	for <mm-commits@archiver.kernel.org>; Wed,  4 Nov 2020 00:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604450486;
	bh=cC5UtXaF8JrVAEwmUDsewWYMzLxA5BXlEgEHR2x51+g=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=k9t3lbrX5Tu0hy00ztz6Mzgcc95INASqL1qYHxQN1Iy4oO+Ha2ByqK9eiJDsXYZa7
	 K0n5s5KAO0AN4x73td51LHvOtGmt5wMNQK8E3T3T8qfSU0DmJjHdJWEo2R1QG1r+13
	 PARz0CIxryiDN1dUictyY+QMHCLvGD7Mjx/6ui8Y=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728319AbgKDAl0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 3 Nov 2020 19:41:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:50674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725811AbgKDAl0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 3 Nov 2020 19:41:26 -0500
Received: from X1 (unknown [208.106.6.120])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 078AE223EA;
        Wed,  4 Nov 2020 00:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604450485;
        bh=cC5UtXaF8JrVAEwmUDsewWYMzLxA5BXlEgEHR2x51+g=;
        h=Date:From:To:Subject:From;
        b=MUR8Jdh3xw9dwi4DDEnVwH+2PBoQSEozZnc4CRrax3IuBRu62uks6gRLF4Keuat3I
         cO96EcCENOpmPlBZZnesA4KDsim+TeXQbM4lNUZrX3CRirRcqFyjXFuMtxLoCWU4Kz
         TujCApJyaURxPbLmOOWvTLOeP+hmehwHIcXJmRO0=
Date:   Tue, 03 Nov 2020 16:41:23 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, will@kernel.org, vbabka@suse.cz,
        tglx@linutronix.de, sjpark@amazon.de, rientjes@google.com,
        peterz@infradead.org, penberg@kernel.org, paulmck@kernel.org,
        mingo@redhat.com, mark.rutland@arm.com, luto@kernel.org,
        keescook@chromium.org, joern@purestorage.com, jannh@google.com,
        iamjoonsoo.kim@lge.com, hpa@zytor.com, hdanton@sina.com,
        gregkh@linuxfoundation.org, glider@google.com, edumazet@google.com,
        dvyukov@google.com, dave.hansen@linux.intel.com, corbet@lwn.net,
        cl@linux.com, catalin.marinas@arm.com, bp@alien8.de,
        aryabinin@virtuozzo.com, andreyknvl@google.com, elver@google.com
Subject:  + arm64-kfence-enable-kfence-for-arm64.patch added to -mm
 tree
Message-ID: <20201104004123.EgAcX%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm64, kfence: enable KFENCE for ARM64
has been added to the -mm tree.  Its filename is
     arm64-kfence-enable-kfence-for-arm64.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/arm64-kfence-enable-kfence-for-arm64.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/arm64-kfence-enable-kfence-for-arm64.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Link: https://lkml.kernel.org/r/20201103175841.3495947-4-elver@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Signed-off-by: Marco Elver <elver@google.com>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Co-developed-by: Alexander Potapenko <glider@google.com>
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

 arch/arm64/Kconfig              |    1 +
 arch/arm64/include/asm/kfence.h |   19 +++++++++++++++++++
 arch/arm64/mm/fault.c           |    4 ++++
 arch/arm64/mm/mmu.c             |    7 ++++++-
 4 files changed, 30 insertions(+), 1 deletion(-)

--- /dev/null
+++ a/arch/arm64/include/asm/kfence.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: GPL-2.0 */
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
@@ -137,6 +137,7 @@ config ARM64
 	select HAVE_ARCH_JUMP_LABEL_RELATIVE
 	select HAVE_ARCH_KASAN if !(ARM64_16K_PAGES && ARM64_VA_BITS_48)
 	select HAVE_ARCH_KASAN_SW_TAGS if HAVE_ARCH_KASAN
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
@@ -322,6 +323,9 @@ static void __do_kernel_fault(unsigned l
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
@@ -1449,7 +1449,12 @@ int arch_add_memory(int nid, u64 start,
 {
 	int ret, flags = 0;
 
-	if (rodata_full || debug_pagealloc_enabled())
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

arm64-kfence-enable-kfence-for-arm64.patch
kfence-documentation-add-kfence-documentation.patch
kfence-add-test-suite.patch
maintainers-add-entry-for-kfence.patch

