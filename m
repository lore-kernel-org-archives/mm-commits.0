From: akpm@linux-foundation.org
Subject: + net-remove-a-collection-of-unneeded-undef-really_slow_io.patch added to -mm tree
Date: Sun, 25 Feb 2007 04:54:03 -0800
Message-ID: <200702251254.l1PCs5rb029625@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35444 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964879AbXBYMyZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Feb 2007 07:54:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com


The patch titled
     net: remove a collection of unneeded #undef REALLY_SLOW_IO stuff
has been added to the -mm tree.  Its filename is
     net-remove-a-collection-of-unneeded-undef-really_slow_io.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: net: remove a collection of unneeded #undef REALLY_SLOW_IO stuff
From: Alan <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/de600.c              |    6 ------
 drivers/net/ni52.c               |    2 --
 drivers/net/skfp/cfm.c           |    2 +-
 drivers/net/sun3_82586.c         |    2 --
 drivers/net/wan/cosa.c           |    1 -
 drivers/net/wireless/wl3501_cs.c |    1 -
 6 files changed, 1 insertion(+), 13 deletions(-)

diff -puN drivers/net/de600.c~net-remove-a-collection-of-unneeded-undef-really_slow_io drivers/net/de600.c
--- a/drivers/net/de600.c~net-remove-a-collection-of-unneeded-undef-really_slow_io
+++ a/drivers/net/de600.c
@@ -38,12 +38,6 @@ static const char version[] = "de600.c: 
 /* Add more time here if your adapter won't work OK: */
 #define DE600_SLOW_DOWN	udelay(delay_time)
 
- /*
- * If you still have trouble reading/writing to the adapter,
- * modify the following "#define": (see <asm/io.h> for more info)
-#define REALLY_SLOW_IO
- */
-
 /* use 0 for production, 1 for verification, >2 for debug */
 #ifdef DE600_DEBUG
 #define PRINTK(x) if (de600_debug >= 2) printk x
diff -puN drivers/net/ni52.c~net-remove-a-collection-of-unneeded-undef-really_slow_io drivers/net/ni52.c
--- a/drivers/net/ni52.c~net-remove-a-collection-of-unneeded-undef-really_slow_io
+++ a/drivers/net/ni52.c
@@ -104,8 +104,6 @@ static int automatic_resume; /* experime
 static int rfdadd;	/* rfdadd=1 may be better for 8K MEM cards */
 static int fifo=0x8;	/* don't change */
 
-/* #define REALLY_SLOW_IO */
-
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
diff -puN drivers/net/skfp/cfm.c~net-remove-a-collection-of-unneeded-undef-really_slow_io drivers/net/skfp/cfm.c
--- a/drivers/net/skfp/cfm.c~net-remove-a-collection-of-unneeded-undef-really_slow_io
+++ a/drivers/net/skfp/cfm.c
@@ -73,7 +73,7 @@ static const char * const cfm_events[] =
 /*
  * map from state to downstream port type
  */
-static const u_char cf_to_ptype[] = {
+static const unsigned char cf_to_ptype[] = {
 	TNONE,TNONE,TNONE,TNONE,TNONE,
 	TNONE,TB,TB,TS,
 	TA,TB,TS,TB
diff -puN drivers/net/sun3_82586.c~net-remove-a-collection-of-unneeded-undef-really_slow_io drivers/net/sun3_82586.c
--- a/drivers/net/sun3_82586.c~net-remove-a-collection-of-unneeded-undef-really_slow_io
+++ a/drivers/net/sun3_82586.c
@@ -28,8 +28,6 @@ static int automatic_resume = 0; /* expe
 static int rfdadd = 0; /* rfdadd=1 may be better for 8K MEM cards */
 static int fifo=0x8;	/* don't change */
 
-/* #define REALLY_SLOW_IO */
-
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
diff -puN drivers/net/wan/cosa.c~net-remove-a-collection-of-unneeded-undef-really_slow_io drivers/net/wan/cosa.c
--- a/drivers/net/wan/cosa.c~net-remove-a-collection-of-unneeded-undef-really_slow_io
+++ a/drivers/net/wan/cosa.c
@@ -94,7 +94,6 @@
 #include <linux/device.h>
 
 #undef COSA_SLOW_IO	/* for testing purposes only */
-#undef REALLY_SLOW_IO
 
 #include <asm/io.h>
 #include <asm/dma.h>
diff -puN drivers/net/wireless/wl3501_cs.c~net-remove-a-collection-of-unneeded-undef-really_slow_io drivers/net/wireless/wl3501_cs.c
--- a/drivers/net/wireless/wl3501_cs.c~net-remove-a-collection-of-unneeded-undef-really_slow_io
+++ a/drivers/net/wireless/wl3501_cs.c
@@ -26,7 +26,6 @@
  * Tested with Planet AP in 2.5.73-bk, 216 Kbytes/s in Infrastructure mode
  * with a SMP machine (dual pentium 100), using pktgen, 432 pps (pkt_size = 60)
  */
-#undef REALLY_SLOW_IO	/* most systems can safely undef this */
 
 #include <linux/delay.h>
 #include <linux/types.h>
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
net-remove-a-collection-of-unneeded-undef-really_slow_io.patch
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
