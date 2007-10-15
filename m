From: akpm@linux-foundation.org
Subject: + hptiop-avoid-buffer-overflow-when-returning-sense-data.patch added to -mm tree
Date: Sun, 14 Oct 2007 23:40:24 -0700
Message-ID: <200710150640.l9F6eOhc021479@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35495 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755591AbXJOGk2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 02:40:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linux@highpoint-tech.com


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

Signed-off-by: HighPoint Linux Team <linux@highpoint-tech.com>
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
