From: akpm@linux-foundation.org
Subject: + x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs.patch added to -mm tree
Date: Wed, 30 Nov 2011 15:30:20 -0800
Message-ID: <201111302330.pAUNULsE026876@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:47608 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168Ab1K3Xa1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2011 18:30:27 -0500
Received: by eeuu44 with SMTP id u44so20016eeu.1
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2011 15:30:26 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dsd@laptop.org, dilinger@queued.net, hpa@zytor.com, mingo@elte.hu, mjg@redhat.com, tglx@linutronix.de


The patch titled
     Subject: x86, olpc-xo15-sci: enable lid close wakeup control through sysfs
has been added to the -mm tree.  Its filename is
     x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs.patch

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
Cc: Andres Salomon <dilinger@queued.net>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/platform/olpc/olpc-xo15-sci.c |   55 +++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff -puN arch/x86/platform/olpc/olpc-xo15-sci.c~x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs arch/x86/platform/olpc/olpc-xo15-sci.c
--- a/arch/x86/platform/olpc/olpc-xo15-sci.c~x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs
+++ a/arch/x86/platform/olpc/olpc-xo15-sci.c
@@ -24,6 +24,50 @@
 #define XO15_SCI_DEVICE_NAME		"OLPC XO-1.5 SCI"
 
 static unsigned long xo15_sci_gpe;
+static bool lid_wake_on_close;
+
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
+		pr_warning(PFX "failed to set lid behaviour\n");
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
+	if (!sscanf(buf, "%u", &val) == 1)
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
@@ -91,6 +135,7 @@ static int xo15_sci_add(struct acpi_devi
 {
 	unsigned long long tmp;
 	acpi_status status;
+	int r;
 
 	if (!device)
 		return -EINVAL;
@@ -112,6 +157,10 @@ static int xo15_sci_add(struct acpi_devi
 
 	dev_info(&device->dev, "Initialized, GPE = 0x%lx\n", xo15_sci_gpe);
 
+	r = sysfs_create_file(&device->dev.kobj, &lid_wake_on_close_attr.attr);
+	if (r)
+		goto err_sysfs;
+
 	/* Flush queue, and enable all SCI events */
 	process_sci_queue();
 	olpc_ec_mask_write(EC_SCI_SRC_ALL);
@@ -123,6 +172,11 @@ static int xo15_sci_add(struct acpi_devi
 		device_init_wakeup(&device->dev, true);
 
 	return 0;
+
+err_sysfs:
+	acpi_remove_gpe_handler(NULL, xo15_sci_gpe, xo15_sci_gpe_handler);
+	cancel_work_sync(&sci_work);
+	return r;
 }
 
 static int xo15_sci_remove(struct acpi_device *device, int type)
@@ -130,6 +184,7 @@ static int xo15_sci_remove(struct acpi_d
 	acpi_disable_gpe(NULL, xo15_sci_gpe);
 	acpi_remove_gpe_handler(NULL, xo15_sci_gpe, xo15_sci_gpe_handler);
 	cancel_work_sync(&sci_work);
+	sysfs_remove_file(&device->dev.kobj, &lid_wake_on_close_attr.attr);
 	return 0;
 }
 
_
Subject: Subject: x86, olpc-xo15-sci: enable lid close wakeup control through sysfs

Patches currently in -mm which might be from dsd@laptop.org are

origin.patch
linux-next.patch
x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs.patch
x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs-fix.patch

