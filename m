From: akpm@linux-foundation.org
Subject: +
 task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss.patch added to -mm tree
Date: Wed, 17 Dec 2014 14:31:16 -0800
Message-ID: <54920434.NJD1TmQKfelxSVlH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43375 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbaLQWbR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Dec 2014 17:31:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: petrcermak@chromium.org, bhelgaas@google.com, primiano@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/task_mmu.c: add user-space support for resetting mm->hiwater_rss (peak RSS)
has been added to the -mm tree.  Its filename is
     task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Petr Cermak <petrcermak@chromium.org>
Subject: fs/proc/task_mmu.c: add user-space support for resetting mm->hiwater_rss (peak RSS)

Peak resident size of a process can be reset back to the process's current
rss value by writing "5" to /proc/pid/clear_refs.  The driving use-case
for this would be getting the peak RSS value, which can be retrieved from
the VmHWM field in /proc/pid/status, per benchmark iteration or test
scenario.

Signed-off-by: Petr Cermak <petrcermak@chromium.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Primiano Tucci <primiano@chromium.org>
Cc: Petr Cermak <petrcermak@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |    3 +++
 fs/proc/task_mmu.c                 |   15 ++++++++++++++-
 include/linux/mm.h                 |    5 +++++
 3 files changed, 22 insertions(+), 1 deletion(-)

diff -puN Documentation/filesystems/proc.txt~task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss
+++ a/Documentation/filesystems/proc.txt
@@ -488,6 +488,9 @@ To clear the bits for the file mapped pa
 To clear the soft-dirty bit
     > echo 4 > /proc/PID/clear_refs
 
+To reset the peak resident set size ("high water mark")
+    > echo 5 > /proc/PID/clear_refs
+
 Any other value written to /proc/PID/clear_refs will have no effect.
 
 The /proc/pid/pagemap gives the PFN, which can be used to find the pageflags
diff -puN fs/proc/task_mmu.c~task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss
+++ a/fs/proc/task_mmu.c
@@ -747,6 +747,7 @@ enum clear_refs_types {
 	CLEAR_REFS_ANON,
 	CLEAR_REFS_MAPPED,
 	CLEAR_REFS_SOFT_DIRTY,
+	CLEAR_REFS_MM_HIWATER_RSS,
 	CLEAR_REFS_LAST,
 };
 
@@ -855,6 +856,17 @@ static ssize_t clear_refs_write(struct f
 	if (!mm)
 		goto out_task;
 
+	if (type == CLEAR_REFS_MM_HIWATER_RSS) {
+		/*
+		 * Writing 5 to /proc/pid/clear_refs resets the peak resident
+		 * set size.
+		 */
+		down_write(&mm->mmap_sem);
+		reset_mm_hiwater_rss(mm);
+		up_write(&mm->mmap_sem);
+		goto out_mm;
+	}
+
 	struct clear_refs_private cp = {
 		.type = type,
 	};
@@ -904,8 +916,9 @@ static ssize_t clear_refs_write(struct f
 		mmu_notifier_invalidate_range_end(mm, 0, -1);
 	flush_tlb_mm(mm);
 	up_read(&mm->mmap_sem);
-	mmput(mm);
 
+out_mm:
+	mmput(mm);
 out_task:
 	put_task_struct(task);
 
diff -puN include/linux/mm.h~task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss include/linux/mm.h
--- a/include/linux/mm.h~task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss
+++ a/include/linux/mm.h
@@ -1368,6 +1368,11 @@ static inline void update_hiwater_vm(str
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

task_mmu-reduce-excessive-indentation-in-clear_refs_write.patch
task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss.patch
task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss-fix.patch

