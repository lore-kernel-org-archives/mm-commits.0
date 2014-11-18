From: akpm@linux-foundation.org
Subject: +
 exit-reparent-s-while_each_thread-for_each_thread-in-find_new_reaper.patch
 added to -mm tree
Date: Tue, 18 Nov 2014 13:50:03 -0800
Message-ID: <546bbf0b.WyiGNdp+24dwy8xe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36863 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300AbaKRVuE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Nov 2014 16:50:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, atomlin@redhat.com, ebiederm@xmission.com, kay@vrfy.org, lennart@poettering.net, stalexan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: exit: reparent: s/while_each_thread/for_each_thread/ in find_new_reaper()
has been added to the -mm tree.  Its filename is
     exit-reparent-s-while_each_thread-for_each_thread-in-find_new_reaper.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/exit-reparent-s-while_each_thread-for_each_thread-in-find_new_reaper.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/exit-reparent-s-while_each_thread-for_each_thread-in-find_new_reaper.patch

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
Subject: exit: reparent: s/while_each_thread/for_each_thread/ in find_new_reaper()

Change find_new_reaper() to use for_each_thread() instead of deprecated
while_each_thread().  We do not bother to check "thread != father" in the
1st loop, we can rely on PF_EXITING check.

Note: this means the minor behavioural change: for_each_thread() starts
from the group leader.  But this should be fine, nobody should make any
assumption about do_wait(__WNOTHREAD) when it comes to reparented tasks. 
And this can avoid the pointless reparenting to a short-living thread
While zombie leaders are not that common.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Aaron Tomlin <atomlin@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Kay Sievers <kay@vrfy.org>
Cc: Lennart Poettering <lennart@poettering.net>
Cc: Sterling Alexander <stalexan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN kernel/exit.c~exit-reparent-s-while_each_thread-for_each_thread-in-find_new_reaper kernel/exit.c
--- a/kernel/exit.c~exit-reparent-s-while_each_thread-for_each_thread-in-find_new_reaper
+++ a/kernel/exit.c
@@ -476,8 +476,7 @@ static struct task_struct *find_new_reap
 	struct pid_namespace *pid_ns = task_active_pid_ns(father);
 	struct task_struct *thread;
 
-	thread = father;
-	while_each_thread(father, thread) {
+	for_each_thread(father, thread) {
 		if (thread->flags & PF_EXITING)
 			continue;
 		if (unlikely(pid_ns->child_reaper == father))
@@ -514,11 +513,10 @@ static struct task_struct *find_new_reap
 				break;
 			if (!reaper->signal->is_child_subreaper)
 				continue;
-			thread = reaper;
-			do {
+			for_each_thread(reaper, thread) {
 				if (!(thread->flags & PF_EXITING))
 					return thread;
-			} while_each_thread(reaper, thread);
+			}
 		}
 	}
 
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
exit-reparent-fix-the-dead-parent-pr_set_child_subreaper-reparenting.patch
exit-reparent-fix-the-cross-namespace-pr_set_child_subreaper-reparenting.patch
exit-reparent-s-while_each_thread-for_each_thread-in-find_new_reaper.patch
exit-reparent-document-the-has_child_subreaper-checks.patch
exit-reparent-introduce-find_child_reaper.patch
exit-reparent-introduce-find_alive_thread.patch
linux-next.patch

