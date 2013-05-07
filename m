From: akpm@linux-foundation.org
Subject: [merged] dmi_scan-refactor-dmi_scan_machine-smbiosdmi_present.patch removed from -mm tree
Date: Tue, 07 May 2013 10:48:27 -0700
Message-ID: <20130507174827.840EE5A4174@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:53784 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757701Ab3EGRs2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:48:28 -0400
Received: by mail-yh0-f74.google.com with SMTP id t59so85133yho.3
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:48:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben@decadent.org.uk, artem.savkov@gmail.com, tmhikaru@gmail.com, zhenzhong.duan@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dmi_scan: refactor dmi_scan_machine(), {smbios,dmi}_present()
has been removed from the -mm tree.  Its filename was
     dmi_scan-refactor-dmi_scan_machine-smbiosdmi_present.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ben Hutchings <ben@decadent.org.uk>
Subject: dmi_scan: refactor dmi_scan_machine(), {smbios,dmi}_present()

Move the calls to memcpy_fromio() up into the loop in dmi_scan_machine(),
and move the signature checks back down into dmi_decode().  We need to
check at 16-byte intervals but keep a 32-byte buffer for an SMBIOS entry,
so shift the buffer after each iteration.

Merge smbios_present() into dmi_present(), so we look for an SMBIOS
signature at the beginning of the given buffer and then for a DMI
signature at an offset of 16 bytes.

[artem.savkov@gmail.com: use proper buf type in dmi_present()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Reported-by: Tim McGrath <tmhikaru@gmail.com>
Tested-by: Tim Mcgrath <tmhikaru@gmail.com>
Cc: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Signed-off-by: Artem Savkov <artem.savkov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/dmi_scan.c |   80 +++++++++++++++-------------------
 1 file changed, 37 insertions(+), 43 deletions(-)

diff -puN drivers/firmware/dmi_scan.c~dmi_scan-refactor-dmi_scan_machine-smbiosdmi_present drivers/firmware/dmi_scan.c
--- a/drivers/firmware/dmi_scan.c~dmi_scan-refactor-dmi_scan_machine-smbiosdmi_present
+++ a/drivers/firmware/dmi_scan.c
@@ -419,22 +419,45 @@ static void __init dmi_format_ids(char *
 			    dmi_get_system_info(DMI_BIOS_DATE));
 }
 
-static int __init dmi_present(const char __iomem *p)
+static int __init dmi_present(const u8 *buf)
 {
-	u8 buf[15];
+	int smbios_ver;
 
-	memcpy_fromio(buf, p, 15);
-	if (dmi_checksum(buf, 15)) {
+	if (memcmp(buf, "_SM_", 4) == 0 &&
+	    buf[5] < 32 && dmi_checksum(buf, buf[5])) {
+		smbios_ver = (buf[6] << 8) + buf[7];
+
+		/* Some BIOS report weird SMBIOS version, fix that up */
+		switch (smbios_ver) {
+		case 0x021F:
+		case 0x0221:
+			pr_debug("SMBIOS version fixup(2.%d->2.%d)\n",
+				 smbios_ver & 0xFF, 3);
+			smbios_ver = 0x0203;
+			break;
+		case 0x0233:
+			pr_debug("SMBIOS version fixup(2.%d->2.%d)\n", 51, 6);
+			smbios_ver = 0x0206;
+			break;
+		}
+	} else {
+		smbios_ver = 0;
+	}
+
+	buf += 16;
+
+	if (memcmp(buf, "_DMI_", 5) == 0 && dmi_checksum(buf, 15)) {
 		dmi_num = (buf[13] << 8) | buf[12];
 		dmi_len = (buf[7] << 8) | buf[6];
 		dmi_base = (buf[11] << 24) | (buf[10] << 16) |
 			(buf[9] << 8) | buf[8];
 
 		if (dmi_walk_early(dmi_decode) == 0) {
-			if (dmi_ver)
+			if (smbios_ver) {
+				dmi_ver = smbios_ver;
 				pr_info("SMBIOS %d.%d present.\n",
 				       dmi_ver >> 8, dmi_ver & 0xFF);
-			else {
+			} else {
 				dmi_ver = (buf[14] & 0xF0) << 4 |
 					   (buf[14] & 0x0F);
 				pr_info("Legacy DMI %d.%d present.\n",
@@ -445,40 +468,14 @@ static int __init dmi_present(const char
 			return 0;
 		}
 	}
-	dmi_ver = 0;
-	return 1;
-}
 
-static int __init smbios_present(const char __iomem *p)
-{
-	u8 buf[32];
-
-	memcpy_fromio(buf, p, 32);
-	if ((buf[5] < 32) && dmi_checksum(buf, buf[5])) {
-		dmi_ver = (buf[6] << 8) + buf[7];
-
-		/* Some BIOS report weird SMBIOS version, fix that up */
-		switch (dmi_ver) {
-		case 0x021F:
-		case 0x0221:
-			pr_debug("SMBIOS version fixup(2.%d->2.%d)\n",
-			       dmi_ver & 0xFF, 3);
-			dmi_ver = 0x0203;
-			break;
-		case 0x0233:
-			pr_debug("SMBIOS version fixup(2.%d->2.%d)\n", 51, 6);
-			dmi_ver = 0x0206;
-			break;
-		}
-		return memcmp(p + 16, "_DMI_", 5) || dmi_present(p + 16);
-	}
 	return 1;
 }
 
 void __init dmi_scan_machine(void)
 {
 	char __iomem *p, *q;
-	int rc;
+	char buf[32];
 
 	if (efi_enabled(EFI_CONFIG_TABLES)) {
 		if (efi.smbios == EFI_INVALID_TABLE_ADDR)
@@ -491,10 +488,10 @@ void __init dmi_scan_machine(void)
 		p = dmi_ioremap(efi.smbios, 32);
 		if (p == NULL)
 			goto error;
-
-		rc = smbios_present(p);
+		memcpy_fromio(buf, p, 32);
 		dmi_iounmap(p, 32);
-		if (!rc) {
+
+		if (!dmi_present(buf)) {
 			dmi_available = 1;
 			goto out;
 		}
@@ -509,18 +506,15 @@ void __init dmi_scan_machine(void)
 		if (p == NULL)
 			goto error;
 
+		memset(buf, 0, 16);
 		for (q = p; q < p + 0x10000; q += 16) {
-			if (memcmp(q, "_SM_", 4) == 0 && q - p <= 0xFFE0)
-				rc = smbios_present(q);
-			else if (memcmp(q, "_DMI_", 5) == 0)
-				rc = dmi_present(q);
-			else
-				continue;
-			if (!rc) {
+			memcpy_fromio(buf + 16, q, 16);
+			if (!dmi_present(buf)) {
 				dmi_available = 1;
 				dmi_iounmap(p, 0x10000);
 				goto out;
 			}
+			memcpy(buf, buf + 16, 16);
 		}
 		dmi_iounmap(p, 0x10000);
 	}
_

Patches currently in -mm which might be from ben@decadent.org.uk are

origin.patch

