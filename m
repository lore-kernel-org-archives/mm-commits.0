From: akpm@linux-foundation.org
Subject: [merged]
 proc-use-%u-for-pid-printing-and-slightly-less-stack.patch removed from -mm
 tree
Date: Wed, 07 Feb 2018 11:55:47 -0800
Message-ID: <20180207195547.UOqsOc3-O%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58110 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754422AbeBGTzs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Feb 2018 14:55:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org, viro@ftp.linux.org.uk


The patch titled
     Subject: proc: use %u for pid printing and slightly less stack
has been removed from the -mm tree.  Its filename was
     proc-use-%u-for-pid-printing-and-slightly-less-stack.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: proc: use %u for pid printing and slightly less stack

PROC_NUMBUF is 13 which is enough for "negative int + \n + \0".

However PIDs and TGIDs are never negative and newline is not a concern,
so use just 10 per integer.

Link: http://lkml.kernel.org/r/20171120203005.GA27743@avx2
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Alexander Viro <viro@ftp.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c        |   16 ++++++++--------
 fs/proc/fd.c          |    2 +-
 fs/proc/self.c        |    6 +++---
 fs/proc/thread_self.c |    5 ++---
 4 files changed, 14 insertions(+), 15 deletions(-)

diff -puN fs/proc/base.c~proc-use-%u-for-pid-printing-and-slightly-less-stack fs/proc/base.c
--- a/fs/proc/base.c~proc-use-%u-for-pid-printing-and-slightly-less-stack
+++ a/fs/proc/base.c
@@ -3018,11 +3018,11 @@ static const struct inode_operations pro
 static void proc_flush_task_mnt(struct vfsmount *mnt, pid_t pid, pid_t tgid)
 {
 	struct dentry *dentry, *leader, *dir;
-	char buf[PROC_NUMBUF];
+	char buf[10 + 1];
 	struct qstr name;
 
 	name.name = buf;
-	name.len = snprintf(buf, sizeof(buf), "%d", pid);
+	name.len = snprintf(buf, sizeof(buf), "%u", pid);
 	/* no ->d_hash() rejects on procfs */
 	dentry = d_hash_and_lookup(mnt->mnt_root, &name);
 	if (dentry) {
@@ -3034,7 +3034,7 @@ static void proc_flush_task_mnt(struct v
 		return;
 
 	name.name = buf;
-	name.len = snprintf(buf, sizeof(buf), "%d", tgid);
+	name.len = snprintf(buf, sizeof(buf), "%u", tgid);
 	leader = d_hash_and_lookup(mnt->mnt_root, &name);
 	if (!leader)
 		goto out;
@@ -3046,7 +3046,7 @@ static void proc_flush_task_mnt(struct v
 		goto out_put_leader;
 
 	name.name = buf;
-	name.len = snprintf(buf, sizeof(buf), "%d", pid);
+	name.len = snprintf(buf, sizeof(buf), "%u", pid);
 	dentry = d_hash_and_lookup(dir, &name);
 	if (dentry) {
 		d_invalidate(dentry);
@@ -3225,14 +3225,14 @@ int proc_pid_readdir(struct file *file,
 	for (iter = next_tgid(ns, iter);
 	     iter.task;
 	     iter.tgid += 1, iter = next_tgid(ns, iter)) {
-		char name[PROC_NUMBUF];
+		char name[10 + 1];
 		int len;
 
 		cond_resched();
 		if (!has_pid_permissions(ns, iter.task, HIDEPID_INVISIBLE))
 			continue;
 
-		len = snprintf(name, sizeof(name), "%d", iter.tgid);
+		len = snprintf(name, sizeof(name), "%u", iter.tgid);
 		ctx->pos = iter.tgid + TGID_OFFSET;
 		if (!proc_fill_cache(file, ctx, name, len,
 				     proc_pid_instantiate, iter.task, NULL)) {
@@ -3560,10 +3560,10 @@ static int proc_task_readdir(struct file
 	for (task = first_tid(proc_pid(inode), tid, ctx->pos - 2, ns);
 	     task;
 	     task = next_tid(task), ctx->pos++) {
-		char name[PROC_NUMBUF];
+		char name[10 + 1];
 		int len;
 		tid = task_pid_nr_ns(task, ns);
-		len = snprintf(name, sizeof(name), "%d", tid);
+		len = snprintf(name, sizeof(name), "%u", tid);
 		if (!proc_fill_cache(file, ctx, name, len,
 				proc_task_instantiate, task, NULL)) {
 			/* returning this tgid failed, save it as the first
diff -puN fs/proc/fd.c~proc-use-%u-for-pid-printing-and-slightly-less-stack fs/proc/fd.c
--- a/fs/proc/fd.c~proc-use-%u-for-pid-printing-and-slightly-less-stack
+++ a/fs/proc/fd.c
@@ -236,7 +236,7 @@ static int proc_readfd_common(struct fil
 	for (fd = ctx->pos - 2;
 	     fd < files_fdtable(files)->max_fds;
 	     fd++, ctx->pos++) {
-		char name[PROC_NUMBUF];
+		char name[10 + 1];
 		int len;
 
 		if (!fcheck_files(files, fd))
diff -puN fs/proc/self.c~proc-use-%u-for-pid-printing-and-slightly-less-stack fs/proc/self.c
--- a/fs/proc/self.c~proc-use-%u-for-pid-printing-and-slightly-less-stack
+++ a/fs/proc/self.c
@@ -17,11 +17,11 @@ static const char *proc_self_get_link(st
 
 	if (!tgid)
 		return ERR_PTR(-ENOENT);
-	/* 11 for max length of signed int in decimal + NULL term */
-	name = kmalloc(12, dentry ? GFP_KERNEL : GFP_ATOMIC);
+	/* max length of unsigned int in decimal + NULL term */
+	name = kmalloc(10 + 1, dentry ? GFP_KERNEL : GFP_ATOMIC);
 	if (unlikely(!name))
 		return dentry ? ERR_PTR(-ENOMEM) : ERR_PTR(-ECHILD);
-	sprintf(name, "%d", tgid);
+	sprintf(name, "%u", tgid);
 	set_delayed_call(done, kfree_link, name);
 	return name;
 }
diff -puN fs/proc/thread_self.c~proc-use-%u-for-pid-printing-and-slightly-less-stack fs/proc/thread_self.c
--- a/fs/proc/thread_self.c~proc-use-%u-for-pid-printing-and-slightly-less-stack
+++ a/fs/proc/thread_self.c
@@ -18,11 +18,10 @@ static const char *proc_thread_self_get_
 
 	if (!pid)
 		return ERR_PTR(-ENOENT);
-	name = kmalloc(PROC_NUMBUF + 6 + PROC_NUMBUF,
-				dentry ? GFP_KERNEL : GFP_ATOMIC);
+	name = kmalloc(10 + 6 + 10 + 1, dentry ? GFP_KERNEL : GFP_ATOMIC);
 	if (unlikely(!name))
 		return dentry ? ERR_PTR(-ENOMEM) : ERR_PTR(-ECHILD);
-	sprintf(name, "%d/task/%d", tgid, pid);
+	sprintf(name, "%u/task/%u", tgid, pid);
 	set_delayed_call(done, kfree_link, name);
 	return name;
 }
_

Patches currently in -mm which might be from adobriyan@gmail.com are

seq_file-delete-small-value-optimization.patch

