From: akpm@linux-foundation.org
Subject: + libata-acpi-add-infrastructure-for-drivers-to-use.patch added to -mm tree
Date: Sun, 11 Mar 2007 01:31:01 -0800
Message-ID: <200703110931.l2B9V1Oq008905@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41292 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752032AbXCKJbK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Mar 2007 05:31:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@redhat.com


The patch titled
     libata-acpi: add infrastructure for drivers to use _GTM/_STM methods
has been added to the -mm tree.  Its filename is
     libata-acpi-add-infrastructure-for-drivers-to-use.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -703,3 +703,88 @@ out:
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
+	if (noacpi)
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

git-libata-all.patch
expose-set_mode-method-so-it-can-be-wrapped.patch
pcmcia-spot-slave-decode-flaws-for-testing.patch
ata_generic-remove-all-the-crud-again-and-use-cable.patch
pata_ali-remove-all-the-crap-again-and-switch-to.patch
pata_amd-remove-all-the-crud-and-restore-the-cable-detect.patch
pata_artop-remove-all-the-crud-again-and-restore-the-cable.patch
pata_atiixp-restore-the-cable-method.patch
pata_cmd64x-restore-cable-method.patch
pata_cs5520-re-remove-crap-and-switch-to-cable-detect.patch
pata_cs5530-re-remove-all-the-crap-and-switch-back-to-the.patch
pata_cs5535-re-remove-all-the-crap-and-switch-to-the-cable.patch
pata_cypress-re-remove-all-the-crap-and-switch-back-to.patch
pata_efar-switch-back-to-cable-methods.patch
pata_hpt366-switch-back-to-cable-method-again.patch
pata_hpt3x3-switch-back-to-cable-method-and-re-remove-all.patch
pata_isapnp-put-cable-type-back.patch
pata_it8213-switch-to-cable-method-again.patch
pata_it821x-switch-back-to-cable-detect-and-re-remove-all.patch
pata_ixp4xx_cf-restore-cable-type-method.patch
pata_legacy-restore-cable-methods.patch
pata_marvell-restore-cable-methods-and-reapply-lost-bug.patch
pata_mpc52xx-restore-cable-method.patch
pata_mpiix-restore-cable-type-method.patch
pata_netcell-re-remove-all-the-crud.patch
pata_ns87410-restore-cable-detect-method.patch
pata_oldpiix-restore-cable-method-re-correct-comments.patch
pata_opti-restore-cable-method.patch
pata_pcmcia-restore-cable-reporting.patch
pata_pdc202xx_old-re-remove-crap-restore-cable-methods.patch
pata_qdi-restore-cable-detect.patch
pata_serverworks-re-remove-crap-restore-cable-detect.patch
pata_sil680-restore-cable-detect-methods.patch
pata_sis-restore-cable-method-re-perform-crapectory.patch
pata_sl82c105-restore-cable-detect-method.patch
pata_via-restore-cable-detect.patch
pata_winbond-restore-cable-method.patch
sata_via-use-cable-detect-methods.patch
libata-acpi-try-and-stop-all-the-non-pci-devices-crashing.patch
libata-acpi-add-infrastructure-for-drivers-to-use.patch
pata_optidma-rework-for-cable-detect-and-to-remove.patch
pata_pdc2027x-restore-various-updates-done-on-the-driver.patch
pata_acpi-restore-driver.patch
ata_piix-remove-ugly-layering-violation.patch
pata_cmd640-multiple-updates.patch
dilnetpc-fix-warning.patch
resend-iphase-64bit-cleanup.patch
pci_module_init-convertion-in-tmscsimc.patch
z85230-fix-fifo-handling.patch
tty-clarify-documentation-of-write.patch
