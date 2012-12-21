From: akpm@linux-foundation.org
Subject: [merged] drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid.patch removed from -mm tree
Date: Fri, 21 Dec 2012 12:39:16 -0800
Message-ID: <20121221203917.26B2620004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:59244 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801Ab2LUUjT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Dec 2012 15:39:19 -0500
Received: by mail-fa0-f74.google.com with SMTP id t1so272491fae.3
        for <mm-commits@vger.kernel.org>; Fri, 21 Dec 2012 12:39:18 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhenzhong.duan@oracle.com, joe.jin@oracle.com, khali@linux-fr.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/firmware/dmi_scan.c: check dmi version when get system uuid
has been removed from the -mm tree.  Its filename was
     drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Subject: drivers/firmware/dmi_scan.c: check dmi version when get system uuid

As of version 2.6 of the SMBIOS specification, the first 3
fields of the UUID are supposed to be little-endian encoded.

Also a minor fix to match variable meaning and mute checkpatch.pl

[akpm@linux-foundation.org: tweak code comment]
Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Cc: Feng Jin <joe.jin@oracle.com>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/dmi_scan.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff -puN drivers/firmware/dmi_scan.c~drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid drivers/firmware/dmi_scan.c
--- a/drivers/firmware/dmi_scan.c~drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid
+++ a/drivers/firmware/dmi_scan.c
@@ -16,6 +16,7 @@
  */
 static char dmi_empty_string[] = "        ";
 
+static u16 __initdata dmi_ver;
 /*
  * Catch too early calls to dmi_check_system():
  */
@@ -161,8 +162,10 @@ static void __init dmi_save_uuid(const s
 		return;
 
 	for (i = 0; i < 16 && (is_ff || is_00); i++) {
-		if(d[i] != 0x00) is_ff = 0;
-		if(d[i] != 0xFF) is_00 = 0;
+		if (d[i] != 0x00)
+			is_00 = 0;
+		if (d[i] != 0xFF)
+			is_ff = 0;
 	}
 
 	if (is_ff || is_00)
@@ -172,7 +175,15 @@ static void __init dmi_save_uuid(const s
 	if (!s)
 		return;
 
-	sprintf(s, "%pUB", d);
+	/*
+	 * As of version 2.6 of the SMBIOS specification, the first 3 fields of
+	 * the UUID are supposed to be little-endian encoded.  The specification
+	 * says that this is the defacto standard.
+	 */
+	if (dmi_ver >= 0x0206)
+		sprintf(s, "%pUL", d);
+	else
+		sprintf(s, "%pUB", d);
 
         dmi_ident[slot] = s;
 }
@@ -414,6 +425,7 @@ static int __init dmi_present(const char
 		 * DMI version 0.0 means that the real version is taken from
 		 * the SMBIOS version, which we don't know at this point.
 		 */
+		dmi_ver = (buf[14] & 0xf0) << 4 | (buf[14] & 0x0f);
 		if (buf[14] != 0)
 			printk(KERN_INFO "DMI %d.%d present.\n",
 			       buf[14] >> 4, buf[14] & 0xF);
_

Patches currently in -mm which might be from zhenzhong.duan@oracle.com are

origin.patch
linux-next.patch

