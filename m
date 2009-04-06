From: akpm@linux-foundation.org
Subject: [folded] proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-cleanup.patch removed from -mm tree
Date: Mon, 06 Apr 2009 15:03:34 -0700
Message-ID: <200904062203.n36M3YbN005391@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53125 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751964AbZDFWGk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 18:06:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, hugh@veritas.com, mikew@google.com, yinghan@google.com, mm-commits@vger.kernel.org


The patch titled
     proc pid maps dont show pgoff of pure anon vmas style fix
has been removed from the -mm tree.  Its filename was
     proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-cleanup.patch

This patch was dropped because it was folded into proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc pid maps dont show pgoff of pure anon vmas style fix
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Fix conding style of proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas.patch

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mike Waychison <mikew@google.com>
Cc: Ying Han <yinghan@google.com>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c   |    5 +++--
 fs/proc/task_nommu.c |    5 +++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff -puN fs/proc/task_mmu.c~proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-cleanup fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-cleanup
+++ a/fs/proc/task_mmu.c
@@ -204,6 +204,7 @@ static void show_map_vma(struct seq_file
 	struct file *file = vma->vm_file;
 	int flags = vma->vm_flags;
 	unsigned long ino = 0;
+	unsigned long long pgoff = 0;
 	dev_t dev = 0;
 	int len;
 
@@ -211,6 +212,7 @@ static void show_map_vma(struct seq_file
 		struct inode *inode = vma->vm_file->f_path.dentry->d_inode;
 		dev = inode->i_sb->s_dev;
 		ino = inode->i_ino;
+		pgoff = ((loff_t)vma->vm_pgoff) << PAGE_SHIFT;
 	}
 
 	seq_printf(m, "%08lx-%08lx %c%c%c%c %08llx %02x:%02x %lu %n",
@@ -220,8 +222,7 @@ static void show_map_vma(struct seq_file
 			flags & VM_WRITE ? 'w' : '-',
 			flags & VM_EXEC ? 'x' : '-',
 			flags & VM_MAYSHARE ? 's' : 'p',
-			(!vma->vm_file) ? 0 :
-				((loff_t)vma->vm_pgoff) << PAGE_SHIFT,
+			pgoff,
 			MAJOR(dev), MINOR(dev), ino, &len);
 
 	/*
diff -puN fs/proc/task_nommu.c~proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-cleanup fs/proc/task_nommu.c
--- a/fs/proc/task_nommu.c~proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-cleanup
+++ a/fs/proc/task_nommu.c
@@ -126,6 +126,7 @@ static int nommu_vma_show(struct seq_fil
 	struct file *file;
 	dev_t dev = 0;
 	int flags, len;
+	unsigned long long pgoff = 0;
 
 	flags = vma->vm_flags;
 	file = vma->vm_file;
@@ -134,6 +135,7 @@ static int nommu_vma_show(struct seq_fil
 		struct inode *inode = vma->vm_file->f_path.dentry->d_inode;
 		dev = inode->i_sb->s_dev;
 		ino = inode->i_ino;
+		pgoff = (loff_t)vma->pg_off << PAGE_SHIFT;
 	}
 
 	seq_printf(m,
@@ -144,8 +146,7 @@ static int nommu_vma_show(struct seq_fil
 		   flags & VM_WRITE ? 'w' : '-',
 		   flags & VM_EXEC ? 'x' : '-',
 		   flags & VM_MAYSHARE ? flags & VM_SHARED ? 'S' : 's' : 'p',
-		   (!vma->vm_file) ? 0 :
-			(unsigned long long) vma->vm_pgoff << PAGE_SHIFT,
+		   pgoff,
 		   MAJOR(dev), MINOR(dev), ino, &len);
 
 	if (file) {
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-cleanup.patch

