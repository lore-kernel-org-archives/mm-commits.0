From: akpm@linux-foundation.org
Subject: [merged] drivers-scsi-megaraidc-fix-sparse-warnings.patch removed from -mm tree
Date: Tue, 17 Jan 2012 13:01:15 -0800
Message-ID: <20120117210115.9E9E010004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:45426 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755118Ab2AQVBQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jan 2012 16:01:16 -0500
Received: by ggnv2 with SMTP id v2so245323ggn.1
        for <mm-commits@vger.kernel.org>; Tue, 17 Jan 2012 13:01:16 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aradford@gmail.com, Bo.Yang@lsi.com, James.Bottomley@HansenPartnership.com, megaraidlinux@lsi.com, rdunlap@xenotime.net, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/scsi/megaraid.c: fix sparse warnings
has been removed from the -mm tree.  Its filename was
     drivers-scsi-megaraidc-fix-sparse-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: adam radford <aradford@gmail.com>
Subject: drivers/scsi/megaraid.c: fix sparse warnings

The following patch for the older megaraid driver fixes some sparse
warnings.

Signed-off-by: Adam Radford <aradford@gmail.com>
Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Neela Syam Kolli <megaraidlinux@lsi.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: <Bo.Yang@lsi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/megaraid.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff -puN drivers/scsi/megaraid.c~drivers-scsi-megaraidc-fix-sparse-warnings drivers/scsi/megaraid.c
--- a/drivers/scsi/megaraid.c~drivers-scsi-megaraidc-fix-sparse-warnings
+++ a/drivers/scsi/megaraid.c
@@ -306,19 +306,22 @@ mega_query_adapter(adapter_t *adapter)
 	adapter->host->sg_tablesize = adapter->sglen;
 
 
-	/* use HP firmware and bios version encoding */
+	/* use HP firmware and bios version encoding
+	   Note: fw_version[0|1] and bios_version[0|1] were originally shifted
+	   right 8 bits making them zero. This 0 value was hardcoded to fix 
+	   sparse warnings. */
 	if (adapter->product_info.subsysvid == HP_SUBSYS_VID) {
 		sprintf (adapter->fw_version, "%c%d%d.%d%d",
 			 adapter->product_info.fw_version[2],
-			 adapter->product_info.fw_version[1] >> 8,
+			 0,
 			 adapter->product_info.fw_version[1] & 0x0f,
-			 adapter->product_info.fw_version[0] >> 8,
+			 0,
 			 adapter->product_info.fw_version[0] & 0x0f);
 		sprintf (adapter->bios_version, "%c%d%d.%d%d",
 			 adapter->product_info.bios_version[2],
-			 adapter->product_info.bios_version[1] >> 8,
+			 0,
 			 adapter->product_info.bios_version[1] & 0x0f,
-			 adapter->product_info.bios_version[0] >> 8,
+			 0,
 			 adapter->product_info.bios_version[0] & 0x0f);
 	} else {
 		memcpy(adapter->fw_version,
_

Patches currently in -mm which might be from aradford@gmail.com are

linux-next.patch

