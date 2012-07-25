From: akpm@linux-foundation.org
Subject: + drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid.patch added to -mm tree
Date: Wed, 25 Jul 2012 12:51:01 -0700
Message-ID: <20120725195102.981935C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:63395 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003Ab2GYTvF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jul 2012 15:51:05 -0400
Received: by bkcjc3 with SMTP id jc3so54129bkc.1
        for <mm-commits@vger.kernel.org>; Wed, 25 Jul 2012 12:51:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zhenzhong.duan@oracle.com, joe.jin@oracle.com, khali@linux-fr.org


The patch titled
     Subject: drivers/firmware/dmi_scan.c: check dmi version when get system uuid
has been added to the -mm tree.  Its filename is
     drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid.patch

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
Subject: drivers/firmware/dmi_scan.c: check dmi version when get system uuid

As of version 2.6 of the SMBIOS specification, the first 3
fields of the UUID are supposed to be little-endian encoded.

Also a minor fix to match variable meaning and mute checkpatch.pl

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Cc: Feng Jin <joe.jin@oracle.com>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/dmi_scan.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff -puN drivers/firmware/dmi_scan.c~drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid drivers/firmware/dmi_scan.c
--- a/drivers/firmware/dmi_scan.c~drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid
+++ a/drivers/firmware/dmi_scan.c
@@ -16,6 +16,7 @@
  */
 static char dmi_empty_string[] = "        ";
 
+static u16  __initdata dmi_ver;
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
@@ -172,7 +175,16 @@ static void __init dmi_save_uuid(const s
 	if (!s)
 		return;
 
-	sprintf(s, "%pUB", d);
+	/*
+	 * As of version 2.6 of the SMBIOS specification, the first 3
+	 * fields of the UUID are supposed to be encoded on little-endian.
+	 * The specification says that this is the defacto standard,
+	 * update kernel code to match dmidecode data.
+	*/
+	if (dmi_ver >= 0x0206)
+		sprintf(s, "%pUL", d);
+	else
+		sprintf(s, "%pUB", d);
 
         dmi_ident[slot] = s;
 }
@@ -414,6 +426,7 @@ static int __init dmi_present(const char
 		 * DMI version 0.0 means that the real version is taken from
 		 * the SMBIOS version, which we don't know at this point.
 		 */
+		dmi_ver = (buf[14] & 0xf0) << 4 | (buf[14] & 0x0f);
 		if (buf[14] != 0)
 			printk(KERN_INFO "DMI %d.%d present.\n",
 			       buf[14] >> 4, buf[14] & 0xF);
_
Subject: Subject: drivers/firmware/dmi_scan.c: check dmi version when get system uuid

Patches currently in -mm which might be from zhenzhong.duan@oracle.com are

origin.patch
linux-next.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch

