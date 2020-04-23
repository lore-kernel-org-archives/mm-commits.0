From: akpm@linux-foundation.org
Subject: [merged]
 proc-allow-to-mount-many-instances-of-proc-in-one-pid-namespace.patch
 removed from -mm tree
Date: Thu, 23 Apr 2020 12:52:11 -0700
Message-ID: <20200423195211.Fw4QHee5b%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726121AbgDWTwN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 23 Apr 2020 15:52:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, akinobu.mita@gmail.com, bfields@fieldses.org, corbet@lwn.net, danielmicay@gmail.com, dhowells@redhat.com, ebiederm@xmission.com, gladkov.alexey@gmail.com, gregkh@linuxfoundation.org, jlayton@poochiereds.net, keescook@chromium.org, ldv@altlinux.org, luto@kernel.org, mingo@kernel.org, mm-commits@vger.kernel.org, oleg@redhat.com, tixxdz@gmail.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: proc: allow to mount many instances of proc in one pid namesp=
ace
has been removed from the -mm tree.  Its filename was
     proc-allow-to-mount-many-instances-of-proc-in-one-pid-namespace.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: Alexey Gladkov <gladkov.alexey@gmail.com>
Subject: proc: allow to mount many instances of proc in one pid namespace

This patch allows to have multiple procfs instances inside the same pid
namespace.  The aim here is lightweight sandboxes, and to allow that we
have to modernize procfs internals.

1) The main aim of this work is to have on embedded systems one
   supervisor for apps.  Right now we have some lightweight sandbox
   support, however if we create pid namespacess we have to manages all
   the processes inside too, where our goal is to be able to run a bunch
   of apps each one inside its own mount namespace without being able to
   notice each other.  We only want to use mount namespaces, and we want
   procfs to behave more like a real mount point.

2) Linux Security Modules have multiple ptrace paths inside some
   subsystems, however inside procfs, the implementation does not
   guarantee that the ptrace() check which triggers the
   security_ptrace_check() hook will always run.  We have the 'hidepid'
   mount option that can be used to force the ptrace_may_access() check
   inside has_pid_permissions() to run.  The problem is that 'hidepid' is
   per pid namespace and not attached to the mount point, any remount or
   modification of 'hidepid' will propagate to all other procfs mounts.

This also does not allow to support Yama LSM easily in desktop and user
sessions.  Yama ptrace scope which restricts ptrace and some other
syscalls to be allowed only on inferiors, can be updated to have a
per-task context, where the context will be inherited during fork(),
clone() and preserved across execve().  If we support multiple private
procfs instances, then we may force the ptrace_may_access() on
/proc/<pids>/ to always run inside that new procfs instances.  This will
allow to specifiy on user sessions if we should populate procfs with pids
that the user can ptrace or not.

By using Yama ptrace scope, some restricted users will only be able to see
inferiors inside /proc, they won't even be able to see their other
processes.  Some software like Chromium, Firefox's crash handler, Wine and
others are already using Yama to restrict which processes can be
ptracable.  With this change this will give the possibility to restrict
/proc/<pids>/ but more importantly this will give desktop users a generic
and usuable way to specifiy which users should see all processes and which
users can not.

Side notes:
* This covers the lack of seccomp where it is not able to parse
arguments, it is easy to install a seccomp filter on direct syscalls
that operate on pids, however /proc/<pid>/ is a Linux ABI using
filesystem syscalls. With this change LSMs should be able to analyze
open/read/write/close...

In the new patch set version I removed the 'newinstance' option
as suggested by Eric W. Biederman.

Selftest has been added to verify new behavior.

Link: http://lkml.kernel.org/r/20200419141057.621356-3-gladkov.alexey@gmail=
.com
Signed-off-by: Alexey Gladkov <gladkov.alexey@gmail.com>
Reviewed-by: Alexey Dobriyan <adobriyan@gmail.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Daniel Micay <danielmicay@gmail.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Djalal Harouni <tixxdz@gmail.com>
Cc: "Dmitry V . Levin" <ldv@altlinux.org>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: "J . Bruce Fields" <bfields@fieldses.org>
Cc: Jeff Layton <jlayton@poochiereds.net>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c                                      |   31 +++---
 fs/proc/inode.c                                     |   11 +-
 fs/proc/root.c                                      |   49 ++++------
 fs/proc/self.c                                      |    6 -
 fs/proc/thread_self.c                               |    6 -
 include/linux/pid_namespace.h                       |   12 --
 include/linux/proc_fs.h                             |   22 ++++
 tools/testing/selftests/proc/.gitignore             |    1=20
 tools/testing/selftests/proc/Makefile               |    1=20
 tools/testing/selftests/proc/proc-multiple-procfs.c |   48 +++++++++
 10 files changed, 124 insertions(+), 63 deletions(-)

--- a/fs/proc/base.c~proc-allow-to-mount-many-instances-of-proc-in-one-pid-=
namespace
+++ a/fs/proc/base.c
@@ -697,13 +697,13 @@ int proc_setattr(struct dentry *dentry,
  * May current process learn task's sched/cmdline info (for hide_pid_min=
=3D1)
  * or euid/egid (for hide_pid_min=3D2)?
  */
-static bool has_pid_permissions(struct pid_namespace *pid,
+static bool has_pid_permissions(struct proc_fs_info *fs_info,
 				 struct task_struct *task,
 				 int hide_pid_min)
 {
-	if (pid->hide_pid < hide_pid_min)
+	if (fs_info->hide_pid < hide_pid_min)
 		return true;
-	if (in_group_p(pid->pid_gid))
+	if (in_group_p(fs_info->pid_gid))
 		return true;
 	return ptrace_may_access(task, PTRACE_MODE_READ_FSCREDS);
 }
@@ -711,18 +711,18 @@ static bool has_pid_permissions(struct p
=20
 static int proc_pid_permission(struct inode *inode, int mask)
 {
-	struct pid_namespace *pid =3D proc_pid_ns(inode);
+	struct proc_fs_info *fs_info =3D proc_sb_info(inode->i_sb);
 	struct task_struct *task;
 	bool has_perms;
=20
 	task =3D get_proc_task(inode);
 	if (!task)
 		return -ESRCH;
-	has_perms =3D has_pid_permissions(pid, task, HIDEPID_NO_ACCESS);
+	has_perms =3D has_pid_permissions(fs_info, task, HIDEPID_NO_ACCESS);
 	put_task_struct(task);
=20
 	if (!has_perms) {
-		if (pid->hide_pid =3D=3D HIDEPID_INVISIBLE) {
+		if (fs_info->hide_pid =3D=3D HIDEPID_INVISIBLE) {
 			/*
 			 * Let's make getdents(), stat(), and open()
 			 * consistent with each other.  If a process
@@ -1909,7 +1909,7 @@ int pid_getattr(const struct path *path,
 		u32 request_mask, unsigned int query_flags)
 {
 	struct inode *inode =3D d_inode(path->dentry);
-	struct pid_namespace *pid =3D proc_pid_ns(inode);
+	struct proc_fs_info *fs_info =3D proc_sb_info(inode->i_sb);
 	struct task_struct *task;
=20
 	generic_fillattr(inode, stat);
@@ -1919,7 +1919,7 @@ int pid_getattr(const struct path *path,
 	rcu_read_lock();
 	task =3D pid_task(proc_pid(inode), PIDTYPE_PID);
 	if (task) {
-		if (!has_pid_permissions(pid, task, HIDEPID_INVISIBLE)) {
+		if (!has_pid_permissions(fs_info, task, HIDEPID_INVISIBLE)) {
 			rcu_read_unlock();
 			/*
 			 * This doesn't prevent learning whether PID exists,
@@ -3313,6 +3313,7 @@ struct dentry *proc_pid_lookup(struct de
 {
 	struct task_struct *task;
 	unsigned tgid;
+	struct proc_fs_info *fs_info;
 	struct pid_namespace *ns;
 	struct dentry *result =3D ERR_PTR(-ENOENT);
=20
@@ -3320,7 +3321,8 @@ struct dentry *proc_pid_lookup(struct de
 	if (tgid =3D=3D ~0U)
 		goto out;
=20
-	ns =3D dentry->d_sb->s_fs_info;
+	fs_info =3D proc_sb_info(dentry->d_sb);
+	ns =3D fs_info->pid_ns;
 	rcu_read_lock();
 	task =3D find_task_by_pid_ns(tgid, ns);
 	if (task)
@@ -3384,6 +3386,7 @@ retry:
 int proc_pid_readdir(struct file *file, struct dir_context *ctx)
 {
 	struct tgid_iter iter;
+	struct proc_fs_info *fs_info =3D proc_sb_info(file_inode(file)->i_sb);
 	struct pid_namespace *ns =3D proc_pid_ns(file_inode(file));
 	loff_t pos =3D ctx->pos;
=20
@@ -3391,13 +3394,13 @@ int proc_pid_readdir(struct file *file,
 		return 0;
=20
 	if (pos =3D=3D TGID_OFFSET - 2) {
-		struct inode *inode =3D d_inode(ns->proc_self);
+		struct inode *inode =3D d_inode(fs_info->proc_self);
 		if (!dir_emit(ctx, "self", 4, inode->i_ino, DT_LNK))
 			return 0;
 		ctx->pos =3D pos =3D pos + 1;
 	}
 	if (pos =3D=3D TGID_OFFSET - 1) {
-		struct inode *inode =3D d_inode(ns->proc_thread_self);
+		struct inode *inode =3D d_inode(fs_info->proc_thread_self);
 		if (!dir_emit(ctx, "thread-self", 11, inode->i_ino, DT_LNK))
 			return 0;
 		ctx->pos =3D pos =3D pos + 1;
@@ -3411,7 +3414,7 @@ int proc_pid_readdir(struct file *file,
 		unsigned int len;
=20
 		cond_resched();
-		if (!has_pid_permissions(ns, iter.task, HIDEPID_INVISIBLE))
+		if (!has_pid_permissions(fs_info, iter.task, HIDEPID_INVISIBLE))
 			continue;
=20
 		len =3D snprintf(name, sizeof(name), "%u", iter.tgid);
@@ -3611,6 +3614,7 @@ static struct dentry *proc_task_lookup(s
 	struct task_struct *task;
 	struct task_struct *leader =3D get_proc_task(dir);
 	unsigned tid;
+	struct proc_fs_info *fs_info;
 	struct pid_namespace *ns;
 	struct dentry *result =3D ERR_PTR(-ENOENT);
=20
@@ -3621,7 +3625,8 @@ static struct dentry *proc_task_lookup(s
 	if (tid =3D=3D ~0U)
 		goto out;
=20
-	ns =3D dentry->d_sb->s_fs_info;
+	fs_info =3D proc_sb_info(dentry->d_sb);
+	ns =3D fs_info->pid_ns;
 	rcu_read_lock();
 	task =3D find_task_by_pid_ns(tid, ns);
 	if (task)
--- a/fs/proc/inode.c~proc-allow-to-mount-many-instances-of-proc-in-one-pid=
-namespace
+++ a/fs/proc/inode.c
@@ -167,13 +167,12 @@ void proc_invalidate_siblings_dcache(str
=20
 static int proc_show_options(struct seq_file *seq, struct dentry *root)
 {
-	struct super_block *sb =3D root->d_sb;
-	struct pid_namespace *pid =3D sb->s_fs_info;
+	struct proc_fs_info *fs_info =3D proc_sb_info(root->d_sb);
=20
-	if (!gid_eq(pid->pid_gid, GLOBAL_ROOT_GID))
-		seq_printf(seq, ",gid=3D%u", from_kgid_munged(&init_user_ns, pid->pid_gi=
d));
-	if (pid->hide_pid !=3D HIDEPID_OFF)
-		seq_printf(seq, ",hidepid=3D%u", pid->hide_pid);
+	if (!gid_eq(fs_info->pid_gid, GLOBAL_ROOT_GID))
+		seq_printf(seq, ",gid=3D%u", from_kgid_munged(&init_user_ns, fs_info->pi=
d_gid));
+	if (fs_info->hide_pid !=3D HIDEPID_OFF)
+		seq_printf(seq, ",hidepid=3D%u", fs_info->hide_pid);
=20
 	return 0;
 }
--- a/fs/proc/root.c~proc-allow-to-mount-many-instances-of-proc-in-one-pid-=
namespace
+++ a/fs/proc/root.c
@@ -77,26 +77,31 @@ static int proc_parse_param(struct fs_co
 	return 0;
 }
=20
-static void proc_apply_options(struct super_block *s,
+static void proc_apply_options(struct proc_fs_info *fs_info,
 			       struct fs_context *fc,
-			       struct pid_namespace *pid_ns,
 			       struct user_namespace *user_ns)
 {
 	struct proc_fs_context *ctx =3D fc->fs_private;
=20
 	if (ctx->mask & (1 << Opt_gid))
-		pid_ns->pid_gid =3D make_kgid(user_ns, ctx->gid);
+		fs_info->pid_gid =3D make_kgid(user_ns, ctx->gid);
 	if (ctx->mask & (1 << Opt_hidepid))
-		pid_ns->hide_pid =3D ctx->hidepid;
+		fs_info->hide_pid =3D ctx->hidepid;
 }
=20
 static int proc_fill_super(struct super_block *s, struct fs_context *fc)
 {
-	struct pid_namespace *pid_ns =3D get_pid_ns(s->s_fs_info);
+	struct proc_fs_context *ctx =3D fc->fs_private;
 	struct inode *root_inode;
+	struct proc_fs_info *fs_info;
 	int ret;
=20
-	proc_apply_options(s, fc, pid_ns, current_user_ns());
+	fs_info =3D kzalloc(sizeof(*fs_info), GFP_KERNEL);
+	if (!fs_info)
+		return -ENOMEM;
+
+	fs_info->pid_ns =3D get_pid_ns(ctx->pid_ns);
+	proc_apply_options(fs_info, fc, current_user_ns());
=20
 	/* User space would break if executables or devices appear on proc */
 	s->s_iflags |=3D SB_I_USERNS_VISIBLE | SB_I_NOEXEC | SB_I_NODEV;
@@ -106,6 +111,7 @@ static int proc_fill_super(struct super_
 	s->s_magic =3D PROC_SUPER_MAGIC;
 	s->s_op =3D &proc_sops;
 	s->s_time_gran =3D 1;
+	s->s_fs_info =3D fs_info;
=20
 	/*
 	 * procfs isn't actually a stacking filesystem; however, there is
@@ -113,7 +119,7 @@ static int proc_fill_super(struct super_
 	 * top of it
 	 */
 	s->s_stack_depth =3D FILESYSTEM_MAX_STACK_DEPTH;
-=09
+
 	/* procfs dentries and inodes don't require IO to create */
 	s->s_shrink.seeks =3D 0;
=20
@@ -140,19 +146,17 @@ static int proc_fill_super(struct super_
 static int proc_reconfigure(struct fs_context *fc)
 {
 	struct super_block *sb =3D fc->root->d_sb;
-	struct pid_namespace *pid =3D sb->s_fs_info;
+	struct proc_fs_info *fs_info =3D proc_sb_info(sb);
=20
 	sync_filesystem(sb);
=20
-	proc_apply_options(sb, fc, pid, current_user_ns());
+	proc_apply_options(fs_info, fc, current_user_ns());
 	return 0;
 }
=20
 static int proc_get_tree(struct fs_context *fc)
 {
-	struct proc_fs_context *ctx =3D fc->fs_private;
-
-	return get_tree_keyed(fc, proc_fill_super, ctx->pid_ns);
+	return get_tree_nodev(fc, proc_fill_super);
 }
=20
 static void proc_fs_context_free(struct fs_context *fc)
@@ -188,22 +192,17 @@ static int proc_init_fs_context(struct f
=20
 static void proc_kill_sb(struct super_block *sb)
 {
-	struct pid_namespace *ns;
+	struct proc_fs_info *fs_info =3D proc_sb_info(sb);
=20
-	ns =3D (struct pid_namespace *)sb->s_fs_info;
-	if (ns->proc_self)
-		dput(ns->proc_self);
-	if (ns->proc_thread_self)
-		dput(ns->proc_thread_self);
-	kill_anon_super(sb);
+	if (fs_info->proc_self)
+		dput(fs_info->proc_self);
=20
-	/* Make the pid namespace safe for the next mount of proc */
-	ns->proc_self =3D NULL;
-	ns->proc_thread_self =3D NULL;
-	ns->pid_gid =3D GLOBAL_ROOT_GID;
-	ns->hide_pid =3D 0;
+	if (fs_info->proc_thread_self)
+		dput(fs_info->proc_thread_self);
=20
-	put_pid_ns(ns);
+	kill_anon_super(sb);
+	put_pid_ns(fs_info->pid_ns);
+	kfree(fs_info);
 }
=20
 static struct file_system_type proc_fs_type =3D {
--- a/fs/proc/self.c~proc-allow-to-mount-many-instances-of-proc-in-one-pid-=
namespace
+++ a/fs/proc/self.c
@@ -36,10 +36,10 @@ static unsigned self_inum __ro_after_ini
 int proc_setup_self(struct super_block *s)
 {
 	struct inode *root_inode =3D d_inode(s->s_root);
-	struct pid_namespace *ns =3D proc_pid_ns(root_inode);
+	struct proc_fs_info *fs_info =3D proc_sb_info(s);
 	struct dentry *self;
 	int ret =3D -ENOMEM;
-=09
+
 	inode_lock(root_inode);
 	self =3D d_alloc_name(s->s_root, "self");
 	if (self) {
@@ -62,7 +62,7 @@ int proc_setup_self(struct super_block *
 	if (ret)
 		pr_err("proc_fill_super: can't allocate /proc/self\n");
 	else
-		ns->proc_self =3D self;
+		fs_info->proc_self =3D self;
=20
 	return ret;
 }
--- a/fs/proc/thread_self.c~proc-allow-to-mount-many-instances-of-proc-in-o=
ne-pid-namespace
+++ a/fs/proc/thread_self.c
@@ -36,7 +36,7 @@ static unsigned thread_self_inum __ro_af
 int proc_setup_thread_self(struct super_block *s)
 {
 	struct inode *root_inode =3D d_inode(s->s_root);
-	struct pid_namespace *ns =3D proc_pid_ns(root_inode);
+	struct proc_fs_info *fs_info =3D proc_sb_info(s);
 	struct dentry *thread_self;
 	int ret =3D -ENOMEM;
=20
@@ -60,9 +60,9 @@ int proc_setup_thread_self(struct super_
 	inode_unlock(root_inode);
=20
 	if (ret)
-		pr_err("proc_fill_super: can't allocate /proc/thread_self\n");
+		pr_err("proc_fill_super: can't allocate /proc/thread-self\n");
 	else
-		ns->proc_thread_self =3D thread_self;
+		fs_info->proc_thread_self =3D thread_self;
=20
 	return ret;
 }
--- a/include/linux/pid_namespace.h~proc-allow-to-mount-many-instances-of-p=
roc-in-one-pid-namespace
+++ a/include/linux/pid_namespace.h
@@ -17,12 +17,6 @@
=20
 struct fs_pin;
=20
-enum { /* definitions for pid_namespace's hide_pid field */
-	HIDEPID_OFF	  =3D 0,
-	HIDEPID_NO_ACCESS =3D 1,
-	HIDEPID_INVISIBLE =3D 2,
-};
-
 struct pid_namespace {
 	struct kref kref;
 	struct idr idr;
@@ -32,17 +26,11 @@ struct pid_namespace {
 	struct kmem_cache *pid_cachep;
 	unsigned int level;
 	struct pid_namespace *parent;
-#ifdef CONFIG_PROC_FS
-	struct dentry *proc_self;
-	struct dentry *proc_thread_self;
-#endif
 #ifdef CONFIG_BSD_PROCESS_ACCT
 	struct fs_pin *bacct;
 #endif
 	struct user_namespace *user_ns;
 	struct ucounts *ucounts;
-	kgid_t pid_gid;
-	int hide_pid;
 	int reboot;	/* group exit code if this pidns was rebooted */
 	struct ns_common ns;
 } __randomize_layout;
--- a/include/linux/proc_fs.h~proc-allow-to-mount-many-instances-of-proc-in=
-one-pid-namespace
+++ a/include/linux/proc_fs.h
@@ -42,6 +42,26 @@ struct proc_ops {
 	unsigned long (*proc_get_unmapped_area)(struct file *, unsigned long, uns=
igned long, unsigned long, unsigned long);
 } __randomize_layout;
=20
+/* definitions for hide_pid field */
+enum {
+	HIDEPID_OFF	  =3D 0,
+	HIDEPID_NO_ACCESS =3D 1,
+	HIDEPID_INVISIBLE =3D 2,
+};
+
+struct proc_fs_info {
+	struct pid_namespace *pid_ns;
+	struct dentry *proc_self;        /* For /proc/self */
+	struct dentry *proc_thread_self; /* For /proc/thread-self */
+	kgid_t pid_gid;
+	int hide_pid;
+};
+
+static inline struct proc_fs_info *proc_sb_info(struct super_block *sb)
+{
+	return sb->s_fs_info;
+}
+
 #ifdef CONFIG_PROC_FS
=20
 typedef int (*proc_write_t)(struct file *, char *, size_t);
@@ -176,7 +196,7 @@ int open_related_ns(struct ns_common *ns
 /* get the associated pid namespace for a file in procfs */
 static inline struct pid_namespace *proc_pid_ns(const struct inode *inode)
 {
-	return inode->i_sb->s_fs_info;
+	return proc_sb_info(inode->i_sb)->pid_ns;
 }
=20
 #endif /* _LINUX_PROC_FS_H */
--- a/tools/testing/selftests/proc/.gitignore~proc-allow-to-mount-many-inst=
ances-of-proc-in-one-pid-namespace
+++ a/tools/testing/selftests/proc/.gitignore
@@ -3,6 +3,7 @@
 /fd-002-posix-eq
 /fd-003-kthread
 /proc-loadavg-001
+/proc-multiple-procfs
 /proc-pid-vm
 /proc-self-map-files-001
 /proc-self-map-files-002
--- a/tools/testing/selftests/proc/Makefile~proc-allow-to-mount-many-instan=
ces-of-proc-in-one-pid-namespace
+++ a/tools/testing/selftests/proc/Makefile
@@ -19,5 +19,6 @@ TEST_GEN_PROGS +=3D self
 TEST_GEN_PROGS +=3D setns-dcache
 TEST_GEN_PROGS +=3D setns-sysvipc
 TEST_GEN_PROGS +=3D thread-self
+TEST_GEN_PROGS +=3D proc-multiple-procfs
=20
 include ../lib.mk
--- /dev/null
+++ a/tools/testing/selftests/proc/proc-multiple-procfs.c
@@ -0,0 +1,48 @@
+/*
+ * Copyright =C2=A9 2020 Alexey Gladkov <gladkov.alexey@gmail.com>
+ *
+ * Permission to use, copy, modify, and distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+#include <assert.h>
+#include <stdlib.h>
+#include <stdio.h>
+#include <sys/mount.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+
+int main(void)
+{
+	struct stat proc_st1, proc_st2;
+	char procbuff[] =3D "/tmp/proc.XXXXXX/meminfo";
+	char procdir1[] =3D "/tmp/proc.XXXXXX";
+	char procdir2[] =3D "/tmp/proc.XXXXXX";
+
+	assert(mkdtemp(procdir1) !=3D NULL);
+	assert(mkdtemp(procdir2) !=3D NULL);
+
+	assert(!mount("proc", procdir1, "proc", 0, "hidepid=3D1"));
+	assert(!mount("proc", procdir2, "proc", 0, "hidepid=3D2"));
+
+	snprintf(procbuff, sizeof(procbuff), "%s/meminfo", procdir1);
+	assert(!stat(procbuff, &proc_st1));
+
+	snprintf(procbuff, sizeof(procbuff), "%s/meminfo", procdir2);
+	assert(!stat(procbuff, &proc_st2));
+
+	umount(procdir1);
+	umount(procdir2);
+
+	assert(proc_st1.st_dev !=3D proc_st2.st_dev);
+
+	return 0;
+}
_

Patches currently in -mm which might be from gladkov.alexey@gmail.com are
