Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EAEBC433ED
	for <mm-commits@archiver.kernel.org>; Tue,  6 Apr 2021 02:28:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5CB06139F
	for <mm-commits@archiver.kernel.org>; Tue,  6 Apr 2021 02:28:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238731AbhDFC2P (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 5 Apr 2021 22:28:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:47426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233049AbhDFC2P (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 5 Apr 2021 22:28:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E16986139B;
        Tue,  6 Apr 2021 02:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617676087;
        bh=z6ZxcCFpbhV1nQqaDg+TykzIT8Syr6q/MPvjtrxbFuk=;
        h=Date:From:To:Subject:From;
        b=isEes2ZHM3GjnW1xu/hP9YFgXDmdVu36eyVdAnv0wrV5S0dq69rZkKl0vMw6t+g0I
         1Y61E5fdez815il8kPh1ylISv3XOYGtjPiodF5ofgqmFde1z1HHjanK47/Mwbv7pfv
         0726PQjcLJbJNaMYxoHV8F2fP9k/Qa+hPgh3e+H8=
Date:   Mon, 05 Apr 2021 19:28:06 -0700
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, benh@kernel.crashing.org,
        catalin.marinas@arm.com, chris@zankel.net, jcmvbkbc@gmail.com,
        linux@armlinux.org.uk, mingo@redhat.com,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, paulus@samba.org,
        tglx@linutronix.de, tsbogend@alpha.franken.de, will@kernel.org
Subject:  + mm-memtest-add-arch_use_memtest.patch added to -mm tree
Message-ID: <20210406022806.SS_m9SLQn%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memtest: add ARCH_USE_MEMTEST
has been added to the -mm tree.  Its filename is
     mm-memtest-add-arch_use_memtest.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memtest-add-arch_use_memtest.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memtest-add-arch_use_memtest.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -14,6 +14,7 @@ config MIPS
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
@@ -2520,11 +2520,18 @@ config TEST_FPU
 
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

mm-memtest-add-arch_use_memtest.patch
mm-generalize-hugetlb_page_size_variable.patch
mm-generalize-arch_has_cache_line_size.patch
mm-generalize-sys_supports_hugetlbfs-rename-as-arch_supports_hugetlbfs.patch
mm-generalize-arch_enable_memory_.patch
mm-drop-redundant-arch_enable__migration.patch
mm-drop-redundant-arch_enable_split_pmd_ptlock.patch
mm-drop-redundant-have_arch_transparent_hugepage.patch

