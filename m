From: akpm@linux-foundation.org
Subject: [merged] ibft-update-ibft-handling-for-v103-of-the-spec.patch removed from -mm tree
Date: Tue, 27 Apr 2010 11:02:26 -0400
Message-ID: <201004271804.o3RI401k011033@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41983 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756499Ab0D0SFM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Apr 2010 14:05:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pjones@redhat.com, James.Bottomley@HansenPartnership.com, greg@kroah.com, konrad@kernel.org, michaelc@cs.wisc.edu, mm-commits@vger.kernel.org


The patch titled
     ibft: update iBFT handling for v1.03 of the spec.
has been removed from the -mm tree.  Its filename was
     ibft-update-ibft-handling-for-v103-of-the-spec.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ibft: update iBFT handling for v1.03 of the spec.
From: Peter Jones <pjones@redhat.com>

This patch series written by Peter Jones and Mike Christie expands on the
iBFT firmware driver to support v1.03 of the spec.  The spec in question
is available at:

ftp://ftp.software.ibm.com/systems/support/bladecenter/iscsi_boot_firmware_table_v1.03.pdf

Linux kernel has support for the iBFT 1.0 spec and this update to 1.03
adds three more things:

 - There is now a ACPI table either called 'iBFT' or 'IBFT' that should
   be parsed.

 - If running with UEFI, only look at the ACPI table.

 - If not found within ACPI tables, fall back to the old mechanism of
   scanning memory for the signature.

It has been tested with gPXE and also a real hardware.


This patch:

- Use struct acpi_table_ibft instead of struct ibft_table_header

- Don't do reserve_ibft_region() on UEFI machines (section 1.4.3.1)

- If ibft_addr isn't initialized when ibft_init() is called, check for
  ACPI-based tables.

Signed-off-by: Konrad Rzeszutek Wilk <konrad@kernel.org>
Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/iscsi_ibft.c      |   30 ++++++++++++++---------
 drivers/firmware/iscsi_ibft_find.c |   34 +++++++++++++++++++++++----
 include/linux/iscsi_ibft.h         |   12 +--------
 3 files changed, 49 insertions(+), 27 deletions(-)

diff -puN drivers/firmware/iscsi_ibft.c~ibft-update-ibft-handling-for-v103-of-the-spec drivers/firmware/iscsi_ibft.c
--- a/drivers/firmware/iscsi_ibft.c~ibft-update-ibft-handling-for-v103-of-the-spec
+++ a/drivers/firmware/iscsi_ibft.c
@@ -1,5 +1,5 @@
 /*
- *  Copyright 2007 Red Hat, Inc.
+ *  Copyright 2007-2010 Red Hat, Inc.
  *  by Peter Jones <pjones@redhat.com>
  *  Copyright 2008 IBM, Inc.
  *  by Konrad Rzeszutek <konradr@linux.vnet.ibm.com>
@@ -19,6 +19,9 @@
  *
  * Changelog:
  *
+ *  06 Jan 2010 - Peter Jones <pjones@redhat.com>
+ *    New changelog entries are in the git log from now on.  Not here.
+ *
  *  14 Mar 2008 - Konrad Rzeszutek <ketuzsezr@darnok.org>
  *    Updated comments and copyrights. (v0.4.9)
  *
@@ -78,9 +81,10 @@
 #include <linux/stat.h>
 #include <linux/string.h>
 #include <linux/types.h>
+#include <linux/acpi.h>
 
-#define IBFT_ISCSI_VERSION "0.4.9"
-#define IBFT_ISCSI_DATE "2008-Mar-14"
+#define IBFT_ISCSI_VERSION "0.5.0"
+#define IBFT_ISCSI_DATE "2010-Feb-25"
 
 MODULE_AUTHOR("Peter Jones <pjones@redhat.com> and \
 Konrad Rzeszutek <ketuzsezr@darnok.org>");
@@ -238,7 +242,7 @@ static const char *ibft_initiator_proper
  */
 
 struct ibft_kobject {
-	struct ibft_table_header *header;
+	struct acpi_table_ibft *header;
 	union {
 		struct ibft_initiator *initiator;
 		struct ibft_nic *nic;
@@ -536,12 +540,13 @@ static int __init ibft_check_device(void
 	u8 *pos;
 	u8 csum = 0;
 
-	len = ibft_addr->length;
+	len = ibft_addr->header.length;
 
 	/* Sanity checking of iBFT. */
-	if (ibft_addr->revision != 1) {
+	if (ibft_addr->header.revision != 1) {
 		printk(KERN_ERR "iBFT module supports only revision 1, " \
-				"while this is %d.\n", ibft_addr->revision);
+				"while this is %d.\n",
+				ibft_addr->header.revision);
 		return -ENOENT;
 	}
 	for (pos = (u8 *)ibft_addr; pos < (u8 *)ibft_addr + len; pos++)
@@ -558,7 +563,7 @@ static int __init ibft_check_device(void
 /*
  * Helper function for ibft_register_kobjects.
  */
-static int __init ibft_create_kobject(struct ibft_table_header *header,
+static int __init ibft_create_kobject(struct acpi_table_ibft *header,
 				       struct ibft_hdr *hdr,
 				       struct list_head *list)
 {
@@ -596,7 +601,7 @@ static int __init ibft_create_kobject(st
 	default:
 		printk(KERN_ERR "iBFT has unknown structure type (%d). " \
 				"Report this bug to %.6s!\n", hdr->id,
-				header->oem_id);
+				header->header.oem_id);
 		rc = 1;
 		break;
 	}
@@ -649,7 +654,7 @@ out_invalid_struct:
  * found add them on the passed-in list. We do not support the other
  * fields at this point, so they are skipped.
  */
-static int __init ibft_register_kobjects(struct ibft_table_header *header,
+static int __init ibft_register_kobjects(struct acpi_table_ibft *header,
 					  struct list_head *list)
 {
 	struct ibft_control *control = NULL;
@@ -660,7 +665,7 @@ static int __init ibft_register_kobjects
 
 	control = (void *)header + sizeof(*header);
 	end = (void *)control + control->hdr.length;
-	eot_offset = (void *)header + header->length - (void *)control;
+	eot_offset = (void *)header + header->header.length - (void *)control;
 	rc = ibft_verify_hdr("control", (struct ibft_hdr *)control, id_control,
 			     sizeof(*control));
 
@@ -672,7 +677,8 @@ static int __init ibft_register_kobjects
 	}
 	for (ptr = &control->initiator_off; ptr < end; ptr += sizeof(u16)) {
 		offset = *(u16 *)ptr;
-		if (offset && offset < header->length && offset < eot_offset) {
+		if (offset && offset < header->header.length &&
+						offset < eot_offset) {
 			rc = ibft_create_kobject(header,
 						 (void *)header + offset,
 						 list);
diff -puN drivers/firmware/iscsi_ibft_find.c~ibft-update-ibft-handling-for-v103-of-the-spec drivers/firmware/iscsi_ibft_find.c
--- a/drivers/firmware/iscsi_ibft_find.c~ibft-update-ibft-handling-for-v103-of-the-spec
+++ a/drivers/firmware/iscsi_ibft_find.c
@@ -1,5 +1,5 @@
 /*
- *  Copyright 2007 Red Hat, Inc.
+ *  Copyright 2007-2010 Red Hat, Inc.
  *  by Peter Jones <pjones@redhat.com>
  *  Copyright 2007 IBM, Inc.
  *  by Konrad Rzeszutek <konradr@linux.vnet.ibm.com>
@@ -22,6 +22,7 @@
 #include <linux/blkdev.h>
 #include <linux/ctype.h>
 #include <linux/device.h>
+#include <linux/efi.h>
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/limits.h>
@@ -30,13 +31,14 @@
 #include <linux/stat.h>
 #include <linux/string.h>
 #include <linux/types.h>
+#include <linux/acpi.h>
 
 #include <asm/mmzone.h>
 
 /*
  * Physical location of iSCSI Boot Format Table.
  */
-struct ibft_table_header *ibft_addr;
+struct acpi_table_ibft *ibft_addr;
 EXPORT_SYMBOL_GPL(ibft_addr);
 
 #define IBFT_SIGN "iBFT"
@@ -46,6 +48,13 @@ EXPORT_SYMBOL_GPL(ibft_addr);
 #define VGA_MEM 0xA0000 /* VGA buffer */
 #define VGA_SIZE 0x20000 /* 128kB */
 
+#ifdef CONFIG_ACPI
+static int __init acpi_find_ibft(struct acpi_table_header *header)
+{
+	ibft_addr = (struct acpi_table_ibft *)header;
+	return 0;
+}
+#endif /* CONFIG_ACPI */
 
 /*
  * Routine used to find the iSCSI Boot Format Table. The logical
@@ -59,6 +68,11 @@ unsigned long __init find_ibft_region(un
 
 	ibft_addr = NULL;
 
+	/* iBFT 1.03 section 1.4.3.1 mandates that UEFI machines will
+	 * only use ACPI for this */
+	if (efi_enabled)
+		return 0;
+
 	for (pos = IBFT_START; pos < IBFT_END; pos += 16) {
 		/* The table can't be inside the VGA BIOS reserved space,
 		 * so skip that area */
@@ -72,14 +86,24 @@ unsigned long __init find_ibft_region(un
 			/* if the length of the table extends past 1M,
 			 * the table cannot be valid. */
 			if (pos + len <= (IBFT_END-1)) {
-				ibft_addr = (struct ibft_table_header *)virt;
+				ibft_addr = (struct acpi_table_ibft *)virt;
 				break;
 			}
 		}
 	}
+#ifdef CONFIG_ACPI
+	/*
+	 * One spec says "IBFT", the other says "iBFT". We have to check
+	 * for both.
+	 */
+	if (!ibft_addr)
+		acpi_table_parse(ACPI_SIG_IBFT, acpi_find_ibft);
+	if (!ibft_addr)
+		acpi_table_parse("iBFT", acpi_find_ibft);
+#endif /* CONFIG_ACPI */
 	if (ibft_addr) {
-		*sizep = PAGE_ALIGN(len);
-		return pos;
+		*sizep = PAGE_ALIGN(ibft_addr->header.length);
+		return (u64)isa_virt_to_bus(ibft_addr);
 	}
 
 	*sizep = 0;
diff -puN include/linux/iscsi_ibft.h~ibft-update-ibft-handling-for-v103-of-the-spec include/linux/iscsi_ibft.h
--- a/include/linux/iscsi_ibft.h~ibft-update-ibft-handling-for-v103-of-the-spec
+++ a/include/linux/iscsi_ibft.h
@@ -21,21 +21,13 @@
 #ifndef ISCSI_IBFT_H
 #define ISCSI_IBFT_H
 
-struct ibft_table_header {
-	char signature[4];
-	u32 length;
-	u8 revision;
-	u8 checksum;
-	char oem_id[6];
-	char oem_table_id[8];
-	char reserved[24];
-} __attribute__((__packed__));
+#include <acpi/acpi.h>
 
 /*
  * Logical location of iSCSI Boot Format Table.
  * If the value is NULL there is no iBFT on the machine.
  */
-extern struct ibft_table_header *ibft_addr;
+extern struct acpi_table_ibft *ibft_addr;
 
 /*
  * Routine used to find and reserve the iSCSI Boot Format Table. The
_

Patches currently in -mm which might be from pjones@redhat.com are

origin.patch
linux-next.patch

