From: akpm@linux-foundation.org
Subject: + proc-use-%u-for-pid-printing-and-slightly-less-stack.patch
 added to -mm tree
Date: Mon, 20 Nov 2017 14:18:08 -0800
Message-ID: <5a1354a0.Tmzo3fviPR1sLDXK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43524 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751109AbdKTWSJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Nov 2017 17:18:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, viro@ftp.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: use %u for pid printing and slightly less stack
has been added to the -mm tree.  Its filename is
     proc-use-%u-for-pid-printing-and-slightly-less-stack.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-use-%25u-for-pid-printing-and-slightly-less-stack.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-use-%25u-for-pid-printing-and-slightly-less-stack.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -3019,11 +3019,11 @@ static const struct inode_operations pro
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
@@ -3035,7 +3035,7 @@ static void proc_flush_task_mnt(struct v
 		return;
 
 	name.name = buf;
-	name.len = snprintf(buf, sizeof(buf), "%d", tgid);
+	name.len = snprintf(buf, sizeof(buf), "%u", tgid);
 	leader = d_hash_and_lookup(mnt->mnt_root, &name);
 	if (!leader)
 		goto out;
@@ -3047,7 +3047,7 @@ static void proc_flush_task_mnt(struct v
 		goto out_put_leader;
 
 	name.name = buf;
-	name.len = snprintf(buf, sizeof(buf), "%d", pid);
+	name.len = snprintf(buf, sizeof(buf), "%u", pid);
 	dentry = d_hash_and_lookup(dir, &name);
 	if (dentry) {
 		d_invalidate(dentry);
@@ -3226,14 +3226,14 @@ int proc_pid_readdir(struct file *file,
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
@@ -3561,10 +3561,10 @@ static int proc_task_readdir(struct file
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

proc-use-%u-for-pid-printing-and-slightly-less-stack.patch
proc-dont-use-read_once-write_once-for-proc-fail-nth.patch
proc-fix-proc-map_files-lookup.patch
seq_file-delete-small-value-optimization.patch

