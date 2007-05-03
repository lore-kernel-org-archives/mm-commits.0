From: akpm@linux-foundation.org
Subject: + procfs-use-simple_read_from_buffer.patch added to -mm tree
Date: Wed, 02 May 2007 22:06:52 -0700
Message-ID: <200705030506.l4356qvv005242@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38189 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767388AbXECFG5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 01:06:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com


The patch titled
     procfs: use simple_read_from_buffer()
has been added to the -mm tree.  Its filename is
     procfs-use-simple_read_from_buffer.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -789,7 +782,6 @@ static ssize_t seccomp_read(struct file 
 {
 	struct task_struct *tsk = get_proc_task(file->f_dentry->d_inode);
 	char __buf[20];
-	loff_t __ppos = *ppos;
 	size_t len;
 
 	if (!tsk)
@@ -797,14 +789,8 @@ static ssize_t seccomp_read(struct file 
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
@@ -863,7 +849,6 @@ static ssize_t proc_fault_inject_read(st
 	char buffer[PROC_NUMBUF];
 	size_t len;
 	int make_it_fail;
-	loff_t __ppos = *ppos;
 
 	if (!task)
 		return -ESRCH;
@@ -871,14 +856,8 @@ static ssize_t proc_fault_inject_read(st
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
@@ -942,7 +921,7 @@ static int do_proc_readlink(struct dentr
 
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
slob-handle-slab_panic-flag.patch
fault-injection-fix-failslab-with-config_numa.patch
hugetlbfs-add-null-check-in-hugetlb_zero_setup.patch
slob-fix-page-order-calculation-on-not-4kb-page.patch
git-alsa.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
fault-injection-disable-stacktrace-filter-for-x86-64.patch
fault-injection-enable-stacktrace-with-dwarf2-unwinder.patch
use-slab_panic-flag-cleanup.patch
simplify-the-stacktrace-code.patch
dtlk-fix-error-checks-in-module_init.patch
procfs-use-simple_read_from_buffer.patch
sunrpc-fix-error-path-in-module_init.patch
