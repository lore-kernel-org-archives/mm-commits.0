From: akpm@linux-foundation.org
Subject: [merged] ipc-dont-allocate-a-copy-larger-than-max.patch removed from -mm tree
Date: Mon, 11 Mar 2013 13:16:30 -0700
Message-ID: <20130311201630.641125A41E9@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:50753 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020Ab3CKUQb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Mar 2013 16:16:31 -0400
Received: by mail-ye0-f201.google.com with SMTP id m12so423282yen.0
        for <mm-commits@vger.kernel.org>; Mon, 11 Mar 2013 13:16:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: peter@hurleysoftware.com, skinsbursky@parallels.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc: don't allocate a copy larger than max
has been removed from the -mm tree.  Its filename was
     ipc-dont-allocate-a-copy-larger-than-max.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Peter Hurley <peter@hurleysoftware.com>
Subject: ipc: don't allocate a copy larger than max

When MSG_COPY is set, a duplicate message must be allocated for the copy
before locking the queue.  However, the copy could not be larger than was
sent which is limited to msg_ctlmax.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
Acked-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN ipc/msg.c~ipc-dont-allocate-a-copy-larger-than-max ipc/msg.c
--- a/ipc/msg.c~ipc-dont-allocate-a-copy-larger-than-max
+++ a/ipc/msg.c
@@ -820,15 +820,17 @@ long do_msgrcv(int msqid, void __user *b
 	struct msg_msg *copy = NULL;
 	unsigned long copy_number = 0;
 
+	ns = current->nsproxy->ipc_ns;
+
 	if (msqid < 0 || (long) bufsz < 0)
 		return -EINVAL;
 	if (msgflg & MSG_COPY) {
-		copy = prepare_copy(buf, bufsz, msgflg, &msgtyp, &copy_number);
+		copy = prepare_copy(buf, min_t(size_t, bufsz, ns->msg_ctlmax),
+				    msgflg, &msgtyp, &copy_number);
 		if (IS_ERR(copy))
 			return PTR_ERR(copy);
 	}
 	mode = convert_mode(&msgtyp, msgflg);
-	ns = current->nsproxy->ipc_ns;
 
 	msq = msg_lock_check(ns, msqid);
 	if (IS_ERR(msq)) {
_

Patches currently in -mm which might be from peter@hurleysoftware.com are

origin.patch
linux-next.patch
ipc-clamp-with-min.patch
ipc-separate-msg-allocation-from-userspace-copy.patch
ipc-tighten-msg-copy-loops.patch
ipc-set-efault-as-default-error-in-load_msg.patch
ipc-remove-msg-handling-from-queue-scan.patch
ipc-implement-msg_copy-as-a-new-receive-mode.patch
ipc-simplify-msg-list-search.patch
ipc-refactor-msg-list-search-into-separate-function.patch

