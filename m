From: akpm@linux-foundation.org
Subject: + scsi-qla4xxx-ql4_isrc-unchangelogged-patch.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:31:55 -0800
Message-ID: <200802230732.m1N7WibN018094@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:42995 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753550AbYBWHyQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 02:54:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david.somayajulu@qlogic.com, James.Bottomley@HansenPartnership.com, andrew.vasquez@qlogic.com


The patch titled
     scsi/qla4xxx/ql4_isr.c: unchangelogged patch
has been added to the -mm tree.  Its filename is
     scsi-qla4xxx-ql4_isrc-unchangelogged-patch.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

scsi-qla4xxx-ql4_isrc-unchangelogged-patch.patch
