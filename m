From: akpm@linux-foundation.org
Subject: + printk-convert-the-format-for-kern_level-to-a-2-byte-pattern.patch added to -mm tree
Date: Wed, 06 Jun 2012 14:47:04 -0700
Message-ID: <20120606214704.C68DEA0274@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:33305 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756307Ab2FFVrG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Jun 2012 17:47:06 -0400
Received: by qcsp5 with SMTP id p5so764031qcs.1
        for <mm-commits@vger.kernel.org>; Wed, 06 Jun 2012 14:47:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, kay.sievers@vrfy.org


The patch titled
     Subject: printk: convert the format for KERN_<LEVEL> to a 2 byte pattern
has been added to the -mm tree.  Its filename is
     printk-convert-the-format-for-kern_level-to-a-2-byte-pattern.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
 kernel/printk.c             |    3 ++-
 3 files changed, 18 insertions(+), 14 deletions(-)

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
diff -puN kernel/printk.c~printk-convert-the-format-for-kern_level-to-a-2-byte-pattern kernel/printk.c
--- a/kernel/printk.c~printk-convert-the-format-for-kern_level-to-a-2-byte-pattern
+++ a/kernel/printk.c
@@ -1342,9 +1342,10 @@ asmlinkage int vprintk_emit(int facility
 		case 'd':	/* KERN_DEFAULT */
 			prefix = true;
 		case 'c':	/* KERN_CONT */
+			break;
 		}
 		text_len -=  end_of_header - text;
-		text = end_of_header;
+		text = (char *)end_of_header;
 	}
 
 	if (level == -1)
_
Subject: Subject: printk: convert the format for KERN_<LEVEL> to a 2 byte pattern

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
maintainers-whitespace-fixes.patch
printk-add-generic-functions-to-find-kern_level-headers.patch
printk-add-kern_levelsh-to-make-kern_level-available-for-asm-use.patch
arch-remove-direct-definitions-of-kern_level-uses.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-checkpatch-fixes.patch
sound-use-printk_get_level-and-printk_skip_level.patch
staging-wlags49_h2-remove-direct-declarations-of-kern_level-prefixes.patch
printk-convert-the-format-for-kern_level-to-a-2-byte-pattern.patch
printk-only-look-for-prefix-levels-in-kernel-messages.patch
printk-remove-the-now-unnecessary-c-annotation-for-kern_cont.patch

