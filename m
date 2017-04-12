From: akpm@linux-foundation.org
Subject: [to-be-updated]
 pidns-expose-task-pid_ns_for_children-to-userspace.patch removed from -mm
 tree
Date: Wed, 12 Apr 2017 12:46:00 -0700
Message-ID: <58ee83f8.D53u2/qKMfSEbcNQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51078 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754116AbdDLTqB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Apr 2017 15:46:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ktkhai@virtuozzo.com, agruenba@redhat.com, avagin@virtuozzo.com, ebiederm@xmission.com, gorcunov@openvz.org, keescook@chromium.org, luto@amacapital.net, mingo@kernel.org, mtk.manpages@googlemail.com, oleg@redhat.com, paul@paul-moore.com, serge@hallyn.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: pidns: expose task pid_ns_for_children to userspace
has been removed from the -mm tree.  Its filename was
     pidns-expose-task-pid_ns_for_children-to-userspace.patch

This patch was dropped because an updated version will be merged

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

Link: http://lkml.kernel.org/r/149086967937.4388.471494976517194744.stgit@localhost.localdomain
Signed-off-by: Kirill Tkhai <ktkhai@virtuozzo.com>
Reviewed-by: Cyrill Gorcunov <gorcunov@openvz.org>
Acked-by: Andrei Vagin <avagin@virtuozzo.com>
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
 kernel/pid_namespace.c  |   25 +++++++++++++++++++++++++
 3 files changed, 27 insertions(+)

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
@@ -374,6 +374,20 @@ static struct ns_common *pidns_get(struc
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
+	return ns ? &ns->ns : NULL;
+}
+
 static void pidns_put(struct ns_common *ns)
 {
 	put_pid_ns(to_pid_ns(ns));
@@ -440,6 +454,17 @@ const struct proc_ns_operations pidns_op
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

ns-allow-ns_entries-to-have-custom-symlink-content.patch

