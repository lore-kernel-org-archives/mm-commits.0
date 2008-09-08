From: akpm@linux-foundation.org
Subject: + sata-blacklist-systems-that-spin-off-disks-during-acpi-power-off.patch added to -mm tree
Date: Mon, 08 Sep 2008 15:44:48 -0700
Message-ID: <200809082244.m88Minr7014168@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34236 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752005AbYIHWq6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Sep 2008 18:46:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, htejun@gmail.com, jeff@garzik.org


The patch titled
     sata: blacklist systems that spin off disks during ACPI power off
has been added to the -mm tree.  Its filename is
     sata-blacklist-systems-that-spin-off-disks-during-acpi-power-off.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sata: blacklist systems that spin off disks during ACPI power off
From: Rafael J. Wysocki <rjw@sisk.pl>

Some notebooks from HP have the problem that their BIOSes attempt to spin
down hard drives before entering ACPI system states S4 and S5.  This leads
to a yo-yo effect during system power-off shutdown and the last phase of
hibernation when the disk is first spun down by the kernel and then almost
immediately turned on and off by the BIOS.  This, in turn, may result in
shortening the disk's life times.

To prevent this from happening we can blacklist the affected systems using
DMI information.  However, only the on-board controlles should be
blacklisted and their PCI slot numbers can be used for this purpose. 
Unfortunately the existing interface for checking DMI information of the
system is not very convenient for this purpose, because to use it, we
would have to define special callback functions or create a separate
struct dmi_system_id table for each blacklisted system.

To overcome this difficulty introduce a new function dmi_first_match()
returning a pointer to the first entry in an array of struct dmi_system_id
elements that matches the system DMI information.  Then, we can use this
pointer to access the entry's .driver_data field containing the additional
information, such as the PCI slot number, allowing us to do the desired
blacklisting.

Introduce a new libata flag ATA_FLAG_NO_POWEROFF_SPINDOWN that, if set,
will prevent disks from being spun off during system power off and
hibernation (to handle the hibernation case we need a new system state
SYSTEM_HIBERNATE_ENTER that can be checked against by libata, in analogy
with SYSTEM_POWER_OFF).  Use dmi_first_match() to set this flag for some
systems affected by the problem described above (HP nx6325, HP nx6310, HP
2510p).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/ahci.c          |   32 +++++++++++++++
 drivers/ata/ata_piix.c      |   33 ++++++++++++++++
 drivers/ata/libata-scsi.c   |   16 ++++++-
 drivers/ata/sata_sil.c      |   35 ++++++++++++++++-
 drivers/firmware/dmi_scan.c |   69 ++++++++++++++++++++++++++--------
 include/linux/dmi.h         |    1 
 include/linux/kernel.h      |    2 
 include/linux/libata.h      |    1 
 kernel/power/disk.c         |    2 
 9 files changed, 170 insertions(+), 21 deletions(-)

diff -puN drivers/ata/ahci.c~sata-blacklist-systems-that-spin-off-disks-during-acpi-power-off drivers/ata/ahci.c
--- a/drivers/ata/ahci.c~sata-blacklist-systems-that-spin-off-disks-during-acpi-power-off
+++ a/drivers/ata/ahci.c
@@ -2515,6 +2515,32 @@ static void ahci_p5wdh_workaround(struct
 	}
 }
 
+static bool ahci_broken_system_poweroff(struct pci_dev *pdev)
+{
+	static const struct dmi_system_id broken_systems[] = {
+		{
+			.ident = "HP Compaq nx6310",
+			.matches = {
+				DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+				DMI_MATCH(DMI_PRODUCT_NAME, "HP Compaq nx6310"),
+			},
+			/* PCI slot number of the controller */
+			.driver_data = (void *)0x1FUL,
+		},
+
+		{ }	/* terminate list */
+	};
+	const struct dmi_system_id *dmi = dmi_first_match(broken_systems);
+
+	if (dmi) {
+		unsigned long slot = (unsigned long)dmi->driver_data;
+		/* apply the quirk only to on-board controllers */
+		return (slot == PCI_SLOT(pdev->devfn));
+	}
+
+	return false;
+}
+
 static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	static int printed_version;
@@ -2604,6 +2630,12 @@ static int ahci_init_one(struct pci_dev 
 		}
 	}
 
+	if (ahci_broken_system_poweroff(pdev)) {
+		pi.flags |= ATA_FLAG_NO_POWEROFF_SPINDOWN;
+		dev_info(&pdev->dev,
+			"quirky BIOS, skipping spindown on poweroff\n");
+	}
+
 	/* CAP.NP sometimes indicate the index of the last enabled
 	 * port, at other times, that of the last possible port, so
 	 * determining the maximum port number requires looking at
diff -puN drivers/ata/ata_piix.c~sata-blacklist-systems-that-spin-off-disks-during-acpi-power-off drivers/ata/ata_piix.c
--- a/drivers/ata/ata_piix.c~sata-blacklist-systems-that-spin-off-disks-during-acpi-power-off
+++ a/drivers/ata/ata_piix.c
@@ -1449,6 +1449,32 @@ static void piix_iocfg_bit18_quirk(struc
 	}
 }
 
+static bool piix_broken_system_poweroff(struct pci_dev *pdev)
+{
+	static const struct dmi_system_id broken_systems[] = {
+		{
+			.ident = "HP Compaq 2510p",
+			.matches = {
+				DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+				DMI_MATCH(DMI_PRODUCT_NAME, "HP Compaq 2510p"),
+			},
+			/* PCI slot number of the controller */
+			.driver_data = (void *)0x1FUL,
+		},
+
+		{ }	/* terminate list */
+	};
+	const struct dmi_system_id *dmi = dmi_first_match(broken_systems);
+
+	if (dmi) {
+		unsigned long slot = (unsigned long)dmi->driver_data;
+		/* apply the quirk only to on-board controllers */
+		return (slot == PCI_SLOT(pdev->devfn));
+	}
+
+	return false;
+}
+
 /**
  *	piix_init_one - Register PIIX ATA PCI device with kernel services
  *	@pdev: PCI device to register
@@ -1484,6 +1510,13 @@ static int __devinit piix_init_one(struc
 	if (!in_module_init)
 		return -ENODEV;
 
+	if (piix_broken_system_poweroff(pdev)) {
+		piix_port_info[ent->driver_data].flags |=
+						ATA_FLAG_NO_POWEROFF_SPINDOWN;
+		dev_info(&pdev->dev,
+			   "quirky BIOS, skipping spindown on poweroff\n");
+	}
+
 	port_info[0] = piix_port_info[ent->driver_data];
 	port_info[1] = piix_port_info[ent->driver_data];
 
diff -puN drivers/ata/libata-scsi.c~sata-blacklist-systems-that-spin-off-disks-during-acpi-power-off drivers/ata/libata-scsi.c
--- a/drivers/ata/libata-scsi.c~sata-blacklist-systems-that-spin-off-disks-during-acpi-power-off
+++ a/drivers/ata/libata-scsi.c
@@ -1181,6 +1181,14 @@ static unsigned int ata_scsi_start_stop_
 
 		tf->command = ATA_CMD_VERIFY;	/* READ VERIFY */
 	} else {
+		/* Some odd clown BIOSen issue spindown on power off (ACPI S4
+		 * or S5) causing some drives to spin up and down again.
+		 */
+		if ((qc->ap->flags & ATA_FLAG_NO_POWEROFF_SPINDOWN) &&
+		    (system_state == SYSTEM_POWER_OFF ||
+		     system_state == SYSTEM_HIBERNATE_ENTER))
+			goto skip;
+
 		/* XXX: This is for backward compatibility, will be
 		 * removed.  Read Documentation/feature-removal-schedule.txt
 		 * for more info.
@@ -1204,8 +1212,7 @@ static unsigned int ata_scsi_start_stop_
 				scmd->scsi_done = qc->scsidone;
 				qc->scsidone = ata_delayed_done;
 			}
-			scmd->result = SAM_STAT_GOOD;
-			return 1;
+			goto skip;
 		}
 
 		/* Issue ATA STANDBY IMMEDIATE command */
@@ -1221,10 +1228,13 @@ static unsigned int ata_scsi_start_stop_
 
 	return 0;
 
-invalid_fld:
+ invalid_fld:
 	ata_scsi_set_sense(scmd, ILLEGAL_REQUEST, 0x24, 0x0);
 	/* "Invalid field in cbd" */
 	return 1;
+ skip:
+	scmd->result = SAM_STAT_GOOD;
+	return 1;
 }
 
 
diff -puN drivers/ata/sata_sil.c~sata-blacklist-systems-that-spin-off-disks-during-acpi-power-off drivers/ata/sata_sil.c
--- a/drivers/ata/sata_sil.c~sata-blacklist-systems-that-spin-off-disks-during-acpi-power-off
+++ a/drivers/ata/sata_sil.c
@@ -603,11 +603,38 @@ static void sil_init_controller(struct a
 	}
 }
 
+static bool sil_broken_system_poweroff(struct pci_dev *pdev)
+{
+	static const struct dmi_system_id broken_systems[] = {
+		{
+			.ident = "HP Compaq nx6325",
+			.matches = {
+				DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+				DMI_MATCH(DMI_PRODUCT_NAME, "HP Compaq nx6325"),
+			},
+			/* PCI slot number of the controller */
+			.driver_data = (void *)0x12UL,
+		},
+
+		{ }	/* terminate list */
+	};
+	const struct dmi_system_id *dmi = dmi_first_match(broken_systems);
+
+	if (dmi) {
+		unsigned long slot = (unsigned long)dmi->driver_data;
+		/* apply the quirk only to on-board controllers */
+		return (slot == PCI_SLOT(pdev->devfn));
+	}
+
+	return false;
+}
+
 static int sil_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	static int printed_version;
 	int board_id = ent->driver_data;
-	const struct ata_port_info *ppi[] = { &sil_port_info[board_id], NULL };
+	struct ata_port_info pi = sil_port_info[board_id];
+	const struct ata_port_info *ppi[] = { &pi, NULL };
 	struct ata_host *host;
 	void __iomem *mmio_base;
 	int n_ports, rc;
@@ -621,6 +648,12 @@ static int sil_init_one(struct pci_dev *
 	if (board_id == sil_3114)
 		n_ports = 4;
 
+	if (sil_broken_system_poweroff(pdev)) {
+		pi.flags |= ATA_FLAG_NO_POWEROFF_SPINDOWN;
+		dev_info(&pdev->dev,
+			   "quirky BIOS, skipping spindown on poweroff\n");
+	}
+
 	host = ata_host_alloc_pinfo(&pdev->dev, ppi, n_ports);
 	if (!host)
 		return -ENOMEM;
diff -puN drivers/firmware/dmi_scan.c~sata-blacklist-systems-that-spin-off-disks-during-acpi-power-off drivers/firmware/dmi_scan.c
--- a/drivers/firmware/dmi_scan.c~sata-blacklist-systems-that-spin-off-disks-during-acpi-power-off
+++ a/drivers/firmware/dmi_scan.c
@@ -407,6 +407,27 @@ void __init dmi_scan_machine(void)
 }
 
 /**
+ *	dmi_match - check if dmi_system_id structure matches system DMI data
+ *	@dmi: pointer to the dmi_system_id structure to check
+ */
+static bool dmi_match(const struct dmi_system_id *dmi)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(dmi->matches); i++) {
+		int s = dmi->matches[i].slot;
+		if (s == DMI_NONE)
+			continue;
+		if (dmi_ident[s]
+		    && strstr(dmi_ident[s], dmi->matches[i].substr))
+			continue;
+		/* No match */
+		return false;
+	}
+	return true;
+}
+
+/**
  *	dmi_check_system - check system DMI data
  *	@list: array of dmi_system_id structures to match against
  *		All non-null elements of the list must match
@@ -421,30 +442,46 @@ void __init dmi_scan_machine(void)
  */
 int dmi_check_system(const struct dmi_system_id *list)
 {
-	int i, count = 0;
-	const struct dmi_system_id *d = list;
+	int count = 0;
+	const struct dmi_system_id *d;
 
-	while (d->ident) {
-		for (i = 0; i < ARRAY_SIZE(d->matches); i++) {
-			int s = d->matches[i].slot;
-			if (s == DMI_NONE)
-				continue;
-			if (dmi_ident[s] && strstr(dmi_ident[s], d->matches[i].substr))
-				continue;
-			/* No match */
-			goto fail;
+	for (d = list; d->ident; d++)
+		if (dmi_match(d)) {
+			count++;
+			if (d->callback && d->callback(d))
+				break;
 		}
-		count++;
-		if (d->callback && d->callback(d))
-			break;
-fail:		d++;
-	}
 
 	return count;
 }
 EXPORT_SYMBOL(dmi_check_system);
 
 /**
+ *	dmi_first_match - find dmi_system_id structure matching system DMI data
+ *	@list: array of dmi_system_id structures to match against
+ *		All non-null elements of the list must match
+ *		their slot's (field index's) data (i.e., each
+ *		list string must be a substring of the specified
+ *		DMI slot's string data) to be considered a
+ *		successful match.
+ *
+ *	Walk the blacklist table until the first match is found.  Return the
+ *	pointer to the matching entry or NULL if there's no match.
+ */
+struct dmi_system_id *dmi_first_match(const struct dmi_system_id *list)
+{
+	int i;
+	const struct dmi_system_id *d;
+
+	for (d = list; d->ident; d++)
+		if (dmi_match(d))
+			return d;
+
+	return NULL;
+}
+EXPORT_SYMBOL(dmi_first_match);
+
+/**
  *	dmi_get_system_info - return DMI data value
  *	@field: data index (see enum dmi_field)
  *
diff -puN include/linux/dmi.h~sata-blacklist-systems-that-spin-off-disks-during-acpi-power-off include/linux/dmi.h
--- a/include/linux/dmi.h~sata-blacklist-systems-that-spin-off-disks-during-acpi-power-off
+++ a/include/linux/dmi.h
@@ -75,6 +75,7 @@ struct dmi_device {
 #ifdef CONFIG_DMI
 
 extern int dmi_check_system(const struct dmi_system_id *list);
+struct dmi_system_id *dmi_first_match(const struct dmi_system_id *list);
 extern const char * dmi_get_system_info(int field);
 extern const struct dmi_device * dmi_find_device(int type, const char *name,
 	const struct dmi_device *from);
diff -puN include/linux/kernel.h~sata-blacklist-systems-that-spin-off-disks-during-acpi-power-off include/linux/kernel.h
--- a/include/linux/kernel.h~sata-blacklist-systems-that-spin-off-disks-during-acpi-power-off
+++ a/include/linux/kernel.h
@@ -278,7 +278,7 @@ extern enum system_states {
 	SYSTEM_HALT,
 	SYSTEM_POWER_OFF,
 	SYSTEM_RESTART,
-	SYSTEM_SUSPEND_DISK,
+	SYSTEM_HIBERNATE_ENTER,
 } system_state;
 
 #define TAINT_PROPRIETARY_MODULE	(1<<0)
diff -puN include/linux/libata.h~sata-blacklist-systems-that-spin-off-disks-during-acpi-power-off include/linux/libata.h
--- a/include/linux/libata.h~sata-blacklist-systems-that-spin-off-disks-during-acpi-power-off
+++ a/include/linux/libata.h
@@ -187,6 +187,7 @@ enum {
 					     * doesn't handle PIO interrupts */
 	ATA_FLAG_NCQ		= (1 << 10), /* host supports NCQ */
 	ATA_FLAG_DEBUGMSG	= (1 << 13),
+	ATA_FLAG_NO_POWEROFF_SPINDOWN = (1 << 14), /* don't spindown before poweroff */
 	ATA_FLAG_IGN_SIMPLEX	= (1 << 15), /* ignore SIMPLEX */
 	ATA_FLAG_NO_IORDY	= (1 << 16), /* controller lacks iordy */
 	ATA_FLAG_ACPI_SATA	= (1 << 17), /* need native SATA ACPI layout */
diff -puN kernel/power/disk.c~sata-blacklist-systems-that-spin-off-disks-during-acpi-power-off kernel/power/disk.c
--- a/kernel/power/disk.c~sata-blacklist-systems-that-spin-off-disks-during-acpi-power-off
+++ a/kernel/power/disk.c
@@ -415,6 +415,7 @@ int hibernation_platform_enter(void)
 	if (error)
 		goto Close;
 
+	system_state = SYSTEM_HIBERNATE_ENTER;
 	suspend_console();
 	ftrace_save = __ftrace_enabled_save();
 	error = device_suspend(PMSG_HIBERNATE);
@@ -450,6 +451,7 @@ int hibernation_platform_enter(void)
  Finish:
 	hibernation_ops->finish();
  Resume_devices:
+	system_state = SYSTEM_RUNNING;
 	device_resume(PMSG_RESTORE);
 	__ftrace_enabled_restore(ftrace_save);
 	resume_console();
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
linux-next.patch
sata-blacklist-systems-that-spin-off-disks-during-acpi-power-off.patch
skge-adapt-skge-to-use-reworked-pci-pm.patch
skty2-adapt-to-the-reworked-pci-pm.patch
e100-adapt-to-the-reworked-pci-pm.patch
ide-hpt3xx-fix-pointer-arithmetic.patch
net-forcedeth-call-restore-mac-addr-in-nv_shutdown-path-v2.patch
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
vsprintf-use-new-vsprintf-symbolic-function-pointer-format-cleanup.patch
shrink_slab-handle-bad-shrinkers.patch

