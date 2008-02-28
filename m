From: akpm@linux-foundation.org
Subject: + core-dump-user_regset-writeback.patch added to -mm tree
Date: Thu, 28 Feb 2008 12:44:38 -0800
Message-ID: <200802282044.m1SKic44019500@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:55498 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760729AbYB1Upt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Feb 2008 15:45:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roland@redhat.com, shaohua.li@intel.com, tony.luck@intel.com


The patch titled
     core dump: user_regset writeback
has been added to the -mm tree.  Its filename is
     core-dump-user_regset-writeback.patch

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
Subject: core dump: user_regset writeback
From: Roland McGrath <roland@redhat.com>

This makes the user_regset-based core dump code call user_regset writeback
hooks when available.  This is necessary groundwork to allow IA64 to set
CORE_DUMP_USE_REGSET.

Cc: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff -puN fs/binfmt_elf.c~core-dump-user_regset-writeback fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~core-dump-user_regset-writeback
+++ a/fs/binfmt_elf.c
@@ -1421,6 +1421,18 @@ struct elf_note_info {
 	int thread_notes;
 };
 
+/*
+ * When a regset has a writeback hook, we call it on each thread before
+ * dumping user memory.  On register window machines, this makes sure the
+ * user memory backing the register data is up to date before we read it.
+ */
+static void do_thread_regset_writeback(struct task_struct *task,
+				       const struct user_regset *regset)
+{
+	if (regset->writeback)
+		regset->writeback(task, regset, 1);
+}
+
 static int fill_thread_core_info(struct elf_thread_core_info *t,
 				 const struct user_regset_view *view,
 				 long signr, size_t *total)
@@ -1442,6 +1454,8 @@ static int fill_thread_core_info(struct 
 		  sizeof(t->prstatus), &t->prstatus);
 	*total += notesize(&t->notes[0]);
 
+	do_thread_regset_writeback(t->task, &view->regsets[0]);
+
 	/*
 	 * Each other regset might generate a note too.  For each regset
 	 * that has no core_note_type or is inactive, we leave t->notes[i]
@@ -1449,6 +1463,7 @@ static int fill_thread_core_info(struct 
 	 */
 	for (i = 1; i < view->n; ++i) {
 		const struct user_regset *regset = &view->regsets[i];
+		do_thread_regset_writeback(t->task, regset);
 		if (regset->core_note_type &&
 		    (!regset->active || regset->active(t->task, regset))) {
 			int ret;
_

Patches currently in -mm which might be from roland@redhat.com are

elfcore-compat-fix-uid-gid-types.patch
git-x86.patch
handle_stop_signal-dont-wake-up-the-stopped-task-until-it-sees-sigcont.patch
add-rusage_thread.patch
remove-unused-variable-from-send_signal.patch
turn-legacy_queue-macro-into-static-inline-function.patch
consolidate-checking-for-ignored-legacy-signals.patch
consolidate-checking-for-ignored-legacy-signals-simplify.patch
signals-do_signal_stop-use-signal_group_exit.patch
signals-do_group_exit-use-signal_group_exit-more-consistently.patch
lock_task_sighand-add-rcu-lock-unlock.patch
k_getrusage-dont-take-rcu_read_lock.patch
do_task_stat-dont-take-rcu_read_lock.patch
signals-consolidate-checks-for-whether-or-not-to-ignore-a-signal.patch
signals-clean-dequeue_signal-from-excess-checks-and-assignments.patch
signals-consolidate-send_sigqueue-and-send_group_sigqueue.patch
signals-cleanup-security_task_kill-usage-implementation.patch
core-dump-user_regset-writeback.patch
free_pidmap-turn-it-into-free_pidmapstruct-upid.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

