From: akpm@linux-foundation.org
Subject: [to-be-updated] c-r-ipc-message-queue-receive-cleanup-fix.patch removed from -mm tree
Date: Mon, 23 Apr 2012 13:56:11 -0700
Message-ID: <20120423205611.6B7EDA0423@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:65258 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819Ab2DWU4N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Apr 2012 16:56:13 -0400
Received: by eekc41 with SMTP id c41so589870eek.1
        for <mm-commits@vger.kernel.org>; Mon, 23 Apr 2012 13:56:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, gorcunov@openvz.org, skinsbursky@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: c/r: ipc: uninitialized variable in compat_do_msg_fill()
has been removed from the -mm tree.  Its filename was
     c-r-ipc-message-queue-receive-cleanup-fix.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
linux-next.patch
debugobjects-fill_pool-returns-void-now.patch
fsnotify-remove-unused-parameter-from-send_to_group.patch
drivers-leds-leds-lp5521c-fix-lp5521_read-error-handling.patch
hpfs-remove-printk-macro.patch

