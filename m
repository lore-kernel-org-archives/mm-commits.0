From: akpm@linux-foundation.org
Subject: [merged] pagemap-clear_refs-modify-to-specify-anon-or-mapped-vma-clearing.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:40:31 -0700
Message-ID: <200909222040.n8MKeV9D005721@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50629 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752601AbZIVUlB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:41:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: moussa.a.ba@gmail.com, jaredeh@gmail.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     pagemap clear_refs: modify to specify anon or mapped vma clearing
has been removed from the -mm tree.  Its filename was
     pagemap-clear_refs-modify-to-specify-anon-or-mapped-vma-clearing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pagemap clear_refs: modify to specify anon or mapped vma clearing
From: "Moussa A. Ba" <moussa.a.ba@gmail.com>

The patch makes the clear_refs more versatile in adding the option to
select anonymous pages or file backed pages for clearing.  This addition
has a measurable impact on user space application performance as it
decreases the number of pagewalks in scenarios where one is only
interested in a specific type of page (anonymous or file mapped).

The patch adds anonymous and file backed filters to the clear_refs interface.

echo 1 > /proc/PID/clear_refs resets the bits on all pages
echo 2 > /proc/PID/clear_refs resets the bits on anonymous pages only
echo 3 > /proc/PID/clear_refs resets the bits on file backed pages only

Any other value is ignored

Signed-off-by: Moussa A. Ba <moussa.a.ba@gmail.com>
Signed-off-by: Jared E. Hulbert <jaredeh@gmail.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |   13 ++++++++++++
 fs/proc/task_mmu.c                 |   28 +++++++++++++++++++++++----
 2 files changed, 37 insertions(+), 4 deletions(-)

diff -puN Documentation/filesystems/proc.txt~pagemap-clear_refs-modify-to-specify-anon-or-mapped-vma-clearing Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~pagemap-clear_refs-modify-to-specify-anon-or-mapped-vma-clearing
+++ a/Documentation/filesystems/proc.txt
@@ -375,6 +375,19 @@ of memory currently marked as referenced
 This file is only present if the CONFIG_MMU kernel configuration option is
 enabled.
 
+The /proc/PID/clear_refs is used to reset the PG_Referenced and ACCESSED/YOUNG
+bits on both physical and virtual pages associated with a process.
+To clear the bits for all the pages associated with the process
+    > echo 1 > /proc/PID/clear_refs
+
+To clear the bits for the anonymous pages associated with the process
+    > echo 2 > /proc/PID/clear_refs
+
+To clear the bits for the file mapped pages associated with the process
+    > echo 3 > /proc/PID/clear_refs
+Any other value written to /proc/PID/clear_refs will have no effect.
+
+
 1.2 Kernel data
 ---------------
 
diff -puN fs/proc/task_mmu.c~pagemap-clear_refs-modify-to-specify-anon-or-mapped-vma-clearing fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~pagemap-clear_refs-modify-to-specify-anon-or-mapped-vma-clearing
+++ a/fs/proc/task_mmu.c
@@ -465,6 +465,10 @@ static int clear_refs_pte_range(pmd_t *p
 	return 0;
 }
 
+#define CLEAR_REFS_ALL 1
+#define CLEAR_REFS_ANON 2
+#define CLEAR_REFS_MAPPED 3
+
 static ssize_t clear_refs_write(struct file *file, const char __user *buf,
 				size_t count, loff_t *ppos)
 {
@@ -472,13 +476,15 @@ static ssize_t clear_refs_write(struct f
 	char buffer[PROC_NUMBUF], *end;
 	struct mm_struct *mm;
 	struct vm_area_struct *vma;
+	int type;
 
 	memset(buffer, 0, sizeof(buffer));
 	if (count > sizeof(buffer) - 1)
 		count = sizeof(buffer) - 1;
 	if (copy_from_user(buffer, buf, count))
 		return -EFAULT;
-	if (!simple_strtol(buffer, &end, 0))
+	type = simple_strtol(buffer, &end, 0);
+	if (type < CLEAR_REFS_ALL || type > CLEAR_REFS_MAPPED)
 		return -EINVAL;
 	if (*end == '\n')
 		end++;
@@ -494,9 +500,23 @@ static ssize_t clear_refs_write(struct f
 		down_read(&mm->mmap_sem);
 		for (vma = mm->mmap; vma; vma = vma->vm_next) {
 			clear_refs_walk.private = vma;
-			if (!is_vm_hugetlb_page(vma))
-				walk_page_range(vma->vm_start, vma->vm_end,
-						&clear_refs_walk);
+			if (is_vm_hugetlb_page(vma))
+				continue;
+			/*
+			 * Writing 1 to /proc/pid/clear_refs affects all pages.
+			 *
+			 * Writing 2 to /proc/pid/clear_refs only affects
+			 * Anonymous pages.
+			 *
+			 * Writing 3 to /proc/pid/clear_refs only affects file
+			 * mapped pages.
+			 */
+			if (type == CLEAR_REFS_ANON && vma->vm_file)
+				continue;
+			if (type == CLEAR_REFS_MAPPED && !vma->vm_file)
+				continue;
+			walk_page_range(vma->vm_start, vma->vm_end,
+					&clear_refs_walk);
 		}
 		flush_tlb_mm(mm);
 		up_read(&mm->mmap_sem);
_

Patches currently in -mm which might be from moussa.a.ba@gmail.com are

origin.patch

