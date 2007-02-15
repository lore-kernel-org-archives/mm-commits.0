From: akpm@linux-foundation.org
Subject: - fix-warning-in-device_add_attrs.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:51:03 -0800
Message-ID: <200702150851.l1F8p3J7025272@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40280 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965534AbXBOIvV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:51:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, greg@kroah.com, khali@linux-fr.org, mm-commits@vger.kernel.org


The patch titled
     device_add_attrs() cleanup
has been removed from the -mm tree.  Its filename was
     fix-warning-in-device_add_attrs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: device_add_attrs() cleanup
From: Andrew Morton <akpm@linux-foundation.org>

Clean up the coding in device_add_attrs() a bit.

Cc: Jean Delvare <khali@linux-fr.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/bus.c |   22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff -puN drivers/base/bus.c~fix-warning-in-device_add_attrs drivers/base/bus.c
--- a/drivers/base/bus.c~fix-warning-in-device_add_attrs
+++ a/drivers/base/bus.c
@@ -324,27 +324,25 @@ int bus_for_each_drv(struct bus_type * b
 	return error;
 }
 
-static int device_add_attrs(struct bus_type * bus, struct device * dev)
+static int device_add_attrs(struct bus_type *bus, struct device *dev)
 {
 	int error = 0;
 	int i;
 
-	if (bus->dev_attrs) {
-		for (i = 0; attr_name(bus->dev_attrs[i]); i++) {
-			error = device_create_file(dev,&bus->dev_attrs[i]);
-			if (error)
-				goto Err;
+	if (!bus->dev_attrs)
+		return 0;
+
+	for (i = 0; attr_name(bus->dev_attrs[i]); i++) {
+		error = device_create_file(dev,&bus->dev_attrs[i]);
+		if (error) {
+			while (--i >= 0)
+				device_remove_file(dev, &bus->dev_attrs[i]);
+			break;
 		}
 	}
- Done:
 	return error;
- Err:
-	while (--i >= 0)
-		device_remove_file(dev,&bus->dev_attrs[i]);
-	goto Done;
 }
 
-
 static void device_remove_attrs(struct bus_type * bus, struct device * dev)
 {
 	int i;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
git-acpi.patch
git-agpgart.patch
git-arm.patch
git-cpufreq.patch
powerpc-rtas-msi-support-fix.patch
git-drm.patch
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
mm-shrink-parent-dentries-when-shrinking-slab.patch
add-epoll-compat-code-to-kernel-compatc-tidy.patch
revert-x86_64-mm-putreg-check.patch
git-gccbug-fixup.patch
