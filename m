From: akpm@linux-foundation.org
Subject: +
 fork-reorder-permissions-when-violating-number-of-processes-limits.patch
 added to -mm tree
Date: Tue, 14 May 2013 12:36:09 -0700
Message-ID: <51929229.kTFTQyqUmNxcZJ8e%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52662 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758059Ab3ENTgK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 May 2013 15:36:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, eparis@redhat.com

Subject: + fork-reorder-permissions-when-violating-number-of-processes-limits.patch added to -mm tree
To: eparis@redhat.com,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Tue, 14 May 2013 12:36:09 -0700


The patch titled
     Subject: fork: reorder permissions when violating number of processes limits
has been added to the -mm tree.  Its filename is
     fork-reorder-permissions-when-violating-number-of-processes-limits.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1195,8 +1195,8 @@ static struct task_struct *copy_process(
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

kernel-audit_treec-audit_add_tree_rule-protect-rule-from-kill_rules.patch
audit-fix-mq_open-and-mq_unlink-to-add-the-mq-root-as-a-hidden-parent-audit_names-record.patch
fork-reorder-permissions-when-violating-number-of-processes-limits.patch

