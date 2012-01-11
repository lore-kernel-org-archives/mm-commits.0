From: akpm@linux-foundation.org
Subject: [to-be-updated] drivers-scsi-megaraidc-fix-sparse-warnings.patch removed from -mm tree
Date: Wed, 11 Jan 2012 14:28:18 -0800
Message-ID: <20120111222818.E937A100056@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:38231 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934130Ab2AKW2U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 17:28:20 -0500
Received: by ghrr15 with SMTP id r15so144324ghr.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 14:28:19 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdunlap@xenotime.net, Bo.Yang@lsi.com, James.Bottomley@HansenPartnership.com, aradford@gmail.com, megaraidlinux@lsi.com, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/scsi/megaraid.c: fix sparse warnings
has been removed from the -mm tree.  Its filename was
     drivers-scsi-megaraidc-fix-sparse-warnings.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Randy Dunlap <rdunlap@xenotime.net>
Subject: drivers/scsi/megaraid.c: fix sparse warnings

Fix sparse warnings of right shift bigger than source value size:

drivers/scsi/megaraid.c:311:65: warning: right shift by bigger than source value
drivers/scsi/megaraid.c:313:65: warning: right shift by bigger than source value
drivers/scsi/megaraid.c:317:67: warning: right shift by bigger than source value
drivers/scsi/megaraid.c:319:67: warning: right shift by bigger than source value

Patch suggestion from email by Al Viro:

"Since both are claimed to be strings, I really suspect that this >> 8 is
misspelled >> 4 and they have a character followed by pair of two-digit
packed decimals in there..."

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Neela Syam Kolli <megaraidlinux@lsi.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/megaraid.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/scsi/megaraid.c~drivers-scsi-megaraidc-fix-sparse-warnings drivers/scsi/megaraid.c
--- a/drivers/scsi/megaraid.c~drivers-scsi-megaraidc-fix-sparse-warnings
+++ a/drivers/scsi/megaraid.c
@@ -310,15 +310,15 @@ mega_query_adapter(adapter_t *adapter)
 	if (adapter->product_info.subsysvid == HP_SUBSYS_VID) {
 		sprintf (adapter->fw_version, "%c%d%d.%d%d",
 			 adapter->product_info.fw_version[2],
-			 adapter->product_info.fw_version[1] >> 8,
+			 adapter->product_info.fw_version[1] >> 4,
 			 adapter->product_info.fw_version[1] & 0x0f,
-			 adapter->product_info.fw_version[0] >> 8,
+			 adapter->product_info.fw_version[0] >> 4,
 			 adapter->product_info.fw_version[0] & 0x0f);
 		sprintf (adapter->bios_version, "%c%d%d.%d%d",
 			 adapter->product_info.bios_version[2],
-			 adapter->product_info.bios_version[1] >> 8,
+			 adapter->product_info.bios_version[1] >> 4,
 			 adapter->product_info.bios_version[1] & 0x0f,
-			 adapter->product_info.bios_version[0] >> 8,
+			 adapter->product_info.bios_version[0] >> 4,
 			 adapter->product_info.bios_version[0] & 0x0f);
 	} else {
 		memcpy(adapter->fw_version,
_

Patches currently in -mm which might be from rdunlap@xenotime.net are

origin.patch
linux-next.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-fix.patch

