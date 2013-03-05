From: akpm@linux-foundation.org
Subject: + dmi_scan-fix-missing-check-for-_dmi_-signature-in-smbios_present.patch added to -mm tree
Date: Tue, 05 Mar 2013 15:37:51 -0800
Message-ID: <20130305233751.D0EC531C1D8@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:49431 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970Ab3CEXhx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Mar 2013 18:37:53 -0500
Received: by mail-gg0-f201.google.com with SMTP id l2so800817ggn.4
        for <mm-commits@vger.kernel.org>; Tue, 05 Mar 2013 15:37:52 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben@decadent.org.uk, stable@vger.kernel.org, tmhikaru@gmail.com, zhenzhong.duan@oracle.com


The patch titled
     Subject: dmi_scan: fix missing check for _DMI_ signature in smbios_present()
has been added to the -mm tree.  Its filename is
     dmi_scan-fix-missing-check-for-_dmi_-signature-in-smbios_present.patch

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
Subject: dmi_scan: fix missing check for _DMI_ signature in smbios_present()

Commit 9f9c9cbb6057 ('drivers/firmware/dmi_scan.c: fetch dmi version from
SMBIOS if it exists') hoisted the check for "_DMI_" into
dmi_scan_machine(), which means that we don't bother to check for "_DMI_"
at offset 16 in an SMBIOS entry.  smbios_present() may also call
dmi_present() for an address where we found "_SM_", if it failed further
validation.

Check for "_DMI_" in smbios_present() before calling dmi_present().

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Reported-by: Tim McGrath <tmhikaru@gmail.com>
Tested-by: Tim Mcgrath <tmhikaru@gmail.com>
Cc: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/dmi_scan.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/firmware/dmi_scan.c~dmi_scan-fix-missing-check-for-_dmi_-signature-in-smbios_present drivers/firmware/dmi_scan.c
--- a/drivers/firmware/dmi_scan.c~dmi_scan-fix-missing-check-for-_dmi_-signature-in-smbios_present
+++ a/drivers/firmware/dmi_scan.c
@@ -442,7 +442,6 @@ static int __init dmi_present(const char
 static int __init smbios_present(const char __iomem *p)
 {
 	u8 buf[32];
-	int offset = 0;
 
 	memcpy_fromio(buf, p, 32);
 	if ((buf[5] < 32) && dmi_checksum(buf, buf[5])) {
@@ -461,9 +460,9 @@ static int __init smbios_present(const c
 			dmi_ver = 0x0206;
 			break;
 		}
-		offset = 16;
+		return memcmp(q + 16, "_DMI_", 5) || dmi_present(p + 16);
 	}
-	return dmi_present(buf + offset);
+	return 1;
 }
 
 void __init dmi_scan_machine(void)
_

Patches currently in -mm which might be from ben@decadent.org.uk are

linux-next.patch
dmi_scan-fix-missing-check-for-_dmi_-signature-in-smbios_present.patch
dmi_scan-refactor-dmi_scan_machine-smbiosdmi_present.patch

