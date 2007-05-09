From: akpm@linux-foundation.org
Subject: - procfs-use-simple_read_from_buffer.patch removed from -mm tree
Date: Tue, 08 May 2007 19:52:21 -0700
Message-ID: <200705090252.l492qLIq009563@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49140 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S968683AbXEICwZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:52:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, mm-commits@vger.kernel.org


The patch titled
     procfs: use simple_read_from_buffer()
has been removed from the -mm tree.  Its filename was
     procfs-use-simple_read_from_buffer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: procfs: use simple_read_from_buffer()
From: Akinobu Mita <akinobu.mita@gmail.com>

Cleanup using simple_read_from_buffer() in procfs.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   35 +++++++----------------------------
 1 file changed, 7 insertions(+), 28 deletions(-)

diff -puN fs/proc/base.c~procfs-use-simple_read_from_buffer fs/proc/base.c
--- a/fs/proc/base.c~procfs-use-simple_read_from_buffer
+++ a/fs/proc/base.c
@@ -660,7 +660,6 @@ static ssize_t oom_adjust_read(struct fi
 	char buffer[PROC_NUMBUF];
 	size_t len;
 	int oom_adjust;
-	loff_t __ppos = *ppos;
 
 	if (!task)
 		return -ESRCH;
@@ -668,14 +667,8 @@ static ssize_t oom_adjust_read(struct fi
 	put_task_struct(task);
 
 	len = snprintf(buffer, sizeof(buffer), "%i\n", oom_adjust);
-	if (__ppos >= len)
-		return 0;
-	if (count > len-__ppos)
-		count = len-__ppos;
-	if (copy_to_user(buf, buffer + __ppos, count))
-		return -EFAULT;
-	*ppos = __ppos + count;
-	return count;
+
+	return simple_read_from_buffer(buf, count, ppos, buffer, len);
 }
 
 static ssize_t oom_adjust_write(struct file *file, const char __user *buf,
@@ -823,7 +816,6 @@ static ssize_t seccomp_read(struct file 
 {
 	struct task_struct *tsk = get_proc_task(file->f_dentry->d_inode);
 	char __buf[20];
-	loff_t __ppos = *ppos;
 	size_t len;
 
 	if (!tsk)
@@ -831,14 +823,8 @@ static ssize_t seccomp_read(struct file 
 	/* no need to print the trailing zero, so use only len */
 	len = sprintf(__buf, "%u\n", tsk->seccomp.mode);
 	put_task_struct(tsk);
-	if (__ppos >= len)
-		return 0;
-	if (count > len - __ppos)
-		count = len - __ppos;
-	if (copy_to_user(buf, __buf + __ppos, count))
-		return -EFAULT;
-	*ppos = __ppos + count;
-	return count;
+
+	return simple_read_from_buffer(buf, count, ppos, __buf, len);
 }
 
 static ssize_t seccomp_write(struct file *file, const char __user *buf,
@@ -897,7 +883,6 @@ static ssize_t proc_fault_inject_read(st
 	char buffer[PROC_NUMBUF];
 	size_t len;
 	int make_it_fail;
-	loff_t __ppos = *ppos;
 
 	if (!task)
 		return -ESRCH;
@@ -905,14 +890,8 @@ static ssize_t proc_fault_inject_read(st
 	put_task_struct(task);
 
 	len = snprintf(buffer, sizeof(buffer), "%i\n", make_it_fail);
-	if (__ppos >= len)
-		return 0;
-	if (count > len-__ppos)
-		count = len-__ppos;
-	if (copy_to_user(buf, buffer + __ppos, count))
-		return -EFAULT;
-	*ppos = __ppos + count;
-	return count;
+
+	return simple_read_from_buffer(buf, count, ppos, buffer, len);
 }
 
 static ssize_t proc_fault_inject_write(struct file * file,
@@ -975,7 +954,7 @@ static int do_proc_readlink(struct dentr
 
 	if (!tmp)
 		return -ENOMEM;
-		
+
 	inode = dentry->d_inode;
 	path = d_path(dentry, mnt, tmp, PAGE_SIZE);
 	len = PTR_ERR(path);
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
git-alsa.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
fault-injection-disable-stacktrace-filter-for-x86-64.patch
cm4000_cs-fix-error-paths.patch
cm4000_cs-use-bitrev.patch
use-simple_read_from_buffer-in-fs.patch
use-simple_read_from_buffer-in-kernel.patch
sunrpc-fix-error-path-in-module_init.patch
