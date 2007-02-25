From: akpm@linux-foundation.org
Subject: + ide-remove-a-ton-of-pointless-undef-really_slow_io.patch added to -mm tree
Date: Sun, 25 Feb 2007 04:53:23 -0800
Message-ID: <200702251253.l1PCrP3S029619@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35431 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964826AbXBYMxn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Feb 2007 07:53:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com


The patch titled
     ide: remove a ton of pointless #undef REALLY_SLOW_IO
has been added to the -mm tree.  Its filename is
     ide-remove-a-ton-of-pointless-undef-really_slow_io.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ide: remove a ton of pointless #undef REALLY_SLOW_IO
From: Alan <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ide/cris/ide-cris.c   |    2 --
 drivers/ide/ide-disk.c        |    2 --
 drivers/ide/ide-probe.c       |    2 --
 drivers/ide/ide.c             |    2 --
 drivers/ide/legacy/ali14xx.c  |    2 --
 drivers/ide/legacy/dtc2278.c  |    2 --
 drivers/ide/legacy/ht6560b.c  |    2 --
 drivers/ide/legacy/qd65xx.c   |    2 --
 drivers/ide/mips/au1xxx-ide.c |    2 --
 drivers/ide/pci/cmd640.c      |    1 -
 drivers/ide/pci/generic.c     |    2 --
 drivers/ide/pci/opti621.c     |    1 -
 drivers/ide/pci/rz1000.c      |    2 --
 13 files changed, 24 deletions(-)

diff -puN drivers/ide/cris/ide-cris.c~ide-remove-a-ton-of-pointless-undef-really_slow_io drivers/ide/cris/ide-cris.c
--- a/drivers/ide/cris/ide-cris.c~ide-remove-a-ton-of-pointless-undef-really_slow_io
+++ a/drivers/ide/cris/ide-cris.c
@@ -17,8 +17,6 @@
  * device can't do DMA handshaking for some stupid reason. We don't need to do that.
  */
 
-#undef REALLY_SLOW_IO           /* most systems can safely undef this */
-
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/timer.h>
diff -puN drivers/ide/ide.c~ide-remove-a-ton-of-pointless-undef-really_slow_io drivers/ide/ide.c
--- a/drivers/ide/ide.c~ide-remove-a-ton-of-pointless-undef-really_slow_io
+++ a/drivers/ide/ide.c
@@ -126,8 +126,6 @@
 #define	REVISION	"Revision: 7.00alpha2"
 #define	VERSION		"Id: ide.c 7.00a2 20020906"
 
-#undef REALLY_SLOW_IO		/* most systems can safely undef this */
-
 #define _IDE_C			/* Tell ide.h it's really us */
 
 #include <linux/module.h>
diff -puN drivers/ide/ide-disk.c~ide-remove-a-ton-of-pointless-undef-really_slow_io drivers/ide/ide-disk.c
--- a/drivers/ide/ide-disk.c~ide-remove-a-ton-of-pointless-undef-really_slow_io
+++ a/drivers/ide/ide-disk.c
@@ -43,8 +43,6 @@
 
 #define IDEDISK_VERSION	"1.18"
 
-#undef REALLY_SLOW_IO		/* most systems can safely undef this */
-
 //#define DEBUG
 
 #include <linux/module.h>
diff -puN drivers/ide/ide-probe.c~ide-remove-a-ton-of-pointless-undef-really_slow_io drivers/ide/ide-probe.c
--- a/drivers/ide/ide-probe.c~ide-remove-a-ton-of-pointless-undef-really_slow_io
+++ a/drivers/ide/ide-probe.c
@@ -31,8 +31,6 @@
  *			valid after probe time even with noprobe
  */
 
-#undef REALLY_SLOW_IO		/* most systems can safely undef this */
-
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/string.h>
diff -puN drivers/ide/legacy/ali14xx.c~ide-remove-a-ton-of-pointless-undef-really_slow_io drivers/ide/legacy/ali14xx.c
--- a/drivers/ide/legacy/ali14xx.c~ide-remove-a-ton-of-pointless-undef-really_slow_io
+++ a/drivers/ide/legacy/ali14xx.c
@@ -37,8 +37,6 @@
  * mode 4 for a while now with no trouble.)  -Derek
  */
 
-#undef REALLY_SLOW_IO           /* most systems can safely undef this */
-
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
diff -puN drivers/ide/legacy/dtc2278.c~ide-remove-a-ton-of-pointless-undef-really_slow_io drivers/ide/legacy/dtc2278.c
--- a/drivers/ide/legacy/dtc2278.c~ide-remove-a-ton-of-pointless-undef-really_slow_io
+++ a/drivers/ide/legacy/dtc2278.c
@@ -4,8 +4,6 @@
  *  Copyright (C) 1996  Linus Torvalds & author (see below)
  */
 
-#undef REALLY_SLOW_IO           /* most systems can safely undef this */
-
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
diff -puN drivers/ide/legacy/ht6560b.c~ide-remove-a-ton-of-pointless-undef-really_slow_io drivers/ide/legacy/ht6560b.c
--- a/drivers/ide/legacy/ht6560b.c~ide-remove-a-ton-of-pointless-undef-really_slow_io
+++ a/drivers/ide/legacy/ht6560b.c
@@ -36,8 +36,6 @@
 
 #define HT6560B_VERSION "v0.07"
 
-#undef REALLY_SLOW_IO		/* most systems can safely undef this */
-
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
diff -puN drivers/ide/legacy/qd65xx.c~ide-remove-a-ton-of-pointless-undef-really_slow_io drivers/ide/legacy/qd65xx.c
--- a/drivers/ide/legacy/qd65xx.c~ide-remove-a-ton-of-pointless-undef-really_slow_io
+++ a/drivers/ide/legacy/qd65xx.c
@@ -25,8 +25,6 @@
  * Samuel Thibault <samuel.thibault@fnac.net>
  */
 
-#undef REALLY_SLOW_IO		/* most systems can safely undef this */
-
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
diff -puN drivers/ide/mips/au1xxx-ide.c~ide-remove-a-ton-of-pointless-undef-really_slow_io drivers/ide/mips/au1xxx-ide.c
--- a/drivers/ide/mips/au1xxx-ide.c~ide-remove-a-ton-of-pointless-undef-really_slow_io
+++ a/drivers/ide/mips/au1xxx-ide.c
@@ -29,8 +29,6 @@
  * Note: for more information, please refer "AMD Alchemy Au1200/Au1550 IDE
  *       Interface and Linux Device Driver" Application Note.
  */
-#undef REALLY_SLOW_IO           /* most systems can safely undef this */
-
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
diff -puN drivers/ide/pci/cmd640.c~ide-remove-a-ton-of-pointless-undef-really_slow_io drivers/ide/pci/cmd640.c
--- a/drivers/ide/pci/cmd640.c~ide-remove-a-ton-of-pointless-undef-really_slow_io
+++ a/drivers/ide/pci/cmd640.c
@@ -98,7 +98,6 @@
  *			 (patch courtesy of Zoltan Hidvegi)
  */
 
-#undef REALLY_SLOW_IO		/* most systems can safely undef this */
 #define CMD640_PREFETCH_MASKS 1
 
 //#define CMD640_DUMP_REGS
diff -puN drivers/ide/pci/generic.c~ide-remove-a-ton-of-pointless-undef-really_slow_io drivers/ide/pci/generic.c
--- a/drivers/ide/pci/generic.c~ide-remove-a-ton-of-pointless-undef-really_slow_io
+++ a/drivers/ide/pci/generic.c
@@ -21,8 +21,6 @@
  * are deemed to be part of the source code.
  */
 
-#undef REALLY_SLOW_IO		/* most systems can safely undef this */
-
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
diff -puN drivers/ide/pci/opti621.c~ide-remove-a-ton-of-pointless-undef-really_slow_io drivers/ide/pci/opti621.c
--- a/drivers/ide/pci/opti621.c~ide-remove-a-ton-of-pointless-undef-really_slow_io
+++ a/drivers/ide/pci/opti621.c
@@ -87,7 +87,6 @@
  * 0.5 doesn't work.
  */
 
-#undef REALLY_SLOW_IO	/* most systems can safely undef this */
 #define OPTI621_DEBUG		/* define for debug messages */
 
 #include <linux/types.h>
diff -puN drivers/ide/pci/rz1000.c~ide-remove-a-ton-of-pointless-undef-really_slow_io drivers/ide/pci/rz1000.c
--- a/drivers/ide/pci/rz1000.c~ide-remove-a-ton-of-pointless-undef-really_slow_io
+++ a/drivers/ide/pci/rz1000.c
@@ -15,8 +15,6 @@
  *  Dunno if this fixes both ports, or only the primary port (?).
  */
 
-#undef REALLY_SLOW_IO		/* most systems can safely undef this */
-
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

git-libata-all.patch
libata-warn-if-speed-limited-due-to-40-wire-cable-v2.patch
add-id_to_dma_mode-function-for-printing-dma-modes.patch
expose-set_mode-method-so-it-can-be-wrapped.patch
acpi-driver-support-for-pata.patch
libata-use-new-id_to_dma_mode-function-to-tidy-reporting.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
adjust-legacy-ide-resource-setting-v2.patch
ide-remove-a-ton-of-pointless-undef-really_slow_io.patch
resend-iphase-64bit-cleanup.patch
serial-serial_txx9-driver-update.patch
serial-serial_txx9-driver-update-fix.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
driver_bfin_serial_core.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
tty-clarify-documentation-of-write.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
edac-k8-driver-coding-tidy.patch
