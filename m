From: akpm@linux-foundation.org
Subject: - smaps-add-pages-referenced-count-to-smaps.patch removed from -mm tree
Date: Mon, 07 May 2007 17:02:27 -0700
Message-ID: <200705080002.l4802ROx008844@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60358 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967487AbXEHAMF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:12:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, clameter@sgi.com, hugh@veritas.com, lethal@linux-sh.org, mm-commits@vger.kernel.org


The patch titled
     smaps: add pages referenced count to smaps
has been removed from the -mm tree.  Its filename was
     smaps-add-pages-referenced-count-to-smaps.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 13 insertions(+), 7 deletions(-)

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

origin.patch
git-alsa.patch
maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-kpagemap-interface.patch
cpusets-allow-empty-cpusmems_allowed-to-be-set-for.patch
cpusets-allow-empty-cpusmems_allowed-to-be-set-for-fix.patch
compiler-introduce-__used-and-__maybe_unused.patch
i386-pci-type-may-be-unused.patch
sh-dma-use-__maybe_unused.patch
scsi-fix-ambiguous-gdthtable-definition.patch
frv-gdb-use-__maybe_unused.patch
i386-voyager-use-__maybe_unused.patch
mips-excite-use-__maybe_unused.patch
mips-tlbex-use-__maybe_unused.patch
powerpc-ps3-use-__maybe_unused.patch
i386-mmzone-use-__maybe_unused.patch
