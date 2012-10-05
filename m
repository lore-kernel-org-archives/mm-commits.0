From: akpm@linux-foundation.org
Subject: + kconfig-clean-up-the-long-arch-list-for-the-debug_bugverbose-config-option.patch added to -mm tree
Date: Fri, 05 Oct 2012 13:41:06 -0700
Message-ID: <20121005204106.9EADE100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:52585 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757275Ab2JEUlI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:41:08 -0400
Received: by mail-vc0-f202.google.com with SMTP id fy27so239590vcb.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:41:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: catalin.marinas@arm.com, cmetcalf@tilera.com, davem@davemloft.net, dhowells@redhat.com, geert@linux-m68k.org, lethal@linux-sh.org, takata@linux-m32r.org


The patch titled
     Subject: Kconfig: clean up the long arch list for the DEBUG_BUGVERBOSE config option
has been added to the -mm tree.  Its filename is
     kconfig-clean-up-the-long-arch-list-for-the-debug_bugverbose-config-option.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Kconfig: clean up the long arch list for the DEBUG_BUGVERBOSE config option

Introduce HAVE_DEBUG_BUGVERBOSE config option and select it in
corresponding architecture Kconfig files.  Architectures that already
select GENERIC_BUG don't need to select HAVE_DEBUG_BUGVERBOSE.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/Kconfig |    1 +
 arch/frv/Kconfig   |    1 +
 arch/m32r/Kconfig  |    1 +
 arch/m68k/Kconfig  |    1 +
 arch/sh/Kconfig    |    1 +
 arch/sparc/Kconfig |    1 +
 arch/tile/Kconfig  |    1 +
 lib/Kconfig.debug  |    8 ++++----
 8 files changed, 11 insertions(+), 4 deletions(-)

diff -puN arch/arm64/Kconfig~kconfig-clean-up-the-long-arch-list-for-the-debug_bugverbose-config-option arch/arm64/Kconfig
--- a/arch/arm64/Kconfig~kconfig-clean-up-the-long-arch-list-for-the-debug_bugverbose-config-option
+++ a/arch/arm64/Kconfig
@@ -10,6 +10,7 @@ config ARM64
 	select GENERIC_TIME_VSYSCALL
 	select HARDIRQS_SW_RESEND
 	select HAVE_ARCH_TRACEHOOK
+	select HAVE_DEBUG_BUGVERBOSE
 	select HAVE_DEBUG_KMEMLEAK
 	select HAVE_DMA_API_DEBUG
 	select HAVE_DMA_ATTRS
diff -puN arch/frv/Kconfig~kconfig-clean-up-the-long-arch-list-for-the-debug_bugverbose-config-option arch/frv/Kconfig
--- a/arch/frv/Kconfig~kconfig-clean-up-the-long-arch-list-for-the-debug_bugverbose-config-option
+++ a/arch/frv/Kconfig
@@ -8,6 +8,7 @@ config FRV
 	select HAVE_UID16
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_SHOW
+	select HAVE_DEBUG_BUGVERBOSE
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_CPU_DEVICES
 	select ARCH_WANT_IPC_PARSE_VERSION
diff -puN arch/m32r/Kconfig~kconfig-clean-up-the-long-arch-list-for-the-debug_bugverbose-config-option arch/m32r/Kconfig
--- a/arch/m32r/Kconfig~kconfig-clean-up-the-long-arch-list-for-the-debug_bugverbose-config-option
+++ a/arch/m32r/Kconfig
@@ -8,6 +8,7 @@ config M32R
 	select HAVE_KERNEL_BZIP2
 	select HAVE_KERNEL_LZMA
 	select ARCH_WANT_IPC_PARSE_VERSION
+	select HAVE_DEBUG_BUGVERBOSE
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_PROBE
 	select GENERIC_IRQ_SHOW
diff -puN arch/m68k/Kconfig~kconfig-clean-up-the-long-arch-list-for-the-debug_bugverbose-config-option arch/m68k/Kconfig
--- a/arch/m68k/Kconfig~kconfig-clean-up-the-long-arch-list-for-the-debug_bugverbose-config-option
+++ a/arch/m68k/Kconfig
@@ -3,6 +3,7 @@ config M68K
 	default y
 	select HAVE_IDE
 	select HAVE_AOUT if MMU
+	select HAVE_DEBUG_BUGVERBOSE
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_SHOW
 	select GENERIC_ATOMIC64
diff -puN arch/sh/Kconfig~kconfig-clean-up-the-long-arch-list-for-the-debug_bugverbose-config-option arch/sh/Kconfig
--- a/arch/sh/Kconfig~kconfig-clean-up-the-long-arch-list-for-the-debug_bugverbose-config-option
+++ a/arch/sh/Kconfig
@@ -13,6 +13,7 @@ config SUPERH
 	select HAVE_DMA_ATTRS
 	select HAVE_IRQ_WORK
 	select HAVE_PERF_EVENTS
+	select HAVE_DEBUG_BUGVERBOSE
 	select ARCH_HAVE_CUSTOM_GPIO_H
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG if (GUSA_RB || CPU_SH4A)
 	select PERF_USE_VMALLOC
diff -puN arch/sparc/Kconfig~kconfig-clean-up-the-long-arch-list-for-the-debug_bugverbose-config-option arch/sparc/Kconfig
--- a/arch/sparc/Kconfig~kconfig-clean-up-the-long-arch-list-for-the-debug_bugverbose-config-option
+++ a/arch/sparc/Kconfig
@@ -32,6 +32,7 @@ config SPARC
 	select GENERIC_PCI_IOMAP
 	select HAVE_NMI_WATCHDOG if SPARC64
 	select HAVE_BPF_JIT
+	select HAVE_DEBUG_BUGVERBOSE
 	select GENERIC_SMP_IDLE_THREAD
 	select GENERIC_CMOS_UPDATE
 	select GENERIC_CLOCKEVENTS
diff -puN arch/tile/Kconfig~kconfig-clean-up-the-long-arch-list-for-the-debug_bugverbose-config-option arch/tile/Kconfig
--- a/arch/tile/Kconfig~kconfig-clean-up-the-long-arch-list-for-the-debug_bugverbose-config-option
+++ a/arch/tile/Kconfig
@@ -14,6 +14,7 @@ config TILE
 	select GENERIC_IRQ_PROBE
 	select GENERIC_PENDING_IRQ if SMP
 	select GENERIC_IRQ_SHOW
+	select HAVE_DEBUG_BUGVERBOSE
 	select HAVE_SYSCALL_WRAPPERS if TILEGX
 	select SYS_HYPERVISOR
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
diff -puN lib/Kconfig.debug~kconfig-clean-up-the-long-arch-list-for-the-debug_bugverbose-config-option lib/Kconfig.debug
--- a/lib/Kconfig.debug~kconfig-clean-up-the-long-arch-list-for-the-debug_bugverbose-config-option
+++ a/lib/Kconfig.debug
@@ -751,12 +751,12 @@ config DEBUG_HIGHMEM
 	  This options enables addition error checking for high memory systems.
 	  Disable for production systems.
 
+config HAVE_DEBUG_BUGVERBOSE
+	bool
+
 config DEBUG_BUGVERBOSE
 	bool "Verbose BUG() reporting (adds 70K)" if DEBUG_KERNEL && EXPERT
-	depends on BUG
-	depends on ARM || AVR32 || M32R || M68K || SPARC32 || SPARC64 || \
-		   FRV || SUPERH || GENERIC_BUG || BLACKFIN || MN10300 || \
-		   TILE || ARM64
+	depends on BUG && (GENERIC_BUG || HAVE_DEBUG_BUGVERBOSE)
 	default y
 	help
 	  Say Y here to make BUG() panics output the file name and line number
_

Patches currently in -mm which might be from catalin.marinas@arm.com are

origin.patch
linux-next.patch
kconfig-clean-up-the-long-arch-list-for-the-uid16-config-option.patch
kconfig-clean-up-the-long-arch-list-for-the-debug_kmemleak-config-option.patch
kconfig-clean-up-the-long-arch-list-for-the-debug_bugverbose-config-option.patch
kconfig-clean-up-the-if-definedarch-list-for-exception-trace-sysctl-entry.patch
rbtree-add-prio-tree-and-interval-tree-tests.patch
mm-replace-vma-prio_tree-with-an-interval-tree.patch
kmemleak-use-rbtree-instead-of-prio-tree.patch
prio_tree-remove.patch
rbtree-move-augmented-rbtree-functionality-to-rbtree_augmentedh.patch
mm-thp-fix-the-pmd_clear-arguments-in-pmdp_get_and_clear.patch
mm-thp-fix-the-update_mmu_cache-last-argument-passing-in-mm-huge_memoryc.patch

