From: akpm@linux-foundation.org
Subject: + hung_task-print-more-info-when-reporting-the-problem.patch
 added to -mm tree
Date: Thu, 08 Aug 2013 15:05:15 -0700
Message-ID: <5204161b.uzcfBHoIORGq3XXj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53224 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966717Ab3HHWFQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Aug 2013 18:05:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, oleg@redhat.com

Subject: + hung_task-print-more-info-when-reporting-the-problem.patch added to -mm tree
To: oleg@redhat.com
From: akpm@linux-foundation.org
Date: Thu, 08 Aug 2013 15:05:15 -0700


The patch titled
     Subject: hung_task: print more info when reporting the problem
has been added to the -mm tree.  Its filename is
     hung_task-print-more-info-when-reporting-the-problem.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hung_task-print-more-info-when-reporting-the-problem.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hung_task-print-more-info-when-reporting-the-problem.patch

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
Subject: hung_task: print more info when reporting the problem

printk(KERN_ERR) from check_hung_task() likely means the bug, but unlike
BUG_ON/WARN_ON it doesn't show the kernel version, this complicates the
bug-reports investigation.

Add the additional pr_err() to print tainted/release/version like
dump_stack_print_info() does, the output becomes:

        INFO: task perl:504 blocked for more than 2 seconds.
	      Not tainted 3.11.0-rc1-10367-g136bb46-dirty #1763
        "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
        ...

While at it, turn the old printk's into pr_err().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/hung_task.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff -puN kernel/hung_task.c~hung_task-print-more-info-when-reporting-the-problem kernel/hung_task.c
--- a/kernel/hung_task.c~hung_task-print-more-info-when-reporting-the-problem
+++ a/kernel/hung_task.c
@@ -15,6 +15,7 @@
 #include <linux/lockdep.h>
 #include <linux/export.h>
 #include <linux/sysctl.h>
+#include <linux/utsname.h>
 
 /*
  * The number of tasks checked:
@@ -99,10 +100,14 @@ static void check_hung_task(struct task_
 	 * Ok, the task did not get scheduled for more than 2 minutes,
 	 * complain:
 	 */
-	printk(KERN_ERR "INFO: task %s:%d blocked for more than "
-			"%ld seconds.\n", t->comm, t->pid, timeout);
-	printk(KERN_ERR "\"echo 0 > /proc/sys/kernel/hung_task_timeout_secs\""
-			" disables this message.\n");
+	pr_err("INFO: task %s:%d blocked for more than %ld seconds.\n",
+		t->comm, t->pid, timeout);
+	pr_err("      %s %s %.*s\n",
+		print_tainted(), init_utsname()->release,
+		(int)strcspn(init_utsname()->version, " "),
+		init_utsname()->version);
+	pr_err("\"echo 0 > /proc/sys/kernel/hung_task_timeout_secs\""
+		" disables this message.\n");
 	sched_show_task(t);
 	debug_show_held_locks(t);
 
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
x86-get_unmapped_area-use-proper-mmap-base-for-bottom-up-direction.patch
include-linux-schedh-dont-use-task-pid-tgid-in-same_thread_group-has_group_leader_pid.patch
mm-mempolicy-turn-vma_set_policy-into-vma_dup_policy.patch
mm-shift-vm_grows-check-from-mmap_region-to-do_mmap_pgoff-v2.patch
mm-do_mmap_pgoff-cleanup-the-usage-of-file_inode.patch
mm-mmap_region-kill-correct_wcount-inode-use-allow_write_access.patch
kernel-wide-fix-missing-validations-on-__get-__put-__copy_to-__copy_from_user.patch
hung_task-print-more-info-when-reporting-the-problem.patch
autofs4-allow-autofs-to-work-outside-the-initial-pid-namespace.patch
autofs4-translate-pids-to-the-right-namespace-for-the-daemon.patch
signals-eventpoll-set-saved_sigmask-at-the-start.patch
move-exit_task_namespaces-outside-of-exit_notify-fix.patch
exec-introduce-exec_binprm-for-depth-==-0-code.patch
exec-kill-int-depth-in-search_binary_handler.patch
exec-proc_exec_connector-should-be-called-only-once.patch
exec-move-allow_write_access-fput-to-exec_binprm.patch
exec-kill-load_binary-=-null-check-in-search_binary_handler.patch
exec-cleanup-the-config_modules-logic.patch
exec-dont-retry-if-request_module-fails.patch
exec-cleanup-the-error-handling-in-search_binary_handler.patch
linux-next.patch

