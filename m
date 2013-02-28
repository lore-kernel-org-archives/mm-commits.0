From: akpm@linux-foundation.org
Subject: + ipc-refactor-msg-list-search-into-separate-function.patch added to -mm tree
Date: Thu, 28 Feb 2013 15:47:40 -0800
Message-ID: <20130228234741.1E6BC31C0A0@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:45060 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192Ab3B1Xrm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 18:47:42 -0500
Received: by mail-qc0-f202.google.com with SMTP id k26so46012qcs.1
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 15:47:41 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: peter@hurleysoftware.com, skinsbursky@parallels.com


The patch titled
     Subject: ipc: refactor msg list search into separate function
has been added to the -mm tree.  Its filename is
     ipc-refactor-msg-list-search-into-separate-function.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Peter Hurley <peter@hurleysoftware.com>
Subject: ipc: refactor msg list search into separate function

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
Acked-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c |   45 +++++++++++++++++++++++++--------------------
 1 file changed, 25 insertions(+), 20 deletions(-)

diff -puN ipc/msg.c~ipc-refactor-msg-list-search-into-separate-function ipc/msg.c
--- a/ipc/msg.c~ipc-refactor-msg-list-search-into-separate-function
+++ a/ipc/msg.c
@@ -807,6 +807,30 @@ static inline void free_copy(struct msg_
 }
 #endif
 
+struct msg_msg *find_msg(struct msg_queue *msq, long *msgtyp, int mode)
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
@@ -837,32 +861,13 @@ long do_msgrcv(int msqid, void __user *b
 
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
-
-				msg = walk_msg;
-				if (mode == SEARCH_LESSEQUAL &&
-						walk_msg->m_type != 1) {
-					msgtyp = walk_msg->m_type - 1;
-				} else if (mode == SEARCH_NUMBER) {
-					if (msgtyp == msg_counter)
-						break;
-				} else
-					break;
-				msg_counter++;
-			}
-		}
 		if (!IS_ERR(msg)) {
 			/*
 			 * Found a suitable message.
_

Patches currently in -mm which might be from peter@hurleysoftware.com are

origin.patch
ipc-fix-potential-oops-when-src-msg-4k-w-msg_copy.patch
ipc-dont-allocate-a-copy-larger-than-max.patch
ipc-clamp-with-min.patch
ipc-separate-msg-allocation-from-userspace-copy.patch
ipc-tighten-msg-copy-loops.patch
ipc-set-efault-as-default-error-in-load_msg.patch
ipc-remove-msg-handling-from-queue-scan.patch
ipc-implement-msg_copy-as-a-new-receive-mode.patch
ipc-simplify-msg-list-search.patch
ipc-refactor-msg-list-search-into-separate-function.patch

