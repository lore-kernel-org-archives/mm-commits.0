From: akpm@linux-foundation.org
Subject: + pid-remove-the-child_reaper-special-case-in-init-mainc.patch added to -mm tree
Date: Mon, 14 Feb 2011 15:52:48 -0800
Message-ID: <201102142352.p1ENqmDK001104@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40743 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753858Ab1BNXxb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Feb 2011 18:53:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, adobriyan@gmail.com, daniel.lezcano@free.fr, oleg@redhat.com


The patch titled
     pid: remove the child_reaper special case in init/main.c
has been added to the -mm tree.  Its filename is
     pid-remove-the-child_reaper-special-case-in-init-mainc.patch

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
Subject: pid: remove the child_reaper special case in init/main.c
From: Eric W. Biederman <ebiederm@xmission.com>

This patchset is a cleanup and a preparation to unshare the pid namespace.
These prerequisites prepare for Eric's patchset to give a file descriptor
to a namespace and join an existing namespace.


This patch:

It turns out that the existing assignment in copy_process of the
child_reaper can handle the initial assignment of child_reaper we just
need to generalize the test in kernel/fork.c

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@free.fr>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pid.h |   11 +++++++++++
 init/main.c         |    9 ---------
 kernel/fork.c       |    2 +-
 3 files changed, 12 insertions(+), 10 deletions(-)

diff -puN include/linux/pid.h~pid-remove-the-child_reaper-special-case-in-init-mainc include/linux/pid.h
--- a/include/linux/pid.h~pid-remove-the-child_reaper-special-case-in-init-mainc
+++ a/include/linux/pid.h
@@ -141,6 +141,17 @@ static inline struct pid_namespace *ns_o
 }
 
 /*
+ * is_child_reaper returns true if the pid is the init process
+ * of the current namespace. As this one could be checked before
+ * pid_ns->child_reaper is assigned in copy_process, we check
+ * with the pid number.
+ */
+static inline bool is_child_reaper(struct pid *pid)
+{
+	return pid->numbers[pid->level].nr == 1;
+}
+
+/*
  * the helpers to get the pid's id seen from different namespaces
  *
  * pid_nr()    : global id, i.e. the id seen from the init namespace;
diff -puN init/main.c~pid-remove-the-child_reaper-special-case-in-init-mainc init/main.c
--- a/init/main.c~pid-remove-the-child_reaper-special-case-in-init-mainc
+++ a/init/main.c
@@ -787,15 +787,6 @@ static int __init kernel_init(void * unu
 	 * init can run on any cpu.
 	 */
 	set_cpus_allowed_ptr(current, cpu_all_mask);
-	/*
-	 * Tell the world that we're going to be the grim
-	 * reaper of innocent orphaned children.
-	 *
-	 * We don't want people to have to make incorrect
-	 * assumptions about where in the task array this
-	 * can be found.
-	 */
-	init_pid_ns.child_reaper = current;
 
 	cad_pid = task_pid(current);
 
diff -puN kernel/fork.c~pid-remove-the-child_reaper-special-case-in-init-mainc kernel/fork.c
--- a/kernel/fork.c~pid-remove-the-child_reaper-special-case-in-init-mainc
+++ a/kernel/fork.c
@@ -1289,7 +1289,7 @@ static struct task_struct *copy_process(
 		tracehook_finish_clone(p, clone_flags, trace);
 
 		if (thread_group_leader(p)) {
-			if (clone_flags & CLONE_NEWPID)
+			if (is_child_reaper(pid))
 				p->nsproxy->pid_ns->child_reaper = p;
 
 			p->signal->leader_pid = pid;
_

Patches currently in -mm which might be from ebiederm@xmission.com are

cgroup-remove-the-ns_cgroup.patch
sysctl_check-drop-table-procname-checks.patch
sysctl_check-drop-dead-code.patch
pid-remove-the-child_reaper-special-case-in-init-mainc.patch
pidns-call-pid_ns_prepare_proc-from-create_pid_namespace.patch
procfs-kill-the-global-proc_mnt-variable.patch
fs-execc-provide-the-correct-process-pid-to-the-pipe-helper.patch
kexec-remove-kmsg_dump_kexec.patch

