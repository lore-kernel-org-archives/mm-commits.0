From: akpm@linux-foundation.org
Subject: [merged]
 fs-coredump-prevent-fsuid=0-dumps-into-user-controlled-directories.patch
 removed from -mm tree
Date: Wed, 23 Mar 2016 10:41:07 -0700
Message-ID: <56f2d533.zo55tPPoRNPjzqXY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59132 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756516AbcCWRlI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2016 13:41:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jann@thejh.net, ebiederm@xmission.com, keescook@chromium.org, luto@kernel.org, oleg@redhat.com, stable@vger.kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/coredump: prevent fsuid=0 dumps into user-controlled directories
has been removed from the -mm tree.  Its filename was
     fs-coredump-prevent-fsuid=0-dumps-into-user-controlled-directories.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jann Horn <jann@thejh.net>
Subject: fs/coredump: prevent fsuid=0 dumps into user-controlled directories

This commit fixes the following security hole affecting systems where all
of the following conditions are fulfilled:

 - The fs.suid_dumpable sysctl is set to 2.
 - The kernel.core_pattern sysctl's value starts with "/". (Systems
   where kernel.core_pattern starts with "|/" are not affected.)
 - Unprivileged user namespace creation is permitted. (This is
   true on Linux >=3.8, but some distributions disallow it by
   default using a distro patch.)

Under these conditions, if a program executes under secure exec rules,
causing it to run with the SUID_DUMP_ROOT flag, then unshares its user
namespace, changes its root directory and crashes, the coredump will be
written using fsuid=0 and a path derived from kernel.core_pattern - but
this path is interpreted relative to the root directory of the process,
allowing the attacker to control where a coredump will be written with
root privileges.

To fix the security issue, always interpret core_pattern for dumps that
are written under SUID_DUMP_ROOT relative to the root directory of init.

Signed-off-by: Jann Horn <jann@thejh.net>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/mconsole_kern.c |    2 +-
 fs/coredump.c                   |   30 ++++++++++++++++++++++++++----
 fs/fhandle.c                    |    2 +-
 fs/open.c                       |    6 ++----
 include/linux/fs.h              |    2 +-
 kernel/sysctl_binary.c          |    2 +-
 6 files changed, 32 insertions(+), 12 deletions(-)

diff -puN arch/um/drivers/mconsole_kern.c~fs-coredump-prevent-fsuid=0-dumps-into-user-controlled-directories arch/um/drivers/mconsole_kern.c
--- a/arch/um/drivers/mconsole_kern.c~fs-coredump-prevent-fsuid=0-dumps-into-user-controlled-directories
+++ a/arch/um/drivers/mconsole_kern.c
@@ -133,7 +133,7 @@ void mconsole_proc(struct mc_request *re
 	ptr += strlen("proc");
 	ptr = skip_spaces(ptr);
 
-	file = file_open_root(mnt->mnt_root, mnt, ptr, O_RDONLY);
+	file = file_open_root(mnt->mnt_root, mnt, ptr, O_RDONLY, 0);
 	if (IS_ERR(file)) {
 		mconsole_reply(req, "Failed to open file", 1, 0);
 		printk(KERN_ERR "open /proc/%s: %ld\n", ptr, PTR_ERR(file));
diff -puN fs/coredump.c~fs-coredump-prevent-fsuid=0-dumps-into-user-controlled-directories fs/coredump.c
--- a/fs/coredump.c~fs-coredump-prevent-fsuid=0-dumps-into-user-controlled-directories
+++ a/fs/coredump.c
@@ -32,6 +32,9 @@
 #include <linux/pipe_fs_i.h>
 #include <linux/oom.h>
 #include <linux/compat.h>
+#include <linux/sched.h>
+#include <linux/fs.h>
+#include <linux/path.h>
 #include <linux/timekeeping.h>
 
 #include <asm/uaccess.h>
@@ -649,6 +652,8 @@ void do_coredump(const siginfo_t *siginf
 		}
 	} else {
 		struct inode *inode;
+		int open_flags = O_CREAT | O_RDWR | O_NOFOLLOW |
+				 O_LARGEFILE | O_EXCL;
 
 		if (cprm.limit < binfmt->min_coredump)
 			goto fail_unlock;
@@ -687,10 +692,27 @@ void do_coredump(const siginfo_t *siginf
 		 * what matters is that at least one of the two processes
 		 * writes its coredump successfully, not which one.
 		 */
-		cprm.file = filp_open(cn.corename,
-				 O_CREAT | 2 | O_NOFOLLOW |
-				 O_LARGEFILE | O_EXCL,
-				 0600);
+		if (need_suid_safe) {
+			/*
+			 * Using user namespaces, normal user tasks can change
+			 * their current->fs->root to point to arbitrary
+			 * directories. Since the intention of the "only dump
+			 * with a fully qualified path" rule is to control where
+			 * coredumps may be placed using root privileges,
+			 * current->fs->root must not be used. Instead, use the
+			 * root directory of init_task.
+			 */
+			struct path root;
+
+			task_lock(&init_task);
+			get_fs_root(init_task.fs, &root);
+			task_unlock(&init_task);
+			cprm.file = file_open_root(root.dentry, root.mnt,
+				cn.corename, open_flags, 0600);
+			path_put(&root);
+		} else {
+			cprm.file = filp_open(cn.corename, open_flags, 0600);
+		}
 		if (IS_ERR(cprm.file))
 			goto fail_unlock;
 
diff -puN fs/fhandle.c~fs-coredump-prevent-fsuid=0-dumps-into-user-controlled-directories fs/fhandle.c
--- a/fs/fhandle.c~fs-coredump-prevent-fsuid=0-dumps-into-user-controlled-directories
+++ a/fs/fhandle.c
@@ -228,7 +228,7 @@ long do_handle_open(int mountdirfd,
 		path_put(&path);
 		return fd;
 	}
-	file = file_open_root(path.dentry, path.mnt, "", open_flag);
+	file = file_open_root(path.dentry, path.mnt, "", open_flag, 0);
 	if (IS_ERR(file)) {
 		put_unused_fd(fd);
 		retval =  PTR_ERR(file);
diff -puN fs/open.c~fs-coredump-prevent-fsuid=0-dumps-into-user-controlled-directories fs/open.c
--- a/fs/open.c~fs-coredump-prevent-fsuid=0-dumps-into-user-controlled-directories
+++ a/fs/open.c
@@ -992,14 +992,12 @@ struct file *filp_open(const char *filen
 EXPORT_SYMBOL(filp_open);
 
 struct file *file_open_root(struct dentry *dentry, struct vfsmount *mnt,
-			    const char *filename, int flags)
+			    const char *filename, int flags, umode_t mode)
 {
 	struct open_flags op;
-	int err = build_open_flags(flags, 0, &op);
+	int err = build_open_flags(flags, mode, &op);
 	if (err)
 		return ERR_PTR(err);
-	if (flags & O_CREAT)
-		return ERR_PTR(-EINVAL);
 	return do_file_open_root(dentry, mnt, filename, &op);
 }
 EXPORT_SYMBOL(file_open_root);
diff -puN include/linux/fs.h~fs-coredump-prevent-fsuid=0-dumps-into-user-controlled-directories include/linux/fs.h
--- a/include/linux/fs.h~fs-coredump-prevent-fsuid=0-dumps-into-user-controlled-directories
+++ a/include/linux/fs.h
@@ -2263,7 +2263,7 @@ extern long do_sys_open(int dfd, const c
 extern struct file *file_open_name(struct filename *, int, umode_t);
 extern struct file *filp_open(const char *, int, umode_t);
 extern struct file *file_open_root(struct dentry *, struct vfsmount *,
-				   const char *, int);
+				   const char *, int, umode_t);
 extern struct file * dentry_open(const struct path *, int, const struct cred *);
 extern int filp_close(struct file *, fl_owner_t id);
 
diff -puN kernel/sysctl_binary.c~fs-coredump-prevent-fsuid=0-dumps-into-user-controlled-directories kernel/sysctl_binary.c
--- a/kernel/sysctl_binary.c~fs-coredump-prevent-fsuid=0-dumps-into-user-controlled-directories
+++ a/kernel/sysctl_binary.c
@@ -1321,7 +1321,7 @@ static ssize_t binary_sysctl(const int *
 	}
 
 	mnt = task_active_pid_ns(current)->proc_mnt;
-	file = file_open_root(mnt->mnt_root, mnt, pathname, flags);
+	file = file_open_root(mnt->mnt_root, mnt, pathname, flags, 0);
 	result = PTR_ERR(file);
 	if (IS_ERR(file))
 		goto out_putname;
_

Patches currently in -mm which might be from jann@thejh.net are


