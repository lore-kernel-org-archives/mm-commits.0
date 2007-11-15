From: akpm@linux-foundation.org
Subject: - cris-build-fixes-fix-crisksymsc.patch removed from -mm tree
Date: Thu, 15 Nov 2007 13:11:54 -0800
Message-ID: <200711152111.lAFLBsVG015805@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42390 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760684AbXKOVRF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 16:17:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.nilsson@axis.com, starvik@axis.com, mm-commits@vger.kernel.org


The patch titled
     cris build fixes: fix crisksyms.c
has been removed from the -mm tree.  Its filename was
     cris-build-fixes-fix-crisksymsc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cris build fixes: fix crisksyms.c
From: Jesper Nilsson <jesper.nilsson@axis.com>

- Add __negdi2 to exported symbols.
- Remove string functions from exported symbols.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
Acked-by: Mikael Starvik <starvik@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/kernel/crisksyms.c |   17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff -puN arch/cris/kernel/crisksyms.c~cris-build-fixes-fix-crisksymsc arch/cris/kernel/crisksyms.c
--- a/arch/cris/kernel/crisksyms.c~cris-build-fixes-fix-crisksymsc
+++ a/arch/cris/kernel/crisksyms.c
@@ -27,6 +27,7 @@ extern void __Mod(void);
 extern void __ashldi3(void);
 extern void __ashrdi3(void);
 extern void __lshrdi3(void);
+extern void __negdi2(void);
 extern void iounmap(volatile void * __iomem);
 
 /* Platform dependent support */
@@ -34,19 +35,6 @@ EXPORT_SYMBOL(kernel_thread);
 EXPORT_SYMBOL(get_cmos_time);
 EXPORT_SYMBOL(loops_per_usec);
 
-/* String functions */
-EXPORT_SYMBOL(memcmp);
-EXPORT_SYMBOL(memmove);
-EXPORT_SYMBOL(strstr);
-EXPORT_SYMBOL(strcpy);
-EXPORT_SYMBOL(strchr);
-EXPORT_SYMBOL(strcmp);
-EXPORT_SYMBOL(strlen);
-EXPORT_SYMBOL(strcat);
-EXPORT_SYMBOL(strncat);
-EXPORT_SYMBOL(strncmp);
-EXPORT_SYMBOL(strncpy);
-
 /* Math functions */
 EXPORT_SYMBOL(__Udiv);
 EXPORT_SYMBOL(__Umod);
@@ -55,6 +43,7 @@ EXPORT_SYMBOL(__Mod);
 EXPORT_SYMBOL(__ashldi3);
 EXPORT_SYMBOL(__ashrdi3);
 EXPORT_SYMBOL(__lshrdi3);
+EXPORT_SYMBOL(__negdi2);
 
 /* Memory functions */
 EXPORT_SYMBOL(__ioremap);
@@ -84,4 +73,4 @@ EXPORT_SYMBOL(start_one_shot_timer);
 EXPORT_SYMBOL(del_fast_timer);
 EXPORT_SYMBOL(schedule_usleep);
 #endif
-
+EXPORT_SYMBOL(csum_partial);
_

Patches currently in -mm which might be from jesper.nilsson@axis.com are

origin.patch
cris-build-fixes-atomich-needs-compilerh.patch
git-mtd.patch
