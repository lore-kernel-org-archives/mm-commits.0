From: akpm@linux-foundation.org
Subject: + hpsa-suppress-messages-due-to-unsupport-scsi-report_luns.patch added to -mm tree
Date: Tue, 08 Dec 2009 14:04:18 -0800
Message-ID: <200912082204.nB8M4IaG027717@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48021 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966509AbZLHWEr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Dec 2009 17:04:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: scameron@beardog.cce.hp.com, James.Bottomley@HansenPartnership.com, achiang@hp.com, jens.axboe@oracle.com, mikem@beardog.cce.hp.com


The patch titled
     hpsa: suppress messages due to unsupport SCSI REPORT_LUNS
has been added to the -mm tree.  Its filename is
     hpsa-suppress-messages-due-to-unsupport-scsi-report_luns.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hpsa: suppress messages due to unsupport SCSI REPORT_LUNS
From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Cc: Mike Miller <mikem@beardog.cce.hp.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Alex Chiang <achiang@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/hpsa.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN drivers/scsi/hpsa.c~hpsa-suppress-messages-due-to-unsupport-scsi-report_luns drivers/scsi/hpsa.c
--- a/drivers/scsi/hpsa.c~hpsa-suppress-messages-due-to-unsupport-scsi-report_luns
+++ a/drivers/scsi/hpsa.c
@@ -964,6 +964,13 @@ static void complete_scsi_command(struct
 				break;
 			}
 			if (sense_key == ILLEGAL_REQUEST) {
+				/*
+				 * SCSI REPORT_LUNS is commonly unsupported on
+				 * Smart Array.  Suppress noisy complaint.
+				 */
+				if (cp->Request.CDB[0] == REPORT_LUNS)
+					break;
+
 				/* If ASC/ASCQ indicate Logical Unit
 				 * Not Supported condition,
 				 */
_

Patches currently in -mm which might be from scameron@beardog.cce.hp.com are

origin.patch
scsi-add-hpsa-driver-for-hp-smart-array-controllers.patch
hpsa-use-msleep-instead-of-schedule_timeout.patch
hpsa-use-msleep-instead-of-schedule_timeout-fix.patch
hpsa-rename-too-generic-variable-names.patch
hpsa-return-scsi_mlqueue_host_busy-on-command-allocation-failure.patch
hpsa-fix-incorrect-scsi-status-reporting.patch
hpsa-suppress-messages-due-to-unsupport-scsi-report_luns.patch

