From: akpm@linux-foundation.org
Subject: - proc-simplify-function-prototypes.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:11:52 -0800
Message-ID: <200802082011.m18KBXC5010125@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53875 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752802AbYBHUqL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:46:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@sw.ru, mm-commits@vger.kernel.org


The patch titled
     proc: simplify function prototypes
has been removed from the -mm tree.  Its filename was
     proc-simplify-function-prototypes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: simplify function prototypes
From: Alexey Dobriyan <adobriyan@sw.ru>

Move code around so as to reduce the number of forward-declarations.

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c  |   18 ++++++------------
 fs/proc/proc_tty.c |    3 ---
 2 files changed, 6 insertions(+), 15 deletions(-)

diff -puN fs/proc/generic.c~proc-simplify-function-prototypes fs/proc/generic.c
--- a/fs/proc/generic.c~proc-simplify-function-prototypes
+++ a/fs/proc/generic.c
@@ -25,12 +25,6 @@
 
 #include "internal.h"
 
-static ssize_t proc_file_read(struct file *file, char __user *buf,
-			      size_t nbytes, loff_t *ppos);
-static ssize_t proc_file_write(struct file *file, const char __user *buffer,
-			       size_t count, loff_t *ppos);
-static loff_t proc_file_lseek(struct file *, loff_t, int);
-
 DEFINE_SPINLOCK(proc_subdir_lock);
 
 static int proc_match(int len, const char *name, struct proc_dir_entry *de)
@@ -40,12 +34,6 @@ static int proc_match(int len, const cha
 	return !memcmp(name, de->name, len);
 }
 
-static const struct file_operations proc_file_operations = {
-	.llseek		= proc_file_lseek,
-	.read		= proc_file_read,
-	.write		= proc_file_write,
-};
-
 /* buffer size is one page but our output routines use some slack for overruns */
 #define PROC_BLOCK_SIZE	(PAGE_SIZE - 1024)
 
@@ -233,6 +221,12 @@ proc_file_lseek(struct file *file, loff_
 	return retval;
 }
 
+static const struct file_operations proc_file_operations = {
+	.llseek		= proc_file_lseek,
+	.read		= proc_file_read,
+	.write		= proc_file_write,
+};
+
 static int proc_notify_change(struct dentry *dentry, struct iattr *iattr)
 {
 	struct inode *inode = dentry->d_inode;
diff -puN fs/proc/proc_tty.c~proc-simplify-function-prototypes fs/proc/proc_tty.c
--- a/fs/proc/proc_tty.c~proc-simplify-function-prototypes
+++ a/fs/proc/proc_tty.c
@@ -15,9 +15,6 @@
 #include <linux/seq_file.h>
 #include <linux/bitops.h>
 
-static int tty_ldiscs_read_proc(char *page, char **start, off_t off,
-				int count, int *eof, void *data);
-
 /*
  * The /proc/tty directory inodes...
  */
_

Patches currently in -mm which might be from adobriyan@sw.ru are

origin.patch
single_open-seq_release-leak-diagnostics.patch
