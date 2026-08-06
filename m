Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C082427F99
	for <mm-commits@vger.kernel.org>; Thu,  6 Aug 2026 23:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786058886; cv=none; b=qW7XhoorXugz+5Dg8rUXBHPUbrdRM+iIYycm/DberGAu0KfRNl+XVUtE4VENTmnhVP2FRSmwgJgnifbOka7Ozc1Ku7Es3/wuJpixz6AOoqaA7Klqz9OuMSHGa2GYPDbQQPxZ70/kqFXpwlj/fRmzP/jixsJRUe0dotxp+zZi0Ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786058886; c=relaxed/simple;
	bh=t/WGJjKXV1AGUunY64UawWX+0s2SxZjDgoRYUgTwxt0=;
	h=Date:To:From:Subject:Message-Id; b=LLBjD8nZdP4iaGCWADaJ1ha2qqH9Yw4ETfoM+Lwroc6iKJpv43OEkfSAo5N2E0BBszIOReTw/0vBQckIov5etdW0+10NgsI0AWaCvBJO2fbT2ZDM6SSO/rq8lKO0Op9cQjkv/Jeexafn/WFQuagUYWZ/FXd8qDQMS4XyHk7aaGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jmNroNpZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jmNroNpZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B81A1F000E9;
	Thu,  6 Aug 2026 23:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786058883;
	bh=y18u6VL7prgAr8IZUoJWaBtWZdhxMlbXuhJ4kEXx9xQ=;
	h=Date:To:From:Subject;
	b=jmNroNpZLBeWApvkdbmZzuwLRJhHPl9bs6OnEeF/5UZj1lnM7SX4DzTih/3hkyB1v
	 ebB122/w0LrAMb/QE7ust6fBAUlwWLLtCKxaXACrj1EQfZy8eqa2V2UoTgTtPEKpwT
	 lVUHX5smIaTJ5i0fikhoGegQEJkggnQhK9hmV/3Y=
Date: Thu, 06 Aug 2026 16:28:03 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping.patch added to mm-unstable branch
Message-Id: <20260806232803.8B81A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: provide vma_[flags_]is_cow_mapping() and remove is_cow_mapping()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Subject: mm: provide vma_[flags_]is_cow_mapping() and remove is_cow_mapping()
Date: Thu, 06 Aug 2026 21:21:27 +0100

All remaining callers of is_cow_mapping() are invoking it in the form of
is_cow_mapping(vma->vm_flags) or an indirected version of this.

Therefore, provide a helper - vma_is_cow_mapping() to directly test the
VMA.

Additionally provide a new helper vma_flags_is_cow_mapping() which
performs the check using the new vma_flags_t type, and share this logic
between vma_is_cow_mapping() and vma_desc_is_cow_mapping().

With these changes, no callers of is_cow_mapping() remain, so remove it.

Also update the userland VMA tests to reflect the change.

No functional change intended.

Link: https://lore.kernel.org/20260806-b4-scalable-cow-virt-pgoff-v4-2-ab318a350404@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Deucher <alexander.deucher@amd.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Boris Brezillon <boris.brezillon@collabora.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: Christan König <christian.koenig@amd.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Dave Airlie <airlied@gmail.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Gregory Price (Meta) <gourry@gourry.net>
Cc: Harry Yoo <harry@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Huang Ray <Ray.Huang@amd.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Liviu Dudau <liviu.dudau@arm.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Namhyung kim <namhyung@kernel.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Steven Price <steven.price@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: <syzbot@syzkaller.appspotmail.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Thomas Zimemrmann <tzimmermann@suse.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Xu Xin <xu.xin16@zte.com.cn>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/mm/gmap_helpers.c             |    2 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c |    4 +--
 drivers/gpu/drm/drm_gem_shmem_helper.c  |    2 -
 drivers/gpu/drm/panthor/panthor_gem.c   |    2 -
 drivers/gpu/drm/ttm/ttm_bo_vm.c         |    2 -
 drivers/gpu/drm/xe/xe_device.c          |    2 -
 fs/proc/task_mmu.c                      |    2 -
 include/linux/mm.h                      |   15 +++++++------
 kernel/events/uprobes.c                 |    2 -
 mm/gup.c                                |    2 -
 mm/huge_memory.c                        |    8 +++----
 mm/hugetlb.c                            |    2 -
 mm/internal.h                           |    2 -
 mm/memory.c                             |   25 ++++++++++------------
 mm/mempolicy.c                          |    2 -
 tools/testing/vma/include/dup.h         |   11 +++++++++
 16 files changed, 49 insertions(+), 36 deletions(-)

--- a/arch/s390/mm/gmap_helpers.c~mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping
+++ a/arch/s390/mm/gmap_helpers.c
@@ -200,7 +200,7 @@ static int find_zeropage_pte_entry(pte_t
 		 * currently only works in COW mappings, which is also where
 		 * mm_forbids_zeropage() is checked.
 		 */
-		if (!is_cow_mapping(walk->vma->vm_flags))
+		if (!vma_is_cow_mapping(walk->vma))
 			return -EFAULT;
 
 		*found_addr = addr;
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c~mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping
+++ a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
@@ -377,9 +377,9 @@ static int amdgpu_gem_object_mmap(struct
 	/* Workaround for Thunk bug creating PROT_NONE,MAP_PRIVATE mappings
 	 * for debugger access to invisible VRAM. Should have used MAP_SHARED
 	 * instead. Clearing VM_MAYWRITE prevents the mapping from ever
-	 * becoming writable and makes is_cow_mapping(vm_flags) false.
+	 * becoming writable and makes vma_is_cow_mapping(vma) false.
 	 */
-	if (is_cow_mapping(vma->vm_flags) &&
+	if (vma_is_cow_mapping(vma) &&
 	    !(vma->vm_flags & VM_ACCESS_FLAGS))
 		vm_flags_clear(vma, VM_MAYWRITE);
 
--- a/drivers/gpu/drm/drm_gem_shmem_helper.c~mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping
+++ a/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -753,7 +753,7 @@ int drm_gem_shmem_mmap(struct drm_gem_sh
 		return ret;
 	}
 
-	if (is_cow_mapping(vma->vm_flags))
+	if (vma_is_cow_mapping(vma))
 		return -EINVAL;
 
 	dma_resv_lock(shmem->base.resv, NULL);
--- a/drivers/gpu/drm/panthor/panthor_gem.c~mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping
+++ a/drivers/gpu/drm/panthor/panthor_gem.c
@@ -761,7 +761,7 @@ static int panthor_gem_mmap(struct drm_g
 		return ret;
 	}
 
-	if (is_cow_mapping(vma->vm_flags))
+	if (vma_is_cow_mapping(vma))
 		return -EINVAL;
 
 	if (!refcount_inc_not_zero(&bo->cmap.mmap_count)) {
--- a/drivers/gpu/drm/ttm/ttm_bo_vm.c~mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping
+++ a/drivers/gpu/drm/ttm/ttm_bo_vm.c
@@ -489,7 +489,7 @@ static const struct vm_operations_struct
 int ttm_bo_mmap_obj(struct vm_area_struct *vma, struct ttm_buffer_object *bo)
 {
 	/* Enforce no COW since would have really strange behavior with it. */
-	if (is_cow_mapping(vma->vm_flags))
+	if (vma_is_cow_mapping(vma))
 		return -EINVAL;
 
 	drm_gem_object_get(&bo->base);
--- a/drivers/gpu/drm/xe/xe_device.c~mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping
+++ a/drivers/gpu/drm/xe/xe_device.c
@@ -330,7 +330,7 @@ static int xe_pci_barrier_mmap(struct fi
 	if (vma->vm_end - vma->vm_start > SZ_4K)
 		return -EINVAL;
 
-	if (is_cow_mapping(vma->vm_flags))
+	if (vma_is_cow_mapping(vma))
 		return -EINVAL;
 
 	if (vma->vm_flags & (VM_READ | VM_EXEC))
--- a/fs/proc/task_mmu.c~mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping
+++ a/fs/proc/task_mmu.c
@@ -1693,7 +1693,7 @@ static inline bool pte_is_pinned(struct
 
 	if (!pte_write(pte))
 		return false;
-	if (!is_cow_mapping(vma->vm_flags))
+	if (!vma_is_cow_mapping(vma))
 		return false;
 	if (likely(!mm_flags_test(MMF_HAS_PINNED, vma->vm_mm)))
 		return false;
--- a/include/linux/mm.h~mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping
+++ a/include/linux/mm.h
@@ -2271,17 +2271,20 @@ void unpin_user_pages(struct page **page
 void unpin_user_folio(struct folio *folio, unsigned long npages);
 void unpin_folios(struct folio **folios, unsigned long nfolios);
 
-static inline bool is_cow_mapping(vm_flags_t flags)
+static inline bool vma_flags_is_cow_mapping(const vma_flags_t *flags)
 {
-	return (flags & (VM_SHARED | VM_MAYWRITE)) == VM_MAYWRITE;
+	return vma_flags_test(flags, VMA_MAYWRITE_BIT) &&
+		!vma_flags_test(flags, VMA_SHARED_BIT);
 }
 
-static inline bool vma_desc_is_cow_mapping(struct vm_area_desc *desc)
+static inline bool vma_is_cow_mapping(const struct vm_area_struct *vma)
 {
-	const vma_flags_t *flags = &desc->vma_flags;
+	return vma_flags_is_cow_mapping(&vma->flags);
+}
 
-	return vma_flags_test(flags, VMA_MAYWRITE_BIT) &&
-		!vma_flags_test(flags, VMA_SHARED_BIT);
+static inline bool vma_desc_is_cow_mapping(struct vm_area_desc *desc)
+{
+	return vma_flags_is_cow_mapping(&desc->vma_flags);
 }
 
 #ifndef CONFIG_MMU
--- a/kernel/events/uprobes.c~mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping
+++ a/kernel/events/uprobes.c
@@ -513,7 +513,7 @@ int uprobe_write(struct arch_uprobe *aup
 
 	uprobe = container_of(auprobe, struct uprobe, arch);
 
-	if (WARN_ON_ONCE(!is_cow_mapping(vma->vm_flags)))
+	if (WARN_ON_ONCE(!vma_is_cow_mapping(vma)))
 		return -EINVAL;
 
 	/*
--- a/mm/gup.c~mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping
+++ a/mm/gup.c
@@ -1236,7 +1236,7 @@ static int check_vma_flags(struct vm_are
 			 * Anon pages in shared mappings are surprising: now
 			 * just reject it.
 			 */
-			if (!is_cow_mapping(vm_flags))
+			if (!vma_is_cow_mapping(vma))
 				return -EFAULT;
 		}
 	} else if (!(vm_flags & VM_READ)) {
--- a/mm/huge_memory.c~mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping
+++ a/mm/huge_memory.c
@@ -1681,7 +1681,7 @@ vm_fault_t vmf_insert_pfn_pmd(struct vm_
 	BUG_ON(!(vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP)));
 	BUG_ON((vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP)) ==
 						(VM_PFNMAP|VM_MIXEDMAP));
-	BUG_ON((vma->vm_flags & VM_PFNMAP) && is_cow_mapping(vma->vm_flags));
+	BUG_ON((vma->vm_flags & VM_PFNMAP) && vma_is_cow_mapping(vma));
 
 	pfnmap_setup_cachemode_pfn(pfn, &pgprot);
 
@@ -1789,7 +1789,7 @@ vm_fault_t vmf_insert_pfn_pud(struct vm_
 	BUG_ON(!(vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP)));
 	BUG_ON((vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP)) ==
 						(VM_PFNMAP|VM_MIXEDMAP));
-	BUG_ON((vma->vm_flags & VM_PFNMAP) && is_cow_mapping(vma->vm_flags));
+	BUG_ON((vma->vm_flags & VM_PFNMAP) && vma_is_cow_mapping(vma));
 
 	pfnmap_setup_cachemode_pfn(pfn, &pgprot);
 
@@ -1931,7 +1931,7 @@ int copy_huge_pmd(struct mm_struct *dst_
 		 * applied special bit, or we made the PRIVATE mapping be
 		 * able to wrongly write to the backend MMIO.
 		 */
-		VM_WARN_ON_ONCE(is_cow_mapping(src_vma->vm_flags) && pmd_write(pmd));
+		VM_WARN_ON_ONCE(vma_is_cow_mapping(src_vma) && pmd_write(pmd));
 		goto set_pmd;
 	}
 
@@ -2052,7 +2052,7 @@ int copy_huge_pud(struct mm_struct *dst_
 	 * TODO: once we support anonymous pages, use
 	 * folio_try_dup_anon_rmap_*() and split if duplicating fails.
 	 */
-	if (is_cow_mapping(vma->vm_flags) && pud_write(pud)) {
+	if (vma_is_cow_mapping(vma) && pud_write(pud)) {
 		pudp_set_wrprotect(src_mm, addr, src_pud);
 		pud = pud_wrprotect(pud);
 	}
--- a/mm/hugetlb.c~mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping
+++ a/mm/hugetlb.c
@@ -4898,7 +4898,7 @@ int copy_hugetlb_page_range(struct mm_st
 	pte_t *src_pte, *dst_pte, entry;
 	struct folio *pte_folio;
 	unsigned long addr;
-	bool cow = is_cow_mapping(src_vma->vm_flags);
+	bool cow = vma_is_cow_mapping(src_vma);
 	struct hstate *h = hstate_vma(src_vma);
 	unsigned long sz = huge_page_size(h);
 	unsigned long npages = pages_per_huge_page(h);
--- a/mm/internal.h~mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping
+++ a/mm/internal.h
@@ -1353,7 +1353,7 @@ static inline bool gup_must_unshare(stru
 		 * ... because we only care about writable private ("COW")
 		 * mappings where we have to break COW early.
 		 */
-		return is_cow_mapping(vma->vm_flags);
+		return vma_is_cow_mapping(vma);
 	}
 
 	/* Paired with a memory barrier in folio_try_share_anon_rmap_*(). */
--- a/mm/memory.c~mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping
+++ a/mm/memory.c
@@ -780,7 +780,7 @@ static inline struct page *__vm_normal_p
 				/* Only CoW'ed anon folios are "normal". */
 				if (pfn == index)
 					return NULL;
-				if (!is_cow_mapping(vma->vm_flags))
+				if (!vma_is_cow_mapping(vma))
 					return NULL;
 			}
 		}
@@ -1002,7 +1002,6 @@ copy_nonpresent_pte(struct mm_struct *ds
 		pte_t *dst_pte, pte_t *src_pte, struct vm_area_struct *dst_vma,
 		struct vm_area_struct *src_vma, unsigned long addr, int *rss)
 {
-	vm_flags_t vm_flags = dst_vma->vm_flags;
 	pte_t orig_pte = ptep_get(src_pte);
 	softleaf_t entry = softleaf_from_pte(orig_pte);
 	pte_t pte = orig_pte;
@@ -1026,7 +1025,7 @@ copy_nonpresent_pte(struct mm_struct *ds
 		rss[mm_counter(folio)]++;
 
 		if (!softleaf_is_migration_read(entry) &&
-				is_cow_mapping(vm_flags)) {
+				vma_is_cow_mapping(dst_vma)) {
 			/*
 			 * COW mappings require pages in both parent and child
 			 * to be set to read. A previously exclusive entry is
@@ -1067,7 +1066,7 @@ copy_nonpresent_pte(struct mm_struct *ds
 		 * save and restore device driver state).
 		 */
 		if (softleaf_is_device_private_write(entry) &&
-		    is_cow_mapping(vm_flags)) {
+		    vma_is_cow_mapping(dst_vma)) {
 			entry = make_readable_device_private_entry(
 							swp_offset(entry));
 			pte = swp_entry_to_pte(entry);
@@ -1082,7 +1081,7 @@ copy_nonpresent_pte(struct mm_struct *ds
 		 * exclusive entries currently only support private writable
 		 * (ie. COW) mappings.
 		 */
-		VM_BUG_ON(!is_cow_mapping(src_vma->vm_flags));
+		VM_BUG_ON(!vma_is_cow_mapping(src_vma));
 		if (try_restore_exclusive_pte(src_vma, addr, src_pte, orig_pte))
 			return -EBUSY;
 		return -ENOENT;
@@ -1181,7 +1180,7 @@ static __always_inline void __copy_prese
 	}
 
 	/* If it's a COW mapping, write protect it both processes. */
-	if (is_cow_mapping(src_vma->vm_flags) && writable) {
+	if (vma_is_cow_mapping(src_vma) && writable) {
 		wrprotect_ptes(src_mm, addr, src_pte, nr);
 		pte = pte_wrprotect(pte);
 	}
@@ -1602,9 +1601,9 @@ copy_page_range(struct vm_area_struct *d
 	 * We need to invalidate the secondary MMU mappings only when
 	 * there could be a permission downgrade on the ptes of the
 	 * parent mm. And a permission downgrade will only happen if
-	 * is_cow_mapping() returns true.
+	 * vma_is_cow_mapping() returns true.
 	 */
-	is_cow = is_cow_mapping(src_vma->vm_flags);
+	is_cow = vma_is_cow_mapping(src_vma);
 
 	if (is_cow) {
 		mmu_notifier_range_init(&range, MMU_NOTIFY_PROTECTION_PAGE,
@@ -2437,7 +2436,7 @@ static bool vm_mixed_zeropage_allowed(st
 	if (mm_forbids_zeropage(vma->vm_mm))
 		return false;
 	/* zeropages in COW mappings are common and unproblematic. */
-	if (is_cow_mapping(vma->vm_flags))
+	if (vma_is_cow_mapping(vma))
 		return true;
 	/* Mappings that do not allow for writable PTEs are unproblematic. */
 	if (!(vma->vm_flags & (VM_WRITE | VM_MAYWRITE)))
@@ -2888,7 +2887,7 @@ vm_fault_t vmf_insert_pfn_prot(struct vm
 	BUG_ON(!(vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP)));
 	BUG_ON((vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP)) ==
 						(VM_PFNMAP|VM_MIXEDMAP));
-	BUG_ON((vma->vm_flags & VM_PFNMAP) && is_cow_mapping(vma->vm_flags));
+	BUG_ON((vma->vm_flags & VM_PFNMAP) && vma_is_cow_mapping(vma));
 	BUG_ON((vma->vm_flags & VM_MIXEDMAP) && pfn_valid(pfn));
 
 	if (addr < vma->vm_start || addr >= vma->vm_end)
@@ -3300,7 +3299,7 @@ static int remap_pfn_range_prepare_vma(s
 				       unsigned long size)
 {
 	const unsigned long end = addr + PAGE_ALIGN(size);
-	const bool is_cow = is_cow_mapping(vma->vm_flags);
+	const bool is_cow = vma_is_cow_mapping(vma);
 	int err;
 
 	err = get_remap_pgoff(is_cow, addr, end, vma->vm_start, vma->vm_end,
@@ -6800,7 +6799,7 @@ static vm_fault_t sanitize_fault_flags(s
 		 * FAULT_FLAG_UNSHARE only applies to COW mappings. Let's
 		 * just treat it like an ordinary read-fault otherwise.
 		 */
-		if (!is_cow_mapping(vma->vm_flags))
+		if (!vma_is_cow_mapping(vma))
 			*flags &= ~FAULT_FLAG_UNSHARE;
 	} else if (*flags & FAULT_FLAG_WRITE) {
 		/* Write faults on read-only mappings are impossible ... */
@@ -6808,7 +6807,7 @@ static vm_fault_t sanitize_fault_flags(s
 			return VM_FAULT_SIGSEGV;
 		/* ... and FOLL_FORCE only applies to COW mappings. */
 		if (WARN_ON_ONCE(!(vma->vm_flags & VM_WRITE) &&
-				 !is_cow_mapping(vma->vm_flags)))
+				 !vma_is_cow_mapping(vma)))
 			return VM_FAULT_SIGSEGV;
 	}
 #ifdef CONFIG_PER_VMA_LOCK
--- a/mm/mempolicy.c~mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping
+++ a/mm/mempolicy.c
@@ -844,7 +844,7 @@ bool folio_can_map_prot_numa(struct foli
 		return false;
 
 	/* Also skip shared copy-on-write folios */
-	if (is_cow_mapping(vma->vm_flags) && folio_maybe_mapped_shared(folio))
+	if (vma_is_cow_mapping(vma) && folio_maybe_mapped_shared(folio))
 		return false;
 
 	/* Folios are pinned and can't be migrated */
--- a/tools/testing/vma/include/dup.h~mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping
+++ a/tools/testing/vma/include/dup.h
@@ -1162,6 +1162,17 @@ static inline bool vma_is_shared_maywrit
 	return is_shared_maywrite(&vma->flags);
 }
 
+static inline bool vma_flags_is_cow_mapping(const vma_flags_t *flags)
+{
+	return vma_flags_test(flags, VMA_MAYWRITE_BIT) &&
+		!vma_flags_test(flags, VMA_SHARED_BIT);
+}
+
+static inline bool vma_is_cow_mapping(const struct vm_area_struct *vma)
+{
+	return vma_flags_is_cow_mapping(&vma->flags);
+}
+
 static inline struct vm_area_struct *vma_next(struct vma_iterator *vmi)
 {
 	/*
_

Patches currently in -mm which might be from ljs@kernel.org are

x86-mm-pat-acquire-init_mm-write-lock-on-collapse-to-avoid-uaf.patch
x86-mm-pat-acquire-init_mm-read-lock-on-attribute-change-to-avoid-uaf.patch
x86-mm-pat-allocate-split-page-tables-as-kernel-page-tables.patch
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
mm-vma-introduce-vma-anon-page-offset-field-and-add-helpers.patch
mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping.patch
mm-introduce-linear_anon_page_index.patch
mm-abstract-vma_address-and-introduce-vma_anon_address.patch
mm-update-print_bad_page_map-to-show-anon-index-if-appropriate.patch
mm-introduce-and-use-vma_filebacked_address.patch
mm-vma-fix-self-merge-check-in-copy_vma.patch
tools-testing-vma-add-tests-for-copy_vma-self-merge.patch
mm-propagate-vma-anonymous-page-offset-on-map-remap-split-merge.patch
mm-rmap-track-whether-the-page-vma-mapped-pgoff-is-anonymous.patch
mm-clean-up-vma_address_end.patch
mm-huge_memory-update-remove_migration_pmd-to-accept-a-folio.patch
mm-migrate-calculate-large-folio-page-index-using-pfn.patch
mm-rmap-use-anon-pgoff-to-track-map_private-file-backed-anon-folios.patch
tools-testing-vma-expand-vma-merge-tests-to-assert-anon-pgoff.patch
tools-testing-selftests-mm-test-anonymous-page-offset-merge-behaviour.patch
mm-vma-only-permit-map_private-dev-zero-to-be-mapped-anonymous.patch
mm-vma-make-map_private-mapped-dev-zero-mappings-truly-anonymous.patch
tools-testing-vma-add-test-to-assert-map_private-dev-zero-is-anon.patch
tools-testing-selftests-mm-add-map_private-dev-zero-merge-tests.patch
mm-add-some-missing-includes-to-mm-local-headers.patch

