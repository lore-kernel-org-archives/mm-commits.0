From: akpm@linux-foundation.org
Subject: - docbook-fix-usb-content.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:46:08 -0700
Message-ID: <200710162046.l9GKk8Uo016336@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47516 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965685AbXJPU52 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 16:57:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, rob@landley.net, mm-commits@vger.kernel.org


The patch titled
     docbook: fix usb content
has been removed from the -mm tree.  Its filename was
     docbook-fix-usb-content.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: docbook: fix usb content
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix USB docbook warnings.

Warning(linux-2.6.23-git8//include/linux/usb/gadget.h:487): No description found for parameter 'g'
Warning(linux-2.6.23-git8//include/linux/usb/gadget.h:506): No description found for parameter 'g'

Warning(linux-2.6.23-git8//drivers/usb/core/hub.c:1416): No description found for parameter 'usb_dev'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Rob Landley <rob@landley.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/core/hub.c     |    6 +++++-
 include/linux/usb/gadget.h |    4 ++--
 2 files changed, 7 insertions(+), 3 deletions(-)

diff -puN drivers/usb/core/hub.c~docbook-fix-usb-content drivers/usb/core/hub.c
--- a/drivers/usb/core/hub.c~docbook-fix-usb-content
+++ a/drivers/usb/core/hub.c
@@ -1405,7 +1405,11 @@ fail:
 
 
 /**
- * Similar to usb_disconnect()
+ * usb_deauthorize_device - deauthorize a device (usbcore-internal)
+ * @usb_dev: USB device
+ *
+ * Move the USB device to a very basic state where interfaces are disabled
+ * and the device is in fact unconfigured and unusable.
  *
  * We share a lock (that we have) with device_del(), so we need to
  * defer its call.
diff -puN include/linux/usb/gadget.h~docbook-fix-usb-content include/linux/usb/gadget.h
--- a/include/linux/usb/gadget.h~docbook-fix-usb-content
+++ a/include/linux/usb/gadget.h
@@ -481,7 +481,7 @@ static inline void *get_gadget_data (str
 
 /**
  * gadget_is_dualspeed - return true iff the hardware handles high speed
- * @gadget: controller that might support both high and full speeds
+ * @g: controller that might support both high and full speeds
  */
 static inline int gadget_is_dualspeed(struct usb_gadget *g)
 {
@@ -497,7 +497,7 @@ static inline int gadget_is_dualspeed(st
 
 /**
  * gadget_is_otg - return true iff the hardware is OTG-ready
- * @gadget: controller that might have a Mini-AB connector
+ * @g: controller that might have a Mini-AB connector
  *
  * This is a runtime test, since kernels with a USB-OTG stack sometimes
  * run on boards which only have a Mini-B (or Mini-A) connector.
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-acpi.patch
git-alsa.patch
fix-auditscc-kernel-doc.patch
comment-typo-in-scripts-kconfig-makefile.patch
git-unionfs.patch
git-watchdog.patch
git-ipwireless_cs.patch
security-convert-lsm-into-a-static-interface-fix-2-fix.patch
docs-ramdisk-initrd-initramfs-corrections.patch
send-quota-messages-via-netlink-fix.patch
send-quota-messages-via-netlink-fix-fix.patch
maintainers-linux-omap-list-is-subscribers-only.patch
make-the-pr_-family-of-macros-in-kernelh-complete.patch
doc-about-email-clients-for-linux-patches.patch
change-inotifyfs-magic-as-the-same-magic-is-used-for-futexfs-v2.patch
dont-truncate-proc-pid-environ-at-4096-characters.patch
dontdiff-update-based-on-gitignore-updates.patch
kernel-doc-fix-doc-blocks-and-html.patch
express-relocatability-of-kernel-on-x86_64-in.patch
remap_file_pages-kernel-doc-corrections.patch
hook-up-group-scheduler-with-control-groups.patch
hook-up-group-scheduler-with-control-groups-fix.patch
combine-instrumentation-menus-in-kernel-kconfiginstrumentation.patch
add-samples-subdir.patch
profile-likely-unlikely-macros.patch
