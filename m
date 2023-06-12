Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70C01C7EE2F
	for <mm-commits@archiver.kernel.org>; Mon, 12 Jun 2023 17:17:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231127AbjFLRRC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Jun 2023 13:17:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235408AbjFLRQ4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jun 2023 13:16:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5E0D10EA
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 10:16:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5296860AFA
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 17:16:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A93E2C433D2;
        Mon, 12 Jun 2023 17:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686590209;
        bh=3S3baPvCNe5DcIDD3JtlpjBdXoIyU5gITYLSfkb3tHY=;
        h=Date:To:From:Subject:From;
        b=xW+xaVc8rXf3kN4ETH21IrvSjLW/DM+Jo9QfDb7CmwNWAfIRZmXe5spmfwRYvNTpz
         m/gikI2jeDFeSRQrlrvyDzNIpmtMfpNbmXfCuDdPbNhoYqyWuMeCHatqOME9Qyifvq
         lyQkuf6enenLaB+bASXFnuv5m1egLTwbSDr+JI14=
Date:   Mon, 12 Jun 2023 10:16:48 -0700
To:     mm-commits@vger.kernel.org, mcgrof@kernel.org,
        keescook@chromium.org, ebiederm@xmission.com,
        chenhuacai@loongson.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked] kthread-unify-kernel_thread-and-user_mode_thread.patch removed from -mm tree
Message-Id: <20230612171649.A93E2C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kthread: Unify kernel_thread() and user_mode_thread()
has been removed from the -mm tree.  Its filename was
     kthread-unify-kernel_thread-and-user_mode_thread.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Huacai Chen <chenhuacai@loongson.cn>
Subject: kthread: Unify kernel_thread() and user_mode_thread()
Date: Sat, 3 Jun 2023 09:53:02 +0800

Commit 343f4c49f2438d8 ("kthread: Don't allocate kthread_struct for init
and umh") introduces a new function user_mode_thread() for init and umh.

init and umh are different from typical kernel threads since the don't
need a "kthread" struct and they will finally become user processes by
calling kernel_execve(), but on the other hand, they are also different
from typical user mode threads (they have no "mm" structs at creation
time, which is traditionally used to distinguish a user thread and a
kernel thread).

So I think it is reasonable to treat init and umh as "special kernel
threads". Then let's unify the kernel_thread() and user_mode_thread()
to kernel_thread() again, and add a new 'user' parameter for init and
umh.

This also makes code simpler.

Link: https://lkml.kernel.org/r/20230603015302.1768127-1-chenhuacai@loongson.cn
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched/task.h |    3 +--
 init/main.c                |    4 ++--
 kernel/fork.c              |   20 ++------------------
 kernel/kthread.c           |    2 +-
 kernel/umh.c               |    6 +++---
 5 files changed, 9 insertions(+), 26 deletions(-)

--- a/include/linux/sched/task.h~kthread-unify-kernel_thread-and-user_mode_thread
+++ a/include/linux/sched/task.h
@@ -98,8 +98,7 @@ struct task_struct *copy_process(struct
 struct task_struct *create_io_thread(int (*fn)(void *), void *arg, int node);
 struct task_struct *fork_idle(int);
 extern pid_t kernel_thread(int (*fn)(void *), void *arg, const char *name,
-			    unsigned long flags);
-extern pid_t user_mode_thread(int (*fn)(void *), void *arg, unsigned long flags);
+			    unsigned long flags, bool user);
 extern long kernel_wait4(pid_t, int __user *, int, struct rusage *);
 int kernel_wait(pid_t pid, int *stat);
 
--- a/init/main.c~kthread-unify-kernel_thread-and-user_mode_thread
+++ a/init/main.c
@@ -690,7 +690,7 @@ noinline void __ref __noreturn rest_init
 	 * the init task will end up wanting to create kthreads, which, if
 	 * we schedule it before we create kthreadd, will OOPS.
 	 */
-	pid = user_mode_thread(kernel_init, NULL, CLONE_FS);
+	pid = kernel_thread(kernel_init, NULL, NULL, CLONE_FS, true);
 	/*
 	 * Pin init on the boot CPU. Task migration is not properly working
 	 * until sched_init_smp() has been run. It will set the allowed
@@ -703,7 +703,7 @@ noinline void __ref __noreturn rest_init
 	rcu_read_unlock();
 
 	numa_default_policy();
-	pid = kernel_thread(kthreadd, NULL, NULL, CLONE_FS | CLONE_FILES);
+	pid = kernel_thread(kthreadd, NULL, NULL, CLONE_FS | CLONE_FILES, false);
 	rcu_read_lock();
 	kthreadd_task = find_task_by_pid_ns(pid, &init_pid_ns);
 	rcu_read_unlock();
--- a/kernel/fork.c~kthread-unify-kernel_thread-and-user_mode_thread
+++ a/kernel/fork.c
@@ -2961,7 +2961,7 @@ pid_t kernel_clone(struct kernel_clone_a
  * Create a kernel thread.
  */
 pid_t kernel_thread(int (*fn)(void *), void *arg, const char *name,
-		    unsigned long flags)
+		    unsigned long flags, bool user)
 {
 	struct kernel_clone_args args = {
 		.flags		= ((lower_32_bits(flags) | CLONE_VM |
@@ -2970,23 +2970,7 @@ pid_t kernel_thread(int (*fn)(void *), v
 		.fn		= fn,
 		.fn_arg		= arg,
 		.name		= name,
-		.kthread	= 1,
-	};
-
-	return kernel_clone(&args);
-}
-
-/*
- * Create a user mode thread.
- */
-pid_t user_mode_thread(int (*fn)(void *), void *arg, unsigned long flags)
-{
-	struct kernel_clone_args args = {
-		.flags		= ((lower_32_bits(flags) | CLONE_VM |
-				    CLONE_UNTRACED) & ~CSIGNAL),
-		.exit_signal	= (lower_32_bits(flags) & CSIGNAL),
-		.fn		= fn,
-		.fn_arg		= arg,
+		.kthread	= !user,
 	};
 
 	return kernel_clone(&args);
--- a/kernel/kthread.c~kthread-unify-kernel_thread-and-user_mode_thread
+++ a/kernel/kthread.c
@@ -400,7 +400,7 @@ static void create_kthread(struct kthrea
 #endif
 	/* We want our own signal handler (we take no signals by default). */
 	pid = kernel_thread(kthread, create, create->full_name,
-			    CLONE_FS | CLONE_FILES | SIGCHLD);
+			    CLONE_FS | CLONE_FILES | SIGCHLD, false);
 	if (pid < 0) {
 		/* Release the structure when caller killed by a fatal signal. */
 		struct completion *done = xchg(&create->done, NULL);
--- a/kernel/umh.c~kthread-unify-kernel_thread-and-user_mode_thread
+++ a/kernel/umh.c
@@ -130,7 +130,7 @@ static void call_usermodehelper_exec_syn
 
 	/* If SIGCLD is ignored do_wait won't populate the status. */
 	kernel_sigaction(SIGCHLD, SIG_DFL);
-	pid = user_mode_thread(call_usermodehelper_exec_async, sub_info, SIGCHLD);
+	pid = kernel_thread(call_usermodehelper_exec_async, sub_info, NULL, SIGCHLD, true);
 	if (pid < 0)
 		sub_info->retval = pid;
 	else
@@ -169,8 +169,8 @@ static void call_usermodehelper_exec_wor
 		 * want to pollute current->children, and we need a parent
 		 * that always ignores SIGCHLD to ensure auto-reaping.
 		 */
-		pid = user_mode_thread(call_usermodehelper_exec_async, sub_info,
-				       CLONE_PARENT | SIGCHLD);
+		pid = kernel_thread(call_usermodehelper_exec_async, sub_info,
+				       NULL, CLONE_PARENT | SIGCHLD, true);
 		if (pid < 0) {
 			sub_info->retval = pid;
 			umh_complete(sub_info);
_

Patches currently in -mm which might be from chenhuacai@loongson.cn are


