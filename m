From: akpm@linux-foundation.org
Subject: + task-comm-ext4-protect-task-comm-access-by-using-get_task_comm.patch added to -mm tree
Date: Wed, 04 May 2011 16:37:18 -0700
Message-ID: <201105042337.p44NbIcR021398@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49966 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754245Ab1EDXiE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 May 2011 19:38:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: john.stultz@linaro.org, dave@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com, rientjes@google.com, tglx@linutronix.de, tytso@mit.edu


The patch titled
     task->comm: ext4: protect task->comm access by using get_task_comm()
has been added to the -mm tree.  Its filename is
     task-comm-ext4-protect-task-comm-access-by-using-get_task_comm.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: task->comm: ext4: protect task->comm access by using get_task_comm()
From: John Stultz <john.stultz@linaro.org>

Convert ext4 comm access to use the safe get_task_comm() accessor.

Signed-off-by: John Stultz <john.stultz@linaro.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/file.c  |    8 ++++++--
 fs/ext4/super.c |   13 ++++++++++---
 2 files changed, 16 insertions(+), 5 deletions(-)

diff -puN fs/ext4/file.c~task-comm-ext4-protect-task-comm-access-by-using-get_task_comm fs/ext4/file.c
--- a/fs/ext4/file.c~task-comm-ext4-protect-task-comm-access-by-using-get_task_comm
+++ a/fs/ext4/file.c
@@ -124,11 +124,15 @@ ext4_file_write(struct kiocb *iocb, cons
 		static unsigned long unaligned_warn_time;
 
 		/* Warn about this once per day */
-		if (printk_timed_ratelimit(&unaligned_warn_time, 60*60*24*HZ))
+		if (printk_timed_ratelimit(&unaligned_warn_time, 60*60*24*HZ)) {
+			char comm[TASK_COMM_LEN];
+
+			get_task_comm(comm, current);
 			ext4_msg(inode->i_sb, KERN_WARNING,
 				 "Unaligned AIO/DIO on inode %ld by %s; "
 				 "performance will be poor.",
-				 inode->i_ino, current->comm);
+				 inode->i_ino, comm);
+		}
 		mutex_lock(ext4_aio_mutex(inode));
 		ext4_aiodio_wait(inode);
 	}
diff -puN fs/ext4/super.c~task-comm-ext4-protect-task-comm-access-by-using-get_task_comm fs/ext4/super.c
--- a/fs/ext4/super.c~task-comm-ext4-protect-task-comm-access-by-using-get_task_comm
+++ a/fs/ext4/super.c
@@ -426,12 +426,15 @@ void __ext4_error(struct super_block *sb
 {
 	struct va_format vaf;
 	va_list args;
+	char comm[TASK_COMM_LEN];
 
 	va_start(args, fmt);
 	vaf.fmt = fmt;
 	vaf.va = &args;
+
+	get_task_comm(comm, current);
 	printk(KERN_CRIT "EXT4-fs error (device %s): %s:%d: comm %s: %pV\n",
-	       sb->s_id, function, line, current->comm, &vaf);
+	       sb->s_id, function, line, comm, &vaf);
 	va_end(args);
 
 	ext4_handle_error(sb);
@@ -444,6 +447,7 @@ void ext4_error_inode(struct inode *inod
 	va_list args;
 	struct va_format vaf;
 	struct ext4_super_block *es = EXT4_SB(inode->i_sb)->s_es;
+	char comm[TASK_COMM_LEN];
 
 	es->s_last_error_ino = cpu_to_le32(inode->i_ino);
 	es->s_last_error_block = cpu_to_le64(block);
@@ -455,7 +459,8 @@ void ext4_error_inode(struct inode *inod
 	       inode->i_sb->s_id, function, line, inode->i_ino);
 	if (block)
 		printk(KERN_CONT "block %llu: ", block);
-	printk(KERN_CONT "comm %s: %pV\n", current->comm, &vaf);
+	get_task_comm(comm, current);
+	printk(KERN_CONT "comm %s: %pV\n", comm, &vaf);
 	va_end(args);
 
 	ext4_handle_error(inode->i_sb);
@@ -470,6 +475,7 @@ void ext4_error_file(struct file *file, 
 	struct ext4_super_block *es;
 	struct inode *inode = file->f_dentry->d_inode;
 	char pathname[80], *path;
+	char comm[TASK_COMM_LEN];
 
 	es = EXT4_SB(inode->i_sb)->s_es;
 	es->s_last_error_ino = cpu_to_le32(inode->i_ino);
@@ -485,7 +491,8 @@ void ext4_error_file(struct file *file, 
 	va_start(args, fmt);
 	vaf.fmt = fmt;
 	vaf.va = &args;
-	printk(KERN_CONT "comm %s: path %s: %pV\n", current->comm, path, &vaf);
+	get_task_comm(comm, current);
+	printk(KERN_CONT "comm %s: path %s: %pV\n", comm, path, &vaf);
 	va_end(args);
 
 	ext4_handle_error(inode->i_sb);
_

Patches currently in -mm which might be from john.stultz@linaro.org are

mm-check-if-any-page-in-a-pageblock-is-reserved-before-marking-it-migrate_reserve.patch
mm-check-if-any-page-in-a-pageblock-is-reserved-before-marking-it-migrate_reserve-fix.patch
task-comm-introduce-comm_lock-seqlock-to-protect-task-comm-access.patch
task-comm-timerstats-protect-task-comm-access-by-using-get_task_comm.patch
task-comm-ext4-protect-task-comm-access-by-using-get_task_comm.patch
drivers-rtc-rtc-pcf50633c-dont-request-update-irq.patch

