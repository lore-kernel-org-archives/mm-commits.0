From: akpm@linux-foundation.org
Subject: + hptiop-avoid-buffer-overflow-when-returning-sense-data.patch added to -mm tree
Date: Mon, 15 Oct 2007 00:42:31 -0700
Message-ID: <200710150742.l9F7gVvr023636@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41542 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751975AbXJOHmu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 03:42:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linux@highpoint-tech.com, James.Bottomley@steeleye.com, stable@kernel.org


The patch titled
     hptiop: avoid buffer overflow when returning sense data
has been added to the -mm tree.  Its filename is
     hptiop-avoid-buffer-overflow-when-returning-sense-data.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: hptiop: avoid buffer overflow when returning sense data
From: HighPoint Linux Team <linux@highpoint-tech.com>

avoid buffer overflow when returning sense data.

With current adapter firmware the driver is working but future firmware
updates may return sense data larger than 96 bytes, causing overflow on
scp->sense_buffer and a kernel crash.

This fix should be backported to earlier kernels.

Signed-off-by: HighPoint Linux Team <linux@highpoint-tech.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/hptiop.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/hptiop.c~hptiop-avoid-buffer-overflow-when-returning-sense-data drivers/scsi/hptiop.c
--- a/drivers/scsi/hptiop.c~hptiop-avoid-buffer-overflow-when-returning-sense-data
+++ a/drivers/scsi/hptiop.c
@@ -375,8 +375,9 @@ static void hptiop_host_request_callback
 		scp->result = SAM_STAT_CHECK_CONDITION;
 		memset(&scp->sense_buffer,
 				0, sizeof(scp->sense_buffer));
-		memcpy(&scp->sense_buffer,
-			&req->sg_list, le32_to_cpu(req->dataxfer_length));
+		memcpy(&scp->sense_buffer, &req->sg_list,
+				min(sizeof(scp->sense_buffer),
+					le32_to_cpu(req->dataxfer_length)));
 		break;
 
 	default:
_

Patches currently in -mm which might be from linux@highpoint-tech.com are

git-scsi-misc.patch
hptiop-avoid-buffer-overflow-when-returning-sense-data.patch
