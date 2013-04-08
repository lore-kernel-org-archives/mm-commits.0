From: akpm@linux-foundation.org
Subject: [wrecked] procfs-improve-scaling-in-proc-v5.patch removed from -mm tree
Date: Mon, 08 Apr 2013 11:57:56 -0700
Message-ID: <20130408185756.9D3BE31C24B@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ia0-f201.google.com ([209.85.210.201]:48965 "EHLO
	mail-ia0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935549Ab3DHS56 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Apr 2013 14:57:58 -0400
Received: by mail-ia0-f201.google.com with SMTP id k25so440327iah.0
        for <mm-commits@vger.kernel.org>; Mon, 08 Apr 2013 11:57:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nzimmer@sgi.com, adobriyan@gmail.com, dwmw2@infradead.org, ebiederm@xmission.com, eric.dumazet@gmail.com, paulmck@linux.vnet.ibm.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: procfs-improve-scaling-in-proc-v5
has been removed from the -mm tree.  Its filename was
     procfs-improve-scaling-in-proc-v5.patch

This patch was dropped because other changes were merged, which wrecked this patch

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
 	struct inode *inode = new_inode_pseudo(sb);
+	const struct file_operations *fops;
 
 	if (inode) {
 		inode->i_ino = de->low_ino;
@@ -481,19 +483,22 @@ struct inode *proc_get_inode(struct supe
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
 	} else
 	       pde_put(de);
 	return inode;
_

Patches currently in -mm which might be from nzimmer@sgi.com are

linux-next.patch
timer_list-split-timer_list_show_tickdevices.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-v5.patch

