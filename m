From: akpm@linux-foundation.org
Subject: + rtc-m48t59-fix-section-mismatch-warning.patch added to -mm tree
Date: Thu, 01 Nov 2007 16:42:20 -0700
Message-ID: <200711012342.lA1NgK8f021631@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55132 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754645AbXKAXmq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Nov 2007 19:42:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, a.zummo@towertech.it, david-b@pacbell.net


The patch titled
     rtc: m48t59 fix section mismatch warning
has been added to the -mm tree.  Its filename is
     rtc-m48t59-fix-section-mismatch-warning.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: rtc: m48t59 fix section mismatch warning
From: Randy Dunlap <randy.dunlap@oracle.com>

Change the name of this data to use a name (suffix) that is whitelisted
by MODPOST so that the section warning is fixed (not generated).

WARNING: vmlinux.o(.data+0x1b140): Section mismatch: reference to .init.text:m48t59_rtc_probe (between 'm48t59_rtc_platdrv' and 'm48t59_nvram_attr')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-m48t59.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/rtc/rtc-m48t59.c~rtc-m48t59-fix-section-mismatch-warning drivers/rtc/rtc-m48t59.c
--- a/drivers/rtc/rtc-m48t59.c~rtc-m48t59-fix-section-mismatch-warning
+++ a/drivers/rtc/rtc-m48t59.c
@@ -464,7 +464,7 @@ static int __devexit m48t59_rtc_remove(s
 	return 0;
 }
 
-static struct platform_driver m48t59_rtc_platdrv = {
+static struct platform_driver m48t59_rtc_driver = {
 	.driver		= {
 		.name	= "rtc-m48t59",
 		.owner	= THIS_MODULE,
@@ -475,12 +475,12 @@ static struct platform_driver m48t59_rtc
 
 static int __init m48t59_rtc_init(void)
 {
-	return platform_driver_register(&m48t59_rtc_platdrv);
+	return platform_driver_register(&m48t59_rtc_driver);
 }
 
 static void __exit m48t59_rtc_exit(void)
 {
-	platform_driver_unregister(&m48t59_rtc_platdrv);
+	platform_driver_unregister(&m48t59_rtc_driver);
 }
 
 module_init(m48t59_rtc_init);
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
rtc-m48t59-fix-section-mismatch-warning.patch
git-dvb.patch
git-kbuild.patch
advansys-fix-section-mismatch-warning.patch
aic94-fix-section-mismatches.patch
sym2-fix-section-mismatch-warning.patch
git-unionfs.patch
git-watchdog.patch
hostap-fix-section-mismatch-warning.patch
git-ipwireless_cs.patch
x86-bitops_32h-style-cleanups.patch
voyager-use-struct-instead-of-param.patch
sysctl-fix-token-ring-procname.patch
gbefb-fix-section-mismatch-warnings.patch
vmstat-fix-section-mismatch-warning.patch
register_cpu-__devinit-or-__cpuinit.patch
move-kprobes-examples-to-samples-resend.patch
move-kprobes-examples-to-samples-resend-checkpatch-fixes.patch
fs-menu-small-reorg.patch
profile-likely-unlikely-macros.patch
