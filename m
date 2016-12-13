From: akpm@linux-foundation.org
Subject: [patch 099/123] fs/proc: calculate /proc/* and /proc/*/task/*
 nlink at init time
Date: Mon, 12 Dec 2016 16:45:32 -0800
Message-ID: <584f44ac.R4by2fzAX/adi/Ti%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41816 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932499AbcLMApd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2016 19:45:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, adobriyan@gmail.com, vegard.nossum@oracle.com

From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: fs/proc: calculate /proc/* and /proc/*/task/* nlink at init time

Runtime nlink calculation works but meh. I don't know how to do it
at compile time, but I know how to do it at init time.

Shift "2+" part into init time as a bonus.

Link: http://lkml.kernel.org/r/20161122195549.GB29812@avx2
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Reviewed-by: Vegard Nossum <vegard.nossum@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c     |   19 +++++++++++++------
 fs/proc/internal.h |    1 +
 fs/proc/root.c     |    1 +
 3 files changed, 15 insertions(+), 6 deletions(-)

diff -puN fs/proc/base.c~proc-calculate-proc-and-proc-task-nlink-at-init-time fs/proc/base.c
--- a/fs/proc/base.c~proc-calculate-proc-and-proc-task-nlink-at-init-time
+++ a/fs/proc/base.c
@@ -104,6 +104,9 @@
  *	in /proc for a task before it execs a suid executable.
  */
 
+static u8 nlink_tid;
+static u8 nlink_tgid;
+
 struct pid_entry {
 	const char *name;
 	unsigned int len;
@@ -139,13 +142,13 @@ struct pid_entry {
  * Count the number of hardlinks for the pid_entry table, excluding the .
  * and .. links.
  */
-static unsigned int pid_entry_count_dirs(const struct pid_entry *entries,
+static unsigned int __init pid_entry_nlink(const struct pid_entry *entries,
 	unsigned int n)
 {
 	unsigned int i;
 	unsigned int count;
 
-	count = 0;
+	count = 2;
 	for (i = 0; i < n; ++i) {
 		if (S_ISDIR(entries[i].mode))
 			++count;
@@ -3068,8 +3071,7 @@ static int proc_pid_instantiate(struct i
 	inode->i_fop = &proc_tgid_base_operations;
 	inode->i_flags|=S_IMMUTABLE;
 
-	set_nlink(inode, 2 + pid_entry_count_dirs(tgid_base_stuff,
-						  ARRAY_SIZE(tgid_base_stuff)));
+	set_nlink(inode, nlink_tgid);
 
 	d_set_d_op(dentry, &pid_dentry_operations);
 
@@ -3361,8 +3363,7 @@ static int proc_task_instantiate(struct
 	inode->i_fop = &proc_tid_base_operations;
 	inode->i_flags|=S_IMMUTABLE;
 
-	set_nlink(inode, 2 + pid_entry_count_dirs(tid_base_stuff,
-						  ARRAY_SIZE(tid_base_stuff)));
+	set_nlink(inode, nlink_tid);
 
 	d_set_d_op(dentry, &pid_dentry_operations);
 
@@ -3552,3 +3553,9 @@ static const struct file_operations proc
 	.iterate_shared	= proc_task_readdir,
 	.llseek		= generic_file_llseek,
 };
+
+void __init set_proc_pid_nlink(void)
+{
+	nlink_tid = pid_entry_nlink(tid_base_stuff, ARRAY_SIZE(tid_base_stuff));
+	nlink_tgid = pid_entry_nlink(tgid_base_stuff, ARRAY_SIZE(tgid_base_stuff));
+}
diff -puN fs/proc/internal.h~proc-calculate-proc-and-proc-task-nlink-at-init-time fs/proc/internal.h
--- a/fs/proc/internal.h~proc-calculate-proc-and-proc-task-nlink-at-init-time
+++ a/fs/proc/internal.h
@@ -211,6 +211,7 @@ extern const struct inode_operations pro
 extern const struct inode_operations proc_pid_link_inode_operations;
 
 extern void proc_init_inodecache(void);
+void set_proc_pid_nlink(void);
 extern struct inode *proc_get_inode(struct super_block *, struct proc_dir_entry *);
 extern int proc_fill_super(struct super_block *, void *data, int flags);
 extern void proc_entry_rundown(struct proc_dir_entry *);
diff -puN fs/proc/root.c~proc-calculate-proc-and-proc-task-nlink-at-init-time fs/proc/root.c
--- a/fs/proc/root.c~proc-calculate-proc-and-proc-task-nlink-at-init-time
+++ a/fs/proc/root.c
@@ -122,6 +122,7 @@ void __init proc_root_init(void)
 	int err;
 
 	proc_init_inodecache();
+	set_proc_pid_nlink();
 	err = register_filesystem(&proc_fs_type);
 	if (err)
 		return;
_
