From: akpm@linux-foundation.org
Subject: + drivers-scsi-megaraidc-fix-sparse-warnings.patch added to -mm tree
Date: Wed, 11 Jan 2012 14:30:01 -0800
Message-ID: <20120111223002.16C24200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:61579 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996Ab2AKWaF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 17:30:05 -0500
Received: by eekd41 with SMTP id d41so45902eek.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 14:30:03 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aradford@gmail.com, Bo.Yang@lsi.com, James.Bottomley@HansenPartnership.com, megaraidlinux@lsi.com, rdunlap@xenotime.net


The patch titled
     Subject: drivers/scsi/megaraid.c: fix sparse warnings
has been added to the -mm tree.  Its filename is
     drivers-scsi-megaraidc-fix-sparse-warnings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: drivers/scsi/megaraid.c: fix sparse warnings

Patches currently in -mm which might be from aradford@gmail.com are

drivers-scsi-megaraidc-fix-sparse-warnings.patch

