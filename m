Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C85D23A566
	for <mm-commits@vger.kernel.org>; Mon,  3 Mar 2025 22:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741042564; cv=none; b=QSp3F/wx2m+TLhqcOLyaGUk7uHkgyYPr4bvO/JFaQadLGM8AjTbJxlin0V5QfqU+0gOgzzXnjKw5Yx2+ReiILa2dDktJQ5QUqPhO3MaXLbJ+v89/Z4HyURIM6Y5hcGoyOKhhf0aS+s/n2phZP6tY+apzEWGMdyxfBLEGxpY7X14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741042564; c=relaxed/simple;
	bh=pI83VVRVS6ag42dVN1obOw4n4nGF8Dapc07PCBKWocI=;
	h=Date:To:From:Subject:Message-Id; b=riGwb0l3/zAP/1lBl4cDCb/6fNnKmtceTrMyx++V7K78EqZqSjYCveQ4IUCLii6NodxIwolHl8YXLpreiGQDYIIJ7HfwDEgNIImtnD3BL/opqdVUShXJ2BEUAFxc6sXiB48iItO66R9kJgaQA2uuGQafMlC0ayKJNiUqwFBDs1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KM+p0u5n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KM+p0u5n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC4F2C4CEE8;
	Mon,  3 Mar 2025 22:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741042563;
	bh=pI83VVRVS6ag42dVN1obOw4n4nGF8Dapc07PCBKWocI=;
	h=Date:To:From:Subject:From;
	b=KM+p0u5nU2Ci3MYMC9T28yW5wfclkkp75sVHaGMONcOZs9L5ETrAERAJucfESHVn6
	 Ofv2ZHiTEIQ507x+jKzTL1ZYTl8+MUpJCQXmTqPGVFb5WOReOQazon79m1QGcGMJiS
	 tE+IX69r525VC0hzpd+xLFI4rgfaVz16vFzf951o=
Date: Mon, 03 Mar 2025 14:56:03 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,tj@kernel.org,tglx@linutronix.de,muchun.song@linux.dev,mkoutny@suse.com,mingo@redhat.com,luto@kernel.org,lorenzo.stoakes@oracle.com,lizefan.x@bytedance.com,liam.howlett@oracle.com,kirill.shutemov@linux.intel.com,jannh@google.com,ioworker0@gmail.com,hannes@cmpxchg.org,dave.hansen@linux.intel.com,corbet@lwn.net,bp@alien8.de,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-use-folio_large_nr_pages-in-add-remove-functions.patch added to mm-unstable branch
Message-Id: <20250303225603.CC4F2C4CEE8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/rmap: use folio_large_nr_pages() in add/remove functions
has been added to the -mm mm-unstable branch.  Its filename is
     mm-rmap-use-folio_large_nr_pages-in-add-remove-functions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-use-folio_large_nr_pages-in-add-remove-functions.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Subject: mm/rmap: use folio_large_nr_pages() in add/remove functions
Date: Mon, 3 Mar 2025 17:30:04 +0100

Let's just use the "large" variant in code where we are sure that we have
a large folio in our hands: this way we are sure that we don't perform any
unnecessary "large" checks.

While at it, convert the VM_BUG_ON_VMA to a VM_WARN_ON_ONCE.

Maybe in the future there will not be a difference in that regard between
large and small folios; in that case, unifying the handling again will be
easy.  E.g., folio_large_nr_pages() will simply translate to
folio_nr_pages() until we replace all instances.

Link: https://lkml.kernel.org/r/20250303163014.1128035-12-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andy Lutomirks^H^Hski <luto@kernel.org>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: Michal Koutn <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: tejun heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zefan Li <lizefan.x@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/mm/rmap.c~mm-rmap-use-folio_large_nr_pages-in-add-remove-functions
+++ a/mm/rmap.c
@@ -1274,7 +1274,7 @@ static __always_inline unsigned int __fo
 		if (first) {
 			nr = atomic_add_return_relaxed(ENTIRELY_MAPPED, mapped);
 			if (likely(nr < ENTIRELY_MAPPED + ENTIRELY_MAPPED)) {
-				nr_pages = folio_nr_pages(folio);
+				nr_pages = folio_large_nr_pages(folio);
 				/*
 				 * We only track PMD mappings of PMD-sized
 				 * folios separately.
@@ -1522,14 +1522,11 @@ void folio_add_anon_rmap_pmd(struct foli
 void folio_add_new_anon_rmap(struct folio *folio, struct vm_area_struct *vma,
 		unsigned long address, rmap_t flags)
 {
-	const int nr = folio_nr_pages(folio);
 	const bool exclusive = flags & RMAP_EXCLUSIVE;
-	int nr_pmdmapped = 0;
+	int nr = 1, nr_pmdmapped = 0;
 
 	VM_WARN_ON_FOLIO(folio_test_hugetlb(folio), folio);
 	VM_WARN_ON_FOLIO(!exclusive && !folio_test_locked(folio), folio);
-	VM_BUG_ON_VMA(address < vma->vm_start ||
-			address + (nr << PAGE_SHIFT) > vma->vm_end, vma);
 
 	/*
 	 * VM_DROPPABLE mappings don't swap; instead they're just dropped when
@@ -1547,6 +1544,7 @@ void folio_add_new_anon_rmap(struct foli
 	} else if (!folio_test_pmd_mappable(folio)) {
 		int i;
 
+		nr = folio_large_nr_pages(folio);
 		for (i = 0; i < nr; i++) {
 			struct page *page = folio_page(folio, i);
 
@@ -1559,6 +1557,7 @@ void folio_add_new_anon_rmap(struct foli
 		folio_set_large_mapcount(folio, nr, vma);
 		atomic_set(&folio->_nr_pages_mapped, nr);
 	} else {
+		nr = folio_large_nr_pages(folio);
 		/* increment count (starts at -1) */
 		atomic_set(&folio->_entire_mapcount, 0);
 		folio_set_large_mapcount(folio, 1, vma);
@@ -1568,6 +1567,9 @@ void folio_add_new_anon_rmap(struct foli
 		nr_pmdmapped = nr;
 	}
 
+	VM_WARN_ON_ONCE(address < vma->vm_start ||
+			address + (nr << PAGE_SHIFT) > vma->vm_end);
+
 	__folio_mod_stat(folio, nr, nr_pmdmapped);
 	mod_mthp_stat(folio_order(folio), MTHP_STAT_NR_ANON, 1);
 }
@@ -1681,7 +1683,7 @@ static __always_inline void __folio_remo
 		if (last) {
 			nr = atomic_sub_return_relaxed(ENTIRELY_MAPPED, mapped);
 			if (likely(nr < ENTIRELY_MAPPED)) {
-				nr_pages = folio_nr_pages(folio);
+				nr_pages = folio_large_nr_pages(folio);
 				if (level == RMAP_LEVEL_PMD)
 					nr_pmdmapped = nr_pages;
 				nr = nr_pages - (nr & FOLIO_PAGES_MAPPED);
_

Patches currently in -mm which might be from david@redhat.com are

mm-gup-reject-foll_split_pmd-with-hugetlb-vmas.patch
mm-rmap-reject-hugetlb-folios-in-folio_make_device_exclusive.patch
mm-rmap-convert-make_device_exclusive_range-to-make_device_exclusive.patch
mm-rmap-convert-make_device_exclusive_range-to-make_device_exclusive-fix.patch
mm-rmap-implement-make_device_exclusive-using-folio_walk-instead-of-rmap-walk.patch
mm-memory-detect-writability-in-restore_exclusive_pte-through-can_change_pte_writable.patch
mm-use-single-swp_device_exclusive-entry-type.patch
mm-page_vma_mapped-device-exclusive-entries-are-not-migration-entries.patch
kernel-events-uprobes-handle-device-exclusive-entries-correctly-in-__replace_page.patch
mm-ksm-handle-device-exclusive-entries-correctly-in-write_protect_page.patch
mm-rmap-handle-device-exclusive-entries-correctly-in-try_to_unmap_one.patch
mm-rmap-handle-device-exclusive-entries-correctly-in-try_to_migrate_one.patch
mm-rmap-handle-device-exclusive-entries-correctly-in-page_vma_mkclean_one.patch
mm-page_idle-handle-device-exclusive-entries-correctly-in-page_idle_clear_pte_refs_one.patch
mm-damon-handle-device-exclusive-entries-correctly-in-damon_folio_young_one.patch
mm-damon-handle-device-exclusive-entries-correctly-in-damon_folio_mkold_one.patch
mm-rmap-keep-mapcount-untouched-for-device-exclusive-entries.patch
mm-rmap-avoid-ebusy-from-make_device_exclusive.patch
lib-test_hmm-make-dmirror_atomic_map-consume-a-single-page.patch
mm-memory-remove-pageanonexclusive-sanity-check-in-restore_exclusive_pte.patch
mm-memory-pass-folio-and-pte-to-restore_exclusive_pte.patch
mm-memory-document-restore_exclusive_pte.patch
mm-mmu_notifier-use-mmu_notify_clear-in-remove_device_exclusive_entry.patch
mm-factor-out-large-folio-handling-from-folio_order-into-folio_large_order.patch
mm-factor-out-large-folio-handling-from-folio_nr_pages-into-folio_large_nr_pages.patch
mm-let-_folio_nr_pages-overlay-memcg_data-in-first-tail-page.patch
mm-move-hugetlb-specific-things-in-folio-to-page.patch
mm-move-_pincount-in-folio-to-page-on-32bit.patch
mm-move-_entire_mapcount-in-folio-to-page-on-32bit.patch
mm-rmap-pass-dst_vma-to-folio_dup_file_rmap_pte-and-friends.patch
mm-rmap-pass-vma-to-__folio_add_rmap.patch
mm-rmap-abstract-large-mapcount-operations-for-large-folios-hugetlb.patch
bit_spinlock-__always_inline-unlock-functions.patch
mm-rmap-use-folio_large_nr_pages-in-add-remove-functions.patch
mm-rmap-basic-mm-owner-tracking-for-large-folios-hugetlb.patch
mm-copy-on-write-cow-reuse-support-for-pte-mapped-thp.patch
mm-convert-folio_likely_mapped_shared-to-folio_maybe_mapped_shared.patch
mm-config_no_page_mapcount-to-prepare-for-not-maintain-per-page-mapcounts-in-large-folios.patch
fs-proc-page-remove-per-page-mapcount-dependency-for-proc-kpagecount-config_no_page_mapcount.patch
fs-proc-task_mmu-remove-per-page-mapcount-dependency-for-pm_mmap_exclusive-config_no_page_mapcount.patch
fs-proc-task_mmu-remove-per-page-mapcount-dependency-for-mapmax-config_no_page_mapcount.patch
fs-proc-task_mmu-remove-per-page-mapcount-dependency-for-smaps-smaps_rollup-config_no_page_mapcount.patch
mm-stop-maintaining-the-per-page-mapcount-of-large-folios-config_no_page_mapcount.patch

