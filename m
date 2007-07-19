From: akpm@linux-foundation.org
Subject: - lguest-the-makefile-and-kconfig.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:05:00 -0700
Message-ID: <200707192005.l6JK50eX019998@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40471 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759898AbXGSUP2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:15:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     lguest: the Makefile and Kconfig
has been removed from the -mm tree.  Its filename was
     lguest-the-makefile-and-kconfig.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: lguest: the Makefile and Kconfig
From: Rusty Russell <rusty@rustcorp.com.au>

This is the Kconfig and Makefile to allow lguest to actually be
compiled.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/Kconfig         |    2 ++
 drivers/Makefile        |    1 +
 drivers/lguest/Kconfig  |   20 ++++++++++++++++++++
 drivers/lguest/Makefile |    7 +++++++
 4 files changed, 30 insertions(+)

diff -puN drivers/Kconfig~lguest-the-makefile-and-kconfig drivers/Kconfig
--- a/drivers/Kconfig~lguest-the-makefile-and-kconfig
+++ a/drivers/Kconfig
@@ -85,4 +85,6 @@ source "drivers/auxdisplay/Kconfig"
 source "drivers/kvm/Kconfig"
 
 source "drivers/uio/Kconfig"
+
+source "drivers/lguest/Kconfig"
 endmenu
diff -puN drivers/Makefile~lguest-the-makefile-and-kconfig drivers/Makefile
--- a/drivers/Makefile~lguest-the-makefile-and-kconfig
+++ a/drivers/Makefile
@@ -73,6 +73,7 @@ obj-$(CONFIG_ISDN)		+= isdn/
 obj-$(CONFIG_EDAC)		+= edac/
 obj-$(CONFIG_MCA)		+= mca/
 obj-$(CONFIG_EISA)		+= eisa/
+obj-$(CONFIG_LGUEST_GUEST)	+= lguest/
 obj-$(CONFIG_CPU_FREQ)		+= cpufreq/
 obj-$(CONFIG_MMC)		+= mmc/
 obj-$(CONFIG_NEW_LEDS)		+= leds/
diff -puN /dev/null drivers/lguest/Kconfig
--- /dev/null
+++ a/drivers/lguest/Kconfig
@@ -0,0 +1,20 @@
+config LGUEST
+	tristate "Linux hypervisor example code"
+	depends on X86 && PARAVIRT && NET && EXPERIMENTAL && !X86_PAE
+	select LGUEST_GUEST
+	select HVC_DRIVER
+	---help---
+	  This is a very simple module which allows you to run
+	  multiple instances of the same Linux kernel, using the
+	  "lguest" command found in the Documentation/lguest directory.
+	  Note that "lguest" is pronounced to rhyme with "fell quest",
+	  not "rustyvisor".  See Documentation/lguest/lguest.txt.
+
+	  If unsure, say N.  If curious, say M.  If masochistic, say Y.
+
+config LGUEST_GUEST
+	bool
+	help
+	  The guest needs code built-in, even if the host has lguest
+	  support as a module.  The drivers are tiny, so we build them
+	  in too.
diff -puN /dev/null drivers/lguest/Makefile
--- /dev/null
+++ a/drivers/lguest/Makefile
@@ -0,0 +1,7 @@
+# Guest requires the paravirt_ops replacement and the bus driver.
+obj-$(CONFIG_LGUEST_GUEST) += lguest.o lguest_asm.o lguest_bus.o
+
+# Host requires the other files, which can be a module.
+obj-$(CONFIG_LGUEST)	+= lg.o
+lg-y := core.o hypercalls.o page_tables.o interrupts_and_traps.o \
+	segments.o io.o lguest_user.o switcher.o
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

origin.patch
git-kbuild.patch
git-kvm.patch
lguest-the-host-code-lguest-vs-clockevents-fix-resume-logic.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
