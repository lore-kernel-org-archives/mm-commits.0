From: akpm@linux-foundation.org
Subject: [merged]
 task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss.patch removed from -mm tree
Date: Fri, 13 Feb 2015 12:21:35 -0800
Message-ID: <54de5ccf.Ot+wYl+Fwt2sDR9x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48990 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698AbbBMUVg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 15:21:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: petrcermak@chromium.org, bhelgaas@google.com, primiano@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/task_mmu.c: add user-space support for resetting mm->hiwater_rss (peak RSS)
has been removed from the -mm tree.  Its filename was
     task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Petr Cermak <petrcermak@chromium.org>
Subject: fs/proc/task_mmu.c: add user-space support for resetting mm->hiwater_rss (peak RSS)

Peak resident size of a process can be reset back to the process's current
rss value by writing "5" to /proc/pid/clear_refs.  The driving use-case
for this would be getting the peak RSS value, which can be retrieved from
the VmHWM field in /proc/pid/status, per benchmark iteration or test
scenario.

[akpm@linux-foundation.org: clarify behaviour in documentation]
Signed-off-by: Petr Cermak <petrcermak@chromium.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Primiano Tucci <primiano@chromium.org>
Cc: Petr Cermak <petrcermak@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |    4 ++++
 fs/proc/task_mmu.c                 |   14 ++++++++++++++
 include/linux/mm.h                 |    5 +++++
 3 files changed, 23 insertions(+)

diff -puN Documentation/filesystems/proc.txt~task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss
+++ a/Documentation/filesystems/proc.txt
@@ -489,6 +489,10 @@ To clear the bits for the file mapped pa
 To clear the soft-dirty bit
     > echo 4 > /proc/PID/clear_refs
 
+To reset the peak resident set size ("high water mark") to the process's
+current value:
+    > echo 5 > /proc/PID/clear_refs
+
 Any other value written to /proc/PID/clear_refs will have no effect.
 
 The /proc/pid/pagemap gives the PFN, which can be used to find the pageflags
diff -puN fs/proc/task_mmu.c~task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss
+++ a/fs/proc/task_mmu.c
@@ -732,6 +732,7 @@ enum clear_refs_types {
 	CLEAR_REFS_ANON,
 	CLEAR_REFS_MAPPED,
 	CLEAR_REFS_SOFT_DIRTY,
+	CLEAR_REFS_MM_HIWATER_RSS,
 	CLEAR_REFS_LAST,
 };
 
@@ -907,6 +908,18 @@ static ssize_t clear_refs_write(struct f
 			.mm = mm,
 			.private = &cp,
 		};
+
+		if (type == CLEAR_REFS_MM_HIWATER_RSS) {
+			/*
+			 * Writing 5 to /proc/pid/clear_refs resets the peak
+			 * resident set size to this mm's current rss value.
+			 */
+			down_write(&mm->mmap_sem);
+			reset_mm_hiwater_rss(mm);
+			up_write(&mm->mmap_sem);
+			goto out_mm;
+		}
+
 		down_read(&mm->mmap_sem);
 		if (type == CLEAR_REFS_SOFT_DIRTY) {
 			for (vma = mm->mmap; vma; vma = vma->vm_next) {
@@ -928,6 +941,7 @@ static ssize_t clear_refs_write(struct f
 			mmu_notifier_invalidate_range_end(mm, 0, -1);
 		flush_tlb_mm(mm);
 		up_read(&mm->mmap_sem);
+out_mm:
 		mmput(mm);
 	}
 	put_task_struct(task);
diff -puN include/linux/mm.h~task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss include/linux/mm.h
--- a/include/linux/mm.h~task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss
+++ a/include/linux/mm.h
@@ -1408,6 +1408,11 @@ static inline void update_hiwater_vm(str
 		mm->hiwater_vm = mm->total_vm;
 }
 
+static inline void reset_mm_hiwater_rss(struct mm_struct *mm)
+{
+	mm->hiwater_rss = get_mm_rss(mm);
+}
+
 static inline void setmax_mm_hiwater_rss(unsigned long *maxrss,
 					 struct mm_struct *mm)
 {
_

Patches currently in -mm which might be from petrcermak@chromium.org are

origin.patch

