From: akpm@linux-foundation.org
Subject: + watchdog-hpwdt-use-dmi_walk-instead-of-own-copy.patch added to -mm tree
Date: Fri, 29 Feb 2008 14:49:14 -0800
Message-ID: <200802292249.m1TMnEYu024780@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:45718 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753077AbYB2Wtx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Feb 2008 17:49:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rdreier@cisco.com, Thomas.Mingarelli@hp.com, rolandd@cisco.com, wim@iguana.be


The patch titled
     watchdog: hpwdt: use dmi_walk() instead of own copy
has been added to the -mm tree.  Its filename is
     watchdog-hpwdt-use-dmi_walk-instead-of-own-copy.patch

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
Subject: watchdog: hpwdt: use dmi_walk() instead of own copy
From: Roland Dreier <rdreier@cisco.com>

On my HP DL380 G5 system running a 64-bit kernel, loading the hpwdt driver
causes a crash because the driver attempts to ioremap an invalid physical
address.  This is because the driver has an incorrect definition of the SMBIOS
table entry point structure: the table address is only a 32-bit quantity, and
making it a u64 means that the high-order 32 bits end up containing garbage.

We can fix this by simply deleting all of the duplicated DMI table walking
code and using the kernel's existing dmi_walk() interface to find the DMI
entry the driver is looking for.

Tested on an HP DL380 G5 running a 64-bit kernel.

Signed-off-by: Roland Dreier <rolandd@cisco.com>
Acked-by: Thomas Mingarelli <Thomas.Mingarelli@hp.com>
Cc: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/hpwdt.c |  203 +++----------------------------------
 1 file changed, 20 insertions(+), 183 deletions(-)

diff -puN drivers/watchdog/hpwdt.c~watchdog-hpwdt-use-dmi_walk-instead-of-own-copy drivers/watchdog/hpwdt.c
--- a/drivers/watchdog/hpwdt.c~watchdog-hpwdt-use-dmi_walk-instead-of-own-copy
+++ a/drivers/watchdog/hpwdt.c
@@ -58,41 +58,6 @@ struct bios32_service_dir {
 	u8 reserved[5];
 };
 
-/*
- * smbios_entry_point     - defines SMBIOS entry point structure
- *
- * anchor[4]              - anchor string (_SM_)
- * checksum               - checksum of the entry point structure
- * length                 - length of the entry point structure
- * major_ver              - major version (02h for revision 2.1)
- * minor_ver              - minor version (01h for revision 2.1)
- * max_struct_size        - size of the largest SMBIOS structure
- * revision               - entry point structure revision implemented
- * formatted_area[5]      - reserved
- * intermediate_anchor[5] - intermediate anchor string (_DMI_)
- * intermediate_checksum  - intermediate checksum
- * table_length           - structure table length
- * table_address          - structure table address
- * table_num_structs      - number of SMBIOS structures present
- * bcd_revision           - BCD revision
- */
-struct smbios_entry_point {
-	u8 anchor[4];
-	u8 checksum;
-	u8 length;
-	u8 major_ver;
-	u8 minor_ver;
-	u16 max_struct_size;
-	u8 revision;
-	u8 formatted_area[5];
-	u8 intermediate_anchor[5];
-	u8 intermediate_checksum;
-	u16 table_length;
-	u32 table_address;
-	u16 table_num_structs;
-	u8 bcd_revision;
-};
-
 /* type 212 */
 struct smbios_cru64_info {
 	u8 type;
@@ -175,24 +140,6 @@ static struct pci_device_id hpwdt_device
 };
 MODULE_DEVICE_TABLE(pci, hpwdt_devices);
 
-/*
- *	bios_checksum
- */
-static int __devinit bios_checksum(const char __iomem *ptr, int len)
-{
-	char sum = 0;
-	int i;
-
-	/*
-	 * calculate checksum of size bytes. This should add up
-	 * to zero if we have a valid header.
-	 */
-	for (i = 0; i < len; i++)
-		sum += ptr[i];
-
-	return ((sum == 0) && (len > 0));
-}
-
 #ifndef CONFIG_X86_64
 /* --32 Bit Bios------------------------------------------------------------ */
 
@@ -303,6 +250,24 @@ static int __devinit cru_detect(unsigned
 }
 
 /*
+ *	bios_checksum
+ */
+static int __devinit bios_checksum(const char __iomem *ptr, int len)
+{
+	char sum = 0;
+	int i;
+
+	/*
+	 * calculate checksum of size bytes. This should add up
+	 * to zero if we have a valid header.
+	 */
+	for (i = 0; i < len; i++)
+		sum += ptr[i];
+
+	return ((sum == 0) && (len > 0));
+}
+
+/*
  *	bios32_present
  *
  *	Routine Description:
@@ -410,12 +375,8 @@ asmlinkage void asminline_call(struct cm
  *	dmi_find_cru
  *
  *	Routine Description:
- *	This function checks wether or not a SMBIOS/DMI record is
+ *	This function checks whether or not a SMBIOS/DMI record is
  *	the 64bit CRU info or not
- *
- *	Return Value:
- *	0        :  SUCCESS - if record found
- *	<0       :  FAILURE - if record not found
  */
 static void __devinit dmi_find_cru(const struct dmi_header *dm)
 {
@@ -434,135 +395,11 @@ static void __devinit dmi_find_cru(const
 	}
 }
 
-/*
- *	dmi_table
- *
- *	Routine Description:
- *	Decode the SMBIOS/DMI table and check if we have a 64bit CRU record
- *	or not.
- *
- *	We have to be cautious here. We have seen BIOSes with DMI pointers
- *	pointing to completely the wrong place for example
- */
-static void __devinit dmi_table(u8 *buf, int len, int num,
-		      void (*decode)(const struct dmi_header *))
-{
-	u8 *data = buf;
-	int i = 0;
-
-	/*
-	 *	Stop when we see all the items the table claimed to have
-	 *	OR we run off the end of the table (also happens)
-	 */
-	while ((i < num) && (data - buf + sizeof(struct dmi_header)) <= len) {
-		const struct dmi_header *dm = (const struct dmi_header *)data;
-
-		/*
-		 *  We want to know the total length (formated area and strings)
-		 *  before decoding to make sure we won't run off the table in
-		 *  dmi_decode or dmi_string
-		 */
-		data += dm->length;
-		while ((data - buf < len - 1) && (data[0] || data[1]))
-			data++;
-		if (data - buf < len - 1)
-			decode(dm);
-		data += 2;
-		i++;
-	}
-}
-
-/*
- *	smbios_present
- *
- *	Routine Description:
- *	This function parses the SMBIOS entry point table to retrieve
- *	the 64 bit CRU Service.
- *
- *	Return Value:
- *	0        :  SUCCESS
- *	<0       :  FAILURE
- */
-static int __devinit smbios_present(const char __iomem *p)
-{
-	struct smbios_entry_point *eps =
-		(struct smbios_entry_point *) p;
-	int length;
-	u8 *buf;
-
-	/* check if we have indeed the SMBIOS table entry point */
-	if ((strncmp((char *)eps->anchor, "_SM_",
-			     sizeof(eps->anchor))) == 0) {
-		length = eps->length;
-
-		/* SMBIOS v2.1 implementation might use 0x1e */
-		if ((length == 0x1e) &&
-		    (eps->major_ver == 2) &&
-		    (eps->minor_ver == 1))
-			length = 0x1f;
-
-		/*
-		 * Now we will check:
-		 * - SMBIOS checksum must be 0
-		 * - intermediate anchor should be _DMI_
-		 * - intermediate checksum should be 0
-		 */
-		if ((bios_checksum(p, length)) &&
-		    (strncmp((char *)eps->intermediate_anchor, "_DMI_",
-		             sizeof(eps->intermediate_anchor)) == 0) &&
-		    (bios_checksum(p+0x10, 15))) {
-			buf = ioremap(eps->table_address, eps->table_length);
-			if (buf == NULL)
-				return -ENODEV;
-
-
-			/* Scan the DMI table for the 64 bit CRU service */
-			dmi_table(buf, eps->table_length,
-			          eps->table_num_structs, dmi_find_cru);
-
-			iounmap(buf);
-			return 0;
-		}
-	}
-
-	return -ENODEV;
-}
-
-static void __devinit smbios_scan_machine(void)
-{
-	char __iomem *p, *q;
-
-	if (efi_enabled) {
-		if (efi.smbios == EFI_INVALID_TABLE_ADDR)
-			return;
-
-		p = ioremap(efi.smbios, 32);
-		if (p == NULL)
-			return;
-
-		smbios_present(p);
-		iounmap(p);
-	} else {
-		/*
-		 * Search from 0x0f0000 through 0x0fffff, inclusive.
-		 */
-		p = ioremap(PCI_ROM_BASE1, ROM_SIZE);
-		if (p == NULL)
-			return;
-
-		for (q = p; q < p + ROM_SIZE; q += 16)
-			if (!smbios_present(q))
-				break;
-
-		iounmap(p);
-	}
-}
