From: akpm@linux-foundation.org
Subject: + cris-build-fixes-fix-crisksymsc.patch added to -mm tree
Date: Tue, 30 Oct 2007 15:13:05 -0700
Message-ID: <200710302213.l9UMD5oe030508@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59111 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752810AbXJ3WNJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Oct 2007 18:13:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jesper.nilsson@axis.com, starvik@axis.com


The patch titled
     cris build fixes: fix crisksyms.c
has been added to the -mm tree.  Its filename is
     cris-build-fixes-fix-crisksymsc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

cris-build-fixes-fix-csum_tcpudp_magic-declaration.patch
cris-build-fixes-add-missing-syscalls.patch
cris-build-fixes-hardirqh-include-asm-irqh.patch
cris-build-fixes-atomich-needs-compilerh.patch
cris-build-fixes-atomich-needs-compilerh-fix.patch
cris-build-fixes-irq-fixes.patch
cris-build-fixes-sys_crisc-needs-fsh.patch
cris-build-fixes-add-baud-rate-defines.patch
cris-build-fixes-update-eth_v10c-ethernet-driver.patch
cris-build-fixes-update-eth_v10c-ethernet-driver-fix.patch
cris-build-fixes-fix-mtdramh.patch
cris-build-fixes-fix-mtdramh-checkpatch-fixes.patch
cris-build-fixes-corrected-and-improved-nmi-and-irq-handling.patch
cris-build-fixes-fixes-in-arch-cris-kernel-timec-checkpatch-fixes.patch
cris-build-fixes-fixes-in-arch-cris-kernel-timec.patch
cris-build-fixes-setupc-needs-paramh.patch
cris-build-fixes-fix-crisksymsc.patch
cris-build-fixes-defconfig-updates.patch
