From: akpm@linux-foundation.org
Subject: + mm-config-menu-move-zone_dma-under-a-menu.patch added to -mm tree
Date: Tue, 17 Jan 2012 15:32:39 -0800
Message-ID: <20120117233239.9F9B71E004D@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:33147 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755252Ab2AQXck (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jan 2012 18:32:40 -0500
Received: by yenl12 with SMTP id l12so128627yen.1
        for <mm-commits@vger.kernel.org>; Tue, 17 Jan 2012 15:32:40 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rdunlap@xenotime.net, rientjes@google.com


The patch titled
     Subject: mm: config menu: move ZONE_DMA under a menu
has been added to the -mm tree.  Its filename is
     mm-config-menu-move-zone_dma-under-a-menu.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: mm: config menu: move ZONE_DMA under a menu

Patches currently in -mm which might be from rdunlap@xenotime.net are

origin.patch
linux-next.patch
mm-config-menu-move-zone_dma-under-a-menu.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-fix.patch

