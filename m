From: akpm@linux-foundation.org
Subject: [folded-merged]
 kernel-kmod-fix-use-after-free-of-the-sub_info-structure-v2.patch removed
 from -mm tree
Date: Wed, 29 Oct 2014 14:46:58 -0700
Message-ID: <54516052.UTe/dKM9bpKRgKEt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52896 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755312AbaJ2Vq5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 29 Oct 2014 17:46:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: schwidefsky@de.ibm.com, oleg@redhat.com, penguin-kernel@i-love.sakura.ne.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel-kmod-fix-use-after-free-of-the-sub_info-structure-v2
has been removed from the -mm tree.  Its filename was
     kernel-kmod-fix-use-after-free-of-the-sub_info-structure-v2.patch

This patch was dropped because it was folded into kernel-kmod-fix-use-after-free-of-the-sub_info-structure.patch

------------------------------------------------------
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: kernel-kmod-fix-use-after-free-of-the-sub_info-structure-v2

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kmod.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff -puN kernel/kmod.c~kernel-kmod-fix-use-after-free-of-the-sub_info-structure-v2 kernel/kmod.c
--- a/kernel/kmod.c~kernel-kmod-fix-use-after-free-of-the-sub_info-structure-v2
+++ a/kernel/kmod.c
@@ -208,7 +208,8 @@ static void umh_complete(struct subproce
 	struct completion *comp = xchg(&sub_info->complete, NULL);
 	/*
 	 * See call_usermodehelper_exec(). If xchg() returns NULL
-	 * we own sub_info, the UMH_KILLABLE caller has gone away.
+	 * we own sub_info, the UMH_KILLABLE caller has gone away
+	 * or the caller used UMH_NO_WAIT.
 	 */
 	if (comp)
 		complete(comp);
@@ -265,12 +266,12 @@ static int ____call_usermodehelper(void
 			   (const char __user *const __user *)sub_info->envp);
 out:
 	sub_info->retval = retval;
+	/* wait_for_helper() will call umh_complete if UHM_WAIT_PROC. */
 	if (wait != UMH_WAIT_PROC)
-		/* For UMH_WAIT_PROC wait_for_helper calls umh_complete */
 		umh_complete(sub_info);
-	if (retval)
-		do_exit(0);
-	return 0;
+	if (!retval)
+		return 0;
+	do_exit(0);
 }
 
 static int call_helper(void *data)
@@ -580,6 +581,11 @@ int call_usermodehelper_exec(struct subp
 		goto out;
 	}
 
+	/*
+	 * Set the completion pointer only if there is a waiter.
+	 * This makes it possible to use umh_complete to free
+	 * the data structure in case of UMH_NO_WAIT.
+	 */
 	sub_info->complete = (wait == UMH_NO_WAIT) ? NULL : &done;
 	sub_info->wait = wait;
 
_

Patches currently in -mm which might be from schwidefsky@de.ibm.com are

kernel-kmod-fix-use-after-free-of-the-sub_info-structure.patch
usermodehelper-dont-use-clone_vfork-for-____call_usermodehelper.patch
usermodehelper-kill-the-kmod_thread_locker-logic.patch
linux-next.patch

