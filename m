From: akpm@linux-foundation.org
Subject: + ipc-set-efault-as-default-error-in-load_msg.patch added to -mm tree
Date: Thu, 28 Feb 2013 15:47:28 -0800
Message-ID: <20130228234729.399DB5A410E@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:39649 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094Ab3B1Xra (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 18:47:30 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so272092vcd.5
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 15:47:29 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: peter@hurleysoftware.com, skinsbursky@parallels.com


The patch titled
     Subject: ipc: set EFAULT as default error in load_msg()
has been added to the -mm tree.  Its filename is
     ipc-set-efault-as-default-error-in-load_msg.patch

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
Subject: ipc: set EFAULT as default error in load_msg()

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
Acked-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msgutil.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff -puN ipc/msgutil.c~ipc-set-efault-as-default-error-in-load_msg ipc/msgutil.c
--- a/ipc/msgutil.c~ipc-set-efault-as-default-error-in-load_msg
+++ a/ipc/msgutil.c
@@ -84,7 +84,7 @@ struct msg_msg *load_msg(const void __us
 {
 	struct msg_msg *msg;
 	struct msg_msgseg *seg;
-	int err;
+	int err = -EFAULT;
 	int alen;
 
 	msg = alloc_msg(len);
@@ -92,19 +92,15 @@ struct msg_msg *load_msg(const void __us
 		return ERR_PTR(-ENOMEM);
 
 	alen = min(len, DATALEN_MSG);
-	if (copy_from_user(msg + 1, src, alen)) {
-		err = -EFAULT;
+	if (copy_from_user(msg + 1, src, alen))
 		goto out_err;
-	}
 
 	for (seg = msg->next; seg != NULL; seg = seg->next) {
 		len -= alen;
 		src = (char __user *)src + alen;
 		alen = min(len, DATALEN_SEG);
-		if (copy_from_user(seg + 1, src, alen)) {
-			err = -EFAULT;
+		if (copy_from_user(seg + 1, src, alen))
 			goto out_err;
-		}
 	}
 
 	err = security_msg_msg_alloc(msg);
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

