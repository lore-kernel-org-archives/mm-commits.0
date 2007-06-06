From: akpm@linux-foundation.org
Subject: + drivers-edac-mod-use-edac_coreh.patch added to -mm tree
Date: Tue, 05 Jun 2007 18:50:48 -0700
Message-ID: <200706060150.l561omZR007455@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56326 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933711AbXFFBu4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jun 2007 21:50:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dougthompson@xmission.com


The patch titled
     drivers-edac: mod use edac_core.h
has been added to the -mm tree.  Its filename is
     drivers-edac-mod-use-edac_coreh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers-edac: mod use edac_core.h
From: Douglas Thompson <dougthompson@xmission.com>

In the refactoring of edac_mc.c into several subsystem files,
the header file edac_mc.h became meaningless. A new header file
edac_core.h was created. All the files that previously included
"edac_mc.h" are changed to include "edac_core.h".

Signed-off-by: Douglas Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/amd76x_edac.c     |    4 ++--
 drivers/edac/e752x_edac.c      |    4 ++--
 drivers/edac/e7xxx_edac.c      |    4 ++--
 drivers/edac/edac_mc.c         |    2 +-
 drivers/edac/edac_mc_sysfs.c   |    2 +-
 drivers/edac/edac_module.c     |    4 ++--
 drivers/edac/edac_pci_sysfs.c  |    4 ++--
 drivers/edac/i5000_edac.c      |    4 ++--
 drivers/edac/i82443bxgx_edac.c |    2 +-
 drivers/edac/i82860_edac.c     |    4 ++--
 drivers/edac/i82875p_edac.c    |    4 ++--
 drivers/edac/r82600_edac.c     |    4 ++--
 12 files changed, 21 insertions(+), 21 deletions(-)

diff -puN drivers/edac/amd76x_edac.c~drivers-edac-mod-use-edac_coreh drivers/edac/amd76x_edac.c
--- a/drivers/edac/amd76x_edac.c~drivers-edac-mod-use-edac_coreh
+++ a/drivers/edac/amd76x_edac.c
@@ -17,9 +17,9 @@
 #include <linux/pci.h>
 #include <linux/pci_ids.h>
 #include <linux/slab.h>
-#include "edac_mc.h"
+#include "edac_core.h"
 
-#define AMD76X_REVISION	" Ver: 2.0.1 "  __DATE__
+#define AMD76X_REVISION	" Ver: 2.0.2 "  __DATE__
 #define EDAC_MOD_STR	"amd76x_edac"
 
 #define amd76x_printk(level, fmt, arg...) \
diff -puN drivers/edac/e752x_edac.c~drivers-edac-mod-use-edac_coreh drivers/edac/e752x_edac.c
--- a/drivers/edac/e752x_edac.c~drivers-edac-mod-use-edac_coreh
+++ a/drivers/edac/e752x_edac.c
@@ -23,9 +23,9 @@
 #include <linux/pci_ids.h>
 #include <linux/slab.h>
 #include <linux/edac.h>
-#include "edac_mc.h"
+#include "edac_core.h"
 
-#define E752X_REVISION	" Ver: 2.0.1 " __DATE__
+#define E752X_REVISION	" Ver: 2.0.2 " __DATE__
 #define EDAC_MOD_STR	"e752x_edac"
 
 static int force_function_unhide;
diff -puN drivers/edac/e7xxx_edac.c~drivers-edac-mod-use-edac_coreh drivers/edac/e7xxx_edac.c
--- a/drivers/edac/e7xxx_edac.c~drivers-edac-mod-use-edac_coreh
+++ a/drivers/edac/e7xxx_edac.c
@@ -28,9 +28,9 @@
 #include <linux/pci_ids.h>
 #include <linux/slab.h>
 #include <linux/edac.h>
-#include "edac_mc.h"
+#include "edac_core.h"
 
-#define	E7XXX_REVISION " Ver: 2.0.1 " __DATE__
+#define	E7XXX_REVISION " Ver: 2.0.2 " __DATE__
 #define	EDAC_MOD_STR	"e7xxx_edac"
 
 #define e7xxx_printk(level, fmt, arg...) \
diff -puN drivers/edac/edac_mc.c~drivers-edac-mod-use-edac_coreh drivers/edac/edac_mc.c
--- a/drivers/edac/edac_mc.c~drivers-edac-mod-use-edac_coreh
+++ a/drivers/edac/edac_mc.c
@@ -31,7 +31,7 @@
 #include <asm/uaccess.h>
 #include <asm/page.h>
 #include <asm/edac.h>
-#include "edac_mc.h"
+#include "edac_core.h"
 #include "edac_module.h"
 
 
diff -puN drivers/edac/edac_mc_sysfs.c~drivers-edac-mod-use-edac_coreh drivers/edac/edac_mc_sysfs.c
--- a/drivers/edac/edac_mc_sysfs.c~drivers-edac-mod-use-edac_coreh
+++ a/drivers/edac/edac_mc_sysfs.c
@@ -12,7 +12,7 @@
 #include <linux/sysdev.h>
 #include <linux/ctype.h>
 
-#include "edac_mc.h"
+#include "edac_core.h"
 #include "edac_module.h"
 
 /* MC EDAC Controls, setable by module parameter, and sysfs */
diff -puN drivers/edac/edac_module.c~drivers-edac-mod-use-edac_coreh drivers/edac/edac_module.c
--- a/drivers/edac/edac_module.c~drivers-edac-mod-use-edac_coreh
+++ a/drivers/edac/edac_module.c
@@ -3,10 +3,10 @@
 #include <linux/kthread.h>
 #include <linux/edac.h>
 
-#include "edac_mc.h"
+#include "edac_core.h"
 #include "edac_module.h"
 
-#define EDAC_MC_VERSION "Ver: 2.0.3" __DATE__
+#define EDAC_MC_VERSION "Ver: 2.0.4 " __DATE__
 
 #ifdef CONFIG_EDAC_DEBUG
 /* Values of 0 to 4 will generate output */
diff -puN drivers/edac/edac_pci_sysfs.c~drivers-edac-mod-use-edac_coreh drivers/edac/edac_pci_sysfs.c
--- a/drivers/edac/edac_pci_sysfs.c~drivers-edac-mod-use-edac_coreh
+++ a/drivers/edac/edac_pci_sysfs.c
@@ -1,4 +1,4 @@
-/* edac_mc kernel module
+/*
  * (C) 2005, 2006 Linux Networx (http://lnxi.com)
  * This file may be distributed under the terms of the
  * GNU General Public License.
@@ -10,7 +10,7 @@
 #include <linux/sysdev.h>
 #include <linux/ctype.h>
 
-#include "edac_mc.h"
+#include "edac_core.h"
 #include "edac_module.h"
 
 
diff -puN drivers/edac/i5000_edac.c~drivers-edac-mod-use-edac_coreh drivers/edac/i5000_edac.c
--- a/drivers/edac/i5000_edac.c~drivers-edac-mod-use-edac_coreh
+++ a/drivers/edac/i5000_edac.c
@@ -22,12 +22,12 @@
 #include <linux/edac.h>
 #include <asm/mmzone.h>
 
-#include "edac_mc.h"
+#include "edac_core.h"
 
 /*
  * Alter this version for the I5000 module when modifications are made
  */
-#define I5000_REVISION    " Ver: 2.0.11.devel " __DATE__
+#define I5000_REVISION    " Ver: 2.0.12 " __DATE__
 
 #define i5000_printk(level, fmt, arg...) \
         edac_printk(level, "i5000", fmt, ##arg)
diff -puN drivers/edac/i82443bxgx_edac.c~drivers-edac-mod-use-edac_coreh drivers/edac/i82443bxgx_edac.c
--- a/drivers/edac/i82443bxgx_edac.c~drivers-edac-mod-use-edac_coreh
+++ a/drivers/edac/i82443bxgx_edac.c
@@ -29,7 +29,7 @@
 
 #include <linux/slab.h>
 
-#include "edac_mc.h"
+#include "edac_core.h"
 
 #define I82443_REVISION	"0.1"
 
diff -puN drivers/edac/i82860_edac.c~drivers-edac-mod-use-edac_coreh drivers/edac/i82860_edac.c
--- a/drivers/edac/i82860_edac.c~drivers-edac-mod-use-edac_coreh
+++ a/drivers/edac/i82860_edac.c
@@ -14,9 +14,9 @@
 #include <linux/pci.h>
 #include <linux/pci_ids.h>
 #include <linux/slab.h>
-#include "edac_mc.h"
+#include "edac_core.h"
 
-#define  I82860_REVISION " Ver: 2.0.1 " __DATE__
+#define  I82860_REVISION " Ver: 2.0.2 " __DATE__
 #define EDAC_MOD_STR	"i82860_edac"
 
 #define i82860_printk(level, fmt, arg...) \
diff -puN drivers/edac/i82875p_edac.c~drivers-edac-mod-use-edac_coreh drivers/edac/i82875p_edac.c
--- a/drivers/edac/i82875p_edac.c~drivers-edac-mod-use-edac_coreh
+++ a/drivers/edac/i82875p_edac.c
@@ -18,9 +18,9 @@
 #include <linux/pci.h>
 #include <linux/pci_ids.h>
 #include <linux/slab.h>
-#include "edac_mc.h"
+#include "edac_core.h"
 
-#define I82875P_REVISION	" Ver: 2.0.1 " __DATE__
+#define I82875P_REVISION	" Ver: 2.0.2 " __DATE__
 #define EDAC_MOD_STR		"i82875p_edac"
 
 #define i82875p_printk(level, fmt, arg...) \
diff -puN drivers/edac/r82600_edac.c~drivers-edac-mod-use-edac_coreh drivers/edac/r82600_edac.c
--- a/drivers/edac/r82600_edac.c~drivers-edac-mod-use-edac_coreh
+++ a/drivers/edac/r82600_edac.c
@@ -20,9 +20,9 @@
 #include <linux/pci.h>
 #include <linux/pci_ids.h>
 #include <linux/slab.h>
-#include "edac_mc.h"
+#include "edac_core.h"
 
-#define R82600_REVISION	" Ver: 2.0.1 " __DATE__
+#define R82600_REVISION	" Ver: 2.0.2 " __DATE__
 #define EDAC_MOD_STR	"r82600_edac"
 
 #define r82600_printk(level, fmt, arg...) \
_

Patches currently in -mm which might be from dougthompson@xmission.com are

drivers-edac-remove-depends-on-x86.patch
drivers-edac-add-edac_mc_find-api.patch
drivers-edac-add-rddr2-memory-types.patch
drivers-edac-split-out-functions-to-unique-files.patch
drivers-edac-add-edac_device-class.patch
drivers-edac-mc-sysfs-add-missing-mem-types.patch
drivers-edac-change-from-semaphore-to-mutex-operation.patch
drivers-edac-coreh-fix-scrubdefs.patch
drivers-edac-new-i82443bxgz-mc-driver.patch
drivers-edac-add-new-nmi-rescan.patch
drivers-edac-mod-use-edac_coreh.patch
drivers-edac-add-dev_name-getter-function.patch
drivers-edac-new-inte-30x0-mc-driver.patch
drivers-edac-mod-mc-to-use-workq-instead-of-kthread.patch
drivers-edac-updated-pci-monitoring.patch
drivers-edac-mod-assert_error-check.patch
drivers-edac-core-lindent-cleanup.patch
drivers-edac-edac_device-sysfs-cleanup.patch
drivers-edac-cleanup-workq-ifdefs.patch
drivers-edac-lindent-amd76x.patch
drivers-edac-lindent-i5000.patch
drivers-edac-lindent-e7xxx.patch
drivers-edac-lindent-i3000.patch
drivers-edac-lindent-i82860.patch
drivers-edac-lindent-i82875p.patch
drivers-edac-lindent-e752x.patch
drivers-edac-lindent-i82443bxgx.patch
drivers-edac-lindent-r82600.patch
drivers-edac-drivers-to-use-new-pci-operation.patch
drivers-edac-add-device-sysfs-attributes.patch
drivers-edac-device-output-clenaup.patch
drivers-edac-add-info-kconfig.patch
drivers-edac-update-maintainers-files-for-edac.patch
drivers-edac-cleanup-spaces-gotos-after-lindent-messup.patch
