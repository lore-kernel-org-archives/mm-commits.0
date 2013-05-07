From: akpm@linux-foundation.org
Subject: [merged] ipc-clamp-with-min.patch removed from -mm tree
Date: Tue, 07 May 2013 10:51:43 -0700
Message-ID: <20130507175143.72C7C5A451C@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:62077 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993Ab3EGRvo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:51:44 -0400
Received: by mail-qa0-f73.google.com with SMTP id bs12so110895qab.4
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:51:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: peter@hurleysoftware.com, skinsbursky@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc: clamp with min()
has been removed from the -mm tree.  Its filename was
     ipc-clamp-with-min.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
linux-next.patch

