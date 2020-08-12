Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04E2BC433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:03:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D789020774
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266222;
	bh=tAJ4odK4PHhFBXVXW76EIFWbM6Oi66228xFZwTVBonY=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=VOO4aXDSUtc+j2i5L7fLDE9y3o9RxrRsrXnFFuslaTqjEHRB7kC4xHmkRJ/rxzY6J
	 7MVcdnKCjkYhzBAk3m+tGzmKXCu+oDC7BxLIv3XJOUhkUYRAYsz8pxme7MMrHqP24X
	 Lpv5tJRH0EA+X0tqkuk1V4U7pAdXuEu0kquABX+s=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbgHLVDm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:03:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:54288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726583AbgHLVDm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:03:42 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BF2820B1F;
        Wed, 12 Aug 2020 21:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266221;
        bh=tAJ4odK4PHhFBXVXW76EIFWbM6Oi66228xFZwTVBonY=;
        h=Date:From:To:Subject:From;
        b=SRc/1KMZ7qBpFM7B0MnZl10qiPp83r65rY3tn/x5BCHba4HgEArSW5PGP393OMber
         A+XkqoZu8YKtz3S//KdU+ivPyjzXXO4bnD9EDizfjaRCbYxeDxid3290Co0UAKO0y5
         ocOfLS6GZ5gFXgjmxWOMWhKcosEkB+7dHpkjYUxU=
Date:   Wed, 12 Aug 2020 14:03:41 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, ebiederm@xmission.com, hch@lst.de,
        mcgrof@kernel.org, mm-commits@vger.kernel.org
Subject:  [merged] kernel-add-a-kernel_wait-helper.patch removed
 from -mm tree
Message-ID: <20200812210341.zeGoF4O6o%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel: add a kernel_wait helper
has been removed from the -mm tree.  Its filename was
     kernel-add-a-kernel_wait-helper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: kernel: add a kernel_wait helper

Add a helper that waits for a pid and stores the status in the passed in
kernel pointer.  Use it to fix the usage of kernel_wait4 in
call_usermodehelper_exec_sync that only happens to work due to the
implicit set_fs(KERNEL_DS) for kernel threads.

Link: http://lkml.kernel.org/r/20200721130449.5008-1-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched/task.h |    1 +
 kernel/exit.c              |   16 ++++++++++++++++
 kernel/umh.c               |   29 ++++-------------------------
 3 files changed, 21 insertions(+), 25 deletions(-)

--- a/include/linux/sched/task.h~kernel-add-a-kernel_wait-helper
+++ a/include/linux/sched/task.h
@@ -88,6 +88,7 @@ struct task_struct *fork_idle(int);
 struct mm_struct *copy_init_mm(void);
 extern pid_t kernel_thread(int (*fn)(void *), void *arg, unsigned long flags);
 extern long kernel_wait4(pid_t, int __user *, int, struct rusage *);
+int kernel_wait(pid_t pid, int *stat);
 
 extern void free_task(struct task_struct *tsk);
 
--- a/kernel/exit.c~kernel-add-a-kernel_wait-helper
+++ a/kernel/exit.c
@@ -1626,6 +1626,22 @@ long kernel_wait4(pid_t upid, int __user
 	return ret;
 }
 
+int kernel_wait(pid_t pid, int *stat)
+{
+	struct wait_opts wo = {
+		.wo_type	= PIDTYPE_PID,
+		.wo_pid		= find_get_pid(pid),
+		.wo_flags	= WEXITED,
+	};
+	int ret;
+
+	ret = do_wait(&wo);
+	if (ret > 0 && wo.wo_stat)
+		*stat = wo.wo_stat;
+	put_pid(wo.wo_pid);
+	return ret;
+}
+
 SYSCALL_DEFINE4(wait4, pid_t, upid, int __user *, stat_addr,
 		int, options, struct rusage __user *, ru)
 {
--- a/kernel/umh.c~kernel-add-a-kernel_wait-helper
+++ a/kernel/umh.c
@@ -119,37 +119,16 @@ static void call_usermodehelper_exec_syn
 {
 	pid_t pid;
 
-	/* If SIGCLD is ignored kernel_wait4 won't populate the status. */
+	/* If SIGCLD is ignored do_wait won't populate the status. */
 	kernel_sigaction(SIGCHLD, SIG_DFL);
 	pid = kernel_thread(call_usermodehelper_exec_async, sub_info, SIGCHLD);
-	if (pid < 0) {
+	if (pid < 0)
 		sub_info->retval = pid;
-	} else {
-		int ret = -ECHILD;
-		/*
-		 * Normally it is bogus to call wait4() from in-kernel because
-		 * wait4() wants to write the exit code to a userspace address.
-		 * But call_usermodehelper_exec_sync() always runs as kernel
-		 * thread (workqueue) and put_user() to a kernel address works
-		 * OK for kernel threads, due to their having an mm_segment_t
-		 * which spans the entire address space.
-		 *
-		 * Thus the __user pointer cast is valid here.
-		 */
-		kernel_wait4(pid, (int __user *)&ret, 0, NULL);
-
-		/*
-		 * If ret is 0, either call_usermodehelper_exec_async failed and
-		 * the real error code is already in sub_info->retval or
-		 * sub_info->retval is 0 anyway, so don't mess with it then.
-		 */
-		if (ret)
-			sub_info->retval = ret;
-	}
+	else
+		kernel_wait(pid, &sub_info->retval);
 
 	/* Restore default kernel sig handler */
 	kernel_sigaction(SIGCHLD, SIG_IGN);
-
 	umh_complete(sub_info);
 }
 
_

Patches currently in -mm which might be from hch@lst.de are


