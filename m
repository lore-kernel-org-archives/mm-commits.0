From: akpm@linux-foundation.org
Subject: + ipc-implement-msg_copy-as-a-new-receive-mode.patch added to -mm tree
Date: Thu, 28 Feb 2013 15:47:34 -0800
Message-ID: <20130228234735.316A05A410E@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:47317 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094Ab3B1Xrg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 18:47:36 -0500
Received: by mail-vc0-f201.google.com with SMTP id n11so272143vch.4
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 15:47:35 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: peter@hurleysoftware.com, skinsbursky@parallels.com


The patch titled
     Subject: ipc: implement MSG_COPY as a new receive mode
has been added to the -mm tree.  Its filename is
     ipc-implement-msg_copy-as-a-new-receive-mode.patch

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
Subject: ipc: implement MSG_COPY as a new receive mode

Teach the helper routines about MSG_COPY so that msgtyp is preserved as
the message number to copy.

The security functions affected by this change were audited and no
additional changes are necessary.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
Acked-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c |   23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff -puN ipc/msg.c~ipc-implement-msg_copy-as-a-new-receive-mode ipc/msg.c
--- a/ipc/msg.c~ipc-implement-msg_copy-as-a-new-receive-mode
+++ a/ipc/msg.c
@@ -66,6 +66,7 @@ struct msg_sender {
 #define SEARCH_EQUAL		2
 #define SEARCH_NOTEQUAL		3
 #define SEARCH_LESSEQUAL	4
+#define SEARCH_NUMBER		5
 
 #define msg_ids(ns)	((ns)->ids[IPC_MSG_IDS])
 
@@ -583,6 +584,7 @@ static int testmsg(struct msg_msg *msg, 
 	switch(mode)
 	{
 		case SEARCH_ANY:
+		case SEARCH_NUMBER:
 			return 1;
 		case SEARCH_LESSEQUAL:
 			if (msg->m_type <=type)
@@ -738,6 +740,8 @@ SYSCALL_DEFINE4(msgsnd, int, msqid, stru
 
 static inline int convert_mode(long *msgtyp, int msgflg)
 {
+	if (msgflg & MSG_COPY)
+		return SEARCH_NUMBER;
 	/*
 	 *  find message of correct type.
 	 *  msgtyp = 0 => get first.
@@ -774,14 +778,10 @@ static long do_msg_fill(void __user *des
  * This function creates new kernel message structure, large enough to store
  * bufsz message bytes.
  */
-static inline struct msg_msg *prepare_copy(void __user *buf, size_t bufsz,
-					   int msgflg, long *msgtyp,
-					   unsigned long *copy_number)
+static inline struct msg_msg *prepare_copy(void __user *buf, size_t bufsz)
 {
 	struct msg_msg *copy;
 
-	*copy_number = *msgtyp;
-	*msgtyp = 0;
 	/*
 	 * Create dummy message to copy real message to.
 	 */
@@ -797,9 +797,7 @@ static inline void free_copy(struct msg_
 		free_msg(copy);
 }
 #else
-static inline struct msg_msg *prepare_copy(void __user *buf, size_t bufsz,
-					   int msgflg, long *msgtyp,
-					   unsigned long *copy_number)
+static inline struct msg_msg *prepare_copy(void __user *buf, size_t bufsz)
 {
 	return ERR_PTR(-ENOSYS);
 }
@@ -818,18 +816,17 @@ long do_msgrcv(int msqid, void __user *b
 	int mode;
 	struct ipc_namespace *ns;
 	struct msg_msg *copy = NULL;
-	unsigned long copy_number = 0;
 
 	ns = current->nsproxy->ipc_ns;
 
 	if (msqid < 0 || (long) bufsz < 0)
 		return -EINVAL;
 	if (msgflg & MSG_COPY) {
-		copy = prepare_copy(buf, min_t(size_t, bufsz, ns->msg_ctlmax),
-				    msgflg, &msgtyp, &copy_number);
+		copy = prepare_copy(buf, min_t(size_t, bufsz, ns->msg_ctlmax));
 		if (IS_ERR(copy))
 			return PTR_ERR(copy);
 	}
+
 	mode = convert_mode(&msgtyp, msgflg);
 
 	msq = msg_lock_check(ns, msqid);
@@ -861,8 +858,8 @@ long do_msgrcv(int msqid, void __user *b
 				if (mode == SEARCH_LESSEQUAL &&
 						walk_msg->m_type != 1) {
 					msgtyp = walk_msg->m_type - 1;
-				} else if (msgflg & MSG_COPY) {
-					if (copy_number == msg_counter)
+				} else if (mode == SEARCH_NUMBER) {
+					if (msgtyp == msg_counter)
 						break;
 				} else
 					break;
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

