From: akpm@linux-foundation.org
Subject: + ipc-clamp-with-min.patch added to -mm tree
Date: Thu, 28 Feb 2013 15:47:19 -0800
Message-ID: <20130228234720.03F725A410E@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:33340 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175Ab3B1XrV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 18:47:21 -0500
Received: by mail-yh0-f73.google.com with SMTP id 28so273841yhr.4
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 15:47:20 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: peter@hurleysoftware.com, skinsbursky@parallels.com


The patch titled
     Subject: ipc: clamp with min()
has been added to the -mm tree.  Its filename is
     ipc-clamp-with-min.patch

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
Subject: ipc: clamp with min()

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
Acked-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msgutil.c |   30 ++++++++----------------------
 1 file changed, 8 insertions(+), 22 deletions(-)

diff -puN ipc/msgutil.c~ipc-clamp-with-min ipc/msgutil.c
--- a/ipc/msgutil.c~ipc-clamp-with-min
+++ a/ipc/msgutil.c
@@ -41,8 +41,8 @@ struct msg_msgseg {
 	/* the next part of the message follows immediately */
 };
 
-#define DATALEN_MSG	(PAGE_SIZE-sizeof(struct msg_msg))
-#define DATALEN_SEG	(PAGE_SIZE-sizeof(struct msg_msgseg))
+#define DATALEN_MSG	(int)(PAGE_SIZE-sizeof(struct msg_msg))
+#define DATALEN_SEG	(int)(PAGE_SIZE-sizeof(struct msg_msgseg))
 
 struct msg_msg *load_msg(const void __user *src, int len)
 {
@@ -51,10 +51,7 @@ struct msg_msg *load_msg(const void __us
 	int err;
 	int alen;
 
-	alen = len;
-	if (alen > DATALEN_MSG)
-		alen = DATALEN_MSG;
-
+	alen = min(len, DATALEN_MSG);
 	msg = kmalloc(sizeof(*msg) + alen, GFP_KERNEL);
 	if (msg == NULL)
 		return ERR_PTR(-ENOMEM);
@@ -72,9 +69,7 @@ struct msg_msg *load_msg(const void __us
 	pseg = &msg->next;
 	while (len > 0) {
 		struct msg_msgseg *seg;
-		alen = len;
-		if (alen > DATALEN_SEG)
-			alen = DATALEN_SEG;
+		alen = min(len, DATALEN_SEG);
 		seg = kmalloc(sizeof(*seg) + alen,
 						 GFP_KERNEL);
 		if (seg == NULL) {
@@ -113,19 +108,14 @@ struct msg_msg *copy_msg(struct msg_msg 
 	if (src->m_ts > dst->m_ts)
 		return ERR_PTR(-EINVAL);
 
-	alen = len;
-	if (alen > DATALEN_MSG)
-		alen = DATALEN_MSG;
-
+	alen = min(len, DATALEN_MSG);
 	memcpy(dst + 1, src + 1, alen);
 
 	len -= alen;
 	dst_pseg = dst->next;
 	src_pseg = src->next;
 	while (len > 0) {
-		alen = len;
-		if (alen > DATALEN_SEG)
-			alen = DATALEN_SEG;
+		alen = min(len, DATALEN_SEG);
 		memcpy(dst_pseg + 1, src_pseg + 1, alen);
 		dst_pseg = dst_pseg->next;
 		len -= alen;
@@ -148,9 +138,7 @@ int store_msg(void __user *dest, struct 
 	int alen;
 	struct msg_msgseg *seg;
 
-	alen = len;
-	if (alen > DATALEN_MSG)
-		alen = DATALEN_MSG;
+	alen = min(len, DATALEN_MSG);
 	if (copy_to_user(dest, msg + 1, alen))
 		return -1;
 
@@ -158,9 +146,7 @@ int store_msg(void __user *dest, struct 
 	dest = ((char __user *)dest) + alen;
 	seg = msg->next;
 	while (len > 0) {
-		alen = len;
-		if (alen > DATALEN_SEG)
-			alen = DATALEN_SEG;
+		alen = min(len, DATALEN_SEG);
 		if (copy_to_user(dest, seg + 1, alen))
 			return -1;
 		len -= alen;
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

