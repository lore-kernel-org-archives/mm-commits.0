From: akpm@linux-foundation.org
Subject: - alpha-fix-trivial-section-mismatch-warnings.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:50:38 -0700
Message-ID: <200707162050.l6GKocU4001327@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34297 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761999AbXGPVf6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:35:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sam@ravnborg.org, ink@jurassic.park.msu.ru, mroos@linux.ee, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     alpha: fix trivial section mismatch warnings
has been removed from the -mm tree.  Its filename was
     alpha-fix-trivial-section-mismatch-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: alpha: fix trivial section mismatch warnings
From: Sam Ravnborg <sam@ravnborg.org>

Fix the following section mismatch warnings:
WARNING: arch/alpha/kernel/built-in.o(.text+0x7c78): Section mismatch: reference to .init.text:init_rtc_irq (between 'common_init_rtc' and 'timer_interrupt')
WARNING: arch/alpha/kernel/built-in.o(.text+0x7c7c): Section mismatch: reference to .init.text:init_rtc_irq (between 'common_init_rtc' and 'timer_interrupt')
WARNING: arch/alpha/kernel/built-in.o(.data+0x2c30): Section mismatch: reference to .init.text:srm_console_setup (between 'srmcons' and 'tsunami_pci_ops')

In all three cases functions marked __init was called outside __init context.
So the fix was to just drop the __init attribute.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Meelis Roos <mroos@linux.ee>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Richard Henderson <rth@twiddle.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/srmcons.c    |    2 +-
 arch/alpha/kernel/sys_marvel.c |    2 +-
 arch/alpha/kernel/time.c       |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/alpha/kernel/srmcons.c~alpha-fix-trivial-section-mismatch-warnings arch/alpha/kernel/srmcons.c
--- a/arch/alpha/kernel/srmcons.c~alpha-fix-trivial-section-mismatch-warnings
+++ a/arch/alpha/kernel/srmcons.c
@@ -289,7 +289,7 @@ srm_console_device(struct console *co, i
 	return srmcons_driver;
 }
 
-static int __init
+static int
 srm_console_setup(struct console *co, char *options)
 {
 	return 0;
diff -puN arch/alpha/kernel/sys_marvel.c~alpha-fix-trivial-section-mismatch-warnings arch/alpha/kernel/sys_marvel.c
--- a/arch/alpha/kernel/sys_marvel.c~alpha-fix-trivial-section-mismatch-warnings
+++ a/arch/alpha/kernel/sys_marvel.c
@@ -420,7 +420,7 @@ marvel_init_pci(void)
 		io7_clear_errors(io7);
 }
 
-static void
+static void __init
 marvel_init_rtc(void)
 {
 	init_rtc_irq();
diff -puN arch/alpha/kernel/time.c~alpha-fix-trivial-section-mismatch-warnings arch/alpha/kernel/time.c
--- a/arch/alpha/kernel/time.c~alpha-fix-trivial-section-mismatch-warnings
+++ a/arch/alpha/kernel/time.c
@@ -144,7 +144,7 @@ irqreturn_t timer_interrupt(int irq, voi
 	return IRQ_HANDLED;
 }
 
-void
+void __init
 common_init_rtc(void)
 {
 	unsigned char x;
_

Patches currently in -mm which might be from sam@ravnborg.org are

origin.patch
powerpc-vdso-install-unstripped-copies-on-disk.patch
git-kbuild.patch
use-posix-bre-in-headers-install-target.patch
modpost-white-list-pattern-adjustment.patch
strip-config_-automatically-in-kernel-configuration-search.patch
fix-the-warning-when-running-make-tags.patch
kconfig-reset-generated-values-only-if-kconfig-and-config-agree.patch
pass-g-to-assembler-under-config_debug_info.patch
x86-fix-section-mismatch-warnings-in-mtrr.patch
i386-fix-section-mismatch-warning-in-intel_cacheinfo.patch
i386-vdso-install-unstripped-copies-on-disk.patch
i386-vdso-install-unstripped-copies-on-disk-fix.patch
x86_64-ia32-vdso-install-unstripped-copies-on-disk.patch
whitelist-references-from-__dbe_table-to-init.patch
