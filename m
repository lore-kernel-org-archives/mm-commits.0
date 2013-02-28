From: akpm@linux-foundation.org
Subject: + ipc-separate-msg-allocation-from-userspace-copy.patch added to -mm tree
Date: Thu, 28 Feb 2013 15:47:22 -0800
Message-ID: <20130228234723.10DBE5A410E@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:40195 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175Ab3B1XrY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 18:47:24 -0500
Received: by mail-qe0-f73.google.com with SMTP id a11so272405qen.4
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 15:47:23 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: peter@hurleysoftware.com, skinsbursky@parallels.com


The patch titled
     Subject: ipc: separate msg allocation from userspace copy
has been added to the -mm tree.  Its filename is
     ipc-separate-msg-allocation-from-userspace-copy.patch

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
Subject: ipc: separate msg allocation from userspace copy

Separating msg allocation enables single-block vmalloc
allocation instead.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
Acked-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msgutil.c |   52 +++++++++++++++++++++++++++++++++++-------------
 1 file changed, 38 insertions(+), 14 deletions(-)

diff -puN ipc/msgutil.c~ipc-separate-msg-allocation-from-userspace-copy ipc/msgutil.c
--- a/ipc/msgutil.c~ipc-separate-msg-allocation-from-userspace-copy
+++ a/ipc/msgutil.c
@@ -44,21 +44,54 @@ struct msg_msgseg {
 #define DATALEN_MSG	(int)(PAGE_SIZE-sizeof(struct msg_msg))
 #define DATALEN_SEG	(int)(PAGE_SIZE-sizeof(struct msg_msgseg))
 
-struct msg_msg *load_msg(const void __user *src, int len)
+
+static struct msg_msg *alloc_msg(int len)
 {
 	struct msg_msg *msg;
 	struct msg_msgseg **pseg;
-	int err;
 	int alen;
 
 	alen = min(len, DATALEN_MSG);
 	msg = kmalloc(sizeof(*msg) + alen, GFP_KERNEL);
 	if (msg == NULL)
-		return ERR_PTR(-ENOMEM);
+		return NULL;
 
 	msg->next = NULL;
 	msg->security = NULL;
 
+	len -= alen;
+	pseg = &msg->next;
+	while (len > 0) {
+		struct msg_msgseg *seg;
+		alen = min(len, DATALEN_SEG);
+		seg = kmalloc(sizeof(*seg) + alen, GFP_KERNEL);
+		if (seg == NULL)
+			goto out_err;
+		*pseg = seg;
+		seg->next = NULL;
+		pseg = &seg->next;
+		len -= alen;
+	}
+
+	return msg;
+
+out_err:
+	free_msg(msg);
+	return NULL;
+}
+
+struct msg_msg *load_msg(const void __user *src, int len)
+{
+	struct msg_msg *msg;
+	struct msg_msgseg *seg;
+	int err;
+	int alen;
+
+	msg = alloc_msg(len);
+	if (msg == NULL)
+		return ERR_PTR(-ENOMEM);
+
+	alen = min(len, DATALEN_MSG);
 	if (copy_from_user(msg + 1, src, alen)) {
 		err = -EFAULT;
 		goto out_err;
@@ -66,23 +99,14 @@ struct msg_msg *load_msg(const void __us
 
 	len -= alen;
 	src = ((char __user *)src) + alen;
-	pseg = &msg->next;
+	seg = msg->next;
 	while (len > 0) {
-		struct msg_msgseg *seg;
 		alen = min(len, DATALEN_SEG);
-		seg = kmalloc(sizeof(*seg) + alen,
-						 GFP_KERNEL);
-		if (seg == NULL) {
-			err = -ENOMEM;
-			goto out_err;
-		}
-		*pseg = seg;
-		seg->next = NULL;
 		if (copy_from_user(seg + 1, src, alen)) {
 			err = -EFAULT;
 			goto out_err;
 		}
-		pseg = &seg->next;
+		seg = seg->next;
 		len -= alen;
 		src = ((char __user *)src) + alen;
 	}
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

