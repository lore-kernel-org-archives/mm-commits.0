From: akpm@linux-foundation.org
Subject: + gru-fix-handling-of-mesq-failures.patch added to -mm tree
Date: Thu, 09 Apr 2009 15:37:36 -0700
Message-ID: <200904092237.n39MbaMY032558@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38849 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752907AbZDIWjE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Apr 2009 18:39:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: steiner@sgi.com


The patch titled
     gru: fix handling of mesq failures
has been added to the -mm tree.  Its filename is
     gru-fix-handling-of-mesq-failures.patch

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

gru-bug-fixes-for-gru-exception-handling.patch
gru-dump-chiplet-state.patch
gru-dynamic-allocation-of-kernel-contexts.patch
gru-change-context-load-and-unload.patch
gru-support-cch_allocate-for-kernel-threads.patch
gru-change-resource-assignment-for-kernel-threads.patch
gru-support-contexts-with-zero-dsrs-or-cbrs.patch
gru-fix-handling-of-mesq-failures.patch
gru-check-context-state-on-reload.patch
gru-support-instruction-completion-interrupts.patch
gru-support-for-asynchronous-gru-instructions.patch
gru-update-gru-kernel-self-tests.patch
gru-update-to-rev-09-of-gru-spec.patch

