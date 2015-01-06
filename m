From: akpm@linux-foundation.org
Subject: [failures]
 task_mmu-reduce-excessive-indentation-in-clear_refs_write.patch removed
 from -mm tree
Date: Tue, 06 Jan 2015 13:57:06 -0800
Message-ID: <54ac5a32.tBLqSFqlngLUXcLP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42926 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336AbbAFV5H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jan 2015 16:57:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: petrcermak@chromium.org, bhelgaas@google.com, primiano@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/task_mmu.c: reduce excessive indentation in clear_refs_write
has been removed from the -mm tree.  Its filename was
     task_mmu-reduce-excessive-indentation-in-clear_refs_write.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Petr Cermak <petrcermak@chromium.org>
Subject: fs/proc/task_mmu.c: reduce excessive indentation in clear_refs_write

This is a purely cosmetic fix for clear_refs_write().  It removes
excessive indentation as suggested by Bjorn Helgaas <bhelgaas@google.com>.
 This is to make upcoming changes to the file more readable.

Signed-off-by: Petr Cermak <petrcermak@chromium.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Primiano Tucci <primiano@chromium.org>
Cc: Petr Cermak <petrcermak@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |  100 +++++++++++++++++++++----------------------
 1 file changed, 51 insertions(+), 49 deletions(-)

diff -puN fs/proc/task_mmu.c~task_mmu-reduce-excessive-indentation-in-clear_refs_write fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~task_mmu-reduce-excessive-indentation-in-clear_refs_write
+++ a/fs/proc/task_mmu.c
@@ -852,59 +852,61 @@ static ssize_t clear_refs_write(struct f
 	if (!task)
 		return -ESRCH;
 	mm = get_task_mm(task);
-	if (mm) {
-		struct clear_refs_private cp = {
-			.type = type,
-		};
-		struct mm_walk clear_refs_walk = {
-			.pmd_entry = clear_refs_pte_range,
-			.mm = mm,
-			.private = &cp,
-		};
-		down_read(&mm->mmap_sem);
-		if (type == CLEAR_REFS_SOFT_DIRTY) {
-			for (vma = mm->mmap; vma; vma = vma->vm_next) {
-				if (!(vma->vm_flags & VM_SOFTDIRTY))
-					continue;
-				up_read(&mm->mmap_sem);
-				down_write(&mm->mmap_sem);
-				for (vma = mm->mmap; vma; vma = vma->vm_next) {
-					vma->vm_flags &= ~VM_SOFTDIRTY;
-					vma_set_page_prot(vma);
-				}
-				downgrade_write(&mm->mmap_sem);
-				break;
-			}
-			mmu_notifier_invalidate_range_start(mm, 0, -1);
-		}
+	if (!mm)
+		goto out_task;
+
+	struct clear_refs_private cp = {
+		.type = type,
+	};
+	struct mm_walk clear_refs_walk = {
+		.pmd_entry = clear_refs_pte_range,
+		.mm = mm,
+		.private = &cp,
+	};
+	down_read(&mm->mmap_sem);
+	if (type == CLEAR_REFS_SOFT_DIRTY) {
 		for (vma = mm->mmap; vma; vma = vma->vm_next) {
-			cp.vma = vma;
-			if (is_vm_hugetlb_page(vma))
-				continue;
-			/*
-			 * Writing 1 to /proc/pid/clear_refs affects all pages.
-			 *
-			 * Writing 2 to /proc/pid/clear_refs only affects
-			 * Anonymous pages.
-			 *
-			 * Writing 3 to /proc/pid/clear_refs only affects file
-			 * mapped pages.
-			 *
-			 * Writing 4 to /proc/pid/clear_refs affects all pages.
-			 */
-			if (type == CLEAR_REFS_ANON && vma->vm_file)
+			if (!(vma->vm_flags & VM_SOFTDIRTY))
 				continue;
-			if (type == CLEAR_REFS_MAPPED && !vma->vm_file)
-				continue;
-			walk_page_range(vma->vm_start, vma->vm_end,
-					&clear_refs_walk);
+			up_read(&mm->mmap_sem);
+			down_write(&mm->mmap_sem);
+			for (vma = mm->mmap; vma; vma = vma->vm_next) {
+				vma->vm_flags &= ~VM_SOFTDIRTY;
+				vma_set_page_prot(vma);
+			}
+			downgrade_write(&mm->mmap_sem);
+			break;
 		}
-		if (type == CLEAR_REFS_SOFT_DIRTY)
-			mmu_notifier_invalidate_range_end(mm, 0, -1);
-		flush_tlb_mm(mm);
-		up_read(&mm->mmap_sem);
-		mmput(mm);
+		mmu_notifier_invalidate_range_start(mm, 0, -1);
 	}
+	for (vma = mm->mmap; vma; vma = vma->vm_next) {
+		cp.vma = vma;
+		if (is_vm_hugetlb_page(vma))
+			continue;
+		/*
+		 * Writing 1 to /proc/pid/clear_refs affects all pages.
+		 *
+		 * Writing 2 to /proc/pid/clear_refs only affects anonymous
+		 * pages.
+		 *
+		 * Writing 3 to /proc/pid/clear_refs only affects file mapped
+		 * pages.
+		 *
+		 * Writing 4 to /proc/pid/clear_refs affects all pages.
+		 */
+		if (type == CLEAR_REFS_ANON && vma->vm_file)
+			continue;
+		if (type == CLEAR_REFS_MAPPED && !vma->vm_file)
+			continue;
+		walk_page_range(vma->vm_start, vma->vm_end, &clear_refs_walk);
+	}
+	if (type == CLEAR_REFS_SOFT_DIRTY)
+		mmu_notifier_invalidate_range_end(mm, 0, -1);
+	flush_tlb_mm(mm);
+	up_read(&mm->mmap_sem);
+	mmput(mm);
+
+out_task:
 	put_task_struct(task);
 
 	return count;
_

Patches currently in -mm which might be from petrcermak@chromium.org are

task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss.patch
task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss-fix.patch

