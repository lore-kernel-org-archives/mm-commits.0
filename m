From: akpm@linux-foundation.org
Subject: + drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists.patch added to -mm tree
Date: Wed, 25 Jul 2012 12:55:30 -0700
Message-ID: <20120725195531.2A8AF100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:34899 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432Ab2GYTzc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jul 2012 15:55:32 -0400
Received: by qabg24 with SMTP id g24so147725qab.1
        for <mm-commits@vger.kernel.org>; Wed, 25 Jul 2012 12:55:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zhenzhong.duan@oracle.com, joe.jin@oracle.com, khali@linux-fr.org


The patch titled
     Subject: drivers/firmware/dmi_scan.c: fetch dmi version from SMBIOS if it exists
has been added to the -mm tree.  Its filename is
     drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Subject: drivers/firmware/dmi_scan.c: fetch dmi version from SMBIOS if it exists

The right dmi version is in SMBIOS if it's zero in DMI region

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Cc: Feng Jin <joe.jin@oracle.com>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/dmi_scan.c |   63 +++++++++++++++++++++++++---------
 1 file changed, 48 insertions(+), 15 deletions(-)

diff -puN drivers/firmware/dmi_scan.c~drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists drivers/firmware/dmi_scan.c
--- a/drivers/firmware/dmi_scan.c~drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists
+++ a/drivers/firmware/dmi_scan.c
@@ -119,12 +119,12 @@ static int __init dmi_walk_early(void (*
 	return 0;
 }
 
-static int __init dmi_checksum(const u8 *buf)
+static int __init dmi_checksum(const u8 *buf, u8 len)
 {
 	u8 sum = 0;
 	int a;
 
-	for (a = 0; a < 15; a++)
+	for (a = 0; a < len; a++)
 		sum += buf[a];
 
 	return sum == 0;
@@ -415,30 +415,58 @@ static int __init dmi_present(const char
 	u8 buf[15];
 
 	memcpy_fromio(buf, p, 15);
-	if ((memcmp(buf, "_DMI_", 5) == 0) && dmi_checksum(buf)) {
+	if (dmi_checksum(buf, 15)) {
 		dmi_num = (buf[13] << 8) | buf[12];
 		dmi_len = (buf[7] << 8) | buf[6];
 		dmi_base = (buf[11] << 24) | (buf[10] << 16) |
 			(buf[9] << 8) | buf[8];
 
-		/*
-		 * DMI version 0.0 means that the real version is taken from
-		 * the SMBIOS version, which we don't know at this point.
-		 */
-		dmi_ver = (buf[14] & 0xf0) << 4 | (buf[14] & 0x0f);
-		if (buf[14] != 0)
-			printk(KERN_INFO "DMI %d.%d present.\n",
-			       buf[14] >> 4, buf[14] & 0xF);
-		else
-			printk(KERN_INFO "DMI present.\n");
 		if (dmi_walk_early(dmi_decode) == 0) {
+			if (dmi_ver)
+				printk(KERN_INFO "SMBIOS %d.%d present.\n",
+				       dmi_ver >> 8, dmi_ver & 0xFF);
+			else {
+				dmi_ver = (buf[14] & 0xF0) << 4 |
+					   (buf[14] & 0x0F);
+				printk(KERN_INFO "Legacy DMI %d.%d present.\n",
+				       dmi_ver >> 8, dmi_ver & 0xFF);
+			}
 			dmi_dump_ids();
 			return 0;
 		}
 	}
+	dmi_ver = 0;
 	return 1;
 }
 
+static int __init smbios_present(const char __iomem *p)
+{
+	u8 buf[32];
+	int offset = 0;
+
+	memcpy_fromio(buf, p, 32);
+	if ((buf[5] < 32) && dmi_checksum(buf, buf[5])) {
+		dmi_ver = (buf[6] << 8) + buf[7];
+
+		/* Some BIOS report weird SMBIOS version, fix that up */
+		switch (dmi_ver) {
+		case 0x021F:
+		case 0x0221:
+			printk(KERN_DEBUG "SMBIOS version fixup(2.%d->2.%d)\n",
+			       dmi_ver & 0xFF, 3);
+			dmi_ver = 0x0203;
+			break;
+		case 0x0233:
+			printk(KERN_DEBUG "SMBIOS version fixup(2.%d->2.%d)\n",
+			       51, 6);
+			dmi_ver = 0x0206;
+			break;
+		}
+		offset = 16;
+	}
+	return dmi_present(buf + offset);
+}
+
 void __init dmi_scan_machine(void)
 {
 	char __iomem *p, *q;
@@ -456,7 +484,7 @@ void __init dmi_scan_machine(void)
 		if (p == NULL)
 			goto error;
 
-		rc = dmi_present(p + 0x10); /* offset of _DMI_ string */
+		rc = smbios_present(p);
 		dmi_iounmap(p, 32);
 		if (!rc) {
 			dmi_available = 1;
@@ -474,7 +502,12 @@ void __init dmi_scan_machine(void)
 			goto error;
 
 		for (q = p; q < p + 0x10000; q += 16) {
-			rc = dmi_present(q);
+			if (memcmp(q, "_SM_", 4) == 0 && q - p <= 0xFFE0)
+				rc = smbios_present(q);
+			else if (memcmp(q, "_DMI_", 5) == 0)
+				rc = dmi_present(q);
+			else
+				continue;
 			if (!rc) {
 				dmi_available = 1;
 				dmi_iounmap(p, 0x10000);
_
Subject: Subject: drivers/firmware/dmi_scan.c: fetch dmi version from SMBIOS if it exists

Patches currently in -mm which might be from zhenzhong.duan@oracle.com are

origin.patch
linux-next.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists.patch

