Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 352E6C433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:40:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15DDD61421
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:40:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbhEHWl0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:41:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:45020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229577AbhEHWlY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:41:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C42B61402;
        Sat,  8 May 2021 22:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513621;
        bh=YXy6GWcZ35B1UXrRn4+epmyhJYP9XvuJcasQsOgWMNU=;
        h=Date:From:To:Subject:From;
        b=BDi8VKK44nml6gMtPEhBqYAOR/4DV3EWFG38gNaglg1/qIz5eS9zitWb7gtmAQ2bL
         RF9lEbAQtY1TXZWJmmaccNHFN71CQ9wpj44ye6ptv/NBJD6c8gqgReMwd6iy+GqQ+H
         xMhKP7eMpp3eJT5sbhuoYZVXFJ+sQGGBsfdtG39k=
Date:   Sat, 08 May 2021 15:40:21 -0700
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, benh@kernel.crashing.org,
        catalin.marinas@arm.com, chris@zankel.net, jcmvbkbc@gmail.com,
        linux@armlinux.org.uk, mingo@redhat.com,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, paulus@samba.org,
        tglx@linutronix.de, tsbogend@alpha.franken.de, will@kernel.org
Subject:  [merged] mm-memtest-add-arch_use_memtest.patch removed
 from -mm tree
Message-ID: <20210508224021._hcXF1GRe%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memtest: add ARCH_USE_MEMTEST
has been removed from the -mm tree.  Its filename was
     mm-memtest-add-arch_use_memtest.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/memtest: add ARCH_USE_MEMTEST

early_memtest() does not get called from all architectures.  Hence
enabling CONFIG_MEMTEST and providing a valid memtest=[1..N] kernel
command line option might not trigger the memory pattern tests as would be
expected in normal circumstances.  This situation is misleading.

The change here prevents the above mentioned problem after introducing a
new config option ARCH_USE_MEMTEST that should be subscribed on platforms
that call early_memtest(), in order to enable the config CONFIG_MEMTEST. 
Conversely CONFIG_MEMTEST cannot be enabled on platforms where it would
not be tested anyway.

Link: https://lkml.kernel.org/r/1617269193-22294-1-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com> (arm64)
Reviewed-by: Max Filippov <jcmvbkbc@gmail.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Will Deacon <will@kernel.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Chris Zankel <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/Kconfig     |    1 +
 arch/arm64/Kconfig   |    1 +
 arch/mips/Kconfig    |    1 +
 arch/powerpc/Kconfig |    1 +
 arch/x86/Kconfig     |    1 +
 arch/xtensa/Kconfig  |    1 +
 lib/Kconfig.debug    |    9 ++++++++-
 7 files changed, 14 insertions(+), 1 deletion(-)

--- a/arch/arm64/Kconfig~mm-memtest-add-arch_use_memtest
+++ a/arch/arm64/Kconfig
@@ -67,6 +67,7 @@ config ARM64
 	select ARCH_KEEP_MEMBLOCK
 	select ARCH_USE_CMPXCHG_LOCKREF
 	select ARCH_USE_GNU_PROPERTY
+	select ARCH_USE_MEMTEST
 	select ARCH_USE_QUEUED_RWLOCKS
 	select ARCH_USE_QUEUED_SPINLOCKS
 	select ARCH_USE_SYM_ANNOTATIONS
--- a/arch/arm/Kconfig~mm-memtest-add-arch_use_memtest
+++ a/arch/arm/Kconfig
@@ -33,6 +33,7 @@ config ARM
 	select ARCH_SUPPORTS_ATOMIC_RMW
 	select ARCH_USE_BUILTIN_BSWAP
 	select ARCH_USE_CMPXCHG_LOCKREF
+	select ARCH_USE_MEMTEST
 	select ARCH_WANT_DEFAULT_TOPDOWN_MMAP_LAYOUT if MMU
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select ARCH_WANT_LD_ORPHAN_WARN
--- a/arch/mips/Kconfig~mm-memtest-add-arch_use_memtest
+++ a/arch/mips/Kconfig
@@ -16,6 +16,7 @@ config MIPS
 	select ARCH_SUPPORTS_UPROBES
 	select ARCH_USE_BUILTIN_BSWAP
 	select ARCH_USE_CMPXCHG_LOCKREF if 64BIT
+	select ARCH_USE_MEMTEST
 	select ARCH_USE_QUEUED_RWLOCKS
 	select ARCH_USE_QUEUED_SPINLOCKS
 	select ARCH_WANT_DEFAULT_TOPDOWN_MMAP_LAYOUT if MMU
--- a/arch/powerpc/Kconfig~mm-memtest-add-arch_use_memtest
+++ a/arch/powerpc/Kconfig
@@ -149,6 +149,7 @@ config PPC
 	select ARCH_SUPPORTS_DEBUG_PAGEALLOC	if PPC32 || PPC_BOOK3S_64
 	select ARCH_USE_BUILTIN_BSWAP
 	select ARCH_USE_CMPXCHG_LOCKREF		if PPC64
+	select ARCH_USE_MEMTEST
 	select ARCH_USE_QUEUED_RWLOCKS		if PPC_QUEUED_SPINLOCKS
 	select ARCH_USE_QUEUED_SPINLOCKS	if PPC_QUEUED_SPINLOCKS
 	select ARCH_WANT_IPC_PARSE_VERSION
--- a/arch/x86/Kconfig~mm-memtest-add-arch_use_memtest
+++ a/arch/x86/Kconfig
@@ -100,6 +100,7 @@ config X86
 	select ARCH_SUPPORTS_LTO_CLANG		if X86_64
 	select ARCH_SUPPORTS_LTO_CLANG_THIN	if X86_64
 	select ARCH_USE_BUILTIN_BSWAP
+	select ARCH_USE_MEMTEST
 	select ARCH_USE_QUEUED_RWLOCKS
 	select ARCH_USE_QUEUED_SPINLOCKS
 	select ARCH_USE_SYM_ANNOTATIONS
--- a/arch/xtensa/Kconfig~mm-memtest-add-arch_use_memtest
+++ a/arch/xtensa/Kconfig
@@ -7,6 +7,7 @@ config XTENSA
 	select ARCH_HAS_SYNC_DMA_FOR_CPU if MMU
 	select ARCH_HAS_SYNC_DMA_FOR_DEVICE if MMU
 	select ARCH_HAS_DMA_SET_UNCACHED if MMU
+	select ARCH_USE_MEMTEST
 	select ARCH_USE_QUEUED_RWLOCKS
 	select ARCH_USE_QUEUED_SPINLOCKS
 	select ARCH_WANT_FRAME_POINTERS
--- a/lib/Kconfig.debug~mm-memtest-add-arch_use_memtest
+++ a/lib/Kconfig.debug
@@ -2578,11 +2578,18 @@ config TEST_FPU
 
 endif # RUNTIME_TESTING_MENU
 
+config ARCH_USE_MEMTEST
+	bool
+	help
+	  An architecture should select this when it uses early_memtest()
+	  during boot process.
+
 config MEMTEST
 	bool "Memtest"
+	depends on ARCH_USE_MEMTEST
 	help
 	  This option adds a kernel parameter 'memtest', which allows memtest
-	  to be set.
+	  to be set and executed.
 	        memtest=0, mean disabled; -- default
 	        memtest=1, mean do 1 test pattern;
 	        ...
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are


