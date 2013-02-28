From: akpm@linux-foundation.org
Subject: + ipc-simplify-msg-list-search.patch added to -mm tree
Date: Thu, 28 Feb 2013 15:47:37 -0800
Message-ID: <20130228234738.38BE531C0A0@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:45092 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094Ab3B1Xrj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 18:47:39 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so272171vcd.3
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 15:47:38 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: peter@hurleysoftware.com, skinsbursky@parallels.com


The patch titled
     Subject: ipc: simplify msg list search
has been added to the -mm tree.  Its filename is
     ipc-simplify-msg-list-search.patch

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
@@ -837,7 +837,7 @@ long do_msgrcv(int msqid, void __user *b
 
 	for (;;) {
 		struct msg_receiver msr_d;
-		struct list_head *tmp;
+		struct msg_msg *walk_msg;
 		long msg_counter = 0;
 
 		msg = ERR_PTR(-EACCES);
@@ -845,11 +845,8 @@ long do_msgrcv(int msqid, void __user *b
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
@@ -865,7 +862,6 @@ long do_msgrcv(int msqid, void __user *b
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

