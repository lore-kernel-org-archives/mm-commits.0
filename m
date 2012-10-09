From: akpm@linux-foundation.org
Subject: [merged] x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-and-vm_insert_pfn.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:05:41 -0700
Message-ID: <20121009180542.39A23100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:40838 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab2JISFo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:05:44 -0400
Received: by mail-yh0-f74.google.com with SMTP id 10so573446yhl.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:05:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: suresh.b.siddha@intel.com, a.p.zijlstra@chello.nl, cmetcalf@tilera.com, cotte@de.ibm.com, eparis@redhat.com, gorcunov@openvz.org, hpa@zytor.com, hughd@google.com, james.l.morris@oracle.com, jbaron@redhat.com, khlebnikov@openvz.org, matthltc@us.ibm.com, mingo@redhat.com, npiggin@kernel.dk, oleg@redhat.com, penguin-kernel@I-love.SAKURA.ne.jp, robert.richter@amd.com, takedakn@nttdata.co.jp, torvalds@linux-foundation.org, venki@google.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: x86, pat: separate the pfn attribute tracking for remap_pfn_range and vm_insert_pfn
has been removed from the -mm tree.  Its filename was
     x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-and-vm_insert_pfn.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: x86, pat: separate the pfn attribute tracking for remap_pfn_range and vm_insert_pfn

With PAT enabled, vm_insert_pfn() looks up the existing pfn memory
attribute and uses it.  Expectation is that the driver reserves the memory
attributes for the pfn before calling vm_insert_pfn().

remap_pfn_range() (when called for the whole vma) will setup a new
attribute (based on the prot argument) for the specified pfn range.  This
addresses the legacy usage which typically calls remap_pfn_range() with a
desired memory attribute.  For ranges smaller than the vma size (which is
typically not the case), remap_pfn_range() will use the existing memory
attribute for the pfn range.

Expose two different API's for these different behaviors. 
track_pfn_insert() for tracking the pfn attribute set by vm_insert_pfn()
and track_pfn_remap() for the remap_pfn_range().

This cleanup also prepares the ground for the track/untrack pfn vma routines
to take over the ownership of setting PAT specific vm_flag in the 'vma'.

[khlebnikov@openvz.org: Clear checks in track_pfn_remap()]
[akpm@linux-foundation.org: tweak a few comments]
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Venkatesh Pallipadi <venki@google.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Carsten Otte <cotte@de.ibm.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Eric Paris <eparis@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: James Morris <james.l.morris@oracle.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Kentaro Takeda <takedakn@nttdata.co.jp>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Matt Helsley <matthltc@us.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/pat.c             |   47 ++++++++++++++++++++-------
 include/asm-generic/pgtable.h |   55 ++++++++++++++++++--------------
 mm/memory.c                   |   13 ++-----
 3 files changed, 73 insertions(+), 42 deletions(-)

diff -puN arch/x86/mm/pat.c~x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-and-vm_insert_pfn arch/x86/mm/pat.c
--- a/arch/x86/mm/pat.c~x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-and-vm_insert_pfn
+++ a/arch/x86/mm/pat.c
@@ -664,13 +664,13 @@ static void free_pfn_range(u64 paddr, un
 }
 
 /*
- * track_pfn_vma_copy is called when vma that is covering the pfnmap gets
+ * track_pfn_copy is called when vma that is covering the pfnmap gets
  * copied through copy_page_range().
  *
  * If the vma has a linear pfn mapping for the entire range, we get the prot
  * from pte and reserve the entire vma range with single reserve_pfn_range call.
  */
-int track_pfn_vma_copy(struct vm_area_struct *vma)
+int track_pfn_copy(struct vm_area_struct *vma)
 {
 	resource_size_t paddr;
 	unsigned long prot;
@@ -694,15 +694,12 @@ int track_pfn_vma_copy(struct vm_area_st
 }
 
 /*
- * track_pfn_vma_new is called when a _new_ pfn mapping is being established
- * for physical range indicated by pfn and size.
- *
  * prot is passed in as a parameter for the new mapping. If the vma has a
  * linear pfn mapping for the entire range reserve the entire vma range with
  * single reserve_pfn_range call.
  */
-int track_pfn_vma_new(struct vm_area_struct *vma, pgprot_t *prot,
-			unsigned long pfn, unsigned long size)
+int track_pfn_remap(struct vm_area_struct *vma, pgprot_t *prot,
+		    unsigned long pfn, unsigned long size)
 {
 	resource_size_t paddr = (resource_size_t)pfn << PAGE_SHIFT;
 	unsigned long flags;
@@ -714,8 +711,36 @@ int track_pfn_vma_new(struct vm_area_str
 	if (!pat_enabled)
 		return 0;
 
-	/* for vm_insert_pfn and friends, we set prot based on lookup */
+	/*
+	 * For anything smaller than the vma size we set prot based on the
+	 * lookup.
+	 */
 	flags = lookup_memtype(paddr);
+
+	/* Check memtype for the remaining pages */
+	while (size > PAGE_SIZE) {
+		size -= PAGE_SIZE;
+		paddr += PAGE_SIZE;
+		if (flags != lookup_memtype(paddr))
+			return -EINVAL;
+	}
+
+	*prot = __pgprot((pgprot_val(vma->vm_page_prot) & (~_PAGE_CACHE_MASK)) |
+			 flags);
+
+	return 0;
+}
+
+int track_pfn_insert(struct vm_area_struct *vma, pgprot_t *prot,
+		     unsigned long pfn)
+{
+	unsigned long flags;
+
+	if (!pat_enabled)
+		return 0;
+
+	/* Set prot based on lookup */
+	flags = lookup_memtype((resource_size_t)pfn << PAGE_SHIFT);
 	*prot = __pgprot((pgprot_val(vma->vm_page_prot) & (~_PAGE_CACHE_MASK)) |
 			 flags);
 
@@ -723,12 +748,12 @@ int track_pfn_vma_new(struct vm_area_str
 }
 
 /*
- * untrack_pfn_vma is called while unmapping a pfnmap for a region.
+ * untrack_pfn is called while unmapping a pfnmap for a region.
  * untrack can be called for a specific region indicated by pfn and size or
  * can be for the entire vma (in which case pfn, size are zero).
  */
-void untrack_pfn_vma(struct vm_area_struct *vma, unsigned long pfn,
-			unsigned long size)
+void untrack_pfn(struct vm_area_struct *vma, unsigned long pfn,
+		 unsigned long size)
 {
 	resource_size_t paddr;
 	unsigned long prot;
diff -puN include/asm-generic/pgtable.h~x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-and-vm_insert_pfn include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h~x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-and-vm_insert_pfn
+++ a/include/asm-generic/pgtable.h
@@ -381,48 +381,57 @@ static inline void ptep_modify_prot_comm
 
 #ifndef __HAVE_PFNMAP_TRACKING
 /*
- * Interface that can be used by architecture code to keep track of
- * memory type of pfn mappings (remap_pfn_range, vm_insert_pfn)
- *
- * track_pfn_vma_new is called when a _new_ pfn mapping is being established
- * for physical range indicated by pfn and size.
+ * Interfaces that can be used by architecture code to keep track of
+ * memory type of pfn mappings specified by the remap_pfn_range,
+ * vm_insert_pfn.
+ */
+
+/*
+ * track_pfn_remap is called when a _new_ pfn mapping is being established
+ * by remap_pfn_range() for physical range indicated by pfn and size.
  */
-static inline int track_pfn_vma_new(struct vm_area_struct *vma, pgprot_t *prot,
-					unsigned long pfn, unsigned long size)
+static inline int track_pfn_remap(struct vm_area_struct *vma, pgprot_t *prot,
+				  unsigned long pfn, unsigned long size)
 {
 	return 0;
 }
 
 /*
- * Interface that can be used by architecture code to keep track of
- * memory type of pfn mappings (remap_pfn_range, vm_insert_pfn)
- *
- * track_pfn_vma_copy is called when vma that is covering the pfnmap gets
+ * track_pfn_insert is called when a _new_ single pfn is established
+ * by vm_insert_pfn().
+ */
+static inline int track_pfn_insert(struct vm_area_struct *vma, pgprot_t *prot,
+				   unsigned long pfn)
+{
+	return 0;
+}
+
+/*
+ * track_pfn_copy is called when vma that is covering the pfnmap gets
  * copied through copy_page_range().
  */
-static inline int track_pfn_vma_copy(struct vm_area_struct *vma)
+static inline int track_pfn_copy(struct vm_area_struct *vma)
 {
 	return 0;
 }
 
 /*
- * Interface that can be used by architecture code to keep track of
- * memory type of pfn mappings (remap_pfn_range, vm_insert_pfn)
- *
  * untrack_pfn_vma is called while unmapping a pfnmap for a region.
  * untrack can be called for a specific region indicated by pfn and size or
- * can be for the entire vma (in which case size can be zero).
+ * can be for the entire vma (in which case pfn, size are zero).
  */
-static inline void untrack_pfn_vma(struct vm_area_struct *vma,
-					unsigned long pfn, unsigned long size)
+static inline void untrack_pfn(struct vm_area_struct *vma,
+			       unsigned long pfn, unsigned long size)
 {
 }
 #else
-extern int track_pfn_vma_new(struct vm_area_struct *vma, pgprot_t *prot,
-				unsigned long pfn, unsigned long size);
-extern int track_pfn_vma_copy(struct vm_area_struct *vma);
-extern void untrack_pfn_vma(struct vm_area_struct *vma, unsigned long pfn,
-				unsigned long size);
+extern int track_pfn_remap(struct vm_area_struct *vma, pgprot_t *prot,
+			   unsigned long pfn, unsigned long size);
+extern int track_pfn_insert(struct vm_area_struct *vma, pgprot_t *prot,
+			    unsigned long pfn);
+extern int track_pfn_copy(struct vm_area_struct *vma);
+extern void untrack_pfn(struct vm_area_struct *vma, unsigned long pfn,
+			unsigned long size);
 #endif
 
 #ifdef CONFIG_MMU
diff -puN mm/memory.c~x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-and-vm_insert_pfn mm/memory.c
--- a/mm/memory.c~x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-and-vm_insert_pfn
+++ a/mm/memory.c
@@ -1060,7 +1060,7 @@ int copy_page_range(struct mm_struct *ds
 		 * We do not free on error cases below as remove_vma
 		 * gets called on error from higher level routine
 		 */
-		ret = track_pfn_vma_copy(vma);
+		ret = track_pfn_copy(vma);
 		if (ret)
 			return ret;
 	}
@@ -1328,7 +1328,7 @@ static void unmap_single_vma(struct mmu_
 		uprobe_munmap(vma, start, end);
 
 	if (unlikely(is_pfn_mapping(vma)))
-		untrack_pfn_vma(vma, 0, 0);
+		untrack_pfn(vma, 0, 0);
 
 	if (start != end) {
 		if (unlikely(is_vm_hugetlb_page(vma))) {
@@ -2162,14 +2162,11 @@ int vm_insert_pfn(struct vm_area_struct 
 
 	if (addr < vma->vm_start || addr >= vma->vm_end)
 		return -EFAULT;
-	if (track_pfn_vma_new(vma, &pgprot, pfn, PAGE_SIZE))
+	if (track_pfn_insert(vma, &pgprot, pfn))
 		return -EINVAL;
 
 	ret = insert_pfn(vma, addr, pfn, pgprot);
 
-	if (ret)
-		untrack_pfn_vma(vma, pfn, PAGE_SIZE);
-
 	return ret;
 }
 EXPORT_SYMBOL(vm_insert_pfn);
@@ -2311,7 +2308,7 @@ int remap_pfn_range(struct vm_area_struc
 
 	vma->vm_flags |= VM_IO | VM_RESERVED | VM_PFNMAP;
 
-	err = track_pfn_vma_new(vma, &prot, pfn, PAGE_ALIGN(size));
+	err = track_pfn_remap(vma, &prot, pfn, PAGE_ALIGN(size));
 	if (err) {
 		/*
 		 * To indicate that track_pfn related cleanup is not
@@ -2335,7 +2332,7 @@ int remap_pfn_range(struct vm_area_struc
 	} while (pgd++, addr = next, addr != end);
 
 	if (err)
-		untrack_pfn_vma(vma, pfn, PAGE_ALIGN(size));
+		untrack_pfn(vma, pfn, PAGE_ALIGN(size));
 
 	return err;
 }
_

Patches currently in -mm which might be from suresh.b.siddha@intel.com are

origin.patch

