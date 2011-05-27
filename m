From: akpm@linux-foundation.org
Subject: [merged] kstrtox-convert-fs-proc.patch removed from -mm tree
Date: Fri, 27 May 2011 12:58:38 -0700
Message-ID: <201105271956.p4RJuhBZ017589@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39054 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757212Ab1E0UH2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 May 2011 16:07:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fs/proc: convert to kstrtoX()
has been removed from the -mm tree.  Its filename was
     kstrtox-convert-fs-proc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/proc: convert to kstrtoX()
From: Alexey Dobriyan <adobriyan@gmail.com>

Convert fs/proc/ from strict_strto*() to kstrto*() functions.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c     |   16 ++++++++--------
 fs/proc/task_mmu.c |    8 +++++---
 2 files changed, 13 insertions(+), 11 deletions(-)

diff -puN fs/proc/base.c~kstrtox-convert-fs-proc fs/proc/base.c
--- a/fs/proc/base.c~kstrtox-convert-fs-proc
+++ a/fs/proc/base.c
@@ -1059,7 +1059,7 @@ static ssize_t oom_adjust_write(struct f
 {
 	struct task_struct *task;
 	char buffer[PROC_NUMBUF];
-	long oom_adjust;
+	int oom_adjust;
 	unsigned long flags;
 	int err;
 
@@ -1071,7 +1071,7 @@ static ssize_t oom_adjust_write(struct f
 		goto out;
 	}
 
-	err = strict_strtol(strstrip(buffer), 0, &oom_adjust);
+	err = kstrtoint(strstrip(buffer), 0, &oom_adjust);
 	if (err)
 		goto out;
 	if ((oom_adjust < OOM_ADJUST_MIN || oom_adjust > OOM_ADJUST_MAX) &&
@@ -1168,7 +1168,7 @@ static ssize_t oom_score_adj_write(struc
 	struct task_struct *task;
 	char buffer[PROC_NUMBUF];
 	unsigned long flags;
-	long oom_score_adj;
+	int oom_score_adj;
 	int err;
 
 	memset(buffer, 0, sizeof(buffer));
@@ -1179,7 +1179,7 @@ static ssize_t oom_score_adj_write(struc
 		goto out;
 	}
 
-	err = strict_strtol(strstrip(buffer), 0, &oom_score_adj);
+	err = kstrtoint(strstrip(buffer), 0, &oom_score_adj);
 	if (err)
 		goto out;
 	if (oom_score_adj < OOM_SCORE_ADJ_MIN ||
@@ -1468,7 +1468,7 @@ sched_autogroup_write(struct file *file,
 	struct inode *inode = file->f_path.dentry->d_inode;
 	struct task_struct *p;
 	char buffer[PROC_NUMBUF];
-	long nice;
+	int nice;
 	int err;
 
 	memset(buffer, 0, sizeof(buffer));
@@ -1477,9 +1477,9 @@ sched_autogroup_write(struct file *file,
 	if (copy_from_user(buffer, buf, count))
 		return -EFAULT;
 
-	err = strict_strtol(strstrip(buffer), 0, &nice);
-	if (err)
-		return -EINVAL;
+	err = kstrtoint(strstrip(buffer), 0, &nice);
+	if (err < 0)
+		return err;
 
 	p = get_proc_task(inode);
 	if (!p)
diff -puN fs/proc/task_mmu.c~kstrtox-convert-fs-proc fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~kstrtox-convert-fs-proc
+++ a/fs/proc/task_mmu.c
@@ -536,15 +536,17 @@ static ssize_t clear_refs_write(struct f
 	char buffer[PROC_NUMBUF];
 	struct mm_struct *mm;
 	struct vm_area_struct *vma;
-	long type;
+	int type;
+	int rv;
 
 	memset(buffer, 0, sizeof(buffer));
 	if (count > sizeof(buffer) - 1)
 		count = sizeof(buffer) - 1;
 	if (copy_from_user(buffer, buf, count))
 		return -EFAULT;
-	if (strict_strtol(strstrip(buffer), 10, &type))
-		return -EINVAL;
+	rv = kstrtoint(strstrip(buffer), 10, &type);
+	if (rv < 0)
+		return rv;
 	if (type < CLEAR_REFS_ALL || type > CLEAR_REFS_MAPPED)
 		return -EINVAL;
 	task = get_proc_task(file->f_path.dentry->d_inode);
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
linux-next.patch
sysctl-add-proc_dointvec_bool-handler.patch

