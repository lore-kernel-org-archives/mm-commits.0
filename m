From: akpm@linux-foundation.org
Subject: + maps4-add-proportional-set-size-accounting-in-smaps.patch added to -mm tree
Date: Mon, 29 Oct 2007 14:57:17 -0700
Message-ID: <200710292157.l9TLvH5J025322@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36610 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752530AbXJ2V7A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Oct 2007 17:59:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wfg@mail.ustc.edu.cn, P@draigBrady.com, balbir@linux.vnet.ibm.com, bernie@codewiz.org, haveblue@us.ibm.com, hugh@veritas.com, jjberthels@gmail.com, mpm@selenic.com, vda.linux@googlemail.com


The patch titled
     maps4: add proportional set size accounting in smaps
has been added to the -mm tree.  Its filename is
     maps4-add-proportional-set-size-accounting-in-smaps.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: maps4: add proportional set size accounting in smaps
From: Fengguang Wu <wfg@mail.ustc.edu.cn>

The "proportional set size" (PSS) of a process is the count of pages it has
in memory, where each page is divided by the number of processes sharing
it.  So if a process has 1000 pages all to itself, and 1000 shared with one
other process, its PSS will be 1500.

               - lwn.net: "ELC: How much memory are applications really using?"

The PSS proposed by Matt Mackall is a very nice metic for measuring an
process's memory footprint.  So collect and export it via
/proc/<pid>/smaps.

Matt Mackall's pagemap/kpagemap and John Berthels's exmap can also do the
job.  They are comprehensive tools.  But for PSS, let's do it in the simple
way.

Cc: John Berthels <jjberthels@gmail.com>
Cc: Bernardo Innocenti <bernie@codewiz.org>
Cc: Padraig Brady <P@draigBrady.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Matt Mackall <mpm@selenic.com>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff -puN fs/proc/task_mmu.c~maps4-add-proportional-set-size-accounting-in-smaps fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~maps4-add-proportional-set-size-accounting-in-smaps
+++ a/fs/proc/task_mmu.c
@@ -114,6 +114,25 @@ static void pad_len_spaces(struct seq_fi
 	seq_printf(m, "%*c", len, ' ');
 }
 
+/*
+ * Proportional Set Size(PSS): my share of RSS.
+ *
+ * PSS of a process is the count of pages it has in memory, where each
+ * page is divided by the number of processes sharing it.  So if a
+ * process has 1000 pages all to itself, and 1000 shared with one other
+ * process, its PSS will be 1500.
+ *
+ * To keep (accumulated) division errors low, we adopt a 64bit
+ * fixed-point pss counter to minimize division errors. So (pss >>
+ * PSS_SHIFT) would be the real byte count.
+ *
+ * A shift of 12 before division means (assuming 4K page size):
+ * 	- 1M 3-user-pages add up to 8KB errors;
+ * 	- supports mapcount up to 2^24, or 16M;
+ * 	- supports PSS up to 2^52 bytes, or 4PB.
+ */
+#define PSS_SHIFT 12
+
 struct mem_size_stats
 {
 	unsigned long resident;
@@ -122,6 +141,7 @@ struct mem_size_stats
 	unsigned long private_clean;
 	unsigned long private_dirty;
 	unsigned long referenced;
+	u64 pss;
 };
 
 struct pmd_walker {
@@ -195,6 +215,7 @@ static int show_map_internal(struct seq_
 		seq_printf(m,
 			   "Size:           %8lu kB\n"
 			   "Rss:            %8lu kB\n"
+			   "Pss:            %8lu kB\n"
 			   "Shared_Clean:   %8lu kB\n"
 			   "Shared_Dirty:   %8lu kB\n"
 			   "Private_Clean:  %8lu kB\n"
@@ -202,6 +223,7 @@ static int show_map_internal(struct seq_
 			   "Referenced:     %8lu kB\n",
 			   (vma->vm_end - vma->vm_start) >> 10,
 			   mss->resident >> 10,
+			   (unsigned long)(mss.pss >> (10 + PSS_SHIFT)),
 			   mss->shared_clean  >> 10,
 			   mss->shared_dirty  >> 10,
 			   mss->private_clean >> 10,
@@ -226,6 +248,7 @@ static void smaps_pte_range(struct vm_ar
 	pte_t *pte, ptent;
 	spinlock_t *ptl;
 	struct page *page;
+	int mapcount;
 
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
 	for (; addr != end; pte++, addr += PAGE_SIZE) {
@@ -242,16 +265,19 @@ static void smaps_pte_range(struct vm_ar
 		/* Accumulate the size in pages that have been accessed. */
 		if (pte_young(ptent) || PageReferenced(page))
 			mss->referenced += PAGE_SIZE;
-		if (page_mapcount(page) >= 2) {
+		mapcount = page_mapcount(page);
+		if (mapcount >= 2) {
 			if (pte_dirty(ptent))
 				mss->shared_dirty += PAGE_SIZE;
 			else
 				mss->shared_clean += PAGE_SIZE;
+			mss->pss += (PAGE_SIZE << PSS_SHIFT) / mapcount;
 		} else {
 			if (pte_dirty(ptent))
 				mss->private_dirty += PAGE_SIZE;
 			else
 				mss->private_clean += PAGE_SIZE;
+			mss->pss += (PAGE_SIZE << PSS_SHIFT);
 		}
 	}
 	pte_unmap_unlock(pte - 1, ptl);
_

Patches currently in -mm which might be from wfg@mail.ustc.edu.cn are

reiserfs-dont-drop-pg_dirty-when-releasing-sub-page-sized-dirty-file.patch
maps4-add-proportional-set-size-accounting-in-smaps.patch
