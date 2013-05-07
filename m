From: akpm@linux-foundation.org
Subject: [merged] ipc-simplify-msg-list-search.patch removed from -mm tree
Date: Tue, 07 May 2013 10:52:01 -0700
Message-ID: <20130507175201.7183F31C4FD@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:59871 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756434Ab3EGRwD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:52:03 -0400
Received: by mail-gh0-f201.google.com with SMTP id r14so74712ghr.4
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:52:01 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: peter@hurleysoftware.com, skinsbursky@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc: simplify msg list search
has been removed from the -mm tree.  Its filename was
     ipc-simplify-msg-list-search.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Peter Hurley <peter@hurleysoftware.com>
Subject: ipc: simplify msg list search

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
Acked-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff -puN ipc/msg.c~ipc-simplify-msg-list-search ipc/msg.c
--- a/ipc/msg.c~ipc-simplify-msg-list-search
+++ a/ipc/msg.c
@@ -835,7 +835,7 @@ long do_msgrcv(int msqid, void __user *b
 
 	for (;;) {
 		struct msg_receiver msr_d;
-		struct list_head *tmp;
+		struct msg_msg *walk_msg;
 		long msg_counter = 0;
 
 		msg = ERR_PTR(-EACCES);
@@ -843,11 +843,8 @@ long do_msgrcv(int msqid, void __user *b
 			goto out_unlock;
 
 		msg = ERR_PTR(-EAGAIN);
-		tmp = msq->q_messages.next;
-		while (tmp != &msq->q_messages) {
-			struct msg_msg *walk_msg;
+		list_for_each_entry(walk_msg, &msq->q_messages, m_list) {
 
-			walk_msg = list_entry(tmp, struct msg_msg, m_list);
 			if (testmsg(walk_msg, msgtyp, mode) &&
 			    !security_msg_queue_msgrcv(msq, walk_msg, current,
 						       msgtyp, mode)) {
@@ -864,7 +861,6 @@ long do_msgrcv(int msqid, void __user *b
 					break;
 				msg_counter++;
 			}
-			tmp = tmp->next;
 		}
 		if (!IS_ERR(msg)) {
 			/*
_

Patches currently in -mm which might be from peter@hurleysoftware.com are

origin.patch
linux-next.patch

