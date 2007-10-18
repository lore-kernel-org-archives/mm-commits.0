From: akpm@linux-foundation.org
Subject: - hptiop-avoid-buffer-overflow-when-returning-sense-data.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:05:42 -0700
Message-ID: <200710180705.l9I75gli031670@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35367 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761531AbXJRHPh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:15:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@highpoint-tech.com, James.Bottomley@steeleye.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     hptiop: avoid buffer overflow when returning sense data
has been removed from the -mm tree.  Its filename was
     hptiop-avoid-buffer-overflow-when-returning-sense-data.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
git-scsi-misc.patch
