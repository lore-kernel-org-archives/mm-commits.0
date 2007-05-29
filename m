From: akpm@linux-foundation.org
Subject: - libata-acpi-add-infrastructure-for-drivers-to-use.patch removed from -mm tree
Date: Tue, 29 May 2007 11:33:39 -0700
Message-ID: <200705291833.l4TIXeAV007904@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:55309 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750744AbXE2Sdz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 14:33:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     libata-acpi: add infrastructure for drivers to use _GTM/_STM methods
has been removed from the -mm tree.  Its filename was
     libata-acpi-add-infrastructure-for-drivers-to-use.patch

This patch was dropped because Tejun's stuff got merged

------------------------------------------------------
Subject: libata-acpi: add infrastructure for drivers to use _GTM/_STM methods
From: Alan Cox <alan@redhat.com>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-acpi.c |   87 +++++++++++++++++++++++++++++++++++-
 drivers/ata/libata-acpi.h |   47 +++++++++++++++++++
 2 files changed, 133 insertions(+), 1 deletion(-)

diff -puN drivers/ata/libata-acpi.c~libata-acpi-add-infrastructure-for-drivers-to-use drivers/ata/libata-acpi.c
--- a/drivers/ata/libata-acpi.c~libata-acpi-add-infrastructure-for-drivers-to-use
+++ a/drivers/ata/libata-acpi.c
@@ -15,7 +15,7 @@
 #include <linux/libata.h>
 #include <linux/pci.h>
 #include "libata.h"
-
+#include "libata-acpi.h"
 #include <acpi/acpi_bus.h>
 #include <acpi/acnames.h>
 #include <acpi/acnamesp.h>
@@ -704,3 +704,88 @@ out:
 }
 
 
+int ata_acpi_gtm(const struct ata_port *ap, void *handle, struct acpi_gtm *gtm)
+{
+	acpi_status status;
+	struct acpi_buffer output;
+
+	output.length = ACPI_ALLOCATE_BUFFER;
+	output.pointer = NULL;
+
+	status = acpi_evaluate_object(handle, "_GTM", NULL, &output);
+
+	if (ACPI_FAILURE(status)) {
+		ata_port_printk(ap, KERN_ERR, "ACPI get timing mode failed.\n");
+		return -EINVAL;
+	}
+	if (output.length < sizeof(struct acpi_gtm) || output.pointer == NULL) {
+		ata_port_printk(ap, KERN_ERR, "ACPI get timing provided invalid data.\n");
+		return -EINVAL;
+	}
+	memcpy(gtm, output.pointer, sizeof(struct acpi_gtm));
+	kfree(output.pointer);
+	return 0;
+}
+
+int ata_acpi_stm(const struct ata_port *ap, void *handle, struct acpi_gtm *stm)
+{
+	acpi_status status;
+	struct acpi_object_list         input;
+	union acpi_object               in_params[3];
+
+	in_params[0].type = ACPI_TYPE_BUFFER;
+	in_params[0].buffer.length = sizeof(struct acpi_gtm);
+	in_params[0].buffer.pointer = (u8 *)stm;
+	/* Buffers for id may need byteswapping ? */
+	in_params[1].type = ACPI_TYPE_BUFFER;
+	in_params[1].buffer.length = 512;
+	in_params[1].buffer.pointer = (u8 *)ap->device[0].id;
+	in_params[2].type = ACPI_TYPE_BUFFER;
+	in_params[2].buffer.length = 512;
+	in_params[2].buffer.pointer = (u8 *)ap->device[1].id;
+
+	input.count = 3;
+	input.pointer = in_params;
+
+	status = acpi_evaluate_object(handle, "_STM", &input, NULL);
+
+	if (ACPI_FAILURE(status)) {
+		ata_port_printk(ap, KERN_ERR, "ACPI set timing mode failed.\n");
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static void *ata_pata_find_handle(struct device *dev, int port)
+{
+	acpi_handle handle;
+	acpi_integer devfn;
+
+	if (libata_noacpi)
+		return NULL;
+	if (pata_get_dev_handle(dev, &handle, &devfn) < 0)
+		return NULL;
+	return acpi_get_child(handle, port);
+}
+
+void *ata_pata_acpi_handle(const struct ata_port *ap)
+{
+	return ata_pata_find_handle(ap->host->dev, ap->port_no);
+}
+
+int ata_pata_acpi_present(struct pci_dev *pdev)
+{
+	int present = 0;
+
+	if(ata_pata_find_handle(&pdev->dev, 0))
+		present |= 1;
+	if(ata_pata_find_handle(&pdev->dev, 1))
+		present |= 2;
+	return present;
+}
+
+
+EXPORT_SYMBOL_GPL(ata_acpi_gtm);
+EXPORT_SYMBOL_GPL(ata_acpi_stm);
+EXPORT_SYMBOL_GPL(ata_pata_acpi_handle);
+EXPORT_SYMBOL_GPL(ata_pata_acpi_present);
diff -puN /dev/null drivers/ata/libata-acpi.h
--- /dev/null
+++ a/drivers/ata/libata-acpi.h
@@ -0,0 +1,47 @@
+/*
+ *  libata-acpi.h - helper library for ATA ACPI drivers
+ *
+ *  Copyright 2007 Red Hat, Inc.  All rights reserved.
+ *  Copyright 2007 Alan Cox
+ *
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2, or (at your option)
+ *  any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; see the file COPYING.  If not, write to
+ *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ *
+ *  libata documentation is available via 'make {ps|pdf}docs',
+ *  as Documentation/DocBook/libata.*
+ *
+ */
+
+#ifndef __LIBATA_ACPI_H__
+#define __LIBATA_ACPI_H__
+
+struct acpi_drive
+{
+	u32 pio;
+	u32 dma;
+};
+
+struct acpi_gtm {
+	struct acpi_drive drive[2];
+	u32 flags;
+};
+
+extern int ata_acpi_gtm(const struct ata_port *p, void *handle, struct acpi_gtm *gtm);
+extern int ata_acpi_stm(const struct ata_port *ap, void *handle, struct acpi_gtm *stm);
+extern void *ata_pata_acpi_handle(const struct ata_port *ap);
+extern int ata_pata_acpi_present(struct pci_dev *pdev);
+
+#endif
_

Patches currently in -mm which might be from alan@redhat.com are

lots-of-architectures-enable-arbitary-speed-tty-support.patch
git-arm-master.patch
arm26-enable-arbitary-speed-tty-ioctls-and-split.patch
ia64-arbitary-speed-tty-ioctl-support.patch
libata-acpi-add-infrastructure-for-drivers-to-use.patch
pata_acpi-restore-driver.patch
hpt3x2n-correct-revision-boundary.patch
pata_sis-fix-and-clean-up-some-timing-setups.patch
pata_ali-more-work.patch
git-bluetooth.patch
git-scsi-misc.patch
git-watchdog.patch
watchdog-documentation.patch
xtensa-enable-arbitary-tty-speed-setting-ioctls.patch
blackfin-enable-arbitary-speed-serial-setting.patch
h8300-enable-arbitary-speed-tty-port-setup.patch
m32r-enable-arbitary-speed-tty-rate-setting.patch
etrax-enable-arbitary-speed-setting-on-tty-ports.patch
v850-enable-arbitary-speed-tty-ioctls.patch
prevent-an-o_ndelay-writer-from-blocking-when-a-tty-write-is-blocked-by.patch
edd-switch-to-pci_get-based-api.patch
only-send-sigxfsz-when-exceeding-rlimits.patch
revoke-special-mmap-handling.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
