From: akpm@linux-foundation.org
Subject: + qla2xxx-fix-null-ptr-dereference-in-fail-path-in-queue-create-code.patch added to -mm tree
Date: Tue, 29 Sep 2009 13:47:27 -0700
Message-ID: <200909292047.n8TKlRvR024507@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58541 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752350AbZI2Ur1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Sep 2009 16:47:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anirban.chakraborty@qlogic.com, James.Bottomley@HansenPartnership.com, andrew.vasquez@qlogic.com, jirislaby@gmail.com


The patch titled
     qla2xxx: fix Null ptr dereference in fail path in queue create code
has been added to the -mm tree.  Its filename is
     qla2xxx-fix-null-ptr-dereference-in-fail-path-in-queue-create-code.patch

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
Subject: qla2xxx: fix Null ptr dereference in fail path in queue create code
From: Anirban Chakraborty <anirban.chakraborty@qlogic.com>

Current code jumps to fail path in queue create functions and there it
invokes the queue free call with a (NULL) pointer to the queue which could
not be allocated.  Fix it by returning ENOMEM directly without invoking
the queue free call.

Signed-off-by Jiri Slaby <jirislaby@gmail.com>
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

qla2xxx-fix-null-ptr-dereference-in-fail-path-in-queue-create-code.patch

