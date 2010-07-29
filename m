From: akpm@linux-foundation.org
Subject: + acpi-ec_sys-be-more-cautious-about-ec-write-access.patch added to -mm tree
Date: Thu, 29 Jul 2010 13:12:48 -0700
Message-ID: <201007292012.o6TKCm0w031402@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55124 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752104Ab0G2UNb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Jul 2010 16:13:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: trenn@suse.de, mjg@redhat.com


The patch titled
     acpi ec_sys: be more cautious about ec write access
has been added to the -mm tree.  Its filename is
     acpi-ec_sys-be-more-cautious-about-ec-write-access.patch

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
Subject: acpi ec_sys: be more cautious about ec write access
From: Thomas Renninger <trenn@suse.de>

- Set Kconfig option default n
- Only allow root to read/write io file (sever bug!)
- Introduce write support module param -> default off
- Properly clean up if any debugfs files cannot be created

Signed-off-by: Thomas Renninger <trenn@suse.de>
Cc: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/Kconfig  |   11 ++++++++---
 drivers/acpi/ec_sys.c |   30 +++++++++++++++++++++++-------
 2 files changed, 31 insertions(+), 10 deletions(-)

diff -puN drivers/acpi/Kconfig~acpi-ec_sys-be-more-cautious-about-ec-write-access drivers/acpi/Kconfig
--- a/drivers/acpi/Kconfig~acpi-ec_sys-be-more-cautious-about-ec-write-access
+++ a/drivers/acpi/Kconfig
@@ -106,14 +106,19 @@ config ACPI_SYSFS_POWER
 
 config ACPI_EC_DEBUGFS
 	tristate "EC read/write access through /sys/kernel/debug/ec"
-	default y
+	default n
 	help
 	  Say N to disable Embedded Controller /sys/kernel/debug interface
 
+	  Be aware that using this interface can confuse your Embedded
+	  Controller in a way that a normal reboot is not enough. You then
+	  have to power of your system, and remove the laptop battery for
+	  some seconds.
 	  An Embedded Controller typically is available on laptops and reads
 	  sensor values like battery state and temperature.
-	  The kernel access the EC through ACPI parsed code provided by BIOS
-	  tables.
+	  The kernel accesses the EC through ACPI parsed code provided by BIOS
+	  tables. This option allows to access the EC directly without ACPI
+	  code being involved.
 	  Thus this option is a debug option that helps to write ACPI drivers
 	  and can be used to identify ACPI code or EC firmware bugs.
 
diff -puN drivers/acpi/ec_sys.c~acpi-ec_sys-be-more-cautious-about-ec-write-access drivers/acpi/ec_sys.c
--- a/drivers/acpi/ec_sys.c~acpi-ec_sys-be-more-cautious-about-ec-write-access
+++ a/drivers/acpi/ec_sys.c
@@ -17,6 +17,11 @@ MODULE_AUTHOR("Thomas Renninger <trenn@s
 MODULE_DESCRIPTION("ACPI EC sysfs access driver");
 MODULE_LICENSE("GPL");
 
+static bool write_support;
+module_param(write_support, bool, 0644);
+MODULE_PARM_DESC(write_support, "Dangerous, reboot and removal of battery may "
+		 "be needed.");
+
 #define EC_SPACE_SIZE 256
 
 struct sysdev_class acpi_ec_sysdev_class = {
@@ -102,6 +107,7 @@ int acpi_ec_add_debugfs(struct acpi_ec *
 {
 	struct dentry *dev_dir;
 	char name[64];
+
 	if (ec_device_count == 0) {
 		acpi_ec_debugfs_dir = debugfs_create_dir("ec", NULL);
 		if (!acpi_ec_debugfs_dir)
@@ -111,17 +117,27 @@ int acpi_ec_add_debugfs(struct acpi_ec *
 	sprintf(name, "ec%u", ec_device_count);
 	dev_dir = debugfs_create_dir(name, acpi_ec_debugfs_dir);
 	if (!dev_dir) {
-		if (ec_device_count == 0)
-			debugfs_remove_recursive(acpi_ec_debugfs_dir);
-		/* TBD: Proper cleanup for multiple ECs */
+		if (ec_device_count != 0)
+			goto error;
 		return -ENOMEM;
 	}
 
-	debugfs_create_x32("gpe", 0444, dev_dir, (u32 *)&first_ec->gpe);
-	debugfs_create_bool("use_global_lock", 0444, dev_dir,
-			    (u32 *)&first_ec->global_lock);
-	debugfs_create_file("io", 0666, dev_dir, ec, &acpi_ec_io_ops);
+	if (!debugfs_create_x32("gpe", 0444, dev_dir, (u32 *)&first_ec->gpe))
+		goto error;
+	if (!debugfs_create_bool("use_global_lock", 0444, dev_dir,
+				 (u32 *)&first_ec->global_lock))
+		goto error;
+
+	if (!write_support)
+		acpi_ec_io_ops.write = NULL;
+	if (!debugfs_create_file("io", 0600, dev_dir, ec, &acpi_ec_io_ops))
+		goto error;
+
 	return 0;
+
+error:
+	debugfs_remove_recursive(acpi_ec_debugfs_dir);
+	return -ENOMEM;
 }
 
 static int __init acpi_ec_sys_init(void)
_

Patches currently in -mm which might be from trenn@suse.de are

origin.patch
linux-next.patch
acpi-ec-fix-possible-double-io-port-registration.patch
acpi-ec_sys-be-more-cautious-about-ec-write-access.patch

