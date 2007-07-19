From: akpm@linux-foundation.org
Subject: - slow-down-printk-during-boot-fix.patch removed from -mm tree
Date: Thu, 19 Jul 2007 00:51:34 -0700
Message-ID: <200707190751.l6J7pY08020780@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42162 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759273AbXGSIYl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 04:24:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, davej@redhat.com, rdunlap@xenotime.net, mm-commits@vger.kernel.org


The patch titled
     slow-down-printk-during-boot-fix
has been removed from the -mm tree.  Its filename was
     slow-down-printk-during-boot-fix.patch

This patch was dropped because it was folded into slow-down-printk-during-boot.patch

------------------------------------------------------
Subject: slow-down-printk-during-boot-fix
From: Andrew Morton <akpm@linux-foundation.org>

Not all architectures implement CONFIG_HZ.

Cc: Dave Jones <davej@redhat.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN kernel/printk.c~slow-down-printk-during-boot-fix kernel/printk.c
--- a/kernel/printk.c~slow-down-printk-during-boot-fix
+++ a/kernel/printk.c
@@ -172,7 +172,7 @@ unsigned long long printk_delay_msec; /*
 static int __init boot_delay_setup(char *str)
 {
 	unsigned long lpj = preset_lpj ? preset_lpj : 1000000; /* some guess */
-	unsigned long long loops_per_msec = lpj / 1000 * CONFIG_HZ;
+	unsigned long long loops_per_msec = lpj / 1000 * HZ;
 
 	get_option(&str, &boot_delay);
 	if (boot_delay > 10 * 1000)
@@ -180,8 +180,8 @@ static int __init boot_delay_setup(char 
 
 	printk_delay_msec = loops_per_msec;
 	printk(KERN_DEBUG "boot_delay: %u, preset_lpj: %ld, lpj: %lu, "
-		"CONFIG_HZ: %d, printk_delay_msec: %llu\n",
-		boot_delay, preset_lpj, lpj, CONFIG_HZ, printk_delay_msec);
+		"HZ: %d, printk_delay_msec: %llu\n",
+		boot_delay, preset_lpj, lpj, HZ, printk_delay_msec);
 	return 1;
 }
 __setup("boot_delay=", boot_delay_setup);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-fault-feedback-2.patch
freezer-run-show_state-when-freezing-times-out.patch
pm-introduce-hibernation-and-suspend-notifiers.patch
pm-disable-usermode-helper-before-hibernation-and-suspend.patch
slow-down-printk-during-boot.patch
slow-down-printk-during-boot-fix.patch
kernel-doc-fix-leading-dot-in-man-mode-output.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags.patch
lockstat-core-infrastructure.patch
lockstat-human-readability-tweaks.patch
lockdep-various-fixes.patch
lockstat-measure-lock-bouncing.patch
some-kmalloc-memset-kzalloc-tree-wide.patch
dequeue_huge_page-warning-fix.patch
lguest-the-host-code.patch
lguest-the-net-driver.patch
drivers-edac-new-i82443bxgz-mc-driver-broken.patch
drivers-edac-fix-e752x-reversed-csrows-fix.patch
drivers-edac-new-pasemi-driver-fix.patch
drivers-edac-new-i82975x-driver-fix.patch
kernel-sysctlc-finish-off-the-warning-comments.patch
afs-build-fix.patch
