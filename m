From: akpm@linux-foundation.org
Subject: [to-be-updated]
 ns-allow-ns_entries-to-have-custom-symlink-content.patch removed from -mm
 tree
Date: Wed, 12 Apr 2017 12:46:30 -0700
Message-ID: <58ee8416.ugjcNccHCBSS89wk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51116 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754116AbdDLTqc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Apr 2017 15:46:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ktkhai@virtuozzo.com, agruenba@redhat.com, avagin@virtuozzo.com, ebiederm@xmission.com, gorcunov@openvz.org, keescook@chromium.org, luto@amacapital.net, mingo@kernel.org, mtk.manpages@googlemail.com, oleg@redhat.com, paul@paul-moore.com, serge@hallyn.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/nsfs.c: allow ns_entries to have custom symlink content
has been removed from the -mm tree.  Its filename was
     ns-allow-ns_entries-to-have-custom-symlink-content.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Kirill Tkhai <ktkhai@virtuozzo.com>
Subject: fs/nsfs.c: allow ns_entries to have custom symlink content

Patch series "Expose task pid_ns_for_children to userspace".

pid_ns_for_children set by a task is known only to the task itself, and
it's impossible to identify it from outside.

It's a big problem for checkpoint/restore software like CRIU, because it
can't correctly handle tasks, that do setns(CLONE_NEWPID) in proccess of
their work.  If they have a custom pid_ns_for_children before dump, they
must have the same ns after restore.  Otherwise, restored task bumped into
enviroment it does not expect.

This patchset solves the problem.  It exposes pid_ns_for_children to ns
directory in standard way with the name "pid_for_children":

~# ls /proc/5531/ns -l | grep pid
lrwxrwxrwx 1 root root 0 Jan 14 16:38 pid -> pid:[4026531836]
lrwxrwxrwx 1 root root 0 Jan 14 16:38 pid_for_children -> pid:[4026532286]


This patch (of 2):

Make it possible to have link content prefix yyy different from the link
name xxx:

$ readlink /proc/[pid]/ns/xxx
yyy:[4026531838]

This will be used in the patch "pidns: expose task pid_ns_for_children to
userspace".

Link: http://lkml.kernel.org/r/149086966919.4388.10564546347286785860.stgit@localhost.localdomain
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

 fs/nsfs.c               |    4 +++-
 include/linux/proc_ns.h |    1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

diff -puN fs/nsfs.c~ns-allow-ns_entries-to-have-custom-symlink-content fs/nsfs.c
--- a/fs/nsfs.c~ns-allow-ns_entries-to-have-custom-symlink-content
+++ a/fs/nsfs.c
@@ -195,9 +195,11 @@ int ns_get_name(char *buf, size_t size,
 {
 	struct ns_common *ns;
 	int res = -ENOENT;
+	const char *name;
 	ns = ns_ops->get(task);
 	if (ns) {
-		res = snprintf(buf, size, "%s:[%u]", ns_ops->name, ns->inum);
+		name = ns_ops->real_ns_name ? : ns_ops->name;
+		res = snprintf(buf, size, "%s:[%u]", name, ns->inum);
 		ns_ops->put(ns);
 	}
 	return res;
diff -puN include/linux/proc_ns.h~ns-allow-ns_entries-to-have-custom-symlink-content include/linux/proc_ns.h
--- a/include/linux/proc_ns.h~ns-allow-ns_entries-to-have-custom-symlink-content
+++ a/include/linux/proc_ns.h
@@ -14,6 +14,7 @@ struct inode;
 
 struct proc_ns_operations {
 	const char *name;
+	const char *real_ns_name;
 	int type;
 	struct ns_common *(*get)(struct task_struct *task);
 	void (*put)(struct ns_common *ns);
_

Patches currently in -mm which might be from ktkhai@virtuozzo.com are


