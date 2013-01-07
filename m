From: akpm@linux-foundation.org
Subject: [merged] ipc-add-more-comments-to-message-copying-related-code.patch removed from -mm tree
Date: Mon, 07 Jan 2013 11:25:33 -0800
Message-ID: <20130107192533.BB607100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:44718 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755207Ab3AGTZf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2013 14:25:35 -0500
Received: by mail-vb0-f73.google.com with SMTP id l1so2114775vba.0
        for <mm-commits@vger.kernel.org>; Mon, 07 Jan 2013 11:25:34 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: skinsbursky@parallels.com, ebiederm@xmission.com, jmorris@namei.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc: add more comments to message copying related code
has been removed from the -mm tree.  Its filename was
     ipc-add-more-comments-to-message-copying-related-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
Subject: ipc: add more comments to message copying related code

Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN ipc/msg.c~ipc-add-more-comments-to-message-copying-related-code ipc/msg.c
--- a/ipc/msg.c~ipc-add-more-comments-to-message-copying-related-code
+++ a/ipc/msg.c
@@ -770,6 +770,10 @@ static long do_msg_fill(void __user *des
 }
 
 #ifdef CONFIG_CHECKPOINT_RESTORE
+/*
+ * This function creates new kernel message structure, large enough to store
+ * bufsz message bytes.
+ */
 static inline struct msg_msg *prepare_copy(void __user *buf, size_t bufsz,
 					   int msgflg, long *msgtyp,
 					   unsigned long *copy_number)
@@ -881,6 +885,10 @@ long do_msgrcv(int msqid, void __user *b
 				msg = ERR_PTR(-E2BIG);
 				goto out_unlock;
 			}
+			/*
+			 * If we are copying, then do not unlink message and do
+			 * not update queue parameters.
+			 */
 			if (msgflg & MSG_COPY)
 				goto out_unlock;
 			list_del(&msg->m_list);
_

Patches currently in -mm which might be from skinsbursky@parallels.com are

origin.patch

