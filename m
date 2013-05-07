From: akpm@linux-foundation.org
Subject: [merged] ipc-refactor-msg-list-search-into-separate-function.patch removed from -mm tree
Date: Tue, 07 May 2013 10:52:04 -0700
Message-ID: <20130507175204.73A7A31C4FC@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:43651 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756434Ab3EGRwF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:52:05 -0400
Received: by mail-qe0-f74.google.com with SMTP id 1so86535qec.1
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:52:04 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: peter@hurleysoftware.com, fengguang.wu@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc: refactor msg list search into separate function
has been removed from the -mm tree.  Its filename was
     ipc-refactor-msg-list-search-into-separate-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Peter Hurley <peter@hurleysoftware.com>
Subject: ipc: refactor msg list search into separate function

[fengguang.wu@intel.com: find_msg can be static]
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c |   46 +++++++++++++++++++++++++---------------------
 1 file changed, 25 insertions(+), 21 deletions(-)

diff -puN ipc/msg.c~ipc-refactor-msg-list-search-into-separate-function ipc/msg.c
--- a/ipc/msg.c~ipc-refactor-msg-list-search-into-separate-function
+++ a/ipc/msg.c
@@ -807,6 +807,30 @@ static inline void free_copy(struct msg_
 }
 #endif
 
+static struct msg_msg *find_msg(struct msg_queue *msq, long *msgtyp, int mode)
+{
+	struct msg_msg *msg;
+	long count = 0;
+
+	list_for_each_entry(msg, &msq->q_messages, m_list) {
+		if (testmsg(msg, *msgtyp, mode) &&
+		    !security_msg_queue_msgrcv(msq, msg, current,
+					       *msgtyp, mode)) {
+			if (mode == SEARCH_LESSEQUAL && msg->m_type != 1) {
+				*msgtyp = msg->m_type - 1;
+			} else if (mode == SEARCH_NUMBER) {
+				if (*msgtyp == count)
+					return msg;
+			} else
+				return msg;
+			count++;
+		}
+	}
+
+	return ERR_PTR(-EAGAIN);
+}
+
+
 long do_msgrcv(int msqid, void __user *buf, size_t bufsz, long msgtyp,
 	       int msgflg,
 	       long (*msg_handler)(void __user *, struct msg_msg *, size_t))
@@ -835,33 +859,13 @@ long do_msgrcv(int msqid, void __user *b
 
 	for (;;) {
 		struct msg_receiver msr_d;
-		struct msg_msg *walk_msg;
-		long msg_counter = 0;
 
 		msg = ERR_PTR(-EACCES);
 		if (ipcperms(ns, &msq->q_perm, S_IRUGO))
 			goto out_unlock;
 
-		msg = ERR_PTR(-EAGAIN);
-		list_for_each_entry(walk_msg, &msq->q_messages, m_list) {
+		msg = find_msg(msq, &msgtyp, mode);
 
-			if (testmsg(walk_msg, msgtyp, mode) &&
-			    !security_msg_queue_msgrcv(msq, walk_msg, current,
-						       msgtyp, mode)) {
