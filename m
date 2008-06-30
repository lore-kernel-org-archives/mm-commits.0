From: akpm@linux-foundation.org
Subject: + coredump-elf_core_dump-skip-kernel-threads.patch added to -mm tree
Date: Mon, 30 Jun 2008 16:28:58 -0700
Message-ID: <200806302328.m5UNSwwt031010@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46405 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752612AbYF3X31 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jun 2008 19:29:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, roland@redhat.com


The patch titled
     coredump: elf_core_dump: skip kernel threads
has been added to the -mm tree.  Its filename is
     coredump-elf_core_dump-skip-kernel-threads.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: coredump: elf_core_dump: skip kernel threads
From: Oleg Nesterov <oleg@tv-sign.ru>

linux_binfmt->core_dump() runs before the process does exit_aio(), this
means that we can hit the kernel thread which shares the same ->mm. 
Afaics, nothing really bad can happen, but perhaps it makes sense to fix
this minor bug.

It is sad we have to iterate over all threads in system and use
GFP_ATOMIC.  Hopefully we can kill theses ugly do_each_thread()s, but this
needs some nontrivial changes in mm_struct and do_coredump.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c       |    6 ++++++
 fs/binfmt_elf_fdpic.c |    3 +++
 2 files changed, 9 insertions(+)

diff -puN fs/binfmt_elf.c~coredump-elf_core_dump-skip-kernel-threads fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~coredump-elf_core_dump-skip-kernel-threads
+++ a/fs/binfmt_elf.c
@@ -1520,6 +1520,9 @@ static int fill_note_info(struct elfhdr 
 	rcu_read_lock();
 	do_each_thread(g, p)
 		if (p->mm == dump_task->mm) {
+			if (p->flags & PF_KTHREAD)
+				continue;
+
 			t = kzalloc(offsetof(struct elf_thread_core_info,
 					     notes[info->thread_notes]),
 				    GFP_ATOMIC);
@@ -1724,6 +1727,9 @@ static int fill_note_info(struct elfhdr 
 		rcu_read_lock();
 		do_each_thread(g, p)
 			if (current->mm == p->mm && current != p) {
+				if (p->flags & PF_KTHREAD)
+					continue;
+
 				ets = kzalloc(sizeof(*ets), GFP_ATOMIC);
 				if (!ets) {
 					rcu_read_unlock();
diff -puN fs/binfmt_elf_fdpic.c~coredump-elf_core_dump-skip-kernel-threads fs/binfmt_elf_fdpic.c
--- a/fs/binfmt_elf_fdpic.c~coredump-elf_core_dump-skip-kernel-threads
+++ a/fs/binfmt_elf_fdpic.c
@@ -1631,6 +1631,9 @@ static int elf_fdpic_core_dump(long sign
 		rcu_read_lock();
 		do_each_thread(g,p)
 			if (current->mm == p->mm && current != p) {
+				if (p->flags & PF_KTHREAD)
+					continue;
+
 				tmp = kzalloc(sizeof(*tmp), GFP_ATOMIC);
 				if (!tmp) {
 					rcu_read_unlock();
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

get_user_pages-fix-possible-page-leak-on-oom.patch
introduce-pf_kthread-flag.patch
kill-pf_borrowed_mm-in-favour-of-pf_kthread.patch
coredump-zap_threads-must-skip-kernel-threads.patch
coredump-elf_core_dump-skip-kernel-threads.patch
posix-timers-timer_delete-remove-the-bogus-it_process-=-null-check.patch
posix-timers-release_posix_timer-kill-the-bogus-put_task_struct-it_process.patch
signals-collect_signal-remove-the-unneeded-sigismember-check.patch
signals-collect_signal-simplify-the-still_pending-logic.patch
signals-change-collect_signal-to-return-void.patch
__exit_signal-dont-take-rcu-lock.patch
signals-dequeue_signal-dont-check-signal_group_exit-when-setting-signal_stop_dequeued.patch
signals-do_signal_stop-kill-the-signal_unkillable-check.patch
coredump-zap_threads-comments-use-while_each_thread.patch
signals-make-siginfo_t-si_utime-si_sstime-report-times-in-user_hz-not-hz.patch
kernel-signalc-change-vars-pid-and-tgid-types-to-pid_t.patch
include-asm-ptraceh-userspace-headers-cleanup.patch
ptrace-give-more-respect-to-sigkill.patch
ptrace-never-sleep-in-task_traced-if-sigkilled.patch
ptrace-kill-may_ptrace_stop.patch
pidns-remove-now-unused-kill_proc-function.patch
pidns-remove-now-unused-find_pid-function.patch
pidns-remove-find_task_by_pid-unused-for-a-long-time.patch
distinct-tgid-tid-i-o-statistics.patch

