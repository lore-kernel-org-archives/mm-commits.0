From: akpm@linux-foundation.org
Subject: + acpi-make-proc-acpi-wakeup-interface-handle-pci-devices-again.patch added to -mm tree
Date: Fri, 03 Oct 2008 05:51:50 -0700
Message-ID: <200810031251.m93CpoZJ028248@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56547 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751914AbYJCMwb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Oct 2008 08:52:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, lenb@kernel.org


The patch titled
     ACPI: Make /proc/acpi/wakeup interface handle PCI devices (again)
has been added to the -mm tree.  Its filename is
     acpi-make-proc-acpi-wakeup-interface-handle-pci-devices-again.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ACPI: Make /proc/acpi/wakeup interface handle PCI devices (again)
From: Rafael J. Wysocki <rjw@sisk.pl>

Make the ACPI /proc/acpi/wakeup interface set the appropriate wake-up bits
of physical devices corresponding to the ACPI devices and make those bits
be set initially for devices that are enabled to wake up by default.  This
is needed to restore the previous behavior for the PCI devices that were
previously handled correctly with the help of the /proc/acpi/wakeup
interface.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/glue.c       |    5 ++++-
 drivers/acpi/sleep/proc.c |   10 ++++++++++
 2 files changed, 14 insertions(+), 1 deletion(-)

diff -puN drivers/acpi/glue.c~acpi-make-proc-acpi-wakeup-interface-handle-pci-devices-again drivers/acpi/glue.c
--- a/drivers/acpi/glue.c~acpi-make-proc-acpi-wakeup-interface-handle-pci-devices-again
+++ a/drivers/acpi/glue.c
@@ -207,8 +207,11 @@ static int acpi_bind_one(struct device *
 				"firmware_node");
 		ret = sysfs_create_link(&acpi_dev->dev.kobj, &dev->kobj,
 				"physical_node");
-		if (acpi_dev->wakeup.flags.valid)
+		if (acpi_dev->wakeup.flags.valid) {
 			device_set_wakeup_capable(dev, true);
+			device_set_wakeup_enable(dev,
+						acpi_dev->wakeup.state.enabled);
+		}
 	}
 
 	return 0;
diff -puN drivers/acpi/sleep/proc.c~acpi-make-proc-acpi-wakeup-interface-handle-pci-devices-again drivers/acpi/sleep/proc.c
--- a/drivers/acpi/sleep/proc.c~acpi-make-proc-acpi-wakeup-interface-handle-pci-devices-again
+++ a/drivers/acpi/sleep/proc.c
@@ -377,6 +377,14 @@ acpi_system_wakeup_device_seq_show(struc
 	return 0;
 }
 
+static void physical_device_enable_wakeup(struct acpi_device *adev)
+{
+	struct device *dev = acpi_get_physical_device(adev->handle);
+
+	if (dev && device_can_wakeup(dev))
+		device_set_wakeup_enable(dev, adev->wakeup.state.enabled);
+}
+
 static ssize_t
 acpi_system_write_wakeup_device(struct file *file,
 				const char __user * buffer,
@@ -411,6 +419,7 @@ acpi_system_write_wakeup_device(struct f
 		}
 	}
 	if (found_dev) {
+		physical_device_enable_wakeup(found_dev);
 		list_for_each_safe(node, next, &acpi_wakeup_device_list) {
 			struct acpi_device *dev = container_of(node,
 							       struct
@@ -428,6 +437,7 @@ acpi_system_write_wakeup_device(struct f
 				       dev->pnp.bus_id, found_dev->pnp.bus_id);
 				dev->wakeup.state.enabled =
 				    found_dev->wakeup.state.enabled;
+				physical_device_enable_wakeup(dev);
 			}
 		}
 	}
_

Patches currently in -mm which might be from rjw@sisk.pl are

acpi-make-proc-acpi-wakeup-interface-handle-pci-devices-again.patch
git-ftrace.patch
git-pci.patch
skge-adapt-skge-to-use-reworked-pci-pm.patch
skty2-adapt-to-the-reworked-pci-pm.patch
e100-adapt-to-the-reworked-pci-pm.patch
pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation.patch
pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation-cleanup.patch
container-freezer-add-tif_freeze-flag-to-all-architectures.patch
container-freezer-add-tif_freeze-flag-to-all-architectures-fix.patch
container-freezer-make-refrigerator-always-available.patch
container-freezer-implement-freezer-cgroup-subsystem-fix-freezer-kconfig.patch
container-freezer-implement-freezer-cgroup-subsystem-uninline-thaw_process.patch
container-freezer-implement-freezer-cgroup-subsystem-uninline-thaw_process-fix.patch
container-freezer-implement-freezer-cgroup-subsystem-cleanup-comment.patch
container-freezer-skip-frozen-cgroups-during-power-management-resume.patch
vsprintf-use-new-vsprintf-symbolic-function-pointer-format.patch
shrink_slab-handle-bad-shrinkers.patch

