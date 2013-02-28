From: akpm@linux-foundation.org
Subject: + ipc-dont-allocate-a-copy-larger-than-max.patch added to -mm tree
Date: Thu, 28 Feb 2013 15:47:16 -0800
Message-ID: <20130228234717.30F2E5A410E__34061.17948839$1362095265$gmane$org@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:40673 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188Ab3B1XrS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 18:47:18 -0500
Received: by mail-ve0-f201.google.com with SMTP id 14so272048vea.4
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 15:47:17 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: peter@hurleysoftware.com, skinsbursky@parallels.com, stable@vger.kernel.org


The patch titled
     Subject: ipc: don't allocate a copy larger than max
has been added to the -mm tree.  Its filename is
     ipc-dont-allocate-a-copy-larger-than-max.patch

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

