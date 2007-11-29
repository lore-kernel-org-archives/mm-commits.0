From: akpm@linux-foundation.org
Subject: + synclink-standardize-format-of-linux-header-file-includes-with.patch added to -mm tree
Date: Thu, 29 Nov 2007 13:22:16 -0800
Message-ID: <200711292122.lATLMGSb007945@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42158 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760273AbXK2VWZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Nov 2007 16:22:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@crashcourse.ca, paulkf@microgate.com


The patch titled
     synclink: standardize format of linux header file include's with "<>"
has been added to the -mm tree.  Its filename is
     synclink-standardize-format-of-linux-header-file-includes-with.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: synclink: standardize format of linux header file include's with "<>"
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

Use the recommended form of "<>" to include linux header files, and
move those includes up to join the rest of the linux includes.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Acked-by: Paul Fulghum <paulkf@microgate.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/pcmcia/synclink_cs.c |    3 +--
 drivers/char/synclink.c           |    3 +--
 drivers/char/synclink_gt.c        |    3 +--
 drivers/char/synclinkmp.c         |    3 +--
 4 files changed, 4 insertions(+), 8 deletions(-)

diff -puN drivers/char/pcmcia/synclink_cs.c~synclink-standardize-format-of-linux-header-file-includes-with drivers/char/pcmcia/synclink_cs.c
--- a/drivers/char/pcmcia/synclink_cs.c~synclink-standardize-format-of-linux-header-file-includes-with
+++ a/drivers/char/pcmcia/synclink_cs.c
@@ -57,6 +57,7 @@
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/ioctl.h>
+#include <linux/synclink.h>
 
 #include <asm/system.h>
 #include <asm/io.h>
@@ -87,8 +88,6 @@
 
 #include <asm/uaccess.h>
 
-#include "linux/synclink.h"
-
 static MGSL_PARAMS default_params = {
 	MGSL_MODE_HDLC,			/* unsigned long mode */
 	0,				/* unsigned char loopback; */
diff -puN drivers/char/synclink.c~synclink-standardize-format-of-linux-header-file-includes-with drivers/char/synclink.c
--- a/drivers/char/synclink.c~synclink-standardize-format-of-linux-header-file-includes-with
+++ a/drivers/char/synclink.c
@@ -85,6 +85,7 @@
 #include <linux/vmalloc.h>
 #include <linux/init.h>
 #include <linux/ioctl.h>
+#include <linux/synclink.h>
 
 #include <asm/system.h>
 #include <asm/io.h>
@@ -110,8 +111,6 @@
 
 #include <asm/uaccess.h>
 
-#include "linux/synclink.h"
-
 #define RCLRVALUE 0xffff
 
 static MGSL_PARAMS default_params = {
diff -puN drivers/char/synclink_gt.c~synclink-standardize-format-of-linux-header-file-includes-with drivers/char/synclink_gt.c
--- a/drivers/char/synclink_gt.c~synclink-standardize-format-of-linux-header-file-includes-with
+++ a/drivers/char/synclink_gt.c
@@ -73,6 +73,7 @@
 #include <linux/bitops.h>
 #include <linux/workqueue.h>
 #include <linux/hdlc.h>
+#include <linux/synclink.h>
 
 #include <asm/system.h>
 #include <asm/io.h>
@@ -81,8 +82,6 @@
 #include <asm/types.h>
 #include <asm/uaccess.h>
 
-#include "linux/synclink.h"
-
 #if defined(CONFIG_HDLC) || (defined(CONFIG_HDLC_MODULE) && defined(CONFIG_SYNCLINK_GT_MODULE))
 #define SYNCLINK_GENERIC_HDLC 1
 #else
diff -puN drivers/char/synclinkmp.c~synclink-standardize-format-of-linux-header-file-includes-with drivers/char/synclinkmp.c
--- a/drivers/char/synclinkmp.c~synclink-standardize-format-of-linux-header-file-includes-with
+++ a/drivers/char/synclinkmp.c
@@ -66,6 +66,7 @@
 #include <linux/termios.h>
 #include <linux/workqueue.h>
 #include <linux/hdlc.h>
+#include <linux/synclink.h>
 
 #if defined(CONFIG_HDLC) || (defined(CONFIG_HDLC_MODULE) && defined(CONFIG_SYNCLINKMP_MODULE))
 #define SYNCLINK_GENERIC_HDLC 1
@@ -80,8 +81,6 @@
 
 #include <asm/uaccess.h>
 
-#include "linux/synclink.h"
-
 static MGSL_PARAMS default_params = {
 	MGSL_MODE_HDLC,			/* unsigned long mode */
 	0,				/* unsigned char loopback; */
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

origin.patch
git-arm.patch
git-hwmon.patch
git-mips.patch
pcmcia-net-use-roundup_pow_of_two-macro-instead-of-grotesque-loop.patch
git-nfsd.patch
git-xfs.patch
frv-move-dma-macros-to-scatterlisth-for-consistency.patch
m68knommu-remove-vestiges-of-non-existent-disktel.patch
uml-delete-some-unused-headers.patch
rd-use-is_power_of_2-in-drivers-block-rdc.patch
log2h-define-order_base_2-macro-for-convenience.patch
a-few-corrections-to-include-linux-kbuild.patch
ncpfs-update-diagnostic-strings-to-match-routine-names.patch
hfs-update-comment-to-reflect-actual-init-and-exit-routines.patch
synclink-standardize-format-of-linux-header-file-includes-with.patch
rtc-s3c-use-is_power_of_2-macro-for-simplicity.patch
