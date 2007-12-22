From: akpm@linux-foundation.org
Subject: + pid-namespaces-vs-locks-interaction.patch added to -mm tree
Date: Fri, 21 Dec 2007 16:50:32 -0800
Message-ID: <200712220050.lBM0oWCX007434@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34939 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751228AbXLVAuv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Dec 2007 19:50:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vgusev@openvz.org, bfields@fieldses.org, ebiederm@xmission.com, serue@us.ibm.com


The patch titled
     Pid namespaces vs locks interaction
has been added to the -mm tree.  Its filename is
     pid-namespaces-vs-locks-interaction.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Pid namespaces vs locks interaction
From: Vitaliy Gusev <vgusev@openvz.org>

fcntl(F_GETLK,..) can return pid of process for not current pid namespace
(if process is belonged to the several namespaces).  It is true also for
pids in /proc/locks.  So correct behavior is saving pointer to the struct
pid of the process lock owner.

Signed-off-by: Vitaliy Gusev <vgusev@openvz.org>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/locks.c         |   29 +++++++++++++++++++++++------
 include/linux/fs.h |    1 +
 2 files changed, 24 insertions(+), 6 deletions(-)

diff -puN fs/locks.c~pid-namespaces-vs-locks-interaction fs/locks.c
--- a/fs/locks.c~pid-namespaces-vs-locks-interaction
+++ a/fs/locks.c
@@ -125,6 +125,7 @@
 #include <linux/syscalls.h>
 #include <linux/time.h>
 #include <linux/rcupdate.h>
+#include <linux/pid_namespace.h>
 
 #include <asm/semaphore.h>
 #include <asm/uaccess.h>
@@ -185,6 +186,7 @@ void locks_init_lock(struct file_lock *f
 	fl->fl_fasync = NULL;
 	fl->fl_owner = NULL;
 	fl->fl_pid = 0;
+	fl->fl_nspid = NULL;
 	fl->fl_file = NULL;
 	fl->fl_flags = 0;
 	fl->fl_type = 0;
@@ -555,6 +557,8 @@ static void locks_insert_lock(struct fil
 {
 	list_add(&fl->fl_link, &file_lock_list);
 
+	fl->fl_nspid = get_pid(task_tgid(current));
+
 	/* insert into file's list */
 	fl->fl_next = *pos;
 	*pos = fl;
@@ -586,6 +590,11 @@ static void locks_delete_lock(struct fil
 	if (fl->fl_ops && fl->fl_ops->fl_remove)
 		fl->fl_ops->fl_remove(fl);
 
+	if (fl->fl_nspid) {
+		put_pid(fl->fl_nspid);
+		fl->fl_nspid = NULL;
+	}
+
 	locks_wake_up_blocks(fl);
 	locks_free_lock(fl);
 }
@@ -675,14 +684,16 @@ posix_test_lock(struct file *filp, struc
 		if (posix_locks_conflict(fl, cfl))
 			break;
 	}
-	if (cfl)
+	if (cfl) {
 		__locks_copy_lock(fl, cfl);
-	else
+		if (cfl->fl_nspid)
+			fl->fl_pid = pid_nr_ns(cfl->fl_nspid,
+						task_active_pid_ns(current));
+	} else
 		fl->fl_type = F_UNLCK;
 	unlock_kernel();
 	return;
 }
-
 EXPORT_SYMBOL(posix_test_lock);
 
 /*
@@ -2099,6 +2110,12 @@ static void lock_get_status(struct seq_f
 							int id, char *pfx)
 {
 	struct inode *inode = NULL;
+	unsigned int fl_pid;
+
+	if (fl->fl_nspid)
+		fl_pid = pid_nr_ns(fl->fl_nspid, task_active_pid_ns(current));
+	else
+		fl_pid = fl->fl_pid;
 
 	if (fl->fl_file != NULL)
 		inode = fl->fl_file->f_path.dentry->d_inode;
@@ -2139,16 +2156,16 @@ static void lock_get_status(struct seq_f
 	}
 	if (inode) {
 #ifdef WE_CAN_BREAK_LSLK_NOW
-		seq_printf(f, "%d %s:%ld ", fl->fl_pid,
+		seq_printf(f, "%d %s:%ld ", fl_pid,
 				inode->i_sb->s_id, inode->i_ino);
 #else
 		/* userspace relies on this representation of dev_t ;-( */
-		seq_printf(f, "%d %02x:%02x:%ld ", fl->fl_pid,
+		seq_printf(f, "%d %02x:%02x:%ld ", fl_pid,
 				MAJOR(inode->i_sb->s_dev),
 				MINOR(inode->i_sb->s_dev), inode->i_ino);
 #endif
 	} else {
-		seq_printf(f, "%d <none>:0 ", fl->fl_pid);
+		seq_printf(f, "%d <none>:0 ", fl_pid);
 	}
 	if (IS_POSIX(fl)) {
 		if (fl->fl_end == OFFSET_MAX)
diff -puN include/linux/fs.h~pid-namespaces-vs-locks-interaction include/linux/fs.h
--- a/include/linux/fs.h~pid-namespaces-vs-locks-interaction
+++ a/include/linux/fs.h
@@ -876,6 +876,7 @@ struct file_lock {
 	struct list_head fl_block;	/* circular list of blocked processes */
 	fl_owner_t fl_owner;
 	unsigned int fl_pid;
+	struct pid *fl_nspid;
 	wait_queue_head_t fl_wait;
 	struct file *fl_file;
 	unsigned char fl_flags;
_

Patches currently in -mm which might be from vgusev@openvz.org are

pid-namespaces-vs-locks-interaction.patch
