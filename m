From: akpm@linux-foundation.org
Subject: [merged]
 usermodehelper-dont-use-clone_vfork-for-____call_usermodehelper.patch
 removed from -mm tree
Date: Thu, 11 Dec 2014 11:08:04 -0800
Message-ID: <5489eb94.5OFd0YRb76LlVV80%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46055 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758579AbaLKTIF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 14:08:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: usermodehelper: don't use CLONE_VFORK for ____call_usermodehelper()
has been removed from the -mm tree.  Its filename was
     usermodehelper-dont-use-clone_vfork-for-____call_usermodehelper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
mmfs-introduce-helpers-around-the-i_mmap_mutex.patch
mm-use-new-helper-functions-around-the-i_mmap_mutex.patch
mm-convert-i_mmap_mutex-to-rwsem.patch
mm-rmap-share-the-i_mmap_rwsem.patch
uprobes-share-the-i_mmap_rwsem.patch
mm-xip-share-the-i_mmap_rwsem.patch
mm-memory-failure-share-the-i_mmap_rwsem.patch
mm-nommu-share-the-i_mmap_rwsem.patch
mm-memoryc-share-the-i_mmap_rwsem.patch
remove-unnecessary-is_valid_nodemask.patch
oom-dont-assume-that-a-coredumping-thread-will-exit-soon.patch
oom-dont-assume-that-a-coredumping-thread-will-exit-soon-v2.patch
oom-dont-assume-that-a-coredumping-thread-will-exit-soon-v2-fix.patch
oom-kill-the-insufficient-and-no-longer-needed-pt_trace_exit-check.patch
linux-next.patch
all-arches-signal-move-restart_block-to-struct-task_struct.patch

