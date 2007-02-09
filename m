From: akpm@linux-foundation.org
Subject: + smaps-add-pages-referenced-count-to-smaps.patch added to -mm tree
Date: Fri, 09 Feb 2007 15:39:47 -0800
Message-ID: <200702092339.l19NdlqV029894@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:54711 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752553AbXBIXkA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 9 Feb 2007 18:40:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, clameter@sgi.com, hugh@veritas.com, lethal@linux-sh.org


The patch titled
     smaps: add pages referenced count to smaps
has been added to the -mm tree.  Its filename is
     smaps-add-pages-referenced-count-to-smaps.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: smaps: add pages referenced count to smaps
From: David Rientjes <rientjes@google.com>

Adds an additional unsigned long field to struct mem_size_stats called
'referenced'.  For each pte walked in the smaps code, this field is
incremented by PAGE_SIZE if it has pte-reference bits.

An additional line was added to the /proc/pid/smaps output for each VMA to
indicate how many pages within it are currently marked as referenced or
accessed.

Cc: Hugh Dickins <hugh@veritas.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   20 +++++++++++++-------
 1 files changed, 13 insertions(+), 7 deletions(-)

diff -puN fs/proc/task_mmu.c~smaps-add-pages-referenced-count-to-smaps fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~smaps-add-pages-referenced-count-to-smaps
+++ a/fs/proc/task_mmu.c
@@ -120,6 +120,7 @@ struct mem_size_stats
 	unsigned long shared_dirty;
 	unsigned long private_clean;
 	unsigned long private_dirty;
+	unsigned long referenced;
 };
 
 struct pmd_walker {
@@ -188,18 +189,20 @@ static int show_map_internal(struct seq_
 
 	if (mss)
 		seq_printf(m,
-			   "Size:          %8lu kB\n"
-			   "Rss:           %8lu kB\n"
-			   "Shared_Clean:  %8lu kB\n"
-			   "Shared_Dirty:  %8lu kB\n"
-			   "Private_Clean: %8lu kB\n"
-			   "Private_Dirty: %8lu kB\n",
+			   "Size:           %8lu kB\n"
+			   "Rss:            %8lu kB\n"
+			   "Shared_Clean:   %8lu kB\n"
+			   "Shared_Dirty:   %8lu kB\n"
+			   "Private_Clean:  %8lu kB\n"
+			   "Private_Dirty:  %8lu kB\n"
+			   "Pgs_Referenced: %8lu kB\n",
 			   (vma->vm_end - vma->vm_start) >> 10,
 			   mss->resident >> 10,
 			   mss->shared_clean  >> 10,
 			   mss->shared_dirty  >> 10,
 			   mss->private_clean >> 10,
-			   mss->private_dirty >> 10);
+			   mss->private_dirty >> 10,
+			   mss->referenced >> 10);
 
 	if (m->count < m->size)  /* vma is copied successfully */
 		m->version = (vma != get_gate_vma(task))? vma->vm_start: 0;
@@ -232,6 +235,9 @@ static void smaps_one_pmd(struct vm_area
 		if (!page)
 			continue;
 
+		/* Accumulate the size in pages that have been accessed. */
+		if (pte_young(ptent) || PageReferenced(page))
+			mss->referenced += PAGE_SIZE;
 		if (page_mapcount(page) >= 2) {
 			if (pte_dirty(ptent))
 				mss->shared_dirty += PAGE_SIZE;
_

Patches currently in -mm which might be from rientjes@google.com are

smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
