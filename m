From: akpm@linux-foundation.org
Subject: [merged] proc-show-locks-in-proc-pid-fdinfo-x.patch removed from
 -mm tree
Date: Mon, 20 Apr 2015 12:21:13 -0700
Message-ID: <553551a9.sm95k/EIr8SoL7XM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40557 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754243AbbDTTOw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:14:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avagin@openvz.org, bfields@fieldses.org, corbet@lwn.net, gorcunov@openvz.org, jlayton@poochiereds.net, joe@perches.com, viro@zeniv.linux.org.uk, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: show locks in /proc/pid/fdinfo/X
has been removed from the -mm tree.  Its filename was
     proc-show-locks-in-proc-pid-fdinfo-x.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Vagin <avagin@openvz.org>
Subject: proc: show locks in /proc/pid/fdinfo/X

Let's show locks which are associated with a file descriptor in
its fdinfo file.

Currently we don't have a reliable way to determine who holds a lock.  We
can find some information in /proc/locks, but PID which is reported there
can be wrong.  For example, a process takes a lock, then forks a child and
dies.  In this case /proc/locks contains the parent pid, which can be
reused by another process.

$ cat /proc/locks
...
6: FLOCK  ADVISORY  WRITE 324 00:13:13431 0 EOF
...

$ ps -C rpcbind
  PID TTY          TIME CMD
  332 ?        00:00:00 rpcbind

$ cat /proc/332/fdinfo/4
pos:	0
flags:	0100000
mnt_id:	22
lock:	1: FLOCK  ADVISORY  WRITE 324 00:13:13431 0 EOF

$ ls -l /proc/332/fd/4
lr-x------ 1 root root 64 Mar  5 14:43 /proc/332/fd/4 -> /run/rpcbind.lock

$ ls -l /proc/324/fd/
total 0
lrwx------ 1 root root 64 Feb 27 14:50 0 -> /dev/pts/0
lrwx------ 1 root root 64 Feb 27 14:50 1 -> /dev/pts/0
lrwx------ 1 root root 64 Feb 27 14:49 2 -> /dev/pts/0

You can see that the process with the 324 pid doesn't hold the lock.

This information is required for proper dumping and restoring file
locks.

Signed-off-by: Andrey Vagin <avagin@openvz.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Acked-by: Jeff Layton <jlayton@poochiereds.net>
Acked-by: "J. Bruce Fields" <bfields@fieldses.org>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |    4 ++
 fs/locks.c                         |   38 +++++++++++++++++++++++++++
 fs/proc/fd.c                       |   27 ++++++++++++-------
 include/linux/fs.h                 |    7 ++++
 4 files changed, 66 insertions(+), 10 deletions(-)

diff -puN Documentation/filesystems/proc.txt~proc-show-locks-in-proc-pid-fdinfo-x Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~proc-show-locks-in-proc-pid-fdinfo-x
+++ a/Documentation/filesystems/proc.txt
@@ -1709,6 +1709,10 @@ A typical output is
 	flags:	0100002
 	mnt_id:	19
 
+All locks associated with a file descriptor are shown in its fdinfo too.
+
+lock:       1: FLOCK  ADVISORY  WRITE 359 00:13:11691 0 EOF
+
 The files such as eventfd, fsnotify, signalfd, epoll among the regular pos/flags
 pair provide additional information particular to the objects they represent.
 
diff -puN fs/locks.c~proc-show-locks-in-proc-pid-fdinfo-x fs/locks.c
--- a/fs/locks.c~proc-show-locks-in-proc-pid-fdinfo-x
+++ a/fs/locks.c
@@ -2590,6 +2590,44 @@ static int locks_show(struct seq_file *f
 	return 0;
 }
 
+static void __show_fd_locks(struct seq_file *f,
+			struct list_head *head, int *id,
+			struct file *filp, struct files_struct *files)
+{
+	struct file_lock *fl;
+
+	list_for_each_entry(fl, head, fl_list) {
+
+		if (filp != fl->fl_file)
+			continue;
+		if (fl->fl_owner != files &&
+		    fl->fl_owner != filp)
+			continue;
+
+		(*id)++;
+		seq_puts(f, "lock:\t");
+		lock_get_status(f, fl, *id, "");
+	}
+}
+
+void show_fd_locks(struct seq_file *f,
+		  struct file *filp, struct files_struct *files)
+{
+	struct inode *inode = file_inode(filp);
+	struct file_lock_context *ctx;
+	int id = 0;
+
+	ctx = inode->i_flctx;
+	if (!ctx)
+		return;
+
+	spin_lock(&ctx->flc_lock);
+	__show_fd_locks(f, &ctx->flc_flock, &id, filp, files);
+	__show_fd_locks(f, &ctx->flc_posix, &id, filp, files);
+	__show_fd_locks(f, &ctx->flc_lease, &id, filp, files);
+	spin_unlock(&ctx->flc_lock);
+}
+
 static void *locks_start(struct seq_file *f, loff_t *pos)
 	__acquires(&blocked_lock_lock)
 {
diff -puN fs/proc/fd.c~proc-show-locks-in-proc-pid-fdinfo-x fs/proc/fd.c
--- a/fs/proc/fd.c~proc-show-locks-in-proc-pid-fdinfo-x
+++ a/fs/proc/fd.c
@@ -8,6 +8,7 @@
 #include <linux/security.h>
 #include <linux/file.h>
 #include <linux/seq_file.h>
+#include <linux/fs.h>
 
 #include <linux/proc_fs.h>
 
@@ -48,17 +49,23 @@ static int seq_show(struct seq_file *m,
 		put_files_struct(files);
 	}
 
-	if (!ret) {
-		seq_printf(m, "pos:\t%lli\nflags:\t0%o\nmnt_id:\t%i\n",
-			   (long long)file->f_pos, f_flags,
-			   real_mount(file->f_path.mnt)->mnt_id);
-		if (file->f_op->show_fdinfo)
-			file->f_op->show_fdinfo(m, file);
-		ret = seq_has_overflowed(m);
-		fput(file);
-	}
+	if (ret)
+		return ret;
 
-	return ret;
+	seq_printf(m, "pos:\t%lli\nflags:\t0%o\nmnt_id:\t%i\n",
+		   (long long)file->f_pos, f_flags,
+		   real_mount(file->f_path.mnt)->mnt_id);
+
+	show_fd_locks(m, file, files);
+	if (seq_has_overflowed(m))
+		goto out;
+
+	if (file->f_op->show_fdinfo)
+		file->f_op->show_fdinfo(m, file);
+
+out:
+	fput(file);
+	return 0;
 }
 
 static int seq_fdinfo_open(struct inode *inode, struct file *file)
diff -puN include/linux/fs.h~proc-show-locks-in-proc-pid-fdinfo-x include/linux/fs.h
--- a/include/linux/fs.h~proc-show-locks-in-proc-pid-fdinfo-x
+++ a/include/linux/fs.h
@@ -1042,6 +1042,9 @@ extern void lease_get_mtime(struct inode
 extern int generic_setlease(struct file *, long, struct file_lock **, void **priv);
 extern int vfs_setlease(struct file *, long, struct file_lock **, void **);
 extern int lease_modify(struct file_lock *, int, struct list_head *);
+struct files_struct;
+extern void show_fd_locks(struct seq_file *f,
+			 struct file *filp, struct files_struct *files);
 #else /* !CONFIG_FILE_LOCKING */
 static inline int fcntl_getlk(struct file *file, unsigned int cmd,
 			      struct flock __user *user)
@@ -1178,6 +1181,10 @@ static inline int lease_modify(struct fi
 {
 	return -EINVAL;
 }
+
+struct files_struct;
+static inline void show_fd_locks(struct seq_file *f,
+			struct file *filp, struct files_struct *files) {}
 #endif /* !CONFIG_FILE_LOCKING */
 
 
_

Patches currently in -mm which might be from avagin@openvz.org are

origin.patch

