From: akpm@linux-foundation.org
Subject: + acpi-bay-driver-warning-fix.patch added to -mm tree
Date: Wed, 07 Feb 2007 16:51:46 -0800
Message-ID: <200702080052.l180qpZD000972@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48547 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161507AbXBHAyH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Feb 2007 19:54:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, kristen.c.accardi@intel.com, lenb@kernel.org


The patch titled
     acpi: bay driver warning fix
has been added to the -mm tree.  Its filename is
     acpi-bay-driver-warning-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
fix-warning-in-device_add_attrs.patch
git-dvb.patch
kthread-api-conversion-for-dvb_frontend-and-av7110-fix.patch
git-libata-all.patch
sis-warning-fixes.patch
git-md-accel-fixes.patch
git-md-accel-warning-fixes.patch
git-netdev-all.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
git-sh.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-block.patch
git-cryptodev-fixup.patch
mm-vm_insert_pfn-tidy.patch
swiotlb-uninlinings.patch
spi-filesystem-api-tweaks.patch
knfsd-sunrpc-teach-svc_sendto-to-deal-with-ipv6-addresses-tidy.patch
knfsd-sunrpc-support-ipv6-addresses-in-rpc-servers-udp-receive-path-tidy.patch
fix-utrace-utrace-ptrace-compat.patch
sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables-fix-3-fix.patch
acpi-bay-driver-warning-fix.patch
