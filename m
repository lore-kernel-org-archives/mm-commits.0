Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8947C433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:53:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 989EE6143B
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:53:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbhEHWyh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:54:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:42202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229662AbhEHWye (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:54:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9440F60E0B;
        Sat,  8 May 2021 22:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514410;
        bh=pHrgbWm8/1wLLNHTRpoeKdvF2dAt3+0JsLE6oTlsvQ0=;
        h=Date:From:To:Subject:From;
        b=iS6G+b6BjNg4dbmlPL0efI3PJiNJvVjukQ4mRoGDxLfIiCLiWyihnFM2UwcX4KSC3
         MDGHgKfJVHDbx6GU0a26MyB5goo6ENZ2zBZVwnefrauaQCQ8v07DiVSBUY2QJqbQHu
         eU5YbfEiyP03exh7rWF5Pvjz5LOdBZAiy7BGFsMM=
Date:   Sat, 08 May 2021 15:53:30 -0700
From:   akpm@linux-foundation.org
To:     christian@brauner.io, ebiederm@xmission.com,
        jnewsome@torproject.org, mm-commits@vger.kernel.org,
        oleg@redhat.com
Subject:  [merged]
 do_wait-make-pidtype_pid-case-o1-instead-of-on.patch removed from -mm tree
Message-ID: <20210508225330.wgfibkcpz%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: do_wait: make PIDTYPE_PID case O(1) instead of O(n)
has been removed from the -mm tree.  Its filename was
     do_wait-make-pidtype_pid-case-o1-instead-of-on.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jim Newsome <jnewsome@torproject.org>
Subject: do_wait: make PIDTYPE_PID case O(1) instead of O(n)

Add a special-case when waiting on a pid (via waitpid, waitid, wait4, etc)
to avoid doing an O(n) scan of children and tracees, and instead do an
O(1) lookup.  This improves performance when waiting on a pid from a
thread group with many children and/or tracees.

Time to fork and then call waitpid on the child, from a task that already
has N children [1]:

N    | Before  | After
-----|---------|------
1    | 74 us   | 74 us
20   | 72 us   | 75 us
100  | 83 us   | 77 us
500  | 99 us   | 74 us
1000 | 179 us  | 75 us
5000 | 804 us  | 79 us
8000 | 1268 us | 78 us

[1]: https://lkml.org/lkml/2021/3/12/1567

This can make a substantial performance improvement for applications with
a thread that has many children or tracees and frequently needs to wait on
them.  Tools that use ptrace to intercept syscalls for a large number of
processes are likely to fall into this category.  In particular this patch
was developed while building a ptrace-based second generation of the
Shadow emulator [2], for which it allows us to avoid quadratic scaling
(without having to use a workaround that introduces a ~40% performance
penalty) [3].  Other examples of tools that fall into this category which
this patch may help include User Mode Linux [4] and DetTrace [5].

[2]: https://shadow.github.io/
[3]: https://github.com/shadow/shadow/issues/1134#issuecomment-798992292
[4]: https://en.wikipedia.org/wiki/User-mode_Linux
[5]: https://github.com/dettrace/dettrace

Link: https://lkml.kernel.org/r/20210314231544.9379-1-jnewsome@torproject.org
Signed-off-by: James Newsome <jnewsome@torproject.org>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>
Cc: Christian Brauner <christian@brauner.io>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   67 ++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 57 insertions(+), 10 deletions(-)

--- a/kernel/exit.c~do_wait-make-pidtype_pid-case-o1-instead-of-on
+++ a/kernel/exit.c
@@ -1440,9 +1440,48 @@ void __wake_up_parent(struct task_struct
 			   TASK_INTERRUPTIBLE, p);
 }
 
+static bool is_effectively_child(struct wait_opts *wo, bool ptrace,
+				 struct task_struct *target)
+{
+	struct task_struct *parent =
+		!ptrace ? target->real_parent : target->parent;
+
+	return current == parent || (!(wo->wo_flags & __WNOTHREAD) &&
+				     same_thread_group(current, parent));
+}
+
+/*
+ * Optimization for waiting on PIDTYPE_PID. No need to iterate through child
+ * and tracee lists to find the target task.
+ */
+static int do_wait_pid(struct wait_opts *wo)
+{
+	bool ptrace;
+	struct task_struct *target;
+	int retval;
+
+	ptrace = false;
+	target = pid_task(wo->wo_pid, PIDTYPE_TGID);
+	if (target && is_effectively_child(wo, ptrace, target)) {
+		retval = wait_consider_task(wo, ptrace, target);
+		if (retval)
+			return retval;
+	}
+
+	ptrace = true;
+	target = pid_task(wo->wo_pid, PIDTYPE_PID);
+	if (target && target->ptrace &&
+	    is_effectively_child(wo, ptrace, target)) {
+		retval = wait_consider_task(wo, ptrace, target);
+		if (retval)
+			return retval;
+	}
+
+	return 0;
+}
+
 static long do_wait(struct wait_opts *wo)
 {
-	struct task_struct *tsk;
 	int retval;
 
 	trace_sched_process_wait(wo->wo_pid);
@@ -1464,19 +1503,27 @@ repeat:
 
 	set_current_state(TASK_INTERRUPTIBLE);
 	read_lock(&tasklist_lock);
-	tsk = current;
-	do {
-		retval = do_wait_thread(wo, tsk);
-		if (retval)
-			goto end;
 
-		retval = ptrace_do_wait(wo, tsk);
+	if (wo->wo_type == PIDTYPE_PID) {
+		retval = do_wait_pid(wo);
 		if (retval)
 			goto end;
+	} else {
+		struct task_struct *tsk = current;
 
-		if (wo->wo_flags & __WNOTHREAD)
-			break;
-	} while_each_thread(current, tsk);
+		do {
+			retval = do_wait_thread(wo, tsk);
+			if (retval)
+				goto end;
+
+			retval = ptrace_do_wait(wo, tsk);
+			if (retval)
+				goto end;
+
+			if (wo->wo_flags & __WNOTHREAD)
+				break;
+		} while_each_thread(current, tsk);
+	}
 	read_unlock(&tasklist_lock);
 
 notask:
_

Patches currently in -mm which might be from jnewsome@torproject.org are


