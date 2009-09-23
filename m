From: akpm@linux-foundation.org
Subject: [merged] kmod-fix-race-in-usermodehelper-code.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:52:22 -0700
Message-ID: <200909231952.n8NJqMg1028975@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34238 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751693AbZIWTxG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 15:53:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nhorman@tuxdriver.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     kmod: fix race in usermodehelper code
has been removed from the -mm tree.  Its filename was
     kmod-fix-race-in-usermodehelper-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kmod: fix race in usermodehelper code
From: Neil Horman <nhorman@tuxdriver.com>

The user mode helper code has a race in it.  call_usermodehelper_exec()
takes an allocated subprocess_info structure, which it passes to a
workqueue, and then passes it to a kernel thread which it creates, after
which it calls complete to signal to the caller of
call_usermodehelper_exec() that it can free the subprocess_info struct.

But since we use that structure in the created thread, we can't call
complete from __call_usermodehelper(), which is where we create the kernel
thread.  We need to call complete() from within the kernel thread and then
not use subprocess_info afterward in the case of UMH_WAIT_EXEC.  Tested
successfully by me.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kmod.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff -puN kernel/kmod.c~kmod-fix-race-in-usermodehelper-code kernel/kmod.c
--- a/kernel/kmod.c~kmod-fix-race-in-usermodehelper-code
+++ a/kernel/kmod.c
@@ -143,6 +143,7 @@ struct subprocess_info {
 static int ____call_usermodehelper(void *data)
 {
 	struct subprocess_info *sub_info = data;
+	enum umh_wait wait = sub_info->wait;
 	int retval;
 
 	BUG_ON(atomic_read(&sub_info->cred->usage) != 1);
@@ -184,10 +185,14 @@ static int ____call_usermodehelper(void 
 	 */
 	set_user_nice(current, 0);
 
+	if (wait == UMH_WAIT_EXEC)
+		complete(sub_info->complete);
+
 	retval = kernel_execve(sub_info->path, sub_info->argv, sub_info->envp);
 
 	/* Exec failed? */
-	sub_info->retval = retval;
+	if (wait != UMH_WAIT_EXEC)
+		sub_info->retval = retval;
 	do_exit(0);
 }
 
@@ -266,16 +271,14 @@ static void __call_usermodehelper(struct
 
 	switch (wait) {
 	case UMH_NO_WAIT:
+	case UMH_WAIT_EXEC:
 		break;
 
 	case UMH_WAIT_PROC:
 		if (pid > 0)
 			break;
 		sub_info->retval = pid;
-		/* FALLTHROUGH */
