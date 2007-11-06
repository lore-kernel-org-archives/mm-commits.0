From: akpm@linux-foundation.org
Subject: - rtc-m48t59-fix-section-mismatch-warning.patch removed from -mm tree
Date: Mon, 05 Nov 2007 21:52:20 -0800
Message-ID: <200711060552.lA65qKuP007288@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36623 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753954AbXKFF4P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Nov 2007 00:56:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, a.zummo@towertech.it, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     rtc: m48t59 fix section mismatch warning
has been removed from the -mm tree.  Its filename was
     rtc-m48t59-fix-section-mismatch-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
git-dvb.patch
git-kbuild.patch
advansys-fix-section-mismatch-warning.patch
aic94-fix-section-mismatches.patch
sym2-fix-section-mismatch-warning.patch
git-unionfs.patch
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
