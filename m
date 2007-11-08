From: akpm@linux-foundation.org
Subject: - aacraid-dont-assign-cpu_to_le32constant-to-u8.patch removed from -mm tree
Date: Thu, 08 Nov 2007 10:33:26 -0800
Message-ID: <200711081833.lA8IXQx9008551@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37721 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761837AbXKHSdj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Nov 2007 13:33:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, James.Bottomley@steeleye.com, mark_salyzyn@adaptec.com, mm-commits@vger.kernel.org


The patch titled
     aacraid: don't assign cpu_to_le32(constant) to u8
has been removed from the -mm tree.  Its filename was
     aacraid-dont-assign-cpu_to_le32constant-to-u8.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: aacraid: don't assign cpu_to_le32(constant) to u8
From: Stephen Rothwell <sfr@canb.auug.org.au>

Noticed on PowerPC allmod config build:

drivers/scsi/aacraid/commsup.c:1342: warning: large integer implicitly truncated to unsigned type
drivers/scsi/aacraid/commsup.c:1343: warning: large integer implicitly truncated to unsigned type
drivers/scsi/aacraid/commsup.c:1344: warning: large integer implicitly truncated to unsigned type

Also fix some whitespace on the changed lines.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Acked-by: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/aacraid/commsup.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/scsi/aacraid/commsup.c~aacraid-dont-assign-cpu_to_le32constant-to-u8 drivers/scsi/aacraid/commsup.c
--- a/drivers/scsi/aacraid/commsup.c~aacraid-dont-assign-cpu_to_le32constant-to-u8
+++ a/drivers/scsi/aacraid/commsup.c
@@ -1339,9 +1339,9 @@ int aac_check_health(struct aac_dev * aa
 			aif = (struct aac_aifcmd *)hw_fib->data;
 			aif->command = cpu_to_le32(AifCmdEventNotify);
 		 	aif->seqnum = cpu_to_le32(0xFFFFFFFF);
-		 	aif->data[0] = cpu_to_le32(AifEnExpEvent);
-			aif->data[1] = cpu_to_le32(AifExeFirmwarePanic);
-		 	aif->data[2] = cpu_to_le32(AifHighPriority);
+			aif->data[0] = AifEnExpEvent;
+			aif->data[1] = AifExeFirmwarePanic;
+			aif->data[2] = AifHighPriority;
 			aif->data[3] = cpu_to_le32(BlinkLED);
 
 			/*
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

origin.patch
aacraid-fix-endianness-warnings.patch
aacraid-fix-endianness-warnings-checkpatch-fixes.patch
aacraid-dont-assign-cpu_to_le32constant-to-u8.patch
