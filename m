From: akpm@linux-foundation.org
Subject: [merged] qla2xxx-fix-null-ptr-dereference-in-fail-path-in-queue-create-code.patch removed from -mm tree
Date: Mon, 05 Oct 2009 11:40:06 -0700
Message-ID: <200910051840.n95Ie6K3020561@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52621 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754594AbZJESku (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Oct 2009 14:40:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anirban.chakraborty@qlogic.com, James.Bottomley@HansenPartnership.com, andrew.vasquez@qlogic.com, jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     qla2xxx: fix Null ptr dereference in fail path in queue create code
has been removed from the -mm tree.  Its filename was
     qla2xxx-fix-null-ptr-dereference-in-fail-path-in-queue-create-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: qla2xxx: fix Null ptr dereference in fail path in queue create code
From: Anirban Chakraborty <anirban.chakraborty@qlogic.com>

Current code jumps to fail path in queue create functions and there it
invokes the queue free call with a (NULL) pointer to the queue which could
not be allocated.  Fix it by returning ENOMEM directly without invoking
the queue free call.

Report-by Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/qla2xxx/qla_mid.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/qla2xxx/qla_mid.c~qla2xxx-fix-null-ptr-dereference-in-fail-path-in-queue-create-code drivers/scsi/qla2xxx/qla_mid.c
--- a/drivers/scsi/qla2xxx/qla_mid.c~qla2xxx-fix-null-ptr-dereference-in-fail-path-in-queue-create-code
+++ a/drivers/scsi/qla2xxx/qla_mid.c
@@ -568,7 +568,7 @@ qla25xx_create_req_que(struct qla_hw_dat
 	if (req == NULL) {
 		qla_printk(KERN_WARNING, ha, "could not allocate memory"
 			"for request que\n");
-		goto que_failed;
+		return 0;
 	}
 
 	req->length = REQUEST_ENTRY_CNT_24XX;
@@ -659,7 +659,7 @@ qla25xx_create_rsp_que(struct qla_hw_dat
 	if (rsp == NULL) {
 		qla_printk(KERN_WARNING, ha, "could not allocate memory for"
 				" response que\n");
-		goto que_failed;
+		return 0;
 	}
 
 	rsp->length = RESPONSE_ENTRY_CNT_MQ;
_

Patches currently in -mm which might be from anirban.chakraborty@qlogic.com are

linux-next.patch

