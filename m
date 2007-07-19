From: akpm@linux-foundation.org
Subject: + fix-acpi_ev_pci_config_region_setup-to-avoid-memory-leak.patch added to -mm tree
Date: Wed, 18 Jul 2007 17:51:59 -0700
Message-ID: <200707190051.l6J0pxST005785@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55413 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763214AbXGSAwH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Jul 2007 20:52:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jesper.juhl@gmail.com


The patch titled
     Fix acpi_ev_pci_config_region_setup() to avoid memory leak
has been added to the -mm tree.  Its filename is
     fix-acpi_ev_pci_config_region_setup-to-avoid-memory-leak.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
fix-acpi_ev_pci_config_region_setup-to-avoid-memory-leak.patch
git-mtd.patch
remove-unneeded-test-of-task-in-dump_trace.patch
git-xfs.patch
