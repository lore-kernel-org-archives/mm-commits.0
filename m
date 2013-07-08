From: akpm@linux-foundation.org
Subject: [merged]
 fork-reorder-permissions-when-violating-number-of-processes-limits.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:36:05 -0700
Message-ID: <51db14a5.ZFpv7CniH3rsszvI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51572 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159Ab3GHTgF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:36:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, eparis@redhat.com

Subject: [merged] fork-reorder-permissions-when-violating-number-of-processes-limits.patch removed from -mm tree
To: eparis@redhat.com,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:36:05 -0700


The patch titled
     Subject: fork: reorder permissions when violating number of processes limits
has been removed from the -mm tree.  Its filename was
     fork-reorder-permissions-when-violating-number-of-processes-limits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Eric Paris <eparis@redhat.com>
Subject: fork: reorder permissions when violating number of processes limits

When a task is attempting to violate the RLIMIT_NPROC limit we have a
check to see if the task is sufficiently priviledged.  The check first
looks at CAP_SYS_ADMIN, then CAP_SYS_RESOURCE, then if the task is uid=0.

A result is that tasks which are allowed by the uid=0 check are first
checked against the security subsystem.  This results in the security
subsystem auditting a denial for sys_admin and sys_resource and then the
task passing the uid=0 check.

This patch rearranges the code to first check uid=0, since if we pass that
we shouldn't hit the security system at all.  We then check sys_resource,
since it is the smallest capability which will solve the problem.  Lastly
we check the fallback everything cap_sysadmin.  We don't want to give this
capability many places since it is so powerful.

This will eliminate many of the false positive/needless denial messages we
get when a root task tries to violate the nproc limit.  (note that
kthreads count against root, so on a sufficiently large machine we can
actually get past the default limits before any userspace tasks are
launched.)

Signed-off-by: Eric Paris <eparis@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/fork.c~fork-reorder-permissions-when-violating-number-of-processes-limits kernel/fork.c
--- a/kernel/fork.c~fork-reorder-permissions-when-violating-number-of-processes-limits
+++ a/kernel/fork.c
@@ -1199,8 +1199,8 @@ static struct task_struct *copy_process(
 	retval = -EAGAIN;
 	if (atomic_read(&p->real_cred->user->processes) >=
 			task_rlimit(p, RLIMIT_NPROC)) {
-		if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_RESOURCE) &&
-		    p->real_cred->user != INIT_USER)
+		if (p->real_cred->user != INIT_USER &&
+		    !capable(CAP_SYS_RESOURCE) && !capable(CAP_SYS_ADMIN))
 			goto bad_fork_free;
 	}
 	current->flags &= ~PF_NPROC_EXCEEDED;
_

Patches currently in -mm which might be from eparis@redhat.com are

origin.patch
linux-next.patch
audit-fix-mq_open-and-mq_unlink-to-add-the-mq-root-as-a-hidden-parent-audit_names-record.patch
kernel-auditfilterc-fixing-build-warning.patch
kernel-auditfilterc-fix-leak-in-audit_add_rule-error-path.patch
audit-fix-decimal-constant-description.patch
fanotify-info-leak-in-copy_event_to_user.patch
fanotify-fix-races-when-adding-removing-marks.patch
fanotify-put-duplicate-code-for-adding-vfsmount-inode-marks-into-an-own-function.patch
dnotify-replace-dnotify_mark_mutex-with-mark-mutex-of-dnotify_group.patch
inotify-fix-race-when-adding-a-new-watch.patch
fsnotify-update-comments-concerning-locking-scheme.patch

