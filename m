From: akpm@linux-foundation.org
Subject: + ipc-remove-msg-handling-from-queue-scan.patch added to -mm tree
Date: Thu, 28 Feb 2013 15:47:32 -0800
Message-ID: <20130228234732.647D85A410E@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:57533 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094Ab3B1Xrd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 18:47:33 -0500
Received: by mail-ye0-f201.google.com with SMTP id m12so272368yen.2
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 15:47:32 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: peter@hurleysoftware.com, skinsbursky@parallels.com


The patch titled
     Subject: ipc: remove msg handling from queue scan
has been added to the -mm tree.  Its filename is
     ipc-remove-msg-handling-from-queue-scan.patch

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
Subject: ipc: remove msg handling from queue scan

In preparation for refactoring the queue scan into a separate
function, relocate msg copying.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
Acked-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff -puN ipc/msg.c~ipc-remove-msg-handling-from-queue-scan ipc/msg.c
--- a/ipc/msg.c~ipc-remove-msg-handling-from-queue-scan
+++ a/ipc/msg.c
@@ -862,16 +862,8 @@ long do_msgrcv(int msqid, void __user *b
 						walk_msg->m_type != 1) {
 					msgtyp = walk_msg->m_type - 1;
 				} else if (msgflg & MSG_COPY) {
-					if (copy_number == msg_counter) {
-						/*
-						 * Found requested message.
-						 * Copy it.
-						 */
-						msg = copy_msg(msg, copy);
-						if (IS_ERR(msg))
-							goto out_unlock;
+					if (copy_number == msg_counter)
 						break;
-					}
 				} else
 					break;
 				msg_counter++;
@@ -891,8 +883,10 @@ long do_msgrcv(int msqid, void __user *b
 			 * If we are copying, then do not unlink message and do
 			 * not update queue parameters.
 			 */
-			if (msgflg & MSG_COPY)
+			if (msgflg & MSG_COPY) {
+				msg = copy_msg(msg, copy);
 				goto out_unlock;
+			}
 			list_del(&msg->m_list);
 			msq->q_qnum--;
 			msq->q_rtime = get_seconds();
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

