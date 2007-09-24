From: akpm@linux-foundation.org
Subject: + maps-pssproportional-set-size-accounting-in-smaps.patch added to -mm tree
Date: Mon, 24 Sep 2007 13:32:10 -0700
Message-ID: <200709242032.l8OKWAvJ016206@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34879 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754681AbXIXUdE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Sep 2007 16:33:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wfg@mail.ustc.edu.cn, P@draigBrady.com, balbir@linux.vnet.ibm.com, bernie@codewiz.org, hugh@veritas.com, jjberthels@gmail.com, mpm@selenic.com, vda.linux@googlemail.com


The patch titled
     maps: PSS(proportional set size) accounting in smaps
has been added to the -mm tree.  Its filename is
     maps-pssproportional-set-size-accounting-in-smaps.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: maps: PSS(proportional set size) accounting in smaps
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
Acked-by: Matt Mackall <mpm@selenic.com>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   29 ++++++++++++++++++++++++++++-
 1 files changed, 28 insertions(+), 1 deletion(-)

diff -puN fs/proc/task_mmu.c~maps-pssproportional-set-size-accounting-in-smaps fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~maps-pssproportional-set-size-accounting-in-smaps
+++ a/fs/proc/task_mmu.c
@@ -324,6 +324,27 @@ struct mem_size_stats
 	unsigned long private_clean;
 	unsigned long private_dirty;
 	unsigned long referenced;
+
+	/*
+	 * Proportional Set Size(PSS): my share of RSS.
+	 *
+	 * PSS of a process is the count of pages it has in memory, where each
+	 * page is divided by the number of processes sharing it.  So if a
+	 * process has 1000 pages all to itself, and 1000 shared with one other
+	 * process, its PSS will be 1500.               - Matt Mackall, lwn.net
+	 */
+	u64 	      pss;
+	/*
+	 * To keep (accumulated) division errors low, we adopt 64bit pss and
+	 * use some low bits for division errors. So (pss >> PSS_DIV_BITS)
+	 * would be the real byte count.
+	 *
+	 * A shift of 12 before division means(assuming 4K page size):
+	 * 	- 1M 3-user-pages add up to 8KB errors;
+	 * 	- supports mapcount up to 2^24, or 16M;
+	 * 	- supports PSS up to 2^52 bytes, or 4PB.
+	 */
+#define PSS_DIV_BITS	12
 };
 
 struct smaps_arg
@@ -341,6 +362,7 @@ static int smaps_pte_range(pmd_t *pmd, u
 	pte_t *pte, ptent;
 	spinlock_t *ptl;
 	struct page *page;
+	int mapcount;
 
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
 	for (; addr != end; pte++, addr += PAGE_SIZE) {
@@ -357,16 +379,19 @@ static int smaps_pte_range(pmd_t *pmd, u
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
+			mss->pss += (PAGE_SIZE << PSS_DIV_BITS) / mapcount;
 		} else {
 			if (pte_dirty(ptent))
 				mss->private_dirty += PAGE_SIZE;
 			else
 				mss->private_clean += PAGE_SIZE;
+			mss->pss += (PAGE_SIZE << PSS_DIV_BITS);
 		}
 	}
 	pte_unmap_unlock(pte - 1, ptl);
@@ -395,6 +420,7 @@ static int show_smap(struct seq_file *m,
 	seq_printf(m,
 		   "Size:           %8lu kB\n"
 		   "Rss:            %8lu kB\n"
+		   "Pss:            %8lu kB\n"
 		   "Shared_Clean:   %8lu kB\n"
 		   "Shared_Dirty:   %8lu kB\n"
 		   "Private_Clean:  %8lu kB\n"
@@ -402,6 +428,7 @@ static int show_smap(struct seq_file *m,
 		   "Referenced:     %8lu kB\n",
 		   (vma->vm_end - vma->vm_start) >> 10,
 		   sarg.mss.resident >> 10,
+		   (unsigned long)(sarg.mss.pss >> (10 + PSS_DIV_BITS)),
 		   sarg.mss.shared_clean  >> 10,
 		   sarg.mss.shared_dirty  >> 10,
 		   sarg.mss.private_clean >> 10,
_

Patches currently in -mm which might be from wfg@mail.ustc.edu.cn are

readahead-compacting-file_ra_state.patch
readahead-mmap-read-around-simplification.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix-2.patch
radixtree-introduce-radix_tree_next_hole.patch
readahead-basic-support-of-interleaved-reads.patch
readahead-remove-the-local-copy-of-ra-in-do_generic_mapping_read.patch
readahead-remove-several-readahead-macros.patch
readahead-remove-the-limit-max_sectors_kb-imposed-on-max_readahead_kb.patch
filemap-trivial-code-cleanups.patch
filemap-convert-some-unsigned-long-to-pgoff_t.patch
make-swappiness-safer-to-use.patch
maps-pssproportional-set-size-accounting-in-smaps.patch
convert-ill-defined-log2-to-ilog2.patch
seqfile-merge-duplite-code-to-seq_open_private.patch
avoid-negative-and-full-width-shifts-in-radix-treec.patch
