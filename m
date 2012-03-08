From: akpm@linux-foundation.org
Subject: [merged] x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs.patch removed from -mm tree
Date: Thu, 08 Mar 2012 11:17:16 -0800
Message-ID: <20120308191717.13159A06CB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:60634 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238Ab2CHTRS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Mar 2012 14:17:18 -0500
Received: by yenq2 with SMTP id q2so103720yen.1
        for <mm-commits@vger.kernel.org>; Thu, 08 Mar 2012 11:17:17 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dsd@laptop.org, dilinger@queued.net, hpa@zytor.com, mingo@elte.hu, mjg@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: x86, olpc-xo15-sci: enable lid close wakeup control through sysfs
has been removed from the -mm tree.  Its filename was
     x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Daniel Drake <dsd@laptop.org>
Subject: x86, olpc-xo15-sci: enable lid close wakeup control through sysfs

Like most systems, OLPC's ACPI LID switch wakes up the system when the lid
is opened, but not when it is closed.

Under OLPC's opportunistic suspend model, the lid may be closed while the
system was oportunistically suspended with the screen running.  In this
event, we want to wake up to turn the screen off.

Enable control of normal ACPI wakeups through lid close events through a
new sysfs attribute "lid_wake_on_closed".  When set, and when LID wakeups
are enabled through ACPI, the system will wake up on both open and close
lid events.

Signed-off-by: Daniel Drake <dsd@laptop.org>
[akpm@linux-foundation.org: fix sscanf checking]
Cc: Andres Salomon <dilinger@queued.net>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/platform/olpc/olpc-xo15-sci.c |   67 +++++++++++++++++++++++
 1 file changed, 67 insertions(+)

diff -puN arch/x86/platform/olpc/olpc-xo15-sci.c~x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs arch/x86/platform/olpc/olpc-xo15-sci.c
--- a/arch/x86/platform/olpc/olpc-xo15-sci.c~x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs
+++ a/arch/x86/platform/olpc/olpc-xo15-sci.c
@@ -24,6 +24,62 @@
 #define XO15_SCI_DEVICE_NAME		"OLPC XO-1.5 SCI"
 
 static unsigned long xo15_sci_gpe;
+static bool lid_wake_on_close;
+
+/*
+ * The normal ACPI LID wakeup behavior is wake-on-open, but not
+ * wake-on-close. This is implemented as standard by the XO-1.5 DSDT.
+ *
+ * We provide here a sysfs attribute that will additionally enable
+ * wake-on-close behavior. This is useful (e.g.) when we oportunistically
+ * suspend with the display running; if the lid is then closed, we want to
+ * wake up to turn the display off.
+ *
+ * This is controlled through a custom method in the XO-1.5 DSDT.
+ */
+static int set_lid_wake_behavior(bool wake_on_close)
+{
+	struct acpi_object_list arg_list;
+	union acpi_object arg;
+	acpi_status status;
+
+	arg_list.count = 1;
+	arg_list.pointer = &arg;
+	arg.type = ACPI_TYPE_INTEGER;
+	arg.integer.value = wake_on_close;
+	status = acpi_evaluate_object(NULL, "\\_SB.PCI0.LID.LIDW", &arg_list,
+				      NULL);
+	if (ACPI_FAILURE(status)) {
+		pr_warning(PFX "failed to set lid behavior\n");
+		return 1;
+	}
+
+	lid_wake_on_close = wake_on_close;
+	return 0;
+}
+
+static ssize_t lid_wake_on_close_show(struct kobject *s,
+				      struct kobj_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%u\n", lid_wake_on_close);
+}
+
+static ssize_t lid_wake_on_close_store(struct kobject *s,
+				       struct kobj_attribute *attr,
+				       const char *buf, size_t n)
+{
+	unsigned int val;
+
+	if (sscanf(buf, "%u", &val) != 1)
+		return -EINVAL;
+
+	set_lid_wake_behavior(!!val);
+	return n;
+}
+
+static struct kobj_attribute lid_wake_on_close_attr =
+	__ATTR(lid_wake_on_close, 0644,
+	       lid_wake_on_close_show, lid_wake_on_close_store);
 
 static void battery_status_changed(void)
 {
@@ -91,6 +147,7 @@ static int xo15_sci_add(struct acpi_devi
 {
 	unsigned long long tmp;
 	acpi_status status;
+	int r;
 
 	if (!device)
 		return -EINVAL;
@@ -112,6 +169,10 @@ static int xo15_sci_add(struct acpi_devi
 
 	dev_info(&device->dev, "Initialized, GPE = 0x%lx\n", xo15_sci_gpe);
 
+	r = sysfs_create_file(&device->dev.kobj, &lid_wake_on_close_attr.attr);
+	if (r)
+		goto err_sysfs;
+
 	/* Flush queue, and enable all SCI events */
 	process_sci_queue();
 	olpc_ec_mask_write(EC_SCI_SRC_ALL);
@@ -123,6 +184,11 @@ static int xo15_sci_add(struct acpi_devi
 		device_init_wakeup(&device->dev, true);
 
 	return 0;
+
+err_sysfs:
+	acpi_remove_gpe_handler(NULL, xo15_sci_gpe, xo15_sci_gpe_handler);
+	cancel_work_sync(&sci_work);
+	return r;
 }
 
 static int xo15_sci_remove(struct acpi_device *device, int type)
@@ -130,6 +196,7 @@ static int xo15_sci_remove(struct acpi_d
 	acpi_disable_gpe(NULL, xo15_sci_gpe);
 	acpi_remove_gpe_handler(NULL, xo15_sci_gpe, xo15_sci_gpe_handler);
 	cancel_work_sync(&sci_work);
+	sysfs_remove_file(&device->dev.kobj, &lid_wake_on_close_attr.attr);
 	return 0;
 }
 
_

Patches currently in -mm which might be from dsd@laptop.org are

linux-next.patch
platform-drivers-x86-convert-drivers-platform-x86-to-use-module_platform_driver.patch
x86-olpc-add-debugfs-interface-for-ec-commands.patch

