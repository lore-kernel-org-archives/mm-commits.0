Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C48BC433E0
	for <mm-commits@archiver.kernel.org>; Mon, 15 Mar 2021 21:20:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 608ED64EB9
	for <mm-commits@archiver.kernel.org>; Mon, 15 Mar 2021 21:20:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230112AbhCOVUA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Mar 2021 17:20:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:54664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232025AbhCOVTq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 15 Mar 2021 17:19:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F07B664E31;
        Mon, 15 Mar 2021 21:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615843186;
        bh=RxC9ntwbi/6O9juC9gHS4SlP5rg9QXnmt6VCvRAoAV8=;
        h=Date:From:To:Subject:From;
        b=PwubWPzInVlAOmtWA9Mym0mNWKptBBINlCuAjF7Rg2hWiVGL6WhFwvWcFsuQ3ktnU
         mLv3pXy5yRVmbKx0xmTVUPcKG1XbyDotkWaalMIeqCLigaScZiLQH7ZIjLL7gOmHiK
         bsFl9NK+TCA00jnY+rnM9eIUfQwaIBGQ34v8/EjQ=
Date:   Mon, 15 Mar 2021 14:19:45 -0700
From:   akpm@linux-foundation.org
To:     christian@brauner.io, ebiederm@xmission.com,
        jnewsome@torproject.org, mm-commits@vger.kernel.org,
        oleg@redhat.com
Subject:  [to-be-updated]
 do_wait-make-pidtype_pid-case-o1-instead-of-on.patch removed from -mm tree
Message-ID: <20210315211945.TL5e8UrCt%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/exit.c: do_wait: make PIDTYPE_PID case O(1) instead of O(n)
has been removed from the -mm tree.  Its filename was
     do_wait-make-pidtype_pid-case-o1-instead-of-on.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Jim Newsome <jnewsome@torproject.org>
Subject: kernel/exit.c: do_wait: make PIDTYPE_PID case O(1) instead of O(n)

do_wait is an internal function used to implement waitpid, waitid, wait4,
etc.  To handle the general case, it does an O(n) linear scan of the
thread group's children and tracees.

This patch adds a special-case when waiting on a pid to skip these scans
and instead do an O(1) lookup.  This improves performance when waiting on
a pid from a thread group with many children and/or tracees.

Link: https://lkml.kernel.org/r/20210312173855.24843-1-jnewsome@torproject.org
Signed-off-by: James Newsome <jnewsome@torproject.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>
Cc: Christian Brauner <christian@brauner.io>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   69 +++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 59 insertions(+), 10 deletions(-)

--- a/kernel/exit.c~do_wait-make-pidtype_pid-case-o1-instead-of-on
+++ a/kernel/exit.c
@@ -1439,9 +1439,50 @@ void __wake_up_parent(struct task_struct
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
+	target = pid_task(wo->wo_pid, PIDTYPE_PID);
+	if (!target)
+		return 0;
+
+	ptrace = false;
+	if (thread_group_leader(target) &&
+	    is_effectively_child(wo, ptrace, target)) {
+		retval = wait_consider_task(wo, ptrace, target);
+		if (retval)
+			return retval;
+	}
+
+	ptrace = true;
+	if (target->ptrace && is_effectively_child(wo, ptrace, target)) {
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
@@ -1463,19 +1504,27 @@ repeat:
 
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


