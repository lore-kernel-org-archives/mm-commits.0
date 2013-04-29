From: akpm@linux-foundation.org
Subject: [folded-merged] mm-soft-dirty-bits-for-user-memory-changes-tracking-fix.patch removed from -mm tree
Date: Mon, 29 Apr 2013 14:53:52 -0700
Message-ID: <20130429215352.69D135A41E9@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:42441 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933150Ab3D2Vxx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Apr 2013 17:53:53 -0400
Received: by mail-qa0-f74.google.com with SMTP id bs12so241929qab.1
        for <mm-commits@vger.kernel.org>; Mon, 29 Apr 2013 14:53:52 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@parallels.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: mem-soft-dirty: Reshuffle CONFIG_ options to be more Arch-friendly
has been removed from the -mm tree.  Its filename was
     mm-soft-dirty-bits-for-user-memory-changes-tracking-fix.patch

This patch was dropped because it was folded into mm-soft-dirty-bits-for-user-memory-changes-tracking.patch

------------------------------------------------------
From: Pavel Emelyanov <xemul@parallels.com>
Subject: mem-soft-dirty: Reshuffle CONFIG_ options to be more Arch-friendly

As Stephen Rothwell pointed out, config options, that depend on
architecture support, are better to be wrapped into a select +
depends on scheme.

Do this for CONFIG_MEM_SOFT_DIRTY, as it currently works only
for X86.

Signed-off-by: Pavel Emelyanov <xemul@parallels.com>
Acked-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig                   |    3 +++
 arch/x86/Kconfig               |    1 +
 arch/x86/include/asm/pgtable.h |    2 --
 include/asm-generic/pgtable.h  |    2 +-
 mm/Kconfig                     |    2 +-
 5 files changed, 6 insertions(+), 4 deletions(-)

diff -puN arch/Kconfig~mm-soft-dirty-bits-for-user-memory-changes-tracking-fix arch/Kconfig
--- a/arch/Kconfig~mm-soft-dirty-bits-for-user-memory-changes-tracking-fix
+++ a/arch/Kconfig
@@ -362,6 +362,9 @@ config HAVE_IRQ_TIME_ACCOUNTING
 config HAVE_ARCH_TRANSPARENT_HUGEPAGE
 	bool
 
+config HAVE_ARCH_SOFT_DIRTY
+	bool
+
 config HAVE_MOD_ARCH_SPECIFIC
 	bool
 	help
diff -puN arch/x86/Kconfig~mm-soft-dirty-bits-for-user-memory-changes-tracking-fix arch/x86/Kconfig
--- a/arch/x86/Kconfig~mm-soft-dirty-bits-for-user-memory-changes-tracking-fix
+++ a/arch/x86/Kconfig
@@ -101,6 +101,7 @@ config X86
 	select HAVE_ARCH_SECCOMP_FILTER
 	select BUILDTIME_EXTABLE_SORT
 	select GENERIC_CMOS_UPDATE
+	select HAVE_ARCH_SOFT_DIRTY
 	select CLOCKSOURCE_WATCHDOG
 	select GENERIC_CLOCKEVENTS
 	select ARCH_CLOCKSOURCE_DATA if X86_64
diff -puN arch/x86/include/asm/pgtable.h~mm-soft-dirty-bits-for-user-memory-changes-tracking-fix arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h~mm-soft-dirty-bits-for-user-memory-changes-tracking-fix
+++ a/arch/x86/include/asm/pgtable.h
@@ -294,8 +294,6 @@ static inline pmd_t pmd_mknotpresent(pmd
 	return pmd_clear_flags(pmd, _PAGE_PRESENT);
 }
 
-#define __HAVE_SOFT_DIRTY
-
 static inline int pte_soft_dirty(pte_t pte)
 {
 	return pte_flags(pte) & _PAGE_SOFT_DIRTY;
diff -puN include/asm-generic/pgtable.h~mm-soft-dirty-bits-for-user-memory-changes-tracking-fix include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h~mm-soft-dirty-bits-for-user-memory-changes-tracking-fix
+++ a/include/asm-generic/pgtable.h
@@ -396,7 +396,7 @@ static inline void ptep_modify_prot_comm
 #define arch_start_context_switch(prev)	do {} while (0)
 #endif
 
-#ifndef __HAVE_SOFT_DIRTY
+#ifndef CONFIG_HAVE_ARCH_SOFT_DIRTY
 static inline int pte_soft_dirty(pte_t pte)
 {
 	return 0;
diff -puN mm/Kconfig~mm-soft-dirty-bits-for-user-memory-changes-tracking-fix mm/Kconfig
--- a/mm/Kconfig~mm-soft-dirty-bits-for-user-memory-changes-tracking-fix
+++ a/mm/Kconfig
@@ -474,7 +474,7 @@ config FRONTSWAP
 
 config MEM_SOFT_DIRTY
 	bool "Track memory changes"
-	depends on CHECKPOINT_RESTORE && X86
+	depends on CHECKPOINT_RESTORE && HAVE_ARCH_SOFT_DIRTY
 	select PROC_PAGE_MONITOR
 	help
 	  This option enables memory changes tracking by introducing a
_

Patches currently in -mm which might be from xemul@parallels.com are

clear_refs-sanitize-accepted-commands-declaration.patch
clear_refs-introduce-private-struct-for-mm_walk.patch
pagemap-introduce-pagemap_entry_t-without-pmshift-bits.patch
pagemap-introduce-the-proc-pid-pagemap2-file.patch
mm-soft-dirty-bits-for-user-memory-changes-tracking.patch

