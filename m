From: akpm@linux-foundation.org
Subject: + ipc-tighten-msg-copy-loops.patch added to -mm tree
Date: Thu, 28 Feb 2013 15:47:25 -0800
Message-ID: <20130228234726.2274C31C0A0@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:54664 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846Ab3B1Xr1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 18:47:27 -0500
Received: by mail-yh0-f74.google.com with SMTP id z6so273827yhz.5
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 15:47:26 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: peter@hurleysoftware.com, skinsbursky@parallels.com


The patch titled
     Subject: ipc: tighten msg copy loops
has been added to the -mm tree.  Its filename is
     ipc-tighten-msg-copy-loops.patch

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

