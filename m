From: akpm@linux-foundation.org
Subject: + freezer_cg-disable-writing-freezerstate-of-root-cgroup.patch added to -mm tree
Date: Thu, 06 Nov 2008 17:15:58 -0800
Message-ID: <200811070115.mA71FwIR004451@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60779 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752146AbYKGBRf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Nov 2008 20:17:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, clg@fr.ibm.com, matthltc@us.ibm.com, menage@google.com, serue@us.ibm.com


The patch titled
     freezer_cg: disable writing freezer.state of root cgroup
has been added to the -mm tree.  Its filename is
     freezer_cg-disable-writing-freezerstate-of-root-cgroup.patch

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
Subject: freezer_cg: disable writing freezer.state of root cgroup
From: Li Zefan <lizf@cn.fujitsu.com>

With this change, control file 'freezer.state' doesn't exist in root
cgroup, making root cgroup unfreezable.

I think it's reasonable to disallow freeze tasks in the root cgroup.  And
then we can avoid fork overhead when freezer subsystem is compiled but not
used.

Also make writing invalid value to freezer.state returns EINVAL rather
than EIO.  This is more consistent with other cgroup subsystem.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Paul Menage <menage@google.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: Paul Menage <menage@google.com>
Cc: Matt Helsley <matthltc@us.ibm.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/freezer-subsystem.txt |   21 ++++++++++--------
 kernel/cgroup_freezer.c                     |   11 ++++++++-
 2 files changed, 22 insertions(+), 10 deletions(-)

diff -puN Documentation/cgroups/freezer-subsystem.txt~freezer_cg-disable-writing-freezerstate-of-root-cgroup Documentation/cgroups/freezer-subsystem.txt
--- a/Documentation/cgroups/freezer-subsystem.txt~freezer_cg-disable-writing-freezerstate-of-root-cgroup
+++ a/Documentation/cgroups/freezer-subsystem.txt
@@ -1,4 +1,4 @@
-	The cgroup freezer is useful to batch job management system which start
+The cgroup freezer is useful to batch job management system which start
 and stop sets of tasks in order to schedule the resources of a machine
 according to the desires of a system administrator. This sort of program
 is often used on HPC clusters to schedule access to the cluster as a
@@ -6,7 +6,7 @@ whole. The cgroup freezer uses cgroups t
 be started/stopped by the batch job management system. It also provides
 a means to start and stop the tasks composing the job.
 
-	The cgroup freezer will also be useful for checkpointing running groups
+The cgroup freezer will also be useful for checkpointing running groups
 of tasks. The freezer allows the checkpoint code to obtain a consistent
 image of the tasks by attempting to force the tasks in a cgroup into a
 quiescent state. Once the tasks are quiescent another task can
@@ -16,7 +16,7 @@ recoverable error occur. This also allow
 migrated between nodes in a cluster by copying the gathered information
 to another node and restarting the tasks there.
 
-	Sequences of SIGSTOP and SIGCONT are not always sufficient for stopping
+Sequences of SIGSTOP and SIGCONT are not always sufficient for stopping
 and resuming tasks in userspace. Both of these signals are observable
 from within the tasks we wish to freeze. While SIGSTOP cannot be caught,
 blocked, or ignored it can be seen by waiting or ptracing parent tasks.
@@ -37,26 +37,29 @@ demonstrate this problem using nested ba
 
 	<at this point 16990 exits and causes 16644 to exit too>
 
-	This happens because bash can observe both signals and choose how it
+This happens because bash can observe both signals and choose how it
 responds to them.
 
-	Another example of a program which catches and responds to these
+Another example of a program which catches and responds to these
 signals is gdb. In fact any program designed to use ptrace is likely to
 have a problem with this method of stopping and resuming tasks.
 
-	 In contrast, the cgroup freezer uses the kernel freezer code to
+In contrast, the cgroup freezer uses the kernel freezer code to
 prevent the freeze/unfreeze cycle from becoming visible to the tasks
 being frozen. This allows the bash example above and gdb to run as
 expected.
 
-	The freezer subsystem in the container filesystem defines a file named
+The freezer subsystem in the container filesystem defines a file named
 freezer.state. Writing "FROZEN" to the state file will freeze all tasks in the
 cgroup. Subsequently writing "THAWED" will unfreeze the tasks in the cgroup.
 Reading will return the current state.
 
+Note freezer.state doesn't exist in root cgroup, which means root cgroup
+is non-freezable.
+
 * Examples of usage :
 
-   # mkdir /containers/freezer
+   # mkdir /containers
    # mount -t cgroup -ofreezer freezer  /containers
    # mkdir /containers/0
    # echo $some_pid > /containers/0/tasks
@@ -94,6 +97,6 @@ things happens:
 		the freezer.state file
 	2) Userspace retries the freezing operation by writing "FROZEN" to
 		the freezer.state file (writing "FREEZING" is not legal
-		and returns EIO)
+		and returns EINVAL)
 	3) The tasks that blocked the cgroup from entering the "FROZEN"
 		state disappear from the cgroup's set of tasks.
diff -puN kernel/cgroup_freezer.c~freezer_cg-disable-writing-freezerstate-of-root-cgroup kernel/cgroup_freezer.c
--- a/kernel/cgroup_freezer.c~freezer_cg-disable-writing-freezerstate-of-root-cgroup
+++ a/kernel/cgroup_freezer.c
@@ -192,6 +192,13 @@ static void freezer_fork(struct cgroup_s
 	 */
 	freezer = task_freezer(task);
 
+	/*
+	 * The root cgroup is non-freezable, so we can skip the
+	 * following check.
+	 */
+	if (!freezer->css.cgroup->parent)
+		return;
+
 	spin_lock_irq(&freezer->lock);
 	BUG_ON(freezer->state == CGROUP_FROZEN);
 
@@ -335,7 +342,7 @@ static int freezer_write(struct cgroup *
 	else if (strcmp(buffer, freezer_state_strs[CGROUP_FROZEN]) == 0)
 		goal_state = CGROUP_FROZEN;
 	else
-		return -EIO;
+		return -EINVAL;
 
 	if (!cgroup_lock_live_group(cgroup))
 		return -ENODEV;
@@ -354,6 +361,8 @@ static struct cftype files[] = {
 
 static int freezer_populate(struct cgroup_subsys *ss, struct cgroup *cgroup)
 {
+	if (!cgroup->parent)
+		return 0;
 	return cgroup_add_files(cgroup, ss, files, ARRAY_SIZE(files));
 }
 
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

cgroups-fix-invalid-cgrp-dentry-before-cgroup-has-been-completely-removed.patch
documentation-kernel-parameterstxt-update-isolcpus-kernel-option.patch
freezer_cg-remove-task_lock-from-freezer_fork.patch
freezer_cg-disable-writing-freezerstate-of-root-cgroup.patch

