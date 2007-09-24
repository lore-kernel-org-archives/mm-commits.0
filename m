From: akpm@linux-foundation.org
Subject: - maps2-export-page-index-in-kpagemap.patch removed from -mm tree
Date: Mon, 24 Sep 2007 14:02:48 -0700
Message-ID: <200709242102.l8OL2ntl017530@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47473 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756903AbXIXVIk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Sep 2007 17:08:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wfg@mail.ustc.edu.cn, balbir@linux.vnet.ibm.com, haveblue@us.ibm.com, jjberthels@gmail.com, mpm@selenic.com, mm-commits@vger.kernel.org


The patch titled
     maps2: export page index in kpagemap
has been removed from the -mm tree.  Its filename was
     maps2-export-page-index-in-kpagemap.patch

This patch was dropped because maybe not

------------------------------------------------------
Subject: maps2: export page index in kpagemap
From: Fengguang Wu <wfg@mail.ustc.edu.cn>

To analyze/optimize the memory footprint, the number one question people
may ask about pagemap/kpagemap could be:

	Which part of the files are being actively mapped?

In the (rare) case of nonlinear mapping, that question could only be
answered by explicitly exporting the page index in kpagemap.  Simply
judging by the PFNs from pagemap could be wrong!

Cc: Matt Mackall <mpm@selenic.com>
Cc: John Berthels <jjberthels@gmail.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_misc.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff -puN fs/proc/proc_misc.c~maps2-export-page-index-in-kpagemap fs/proc/proc_misc.c
--- a/fs/proc/proc_misc.c~maps2-export-page-index-in-kpagemap
+++ a/fs/proc/proc_misc.c
@@ -672,8 +672,8 @@ static const struct file_operations proc
 #endif
 
 #ifdef CONFIG_PROC_PAGE_MONITOR
-#define KPMSIZE (sizeof(unsigned long) * 2)
-#define KPMMASK (KPMSIZE - 1)
+#define KPMITEMS 3
+#define KPMSIZE (sizeof(unsigned long) * KPMITEMS)
 /* /proc/kpagemap - an array exposing page flags and counts
  *
  * Each entry is a pair of unsigned longs representing the
@@ -699,7 +699,7 @@ static ssize_t kpagemap_read(struct file
 
 	pfn = src / KPMSIZE - 1;
 	count = min_t(unsigned long, count, ((max_pfn + 1) * KPMSIZE) - src);
-	if (src & KPMMASK || count & KPMMASK)
+	if (src % KPMITEMS || count % KPMITEMS)
 		return -EIO;
 
 	page = (unsigned long *)__get_free_page(GFP_USER);
@@ -713,25 +713,28 @@ static ssize_t kpagemap_read(struct file
 		if (pfn == -1) {
 			page[0] = 0;
 			page[1] = 0;
+			page[2] = 0;
 			((char *)page)[0] = (ntohl(1) != 1);
 			((char *)page)[1] = PAGE_SHIFT;
 			((char *)page)[2] = sizeof(unsigned long);
 			((char *)page)[3] = KPMSIZE;
-			i = 2;
+			i = KPMITEMS;
 			pfn++;
 		}
 
-		for (; i < 2 * chunk / KPMSIZE; i += 2, pfn++) {
+		for (; i < KPMITEMS * chunk / KPMSIZE; i += KPMITEMS, pfn++) {
 			ppage = pfn_to_page(pfn);
 			if (!ppage) {
 				page[i] = 0;
 				page[i + 1] = 0;
+				page[i + 2] = 0;
 			} else {
 				page[i] = ppage->flags;
 				page[i + 1] = atomic_read(&ppage->_count);
+				page[i + 2] = page_index(ppage);
 			}
 		}
-		chunk = (i / 2) * KPMSIZE;
+		chunk = (i / KPMITEMS) * KPMSIZE;
 
 		if (copy_to_user(buf, page, chunk)) {
 			ret = -EFAULT;
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
maps2-export-page-index-in-kpagemap.patch
maps-pssproportional-set-size-accounting-in-smaps.patch
convert-ill-defined-log2-to-ilog2.patch
seqfile-merge-duplite-code-to-seq_open_private.patch
avoid-negative-and-full-width-shifts-in-radix-treec.patch
