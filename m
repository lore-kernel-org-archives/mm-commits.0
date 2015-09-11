From: akpm@linux-foundation.org
Subject: [merged]
 procfs-always-expose-proc-pid-map_files-and-make-it-readable.patch removed
 from -mm tree
Date: Fri, 11 Sep 2015 11:11:31 -0700
Message-ID: <55f31953.KH/W+X2WJYnuFr47%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53673 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbbIKSLc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 14:11:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: calvinowens@fb.com, gorcunov@openvz.org, joe@perches.com, keescook@chromium.org, kirill@shutemov.name, luto@amacapital.net, mm-commits@vger.kernel.org


The patch titled
     Subject: procfs: always expose /proc/<pid>/map_files/ and make it readable
has been removed from the -mm tree.  Its filename was
     procfs-always-expose-proc-pid-map_files-and-make-it-readable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Calvin Owens <calvinowens@fb.com>
Subject: procfs: always expose /proc/<pid>/map_files/ and make it readable

Currently, /proc/<pid>/map_files/ is restricted to CAP_SYS_ADMIN, and is
only exposed if CONFIG_CHECKPOINT_RESTORE is set.

Each mapped file region gets a symlink in /proc/<pid>/map_files/
corresponding to the virtual address range at which it is mapped.  The
symlinks work like the symlinks in /proc/<pid>/fd/, so you can follow them
to the backing file even if that backing file has been unlinked.

Currently, files which are mapped, unlinked, and closed are impossible to
stat() from userspace.  Exposing /proc/<pid>/map_files/ closes this
functionality "hole".

Not being able to stat() such files makes noticing and explicitly
accounting for the space they use on the filesystem impossible.  You can
work around this by summing up the space used by every file in the
filesystem and subtracting that total from what statfs() tells you, but
that obviously isn't great, and it becomes unworkable once your filesystem
becomes large enough.

This patch moves map_files/ out from behind CONFIG_CHECKPOINT_RESTORE, and
adjusts the permissions enforced on it as follows:

* proc_map_files_lookup()
* proc_map_files_readdir()
* map_files_d_revalidate()

	Remove the CAP_SYS_ADMIN restriction, leaving only the current
	restriction requiring PTRACE_MODE_READ. The information made
	available to userspace by these three functions is already
	available in /proc/PID/maps with MODE_READ, so I don't see any
	reason to limit them any further (see below for more detail).

* proc_map_files_follow_link()

	This stub has been added, and requires that the user have
	CAP_SYS_ADMIN in order to follow the links in map_files/,
	since there was concern on LKML both about the potential for
	bypassing permissions on ancestor directories in the path to
	files pointed to, and about what happens with more exotic
	memory mappings created by some drivers (ie dma-buf).

In older versions of this patch, I changed every permission check in
the four functions above to enforce MODE_ATTACH instead of MODE_READ.
This was an oversight on my part, and after revisiting the discussion
it seems that nobody was concerned about anything outside of what is
made possible by ->follow_link(). So in this version, I've left the
checks for PTRACE_MODE_READ as-is.

[akpm@linux-foundation.org: catch up with concurrent proc_pid_follow_link() changes]
Signed-off-by: Calvin Owens <calvinowens@fb.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Joe Perches <joe@perches.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   43 ++++++++++++++++++++++++-------------------
 1 file changed, 24 insertions(+), 19 deletions(-)

diff -puN fs/proc/base.c~procfs-always-expose-proc-pid-map_files-and-make-it-readable fs/proc/base.c
--- a/fs/proc/base.c~procfs-always-expose-proc-pid-map_files-and-make-it-readable
+++ a/fs/proc/base.c
@@ -1836,8 +1836,6 @@ end_instantiate:
 	return dir_emit(ctx, name, len, 1, DT_UNKNOWN);
 }
 
-#ifdef CONFIG_CHECKPOINT_RESTORE
-
 /*
  * dname_to_vma_addr - maps a dentry name into two unsigned longs
  * which represent vma start and end addresses.
@@ -1864,11 +1862,6 @@ static int map_files_d_revalidate(struct
 	if (flags & LOOKUP_RCU)
 		return -ECHILD;
 
-	if (!capable(CAP_SYS_ADMIN)) {
-		status = -EPERM;
-		goto out_notask;
-	}
-
 	inode = d_inode(dentry);
 	task = get_proc_task(inode);
 	if (!task)
@@ -1957,6 +1950,29 @@ struct map_files_info {
 	unsigned char	name[4*sizeof(long)+2]; /* max: %lx-%lx\0 */
 };
 
+/*
+ * Only allow CAP_SYS_ADMIN to follow the links, due to concerns about how the
+ * symlinks may be used to bypass permissions on ancestor directories in the
+ * path to the file in question.
+ */
+static const char *
+proc_map_files_follow_link(struct dentry *dentry, void **cookie)
+{
+	if (!capable(CAP_SYS_ADMIN))
+		return ERR_PTR(-EPERM);
+
+	return proc_pid_follow_link(dentry, NULL);
+}
+
+/*
+ * Identical to proc_pid_link_inode_operations except for follow_link()
+ */
+static const struct inode_operations proc_map_files_link_inode_operations = {
+	.readlink	= proc_pid_readlink,
+	.follow_link	= proc_map_files_follow_link,
+	.setattr	= proc_setattr,
+};
+
 static int
 proc_map_files_instantiate(struct inode *dir, struct dentry *dentry,
 			   struct task_struct *task, const void *ptr)
@@ -1972,7 +1988,7 @@ proc_map_files_instantiate(struct inode
 	ei = PROC_I(inode);
 	ei->op.proc_get_link = proc_map_files_get_link;
 
-	inode->i_op = &proc_pid_link_inode_operations;
+	inode->i_op = &proc_map_files_link_inode_operations;
 	inode->i_size = 64;
 	inode->i_mode = S_IFLNK;
 
@@ -1996,10 +2012,6 @@ static struct dentry *proc_map_files_loo
 	int result;
 	struct mm_struct *mm;
 
-	result = -EPERM;
-	if (!capable(CAP_SYS_ADMIN))
-		goto out;
-
 	result = -ENOENT;
 	task = get_proc_task(dir);
 	if (!task)
@@ -2053,10 +2065,6 @@ proc_map_files_readdir(struct file *file
 	struct map_files_info *p;
 	int ret;
 
-	ret = -EPERM;
-	if (!capable(CAP_SYS_ADMIN))
-		goto out;
-
 	ret = -ENOENT;
 	task = get_proc_task(file_inode(file));
 	if (!task)
@@ -2245,7 +2253,6 @@ static const struct file_operations proc
 	.llseek		= seq_lseek,
 	.release	= seq_release_private,
 };
-#endif /* CONFIG_CHECKPOINT_RESTORE */
 
 static int proc_pident_instantiate(struct inode *dir,
 	struct dentry *dentry, struct task_struct *task, const void *ptr)
@@ -2744,9 +2751,7 @@ static const struct inode_operations pro
 static const struct pid_entry tgid_base_stuff[] = {
 	DIR("task",       S_IRUGO|S_IXUGO, proc_task_inode_operations, proc_task_operations),
 	DIR("fd",         S_IRUSR|S_IXUSR, proc_fd_inode_operations, proc_fd_operations),
-#ifdef CONFIG_CHECKPOINT_RESTORE
 	DIR("map_files",  S_IRUSR|S_IXUSR, proc_map_files_inode_operations, proc_map_files_operations),
-#endif
 	DIR("fdinfo",     S_IRUSR|S_IXUSR, proc_fdinfo_inode_operations, proc_fdinfo_operations),
 	DIR("ns",	  S_IRUSR|S_IXUGO, proc_ns_dir_inode_operations, proc_ns_dir_operations),
 #ifdef CONFIG_NET
_

Patches currently in -mm which might be from calvinowens@fb.com are


