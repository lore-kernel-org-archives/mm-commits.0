From: akpm@linux-foundation.org
Subject: [merged] printk-convert-the-format-for-kern_level-to-a-2-byte-pattern.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:49:39 -0700
Message-ID: <20120731184940.1961A5C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:33577 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756263Ab2GaStm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:49:42 -0400
Received: by wibhr14 with SMTP id hr14so146945wib.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:49:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, kay.sievers@vrfy.org, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: convert the format for KERN_<LEVEL> to a 2 byte pattern
has been removed from the -mm tree.  Its filename was
     printk-convert-the-format-for-kern_level-to-a-2-byte-pattern.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: printk: convert the format for KERN_<LEVEL> to a 2 byte pattern

Instead of "<.>", use an ASCII SOH for the KERN_<LEVEL> prefix initiator.

This saves 1 byte per printk, thousands of bytes in a normal kernel.

No output changes are produced as vprintk_emit converts these uses to
"<.>".

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kern_levels.h |   25 ++++++++++++++-----------
 include/linux/printk.h      |    4 ++--
 2 files changed, 16 insertions(+), 13 deletions(-)

diff -puN include/linux/kern_levels.h~printk-convert-the-format-for-kern_level-to-a-2-byte-pattern include/linux/kern_levels.h
--- a/include/linux/kern_levels.h~printk-convert-the-format-for-kern_level-to-a-2-byte-pattern
+++ a/include/linux/kern_levels.h
@@ -1,22 +1,25 @@
 #ifndef __KERN_LEVELS_H__
 #define __KERN_LEVELS_H__
 
-#define KERN_EMERG	"<0>"	/* system is unusable			*/
-#define KERN_ALERT	"<1>"	/* action must be taken immediately	*/
-#define KERN_CRIT	"<2>"	/* critical conditions			*/
-#define KERN_ERR	"<3>"	/* error conditions			*/
-#define KERN_WARNING	"<4>"	/* warning conditions			*/
-#define KERN_NOTICE	"<5>"	/* normal but significant condition	*/
-#define KERN_INFO	"<6>"	/* informational			*/
-#define KERN_DEBUG	"<7>"	/* debug-level messages			*/
+#define KERN_SOH	"\001"		/* ASCII Start Of Header */
+#define KERN_SOH_ASCII	'\001'
+
+#define KERN_EMERG	KERN_SOH "0"	/* system is unusable */
+#define KERN_ALERT	KERN_SOH "1"	/* action must be taken immediately */
+#define KERN_CRIT	KERN_SOH "2"	/* critical conditions */
+#define KERN_ERR	KERN_SOH "3"	/* error conditions */
+#define KERN_WARNING	KERN_SOH "4"	/* warning conditions */
+#define KERN_NOTICE	KERN_SOH "5"	/* normal but significant condition */
+#define KERN_INFO	KERN_SOH "6"	/* informational */
+#define KERN_DEBUG	KERN_SOH "7"	/* debug-level messages */
+
+#define KERN_DEFAULT	KERN_SOH "d"	/* the default kernel loglevel */
 
-/* Use the default kernel loglevel */
-#define KERN_DEFAULT	"<d>"
 /*
  * Annotation for a "continued" line of log printout (only done after a
  * line that had no enclosing \n). Only to be used by core/arch code
  * during early bootup (a continued line is not SMP-safe otherwise).
  */
-#define KERN_CONT	"<c>"
+#define KERN_CONT	KERN_SOH "c"
 
 #endif
diff -puN include/linux/printk.h~printk-convert-the-format-for-kern_level-to-a-2-byte-pattern include/linux/printk.h
--- a/include/linux/printk.h~printk-convert-the-format-for-kern_level-to-a-2-byte-pattern
+++ a/include/linux/printk.h
@@ -9,7 +9,7 @@ extern const char linux_proc_banner[];
 
 static inline int printk_get_level(const char *buffer)
 {
-	if (buffer[0] == '<' && buffer[1] && buffer[2] == '>') {
+	if (buffer[0] == KERN_SOH_ASCII && buffer[1]) {
 		switch (buffer[1]) {
 		case '0' ... '7':
 		case 'd':	/* KERN_DEFAULT */
@@ -27,7 +27,7 @@ static inline const char *printk_skip_le
 		case '0' ... '7':
 		case 'd':	/* KERN_DEFAULT */
 		case 'c':	/* KERN_CONT */
-			return buffer + 3;
+			return buffer + 2;
 		}
 	}
 	return buffer;
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
dynamic_debug-restore-dev_dbg-netdev_dbg-functionality-reduce-stack-use.patch
dynamic_debug-restore-dev_dbg-netdev_dbg-functionality-reduce-stack-use-v2.patch
linux-next.patch
thermal-add-renesas-r-car-thermal-sensor-support.patch

