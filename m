From: akpm@linux-foundation.org
Subject: [merged] ipc-remove-msg-handling-from-queue-scan.patch removed from -mm tree
Date: Tue, 07 May 2013 10:51:55 -0700
Message-ID: <20130507175155.73EE35A4111@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:63862 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993Ab3EGRv4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:51:56 -0400
Received: by mail-qc0-f201.google.com with SMTP id c10so86565qcz.2
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:51:55 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: peter@hurleysoftware.com, skinsbursky@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc: remove msg handling from queue scan
has been removed from the -mm tree.  Its filename was
     ipc-remove-msg-handling-from-queue-scan.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -860,16 +860,8 @@ long do_msgrcv(int msqid, void __user *b
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
 					msg = ERR_PTR(-EAGAIN);
 				} else
 					break;
@@ -890,8 +882,10 @@ long do_msgrcv(int msqid, void __user *b
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
linux-next.patch

