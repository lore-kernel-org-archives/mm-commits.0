From: akpm@linux-foundation.org
Subject: + dmi_scan-refactor-dmi_scan_machine-smbiosdmi_present.patch added to -mm tree
Date: Tue, 05 Mar 2013 15:37:53 -0800
Message-ID: <20130305233753.B5AC531C1D8@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:51768 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523Ab3CEXhz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Mar 2013 18:37:55 -0500
Received: by mail-ve0-f202.google.com with SMTP id m1so801665ves.3
        for <mm-commits@vger.kernel.org>; Tue, 05 Mar 2013 15:37:54 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben@decadent.org.uk, tmhikaru@gmail.com, zhenzhong.duan@oracle.com


The patch titled
     Subject: dmi_scan: refactor dmi_scan_machine(), {smbios,dmi}_present()
has been added to the -mm tree.  Its filename is
     dmi_scan-refactor-dmi_scan_machine-smbiosdmi_present.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Reported-by: Tim McGrath <tmhikaru@gmail.com>
Tested-by: Tim Mcgrath <tmhikaru@gmail.com>
Cc: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/dmi_scan.c |   80 +++++++++++++++-------------------
 1 file changed, 37 insertions(+), 43 deletions(-)

diff -puN drivers/firmware/dmi_scan.c~dmi_scan-refactor-dmi_scan_machine-smbiosdmi_present drivers/firmware/dmi_scan.c
--- a/drivers/firmware/dmi_scan.c~dmi_scan-refactor-dmi_scan_machine-smbiosdmi_present
+++ a/drivers/firmware/dmi_scan.c
@@ -410,22 +410,45 @@ static void __init dmi_dump_ids(void)
 	printk(KERN_CONT "\n");
 }
 
-static int __init dmi_present(const char __iomem *p)
+static int __init dmi_present(const char *buf)
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
@@ -435,40 +458,14 @@ static int __init dmi_present(const char
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
-		return memcmp(q + 16, "_DMI_", 5) || dmi_present(p + 16);
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
@@ -481,10 +478,10 @@ void __init dmi_scan_machine(void)
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
@@ -499,18 +496,15 @@ void __init dmi_scan_machine(void)
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

linux-next.patch
dmi_scan-fix-missing-check-for-_dmi_-signature-in-smbios_present.patch
dmi_scan-refactor-dmi_scan_machine-smbiosdmi_present.patch

