Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A07A143867
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 04:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291567; cv=none; b=WIFS1qzuDrgM2bL4Ujm8sLLTHnzHr1LxVsKrk+Jibmxv5J2KTaYlZAriImgrv7miT6jvfNo8scZDIjGL0Q5N2JRuJtiWIYbhm0XNavQCuSYOaxyn9cZP+ZVlWRwH1v0aJTsUrKxjX6p7xts1Mb7YE0QJnVoegHiLAq+b3/ybLo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291567; c=relaxed/simple;
	bh=67LSxw+7W9+Q8NHZjeNp5JbVmXHkEIHvbVUoCsWbQVc=;
	h=Date:To:From:Subject:Message-Id; b=fIEfHy57mBnebsM5pEEIuCXDt3gOUEUNPSlaCE5XIGGkf0ft6Tn86kUwN4xtBRgKNQYjhlDLmxL0uWOJfhf5nGk3hc95K/nvOEwpoiwasnNvcKdPbovKzRyc+NUn7MpOqPQvfvrt21a2JBbLHT/Ip2qsKz8p/RPNh3QXlJcfvUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dfCT7yAf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dfCT7yAf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A326EC32782;
	Tue, 25 Jun 2024 04:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291566;
	bh=67LSxw+7W9+Q8NHZjeNp5JbVmXHkEIHvbVUoCsWbQVc=;
	h=Date:To:From:Subject:From;
	b=dfCT7yAfudyTAj6duXK8vtr+Wl0CtWAguGEOKwnxI6MOKkUcRyCKfCMVCcQ1YoXmD
	 o/9luTLI0SOPokgRilaaWCDinwFUSworwO/WUd754P48RyAqse0PYiw4MrSEuS42CN
	 ZOSPl4oKDA7UEtyJPAT+X2GoCQ2WgzyqhLdCiRGo=
Date: Mon, 24 Jun 2024 21:59:26 -0700
To: mm-commits@vger.kernel.org,vdonnefort@google.com,dan.j.williams@intel.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-cleanly-support-zeropage-in-vm_insert_page-vm_map_pages-and-vmf_insert_mixed.patch removed from -mm tree
Message-Id: <20240625045926.A326EC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory: cleanly support zeropage in vm_insert_page*(), vm_map_pages*() and vmf_insert_mixed()
has been removed from the -mm tree.  Its filename was
     mm-memory-cleanly-support-zeropage-in-vm_insert_page-vm_map_pages-and-vmf_insert_mixed.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/memory: cleanly support zeropage in vm_insert_page*(), vm_map_pages*() and vmf_insert_mixed()
Date: Wed, 22 May 2024 14:57:12 +0200

For now we only get the (small) zeropage mapped to user space in four
cases (excluding VM_PFNMAP mappings, such as /proc/vmstat):

(1) Read page faults in anonymous VMAs (MAP_PRIVATE|MAP_ANON):
    do_anonymous_page() will not refcount it and map it pte_mkspecial()
(2) UFFDIO_ZEROPAGE on anonymous VMA or COW mapping of shmem
    (MAP_PRIVATE). mfill_atomic_pte_zeropage() will not refcount it and
    map it pte_mkspecial().
(3) KSM in mergeable VMA (anonymous VMA or COW mapping).
    cmp_and_merge_page() will not refcount it and map it
    pte_mkspecial().
(4) FSDAX as an optimization for holes.
    vmf_insert_mixed()->__vm_insert_mixed() might end up calling
    insert_page() without CONFIG_ARCH_HAS_PTE_SPECIAL, refcounting the
    zeropage and not mapping it pte_mkspecial(). With
    CONFIG_ARCH_HAS_PTE_SPECIAL, we'll call insert_pfn() where we will
    not refcount it and map it pte_mkspecial().

In case (4), we might not have VM_MIXEDMAP set: while fs/fuse/dax.c sets
VM_MIXEDMAP, we removed it for ext4 fsdax in commit e1fb4a086495 ("dax:
remove VM_MIXEDMAP for fsdax and device dax") and for XFS in commit
e1fb4a086495 ("dax: remove VM_MIXEDMAP for fsdax and device dax").

Without CONFIG_ARCH_HAS_PTE_SPECIAL and with VM_MIXEDMAP, vm_normal_page()
would currently return the zeropage.  We'll refcount the zeropage when
mapping and when unmapping.

Without CONFIG_ARCH_HAS_PTE_SPECIAL and without VM_MIXEDMAP,
vm_normal_page() would currently refuse to return the zeropage.  So we'd
refcount it when mapping but not when unmapping it ...  do we have fsdax
without CONFIG_ARCH_HAS_PTE_SPECIAL in practice?  Hard to tell.

Independent of that, we should never refcount the zeropage when we might
be holding that reference for a long time, because even without an
accounting imbalance we might overflow the refcount.  As there is interest
in using the zeropage also in other VM_MIXEDMAP mappings, let's add clean
support for that in the cases where it makes sense:

(A) Never refcount the zeropage when mapping it:

In insert_page(), special-case the zeropage, do not refcount it, and use
pte_mkspecial().  Don't involve insert_pfn(), adjusting insert_page()
looks cleaner than branching off to insert_pfn().

(B) Never refcount the zeropage when unmapping it:

In vm_normal_page(), also don't return the zeropage in a VM_MIXEDMAP
mapping without CONFIG_ARCH_HAS_PTE_SPECIAL.  Add a VM_WARN_ON_ONCE()
sanity check if we'd ever return the zeropage, which could happen if
someone forgets to set pte_mkspecial() when mapping the zeropage. 
Document that.

(C) Allow the zeropage only where reasonable

s390x never wants the zeropage in some processes running legacy KVM guests
that make use of storage keys.  So disallow that.

Further, using the zeropage in COW mappings is unproblematic (just what we
do for other COW mappings), because FAULT_FLAG_UNSHARE can just unshare it
and GUP with FOLL_LONGTERM would work as expected.

Similarly, mappings that can never have writable PTEs (implying no write
faults) are also not problematic, because nothing could end up mapping the
PTE writable by mistake later.  But in case we could have writable PTEs,
we'll only allow the zeropage in FSDAX VMAs, that are incompatible with
GUP and are blocked there completely.

We'll always require the zeropage to be mapped with pte_special(). 
GUP-fast will reject the zeropage that way, but GUP-slow will allow it. 
(Note that GUP does not refcount the zeropage with FOLL_PIN, because there
were issues with overflowing the refcount in the past).

Add sanity checks to can_change_pte_writable() and wp_page_reuse(), to
catch early during testing if we'd ever find a zeropage unexpectedly in
code that wants to upgrade write permissions.

Convert the BUG_ON in vm_mixed_ok() to an ordinary check and simply fail
with VM_FAULT_SIGBUS, like we do for other sanity checks.  Drop the stale
comment regarding reserved pages from insert_page().

Note that:
* we won't mess with VM_PFNMAP mappings for now. remap_pfn_range() and
  vmf_insert_pfn() would allow the zeropage in some cases and
  not refcount it.
* vmf_insert_pfn*() will reject the zeropage in VM_MIXEDMAP
  mappings and we'll leave that alone for now. People can simply use
  one of the other interfaces.
* we won't bother with the huge zeropage for now. It's never
  PTE-mapped and also GUP does not special-case it yet.

Link: https://lkml.kernel.org/r/20240522125713.775114-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c   |   91 ++++++++++++++++++++++++++++++++++++------------
 mm/mprotect.c |    2 +
 2 files changed, 72 insertions(+), 21 deletions(-)

--- a/mm/memory.c~mm-memory-cleanly-support-zeropage-in-vm_insert_page-vm_map_pages-and-vmf_insert_mixed
+++ a/mm/memory.c
@@ -575,10 +575,13 @@ static void print_bad_pte(struct vm_area
  * VM_MIXEDMAP mappings can likewise contain memory with or without "struct
  * page" backing, however the difference is that _all_ pages with a struct
  * page (that is, those where pfn_valid is true) are refcounted and considered
- * normal pages by the VM. The disadvantage is that pages are refcounted
- * (which can be slower and simply not an option for some PFNMAP users). The
- * advantage is that we don't have to follow the strict linearity rule of
- * PFNMAP mappings in order to support COWable mappings.
+ * normal pages by the VM. The only exception are zeropages, which are
+ * *never* refcounted.
+ *
+ * The disadvantage is that pages are refcounted (which can be slower and
+ * simply not an option for some PFNMAP users). The advantage is that we
+ * don't have to follow the strict linearity rule of PFNMAP mappings in
+ * order to support COWable mappings.
  *
  */
 struct page *vm_normal_page(struct vm_area_struct *vma, unsigned long addr,
@@ -616,6 +619,8 @@ struct page *vm_normal_page(struct vm_ar
 		if (vma->vm_flags & VM_MIXEDMAP) {
 			if (!pfn_valid(pfn))
 				return NULL;
+			if (is_zero_pfn(pfn))
+				return NULL;
 			goto out;
 		} else {
 			unsigned long off;
@@ -641,6 +646,7 @@ check_pfn:
 	 * eg. VDSO mappings can cause them to exist.
 	 */
 out:
+	VM_WARN_ON_ONCE(is_zero_pfn(pfn));
 	return pfn_to_page(pfn);
 }
 
@@ -1977,12 +1983,48 @@ pte_t *__get_locked_pte(struct mm_struct
 	return pte_alloc_map_lock(mm, pmd, addr, ptl);
 }
 
-static int validate_page_before_insert(struct page *page)
+static bool vm_mixed_zeropage_allowed(struct vm_area_struct *vma)
+{
+	VM_WARN_ON_ONCE(vma->vm_flags & VM_PFNMAP);
+	/*
+	 * Whoever wants to forbid the zeropage after some zeropages
+	 * might already have been mapped has to scan the page tables and
+	 * bail out on any zeropages. Zeropages in COW mappings can
+	 * be unshared using FAULT_FLAG_UNSHARE faults.
+	 */
+	if (mm_forbids_zeropage(vma->vm_mm))
+		return false;
+	/* zeropages in COW mappings are common and unproblematic. */
+	if (is_cow_mapping(vma->vm_flags))
+		return true;
+	/* Mappings that do not allow for writable PTEs are unproblematic. */
+	if (!(vma->vm_flags & (VM_WRITE | VM_MAYWRITE)))
+		return true;
+	/*
+	 * Why not allow any VMA that has vm_ops->pfn_mkwrite? GUP could
+	 * find the shared zeropage and longterm-pin it, which would
+	 * be problematic as soon as the zeropage gets replaced by a different
+	 * page due to vma->vm_ops->pfn_mkwrite, because what's mapped would
+	 * now differ to what GUP looked up. FSDAX is incompatible to
+	 * FOLL_LONGTERM and VM_IO is incompatible to GUP completely (see
+	 * check_vma_flags).
+	 */
+	return vma->vm_ops && vma->vm_ops->pfn_mkwrite &&
+	       (vma_is_fsdax(vma) || vma->vm_flags & VM_IO);
+}
+
+static int validate_page_before_insert(struct vm_area_struct *vma,
+				       struct page *page)
 {
 	struct folio *folio = page_folio(page);
 
 	if (!folio_ref_count(folio))
 		return -EINVAL;
+	if (unlikely(is_zero_folio(folio))) {
+		if (!vm_mixed_zeropage_allowed(vma))
+			return -EINVAL;
+		return 0;
+	}
 	if (folio_test_anon(folio) || folio_test_slab(folio) ||
 	    page_has_type(page))
 		return -EINVAL;
@@ -1994,24 +2036,23 @@ static int insert_page_into_pte_locked(s
 			unsigned long addr, struct page *page, pgprot_t prot)
 {
 	struct folio *folio = page_folio(page);
+	pte_t pteval;
 
 	if (!pte_none(ptep_get(pte)))
 		return -EBUSY;
 	/* Ok, finally just insert the thing.. */
-	folio_get(folio);
-	inc_mm_counter(vma->vm_mm, mm_counter_file(folio));
-	folio_add_file_rmap_pte(folio, page, vma);
-	set_pte_at(vma->vm_mm, addr, pte, mk_pte(page, prot));
+	pteval = mk_pte(page, prot);
+	if (unlikely(is_zero_folio(folio))) {
+		pteval = pte_mkspecial(pteval);
+	} else {
+		folio_get(folio);
+		inc_mm_counter(vma->vm_mm, mm_counter_file(folio));
+		folio_add_file_rmap_pte(folio, page, vma);
+	}
+	set_pte_at(vma->vm_mm, addr, pte, pteval);
 	return 0;
 }
 
-/*
- * This is the old fallback for page remapping.
- *
- * For historical reasons, it only allows reserved pages. Only
- * old drivers should use this, and they needed to mark their
- * pages reserved for the old functions anyway.
- */
 static int insert_page(struct vm_area_struct *vma, unsigned long addr,
 			struct page *page, pgprot_t prot)
 {
@@ -2019,7 +2060,7 @@ static int insert_page(struct vm_area_st
 	pte_t *pte;
 	spinlock_t *ptl;
 
-	retval = validate_page_before_insert(page);
+	retval = validate_page_before_insert(vma, page);
 	if (retval)
 		goto out;
 	retval = -ENOMEM;
@@ -2037,7 +2078,7 @@ static int insert_page_in_batch_locked(s
 {
 	int err;
 
-	err = validate_page_before_insert(page);
+	err = validate_page_before_insert(vma, page);
 	if (err)
 		return err;
 	return insert_page_into_pte_locked(vma, pte, addr, page, prot);
@@ -2143,7 +2184,8 @@ EXPORT_SYMBOL(vm_insert_pages);
  * @page: source kernel page
  *
  * This allows drivers to insert individual pages they've allocated
- * into a user vma.
+ * into a user vma. The zeropage is supported in some VMAs,
+ * see vm_mixed_zeropage_allowed().
  *
  * The page has to be a nice clean _individual_ kernel allocation.
  * If you allocate a compound page, you need to have marked it as
@@ -2187,6 +2229,8 @@ EXPORT_SYMBOL(vm_insert_page);
  * @offset: user's requested vm_pgoff
  *
  * This allows drivers to map range of kernel pages into a user vma.
+ * The zeropage is supported in some VMAs, see
+ * vm_mixed_zeropage_allowed().
  *
  * Return: 0 on success and error code otherwise.
  */
@@ -2402,8 +2446,11 @@ vm_fault_t vmf_insert_pfn(struct vm_area
 }
 EXPORT_SYMBOL(vmf_insert_pfn);
 
-static bool vm_mixed_ok(struct vm_area_struct *vma, pfn_t pfn)
+static bool vm_mixed_ok(struct vm_area_struct *vma, pfn_t pfn, bool mkwrite)
 {
+	if (unlikely(is_zero_pfn(pfn_t_to_pfn(pfn))) &&
+	    (mkwrite || !vm_mixed_zeropage_allowed(vma)))
+		return false;
 	/* these checks mirror the abort conditions in vm_normal_page */
 	if (vma->vm_flags & VM_MIXEDMAP)
 		return true;
@@ -2422,7 +2469,8 @@ static vm_fault_t __vm_insert_mixed(stru
 	pgprot_t pgprot = vma->vm_page_prot;
 	int err;
 
-	BUG_ON(!vm_mixed_ok(vma, pfn));
+	if (!vm_mixed_ok(vma, pfn, mkwrite))
+		return VM_FAULT_SIGBUS;
 
 	if (addr < vma->vm_start || addr >= vma->vm_end)
 		return VM_FAULT_SIGBUS;
@@ -3170,6 +3218,7 @@ static inline void wp_page_reuse(struct
 	pte_t entry;
 
 	VM_BUG_ON(!(vmf->flags & FAULT_FLAG_WRITE));
+	VM_WARN_ON(is_zero_pfn(pte_pfn(vmf->orig_pte)));
 
 	if (folio) {
 		VM_BUG_ON(folio_test_anon(folio) &&
--- a/mm/mprotect.c~mm-memory-cleanly-support-zeropage-in-vm_insert_page-vm_map_pages-and-vmf_insert_mixed
+++ a/mm/mprotect.c
@@ -71,6 +71,8 @@ bool can_change_pte_writable(struct vm_a
 		return page && PageAnon(page) && PageAnonExclusive(page);
 	}
 
+	VM_WARN_ON_ONCE(is_zero_pfn(pte_pfn(pte)) && pte_dirty(pte));
+
 	/*
 	 * Writable MAP_SHARED mapping: "clean" might indicate that the FS still
 	 * needs a real write-fault for writenotify
_

Patches currently in -mm which might be from david@redhat.com are

mm-pass-meminit_context-to-__free_pages_core.patch
mm-pass-meminit_context-to-__free_pages_core-fix.patch
mm-pass-meminit_context-to-__free_pages_core-fix-2.patch
mm-pass-meminit_context-to-__free_pages_core-fix-3.patch
mm-memory_hotplug-initialize-memmap-of-zone_device-with-pageoffline-instead-of-pagereserved.patch
mm-memory_hotplug-skip-adjust_managed_page_count-for-pageoffline-pages-when-offlining.patch
mm-read-page_type-using-read_once.patch
mm-migrate-make-migrate_misplaced_folio-return-0-on-success.patch
mm-migrate-move-numa-hinting-fault-folio-isolation-checks-under-ptl.patch

