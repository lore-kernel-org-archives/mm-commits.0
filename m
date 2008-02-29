From: akpm@linux-foundation.org
Subject: - scsi-fix-cd-burning-regression.patch removed from -mm tree
Date: Fri, 29 Feb 2008 00:58:46 -0800
Message-ID: <200802290908.m1T985QK014813@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:46009 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754262AbYB2JIT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Feb 2008 04:08:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: efault@gmx.de, James.Bottomley@HansenPartnership.com, htejun@gmail.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     scsi: fix CD burning regression
has been removed from the -mm tree.  Its filename was
     scsi-fix-cd-burning-regression.patch

This patch was dropped because it had testing failures

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scsi: fix CD burning regression
From: Mike Galbraith <efault@gmx.de>

Fix CD burning regression introduced by
6b00769fe1502b4ad97bb327ef7ac971b208bfb5.  raw_data_len must be updated to
reflect residual data upon IO completion because it is used by
blk_complete_sghdr_rq() to set hdr->resid which eventually becomes visible to
userland.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/scsi_lib.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/scsi_lib.c~scsi-fix-cd-burning-regression drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c~scsi-fix-cd-burning-regression
+++ a/drivers/scsi/scsi_lib.c
@@ -871,7 +871,7 @@ void scsi_io_completion(struct scsi_cmnd
 			scsi_end_bidi_request(cmd);
 			return;
 		}
-		req->data_len = scsi_get_resid(cmd);
+		req->data_len = req->raw_data_len = scsi_get_resid(cmd);
 	}
 
 	BUG_ON(blk_bidi_rq(req)); /* bidi not support for !blk_pc_request yet */
_

Patches currently in -mm which might be from efault@gmx.de are

block-fix-residual-byte-count-handling.patch
scsi-fix-cd-burning-regression.patch

