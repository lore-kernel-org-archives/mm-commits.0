Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54847C4332F
	for <mm-commits@archiver.kernel.org>; Mon,  6 Nov 2023 18:12:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231915AbjKFSME (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Nov 2023 13:12:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232348AbjKFSMD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Nov 2023 13:12:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7E8AD4C
        for <mm-commits@vger.kernel.org>; Mon,  6 Nov 2023 10:12:00 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A6DEC433C8;
        Mon,  6 Nov 2023 18:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699294320;
        bh=HtN1uCbqPSDprX0MNOCmOIXnxsC/2bWlVqN1gTucvPU=;
        h=Date:To:From:Subject:From;
        b=rzSEg+jSn/iORaSKvbukcQdbya0OMb03G7oBpYyYFo2xdd4bIqOpZaYDx7Em7StKT
         d0EZQoC22uayKuY5vwHHYKcHnEr8E77JFn+EkmwfgvW5vfm7eKbMv07oUlrCsaZJ5U
         0+xZ9ZEKkhdidoYU6DlTrjXYnTQqScwXTxFYvRcw=
Date:   Mon, 06 Nov 2023 10:11:59 -0800
To:     mm-commits@vger.kernel.org, ebiederm@xmission.com,
        brauner@kernel.org, oleg@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + introduce-for_other_threadsp-t.patch added to mm-nonmm-unstable branch
Message-Id: <20231106181200.3A6DEC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: introduce for_other_threads(p, t)
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     introduce-for_other_threadsp-t.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/introduce-for_other_threadsp-t.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: introduce for_other_threads(p, t)
Date: Mon, 30 Oct 2023 16:57:10 +0100

Cosmetic, but imho it makes the usage look more clear and simple, the new
helper doesn't require to initialize "t".

After this change while_each_thread() has only 3 users, and it is only
used in the do/while loops.

Link: https://lkml.kernel.org/r/20231030155710.GA9095@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Christian Brauner <brauner@kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c                    |    3 +--
 include/linux/sched/signal.h |    3 +++
 kernel/signal.c              |   11 ++++-------
 3 files changed, 8 insertions(+), 9 deletions(-)

--- a/fs/exec.c~introduce-for_other_threadsp-t
+++ a/fs/exec.c
@@ -1578,11 +1578,10 @@ static void check_unsafe_exec(struct lin
 	 * will be able to manipulate the current directory, etc.
 	 * It would be nice to force an unshare instead...
 	 */
-	t = p;
 	n_fs = 1;
 	spin_lock(&p->fs->lock);
 	rcu_read_lock();
-	while_each_thread(p, t) {
+	for_other_threads(p, t) {
 		if (t->fs == p->fs)
 			n_fs++;
 	}
--- a/include/linux/sched/signal.h~introduce-for_other_threadsp-t
+++ a/include/linux/sched/signal.h
@@ -646,6 +646,9 @@ extern bool current_is_single_threaded(v
 #define while_each_thread(g, t) \
 	while ((t = next_thread(t)) != g)
 
+#define for_other_threads(p, t)	\
+	for (t = p; (t = next_thread(t)) != p; )
+
 #define __for_each_thread(signal, t)	\
 	list_for_each_entry_rcu(t, &(signal)->thread_head, thread_node, \
 		lockdep_is_held(&tasklist_lock))
--- a/kernel/signal.c~introduce-for_other_threadsp-t
+++ a/kernel/signal.c
@@ -1376,12 +1376,12 @@ int force_sig_info(struct kernel_siginfo
  */
 int zap_other_threads(struct task_struct *p)
 {
-	struct task_struct *t = p;
+	struct task_struct *t;
 	int count = 0;
 
 	p->signal->group_stop_count = 0;
 
-	while_each_thread(p, t) {
+	for_other_threads(p, t) {
 		task_clear_jobctl_pending(t, JOBCTL_PENDING_MASK);
 		/* Don't require de_thread to wait for the vhost_worker */
 		if ((t->flags & (PF_IO_WORKER | PF_USER_WORKER)) != PF_USER_WORKER)
@@ -2465,12 +2465,10 @@ static bool do_signal_stop(int signr)
 			sig->group_exit_code = signr;
 
 		sig->group_stop_count = 0;
-
 		if (task_set_jobctl_pending(current, signr | gstop))
 			sig->group_stop_count++;
 
-		t = current;
-		while_each_thread(current, t) {
+		for_other_threads(current, t) {
 			/*
 			 * Setting state to TASK_STOPPED for a group
 			 * stop is always done with the siglock held,
@@ -2966,8 +2964,7 @@ static void retarget_shared_pending(stru
 	if (sigisemptyset(&retarget))
 		return;
 
-	t = tsk;
-	while_each_thread(tsk, t) {
+	for_other_threads(tsk, t) {
 		if (t->flags & PF_EXITING)
 			continue;
 
_

Patches currently in -mm which might be from oleg@redhat.com are

introduce-for_other_threadsp-t.patch

