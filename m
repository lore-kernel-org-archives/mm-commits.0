From: akpm@linux-foundation.org
Subject: +
 usermodehelper-dont-use-clone_vfork-for-____call_usermodehelper.patch added to -mm tree
Date: Mon, 20 Oct 2014 14:14:53 -0700
Message-ID: <54457b4d.lcIK8st+sl4/nS/X%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56867 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435AbaJTVOx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Oct 2014 17:14:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: usermodehelper: don't use CLONE_VFORK for ____call_usermodehelper()
has been added to the -mm tree.  Its filename is
     usermodehelper-dont-use-clone_vfork-for-____call_usermodehelper.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/usermodehelper-dont-use-clone_vfork-for-____call_usermodehelper.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/usermodehelper-dont-use-clone_vfork-for-____call_usermodehelper.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: usermodehelper: don't use CLONE_VFORK for ____call_usermodehelper()

After "kernel/kmod: fix use-after-free of the sub_infostructure"
CLONE_VFORK in __call_usermodehelper() buys nothing, we rely on on
umh_complete() in ____call_usermodehelper() anyway.

Remove it.  This also eliminates the unnecessary sleep/wakeup in the
likely case, and this allows the next change.

While at it, kill the "int wait" locals in ____call_usermodehelper() and
__call_usermodehelper(), they can safely use sub_info->wait.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kmod.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff -puN kernel/kmod.c~usermodehelper-dont-use-clone_vfork-for-____call_usermodehelper kernel/kmod.c
--- a/kernel/kmod.c~usermodehelper-dont-use-clone_vfork-for-____call_usermodehelper
+++ a/kernel/kmod.c
@@ -223,7 +223,6 @@ static void umh_complete(struct subproce
 static int ____call_usermodehelper(void *data)
 {
 	struct subprocess_info *sub_info = data;
-	int wait = sub_info->wait & ~UMH_KILLABLE;
 	struct cred *new;
 	int retval;
 
@@ -267,7 +266,7 @@ static int ____call_usermodehelper(void
 out:
 	sub_info->retval = retval;
 	/* wait_for_helper() will call umh_complete if UHM_WAIT_PROC. */
-	if (wait != UMH_WAIT_PROC)
+	if (!(sub_info->wait & UMH_WAIT_PROC))
 		umh_complete(sub_info);
 	if (!retval)
 		return 0;
@@ -323,18 +322,13 @@ static void __call_usermodehelper(struct
 {
 	struct subprocess_info *sub_info =
 		container_of(work, struct subprocess_info, work);
-	int wait = sub_info->wait & ~UMH_KILLABLE;
 	pid_t pid;
 
-	/* CLONE_VFORK: wait until the usermode helper has execve'd
-	 * successfully We need the data structures to stay around
-	 * until that is done.  */
-	if (wait == UMH_WAIT_PROC)
+	if (sub_info->wait & UMH_WAIT_PROC)
 		pid = kernel_thread(wait_for_helper, sub_info,
 				    CLONE_FS | CLONE_FILES | SIGCHLD);
 	else {
-		pid = kernel_thread(call_helper, sub_info,
-				    CLONE_VFORK | SIGCHLD);
+		pid = kernel_thread(call_helper, sub_info, SIGCHLD);
 		/* Worker thread stopped blocking khelper thread. */
 		kmod_thread_locker = NULL;
 	}
_

Patches currently in -mm which might be from oleg@redhat.com are

kernel-kmod-fix-use-after-free-of-the-sub_info-structure.patch
kernel-kmod-fix-use-after-free-of-the-sub_info-structure-v2.patch
usermodehelper-dont-use-clone_vfork-for-____call_usermodehelper.patch
usermodehelper-kill-the-kmod_thread_locker-logic.patch
linux-next.patch

