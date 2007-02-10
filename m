From: akpm@linux-foundation.org
Subject: - acpi-bay-driver-warning-fix.patch removed from -mm tree
Date: Fri, 09 Feb 2007 21:23:11 -0800
Message-ID: <200702100523.l1A5NBvF004519@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36690 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752682AbXBJFYd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 10 Feb 2007 00:24:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kristen.c.accardi@intel.com, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     acpi: bay driver warning fix
has been removed from the -mm tree.  Its filename was
     acpi-bay-driver-warning-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: acpi: bay driver warning fix
From: Andrew Morton <akpm@linux-foundation.org>

drivers/acpi/bay.c: In function 'bay_add':
drivers/acpi/bay.c:310: warning: statement with no effect

Fix it by rewriting those macros in C.  Much nicer.

Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/acpi/acpi_drivers.h |   24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff -puN include/acpi/acpi_drivers.h~acpi-bay-driver-warning-fix include/acpi/acpi_drivers.h
--- a/include/acpi/acpi_drivers.h~acpi-bay-driver-warning-fix
+++ a/include/acpi/acpi_drivers.h
@@ -122,10 +122,24 @@ extern int register_hotplug_dock_device(
 	acpi_notify_handler handler, void *context);
 extern void unregister_hotplug_dock_device(acpi_handle handle);
 #else
-#define is_dock_device(h)			(0)
-#define register_dock_notifier(nb) 		(-ENODEV)
-#define unregister_dock_notifier(nb)           	do { } while(0)
-#define register_hotplug_dock_device(h1, h2, c)	(-ENODEV)
-#define unregister_hotplug_dock_device(h)       do { } while(0)
+static inline int is_dock_device(acpi_handle handle)
+{
+	return 0;
+}
+static inline int register_dock_notifier(struct notifier_block *nb)
+{
+	return -ENODEV;
+}
+static inline void unregister_dock_notifier(struct notifier_block *nb)
+{
+}
+static inline int register_hotplug_dock_device(acpi_handle handle,
+				acpi_notify_handler handler, void *context)
+{
+	return -ENODEV;
+}
+static inline void unregister_hotplug_dock_device(acpi_handle handle)
+{
+}
 #endif
 #endif /*__ACPI_DRIVERS_H__*/
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
git-acpi.patch
git-cifs-fix.patch
fix-warning-in-device_add_attrs.patch
git-drm.patch
git-dvb.patch
git-infiniband.patch
git-input.patch
git-libata-all.patch
sis-warning-fixes.patch
git-libata-all-lib-iomapc-fix-for-config_pci=n.patch
git-md-accel-fixes.patch
git-md-accel-warning-fixes.patch
git-md-accel-fix.patch
git-mips-fixup.patch
git-mtd.patch
git-netdev-all.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
git-backlight-sony-fix.patch
git-sh.patch
git-scsi-misc.patch
git-scsi-misc-fixup.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
revert-x86_64-mm-msr-on-cpu.patch
x86_64-survive-having-no-irq-mapping-for-a-vector-fix.patch
mm-vm_insert_pfn-tidy.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
swiotlb-uninlinings.patch
kprobes-list-all-active-probes-in-the-system-tidy.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
knfsd-sunrpc-teach-svc_sendto-to-deal-with-ipv6-addresses-tidy.patch
knfsd-sunrpc-support-ipv6-addresses-in-rpc-servers-udp-receive-path-tidy.patch
revert-x86_64-mm-putreg-check.patch
fbdev-driver-for-s3-trio-virge-update-2-fix.patch
deprecate-sa_interrupt-and-friends.patch
git-gccbug-fixup.patch
