From: akpm@linux-foundation.org
Subject: [merged] gru-fix-handling-of-mesq-failures.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:48:42 -0700
Message-ID: <200906182248.n5IMmgYf007814@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57923 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753133AbZFRWvP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:51:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steiner@sgi.com, mm-commits@vger.kernel.org


The patch titled
     gru: fix handling of mesq failures
has been removed from the -mm tree.  Its filename was
     gru-fix-handling-of-mesq-failures.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gru: fix handling of mesq failures
From: Jack Steiner <steiner@sgi.com>

Fix endcase in handling GRU message queue failures due to NACKs of PUT
requests.  Must ensure that the "present" bits are cleared before
resending the message.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grukservices.c |   33 ++++++++++++++++++--------
 1 file changed, 24 insertions(+), 9 deletions(-)

diff -puN drivers/misc/sgi-gru/grukservices.c~gru-fix-handling-of-mesq-failures drivers/misc/sgi-gru/grukservices.c
--- a/drivers/misc/sgi-gru/grukservices.c~gru-fix-handling-of-mesq-failures
+++ a/drivers/misc/sgi-gru/grukservices.c
@@ -503,6 +503,29 @@ static void send_message_queue_interrupt
 				mqd->interrupt_vector);
 }
 
+/*
+ * Handle a PUT failure. Note: if message was a 2-line message, one of the
+ * lines might have successfully have been written. Before sending the
+ * message, "present" must be cleared in BOTH lines to prevent the receiver
+ * from prematurely seeing the full message.
+ */
+static int send_message_put_nacked(void *cb, struct gru_message_queue_desc *mqd,
+			void *mesg, int lines)
+{
+	unsigned long m;
+
+	m = mqd->mq_gpa + (gru_get_amo_value_head(cb) << 6);
+	if (lines == 2) {
+		gru_vset(cb, m, 0, XTYPE_CL, lines, 1, IMA);
+		if (gru_wait(cb) != CBS_IDLE)
+			return MQE_UNEXPECTED_CB_ERR;
+	}
+	gru_vstore(cb, m, gru_get_tri(mesg), XTYPE_CL, lines, 1, IMA);
+	if (gru_wait(cb) != CBS_IDLE)
+		return MQE_UNEXPECTED_CB_ERR;
+	send_message_queue_interrupt(mqd);
+	return MQE_OK;
+}
 
 /*
  * Handle a gru_mesq failure. Some of these failures are software recoverable
@@ -512,7 +535,6 @@ static int send_message_failure(void *cb
 				void *mesg, int lines)
 {
 	int substatus, ret = 0;
-	unsigned long m;
 
 	substatus = gru_get_cb_message_queue_substatus(cb);
 	switch (substatus) {
@@ -534,14 +556,7 @@ static int send_message_failure(void *cb
 		break;
 	case CBSS_PUT_NACKED:
 		STAT(mesq_send_put_nacked);
-		m = mqd->mq_gpa + (gru_get_amo_value_head(cb) << 6);
-		gru_vstore(cb, m, gru_get_tri(mesg), XTYPE_CL, lines, 1, IMA);
-		if (gru_wait(cb) == CBS_IDLE) {
-			ret = MQE_OK;
-			send_message_queue_interrupt(mqd);
-		} else {
-			ret = MQE_UNEXPECTED_CB_ERR;
-		}
+		ret = send_message_put_nacked(cb, mqd, mesg, lines);
 		break;
 	default:
 		BUG();
_

Patches currently in -mm which might be from steiner@sgi.com are

origin.patch

