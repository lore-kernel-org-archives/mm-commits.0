From: akpm@linux-foundation.org
Subject: [folded-merged]
 printk-nmi-increase-the-size-of-nmi-buffer-and-make-it-configurable-fix-2.patch removed from -mm tree
Date: Wed, 20 Jan 2016 13:11:14 -0800
Message-ID: <569ff7f2.Ekf7R9JifOponO+8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37688 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754445AbcATVLP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Jan 2016 16:11:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pmladek@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: printk/nmi: Remove the questionable CONFIG_NEED_PRINTK_NMI
has been removed from the -mm tree.  Its filename was
     printk-nmi-increase-the-size-of-nmi-buffer-and-make-it-configurable-fix-2.patch

This patch was dropped because it was folded into printk-nmi-increase-the-size-of-nmi-buffer-and-make-it-configurable.patch

------------------------------------------------------
From: Petr Mladek <pmladek@suse.com>
Subject: printk/nmi: Remove the questionable CONFIG_NEED_PRINTK_NMI

The flag NEED_PRINTK_NMI was added because of Arm.  It used the NMI safe
backtrace implementation on all Arm systems.  But it did not have a real
NMI handling on CPU_V7M.

It seems that it causes more confusion than good.  Let's use HAVE_NMI on
all arm systems and get rid of the problematic flag.

Signed-off-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig     |    3 ---
 arch/arm/Kconfig |    3 +--
 init/Kconfig     |    2 +-
 3 files changed, 2 insertions(+), 6 deletions(-)

diff -puN arch/Kconfig~printk-nmi-increase-the-size-of-nmi-buffer-and-make-it-configurable-fix-2 arch/Kconfig
--- a/arch/Kconfig~printk-nmi-increase-the-size-of-nmi-buffer-and-make-it-configurable-fix-2
+++ a/arch/Kconfig
@@ -190,9 +190,6 @@ config HAVE_KPROBES_ON_FTRACE
 config HAVE_NMI
 	bool
 
-config NEED_PRINTK_NMI
-	bool
-
 config HAVE_NMI_WATCHDOG
 	depends on HAVE_NMI
 	bool
diff -puN arch/arm/Kconfig~printk-nmi-increase-the-size-of-nmi-buffer-and-make-it-configurable-fix-2 arch/arm/Kconfig
--- a/arch/arm/Kconfig~printk-nmi-increase-the-size-of-nmi-buffer-and-make-it-configurable-fix-2
+++ a/arch/arm/Kconfig
@@ -67,8 +67,7 @@ config ARM
 	select HAVE_KRETPROBES if (HAVE_KPROBES)
 	select HAVE_MEMBLOCK
 	select HAVE_MOD_ARCH_SPECIFIC
-	select HAVE_NMI if (!CPU_V7M)
-	select NEED_PRINTK_NMI if (CPU_V7M)
+	select HAVE_NMI
 	select HAVE_OPROFILE if (HAVE_PERF_EVENTS)
 	select HAVE_OPTPROBES if !THUMB2_KERNEL
 	select HAVE_PERF_EVENTS
diff -puN init/Kconfig~printk-nmi-increase-the-size-of-nmi-buffer-and-make-it-configurable-fix-2 init/Kconfig
--- a/init/Kconfig~printk-nmi-increase-the-size-of-nmi-buffer-and-make-it-configurable-fix-2
+++ a/init/Kconfig
@@ -1468,7 +1468,7 @@ config PRINTK
 config PRINTK_NMI
 	def_bool y
 	depends on PRINTK
-	depends on HAVE_NMI || NEED_PRINTK_NMI
+	depends on HAVE_NMI
 
 config BUG
 	bool "BUG() support" if EXPERT
_

Patches currently in -mm which might be from pmladek@suse.com are

printk-nmi-generic-solution-for-safe-printk-in-nmi.patch
printk-nmi-use-irq-work-only-when-ready.patch
printk-nmi-warn-when-some-message-has-been-lost-in-nmi-context.patch
printk-nmi-increase-the-size-of-nmi-buffer-and-make-it-configurable.patch

