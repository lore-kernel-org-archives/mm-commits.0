From: akpm@linux-foundation.org
Subject: [merged] sata-piix-blacklist-system-that-spins-off-disks-during-acpi-power-off.patch removed from -mm tree
Date: Wed, 28 Jan 2009 15:28:58 -0800
Message-ID: <200901282328.n0SNSw53006896@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54976 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757125AbZA1X34 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Jan 2009 18:29:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, alan@lxorguk.ukuu.org.uk, elendil@planet.nl, fweisbec@gmail.com, jeff@garzik.org, maciej.rutecki@gmail.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     sata piix: Blacklist system that spins off disks during ACPI power off
has been removed from the -mm tree.  Its filename was
     sata-piix-blacklist-system-that-spins-off-disks-during-acpi-power-off.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sata piix: Blacklist system that spins off disks during ACPI power off
From: Rafael J. Wysocki <rjw@sisk.pl>

Some notebooks from HP have the problem that their BIOSes attempt to spin
down hard drives before entering ACPI system states S4 and S5.  This leads
to a yo-yo effect during system power-off shutdown and the last phase of
hibernation when the disk is first spun down by the kernel and then almost
immediately turned on and off by the BIOS.  This, in turn, may result in
shortening the disk's life times.

To prevent this from happening we can blacklist the affected systems using
DMI information.

Blacklist HP 2510p that uses the ata_piix driver.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Tested-by: Maciej Rutecki <maciej.rutecki@gmail.com>
Tested-by: Frans Pop <elendil@planet.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/ata_piix.c |   34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff -puN drivers/ata/ata_piix.c~sata-piix-blacklist-system-that-spins-off-disks-during-acpi-power-off drivers/ata/ata_piix.c
--- a/drivers/ata/ata_piix.c~sata-piix-blacklist-system-that-spins-off-disks-during-acpi-power-off
+++ a/drivers/ata/ata_piix.c
@@ -1387,6 +1387,32 @@ static void piix_iocfg_bit18_quirk(struc
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
+		return slot == PCI_SLOT(pdev->devfn);
+	}
+
+	return false;
+}
+
 /**
  *	piix_init_one - Register PIIX ATA PCI device with kernel services
  *	@pdev: PCI device to register
@@ -1422,6 +1448,14 @@ static int __devinit piix_init_one(struc
 	if (!in_module_init)
 		return -ENODEV;
 
+	if (piix_broken_system_poweroff(pdev)) {
+		piix_port_info[ent->driver_data].flags |=
+				ATA_FLAG_NO_POWEROFF_SPINDOWN |
+					ATA_FLAG_NO_HIBERNATE_SPINDOWN;
+		dev_info(&pdev->dev, "quirky BIOS, skipping spindown "
+				"on poweroff and hibernation\n");
+	}
+
 	port_info[0] = piix_port_info[ent->driver_data];
 	port_info[1] = piix_port_info[ent->driver_data];
 
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
linux-next.patch
drivers-consolidate-driver_probe_done-loops-into-one-place.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-fix.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-checkpatch-fixes.patch
resume-wait-for-device-probing-to-finish.patch
misc-dell-laptop-should-depend-on-power_supply.patch
fbmem-copy_from-to_user-with-mutex-held-v3.patch
sata-ahci-blacklist-system-that-spins-off-disks-during-acpi-power-off.patch
shrink_slab-handle-bad-shrinkers.patch

