From: akpm@linux-foundation.org
Subject: + ipc-bugfix-for-msgrcv-with-msgtyp-0.patch added to -mm tree
Date: Mon, 26 Aug 2013 13:43:29 -0700
Message-ID: <521bbdf1.UKISq8W8VfedUhHT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57711 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095Ab3HZUna (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Aug 2013 16:43:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, peter@hurleysoftware.com, sss@secomea.dk

Subject: + ipc-bugfix-for-msgrcv-with-msgtyp-0.patch added to -mm tree
To: sss@secomea.dk,peter@hurleysoftware.com,stable@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 26 Aug 2013 13:43:29 -0700


The patch titled
     Subject: IPC: bugfix for msgrcv with msgtyp < 0
has been added to the -mm tree.  Its filename is
     ipc-bugfix-for-msgrcv-with-msgtyp-0.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-bugfix-for-msgrcv-with-msgtyp-0.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-bugfix-for-msgrcv-with-msgtyp-0.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Svenning Sørensen <sss@secomea.dk>
Subject: IPC: bugfix for msgrcv with msgtyp < 0

According to 'man msgrcv': "If msgtyp is less than 0, the first message of
the lowest type that is less than or equal to the absolute value of msgtyp
shall be received."

Bug: The kernel only returns a message if its type is 1; other messages
with type < abs(msgtype) will never get returned.

Fix: After having traversed the list to find the first message with the
lowest type, we need to actually return that message.

Signed-off-by: Svenning Soerensen <sss@secomea.dk>
Reviewed-by: Peter Hurley <peter@hurleysoftware.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN ipc/msg.c~ipc-bugfix-for-msgrcv-with-msgtyp-0 ipc/msg.c
--- a/ipc/msg.c~ipc-bugfix-for-msgrcv-with-msgtyp-0
+++ a/ipc/msg.c
@@ -839,7 +839,7 @@ static inline void free_copy(struct msg_
 
 static struct msg_msg *find_msg(struct msg_queue *msq, long *msgtyp, int mode)
 {
-	struct msg_msg *msg;
+	struct msg_msg *msg, *found = NULL;
 	long count = 0;
 
 	list_for_each_entry(msg, &msq->q_messages, m_list) {
@@ -848,6 +848,7 @@ static struct msg_msg *find_msg(struct m
 					       *msgtyp, mode)) {
 			if (mode == SEARCH_LESSEQUAL && msg->m_type != 1) {
 				*msgtyp = msg->m_type - 1;
+				found = msg;
 			} else if (mode == SEARCH_NUMBER) {
 				if (*msgtyp == count)
 					return msg;
@@ -857,7 +858,7 @@ static struct msg_msg *find_msg(struct m
 		}
 	}
 
-	return ERR_PTR(-EAGAIN);
+	return found ?: ERR_PTR(-EAGAIN);
 }
 
 long do_msgrcv(int msqid, void __user *buf, size_t bufsz, long msgtyp, int msgflg,
_

Patches currently in -mm which might be from sss@secomea.dk are

ipc-bugfix-for-msgrcv-with-msgtyp-0.patch

