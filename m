From: akpm@linux-foundation.org
Subject: [merged]
 pidns-expose-task-pid_ns_for_children-to-userspace.patch removed from -mm
 tree
Date: Tue, 09 May 2017 11:02:01 -0700
Message-ID: <20170509180201.CqyEBIQpU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34556 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753907AbdEISCC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 9 May 2017 14:02:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: agruenba@redhat.com, avagin@virtuozzo.com, ebiederm@xmission.com, keescook@chromium.org, ktkhai@virtuozzo.com, luto@amacapital.net, mingo@kernel.org, mm-commits@vger.kernel.org, mtk.manpages@googlemail.com, oleg@redhat.com, paul@paul-moore.com, serge@hallyn.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: pidns: expose task pid_ns_for_children to userspace
has been removed from the -mm tree.  Its filename was
     pidns-expose-task-pid_ns_for_children-to-userspace.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kirill Tkhai <ktkhai@virtuozzo.com>
Subject: pidns: expose task pid_ns_for_children to userspace

pid_ns_for_children set by a task is known only to the task itself, and
it's impossible to identify it from outside.

It's a big problem for checkpoint/restore software like CRIU, because it
can't correctly handle tasks, that do setns(CLONE_NEWPID) in proccess of
their work.

This patch solves the problem, and it exposes pid_ns_for_children to ns
directory in standard way with the name "pid_for_children":

~# ls /proc/5531/ns -l | grep pid
lrwxrwxrwx 1 root root 0 Jan 14 16:38 pid -> pid:[4026531836]
lrwxrwxrwx 1 root root 0 Jan 14 16:38 pid_for_children -> pid:[4026532286]

Link: http://lkml.kernel.org/r/149201123914.6007.2187327078064239572.stgit@localhost.localdomain
Signed-off-by: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: Andrei Vagin <avagin@virtuozzo.com>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Serge Hallyn <serge@hallyn.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/namespaces.c    |    1 +
 include/linux/proc_ns.h |    1 +
 kernel/pid_namespace.c  |   34 ++++++++++++++++++++++++++++++++++
 3 files changed, 36 insertions(+)

diff -puN fs/proc/namespaces.c~pidns-expose-task-pid_ns_for_children-to-userspace fs/proc/namespaces.c
--- a/fs/proc/namespaces.c~pidns-expose-task-pid_ns_for_children-to-userspace
+++ a/fs/proc/namespaces.c
@@ -23,6 +23,7 @@ static const struct proc_ns_operations *
 #endif
 #ifdef CONFIG_PID_NS
 	&pidns_operations,
+	&pidns_for_children_operations,
 #endif
 #ifdef CONFIG_USER_NS
 	&userns_operations,
diff -puN include/linux/proc_ns.h~pidns-expose-task-pid_ns_for_children-to-userspace include/linux/proc_ns.h
--- a/include/linux/proc_ns.h~pidns-expose-task-pid_ns_for_children-to-userspace
+++ a/include/linux/proc_ns.h
@@ -27,6 +27,7 @@ extern const struct proc_ns_operations n
 extern const struct proc_ns_operations utsns_operations;
 extern const struct proc_ns_operations ipcns_operations;
 extern const struct proc_ns_operations pidns_operations;
+extern const struct proc_ns_operations pidns_for_children_operations;
 extern const struct proc_ns_operations userns_operations;
 extern const struct proc_ns_operations mntns_operations;
 extern const struct proc_ns_operations cgroupns_operations;
diff -puN kernel/pid_namespace.c~pidns-expose-task-pid_ns_for_children-to-userspace kernel/pid_namespace.c
--- a/kernel/pid_namespace.c~pidns-expose-task-pid_ns_for_children-to-userspace
+++ a/kernel/pid_namespace.c
@@ -374,6 +374,29 @@ static struct ns_common *pidns_get(struc
 	return ns ? &ns->ns : NULL;
 }
 
+static struct ns_common *pidns_for_children_get(struct task_struct *task)
+{
+	struct pid_namespace *ns = NULL;
+
+	task_lock(task);
+	if (task->nsproxy) {
+		ns = task->nsproxy->pid_ns_for_children;
+		get_pid_ns(ns);
+	}
+	task_unlock(task);
+
+	if (ns) {
+		read_lock(&tasklist_lock);
+		if (!ns->child_reaper) {
+			put_pid_ns(ns);
+			ns = NULL;
+		}
+		read_unlock(&tasklist_lock);
+	}
+
+	return ns ? &ns->ns : NULL;
+}
+
 static void pidns_put(struct ns_common *ns)
 {
 	put_pid_ns(to_pid_ns(ns));
@@ -440,6 +463,17 @@ const struct proc_ns_operations pidns_op
 	.put		= pidns_put,
 	.install	= pidns_install,
 	.owner		= pidns_owner,
+	.get_parent	= pidns_get_parent,
+};
+
+const struct proc_ns_operations pidns_for_children_operations = {
+	.name		= "pid_for_children",
+	.real_ns_name	= "pid",
+	.type		= CLONE_NEWPID,
+	.get		= pidns_for_children_get,
+	.put		= pidns_put,
+	.install	= pidns_install,
+	.owner		= pidns_owner,
 	.get_parent	= pidns_get_parent,
 };
 
_

Patches currently in -mm which might be from ktkhai@virtuozzo.com are


