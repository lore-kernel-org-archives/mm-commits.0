From: akpm@linux-foundation.org
Subject: + printk-remove-the-now-unnecessary-c-annotation-for-kern_cont.patch added to -mm tree
Date: Wed, 06 Jun 2012 14:47:17 -0700
Message-ID: <20120606214717.E3FE9A0274@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:38845 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756307Ab2FFVrT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Jun 2012 17:47:19 -0400
Received: by mail-lpp01m010-f74.google.com with SMTP id r15so424671lag.1
        for <mm-commits@vger.kernel.org>; Wed, 06 Jun 2012 14:47:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, kay.sievers@vrfy.org


The patch titled
     Subject: printk: remove the now unnecessary "C" annotation for KERN_CONT
has been added to the -mm tree.  Its filename is
     printk-remove-the-now-unnecessary-c-annotation-for-kern_cont.patch

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
Subject: printk: remove the now unnecessary "C" annotation for KERN_CONT

Now that all KERN_<LEVEL> uses are prefixed with ASCII SOH, there is no
need for a KERN_CONT.  Keep it backward compatible by adding #define
KERN_CONT ""

Reduces kernel image size a thousand bytes.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kern_levels.h |    2 +-
 include/linux/printk.h      |    2 --
 2 files changed, 1 insertion(+), 3 deletions(-)

diff -puN include/linux/kern_levels.h~printk-remove-the-now-unnecessary-c-annotation-for-kern_cont include/linux/kern_levels.h
--- a/include/linux/kern_levels.h~printk-remove-the-now-unnecessary-c-annotation-for-kern_cont
+++ a/include/linux/kern_levels.h
@@ -20,6 +20,6 @@
  * line that had no enclosing \n). Only to be used by core/arch code
  * during early bootup (a continued line is not SMP-safe otherwise).
  */
-#define KERN_CONT	KERN_SOH "c"
+#define KERN_CONT	""
 
 #endif
diff -puN include/linux/printk.h~printk-remove-the-now-unnecessary-c-annotation-for-kern_cont include/linux/printk.h
--- a/include/linux/printk.h~printk-remove-the-now-unnecessary-c-annotation-for-kern_cont
+++ a/include/linux/printk.h
@@ -13,7 +13,6 @@ static inline int printk_get_level(const
 		switch (buffer[1]) {
 		case '0' ... '7':
 		case 'd':	/* KERN_DEFAULT */
-		case 'c':	/* KERN_CONT */
 			return buffer[1];
 		}
 	}
@@ -26,7 +25,6 @@ static inline const char *printk_skip_le
 		switch (buffer[1]) {
 		case '0' ... '7':
 		case 'd':	/* KERN_DEFAULT */
-		case 'c':	/* KERN_CONT */
 			return buffer + 2;
 		}
 	}
_
Subject: Subject: printk: remove the now unnecessary "C" annotation for KERN_CONT

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

