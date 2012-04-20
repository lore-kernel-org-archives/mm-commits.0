From: akpm@linux-foundation.org
Subject: + c-r-ipc-message-queue-receive-cleanup-fix.patch added to -mm tree
Date: Fri, 20 Apr 2012 15:03:25 -0700
Message-ID: <20120420220325.E7F2EA0172@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:63373 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755960Ab2DTWD2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Apr 2012 18:03:28 -0400
Received: by wejx9 with SMTP id x9so479334wej.1
        for <mm-commits@vger.kernel.org>; Fri, 20 Apr 2012 15:03:27 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dan.carpenter@oracle.com, gorcunov@openvz.org, skinsbursky@parallels.com


The patch titled
     Subject: c/r: ipc: uninitialized variable in compat_do_msg_fill()
has been added to the -mm tree.  Its filename is
     c-r-ipc-message-queue-receive-cleanup-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: c/r: ipc: uninitialized variable in compat_do_msg_fill()

We never initialize "msgp".  It's unfortunate that GCC doesn't warn
about this.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/compat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN ipc/compat.c~c-r-ipc-message-queue-receive-cleanup-fix ipc/compat.c
--- a/ipc/compat.c~c-r-ipc-message-queue-receive-cleanup-fix
+++ a/ipc/compat.c
@@ -336,7 +336,7 @@ long compat_sys_msgsnd(int first, int se
 
 long compat_do_msg_fill(void __user *dest, struct msg_msg *msg, size_t bufsz)
 {
-	struct compat_msgbuf __user *msgp;
+	struct compat_msgbuf __user *msgp = dest;
 	size_t msgsz;
 
 	if (put_user(msg->m_type, &msgp->mtype))
_
Subject: Subject: c/r: ipc: uninitialized variable in compat_do_msg_fill()

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
linux-next.patch
debugobjects-fill_pool-returns-void-now.patch
fsnotify-remove-unused-parameter-from-send_to_group.patch
drivers-leds-leds-lp5521c-fix-lp5521_read-error-handling.patch
hpfs-remove-printk-macro.patch
c-r-ipc-message-queue-receive-cleanup-fix.patch

