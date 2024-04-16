Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 363881E511;
	Tue, 16 Apr 2024 22:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713307217; cv=none; b=Yh5WUlXK2jcM8y7LHgLAuYALIGsLPi4HMOHrXtO8Ce1pqrCBo5j8kt4JHgIPMARQjY0Oq/qpj1Y7HMWiOJFuuElMrFKPx7KywAKBjo/m0DQQVg5OJ/K9eqkdUukqAPWEa/39S+BJ8BA4QnRuWrEJOa9QtGkqmCo0Bhc50++Hrew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713307217; c=relaxed/simple;
	bh=2l9+Ioop1YGNM7jQSTUJMCOSCphPGQV5XtW28VmwAUc=;
	h=Date:To:From:Subject:Message-Id; b=k2Jol8GcDT/1KOSxLVGci7aLLXN/ggFpLJ2tp3yBRPnFrKbxC5FVmXxqazaT5TroM12iXez3veaco4TNsBdTireaQapbUfPwzuOPSepu1F+wjmQOtajwlF4oHCcBXc8yHz7lngZ6VmLDa8/1d5pDvLKiKOe+hucHweyH1rEUZJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=esNGlvU7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="esNGlvU7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77AA5C3277B;
	Tue, 16 Apr 2024 22:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713307216;
	bh=2l9+Ioop1YGNM7jQSTUJMCOSCphPGQV5XtW28VmwAUc=;
	h=Date:To:From:Subject:From;
	b=esNGlvU7DlER1XIJ71T3wCG/cD/xUF8v7uWH2vq8dsP+fXMBhsGFPJMB01D+jeQEt
	 2RjCr3J2fsgJEcT4CrUun5VkwdHpNbQ+yMxlqRVnpNFx4+8gJ1r6fuLg2P6jCps/r8
	 AeWc6xwYJsOvnvioP1+nvwmbayi1dHIEY/s8IivY=
Date: Tue, 16 Apr 2024 15:40:15 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,jhubbard@nvidia.com,jgg@nvidia.com,hughd@google.com,djwong@kernel.org,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-madvise-make-madv_populate_readwrite-handle-vm_fault_retry-properly.patch removed from -mm tree
Message-Id: <20240416224016.77AA5C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/madvise: make MADV_POPULATE_(READ|WRITE) handle VM_FAULT_RETRY properly
has been removed from the -mm tree.  Its filename was
     mm-madvise-make-madv_populate_readwrite-handle-vm_fault_retry-properly.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/madvise: make MADV_POPULATE_(READ|WRITE) handle VM_FAULT_RETRY properly
Date: Thu, 14 Mar 2024 17:12:59 +0100

Darrick reports that in some cases where pread() would fail with -EIO and
mmap()+access would generate a SIGBUS signal, MADV_POPULATE_READ /
MADV_POPULATE_WRITE will keep retrying forever and not fail with -EFAULT.

While the madvise() call can be interrupted by a signal, this is not the
desired behavior.  MADV_POPULATE_READ / MADV_POPULATE_WRITE should behave
like page faults in that case: fail and not retry forever.

A reproducer can be found at [1].

The reason is that __get_user_pages(), as called by
faultin_vma_page_range(), will not handle VM_FAULT_RETRY in a proper way:
it will simply return 0 when VM_FAULT_RETRY happened, making
madvise_populate()->faultin_vma_page_range() retry again and again, never
setting FOLL_TRIED->FAULT_FLAG_TRIED for __get_user_pages().

__get_user_pages_locked() does what we want, but duplicating that logic in
faultin_vma_page_range() feels wrong.

So let's use __get_user_pages_locked() instead, that will detect
VM_FAULT_RETRY and set FOLL_TRIED when retrying, making the fault handler
return VM_FAULT_SIGBUS (VM_FAULT_ERROR) at some point, propagating -EFAULT
from faultin_page() to __get_user_pages(), all the way to
madvise_populate().

But, there is an issue: __get_user_pages_locked() will end up re-taking
the MM lock and then __get_user_pages() will do another VMA lookup.  In
the meantime, the VMA layout could have changed and we'd fail with
different error codes than we'd want to.

As __get_user_pages() will currently do a new VMA lookup either way, let
it do the VMA handling in a different way, controlled by a new
FOLL_MADV_POPULATE flag, effectively moving these checks from
madvise_populate() + faultin_page_range() in there.

With this change, Darricks reproducer properly fails with -EFAULT, as
documented for MADV_POPULATE_READ / MADV_POPULATE_WRITE.

[1] https://lore.kernel.org/all/20240313171936.GN1927156@frogsfrogsfrogs/

Link: https://lkml.kernel.org/r/20240314161300.382526-1-david@redhat.com
Link: https://lkml.kernel.org/r/20240314161300.382526-2-david@redhat.com
Fixes: 4ca9b3859dac ("mm/madvise: introduce MADV_POPULATE_(READ|WRITE) to prefault page tables")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reported-by: Darrick J. Wong <djwong@kernel.org>
Closes: https://lore.kernel.org/all/20240311223815.GW1927156@frogsfrogsfrogs/
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c      |   54 ++++++++++++++++++++++++++++--------------------
 mm/internal.h |   10 +++++---
 mm/madvise.c  |   17 +--------------
 3 files changed, 40 insertions(+), 41 deletions(-)

--- a/mm/gup.c~mm-madvise-make-madv_populate_readwrite-handle-vm_fault_retry-properly
+++ a/mm/gup.c
@@ -1206,6 +1206,22 @@ static long __get_user_pages(struct mm_s
 
 		/* first iteration or cross vma bound */
 		if (!vma || start >= vma->vm_end) {
+			/*
+			 * MADV_POPULATE_(READ|WRITE) wants to handle VMA
+			 * lookups+error reporting differently.
+			 */
+			if (gup_flags & FOLL_MADV_POPULATE) {
+				vma = vma_lookup(mm, start);
+				if (!vma) {
+					ret = -ENOMEM;
+					goto out;
+				}
+				if (check_vma_flags(vma, gup_flags)) {
+					ret = -EINVAL;
+					goto out;
+				}
+				goto retry;
+			}
 			vma = gup_vma_lookup(mm, start);
 			if (!vma && in_gate_area(mm, start)) {
 				ret = get_gate_page(mm, start & PAGE_MASK,
@@ -1685,35 +1701,35 @@ long populate_vma_page_range(struct vm_a
 }
 
 /*
- * faultin_vma_page_range() - populate (prefault) page tables inside the
- *			      given VMA range readable/writable
+ * faultin_page_range() - populate (prefault) page tables inside the
+ *			  given range readable/writable
  *
  * This takes care of mlocking the pages, too, if VM_LOCKED is set.
  *
- * @vma: target vma
+ * @mm: the mm to populate page tables in
  * @start: start address
  * @end: end address
  * @write: whether to prefault readable or writable
  * @locked: whether the mmap_lock is still held
  *
- * Returns either number of processed pages in the vma, or a negative error
- * code on error (see __get_user_pages()).
+ * Returns either number of processed pages in the MM, or a negative error
+ * code on error (see __get_user_pages()). Note that this function reports
+ * errors related to VMAs, such as incompatible mappings, as expected by
+ * MADV_POPULATE_(READ|WRITE).
  *
- * vma->vm_mm->mmap_lock must be held. The range must be page-aligned and
- * covered by the VMA. If it's released, *@locked will be set to 0.
+ * The range must be page-aligned.
+ *
+ * mm->mmap_lock must be held. If it's released, *@locked will be set to 0.
  */
-long faultin_vma_page_range(struct vm_area_struct *vma, unsigned long start,
-			    unsigned long end, bool write, int *locked)
+long faultin_page_range(struct mm_struct *mm, unsigned long start,
+			unsigned long end, bool write, int *locked)
 {
-	struct mm_struct *mm = vma->vm_mm;
 	unsigned long nr_pages = (end - start) / PAGE_SIZE;
 	int gup_flags;
 	long ret;
 
 	VM_BUG_ON(!PAGE_ALIGNED(start));
 	VM_BUG_ON(!PAGE_ALIGNED(end));
-	VM_BUG_ON_VMA(start < vma->vm_start, vma);
-	VM_BUG_ON_VMA(end > vma->vm_end, vma);
 	mmap_assert_locked(mm);
 
 	/*
@@ -1725,19 +1741,13 @@ long faultin_vma_page_range(struct vm_ar
 	 *		  a poisoned page.
 	 * !FOLL_FORCE: Require proper access permissions.
 	 */
-	gup_flags = FOLL_TOUCH | FOLL_HWPOISON | FOLL_UNLOCKABLE;
+	gup_flags = FOLL_TOUCH | FOLL_HWPOISON | FOLL_UNLOCKABLE |
+		    FOLL_MADV_POPULATE;
 	if (write)
 		gup_flags |= FOLL_WRITE;
 
-	/*
-	 * We want to report -EINVAL instead of -EFAULT for any permission
-	 * problems or incompatible mappings.
-	 */
-	if (check_vma_flags(vma, gup_flags))
-		return -EINVAL;
-
-	ret = __get_user_pages(mm, start, nr_pages, gup_flags,
-			       NULL, locked);
+	ret = __get_user_pages_locked(mm, start, nr_pages, NULL, locked,
+				      gup_flags);
 	lru_add_drain();
 	return ret;
 }
--- a/mm/internal.h~mm-madvise-make-madv_populate_readwrite-handle-vm_fault_retry-properly
+++ a/mm/internal.h
@@ -686,9 +686,8 @@ struct anon_vma *folio_anon_vma(struct f
 void unmap_mapping_folio(struct folio *folio);
 extern long populate_vma_page_range(struct vm_area_struct *vma,
 		unsigned long start, unsigned long end, int *locked);
-extern long faultin_vma_page_range(struct vm_area_struct *vma,
-				   unsigned long start, unsigned long end,
-				   bool write, int *locked);
+extern long faultin_page_range(struct mm_struct *mm, unsigned long start,
+		unsigned long end, bool write, int *locked);
 extern bool mlock_future_ok(struct mm_struct *mm, unsigned long flags,
 			       unsigned long bytes);
 
@@ -1127,10 +1126,13 @@ enum {
 	FOLL_FAST_ONLY = 1 << 20,
 	/* allow unlocking the mmap lock */
 	FOLL_UNLOCKABLE = 1 << 21,
+	/* VMA lookup+checks compatible with MADV_POPULATE_(READ|WRITE) */
+	FOLL_MADV_POPULATE = 1 << 22,
 };
 
 #define INTERNAL_GUP_FLAGS (FOLL_TOUCH | FOLL_TRIED | FOLL_REMOTE | FOLL_PIN | \
-			    FOLL_FAST_ONLY | FOLL_UNLOCKABLE)
+			    FOLL_FAST_ONLY | FOLL_UNLOCKABLE | \
+			    FOLL_MADV_POPULATE)
 
 /*
  * Indicates for which pages that are write-protected in the page table,
--- a/mm/madvise.c~mm-madvise-make-madv_populate_readwrite-handle-vm_fault_retry-properly
+++ a/mm/madvise.c
@@ -908,27 +908,14 @@ static long madvise_populate(struct vm_a
 {
 	const bool write = behavior == MADV_POPULATE_WRITE;
 	struct mm_struct *mm = vma->vm_mm;
-	unsigned long tmp_end;
 	int locked = 1;
 	long pages;
 
 	*prev = vma;
 
 	while (start < end) {
-		/*
-		 * We might have temporarily dropped the lock. For example,
-		 * our VMA might have been split.
-		 */
-		if (!vma || start >= vma->vm_end) {
-			vma = vma_lookup(mm, start);
-			if (!vma)
-				return -ENOMEM;
-		}
-
-		tmp_end = min_t(unsigned long, end, vma->vm_end);
 		/* Populate (prefault) page tables readable/writable. */
-		pages = faultin_vma_page_range(vma, start, tmp_end, write,
-					       &locked);
+		pages = faultin_page_range(mm, start, end, write, &locked);
 		if (!locked) {
 			mmap_read_lock(mm);
 			locked = 1;
@@ -949,7 +936,7 @@ static long madvise_populate(struct vm_a
 				pr_warn_once("%s: unhandled return value: %ld\n",
 					     __func__, pages);
 				fallthrough;
-			case -ENOMEM:
+			case -ENOMEM: /* No VMA or out of memory. */
 				return -ENOMEM;
 			}
 		}
_

Patches currently in -mm which might be from david@redhat.com are

mm-madvise-dont-perform-madvise-vma-walk-for-madv_populate_readwrite.patch
mm-convert-folio_estimated_sharers-to-folio_likely_mapped_shared.patch
mm-convert-folio_estimated_sharers-to-folio_likely_mapped_shared-fix.patch
selftests-memfd_secret-add-vmsplice-test.patch
mm-merge-folio_is_secretmem-and-folio_fast_pin_allowed-into-gup_fast_folio_allowed.patch
mm-optimize-config_per_vma_lock-member-placement-in-vm_area_struct.patch
mm-remove-prot-parameter-from-move_pte.patch
mm-gup-consistently-name-gup-fast-functions.patch
mm-treewide-rename-config_have_fast_gup-to-config_have_gup_fast.patch
mm-use-gup-fast-instead-fast-gup-in-remaining-comments.patch
drivers-virt-acrn-fix-pfnmap-pte-checks-in-acrn_vm_ram_map.patch
mm-pass-vma-instead-of-mm-to-follow_pte.patch
mm-follow_pte-improvements.patch
mm-allow-for-detecting-underflows-with-page_mapcount-again.patch
mm-rmap-always-inline-anon-file-rmap-duplication-of-a-single-pte.patch
mm-rmap-add-fast-path-for-small-folios-when-adding-removing-duplicating.patch
mm-track-mapcount-of-large-folios-in-single-value.patch
mm-improve-folio_likely_mapped_shared-using-the-mapcount-of-large-folios.patch
mm-make-folio_mapcount-return-0-for-small-typed-folios.patch
mm-memory-use-folio_mapcount-in-zap_present_folio_ptes.patch
mm-huge_memory-use-folio_mapcount-in-zap_huge_pmd-sanity-check.patch
mm-memory-failure-use-folio_mapcount-in-hwpoison_user_mappings.patch
mm-page_alloc-use-folio_mapped-in-__alloc_contig_migrate_range.patch
mm-migrate-use-folio_likely_mapped_shared-in-add_page_for_migration.patch
sh-mm-cache-use-folio_mapped-in-copy_from_user_page.patch
mm-filemap-use-folio_mapcount-in-filemap_unaccount_folio.patch
mm-migrate_device-use-folio_mapcount-in-migrate_vma_check_page.patch
trace-events-page_ref-trace-the-raw-page-mapcount-value.patch
xtensa-mm-convert-check_tlb_entry-to-sanity-check-folios.patch
mm-debug-print-only-page-mapcount-excluding-folio-entire-mapcount-in-__dump_folio.patch
documentation-admin-guide-cgroup-v1-memoryrst-dont-reference-page_mapcount.patch
mm-ksm-rename-get_ksm_page_flags-to-ksm_get_folio_flags.patch
mm-ksm-remove-page_mapcount-usage-in-stable_tree_search.patch
loongarch-tlb-fix-error-parameter-ptep-set-but-not-used-due-to-__tlb_remove_tlb_entry.patch

