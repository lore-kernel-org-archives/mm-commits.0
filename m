From: akpm@linux-foundation.org
Subject: - synclink-standardize-format-of-linux-header-file-includes-with.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:23:23 -0800
Message-ID: <200802070023.m170N48m006494@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55729 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935083AbYBGApC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:45:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@crashcourse.ca, paulkf@microgate.com, mm-commits@vger.kernel.org


The patch titled
     synclink: standardize format of linux header file include's with "<>"
has been removed from the -mm tree.  Its filename was
     synclink-standardize-format-of-linux-header-file-includes-with.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
git-hwmon.patch
git-xfs.patch
