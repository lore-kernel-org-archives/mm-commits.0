From: akpm@linux-foundation.org
Subject: [merged] ipc-separate-msg-allocation-from-userspace-copy.patch removed from -mm tree
Date: Tue, 07 May 2013 10:51:46 -0700
Message-ID: <20130507175146.7401F31C4F8@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:41207 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993Ab3EGRvr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:51:47 -0400
Received: by mail-gg0-f201.google.com with SMTP id k25so86500ggl.0
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:51:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: peter@hurleysoftware.com, skinsbursky@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc: separate msg allocation from userspace copy
has been removed from the -mm tree.  Its filename was
     ipc-separate-msg-allocation-from-userspace-copy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
linux-next.patch

