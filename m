From: akpm@linux-foundation.org
Subject: + exit-reparent-avoid-find_new_reaper-if-no-children.patch added
 to -mm tree
Date: Thu, 20 Nov 2014 14:41:21 -0800
Message-ID: <546e6e11.X3NJJf2eESjJPMke%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47580 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756141AbaKTWlX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 20 Nov 2014 17:41:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, atomlin@redhat.com, ebiederm@xmission.com, stalexan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: exit: reparent: avoid find_new_reaper() if no children
has been added to the -mm tree.  Its filename is
     exit-reparent-avoid-find_new_reaper-if-no-children.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/exit-reparent-avoid-find_new_reaper-if-no-children.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/exit-reparent-avoid-find_new_reaper-if-no-children.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: exit: reparent: avoid find_new_reaper() if no children

Now that pid_ns logic was isolated we can change forget_original_parent()
to return right after find_child_reaper() when father->children is empty,
there is nothing to reparent in this case.

In particular this avoids find_alive_thread() and this can help if the
whole process exits and it has a lot of PF_EXITING threads at the start of
the thread list, this can easily lead to O(nr_threads ** 2) iterations.

Trivial test case (tested under KVM, 2 CPUs):

	static void *tfunc(void *arg)
	{
		pause();
		return NULL;
	}

	static int child(unsigned int nt)
	{
		pthread_t pt;

		while (nt--)
			assert(pthread_create(&pt, NULL, tfunc, NULL) == 0);

		pthread_kill(pt, SIGTRAP);
		pause();
		return 0;
	}

	int main(int argc, const char *argv[])
	{
		int stat;
		unsigned int nf = atoi(argv[1]);
		unsigned int nt = atoi(argv[2]);

		while (nf--) {
			if (!fork())
				return child(nt);

			wait(&stat);
			assert(stat == SIGTRAP);
		}

		return 0;
	}

$ time ./test 16 16536 shows:

		real		user		sys
	-	5m37.628s	0m4.437s	8m5.560s
	+	0m50.032s	0m7.130s	1m4.927s

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Aaron Tomlin <atomlin@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Sterling Alexander <stalexan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN kernel/exit.c~exit-reparent-avoid-find_new_reaper-if-no-children kernel/exit.c
--- a/kernel/exit.c~exit-reparent-avoid-find_new_reaper-if-no-children
+++ a/kernel/exit.c
@@ -571,6 +571,8 @@ static void forget_original_parent(struc
 
 	/* Can drop and reacquire tasklist_lock */
 	reaper = find_child_reaper(father);
+	if (list_empty(&father->children))
+		goto unlock;
 
 	reaper = find_new_reaper(father, reaper);
 	list_for_each_entry(p, &father->children, sibling) {
@@ -591,6 +593,7 @@ static void forget_original_parent(struc
 			reparent_leader(father, p, &dead_children);
 	}
 	list_splice_tail_init(&father->children, &reaper->children);
+ unlock:
 	write_unlock_irq(&tasklist_lock);
 
 	list_for_each_entry_safe(p, n, &dead_children, ptrace_entry) {
_

Patches currently in -mm which might be from oleg@redhat.com are

mmfs-introduce-helpers-around-the-i_mmap_mutex.patch
mm-use-new-helper-functions-around-the-i_mmap_mutex.patch
mm-convert-i_mmap_mutex-to-rwsem.patch
mm-rmap-share-the-i_mmap_rwsem.patch
uprobes-share-the-i_mmap_rwsem.patch
mm-xip-share-the-i_mmap_rwsem.patch
mm-memory-failure-share-the-i_mmap_rwsem.patch
mm-nommu-share-the-i_mmap_rwsem.patch
mm-memoryc-share-the-i_mmap_rwsem.patch
remove-unnecessary-is_valid_nodemask.patch
proc-task_state-read-cred-group_info-outside-of-task_lock.patch
proc-task_state-deuglify-the-max_fds-calculation.patch
proc-task_state-move-the-main-seq_printf-outside-of-rcu_read_lock.patch
proc-task_state-ptrace_parent-doesnt-need-pid_alive-check.patch
sched_show_task-fix-unsafe-usage-of-real_parent.patch
exit-reparent-use-ptrace_entry-rather-than-sibling-for-exit_dead-tasks.patch
exit-reparent-cleanup-the-changing-of-parent.patch
exit-reparent-cleanup-the-changing-of-parent-fix.patch
exit-reparent-cleanup-the-usage-of-reparent_leader.patch
exit-ptrace-shift-reap-dead-code-from-exit_ptrace-to-forget_original_parent.patch
usermodehelper-dont-use-clone_vfork-for-____call_usermodehelper.patch
usermodehelper-kill-the-kmod_thread_locker-logic.patch
exit-wait-cleanup-the-ptrace_reparented-checks.patch
exit-wait-cleanup-the-ptrace_reparented-checks-fix.patch
exit-wait-dont-use-zombie-real_parent.patch
exit-wait-drop-tasklist_lock-before-psig-c-accounting.patch
exit-release_task-fix-the-comment-about-group-leader-accounting.patch
exit-proc-dont-try-to-flush-proc-tgid-task-tgid.patch
exit-reparent-fix-the-dead-parent-pr_set_child_subreaper-reparenting.patch
exit-reparent-fix-the-cross-namespace-pr_set_child_subreaper-reparenting.patch
exit-reparent-s-while_each_thread-for_each_thread-in-find_new_reaper.patch
exit-reparent-document-the-has_child_subreaper-checks.patch
exit-reparent-introduce-find_child_reaper.patch
exit-reparent-introduce-find_alive_thread.patch
exit-reparent-avoid-find_new_reaper-if-no-children.patch
exit-reparent-call-forget_original_parent-under-tasklist_lock.patch
exit-exit_notify-re-use-dead-list-to-autoreap-current.patch
linux-next.patch

