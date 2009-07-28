From: akpm@linux-foundation.org
Subject: + pagemap-clear_refs-modify-to-specify-anon-or-mapped-vma-clearing.patch added to -mm tree
Date: Tue, 28 Jul 2009 16:52:49 -0700
Message-ID: <200907282352.n6SNqnjO028571@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35530 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756036AbZG1XxX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Jul 2009 19:53:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: moussa.a.ba@gmail.com, jaredeh@gmail.com, rientjes@google.com


The patch titled
     pagemap clear_refs: modify to specify anon or mapped vma clearing
has been added to the -mm tree.  Its filename is
     pagemap-clear_refs-modify-to-specify-anon-or-mapped-vma-clearing.patch

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
Subject: pagemap clear_refs: modify to specify anon or mapped vma clearing
From: "Moussa A. Ba" <moussa.a.ba@gmail.com>

Make the clear_refs proc interface a bit more versatile by adding support
for clearing anonymous pages, file mapped pages or both.

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
@@ -464,6 +464,10 @@ static int clear_refs_pte_range(pmd_t *p
 	return 0;
 }
 
+#define CLEAR_REFS_ALL 1
+#define CLEAR_REFS_ANON 2
+#define CLEAR_REFS_MAPPED 3
+
 static ssize_t clear_refs_write(struct file *file, const char __user *buf,
 				size_t count, loff_t *ppos)
 {
@@ -471,13 +475,15 @@ static ssize_t clear_refs_write(struct f
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
@@ -493,9 +499,23 @@ static ssize_t clear_refs_write(struct f
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

pagemap-clear_refs-modify-to-specify-anon-or-mapped-vma-clearing.patch

