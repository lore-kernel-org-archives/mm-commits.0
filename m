From: akpm@linux-foundation.org
Subject: - maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch removed from -mm tree
Date: Tue, 16 Oct 2007 14:36:24 -0700
Message-ID: <200710162136.l9GLaOS4018573@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35844 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966124AbXJPVsm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:48:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mpm@selenic.com, jeremy@goop.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     maps: simplify interdependence of /proc/pid/maps and smaps
has been removed from the -mm tree.  Its filename was
     maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: maps: simplify interdependence of /proc/pid/maps and smaps
From: Matt Mackall <mpm@selenic.com>

This pulls the shared map display code out of show_map and puts it in
show_smap where it belongs.

Signed-off-by: Matt Mackall <mpm@selenic.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   48 +++++++++++++++++++++----------------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff -puN fs/proc/task_mmu.c~maps2-simplify-interdependence-of-proc-pid-maps-and-smaps fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~maps2-simplify-interdependence-of-proc-pid-maps-and-smaps
+++ a/fs/proc/task_mmu.c
@@ -125,7 +125,7 @@ struct mem_size_stats
 	unsigned long referenced;
 };
 
-static int show_map_internal(struct seq_file *m, void *v, struct mem_size_stats *mss)
+static int show_map(struct seq_file *m, void *v)
 {
 	struct proc_maps_private *priv = m->private;
 	struct task_struct *task = priv->task;
@@ -185,33 +185,11 @@ static int show_map_internal(struct seq_
 	}
 	seq_putc(m, '\n');
 
-	if (mss)
-		seq_printf(m,
-			   "Size:           %8lu kB\n"
-			   "Rss:            %8lu kB\n"
-			   "Shared_Clean:   %8lu kB\n"
-			   "Shared_Dirty:   %8lu kB\n"
-			   "Private_Clean:  %8lu kB\n"
-			   "Private_Dirty:  %8lu kB\n"
-			   "Referenced:     %8lu kB\n",
-			   (vma->vm_end - vma->vm_start) >> 10,
-			   mss->resident >> 10,
-			   mss->shared_clean  >> 10,
-			   mss->shared_dirty  >> 10,
-			   mss->private_clean >> 10,
-			   mss->private_dirty >> 10,
-			   mss->referenced >> 10);
-
 	if (m->count < m->size)  /* vma is copied successfully */
 		m->version = (vma != get_gate_vma(task))? vma->vm_start: 0;
 	return 0;
 }
 
-static int show_map(struct seq_file *m, void *v)
-{
-	return show_map_internal(m, v, NULL);
-}
-
 static int smaps_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 			   void *private)
 {
@@ -286,13 +264,35 @@ static int show_smap(struct seq_file *m,
 {
 	struct vm_area_struct *vma = v;
 	struct mem_size_stats mss;
+	int ret;
 
 	memset(&mss, 0, sizeof mss);
 	mss.vma = vma;
 	if (vma->vm_mm && !is_vm_hugetlb_page(vma))
 		walk_page_range(vma->vm_mm, vma->vm_start, vma->vm_end,
 				&smaps_walk, &mss);
-	return show_map_internal(m, v, &mss);
+
+	ret = show_map(m, v);
+	if (ret)
+		return ret;
+
+	seq_printf(m,
+		   "Size:           %8lu kB\n"
+		   "Rss:            %8lu kB\n"
+		   "Shared_Clean:   %8lu kB\n"
+		   "Shared_Dirty:   %8lu kB\n"
+		   "Private_Clean:  %8lu kB\n"
+		   "Private_Dirty:  %8lu kB\n"
+		   "Referenced:     %8lu kB\n",
+		   (vma->vm_end - vma->vm_start) >> 10,
+		   mss.resident >> 10,
+		   mss.shared_clean  >> 10,
+		   mss.shared_dirty  >> 10,
+		   mss.private_clean >> 10,
+		   mss.private_dirty >> 10,
+		   mss.referenced >> 10);
+
+	return ret;
 }
 
 static struct mm_walk clear_refs_walk = { .pmd_entry = clear_refs_pte_range };
_

Patches currently in -mm which might be from mpm@selenic.com are

origin.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-pid-pagemap-interface-fix-proc-pid-pagemap-return-length-calculation.patch
maps2-add-proc-pid-pagemap-interface-fix-proc-pid-pagemap-end-address-calculation.patch
maps2-add-proc-pid-pagemap-interface-fix-proc-pid-pagemap-header-copy-to-userspace.patch
maps2-add-proc-kpagemap-interface.patch
mmaps2-vma-out-of-mem_size_stats.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch-fix.patch
maps-pssproportional-set-size-accounting-in-smaps.patch
lib-sortc-optimization.patch
sparse-pointer-use-of-zero-as-null.patch
sparse-pointer-use-of-zero-as-null-checkpatch-fixes.patch
