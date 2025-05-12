Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDFC0253F2D
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 23:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747092865; cv=none; b=qYNCks0jZpYGaBnz58n8xwq0+e5mIv1jU3/p+eyUpSRefi+1WjWQpOLSAL0Xsl5wKPLDG50UZ3sBYSfuOCG5AW/feUxM4xIHJKBScz2prhEjbb2bCTuJxnNT/ZAqthDsP05tiNQmLhynEY44kyTDNM5BCk2CA1daUef6pCAelk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747092865; c=relaxed/simple;
	bh=o7XAiaK8c0bTPJOBzzEtJ6ewTCbBsFwwafJCo0NPtRQ=;
	h=Date:To:From:Subject:Message-Id; b=nml1Nnsr5jJunaaCF+MAIswTgGbOPxrRvC9b4G4Wn46g+9SNTXg708N2KP39fd056Ugdx3C+wqo82nntCAoMMRAfaIJu7LCHqHXqIzxl3L4A0AGor1xBaCfFVq0130c1wVL4HAozO/dOh3DmSZ7QHMpnDeHBjiaaJ5IUmK9FVOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EBCCzIPs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EBCCzIPs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43642C4CEE7;
	Mon, 12 May 2025 23:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747092864;
	bh=o7XAiaK8c0bTPJOBzzEtJ6ewTCbBsFwwafJCo0NPtRQ=;
	h=Date:To:From:Subject:From;
	b=EBCCzIPsJEUQfpNr537RSr1CzFHUJyuEEcdUSU00djIxkVYJ95WwR7xrX37Pd5Sqa
	 p9w+Sj/4J+yK0spDvxYa90rVX68JoH8XUORQTLoIPgEFsMKheouMiAkGWGhKEnW52F
	 VxcQIrH34qwbBn3RhJoXNa1AJfNmxQimFXc9L/Og=
Date: Mon, 12 May 2025 16:34:23 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,tursulin@ursulin.net,tglx@linutronix.de,rostedt@goodmis.org,rodrigo.vivi@intel.com,peterz@infradead.org,peterx@redhat.com,mingo@kernel.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,luto@kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,joonas.lahtinen@linux.intel.com,jannh@google.com,jani.nikula@linux.intel.com,hpa@zytor.com,bp@alien8.de,airlied@gmail.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-convert-vm_pfnmap-tracking-to-pfnmap_track-pfnmap_untrack.patch added to mm-new branch
Message-Id: <20250512233424.43642C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: convert VM_PFNMAP tracking to pfnmap_track() + pfnmap_untrack()
has been added to the -mm mm-new branch.  Its filename is
     mm-convert-vm_pfnmap-tracking-to-pfnmap_track-pfnmap_untrack.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-convert-vm_pfnmap-tracking-to-pfnmap_track-pfnmap_untrack.patch

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
Subject: mm: convert VM_PFNMAP tracking to pfnmap_track() + pfnmap_untrack()
Date: Mon, 12 May 2025 14:34:17 +0200

Let's use our new interface.  In remap_pfn_range(), we'll now decide
whether we have to track (full VMA covered) or only lookup the cachemode
(partial VMA covered).

Remember what we have to untrack by linking it from the VMA.  When
duplicating VMAs (e.g., splitting, mremap, fork), we'll handle it similar
to anon VMA names, and use a kref to share the tracking.

Once the last VMA un-refs our tracking data, we'll do the untracking,
which simplifies things a lot and should sort our various issues we saw
recently, for example, when partially unmapping/zapping a tracked VMA.

This change implies that we'll keep tracking the original PFN range even
after splitting + partially unmapping it: not too bad, because it was not
working reliably before.  The only thing that kind-of worked before was
shrinking such a mapping using mremap(): we managed to adjust the
reservation in a hacky way, now we won't adjust the reservation but leave
it around until all involved VMAs are gone.

If that ever turns out to be an issue, we could hook into VM splitting
code and split the tracking; however, that adds complexity that might not
be required, so we'll keep it simple for now.

Link: https://lkml.kernel.org/r/20250512123424.637989-5-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Ingo Molnar <mingo@kernel.org> # x86 bits
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
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

 include/linux/mm_inline.h |    2 
 include/linux/mm_types.h  |   11 ++++
 mm/memory.c               |   82 ++++++++++++++++++++++++++++--------
 mm/mmap.c                 |    5 --
 mm/mremap.c               |    4 -
 mm/vma_init.c             |   50 +++++++++++++++++++++
 6 files changed, 129 insertions(+), 25 deletions(-)

--- a/include/linux/mm_inline.h~mm-convert-vm_pfnmap-tracking-to-pfnmap_track-pfnmap_untrack
+++ a/include/linux/mm_inline.h
@@ -447,6 +447,8 @@ static inline bool anon_vma_name_eq(stru
 
 #endif  /* CONFIG_ANON_VMA_NAME */
 
+void pfnmap_track_ctx_release(struct kref *ref);
+
 static inline void init_tlb_flush_pending(struct mm_struct *mm)
 {
 	atomic_set(&mm->tlb_flush_pending, 0);
--- a/include/linux/mm_types.h~mm-convert-vm_pfnmap-tracking-to-pfnmap_track-pfnmap_untrack
+++ a/include/linux/mm_types.h
@@ -763,6 +763,14 @@ struct vma_numab_state {
 	int prev_scan_seq;
 };
 
+#ifdef __HAVE_PFNMAP_TRACKING
+struct pfnmap_track_ctx {
+	struct kref kref;
+	unsigned long pfn;
+	unsigned long size;	/* in bytes */
+};
+#endif
+
 /*
  * Describes a VMA that is about to be mmap()'ed. Drivers may choose to
  * manipulate mutable fields which will cause those fields to be updated in the
@@ -900,6 +908,9 @@ struct vm_area_struct {
 	struct anon_vma_name *anon_name;
 #endif
 	struct vm_userfaultfd_ctx vm_userfaultfd_ctx;
+#ifdef __HAVE_PFNMAP_TRACKING
+	struct pfnmap_track_ctx *pfnmap_track_ctx;
+#endif
 } __randomize_layout;
 
 #ifdef CONFIG_NUMA
--- a/mm/memory.c~mm-convert-vm_pfnmap-tracking-to-pfnmap_track-pfnmap_untrack
+++ a/mm/memory.c
@@ -1371,7 +1371,7 @@ copy_page_range(struct vm_area_struct *d
 	struct mm_struct *dst_mm = dst_vma->vm_mm;
 	struct mm_struct *src_mm = src_vma->vm_mm;
 	struct mmu_notifier_range range;
-	unsigned long next, pfn = 0;
+	unsigned long next;
 	bool is_cow;
 	int ret;
 
@@ -1381,12 +1381,6 @@ copy_page_range(struct vm_area_struct *d
 	if (is_vm_hugetlb_page(src_vma))
 		return copy_hugetlb_page_range(dst_mm, src_mm, dst_vma, src_vma);
 
-	if (unlikely(src_vma->vm_flags & VM_PFNMAP)) {
-		ret = track_pfn_copy(dst_vma, src_vma, &pfn);
-		if (ret)
-			return ret;
-	}
-
 	/*
 	 * We need to invalidate the secondary MMU mappings only when
 	 * there could be a permission downgrade on the ptes of the
@@ -1428,8 +1422,6 @@ copy_page_range(struct vm_area_struct *d
 		raw_write_seqcount_end(&src_mm->write_protect_seq);
 		mmu_notifier_invalidate_range_end(&range);
 	}
-	if (ret && unlikely(src_vma->vm_flags & VM_PFNMAP))
-		untrack_pfn_copy(dst_vma, pfn);
 	return ret;
 }
 
@@ -1924,9 +1916,6 @@ static void unmap_single_vma(struct mmu_
 	if (vma->vm_file)
 		uprobe_munmap(vma, start, end);
 
-	if (unlikely(vma->vm_flags & VM_PFNMAP))
-		untrack_pfn(vma, 0, 0, mm_wr_locked);
-
 	if (start != end) {
 		if (unlikely(is_vm_hugetlb_page(vma))) {
 			/*
@@ -2872,6 +2861,36 @@ int remap_pfn_range_notrack(struct vm_ar
 	return error;
 }
 
+#ifdef __HAVE_PFNMAP_TRACKING
+static inline struct pfnmap_track_ctx *pfnmap_track_ctx_alloc(unsigned long pfn,
+		unsigned long size, pgprot_t *prot)
+{
+	struct pfnmap_track_ctx *ctx;
+
+	if (pfnmap_track(pfn, size, prot))
+		return ERR_PTR(-EINVAL);
+
+	ctx = kmalloc(sizeof(*ctx), GFP_KERNEL);
+	if (unlikely(!ctx)) {
+		pfnmap_untrack(pfn, size);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	ctx->pfn = pfn;
+	ctx->size = size;
+	kref_init(&ctx->kref);
+	return ctx;
+}
+
+void pfnmap_track_ctx_release(struct kref *ref)
+{
+	struct pfnmap_track_ctx *ctx = container_of(ref, struct pfnmap_track_ctx, kref);
+
+	pfnmap_untrack(ctx->pfn, ctx->size);
+	kfree(ctx);
+}
+#endif /* __HAVE_PFNMAP_TRACKING */
+
 /**
  * remap_pfn_range - remap kernel memory to userspace
  * @vma: user vma to map to
@@ -2884,20 +2903,51 @@ int remap_pfn_range_notrack(struct vm_ar
  *
  * Return: %0 on success, negative error code otherwise.
  */
+#ifdef __HAVE_PFNMAP_TRACKING
 int remap_pfn_range(struct vm_area_struct *vma, unsigned long addr,
 		    unsigned long pfn, unsigned long size, pgprot_t prot)
 {
+	struct pfnmap_track_ctx *ctx = NULL;
 	int err;
 
-	err = track_pfn_remap(vma, &prot, pfn, addr, PAGE_ALIGN(size));
-	if (err)
+	size = PAGE_ALIGN(size);
+
+	/*
+	 * If we cover the full VMA, we'll perform actual tracking, and
+	 * remember to untrack when the last reference to our tracking
+	 * context from a VMA goes away. We'll keep tracking the whole pfn
+	 * range even during VMA splits and partial unmapping.
+	 *
+	 * If we only cover parts of the VMA, we'll only setup the cachemode
+	 * in the pgprot for the pfn range.
+	 */
+	if (addr == vma->vm_start && addr + size == vma->vm_end) {
+		if (vma->pfnmap_track_ctx)
+			return -EINVAL;
+		ctx = pfnmap_track_ctx_alloc(pfn, size, &prot);
+		if (IS_ERR(ctx))
+			return PTR_ERR(ctx);
+	} else if (pfnmap_setup_cachemode(pfn, size, &prot)) {
 		return -EINVAL;
+	}
 
 	err = remap_pfn_range_notrack(vma, addr, pfn, size, prot);
-	if (err)
-		untrack_pfn(vma, pfn, PAGE_ALIGN(size), true);
+	if (ctx) {
+		if (err)
+			kref_put(&ctx->kref, pfnmap_track_ctx_release);
+		else
+			vma->pfnmap_track_ctx = ctx;
+	}
 	return err;
 }
+
+#else
+int remap_pfn_range(struct vm_area_struct *vma, unsigned long addr,
+		    unsigned long pfn, unsigned long size, pgprot_t prot)
+{
+	return remap_pfn_range_notrack(vma, addr, pfn, size, prot);
+}
+#endif
 EXPORT_SYMBOL(remap_pfn_range);
 
 /**
--- a/mm/mmap.c~mm-convert-vm_pfnmap-tracking-to-pfnmap_track-pfnmap_untrack
+++ a/mm/mmap.c
@@ -1784,11 +1784,6 @@ __latent_entropy int dup_mmap(struct mm_
 		tmp = vm_area_dup(mpnt);
 		if (!tmp)
 			goto fail_nomem;
-
-		/* track_pfn_copy() will later take care of copying internal state. */
-		if (unlikely(tmp->vm_flags & VM_PFNMAP))
-			untrack_pfn_clear(tmp);
-
 		retval = vma_dup_policy(mpnt, tmp);
 		if (retval)
 			goto fail_nomem_policy;
--- a/mm/mremap.c~mm-convert-vm_pfnmap-tracking-to-pfnmap_track-pfnmap_untrack
+++ a/mm/mremap.c
@@ -1191,10 +1191,6 @@ static int copy_vma_and_data(struct vma_
 	if (is_vm_hugetlb_page(vma))
 		clear_vma_resv_huge_pages(vma);
 
-	/* Tell pfnmap has moved from this vma */
-	if (unlikely(vma->vm_flags & VM_PFNMAP))
-		untrack_pfn_clear(vma);
-
 	*new_vma_ptr = new_vma;
 	return err;
 }
--- a/mm/vma_init.c~mm-convert-vm_pfnmap-tracking-to-pfnmap_track-pfnmap_untrack
+++ a/mm/vma_init.c
@@ -71,7 +71,51 @@ static void vm_area_init_from(const stru
 #ifdef CONFIG_NUMA
 	dest->vm_policy = src->vm_policy;
 #endif
+#ifdef __HAVE_PFNMAP_TRACKING
+	dest->pfnmap_track_ctx = NULL;
+#endif
+}
+
+#ifdef __HAVE_PFNMAP_TRACKING
+static inline int vma_pfnmap_track_ctx_dup(struct vm_area_struct *orig,
+		struct vm_area_struct *new)
+{
+	struct pfnmap_track_ctx *ctx = orig->pfnmap_track_ctx;
+
+	if (likely(!ctx))
+		return 0;
+
+	/*
+	 * We don't expect to ever hit this. If ever required, we would have
+	 * to duplicate the tracking.
+	 */
+	if (unlikely(kref_read(&ctx->kref) >= REFCOUNT_MAX))
+		return -ENOMEM;
+	kref_get(&ctx->kref);
+	new->pfnmap_track_ctx = ctx;
+	return 0;
+}
+
+static inline void vma_pfnmap_track_ctx_release(struct vm_area_struct *vma)
+{
+	struct pfnmap_track_ctx *ctx = vma->pfnmap_track_ctx;
+
+	if (likely(!ctx))
+		return;
+
+	kref_put(&ctx->kref, pfnmap_track_ctx_release);
+	vma->pfnmap_track_ctx = NULL;
 }
+#else
+static inline int vma_pfnmap_track_ctx_dup(struct vm_area_struct *orig,
+		struct vm_area_struct *new)
+{
+	return 0;
+}
+static inline void vma_pfnmap_track_ctx_release(struct vm_area_struct *vma)
+{
+}
+#endif
 
 struct vm_area_struct *vm_area_dup(struct vm_area_struct *orig)
 {
@@ -83,6 +127,11 @@ struct vm_area_struct *vm_area_dup(struc
 	ASSERT_EXCLUSIVE_WRITER(orig->vm_flags);
 	ASSERT_EXCLUSIVE_WRITER(orig->vm_file);
 	vm_area_init_from(orig, new);
+
+	if (vma_pfnmap_track_ctx_dup(orig, new)) {
+		kmem_cache_free(vm_area_cachep, new);
+		return NULL;
+	}
 	vma_lock_init(new, true);
 	INIT_LIST_HEAD(&new->anon_vma_chain);
 	vma_numab_state_init(new);
@@ -97,5 +146,6 @@ void vm_area_free(struct vm_area_struct
 	vma_assert_detached(vma);
 	vma_numab_state_free(vma);
 	free_anon_vma_name(vma);
+	vma_pfnmap_track_ctx_release(vma);
 	kmem_cache_free(vm_area_cachep, vma);
 }
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

