From: akpm@linux-foundation.org
Subject: [merged] ipc-bugfix-for-msgrcv-with-msgtyp-0.patch removed from
 -mm tree
Date: Thu, 29 Aug 2013 12:42:59 -0700
Message-ID: <521fa443.2sMQdsBy4ZUgPxyT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36281 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756218Ab3H2TnA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Aug 2013 15:43:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, torvalds@linux-foundation.org, stable@vger.kernel.org, peter@hurleysoftware.com, sss@secomea.dk

Subject: [merged] ipc-bugfix-for-msgrcv-with-msgtyp-0.patch removed from -mm tree
To: sss@secomea.dk,peter@hurleysoftware.com,stable@vger.kernel.org,torvalds@linux-foundation.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 29 Aug 2013 12:42:59 -0700


The patch titled
     Subject: IPC: bugfix for msgrcv with msgtyp < 0
has been removed from the -mm tree.  Its filename was
     ipc-bugfix-for-msgrcv-with-msgtyp-0.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

This regression was introduced by

commit daaf74cf0867e3042090d56d10b194d6265b4684
Author:     Peter Hurley <peter@hurleysoftware.com>
AuthorDate: Tue Apr 30 19:15:04 2013 -0700
Commit:     Linus Torvalds <torvalds@linux-foundation.org>
CommitDate: Wed May 1 08:12:57 2013 -0700

    ipc: refactor msg list search into separate function

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

origin.patch

