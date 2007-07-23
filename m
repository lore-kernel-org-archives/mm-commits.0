From: akpm@linux-foundation.org
Subject: - fix-acpi_ev_pci_config_region_setup-to-avoid-memory-leak.patch removed from -mm tree
Date: Mon, 23 Jul 2007 02:35:23 -0700
Message-ID: <200707230935.l6N9ZNow016482@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39965 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757722AbXGWJpJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 05:45:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.juhl@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Fix acpi_ev_pci_config_region_setup() to avoid memory leak
has been removed from the -mm tree.  Its filename was
     fix-acpi_ev_pci_config_region_setup-to-avoid-memory-leak.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix acpi_ev_pci_config_region_setup() to avoid memory leak
From: Jesper Juhl <jesper.juhl@gmail.com>

In drivers/acpi/events/evrgnini.c::acpi_ev_pci_config_region_setup()
there is a memory leak.
We may return at "if (!pci_device_node)" without freeing storage
previously allocated and assigned to 'pci_id'.
This patch fixes the leak by freeing the allocated storage in this
case.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/events/evrgnini.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN drivers/acpi/events/evrgnini.c~fix-acpi_ev_pci_config_region_setup-to-avoid-memory-leak drivers/acpi/events/evrgnini.c
--- a/drivers/acpi/events/evrgnini.c~fix-acpi_ev_pci_config_region_setup-to-avoid-memory-leak
+++ a/drivers/acpi/events/evrgnini.c
@@ -284,6 +284,7 @@ acpi_ev_pci_config_region_setup(acpi_han
 	}
 
 	if (!pci_device_node) {
+		ACPI_FREE(pci_id);
 		return_ACPI_STATUS(AE_AML_OPERAND_TYPE);
 	}
 
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

fix-use-after-free--double-free-bug-in-amd_create_gatt_pages--amd_free_gatt_pages.patch
git-gfs2-nmw.patch
git-kbuild.patch
git-mtd.patch
git-selinux.patch
git-xfs.patch
ipmi-fix-mem-leak-in-try_init_dmi.patch
fix-a-use-after-free-bug-in-kernel-userspace-relay-file-support.patch
floppy-do-a-very-minimal-style-cleanup-of-the-floppy-driver.patch
floppy-remove-dead-commented-out-code-from-floppy-driver.patch
floppy-remove-register-keyword-use-from-floppy-driver.patch
