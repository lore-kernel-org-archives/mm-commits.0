From: akpm@linux-foundation.org
Subject: [merged] fs-proc-use-the-pde-to-to-get-proc_dir_entry.patch
 removed from -mm tree
Date: Fri, 13 Feb 2015 12:21:37 -0800
Message-ID: <54de5cd1.DVqp66GXl0R4L+wj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48993 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698AbbBMUVi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 15:21:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kuleshovmail@gmail.com, nicolas.dichtel@6wind.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs: proc: use PDE() to get proc_dir_entry
has been removed from the -mm tree.  Its filename was
     fs-proc-use-the-pde-to-to-get-proc_dir_entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexander Kuleshov <kuleshovmail@gmail.com>
Subject: fs: proc: use PDE() to get proc_dir_entry

Use the PDE() helper to get proc_dir_entry instead of coding it directly.

Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c |    2 +-
 fs/proc/inode.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/proc/generic.c~fs-proc-use-the-pde-to-to-get-proc_dir_entry fs/proc/generic.c
--- a/fs/proc/generic.c~fs-proc-use-the-pde-to-to-get-proc_dir_entry
+++ a/fs/proc/generic.c
@@ -122,7 +122,7 @@ static int proc_getattr(struct vfsmount
 			struct kstat *stat)
 {
 	struct inode *inode = dentry->d_inode;
-	struct proc_dir_entry *de = PROC_I(inode)->pde;
+	struct proc_dir_entry *de = PDE(inode);
 	if (de && de->nlink)
 		set_nlink(inode, de->nlink);
 
diff -puN fs/proc/inode.c~fs-proc-use-the-pde-to-to-get-proc_dir_entry fs/proc/inode.c
--- a/fs/proc/inode.c~fs-proc-use-the-pde-to-to-get-proc_dir_entry
+++ a/fs/proc/inode.c
@@ -40,7 +40,7 @@ static void proc_evict_inode(struct inod
 	put_pid(PROC_I(inode)->pid);
 
 	/* Let go of any associated proc directory entry */
-	de = PROC_I(inode)->pde;
+	de = PDE(inode);
 	if (de)
 		pde_put(de);
 	head = PROC_I(inode)->sysctl;
_

Patches currently in -mm which might be from kuleshovmail@gmail.com are

origin.patch
kexec-fix-a-typo-in-comment.patch
linux-next.patch

