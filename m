From: akpm@linux-foundation.org
Subject: [merged] ipc-set-efault-as-default-error-in-load_msg.patch removed from -mm tree
Date: Tue, 07 May 2013 10:51:52 -0700
Message-ID: <20130507175152.73B3C31C4F8@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:48826 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993Ab3EGRvx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:51:53 -0400
Received: by mail-yh0-f73.google.com with SMTP id a41so86546yho.0
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:51:52 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: peter@hurleysoftware.com, skinsbursky@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc: set EFAULT as default error in load_msg()
has been removed from the -mm tree.  Its filename was
     ipc-set-efault-as-default-error-in-load_msg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
linux-next.patch

