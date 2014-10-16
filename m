From: akpm@linux-foundation.org
Subject: + kernel-kmod-fix-use-after-free-of-the-sub_info-structure.patch
 added to -mm tree
Date: Thu, 16 Oct 2014 13:30:30 -0700
Message-ID: <54402ae6.Nrdc79V7PyrkKcdM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48300 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874AbaJPUaa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Oct 2014 16:30:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: schwidefsky@de.ibm.com, oleg@redhat.com, penguin-kernel@i-love.sakura.ne.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/kmod: fix use-after-free of the sub_info structure
has been added to the -mm tree.  Its filename is
     kernel-kmod-fix-use-after-free-of-the-sub_info-structure.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-kmod-fix-use-after-free-of-the-sub_info-structure.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-kmod-fix-use-after-free-of-the-sub_info-structure.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: kernel/kmod: fix use-after-free of the sub_info structure

Found this in the message log on a s390 system:

BUG kmalloc-192 (Not tainted): Poison overwritten
Disabling lock debugging due to kernel taint
INFO: 0x00000000684761f4-0x00000000684761f7. First byte 0xff instead of 0x6b
INFO: Allocated in call_usermodehelper_setup+0x70/0x128 age=71 cpu=2 pid=648
 __slab_alloc.isra.47.constprop.56+0x5f6/0x658
 kmem_cache_alloc_trace+0x106/0x408
 call_usermodehelper_setup+0x70/0x128
 call_usermodehelper+0x62/0x90
 cgroup_release_agent+0x178/0x1c0
 process_one_work+0x36e/0x680
 worker_thread+0x2f0/0x4f8
 kthread+0x10a/0x120
 kernel_thread_starter+0x6/0xc
 kernel_thread_starter+0x0/0xc
INFO: Freed in call_usermodehelper_exec+0x110/0x1b8 age=71 cpu=2 pid=648
 __slab_free+0x94/0x560
 kfree+0x364/0x3e0
 call_usermodehelper_exec+0x110/0x1b8
 cgroup_release_agent+0x178/0x1c0
 process_one_work+0x36e/0x680
 worker_thread+0x2f0/0x4f8
 kthread+0x10a/0x120
 kernel_thread_starter+0x6/0xc
 kernel_thread_starter+0x0/0xc

There is a use-after-free bug on the subprocess_info structure allocated
by the user mode helper.  In case do_execve() returns with an error
____call_usermodehelper() stores the error code to sub_info->retval, but
sub_info can already have been freed.

For UMH_NO_WAIT and UMH_WAIT_EXEC the call to kernel_thread() in
__call_usermodehelper() can return while do_execve() is still running. 
For UMH_NO_WAIT __call_usermodehelper() frees the sub_info structure
directly, for UMH_WAIT_EXEC the call to umh_complete() allows
call_usermodehelper_exec() to continue which then frees sub_info.

To fix this race the code needs to make sure that the call to
call_usermodehelper_freeinfo() is always done after the last store to
sub_info->retval.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kmod.c |   74 +++++++++++++++++++++---------------------------
 1 file changed, 33 insertions(+), 41 deletions(-)

diff -puN kernel/kmod.c~kernel-kmod-fix-use-after-free-of-the-sub_info-structure kernel/kmod.c
--- a/kernel/kmod.c~kernel-kmod-fix-use-after-free-of-the-sub_info-structure
+++ a/kernel/kmod.c
@@ -196,12 +196,33 @@ int __request_module(bool wait, const ch
 EXPORT_SYMBOL(__request_module);
 #endif /* CONFIG_MODULES */
 
+static void call_usermodehelper_freeinfo(struct subprocess_info *info)
+{
+	if (info->cleanup)
+		(*info->cleanup)(info);
+	kfree(info);
+}
+
+static void umh_complete(struct subprocess_info *sub_info)
+{
+	struct completion *comp = xchg(&sub_info->complete, NULL);
+	/*
+	 * See call_usermodehelper_exec(). If xchg() returns NULL
+	 * we own sub_info, the UMH_KILLABLE caller has gone away.
+	 */
+	if (comp)
+		complete(comp);
+	else
+		call_usermodehelper_freeinfo(sub_info);
+}
+
 /*
  * This is the task which runs the usermode application
  */
 static int ____call_usermodehelper(void *data)
 {
 	struct subprocess_info *sub_info = data;
+	int wait = sub_info->wait & ~UMH_KILLABLE;
 	struct cred *new;
 	int retval;
 
@@ -221,7 +242,7 @@ static int ____call_usermodehelper(void
 	retval = -ENOMEM;
 	new = prepare_kernel_cred(current);
 	if (!new)
-		goto fail;
+		goto out;
 
 	spin_lock(&umh_sysctl_lock);
 	new->cap_bset = cap_intersect(usermodehelper_bset, new->cap_bset);
@@ -233,7 +254,7 @@ static int ____call_usermodehelper(void
 		retval = sub_info->init(sub_info, new);
 		if (retval) {
 			abort_creds(new);
-			goto fail;
+			goto out;
 		}
 	}
 
@@ -242,13 +263,14 @@ static int ____call_usermodehelper(void
 	retval = do_execve(getname_kernel(sub_info->path),
 			   (const char __user *const __user *)sub_info->argv,
 			   (const char __user *const __user *)sub_info->envp);
-	if (!retval)
-		return 0;
-
-	/* Exec failed? */
-fail:
+out:
 	sub_info->retval = retval;
-	do_exit(0);
+	if (wait != UMH_WAIT_PROC)
+		/* For UMH_WAIT_PROC wait_for_helper calls umh_complete */
+		umh_complete(sub_info);
+	if (retval)
+		do_exit(0);
+	return 0;
 }
 
 static int call_helper(void *data)
@@ -258,26 +280,6 @@ static int call_helper(void *data)
 	return ____call_usermodehelper(data);
 }
 
-static void call_usermodehelper_freeinfo(struct subprocess_info *info)
-{
-	if (info->cleanup)
-		(*info->cleanup)(info);
-	kfree(info);
-}
-
-static void umh_complete(struct subprocess_info *sub_info)
-{
-	struct completion *comp = xchg(&sub_info->complete, NULL);
-	/*
-	 * See call_usermodehelper_exec(). If xchg() returns NULL
-	 * we own sub_info, the UMH_KILLABLE caller has gone away.
-	 */
-	if (comp)
-		complete(comp);
-	else
-		call_usermodehelper_freeinfo(sub_info);
-}
-
 /* Keventd can't block, but this (a child) can. */
 static int wait_for_helper(void *data)
 {
@@ -336,18 +338,8 @@ static void __call_usermodehelper(struct
 		kmod_thread_locker = NULL;
 	}
 
-	switch (wait) {
-	case UMH_NO_WAIT:
-		call_usermodehelper_freeinfo(sub_info);
-		break;
-
-	case UMH_WAIT_PROC:
-		if (pid > 0)
-			break;
-		/* FALLTHROUGH */
-	case UMH_WAIT_EXEC:
-		if (pid < 0)
-			sub_info->retval = pid;
+	if (pid < 0) {
+		sub_info->retval = pid;
 		umh_complete(sub_info);
 	}
 }
@@ -588,7 +580,7 @@ int call_usermodehelper_exec(struct subp
 		goto out;
 	}
 
-	sub_info->complete = &done;
+	sub_info->complete = (wait == UMH_NO_WAIT) ? NULL : &done;
 	sub_info->wait = wait;
 
 	queue_work(khelper_wq, &sub_info->work);
_

Patches currently in -mm which might be from schwidefsky@de.ibm.com are

origin.patch
kernel-kmod-fix-use-after-free-of-the-sub_info-structure.patch
linux-next.patch

