From: akpm@linux-foundation.org
Subject: + utrace-core-utrace-fix-utrace_maybe_reap-vs-find_matching_engine-race.patch added to -mm tree
Date: Tue, 26 Jan 2010 15:30:17 -0800
Message-ID: <201001262330.o0QNUITf028405@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46190 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753792Ab0AZXbY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jan 2010 18:31:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, caiqian@redhat.com, roland@redhat.com


The patch titled
     utrace: fix utrace_maybe_reap() vs find_matching_engine() race
has been added to the -mm tree.  Its filename is
     utrace-core-utrace-fix-utrace_maybe_reap-vs-find_matching_engine-race.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: utrace: fix utrace_maybe_reap() vs find_matching_engine() race
From: Oleg Nesterov <oleg@redhat.com>

The comment in utrace_maybe_reap() correctly explains why
utrace_attach_task/utrace_control/etc can't modify or use
attaching/attached lists.  But find_matching_engine() can scan ->attached
under utrace->lock without any checks, it can race with
utrace_maybe_reap() destroying list nodes.

Change utrace_maybe_reap() to empty ->attached before it drops
utrace->lock, update the comments a bit.

Reported-by: CAI Qian <caiqian@redhat.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/utrace.c |   23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff -puN kernel/utrace.c~utrace-core-utrace-fix-utrace_maybe_reap-vs-find_matching_engine-race kernel/utrace.c
--- a/kernel/utrace.c~utrace-core-utrace-fix-utrace_maybe_reap-vs-find_matching_engine-race
+++ a/kernel/utrace.c
@@ -1,7 +1,7 @@
 /*
  * utrace infrastructure interface for debugging user processes
  *
- * Copyright (C) 2006-2009 Red Hat, Inc.  All rights reserved.
+ * Copyright (C) 2006-2010 Red Hat, Inc.  All rights reserved.
  *
  * This copyrighted material is made available to anyone wishing to use,
  * modify, copy, or redistribute it subject to the terms and conditions
@@ -859,6 +859,7 @@ void utrace_maybe_reap(struct task_struc
 		       bool reap)
 {
 	struct utrace_engine *engine, *next;
+	struct list_head attached;
 
 	spin_lock(&utrace->lock);
 
@@ -897,16 +898,24 @@ void utrace_maybe_reap(struct task_struc
 	}
 
 	/*
-	 * utrace_add_engine() checks ->utrace_flags != 0.
-	 * Since @utrace->reap is set, nobody can set or clear
-	 * UTRACE_EVENT(REAP) in @engine->flags or change
-	 * @engine->ops, and nobody can change @utrace->attached.
+	 * utrace_add_engine() checks ->utrace_flags != 0.  Since
+	 * @utrace->reap is set, nobody can set or clear UTRACE_EVENT(REAP)
+	 * in @engine->flags or change @engine->ops and nobody can change
+	 * @utrace->attached after we drop the lock.
 	 */
 	target->utrace_flags = 0;
-	splice_attaching(utrace);
+
+	/*
+	 * We clear out @utrace->attached before we drop the lock so
+	 * that find_matching_engine() can't come across any old engine
+	 * while we are busy tearing it down.
+	 */
+	list_replace_init(&utrace->attached, &attached);
+	list_splice_tail_init(&utrace->attaching, &attached);
+
 	spin_unlock(&utrace->lock);
 
-	list_for_each_entry_safe(engine, next, &utrace->attached, entry) {
+	list_for_each_entry_safe(engine, next, &attached, entry) {
 		if (engine->flags & UTRACE_EVENT(REAP))
 			engine->ops->report_reap(engine, target);
 
_

Patches currently in -mm which might be from oleg@redhat.com are

linux-next.patch
posix-cpu-timers-reset-expire-cache-when-no-timer-is-running.patch
cpu-timers-simplify-rlimit_cpu-handling.patch
cpu-timers-cleanup-arm_timer.patch
cpu-timers-return-correct-previous-timer-reload-value.patch
cpu-timers-change-sigev_none-timer-implementation.patch
cpu-timers-assure-to-not-iterate-over-all-threads-in-fastpath_timer_check.patch
cpu-timers-optimize-run_posix_cpu_timers.patch
prctl-add-pr_set_proctitle_area-option-for-prctl.patch
coredump-unify-dump_seek-implementations-for-each-binfmt_c.patch
coredump-move-dump_write-and-dump_seek-into-a-header-file.patch
elf-coredump-replace-elf_core_extra_-macros-by-functions.patch
elf-coredump-make-offset-calculation-process-and-writing-process-explicit.patch
elf-coredump-add-extended-numbering-support.patch
mm-pass-mm-flags-as-a-coredump-parameter-for-consistency.patch
tracehooks-kill-some-pt_ptraced-checks.patch
tracehooks-check-pt_ptraced-before-reporting-the-single-step.patch
ptrace_signal-check-pt_ptraced-before-reporting-a-signal.patch
export-__ptrace_detach-and-do_notify_parent_cldstop.patch
reorder-the-code-in-kernel-ptracec.patch
implement-utrace-ptrace.patch
utrace-core.patch
utrace-core-utrace-fix-utrace_maybe_reap-vs-find_matching_engine-race.patch
copy_signal-cleanup-use-zalloc-and-remove-initializations.patch
copy_signal-cleanup-kill-taskstats_tgid_init-and-acct_init_pacct.patch
copy_signal-cleanup-clean-thread_group_cputime_init.patch
copy_signal-cleanup-clean-tty_audit_fork.patch

