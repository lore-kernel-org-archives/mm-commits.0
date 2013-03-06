From: akpm@linux-foundation.org
Subject: + procfs-improve-scaling-in-proc-v5.patch added to -mm tree
Date: Tue, 05 Mar 2013 16:01:46 -0800
Message-ID: <20130306000146.7E35F31C204@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:61946 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575Ab3CFABs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Mar 2013 19:01:48 -0500
Received: by mail-qa0-f73.google.com with SMTP id g10so422516qah.2
        for <mm-commits@vger.kernel.org>; Tue, 05 Mar 2013 16:01:47 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nzimmer@sgi.com, adobriyan@gmail.com, dwmw2@infradead.org, ebiederm@xmission.com, eric.dumazet@gmail.com, paulmck@linux.vnet.ibm.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: procfs-improve-scaling-in-proc-v5
has been added to the -mm tree.  Its filename is
     procfs-improve-scaling-in-proc-v5.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nathan Zimmer <nzimmer@sgi.com>
Subject: procfs-improve-scaling-in-proc-v5

v5: Corrected some warnings from sparce including the supplied by Sasha.

Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/inode.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff -puN fs/proc/inode.c~procfs-improve-scaling-in-proc-v5 fs/proc/inode.c
--- a/fs/proc/inode.c~procfs-improve-scaling-in-proc-v5
+++ a/fs/proc/inode.c
@@ -284,7 +284,7 @@ static long proc_reg_compat_ioctl(struct
 		return rv;
 	}
 	atomic_inc(&pde->pde_users);
-	compat_ioctl = pde->proc_fops->compat_ioctl;
+	compat_ioctl = fops->compat_ioctl;
 	rcu_read_unlock();
 
 	if (compat_ioctl)
@@ -309,7 +309,7 @@ static int proc_reg_mmap(struct file *fi
 		return rv;
 	}
 	atomic_inc(&pde->pde_users);
-	mmap = pde->proc_fops->mmap;
+	mmap = fops->mmap;
 	rcu_read_unlock();
 
 	if (mmap)
@@ -352,7 +352,7 @@ static int proc_reg_open(struct inode *i
 	atomic_inc(&pde->pde_users);
 	open = fops->open;
 	release = fops->release;
-	rcu_read_lock();
+	rcu_read_unlock();
 
 	if (open)
 		rv = open(inode, file);
@@ -400,6 +400,7 @@ static int proc_reg_release(struct inode
 	rcu_read_lock();
 	fops = rcu_dereference(pde->proc_fops);
 	if (!fops) {
+		rcu_read_unlock();
 		/*
 		 * Can't simply exit, __fput() will think that everything is OK,
 		 * and move on to freeing struct file. remove_proc_entry() will
@@ -464,6 +465,7 @@ static const struct file_operations proc
 struct inode *proc_get_inode(struct super_block *sb, struct proc_dir_entry *de)
 {
 	struct inode *inode = iget_locked(sb, de->low_ino);
+	const struct file_operations *fops;
 
 	if (inode && (inode->i_state & I_NEW)) {
 		inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
@@ -480,19 +482,22 @@ struct inode *proc_get_inode(struct supe
 			set_nlink(inode, de->nlink);
 		if (de->proc_iops)
 			inode->i_op = de->proc_iops;
-		if (de->proc_fops) {
+		rcu_read_lock();
+		fops = rcu_dereference(de->proc_fops);
+		if (fops) {
 			if (S_ISREG(inode->i_mode)) {
 #ifdef CONFIG_COMPAT
-				if (!de->proc_fops->compat_ioctl)
+				if (!fops->compat_ioctl)
 					inode->i_fop =
 						&proc_reg_file_ops_no_compat;
 				else
 #endif
 					inode->i_fop = &proc_reg_file_ops;
 			} else {
-				inode->i_fop = de->proc_fops;
+				inode->i_fop = fops;
 			}
 		}
+		rcu_read_unlock();
 		unlock_new_inode(inode);
 	} else
 	       pde_put(de);
_

Patches currently in -mm which might be from nzimmer@sgi.com are

timer_list-split-timer_list_show_tickdevices.patch
timer_list-split-timer_list_show_tickdevices-v4.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-v3.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-v3-fix.patch
procfs-improve-scaling-in-proc.patch
procfs-improve-scaling-in-proc-v5.patch
procfs-improve-scaling-in-proc-fix.patch

