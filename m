Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 409E723A99C
	for <mm-commits@vger.kernel.org>; Mon,  3 Mar 2025 22:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741042554; cv=none; b=YbItronBBnOS58PaHygjcvWxJZllwh25GK7pM05GyqD8jxv9Zi9PnFh0RDtLIDJWEqydu5hJfuh0Gnykv6Vop9wqho8A7rCHhKVdw6rL7iAn8C7KZUP8x/vK6za+9xfHEHSBjkbhXwF6Ydw2FD9sQETn94rUL6hWK6I+/mwOm+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741042554; c=relaxed/simple;
	bh=nWg4aPvdjRglGMQ7OSxIETZysqSUUGnHgLgwaWzTHKk=;
	h=Date:To:From:Subject:Message-Id; b=hHSZDGwTLLtkR/T3nihx1B3wQlv5d919DNiTURx3KMN0iZR2PMdK2AoydNETYKEeQpT//dWBiISyYFkYkIDgI1JfaNhmcqkis+F+dEGzLiqYC6arvg5xx2gDSzScVBlKpUXOXk7cU47ZTPrj70Z1JvilYIodhfi/uPnZmfDLGZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gBfQreLI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gBfQreLI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 063CEC4CEE8;
	Mon,  3 Mar 2025 22:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741042554;
	bh=nWg4aPvdjRglGMQ7OSxIETZysqSUUGnHgLgwaWzTHKk=;
	h=Date:To:From:Subject:From;
	b=gBfQreLIdVyL3OGq453QyAQmLvfeKJeBDDZuW1xCI8DrfQ4nEeUPZgS6UKfCdCN7P
	 ybHIoe5nLhzSRUXW8iqET0/ekjP6SjkNEbSYB0D0EXW3TZKlUAw16JvFOvY5x+qezN
	 e3uyQYpLNt6LTqBSC7TUipjs/n+3kghz7r5lDoi0=
Date: Mon, 03 Mar 2025 14:55:53 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,tj@kernel.org,tglx@linutronix.de,muchun.song@linux.dev,mkoutny@suse.com,mingo@redhat.com,luto@kernel.org,lorenzo.stoakes@oracle.com,lizefan.x@bytedance.com,liam.howlett@oracle.com,kirill.shutemov@linux.intel.com,jannh@google.com,ioworker0@gmail.com,hannes@cmpxchg.org,dave.hansen@linux.intel.com,corbet@lwn.net,bp@alien8.de,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-pass-dst_vma-to-folio_dup_file_rmap_pte-and-friends.patch added to mm-unstable branch
Message-Id: <20250303225554.063CEC4CEE8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/rmap: pass dst_vma to folio_dup_file_rmap_pte() and friends
has been added to the -mm mm-unstable branch.  Its filename is
     mm-rmap-pass-dst_vma-to-folio_dup_file_rmap_pte-and-friends.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-pass-dst_vma-to-folio_dup_file_rmap_pte-and-friends.patch

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
Subject: mm/rmap: pass dst_vma to folio_dup_file_rmap_pte() and friends
Date: Mon, 3 Mar 2025 17:30:00 +0100

We'll need access to the destination MM when modifying the large mapcount
of a non-hugetlb large folios next.  So pass in the destination VMA.

Link: https://lkml.kernel.org/r/20250303163014.1128035-8-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Andy Lutomirks^H^Hski <luto@kernel.org>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
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

 include/linux/rmap.h |   42 ++++++++++++++++++++++++-----------------
 mm/huge_memory.c     |    2 -
 mm/memory.c          |   10 ++++-----
 3 files changed, 31 insertions(+), 23 deletions(-)

--- a/include/linux/rmap.h~mm-rmap-pass-dst_vma-to-folio_dup_file_rmap_pte-and-friends
+++ a/include/linux/rmap.h
@@ -335,7 +335,8 @@ static inline void hugetlb_remove_rmap(s
 }
 
 static __always_inline void __folio_dup_file_rmap(struct folio *folio,
-		struct page *page, int nr_pages, enum rmap_level level)
+		struct page *page, int nr_pages, struct vm_area_struct *dst_vma,
+		enum rmap_level level)
 {
 	const int orig_nr_pages = nr_pages;
 
@@ -366,45 +367,47 @@ static __always_inline void __folio_dup_
  * @folio:	The folio to duplicate the mappings of
  * @page:	The first page to duplicate the mappings of
  * @nr_pages:	The number of pages of which the mapping will be duplicated
+ * @dst_vma:	The destination vm area
  *
  * The page range of the folio is defined by [page, page + nr_pages)
  *
  * The caller needs to hold the page table lock.
  */
 static inline void folio_dup_file_rmap_ptes(struct folio *folio,
-		struct page *page, int nr_pages)
+		struct page *page, int nr_pages, struct vm_area_struct *dst_vma)
 {
-	__folio_dup_file_rmap(folio, page, nr_pages, RMAP_LEVEL_PTE);
+	__folio_dup_file_rmap(folio, page, nr_pages, dst_vma, RMAP_LEVEL_PTE);
 }
 
 static __always_inline void folio_dup_file_rmap_pte(struct folio *folio,
-		struct page *page)
+		struct page *page, struct vm_area_struct *dst_vma)
 {
-	__folio_dup_file_rmap(folio, page, 1, RMAP_LEVEL_PTE);
+	__folio_dup_file_rmap(folio, page, 1, dst_vma, RMAP_LEVEL_PTE);
 }
 
 /**
  * folio_dup_file_rmap_pmd - duplicate a PMD mapping of a page range of a folio
  * @folio:	The folio to duplicate the mapping of
  * @page:	The first page to duplicate the mapping of
+ * @dst_vma:	The destination vm area
  *
  * The page range of the folio is defined by [page, page + HPAGE_PMD_NR)
  *
  * The caller needs to hold the page table lock.
  */
 static inline void folio_dup_file_rmap_pmd(struct folio *folio,
-		struct page *page)
+		struct page *page, struct vm_area_struct *dst_vma)
 {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	__folio_dup_file_rmap(folio, page, HPAGE_PMD_NR, RMAP_LEVEL_PTE);
+	__folio_dup_file_rmap(folio, page, HPAGE_PMD_NR, dst_vma, RMAP_LEVEL_PTE);
 #else
 	WARN_ON_ONCE(true);
 #endif
 }
 
 static __always_inline int __folio_try_dup_anon_rmap(struct folio *folio,
-		struct page *page, int nr_pages, struct vm_area_struct *src_vma,
-		enum rmap_level level)
+		struct page *page, int nr_pages, struct vm_area_struct *dst_vma,
+		struct vm_area_struct *src_vma, enum rmap_level level)
 {
 	const int orig_nr_pages = nr_pages;
 	bool maybe_pinned;
@@ -470,6 +473,7 @@ static __always_inline int __folio_try_d
  * @folio:	The folio to duplicate the mappings of
  * @page:	The first page to duplicate the mappings of
  * @nr_pages:	The number of pages of which the mapping will be duplicated
+ * @dst_vma:	The destination vm area
  * @src_vma:	The vm area from which the mappings are duplicated
  *
  * The page range of the folio is defined by [page, page + nr_pages)
@@ -488,16 +492,18 @@ static __always_inline int __folio_try_d
  * Returns 0 if duplicating the mappings succeeded. Returns -EBUSY otherwise.
  */
 static inline int folio_try_dup_anon_rmap_ptes(struct folio *folio,
-		struct page *page, int nr_pages, struct vm_area_struct *src_vma)
+		struct page *page, int nr_pages, struct vm_area_struct *dst_vma,
+		struct vm_area_struct *src_vma)
 {
-	return __folio_try_dup_anon_rmap(folio, page, nr_pages, src_vma,
-					 RMAP_LEVEL_PTE);
+	return __folio_try_dup_anon_rmap(folio, page, nr_pages, dst_vma,
+					 src_vma, RMAP_LEVEL_PTE);
 }
 
 static __always_inline int folio_try_dup_anon_rmap_pte(struct folio *folio,
-		struct page *page, struct vm_area_struct *src_vma)
+		struct page *page, struct vm_area_struct *dst_vma,
+		struct vm_area_struct *src_vma)
 {
-	return __folio_try_dup_anon_rmap(folio, page, 1, src_vma,
+	return __folio_try_dup_anon_rmap(folio, page, 1, dst_vma, src_vma,
 					 RMAP_LEVEL_PTE);
 }
 
@@ -506,6 +512,7 @@ static __always_inline int folio_try_dup
  *				 of a folio
  * @folio:	The folio to duplicate the mapping of
  * @page:	The first page to duplicate the mapping of
+ * @dst_vma:	The destination vm area
  * @src_vma:	The vm area from which the mapping is duplicated
  *
  * The page range of the folio is defined by [page, page + HPAGE_PMD_NR)
@@ -524,11 +531,12 @@ static __always_inline int folio_try_dup
  * Returns 0 if duplicating the mapping succeeded. Returns -EBUSY otherwise.
  */
 static inline int folio_try_dup_anon_rmap_pmd(struct folio *folio,
-		struct page *page, struct vm_area_struct *src_vma)
+		struct page *page, struct vm_area_struct *dst_vma,
+		struct vm_area_struct *src_vma)
 {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	return __folio_try_dup_anon_rmap(folio, page, HPAGE_PMD_NR, src_vma,
-					 RMAP_LEVEL_PMD);
+	return __folio_try_dup_anon_rmap(folio, page, HPAGE_PMD_NR, dst_vma,
+					 src_vma, RMAP_LEVEL_PMD);
 #else
 	WARN_ON_ONCE(true);
 	return -EBUSY;
--- a/mm/huge_memory.c~mm-rmap-pass-dst_vma-to-folio_dup_file_rmap_pte-and-friends
+++ a/mm/huge_memory.c
@@ -1782,7 +1782,7 @@ int copy_huge_pmd(struct mm_struct *dst_
 	src_folio = page_folio(src_page);
 
 	folio_get(src_folio);
-	if (unlikely(folio_try_dup_anon_rmap_pmd(src_folio, src_page, src_vma))) {
+	if (unlikely(folio_try_dup_anon_rmap_pmd(src_folio, src_page, dst_vma, src_vma))) {
 		/* Page maybe pinned: split and retry the fault on PTEs. */
 		folio_put(src_folio);
 		pte_free(dst_mm, pgtable);
--- a/mm/memory.c~mm-rmap-pass-dst_vma-to-folio_dup_file_rmap_pte-and-friends
+++ a/mm/memory.c
@@ -866,7 +866,7 @@ copy_nonpresent_pte(struct mm_struct *ds
 		folio_get(folio);
 		rss[mm_counter(folio)]++;
 		/* Cannot fail as these pages cannot get pinned. */
-		folio_try_dup_anon_rmap_pte(folio, page, src_vma);
+		folio_try_dup_anon_rmap_pte(folio, page, dst_vma, src_vma);
 
 		/*
 		 * We do not preserve soft-dirty information, because so
@@ -1020,14 +1020,14 @@ copy_present_ptes(struct vm_area_struct
 		folio_ref_add(folio, nr);
 		if (folio_test_anon(folio)) {
 			if (unlikely(folio_try_dup_anon_rmap_ptes(folio, page,
-								  nr, src_vma))) {
+								  nr, dst_vma, src_vma))) {
 				folio_ref_sub(folio, nr);
 				return -EAGAIN;
 			}
 			rss[MM_ANONPAGES] += nr;
 			VM_WARN_ON_FOLIO(PageAnonExclusive(page), folio);
 		} else {
-			folio_dup_file_rmap_ptes(folio, page, nr);
+			folio_dup_file_rmap_ptes(folio, page, nr, dst_vma);
 			rss[mm_counter_file(folio)] += nr;
 		}
 		if (any_writable)
@@ -1045,7 +1045,7 @@ copy_present_ptes(struct vm_area_struct
 		 * guarantee the pinned page won't be randomly replaced in the
 		 * future.
 		 */
-		if (unlikely(folio_try_dup_anon_rmap_pte(folio, page, src_vma))) {
+		if (unlikely(folio_try_dup_anon_rmap_pte(folio, page, dst_vma, src_vma))) {
 			/* Page may be pinned, we have to copy. */
 			folio_put(folio);
 			err = copy_present_page(dst_vma, src_vma, dst_pte, src_pte,
@@ -1055,7 +1055,7 @@ copy_present_ptes(struct vm_area_struct
 		rss[MM_ANONPAGES]++;
 		VM_WARN_ON_FOLIO(PageAnonExclusive(page), folio);
 	} else {
-		folio_dup_file_rmap_pte(folio, page);
+		folio_dup_file_rmap_pte(folio, page, dst_vma);
 		rss[mm_counter_file(folio)]++;
 	}
 
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

