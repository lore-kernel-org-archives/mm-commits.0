From: akpm@linux-foundation.org
Subject: - coredump-format_corename-fix-the-core_uses_pid-logic.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:00:07 -0700
Message-ID: <200807252300.m6PN07oS003558@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34856 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755486AbYGYXHR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:07:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, alan@lxorguk.ukuu.org.uk, andi@firstfloor.org, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     coredump: format_corename: fix the "core_uses_pid" logic
has been removed from the -mm tree.  Its filename was
     coredump-format_corename-fix-the-core_uses_pid-logic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: coredump: format_corename: fix the "core_uses_pid" logic
From: Oleg Nesterov <oleg@tv-sign.ru>

I don't understand why the multi-thread coredump implies the core_uses_pid
behaviour, but we shouldn't use mm->mm_users for that.  This counter can
be incremented by get_task_mm().  Use the valued returned by
coredump_wait() instead.

Also, remove the "const char *pattern" argument, format_corename() can use
core_pattern directly.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff -puN fs/exec.c~coredump-format_corename-fix-the-core_uses_pid-logic fs/exec.c
--- a/fs/exec.c~coredump-format_corename-fix-the-core_uses_pid-logic
+++ a/fs/exec.c
@@ -1379,17 +1379,14 @@ EXPORT_SYMBOL(set_binfmt);
  * name into corename, which must have space for at least
  * CORENAME_MAX_SIZE bytes plus one byte for the zero terminator.
  */
-static int format_corename(char *corename, const char *pattern, long signr)
+static int format_corename(char *corename, int nr_threads, long signr)
 {
-	const char *pat_ptr = pattern;
+	const char *pat_ptr = core_pattern;
+	int ispipe = (*pat_ptr == '|');
 	char *out_ptr = corename;
 	char *const out_end = corename + CORENAME_MAX_SIZE;
 	int rc;
 	int pid_in_pattern = 0;
-	int ispipe = 0;
-
-	if (*pattern == '|')
-		ispipe = 1;
 
 	/* Repeat as long as we have more pattern to process and more output
 	   space */
@@ -1490,7 +1487,7 @@ static int format_corename(char *corenam
 	 * and core_uses_pid is set, then .%pid will be appended to
 	 * the filename. Do not do this for piped commands. */
 	if (!ispipe && !pid_in_pattern
-            && (core_uses_pid || atomic_read(&current->mm->mm_users) != 1)) {
+	    && (core_uses_pid || nr_threads)) {
 		rc = snprintf(out_ptr, out_end - out_ptr,
 			      ".%d", task_tgid_vnr(current));
 		if (rc > out_end - out_ptr)
@@ -1753,7 +1750,7 @@ int do_coredump(long signr, int exit_cod
 	 * uses lock_kernel()
 	 */
  	lock_kernel();
-	ispipe = format_corename(corename, core_pattern, signr);
+	ispipe = format_corename(corename, retval, signr);
 	unlock_kernel();
 	/*
 	 * Don't bother to check the RLIMIT_CORE value if core_pattern points
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
linux-next.patch
migrate_timers-add-comment-use-spinlock_irq.patch
tracehook-add-linux-tracehookh.patch
tracehook-exec.patch
tracehook-unexport-ptrace_notify.patch
tracehook-exit.patch
tracehook-clone.patch
tracehook-vfork-done.patch
tracehook-release_task.patch
tracehook-tracehook_tracer_task.patch
tracehook-tracehook_expect_breakpoints.patch
tracehook-tracehook_signal_handler.patch
tracehook-tracehook_consider_ignored_signal.patch
tracehook-tracehook_consider_fatal_signal.patch
tracehook-syscall.patch
tracehook-get_signal_to_deliver.patch
tracehook-job-control.patch
tracehook-death.patch
tracehook-force-signal_pending.patch
tracehook-tif_notify_resume.patch
tracehook-asm-syscallh.patch
tracehook-config_have_arch_tracehook.patch
tracehook-wait_task_inactive.patch
task_current_syscall.patch
proc-pid-syscall.patch

