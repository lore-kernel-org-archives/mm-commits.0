From: akpm@linux-foundation.org
Subject: - git-backlight-sony-fix.patch removed from -mm tree
Date: Thu, 15 Feb 2007 14:06:38 -0800
Message-ID: <200702152206.l1FM6c2D010130@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36348 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161445AbXBOWGn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 17:06:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     git-backlight-sony-fix
has been removed from the -mm tree.  Its filename was
     git-backlight-sony-fix.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: git-backlight-sony-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/Kconfig       |    2 +-
 drivers/misc/sony-laptop.c |    2 --
 2 files changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/misc/sony-laptop.c~git-backlight-sony-fix drivers/misc/sony-laptop.c
--- a/drivers/misc/sony-laptop.c~git-backlight-sony-fix
+++ a/drivers/misc/sony-laptop.c
@@ -285,7 +285,6 @@ static ssize_t sony_acpi_store(struct de
 static struct platform_driver sncpf_driver = {
 	.driver = {
 		   .name = "sony-laptop",
-		   .owner = THIS_MODULE,
 		   }
 };
 static struct platform_device *sncpf_device;
@@ -399,7 +398,6 @@ static int sony_backlight_get_brightness
 
 static struct backlight_device *sony_backlight_device;
 static struct backlight_properties sony_backlight_properties = {
-	.owner = THIS_MODULE,
 	.update_status = sony_backlight_update_status,
 	.get_brightness = sony_backlight_get_brightness,
 	.max_brightness = SONY_MAX_BRIGHTNESS - 1,
diff -puN drivers/misc/Kconfig~git-backlight-sony-fix drivers/misc/Kconfig
--- a/drivers/misc/Kconfig~git-backlight-sony-fix
+++ a/drivers/misc/Kconfig
@@ -109,7 +109,7 @@ config MSI_LAPTOP
 
 config SONY_LAPTOP
 	tristate "Sony Laptop Extras"
-	depends on X86 && ACPI
+	depends on X86 && ACPI && BROKEN
 	select BACKLIGHT_CLASS_DEVICE
 	  ---help---
 	  This mini-driver drives the SNC device present in the ACPI BIOS of
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
git-acpi.patch
git-agpgart.patch
git-arm.patch
git-cpufreq.patch
powerpc-rtas-msi-support-fix.patch
git-dvb.patch
sis-warning-fixes.patch
sata_nv-add-back-some-verbosity-into-adma-error_handler-tidy.patch
git-md-accel-fixes.patch
git-md-accel-warning-fixes.patch
git-md-accel-fix.patch
git-mips-fixup.patch
git-mtd.patch
git-netdev-all.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
Fabric7-VIOC-driver-fixes.patch
git-backlight.patch
git-backlight-sony-fix.patch
git-sh.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-unionfs-fixup.patch
before-x86_64-mm-mmconfig-share.patch
after-before-x86_64-mm-mmconfig-share.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
kprobes-list-all-active-probes-in-the-system.patch
reduce-size-of-task_struct-on-64-bit-machines-fix.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
add-epoll-compat-code-to-kernel-compatc-tidy.patch
genalloc-warning-fixes.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
revert-x86_64-mm-putreg-check.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
git-gccbug-fixup.patch
