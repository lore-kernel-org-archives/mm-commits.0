Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5E492472AE
	for <mm-commits@vger.kernel.org>; Mon, 20 Jul 2026 19:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784576926; cv=none; b=KEHm2g56L27GDb6vcmQB5IiGNynVk8siGHrXxx7Am5iAzx+Zvsp5cBEhV8fhZYPsHxJDewxS/La34FOZ62L2Hb8VnAYdfizUzF6y1/C5y+Fj/zWwphlCknPKGWPYT51mbV7prpouFYmgPBJAhyynoobVqLtZUA1njYFx3L3duNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784576926; c=relaxed/simple;
	bh=q+nrVcPrL7cxzBMwGL3IO45ildP3Wg3Oe82RfQZeB9A=;
	h=Date:To:From:Subject:Message-Id; b=WACOcUmsD9o44Qz+gPzokPgUdNJ0vXq5D8aj86M/MyGna1/KBeudJF7Fcj1dT9qxFWmyacGGodg8l1QwmHmp4MSrCYitBD/BJ2qLut/wIyrQH14abNbJlRc7UxwbB2MWwBn4WbByd2f/vUJAkBeM0LmCHQXhJOX/fHBHOkFmk6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=URFJTtTX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="URFJTtTX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABA981F000E9;
	Mon, 20 Jul 2026 19:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784576923;
	bh=UR9se6ThWTXKjg4GillmuDNqsIdyhAGwcGWh6xva6Cc=;
	h=Date:To:From:Subject;
	b=URFJTtTXvzgRGSmn5UwTNvQkktLk2shmPpzpN1ZNG29p69xP9ST+mlrR/oFRvcWiJ
	 Em/ujwvv7oPt6+ZhZpQUQSazGGVgcmxXBeixDVa+sUeGMQvnSXLHiJDWAElWc8iKAx
	 n2KM35fUV4aWXvhN2xeAz5Vi1qFJKWlLaW9kxAW8=
Date: Mon, 20 Jul 2026 12:48:43 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-propagate-vma-virtual-page-offset-on-map-remap-split-merge.patch added to mm-new branch
Message-Id: <20260720194843.ABA981F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: propagate VMA virtual page offset on map, remap, split + merge
has been added to the -mm mm-new branch.  Its filename is
     mm-propagate-vma-virtual-page-offset-on-map-remap-split-merge.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-propagate-vma-virtual-page-offset-on-map-remap-split-merge.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm: propagate VMA virtual page offset on map, remap, split + merge
Date: Mon, 20 Jul 2026 15:38:32 +0100

We must correctly update VMA virtual page offset state on all VMA
operations that would result in it changing, with special attention given
to remapping.

We cover most cases by simply updating vma_set_range() to do so (with a
new virtual page offset parameter), but also notably must update the
merging and mapping logic to propagate this parameter correctly.

The remap logic remains the same - we may update the virtual page offset
if the VMA is unfaulted, but now this applies to MAP_PRIVATE file-backed
mappings too, so we update the code to reflect this.

Note that we use __linear_virt_page_index() upon remap as the VMA may be
shared, in order that we update the field consistently regardless of VMA
type.

Also while we're here, replace a VM_BUG_ON_VMA() with a
VM_WARN_ON_ONCE_VMA().

We also introduce vma_anon_pgoff_addr(), vma_start_anon_pgoff(), and
vma_end_anon_pgoff() which differ from their virtual page offset
equivalents in that a shared file-backed mapping returns its file page
offset otherwise the virtual page offset is used.

This means we don't predicate merges for shared file-backed mappings on
virtual page offset.

We simply ensure state is correctly propagated here, so no functional
changes are intended.

Finally, we update insert_vm_struct() to correctly set the virtual page
offset on insertion of a VMA.

Also update VMA userland tests to reflect this change.

Link: https://lore.kernel.org/20260720-b4-scalable-cow-virt-pgoff-v2-6-2d549757a76f@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Gregory Price <gourry@gourry.net>
Cc: Harry Yoo <harry@kernel.org>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c                      |    6 -
 mm/vma.c                         |   56 +++++++++---
 mm/vma.h                         |  127 ++++++++++++++++++++++-------
 mm/vma_exec.c                    |    2 
 tools/testing/vma/shared.c       |    3 
 tools/testing/vma/tests/merge.c  |    4 
 tools/testing/vma/tests/vma.c    |    4 
 tools/testing/vma/vma_internal.h |    1 
 8 files changed, 152 insertions(+), 51 deletions(-)

--- a/mm/mremap.c~mm-propagate-vma-virtual-page-offset-on-map-remap-split-merge
+++ a/mm/mremap.c
@@ -1265,7 +1265,9 @@ static void unmap_source_vma(struct vma_
 static int copy_vma_and_data(struct vma_remap_struct *vrm,
 			     struct vm_area_struct **new_vma_ptr)
 {
-	const unsigned long new_pgoff = linear_page_index(vrm->vma, vrm->addr);
+	const pgoff_t new_pgoff = linear_page_index(vrm->vma, vrm->addr);
+	const pgoff_t new_virt_pgoff =
+		__linear_virt_page_index(vrm->vma, vrm->addr);
 	struct vm_area_struct *vma = vrm->vma;
 	struct vm_area_struct *new_vma;
 	unsigned long moved_len;
@@ -1273,7 +1275,7 @@ static int copy_vma_and_data(struct vma_
 	PAGETABLE_MOVE(pmc, NULL, NULL, vrm->addr, vrm->new_addr, vrm->old_len);
 
 	new_vma = copy_vma(&vma, vrm->new_addr, vrm->new_len, new_pgoff,
-			   &pmc.need_rmap_locks);
+			   new_virt_pgoff, &pmc.need_rmap_locks);
 	if (!new_vma) {
 		vrm_uncharge(vrm);
 		*new_vma_ptr = NULL;
--- a/mm/vma.c~mm-propagate-vma-virtual-page-offset-on-map-remap-split-merge
+++ a/mm/vma.c
@@ -18,6 +18,7 @@ struct mmap_state {
 	unsigned long addr;
 	unsigned long end;
 	pgoff_t pgoff;
+	pgoff_t virt_pgoff;
 	unsigned long pglen;
 	union {
 		vm_flags_t vm_flags;
@@ -46,13 +47,22 @@ struct mmap_state {
 	bool file_doesnt_need_get :1;
 };
 
-#define MMAP_STATE(name, mm_, vmi_, addr_, len_, pgoff_, vma_flags_, file_) \
+static inline pgoff_t map_anon_pgoff(const struct mmap_state *map)
+{
+	if (vma_flags_test(&map->vma_flags, VMA_SHARED_BIT))
+		return map->pgoff;
+
+	return map->virt_pgoff;
+}
+
+#define MMAP_STATE(name, mm_, vmi_, addr_, len_, pgoff_, virt_pgoff_, vma_flags_, file_) \
 	struct mmap_state name = {					\
 		.mm = mm_,						\
 		.vmi = vmi_,						\
 		.addr = addr_,						\
 		.end = (addr_) + (len_),				\
 		.pgoff = pgoff_,					\
+		.virt_pgoff = virt_pgoff_,				\
 		.pglen = PHYS_PFN(len_),				\
 		.vma_flags = vma_flags_,				\
 		.file = file_,						\
@@ -67,6 +77,7 @@ struct mmap_state {
 		.end = (map_)->end,					\
 		.vma_flags = (map_)->vma_flags,				\
 		.pgoff = (map_)->pgoff,					\
+		.anon_pgoff = map_anon_pgoff(map_),			\
 		.file = (map_)->file,					\
 		.prev = (map_)->prev,					\
 		.middle = vma_,						\
@@ -82,10 +93,11 @@ static void __vma_set_range(struct vm_ar
 }
 
 static void vma_set_range(struct vm_area_struct *vma, unsigned long start,
-			  unsigned long end, pgoff_t pgoff)
+			  unsigned long end, pgoff_t pgoff, pgoff_t virt_pgoff)
 {
 	__vma_set_range(vma, start, end);
 	vma_set_pgoff(vma, pgoff);
+	vma_set_virt_pgoff(vma, virt_pgoff);
 }
 
 /* Was this VMA ever forked from a parent, i.e. maybe contains CoW mappings? */
@@ -812,7 +824,8 @@ static int commit_merge(struct vma_merge
 	 */
 	vma_adjust_trans_huge(vma, vmg->start, vmg->end,
 			      vmg->__adjust_middle_start ? vmg->middle : NULL);
-	vma_set_range(vma, vmg->start, vmg->end, vmg_start_pgoff(vmg));
+	vma_set_range(vma, vmg->start, vmg->end, vmg_start_pgoff(vmg),
+		      vmg_start_anon_pgoff(vmg));
 	vmg_adjust_set_range(vmg);
 	vma_iter_store_overwrite(vmg->vmi, vmg->target);
 
@@ -982,6 +995,7 @@ static __must_check struct vm_area_struc
 		vmg->start = prev->vm_start;
 		vmg->end = next->vm_end;
 		vmg->pgoff = vma_start_pgoff(prev);
+		vmg->anon_pgoff = vma_start_anon_pgoff(prev);
 
 		/*
 		 * We already ensured anon_vma compatibility above, so now it's
@@ -1000,6 +1014,7 @@ static __must_check struct vm_area_struc
 		 */
 		vmg->start = prev->vm_start;
 		vmg->pgoff = vma_start_pgoff(prev);
+		vmg->anon_pgoff = vma_start_anon_pgoff(prev);
 
 		if (!vmg->__remove_middle)
 			vmg->__adjust_middle_start = true;
@@ -1022,12 +1037,14 @@ static __must_check struct vm_area_struc
 		if (vmg->__remove_middle) {
 			vmg->end = next->vm_end;
 			vmg->pgoff = vma_start_pgoff(next) - pglen;
+			vmg->anon_pgoff = vma_start_anon_pgoff(next) - pglen;
 		} else {
 			/* We shrink middle and expand next. */
 			vmg->__adjust_next_start = true;
 			vmg->start = middle->vm_start;
 			vmg->end = start;
 			vmg->pgoff = vma_start_pgoff(middle);
+			vmg->anon_pgoff = vma_start_anon_pgoff(middle);
 		}
 
 		err = dup_anon_vma(next, middle, &anon_dup);
@@ -1137,6 +1154,7 @@ struct vm_area_struct *vma_merge_new_ran
 		vmg->start = prev->vm_start;
 		vmg->target = prev;
 		vmg->pgoff = vma_start_pgoff(prev);
+		vmg->anon_pgoff = vma_start_anon_pgoff(prev);
 
 		/*
 		 * If this merge would result in removal of the next VMA but we
@@ -1908,9 +1926,10 @@ static int vma_link(struct mm_struct *mm
  */
 struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
 	unsigned long addr, unsigned long len, pgoff_t pgoff,
-	bool *need_rmap_locks)
+	pgoff_t virt_pgoff, bool *need_rmap_locks)
 {
 	struct vm_area_struct *vma = *vmap;
+	const bool is_shared = vma_test(vma, VMA_SHARED_BIT);
 	unsigned long vma_start = vma->vm_start;
 	struct mm_struct *mm = vma->vm_mm;
 	struct vm_area_struct *new_vma;
@@ -1919,11 +1938,14 @@ struct vm_area_struct *copy_vma(struct v
 	VMG_VMA_STATE(vmg, &vmi, NULL, vma, addr, addr + len);
 
 	/*
-	 * If anonymous vma has not yet been faulted, update new pgoff
-	 * to match new location, to increase its chance of merging.
+	 * If a vma has not yet been faulted, update its virtual pgoff to match
+	 * the new location to increase its chance of merging.
 	 */
-	if (unlikely(vma_is_anonymous(vma) && !vma->anon_vma)) {
-		pgoff = addr >> PAGE_SHIFT;
+	if (!vma->anon_vma && !is_shared) {
+		virt_pgoff = addr >> PAGE_SHIFT;
+
+		if (vma_is_anonymous(vma))
+			pgoff = virt_pgoff;
 		faulted_in_anon_vma = false;
 	}
 
@@ -1940,6 +1962,7 @@ struct vm_area_struct *copy_vma(struct v
 		return NULL;	/* should never get here */
 
 	vmg.pgoff = pgoff;
+	vmg.anon_pgoff = is_shared ? pgoff : virt_pgoff;
 	vmg.next = vma_iter_next_rewind(&vmi, NULL);
 	new_vma = vma_merge_copied_range(&vmg);
 
@@ -1961,7 +1984,7 @@ struct vm_area_struct *copy_vma(struct v
 			 * safe. It is only safe to keep the vm_pgoff
 			 * linear if there are no pages mapped yet.
 			 */
-			VM_BUG_ON_VMA(faulted_in_anon_vma, new_vma);
+			VM_WARN_ON_ONCE_VMA(faulted_in_anon_vma, new_vma);
 			*vmap = vma = new_vma;
 		}
 		*need_rmap_locks =
@@ -1970,7 +1993,7 @@ struct vm_area_struct *copy_vma(struct v
 		new_vma = vm_area_dup(vma);
 		if (!new_vma)
 			goto out;
-		vma_set_range(new_vma, addr, addr + len, pgoff);
+		vma_set_range(new_vma, addr, addr + len, pgoff, virt_pgoff);
 		if (vma_dup_policy(vma, new_vma))
 			goto out_free_vma;
 		if (anon_vma_clone(new_vma, vma, VMA_OP_REMAP))
@@ -2612,7 +2635,7 @@ static int __mmap_new_vma(struct mmap_st
 	if (is_anon)
 		vma_set_anonymous(vma);
 
-	vma_set_range(vma, map->addr, map->end, map->pgoff);
+	vma_set_range(vma, map->addr, map->end, map->pgoff, map->virt_pgoff);
 	vma->flags = map->vma_flags;
 	vma->vm_page_prot = map->page_prot;
 
@@ -2801,7 +2824,8 @@ static unsigned long __mmap_region(struc
 	struct vm_area_struct *vma = NULL;
 	bool have_mmap_prepare = file && file->f_op->mmap_prepare;
 	VMA_ITERATOR(vmi, mm, addr);
-	MMAP_STATE(map, mm, &vmi, addr, len, pgoff, vma_flags, file);
+	const pgoff_t virt_pgoff = addr >> PAGE_SHIFT;
+	MMAP_STATE(map, mm, &vmi, addr, len, pgoff, virt_pgoff, vma_flags, file);
 	struct vm_area_desc desc = {
 		.mm = mm,
 		.file = file,
@@ -2946,6 +2970,7 @@ int do_brk_flags(struct vma_iterator *vm
 		 unsigned long addr, unsigned long len, vma_flags_t vma_flags)
 {
 	struct mm_struct *mm = current->mm;
+	const pgoff_t pgoff = addr >> PAGE_SHIFT;
 
 	/*
 	 * Check against address space limits by the changed size
@@ -2970,7 +2995,7 @@ int do_brk_flags(struct vma_iterator *vm
 	 * occur after forking, so the expand will only happen on new VMAs.
 	 */
 	if (vma && vma->vm_end == addr) {
-		VMG_STATE(vmg, mm, vmi, addr, addr + len, vma_flags, PHYS_PFN(addr));
+		VMG_STATE(vmg, mm, vmi, addr, addr + len, vma_flags, pgoff, pgoff);
 
 		vmg.prev = vma;
 		/* vmi is positioned at prev, which this mode expects. */
@@ -2990,7 +3015,7 @@ int do_brk_flags(struct vma_iterator *vm
 		goto unacct_fail;
 
 	vma_set_anonymous(vma);
-	vma_set_range(vma, addr, addr + len, addr >> PAGE_SHIFT);
+	vma_set_range(vma, addr, addr + len, pgoff, pgoff);
 	vma->flags = vma_flags;
 	vma->vm_page_prot = vm_get_page_prot(vma_flags_to_legacy(vma_flags));
 	vma_start_write(vma);
@@ -3382,6 +3407,7 @@ int insert_vm_struct(struct mm_struct *m
 		WARN_ON_ONCE(vma->anon_vma);
 		vma_set_pgoff(vma, vma->vm_start >> PAGE_SHIFT);
 	}
+	vma_set_virt_pgoff(vma, vma->vm_start >> PAGE_SHIFT);
 
 	if (vma_link(mm, vma)) {
 		if (vma_test(vma, VMA_ACCOUNT_BIT))
@@ -3437,7 +3463,7 @@ struct vm_area_struct *__install_special
 
 	vma->vm_ops = ops;
 	vma->vm_private_data = priv;
-	vma_set_range(vma, addr, addr + len, 0);
+	vma_set_range(vma, addr, addr + len, 0, addr >> PAGE_SHIFT);
 
 	ret = insert_vm_struct(mm, vma);
 	if (ret)
--- a/mm/vma_exec.c~mm-propagate-vma-virtual-page-offset-on-map-remap-split-merge
+++ a/mm/vma_exec.c
@@ -41,7 +41,7 @@ int relocate_vma_down(struct vm_area_str
 	unsigned long new_end = old_end - shift;
 	VMA_ITERATOR(vmi, mm, new_start);
 	VMG_STATE(vmg, mm, &vmi, new_start, old_end, EMPTY_VMA_FLAGS,
-		  vma_start_pgoff(vma));
+		  vma_start_pgoff(vma), vma_start_anon_pgoff(vma));
 	struct vm_area_struct *next;
 	struct mmu_gather tlb;
 	PAGETABLE_MOVE(pmc, vma, vma, old_start, new_start, length);
--- a/mm/vma.h~mm-propagate-vma-virtual-page-offset-on-map-remap-split-merge
+++ a/mm/vma.h
@@ -104,6 +104,7 @@ struct vma_merge_struct {
 	unsigned long start;
 	unsigned long end;
 	pgoff_t pgoff;
+	pgoff_t anon_pgoff;
 
 	union {
 		/* Temporary while VMA flags are being converted. */
@@ -237,11 +238,6 @@ static inline bool vmg_nomem(struct vma_
 	return vmg->state == VMA_MERGE_ERROR_NOMEM;
 }
 
-static inline pgoff_t vmg_start_pgoff(const struct vma_merge_struct *vmg)
-{
-	return vmg->pgoff;
-}
-
 static inline pgoff_t vmg_pages(const struct vma_merge_struct *vmg)
 {
 	const unsigned long size = vmg->end - vmg->start;
@@ -249,6 +245,11 @@ static inline pgoff_t vmg_pages(const st
 	return size >> PAGE_SHIFT;
 }
 
+static inline pgoff_t vmg_start_pgoff(const struct vma_merge_struct *vmg)
+{
+	return vmg->pgoff;
+}
+
 static inline pgoff_t vmg_end_pgoff(const struct vma_merge_struct *vmg)
 {
 	return vmg_start_pgoff(vmg) + vmg_pages(vmg);
@@ -283,6 +284,16 @@ static inline void vma_set_pgoff(struct
 	vma->vm_pgoff = pgoff;
 }
 
+static inline pgoff_t vmg_start_anon_pgoff(const struct vma_merge_struct *vmg)
+{
+	return vmg->anon_pgoff;
+}
+
+static inline pgoff_t vmg_end_anon_pgoff(const struct vma_merge_struct *vmg)
+{
+	return vmg_start_anon_pgoff(vmg) + vmg_pages(vmg);
+}
+
 static inline void __vma_set_virt_pgoff(struct vm_area_struct *vma, pgoff_t pgoff)
 {
 #ifdef CONFIG_64BIT
@@ -301,44 +312,102 @@ static inline void vma_add_pgoff(struct
 {
 	vma_assert_can_modify(vma);
 	vma_set_pgoff(vma, vma_start_pgoff(vma) + delta);
+	vma_set_virt_pgoff(vma, vma_start_virt_pgoff(vma) + delta);
 }
 
 static inline void vma_sub_pgoff(struct vm_area_struct *vma, pgoff_t delta)
 {
 	vma_assert_can_modify(vma);
 	vma_set_pgoff(vma, vma_start_pgoff(vma) - delta);
+	vma_set_virt_pgoff(vma, vma_start_virt_pgoff(vma) - delta);
+}
+
+/**
+ * vma_anon_pgoff_addr() - Calculates the absolute anonymous page offset of
+ * @address.
+ * @vma: The VMA whose anonymous page offset is required.
+ * @address: The address whose absolute page offset is required.
+ *
+ * If the VMA is a shared file-backed mapping, then the file-based page offset
+ * is returned.
+ *
+ * Otherwise, the virtual page offset is returned.
+ *
+ * This means that shared file-backed mappings are correctly merged based on
+ * their file page offset compatibility.
+ *
+ * Returns: The absolute anonymous page offset of @address within @vma.
+ */
+static inline pgoff_t vma_anon_pgoff_addr(const struct vm_area_struct *vma,
+					  unsigned long address)
+{
+	if (vma_test(vma, VMA_SHARED_BIT))
+		return linear_page_index(vma, address);
+
+	return linear_virt_page_index(vma, address);
+}
+
+/**
+ * vma_start_anon_pgoff() - Calculates the absolute anonymous page offset used
+ * for purposes of merge compatibility.
+ * @vma: The VMA whose anonymous page offset is required.
+ *
+ * See vma_anon_pgoff_addr().
+ *
+ * Returns: The absolute anonymous page offset of @vma for purposes of merging.
+ */
+static inline pgoff_t vma_start_anon_pgoff(const struct vm_area_struct *vma)
+{
+	return vma_anon_pgoff_addr(vma, vma->vm_start);
 }
 
-#define VMG_STATE(name, mm_, vmi_, start_, end_, vma_flags_, pgoff_)	\
+/**
+ * vma_end_anon_pgoff() - Calculates the absolute exclusive end anonymous page
+ * offset used for purposes of merge compatibility.
+ * @vma: The VMA whose anonymous end page offset is required.
+ *
+ * See vma_start_anon_pgoff().
+ *
+ * Returns: The absolute exclusive end anonymous page offset of @vma for
+ * purposes of merging.
+ */
+static inline pgoff_t vma_end_anon_pgoff(const struct vm_area_struct *vma)
+{
+	return vma_start_anon_pgoff(vma) + vma_pages(vma);
+}
+
+#define VMG_STATE(name, mm_, vmi_, start_, end_, vma_flags_, pgoff_, anon_pgoff_) \
+	struct vma_merge_struct name = {					  \
+		.mm = mm_,							  \
+		.vmi = vmi_,							  \
+		.start = start_,						  \
+		.end = end_,							  \
+		.vma_flags = vma_flags_,					  \
+		.pgoff = pgoff_,						  \
+		.anon_pgoff = anon_pgoff_,					  \
+		.state = VMA_MERGE_START,					  \
+	}
+
+#define VMG_VMA_STATE(name, vmi_, prev_, vma_, start_, end_)		\
 	struct vma_merge_struct name = {				\
-		.mm = mm_,						\
+		.mm = vma_->vm_mm,					\
 		.vmi = vmi_,						\
+		.prev = prev_,						\
+		.middle = vma_,						\
+		.next = NULL,						\
 		.start = start_,					\
 		.end = end_,						\
-		.vma_flags = vma_flags_,				\
-		.pgoff = pgoff_,					\
+		.vm_flags = vma_->vm_flags,				\
+		.pgoff = linear_page_index(vma_, start_),		\
+		.anon_pgoff = vma_anon_pgoff_addr(vma_, start_),	\
+		.file = vma_->vm_file,					\
+		.anon_vma = vma_->anon_vma,				\
+		.policy = vma_policy(vma_),				\
+		.uffd_ctx = vma_->vm_userfaultfd_ctx,			\
+		.anon_name = anon_vma_name(vma_),			\
 		.state = VMA_MERGE_START,				\
 	}
 
-#define VMG_VMA_STATE(name, vmi_, prev_, vma_, start_, end_)	\
-	struct vma_merge_struct name = {			\
-		.mm = vma_->vm_mm,				\
-		.vmi = vmi_,					\
-		.prev = prev_,					\
-		.middle = vma_,					\
-		.next = NULL,					\
-		.start = start_,				\
-		.end = end_,					\
-		.vm_flags = vma_->vm_flags,			\
-		.pgoff = linear_page_index(vma_, start_),	\
-		.file = vma_->vm_file,				\
-		.anon_vma = vma_->anon_vma,			\
-		.policy = vma_policy(vma_),			\
-		.uffd_ctx = vma_->vm_userfaultfd_ctx,		\
-		.anon_name = anon_vma_name(vma_),		\
-		.state = VMA_MERGE_START,			\
-	}
-
 #ifdef CONFIG_DEBUG_VM_MAPLE_TREE
 void validate_mm(struct mm_struct *mm);
 #else
@@ -520,7 +589,7 @@ void unlink_file_vma_batch_add(struct un
 
 struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
 	unsigned long addr, unsigned long len, pgoff_t pgoff,
-	bool *need_rmap_locks);
+	pgoff_t anon_pgoff, bool *need_rmap_locks);
 
 struct anon_vma *find_mergeable_anon_vma(struct vm_area_struct *vma);
 
--- a/tools/testing/vma/shared.c~mm-propagate-vma-virtual-page-offset-on-map-remap-split-merge
+++ a/tools/testing/vma/shared.c
@@ -23,7 +23,8 @@ struct vm_area_struct *alloc_vma(struct
 
 	vma->vm_start = start;
 	vma->vm_end = end;
-	vma->vm_pgoff = pgoff;
+	vma_set_pgoff(vma, pgoff);
+	vma_set_virt_pgoff(vma, start >> PAGE_SHIFT);
 	vma->flags = vma_flags;
 	vma_assert_detached(vma);
 
--- a/tools/testing/vma/tests/merge.c~mm-propagate-vma-virtual-page-offset-on-map-remap-split-merge
+++ a/tools/testing/vma/tests/merge.c
@@ -45,6 +45,7 @@ void vmg_set_range(struct vma_merge_stru
 	vmg->start = start;
 	vmg->end = end;
 	vmg->pgoff = pgoff;
+	vmg->anon_pgoff = start >> PAGE_SHIFT;
 	vmg->vma_flags = vma_flags;
 
 	vmg->just_expand = false;
@@ -108,6 +109,7 @@ static bool test_simple_merge(void)
 		.end = 0x2000,
 		.vma_flags = vma_flags,
 		.pgoff = 1,
+		.anon_pgoff = 1,
 	};
 
 	ASSERT_FALSE(attach_vma(&mm, vma_left));
@@ -1431,7 +1433,7 @@ static bool test_expand_only_mode(void)
 	struct mm_struct mm = {};
 	VMA_ITERATOR(vmi, &mm, 0);
 	struct vm_area_struct *vma_prev, *vma;
-	VMG_STATE(vmg, &mm, &vmi, 0x5000, 0x9000, vma_flags, 5);
+	VMG_STATE(vmg, &mm, &vmi, 0x5000, 0x9000, vma_flags, 5, 5);
 
 	/*
 	 * Place a VMA prior to the one we're expanding so we assert that we do
--- a/tools/testing/vma/tests/vma.c~mm-propagate-vma-virtual-page-offset-on-map-remap-split-merge
+++ a/tools/testing/vma/tests/vma.c
@@ -38,7 +38,7 @@ static bool test_copy_vma(void)
 	/* Move backwards and do not merge. */
 
 	vma = alloc_and_link_vma(&mm, 0x3000, 0x5000, 3, vma_flags);
-	vma_new = copy_vma(&vma, 0, 0x2000, 0, &need_locks);
+	vma_new = copy_vma(&vma, 0, 0x2000, 0, 3, &need_locks);
 	ASSERT_NE(vma_new, vma);
 	ASSERT_EQ(vma_new->vm_start, 0);
 	ASSERT_EQ(vma_new->vm_end, 0x2000);
@@ -51,7 +51,7 @@ static bool test_copy_vma(void)
 
 	vma = alloc_and_link_vma(&mm, 0, 0x2000, 0, vma_flags);
 	vma_next = alloc_and_link_vma(&mm, 0x6000, 0x8000, 6, vma_flags);
-	vma_new = copy_vma(&vma, 0x4000, 0x2000, 4, &need_locks);
+	vma_new = copy_vma(&vma, 0x4000, 0x2000, 4, 4, &need_locks);
 	vma_assert_attached(vma_new);
 
 	ASSERT_EQ(vma_new, vma_next);
--- a/tools/testing/vma/vma_internal.h~mm-propagate-vma-virtual-page-offset-on-map-remap-split-merge
+++ a/tools/testing/vma/vma_internal.h
@@ -53,6 +53,7 @@ typedef __bitwise unsigned int vm_fault_
 
 #define VM_WARN_ON(_expr) (WARN_ON(_expr))
 #define VM_WARN_ON_ONCE(_expr) (WARN_ON_ONCE(_expr))
+#define VM_WARN_ON_ONCE_VMA(_expr, _vma) (WARN_ON_ONCE(_expr))
 #define VM_WARN_ON_VMG(_expr, _vmg) (WARN_ON(_expr))
 #define VM_BUG_ON(_expr) (BUG_ON(_expr))
 #define VM_BUG_ON_VMA(_expr, _vma) (BUG_ON(_expr))
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-vmalloc-acquire-init_mm-lock-on-huge-vmap-to-avoid-ptdump-uaf.patch
x86-mm-pat-acquire-init_mm-write-lock-on-collapse-to-avoid-uaf.patch
x86-mm-pat-acquire-init_mm-read-lock-on-attribute-change-to-avoid-uaf.patch
mm-ptdump-always-stabilise-against-page-table-freeing-using-init_mm.patch
arm64-remove-redundant-concurrent-ptdump-uaf-mitigation.patch
mm-move-alloc-tag-to-mm.patch
mm-move-vma_start_pgoff-into-mmh-and-clean-up.patch
mm-add-kdoc-comments-for-vma_start-last_pgoff.patch
tools-testing-vma-use-vma_start_pgoff-in-merge-tests.patch
mm-introduce-and-use-vma_end_pgoff.patch
mm-rmap-update-mm-interval_treec-comments.patch
mm-rmap-parameterise-vma_interval_tree_-by-address_space.patch
mm-rmap-elide-unnecessary-static-inlines-in-interval_treec.patch
mm-rmap-rename-vma_interval_tree_-to-mapping_rmap_tree_.patch
mm-rmap-parameterise-anon_vma_interval_tree_-by-anon_vma.patch
mm-rmap-rename-anon_vma_interval_tree_-params-and-use-pgoff_t.patch
mm-rmap-rename-anon_vma_interval_tree_-to-anon_rmap_tree_.patch
maintainers-move-mm-interval_treec-to-rmap-section.patch
mm-vma-introduce-and-use-vmg_pages-vmg__pgoff.patch
mm-vma-clean-up-anon_vma_compatible.patch
mm-vma-refactor-vmg_adjust_set_range-for-clarity.patch
mm-vma-minor-cleanup-of-expand_.patch
mm-introduce-and-use-linear_page_delta.patch
mm-vma-use-vma_start_pgoff-linear_page_index-in-mm-code.patch
mm-prefer-vma__pgoff-to-vma-vm_pgoff-in-kernel.patch
mm-vma-remove-duplicative-vma_pgoff_offset-helper.patch
mm-use-linear_page_-consistently.patch
mm-vma-introduce-vma_assert_can_modify.patch
mm-vma-add-and-use-vma__pgoff.patch
mm-vma-move-__install_special_mapping-to-vmac.patch
mm-vma-make-vma_set_range-static-drop-insert_vm_struct-decl.patch
mm-vma-update-vma_shrink-to-not-pass-start-pgoff-parameters.patch
mm-vma-update-vmg_adjust_set_range-to-offset-pgoff-instead.patch
mm-vma-slightly-rework-the-anonymous-check-in-__mmap_new_vma.patch
mm-vma-introduce-and-use-vma_set_pgoff.patch
mm-vma-correct-incorrect-vmah-inclusion.patch
mm-vma-use-guard-clauses-in-can_vma_merge_.patch
tools-testing-vma-default-vma-mm-flag-bits-to-64-bit.patch
tools-testing-vma-output-compared-expression-on-assert_.patch
mm-introduce-vma_flags_can_grow-and-vma_can_grow.patch
mm-vma-update-do_mmap-to-use-vma_flags_t.patch
mm-convert-__get_unmapped_area-to-use-vma_flags_t.patch
mm-update-generic_get_unmapped_area-to-use-vma_flags_t.patch
mm-prefer-mm-def_vma_flags-in-mm-logic.patch
mm-vma-convert-vm_pgprot_modify-to-use-vma_flags_t-and-rename.patch
mm-vma-rename-vma_get_page_prot-to-vma_flags_to_page_prot.patch
mm-introduce-vma_get_page_prot-and-use-it.patch
mm-vma-update-create_init_stack_vma-to-use-vma_flags_t.patch
mm-vma-convert-miscellaneous-uses-of-vma-flags-in-core-mm.patch
mm-mlock-convert-mlock-code-to-use-vma_flags_t.patch
mm-mprotect-convert-mprotect-code-to-use-vma_flags_t.patch
mm-mremap-convert-mremap-code-to-use-vma_flags_t.patch
mm-mseal-remove-superfluous-comments-fix-confusion-around-mm.patch
mm-mseal-limit-scope-of-mseal-address-zero-to-address-zero.patch
mm-mseal-remove-further-superfluous-comments-do_mseal.patch
mm-vma-introduce-vma-virtual-page-offset-field-and-add-helpers.patch
mm-introduce-linear_virt_page_index.patch
mm-abstract-vma_address-and-introduce-vma_anon_address.patch
mm-update-print_bad_page_map-to-show-virtual-page-index.patch
mm-introduce-and-use-vma_filebacked_address.patch
mm-propagate-vma-virtual-page-offset-on-map-remap-split-merge.patch
mm-rmap-track-whether-the-page-vma-mapped-walk-is-anonymous.patch
mm-introduce-and-use-linear_folio_page_index.patch
mm-rmap-use-virt-pgoff-for-map_private-file-backed-anon-folios.patch
tools-testing-vma-expand-vma-merge-tests-to-assert-virt-pgoff.patch
tools-testing-selftests-mm-test-virtual-page-offset-merge-behaviour.patch
mm-vma-only-permit-map_private-dev-zero-to-be-mapped-anonymous.patch
mm-vma-make-map_private-mapped-dev-zero-mappings-truly-anonymous.patch
tools-testing-vma-add-test-to-assert-map_private-dev-zero-is-anon.patch
tools-testing-selftests-mm-add-map_private-dev-zero-merge-tests.patch

