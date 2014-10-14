From: akpm@linux-foundation.org
Subject: [merged] arm-replace-strnicmp-with-strncasecmp.patch removed from -mm tree
Date: Tue, 14 Oct 2014 11:22:06 -0700
Message-ID: <543d69ce.VKmoo5CzrE1oVfOh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44482 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754638AbaJNSWF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:22:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, linux@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: ARM: replace strnicmp with strncasecmp
has been removed from the -mm tree.  Its filename was
     arm-replace-strnicmp-with-strncasecmp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: ARM: replace strnicmp with strncasecmp

The kernel used to contain two functions for length-delimited,
case-insensitive string comparison, strnicmp with correct semantics and a
slightly buggy strncasecmp.  The latter is the POSIX name, so strnicmp was
renamed to strncasecmp, and strnicmp made into a wrapper for the new
strncasecmp to avoid breaking existing users.

To allow the compat wrapper strnicmp to be removed at some point in the
future, and to avoid the extra indirection cost, do
s/strnicmp/strncasecmp/g.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-pxa/lpd270.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN arch/arm/mach-pxa/lpd270.c~arm-replace-strnicmp-with-strncasecmp arch/arm/mach-pxa/lpd270.c
--- a/arch/arm/mach-pxa/lpd270.c~arm-replace-strnicmp-with-strncasecmp
+++ a/arch/arm/mach-pxa/lpd270.c
@@ -416,17 +416,17 @@ static struct pxafb_mach_info *lpd270_lc
 
 static int __init lpd270_set_lcd(char *str)
 {
-	if (!strnicmp(str, "lq057q3dc02", 11)) {
+	if (!strncasecmp(str, "lq057q3dc02", 11)) {
 		lpd270_lcd_to_use = &sharp_lq057q3dc02;
-	} else if (!strnicmp(str, "lq121s1dg31", 11)) {
+	} else if (!strncasecmp(str, "lq121s1dg31", 11)) {
 		lpd270_lcd_to_use = &sharp_lq121s1dg31;
-	} else if (!strnicmp(str, "lq036q1da01", 11)) {
+	} else if (!strncasecmp(str, "lq036q1da01", 11)) {
 		lpd270_lcd_to_use = &sharp_lq036q1da01;
-	} else if (!strnicmp(str, "lq64d343", 8)) {
+	} else if (!strncasecmp(str, "lq64d343", 8)) {
 		lpd270_lcd_to_use = &sharp_lq64d343;
-	} else if (!strnicmp(str, "lq10d368", 8)) {
+	} else if (!strncasecmp(str, "lq10d368", 8)) {
 		lpd270_lcd_to_use = &sharp_lq10d368;
-	} else if (!strnicmp(str, "lq035q7db02-20", 14)) {
+	} else if (!strncasecmp(str, "lq035q7db02-20", 14)) {
 		lpd270_lcd_to_use = &sharp_lq035q7db02_20;
 	} else {
 		printk(KERN_INFO "lpd270: unknown lcd panel [%s]\n", str);
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

origin.patch
linux-next.patch

