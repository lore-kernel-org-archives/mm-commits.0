From: akpm@linux-foundation.org
Subject: - scsi-qla4xxx-ql4_isrc-unchangelogged-patch.patch removed from -mm tree
Date: Sat, 23 Feb 2008 12:23:56 -0800
Message-ID: <200802232023.m1NKNu0g013587@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:50442 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761627AbYBWU2n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 15:28:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david.somayajulu@qlogic.com, James.Bottomley@HansenPartnership.com, andrew.vasquez@qlogic.com, mm-commits@vger.kernel.org


The patch titled
     scsi/qla4xxx/ql4_isr.c: unchangelogged patch
has been removed from the -mm tree.  Its filename was
     scsi-qla4xxx-ql4_isrc-unchangelogged-patch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scsi/qla4xxx/ql4_isr.c: unchangelogged patch
From: "David Somayajulu" <david.somayajulu@qlogic.com>

Signed-off-by: David C Somayajulu <david.somayajulu@qlogic.com>
Cc: "Andrew Vasquez" <andrew.vasquez@qlogic.com>
Cc: "James Bottomley" <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/qla4xxx/ql4_isr.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/scsi/qla4xxx/ql4_isr.c~scsi-qla4xxx-ql4_isrc-unchangelogged-patch drivers/scsi/qla4xxx/ql4_isr.c
--- a/drivers/scsi/qla4xxx/ql4_isr.c~scsi-qla4xxx-ql4_isrc-unchangelogged-patch
+++ a/drivers/scsi/qla4xxx/ql4_isr.c
@@ -100,8 +100,7 @@ static void qla4xxx_status_entry(struct 
 
 		if (sts_entry->iscsiFlags &ISCSI_FLAG_RESIDUAL_UNDER) {
 			scsi_set_resid(cmd, residual);
-			if (!scsi_status && ((scsi_bufflen(cmd) - residual) <
-				cmd->underflow)) {
+			if ((scsi_bufflen(cmd) - residual) < cmd->underflow) {
 
 				cmd->result = DID_ERROR << 16;
 
_

Patches currently in -mm which might be from david.somayajulu@qlogic.com are

git-scsi-rc-fixes.patch
