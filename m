Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 783F5253F2D
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 23:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747092869; cv=none; b=MTRq6CFJlc+Ug0I4kvRqToipmakfrrx2/cjO12UgBsS6Vr/kpWv3c8jEXlNmqKkW2WRlE2w9PMIH7pTOuFsBtsZRaLeg6Oyd4qxdVMQf0kK7P95SC+hPFdOrvpkr7543QRSopAxZ7disyQSQ0DOFn7ivsQaw2IPRDOZpCEAT7Eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747092869; c=relaxed/simple;
	bh=1d8vOnYYkI1p2tmInh3Q1farPKst6PMCSBAm4IRvFt4=;
	h=Date:To:From:Subject:Message-Id; b=bqqB03HiML5Y2+9+SU52EYJo9m5z/p2veYwrUA6D1XFbq+tRgeCiRmKHiNudZD6vy9cwJix3gKvDmUscsU7buKC82E15x1uPmfRVPjEN0y98dV2DWKQ9tqFcvK4xNe/D4IEEmTnE4m1ekk/XdhuItb4c+hWusxUPoSKfBgi8sy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DTeYaHJC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DTeYaHJC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96932C4CEE7;
	Mon, 12 May 2025 23:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747092868;
	bh=1d8vOnYYkI1p2tmInh3Q1farPKst6PMCSBAm4IRvFt4=;
	h=Date:To:From:Subject:From;
	b=DTeYaHJCudb+vkHK7O3e1dme4I4gMD6fC1usd14igQOAqpz831Z1Qo/yi9OoH2F3w
	 RJj6n8stRs48CvpkJItWvqxzU5IUv/bEkWB3PJKqTHQm75pCVrRMTwhs1C/DcrE9GM
	 mVLlk3ZZwnyBW87RZfH+nA5/lNetrmE5yJmy/DSk=
Date: Mon, 12 May 2025 16:34:28 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,tursulin@ursulin.net,tglx@linutronix.de,rostedt@goodmis.org,rodrigo.vivi@intel.com,peterz@infradead.org,peterx@redhat.com,mingo@kernel.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,luto@kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,joonas.lahtinen@linux.intel.com,jannh@google.com,jani.nikula@linux.intel.com,hpa@zytor.com,bp@alien8.de,airlied@gmail.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-mm-pat-remove-old-pfnmap-tracking-interface.patch added to mm-new branch
Message-Id: <20250512233428.96932C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86/mm/pat: remove old pfnmap tracking interface
has been added to the -mm mm-new branch.  Its filename is
     x86-mm-pat-remove-old-pfnmap-tracking-interface.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-mm-pat-remove-old-pfnmap-tracking-interface.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: x86/mm/pat: remove old pfnmap tracking interface
Date: Mon, 12 May 2025 14:34:18 +0200

We can now get rid of the old interface along with get_pat_info() and
follow_phys().

Link: https://lkml.kernel.org/r/20250512123424.637989-6-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Ingo Molnar <mingo@kernel.org> # x86 bits
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Dave Airlie <airlied@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Tvrtko Ursulin <tursulin@ursulin.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/pat/memtype.c |  147 ------------------------------------
 include/linux/pgtable.h   |   66 ----------------
 2 files changed, 213 deletions(-)

--- a/arch/x86/mm/pat/memtype.c~x86-mm-pat-remove-old-pfnmap-tracking-interface
+++ a/arch/x86/mm/pat/memtype.c
@@ -933,119 +933,6 @@ static void free_pfn_range(u64 paddr, un
 		memtype_free(paddr, paddr + size);
 }
 
-static int follow_phys(struct vm_area_struct *vma, unsigned long *prot,
-		resource_size_t *phys)
-{
-	struct follow_pfnmap_args args = { .vma = vma, .address = vma->vm_start };
-
-	if (follow_pfnmap_start(&args))
-		return -EINVAL;
-
-	/* Never return PFNs of anon folios in COW mappings. */
-	if (!args.special) {
-		follow_pfnmap_end(&args);
-		return -EINVAL;
-	}
-
-	*prot = pgprot_val(args.pgprot);
-	*phys = (resource_size_t)args.pfn << PAGE_SHIFT;
-	follow_pfnmap_end(&args);
-	return 0;
-}
-
-static int get_pat_info(struct vm_area_struct *vma, resource_size_t *paddr,
-		pgprot_t *pgprot)
-{
-	unsigned long prot;
-
-	VM_WARN_ON_ONCE(!(vma->vm_flags & VM_PAT));
-
-	/*
-	 * We need the starting PFN and cachemode used for track_pfn_remap()
-	 * that covered the whole VMA. For most mappings, we can obtain that
-	 * information from the page tables. For COW mappings, we might now
-	 * suddenly have anon folios mapped and follow_phys() will fail.
-	 *
-	 * Fallback to using vma->vm_pgoff, see remap_pfn_range_notrack(), to
-	 * detect the PFN. If we need the cachemode as well, we're out of luck
-	 * for now and have to fail fork().
-	 */
-	if (!follow_phys(vma, &prot, paddr)) {
-		if (pgprot)
-			*pgprot = __pgprot(prot);
-		return 0;
-	}
-	if (is_cow_mapping(vma->vm_flags)) {
-		if (pgprot)
-			return -EINVAL;
-		*paddr = (resource_size_t)vma->vm_pgoff << PAGE_SHIFT;
-		return 0;
-	}
-	WARN_ON_ONCE(1);
-	return -EINVAL;
-}
-
-int track_pfn_copy(struct vm_area_struct *dst_vma,
-		struct vm_area_struct *src_vma, unsigned long *pfn)
-{
-	const unsigned long vma_size = src_vma->vm_end - src_vma->vm_start;
-	resource_size_t paddr;
-	pgprot_t pgprot;
-	int rc;
-
-	if (!(src_vma->vm_flags & VM_PAT))
-		return 0;
-
-	/*
-	 * Duplicate the PAT information for the dst VMA based on the src
-	 * VMA.
-	 */
-	if (get_pat_info(src_vma, &paddr, &pgprot))
-		return -EINVAL;
-	rc = reserve_pfn_range(paddr, vma_size, &pgprot, 1);
-	if (rc)
-		return rc;
-
-	/* Reservation for the destination VMA succeeded. */
-	vm_flags_set(dst_vma, VM_PAT);
-	*pfn = PHYS_PFN(paddr);
-	return 0;
-}
-
-void untrack_pfn_copy(struct vm_area_struct *dst_vma, unsigned long pfn)
-{
-	untrack_pfn(dst_vma, pfn, dst_vma->vm_end - dst_vma->vm_start, true);
-	/*
-	 * Reservation was freed, any copied page tables will get cleaned
-	 * up later, but without getting PAT involved again.
-	 */
-}
-
-/*
- * prot is passed in as a parameter for the new mapping. If the vma has
- * a linear pfn mapping for the entire range, or no vma is provided,
- * reserve the entire pfn + size range with single reserve_pfn_range
- * call.
- */
-int track_pfn_remap(struct vm_area_struct *vma, pgprot_t *prot,
-		    unsigned long pfn, unsigned long addr, unsigned long size)
-{
-	resource_size_t paddr = (resource_size_t)pfn << PAGE_SHIFT;
-
-	/* reserve the whole chunk starting from paddr */
-	if (!vma || (addr == vma->vm_start
-				&& size == (vma->vm_end - vma->vm_start))) {
-		int ret;
-
-		ret = reserve_pfn_range(paddr, size, prot, 0);
-		if (ret == 0 && vma)
-			vm_flags_set(vma, VM_PAT);
-		return ret;
-	}
-
-	return pfnmap_setup_cachemode(pfn, size, prot);
-}
-
 int pfnmap_setup_cachemode(unsigned long pfn, unsigned long size, pgprot_t *prot)
 {
 	resource_size_t paddr = (resource_size_t)pfn << PAGE_SHIFT;
@@ -1082,40 +969,6 @@ void pfnmap_untrack(unsigned long pfn, u
 	free_pfn_range(paddr, size);
 }
 
-/*
- * untrack_pfn is called while unmapping a pfnmap for a region.
- * untrack can be called for a specific region indicated by pfn and size or
- * can be for the entire vma (in which case pfn, size are zero).
- */
-void untrack_pfn(struct vm_area_struct *vma, unsigned long pfn,
-		 unsigned long size, bool mm_wr_locked)
-{
-	resource_size_t paddr;
-
-	if (vma && !(vma->vm_flags & VM_PAT))
-		return;
-
-	/* free the chunk starting from pfn or the whole chunk */
-	paddr = (resource_size_t)pfn << PAGE_SHIFT;
-	if (!paddr && !size) {
-		if (get_pat_info(vma, &paddr, NULL))
-			return;
-		size = vma->vm_end - vma->vm_start;
-	}
-	free_pfn_range(paddr, size);
-	if (vma) {
-		if (mm_wr_locked)
-			vm_flags_clear(vma, VM_PAT);
-		else
-			__vm_flags_mod(vma, 0, VM_PAT);
-	}
-}
-
-void untrack_pfn_clear(struct vm_area_struct *vma)
-{
-	vm_flags_clear(vma, VM_PAT);
-}
-
 pgprot_t pgprot_writecombine(pgprot_t prot)
 {
 	pgprot_set_cachemode(&prot, _PAGE_CACHE_MODE_WC);
--- a/include/linux/pgtable.h~x86-mm-pat-remove-old-pfnmap-tracking-interface
+++ a/include/linux/pgtable.h
@@ -1485,17 +1485,6 @@ static inline pmd_t pmd_swp_clear_soft_d
  * vmf_insert_pfn.
  */
 
-/*
- * track_pfn_remap is called when a _new_ pfn mapping is being established
- * by remap_pfn_range() for physical range indicated by pfn and size.
- */
-static inline int track_pfn_remap(struct vm_area_struct *vma, pgprot_t *prot,
-				  unsigned long pfn, unsigned long addr,
-				  unsigned long size)
-{
-	return 0;
-}
-
 static inline int pfnmap_setup_cachemode(unsigned long pfn, unsigned long size,
 		pgprot_t *prot)
 {
@@ -1511,55 +1500,7 @@ static inline int pfnmap_track(unsigned
 static inline void pfnmap_untrack(unsigned long pfn, unsigned long size)
 {
 }
-
-/*
- * track_pfn_copy is called when a VM_PFNMAP VMA is about to get the page
- * tables copied during copy_page_range(). Will store the pfn to be
- * passed to untrack_pfn_copy() only if there is something to be untracked.
- * Callers should initialize the pfn to 0.
- */
-static inline int track_pfn_copy(struct vm_area_struct *dst_vma,
-		struct vm_area_struct *src_vma, unsigned long *pfn)
-{
-	return 0;
-}
-
-/*
- * untrack_pfn_copy is called when a VM_PFNMAP VMA failed to copy during
- * copy_page_range(), but after track_pfn_copy() was already called. Can
- * be called even if track_pfn_copy() did not actually track anything:
- * handled internally.
- */
-static inline void untrack_pfn_copy(struct vm_area_struct *dst_vma,
-		unsigned long pfn)
-{
-}
-
-/*
- * untrack_pfn is called while unmapping a pfnmap for a region.
- * untrack can be called for a specific region indicated by pfn and size or
- * can be for the entire vma (in which case pfn, size are zero).
- */
-static inline void untrack_pfn(struct vm_area_struct *vma,
-			       unsigned long pfn, unsigned long size,
-			       bool mm_wr_locked)
-{
-}
-
-/*
- * untrack_pfn_clear is called in the following cases on a VM_PFNMAP VMA:
- *
- * 1) During mremap() on the src VMA after the page tables were moved.
- * 2) During fork() on the dst VMA, immediately after duplicating the src VMA.
- */
-static inline void untrack_pfn_clear(struct vm_area_struct *vma)
-{
-}
 #else
-extern int track_pfn_remap(struct vm_area_struct *vma, pgprot_t *prot,
-			   unsigned long pfn, unsigned long addr,
-			   unsigned long size);
-
 /**
  * pfnmap_setup_cachemode - setup the cachemode in the pgprot for a pfn range
  * @pfn: the start of the pfn range
@@ -1614,13 +1555,6 @@ int pfnmap_track(unsigned long pfn, unsi
  * Untrack a pfn range previously tracked through pfnmap_track().
  */
 void pfnmap_untrack(unsigned long pfn, unsigned long size);
-extern int track_pfn_copy(struct vm_area_struct *dst_vma,
-		struct vm_area_struct *src_vma, unsigned long *pfn);
-extern void untrack_pfn_copy(struct vm_area_struct *dst_vma,
-		unsigned long pfn);
-extern void untrack_pfn(struct vm_area_struct *vma, unsigned long pfn,
-			unsigned long size, bool mm_wr_locked);
-extern void untrack_pfn_clear(struct vm_area_struct *vma);
 #endif
 
 /**
_

Patches currently in -mm which might be from david@redhat.com are

selftests-mm-add-simple-vm_pfnmap-tests-based-on-mmaping-dev-mem.patch
x86-mm-pat-factor-out-setting-cachemode-into-pgprot_set_cachemode.patch
mm-convert-track_pfn_insert-to-pfnmap_setup_cachemode.patch
mm-introduce-pfnmap_track-and-pfnmap_untrack-and-use-them-for-memremap.patch
mm-convert-vm_pfnmap-tracking-to-pfnmap_track-pfnmap_untrack.patch
x86-mm-pat-remove-old-pfnmap-tracking-interface.patch
mm-remove-vm_pat.patch
x86-mm-pat-remove-strict_prot-parameter-from-reserve_pfn_range.patch
x86-mm-pat-remove-memtype__match.patch
x86-mm-pat-inline-memtype_match-into-memtype_erase.patch
drm-i915-track_pfn-pfnmap-tracking.patch
mm-io-mapping-track_pfn-pfnmap-tracking.patch

