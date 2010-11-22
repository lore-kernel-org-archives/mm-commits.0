From: akpm@linux-foundation.org
Subject: + mm-remove-gfp-mask-from-pcpu_get_vm_areas.patch added to -mm tree
Date: Mon, 22 Nov 2010 15:36:54 -0800
Message-ID: <201011222336.oAMNasQC015684@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32783 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757813Ab0KVXhE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Nov 2010 18:37:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, cl@linux.com, tj@kernel.org


The patch titled
     mm: remove gfp mask from pcpu_get_vm_areas
has been added to the -mm tree.  Its filename is
     mm-remove-gfp-mask-from-pcpu_get_vm_areas.patch

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
Subject: mm: remove gfp mask from pcpu_get_vm_areas
From: David Rientjes <rientjes@google.com>

pcpu_get_vm_areas() only uses GFP_KERNEL allocations, so remove the gfp_t
formal and use the mask internally.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmalloc.h |    2 +-
 mm/percpu-vm.c          |    2 +-
 mm/vmalloc.c            |   21 +++++++++------------
 3 files changed, 11 insertions(+), 14 deletions(-)

diff -puN include/linux/vmalloc.h~mm-remove-gfp-mask-from-pcpu_get_vm_areas include/linux/vmalloc.h
--- a/include/linux/vmalloc.h~mm-remove-gfp-mask-from-pcpu_get_vm_areas
+++ a/include/linux/vmalloc.h
@@ -119,7 +119,7 @@ extern __init void vm_area_register_earl
 #ifdef CONFIG_SMP
 struct vm_struct **pcpu_get_vm_areas(const unsigned long *offsets,
 				     const size_t *sizes, int nr_vms,
-				     size_t align, gfp_t gfp_mask);
+				     size_t align);
 
 void pcpu_free_vm_areas(struct vm_struct **vms, int nr_vms);
 #endif
diff -puN mm/percpu-vm.c~mm-remove-gfp-mask-from-pcpu_get_vm_areas mm/percpu-vm.c
--- a/mm/percpu-vm.c~mm-remove-gfp-mask-from-pcpu_get_vm_areas
+++ a/mm/percpu-vm.c
@@ -421,7 +421,7 @@ static struct pcpu_chunk *pcpu_create_ch
 		return NULL;
 
 	vms = pcpu_get_vm_areas(pcpu_group_offsets, pcpu_group_sizes,
-				pcpu_nr_groups, pcpu_atom_size, GFP_KERNEL);
+				pcpu_nr_groups, pcpu_atom_size);
 	if (!vms) {
 		pcpu_free_chunk(chunk);
 		return NULL;
diff -puN mm/vmalloc.c~mm-remove-gfp-mask-from-pcpu_get_vm_areas mm/vmalloc.c
--- a/mm/vmalloc.c~mm-remove-gfp-mask-from-pcpu_get_vm_areas
+++ a/mm/vmalloc.c
@@ -2247,17 +2247,16 @@ static unsigned long pvm_determine_end(s
  * @sizes: array containing size of each area
  * @nr_vms: the number of areas to allocate
  * @align: alignment, all entries in @offsets and @sizes must be aligned to this
- * @gfp_mask: allocation mask
  *
  * Returns: kmalloc'd vm_struct pointer array pointing to allocated
  *	    vm_structs on success, %NULL on failure
  *
  * Percpu allocator wants to use congruent vm areas so that it can
  * maintain the offsets among percpu areas.  This function allocates
- * congruent vmalloc areas for it.  These areas tend to be scattered
- * pretty far, distance between two areas easily going up to
- * gigabytes.  To avoid interacting with regular vmallocs, these areas
- * are allocated from top.
+ * congruent vmalloc areas for it with GFP_KERNEL.  These areas tend to
+ * be scattered pretty far, distance between two areas easily going up
+ * to gigabytes.  To avoid interacting with regular vmallocs, these
+ * areas are allocated from top.
  *
  * Despite its complicated look, this allocator is rather simple.  It
  * does everything top-down and scans areas from the end looking for
@@ -2268,7 +2267,7 @@ static unsigned long pvm_determine_end(s
  */
 struct vm_struct **pcpu_get_vm_areas(const unsigned long *offsets,
 				     const size_t *sizes, int nr_vms,
-				     size_t align, gfp_t gfp_mask)
+				     size_t align)
 {
 	const unsigned long vmalloc_start = ALIGN(VMALLOC_START, align);
 	const unsigned long vmalloc_end = VMALLOC_END & ~(align - 1);
@@ -2278,8 +2277,6 @@ struct vm_struct **pcpu_get_vm_areas(con
 	unsigned long base, start, end, last_end;
 	bool purged = false;
 
-	gfp_mask &= GFP_RECLAIM_MASK;
-
 	/* verify parameters and allocate data structures */
 	BUG_ON(align & ~PAGE_MASK || !is_power_of_2(align));
 	for (last_area = 0, area = 0; area < nr_vms; area++) {
@@ -2312,14 +2309,14 @@ struct vm_struct **pcpu_get_vm_areas(con
 		return NULL;
 	}
 
-	vms = kzalloc(sizeof(vms[0]) * nr_vms, gfp_mask);
-	vas = kzalloc(sizeof(vas[0]) * nr_vms, gfp_mask);
+	vms = kzalloc(sizeof(vms[0]) * nr_vms, GFP_KERNEL);
+	vas = kzalloc(sizeof(vas[0]) * nr_vms, GFP_KERNEL);
 	if (!vas || !vms)
 		goto err_free;
 
 	for (area = 0; area < nr_vms; area++) {
-		vas[area] = kzalloc(sizeof(struct vmap_area), gfp_mask);
-		vms[area] = kzalloc(sizeof(struct vm_struct), gfp_mask);
+		vas[area] = kzalloc(sizeof(struct vmap_area), GFP_KERNEL);
+		vms[area] = kzalloc(sizeof(struct vm_struct), GFP_KERNEL);
 		if (!vas[area] || !vms[area])
 			goto err_free;
 	}
_

Patches currently in -mm which might be from rientjes@google.com are

linux-next.patch
mm-remove-call-to-find_vma-in-pagewalk-for-non-hugetlbfs.patch
mm-remove-unused-get_vm_area_node.patch
mm-remove-gfp-mask-from-pcpu_get_vm_areas.patch
mm-unify-module_alloc-code-for-vmalloc.patch
jbd-remove-dependency-on-__gfp_nofail.patch

