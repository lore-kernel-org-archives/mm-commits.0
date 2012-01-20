From: akpm@linux-foundation.org
Subject: [merged] mm-config-menu-move-zone_dma-under-a-menu.patch removed from -mm tree
Date: Fri, 20 Jan 2012 11:40:05 -0800
Message-ID: <20120120194006.E65265C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:49456 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754940Ab2ATTkJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jan 2012 14:40:09 -0500
Received: by eekb15 with SMTP id b15so35530eek.1
        for <mm-commits@vger.kernel.org>; Fri, 20 Jan 2012 11:40:07 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdunlap@xenotime.net, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: config menu: move ZONE_DMA under a menu
has been removed from the -mm tree.  Its filename was
     mm-config-menu-move-zone_dma-under-a-menu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Randy Dunlap <rdunlap@xenotime.net>
Subject: mm: config menu: move ZONE_DMA under a menu

Move the ZONE_DMA kconfig symbol under a menu item instead of having it
listed before everything else in "make {xconfig | gconfig | nconfig |
menuconfig}".

This drops the first line of the top-level kernel config menu
(in 3.2) below and moves it under "Processor type and features".

          [*] DMA memory allocation support
              General setup  --->
          [*] Enable loadable module support  --->
          [*] Enable the block layer  --->
              Processor type and features  --->
              Power management and ACPI options  --->
              Bus options (PCI etc.)  --->
              Executable file formats / Emulations  --->

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff -puN arch/x86/Kconfig~mm-config-menu-move-zone_dma-under-a-menu arch/x86/Kconfig
--- a/arch/x86/Kconfig~mm-config-menu-move-zone_dma-under-a-menu
+++ a/arch/x86/Kconfig
@@ -125,16 +125,6 @@ config HAVE_LATENCYTOP_SUPPORT
 config MMU
 	def_bool y
 
-config ZONE_DMA
-	bool "DMA memory allocation support" if EXPERT
-	default y
-	help
-	  DMA memory allocation support allows devices with less than 32-bit
-	  addressing to allocate within the first 16MB of address space.
-	  Disable if no such devices will be used.
-
-	  If unsure, say Y.
-
 config SBUS
 	bool
 
@@ -258,6 +248,16 @@ source "kernel/Kconfig.freezer"
 
 menu "Processor type and features"
 
+config ZONE_DMA
+	bool "DMA memory allocation support" if EXPERT
+	default y
+	help
+	  DMA memory allocation support allows devices with less than 32-bit
+	  addressing to allocate within the first 16MB of address space.
+	  Disable if no such devices will be used.
+
+	  If unsure, say Y.
+
 source "kernel/time/Kconfig"
 
 config SMP
_

Patches currently in -mm which might be from rdunlap@xenotime.net are

origin.patch
linux-next.patch
ramoops-use-pstore-interface.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-fix.patch

