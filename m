From: akpm@linux-foundation.org
Subject: + anon_inodefs-forbid-open-via-proc.patch added to -mm tree
Date: Mon, 26 Aug 2013 13:48:44 -0700
Message-ID: <521bbf2c.tIgwVOQnf/Z1JVSP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57723 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968Ab3HZUsp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Aug 2013 16:48:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, luto@amacapital.net, oleg@redhat.com

Subject: + anon_inodefs-forbid-open-via-proc.patch added to -mm tree
To: oleg@redhat.com,luto@amacapital.net
From: akpm@linux-foundation.org
Date: Mon, 26 Aug 2013 13:48:44 -0700


The patch titled
     Subject: anon_inodefs: forbid open via /proc
has been added to the -mm tree.  Its filename is
     anon_inodefs-forbid-open-via-proc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/anon_inodefs-forbid-open-via-proc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/anon_inodefs-forbid-open-via-proc.patch

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
Subject: anon_inodefs: forbid open via /proc

open("/proc/pid/$anon-fd") should fail, we can't create the new file with
correct f_op/etc correctly.  Currently this creates the bogus file with
the empty anon_inode_fops, this is harmless but still wrong and
misleading.

Add anon_inode_fops->anon_open() which simply returns ENXIO like
sock_no_open() does in this case.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/anon_inodes.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff -puN fs/anon_inodes.c~anon_inodefs-forbid-open-via-proc fs/anon_inodes.c
--- a/fs/anon_inodes.c~anon_inodefs-forbid-open-via-proc
+++ a/fs/anon_inodes.c
@@ -24,7 +24,15 @@
 
 static struct vfsmount *anon_inode_mnt __read_mostly;
 static struct inode *anon_inode_inode;
-static const struct file_operations anon_inode_fops;
+
+static int anon_open(struct inode *inode, struct file *file)
+{
+	return -ENXIO;
+}
+
+static const struct file_operations anon_inode_fops = {
+	.open = anon_open,
+};
 
 /*
  * anon_inodefs_dname() is called from d_path().
_

Patches currently in -mm which might be from oleg@redhat.com are

pidns-fix-vfork-after-unshareclone_newpid.patch
pidns-kill-the-unnecessary-clone_newpid-in-copy_process.patch
fork-unify-and-tighten-up-clone_newuser-clone_newpid-checks.patch
include-linux-schedh-dont-use-task-pid-tgid-in-same_thread_group-has_group_leader_pid.patch
anon_inodefs-forbid-open-via-proc.patch
mm-mempolicy-turn-vma_set_policy-into-vma_dup_policy.patch
mm-shift-vm_grows-check-from-mmap_region-to-do_mmap_pgoff-v2.patch
mm-do_mmap_pgoff-cleanup-the-usage-of-file_inode.patch
mm-mmap_region-kill-correct_wcount-inode-use-allow_write_access.patch
kernel-wide-fix-missing-validations-on-__get-__put-__copy_to-__copy_from_user.patch
task_work-minor-cleanups.patch
task_work-documentation.patch
autofs4-allow-autofs-to-work-outside-the-initial-pid-namespace.patch
autofs4-translate-pids-to-the-right-namespace-for-the-daemon.patch
__ptrace_may_access-should-not-deny-sub-threads.patch
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

