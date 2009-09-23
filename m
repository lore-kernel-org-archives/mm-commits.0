From: akpm@linux-foundation.org
Subject: [merged] fs-proc-task_mmuc-v1-fix-clear_refs_write-input-sanity-check.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:56:43 -0700
Message-ID: <200909231956.n8NJuhv4005451@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46024 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753352AbZIWT7S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 15:59:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: macli@brc.ubc.ca, mpm@selenic.com, rientjes@google.com, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fs/proc/task_mmu.c v1: fix clear_refs_write() input sanity check
has been removed from the -mm tree.  Its filename was
     fs-proc-task_mmuc-v1-fix-clear_refs_write-input-sanity-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/proc/task_mmu.c v1: fix clear_refs_write() input sanity check
From: Vincent Li <macli@brc.ubc.ca>

Andrew Morton pointed out similar string hacking and obfuscated check for
zero-length input at the end of the function, David Rientjes suggested to
use strict_strtol to replace simple_strtol, this patch cover above
suggestions, add removing of leading and trailing whitespace from user
input.  It does not change function behavious.

Signed-off-by: Vincent Li <macli@brc.ubc.ca>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Amerigo Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff -puN fs/proc/task_mmu.c~fs-proc-task_mmuc-v1-fix-clear_refs_write-input-sanity-check fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~fs-proc-task_mmuc-v1-fix-clear_refs_write-input-sanity-check
+++ a/fs/proc/task_mmu.c
@@ -473,21 +473,20 @@ static ssize_t clear_refs_write(struct f
 				size_t count, loff_t *ppos)
 {
 	struct task_struct *task;
-	char buffer[PROC_NUMBUF], *end;
+	char buffer[PROC_NUMBUF];
 	struct mm_struct *mm;
 	struct vm_area_struct *vma;
-	int type;
+	long type;
 
 	memset(buffer, 0, sizeof(buffer));
 	if (count > sizeof(buffer) - 1)
 		count = sizeof(buffer) - 1;
 	if (copy_from_user(buffer, buf, count))
 		return -EFAULT;
-	type = simple_strtol(buffer, &end, 0);
+	if (strict_strtol(strstrip(buffer), 10, &type))
+		return -EINVAL;
 	if (type < CLEAR_REFS_ALL || type > CLEAR_REFS_MAPPED)
 		return -EINVAL;
-	if (*end == '\n')
-		end++;
 	task = get_proc_task(file->f_path.dentry->d_inode);
 	if (!task)
 		return -ESRCH;
@@ -523,9 +522,8 @@ static ssize_t clear_refs_write(struct f
 		mmput(mm);
 	}
 	put_task_struct(task);
-	if (end - buffer == 0)
-		return -EIO;
-	return end - buffer;
+
+	return count;
 }
 
 const struct file_operations proc_clear_refs_operations = {
_

Patches currently in -mm which might be from macli@brc.ubc.ca are

origin.patch
mm-vsmcan-check-shrink_active_list-sc-isolate_pages-return-value.patch

