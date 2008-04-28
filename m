From: akpm@linux-foundation.org
Subject: - rtc-silence-section-mismatch-warning-in-rtc-test.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:50:14 -0700
Message-ID: <200804282150.m3SLoEqN017456@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37684 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934500AbYD1Vuf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:50:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sam@ravnborg.org, a.zummo@towertech.it, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     rtc: silence section mismatch warning in rtc-test
has been removed from the -mm tree.  Its filename was
     rtc-silence-section-mismatch-warning-in-rtc-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: silence section mismatch warning in rtc-test
From: Sam Ravnborg <sam@ravnborg.org>

Fix following warning:
WARNING: vmlinux.o(.data+0x253e28): Section mismatch in reference from the variable test_drv to the function .devexit.text:test_remove()

Fix by renaming the platfrom_driver variable from *_drv to *_driver
so modpost ignore the reference to an __devexit section.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-test.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/rtc/rtc-test.c~rtc-silence-section-mismatch-warning-in-rtc-test drivers/rtc/rtc-test.c
--- a/drivers/rtc/rtc-test.c~rtc-silence-section-mismatch-warning-in-rtc-test
+++ a/drivers/rtc/rtc-test.c
@@ -147,7 +147,7 @@ static int __devexit test_remove(struct 
 	return 0;
 }
 
-static struct platform_driver test_drv = {
+static struct platform_driver test_driver = {
 	.probe	= test_probe,
 	.remove = __devexit_p(test_remove),
 	.driver = {
@@ -160,7 +160,7 @@ static int __init test_init(void)
 {
 	int err;
 
-	if ((err = platform_driver_register(&test_drv)))
+	if ((err = platform_driver_register(&test_driver)))
 		return err;
 
 	if ((test0 = platform_device_alloc("rtc-test", 0)) == NULL) {
@@ -191,7 +191,7 @@ exit_free_test0:
 	platform_device_put(test0);
 
 exit_driver_unregister:
-	platform_driver_unregister(&test_drv);
+	platform_driver_unregister(&test_driver);
 	return err;
 }
 
@@ -199,7 +199,7 @@ static void __exit test_exit(void)
 {
 	platform_device_unregister(test0);
 	platform_device_unregister(test1);
-	platform_driver_unregister(&test_drv);
+	platform_driver_unregister(&test_driver);
 }
 
 MODULE_AUTHOR("Alessandro Zummo <a.zummo@towertech.it>");
_

Patches currently in -mm which might be from sam@ravnborg.org are

origin.patch
git-kbuild.patch
git-m32r.patch
pcmcia-silence-section-mismatch-warnings-from-class_interface-variables.patch
pcmcia-silence-section-mismatch-warnings-from-pci_driver-variables.patch
pcmcia-annotate-cb_alloc-with-__ref.patch
git-s390.patch
git-sh.patch
scsi-fix-section-mismatch-in-aic94xx.patch
git-watchdog.patch
cpu-fix-section-mismatch-warnings-in-hotcpu_register.patch
cpu-fix-section-mismatch-warning-in-unregister_cpu_notifier.patch
cpu-fix-section-mismatch-warnings-in-cpu_down.patch
cpu-fix-section-mismatch-warning-in-reference-to-register_cpu_notifier.patch
kbuild-remove-duplicate-conflicting-entry-for-oomh.patch
kbuild-move-files-that-dont-check-__kernel__.patch
documentation-build-source-files-in-documentation-sub-dir.patch
ipmi-remove-unused-target-and-action-in-makefile.patch
tpm-fix-section-mismatch-warning.patch
add-kbuildh-that-contains-common-definitions-for-kbuild-users.patch
x86-use-kbuildh.patch
remove-ifdef-__kernel__-checks-from-unexported-headers.patch

