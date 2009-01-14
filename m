From: akpm@linux-foundation.org
Subject: + drivers-consolidate-driver_probe_done-loops-into-one-place.patch added to -mm tree
Date: Wed, 14 Jan 2009 15:48:33 -0800
Message-ID: <200901142348.n0ENmXIj007531@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59406 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757091AbZANXtR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Jan 2009 18:49:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arjan@linux.intel.com, greg@kroah.com, kay.sievers@vrfy.org, lenb@kernel.org, pavel@ucw.cz, rjw@sisk.pl


The patch titled
     drivers: consolidate driver_probe_done() loops into one place
has been added to the -mm tree.  Its filename is
     drivers-consolidate-driver_probe_done-loops-into-one-place.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers: consolidate driver_probe_done() loops into one place
From: Arjan van de Ven <arjan@linux.intel.com>

There are a few places that currently loop over driver_probe_done(), and
I'm about to add another one.  This patch abstracts it into a helper to
reduce duplication.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>
Cc: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/dd.c      |   16 ++++++++++++++++
 include/linux/device.h |    2 ++
 init/do_mounts.c       |   13 +++++++++----
 init/do_mounts_md.c    |    5 +++--
 4 files changed, 30 insertions(+), 6 deletions(-)

diff -puN drivers/base/dd.c~drivers-consolidate-driver_probe_done-loops-into-one-place drivers/base/dd.c
--- a/drivers/base/dd.c~drivers-consolidate-driver_probe_done-loops-into-one-place
+++ a/drivers/base/dd.c
@@ -21,6 +21,7 @@
 #include <linux/module.h>
 #include <linux/kthread.h>
 #include <linux/wait.h>
+#include <linux/async.h>
 
 #include "base.h"
 #include "power/power.h"
@@ -168,6 +169,21 @@ int driver_probe_done(void)
 }
 
 /**
+ * wait_for_device_probe
+ * Wait for device probing to be completed.
+ *
+ * Note: this function polls at 100 msec intervals.
+ */
+int wait_for_device_probe(void)
+{
+	/* wait for the known devices to complete their probing */
+	while (driver_probe_done() != 0)
+		msleep(100);
+	async_synchronize_full();
+	return 0;
+}
+
+/**
  * driver_probe_device - attempt to bind device & driver together
  * @drv: driver to bind a device to
  * @dev: device to try to bind to the driver
diff -puN include/linux/device.h~drivers-consolidate-driver_probe_done-loops-into-one-place include/linux/device.h
--- a/include/linux/device.h~drivers-consolidate-driver_probe_done-loops-into-one-place
+++ a/include/linux/device.h
@@ -147,6 +147,8 @@ extern void put_driver(struct device_dri
 extern struct device_driver *driver_find(const char *name,
 					 struct bus_type *bus);
 extern int driver_probe_done(void);
+extern int wait_for_device_probe(void);
+
 
 /* sysfs interface for exporting driver attributes */
 
diff -puN init/do_mounts.c~drivers-consolidate-driver_probe_done-loops-into-one-place init/do_mounts.c
--- a/init/do_mounts.c~drivers-consolidate-driver_probe_done-loops-into-one-place
+++ a/init/do_mounts.c
@@ -370,10 +370,14 @@ void __init prepare_namespace(void)
 		ssleep(root_delay);
 	}
 
-	/* wait for the known devices to complete their probing */
-	while (driver_probe_done() != 0)
-		msleep(100);
-	async_synchronize_full();
+	/* 
+	 * wait for the known devices to complete their probing 
+	 *
+	 * Note: this is a potential source of long boot delays.
+	 * For example, it is not atypical to wait 5 seconds here
+	 * for the touchpad of a laptop to initialize.
+	 */
+	wait_for_device_probe();
 
 	md_run_setup();
 
@@ -399,6 +403,7 @@ void __init prepare_namespace(void)
 		while (driver_probe_done() != 0 ||
 			(ROOT_DEV = name_to_dev_t(saved_root_name)) == 0)
 			msleep(100);
+		async_synchronize_full();
 	}
 
 	is_floppy = MAJOR(ROOT_DEV) == FLOPPY_MAJOR;
diff -puN init/do_mounts_md.c~drivers-consolidate-driver_probe_done-loops-into-one-place init/do_mounts_md.c
--- a/init/do_mounts_md.c~drivers-consolidate-driver_probe_done-loops-into-one-place
+++ a/init/do_mounts_md.c
@@ -281,8 +281,9 @@ static void __init autodetect_raid(void)
 	 */
 	printk(KERN_INFO "md: Waiting for all devices to be available before autodetect\n");
 	printk(KERN_INFO "md: If you don't use raid, use raid=noautodetect\n");
-	while (driver_probe_done() < 0)
-		msleep(100);
+
+	wait_for_device_probe();
+
 	fd = sys_open("/dev/md0", 0, 0);
 	if (fd >= 0) {
 		sys_ioctl(fd, RAID_AUTORUN, raid_autopart);
_

Patches currently in -mm which might be from arjan@linux.intel.com are

origin.patch
linux-next.patch
drivers-consolidate-driver_probe_done-loops-into-one-place.patch
scripts-add-x86-register-parser-to-markup_oopspl.patch
scripts-add-x86-64-bit-support-to-the-markup_oopspl-script.patch
pci-use-pci_ioremap_bar-in-drivers-serial.patch

