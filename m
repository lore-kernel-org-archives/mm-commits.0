From: akpm@linux-foundation.org
Subject: [merged] ipc-tighten-msg-copy-loops.patch removed from -mm tree
Date: Tue, 07 May 2013 10:51:49 -0700
Message-ID: <20130507175149.70D545A4111@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:39778 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993Ab3EGRvu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:51:50 -0400
Received: by mail-gh0-f202.google.com with SMTP id g24so74728ghb.1
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:51:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: peter@hurleysoftware.com, skinsbursky@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc: tighten msg copy loops
has been removed from the -mm tree.  Its filename was
     ipc-tighten-msg-copy-loops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Peter Hurley <peter@hurleysoftware.com>
Subject: ipc: tighten msg copy loops

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
Acked-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msgutil.c |   32 +++++++++++---------------------
 1 file changed, 11 insertions(+), 21 deletions(-)

diff -puN ipc/msgutil.c~ipc-tighten-msg-copy-loops ipc/msgutil.c
--- a/ipc/msgutil.c~ipc-tighten-msg-copy-loops
+++ a/ipc/msgutil.c
@@ -97,18 +97,14 @@ struct msg_msg *load_msg(const void __us
 		goto out_err;
 	}
 
-	len -= alen;
-	src = ((char __user *)src) + alen;
-	seg = msg->next;
-	while (len > 0) {
+	for (seg = msg->next; seg != NULL; seg = seg->next) {
+		len -= alen;
+		src = (char __user *)src + alen;
 		alen = min(len, DATALEN_SEG);
 		if (copy_from_user(seg + 1, src, alen)) {
 			err = -EFAULT;
 			goto out_err;
 		}
-		seg = seg->next;
-		len -= alen;
-		src = ((char __user *)src) + alen;
 	}
 
 	err = security_msg_msg_alloc(msg);
@@ -135,15 +131,13 @@ struct msg_msg *copy_msg(struct msg_msg 
 	alen = min(len, DATALEN_MSG);
 	memcpy(dst + 1, src + 1, alen);
 
-	len -= alen;
-	dst_pseg = dst->next;
-	src_pseg = src->next;
-	while (len > 0) {
+	for (dst_pseg = dst->next, src_pseg = src->next;
+	     src_pseg != NULL;
+	     dst_pseg = dst_pseg->next, src_pseg = src_pseg->next) {
+
+		len -= alen;
 		alen = min(len, DATALEN_SEG);
 		memcpy(dst_pseg + 1, src_pseg + 1, alen);
-		dst_pseg = dst_pseg->next;
-		len -= alen;
-		src_pseg = src_pseg->next;
 	}
 
 	dst->m_type = src->m_type;
@@ -166,16 +160,12 @@ int store_msg(void __user *dest, struct 
 	if (copy_to_user(dest, msg + 1, alen))
 		return -1;
 
-	len -= alen;
-	dest = ((char __user *)dest) + alen;
-	seg = msg->next;
-	while (len > 0) {
+	for (seg = msg->next; seg != NULL; seg = seg->next) {
+		len -= alen;
+		dest = (char __user *)dest + alen;
 		alen = min(len, DATALEN_SEG);
 		if (copy_to_user(dest, seg + 1, alen))
 			return -1;
-		len -= alen;
-		dest = ((char __user *)dest) + alen;
-		seg = seg->next;
 	}
 	return 0;
 }
_

Patches currently in -mm which might be from peter@hurleysoftware.com are

origin.patch
linux-next.patch

