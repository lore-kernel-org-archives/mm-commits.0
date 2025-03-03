Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99E8123BF90
	for <mm-commits@vger.kernel.org>; Mon,  3 Mar 2025 22:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741042537; cv=none; b=s3XCmuuUk9UaAH3ie2sTv4kFrmhAE2RViTxJYwwIlXK31C0cHLH2irb1gTZc324Nj2BWNMxJa6ucup0YM8Xw0IaLu3acgAuxUAbNI5H253sCsKj9yFtTRKMofJ+Bq/mvidPwBheSVEurUDudFXH6nqHVMrCUkAsmphnDKEYyOd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741042537; c=relaxed/simple;
	bh=63TsZTSd/crK3QtRJl/eK+3TGJ5RyNi3hWdEpHwaAOg=;
	h=Date:To:From:Subject:Message-Id; b=UlHocDjpFD+hu5yhX5hezWzWm92vMGipYWGptsetN95ak1QCbJYEwALgwMH7DDnq3MIK/AAbj8LpnTOPX0i0g/CsnGzsUJ9GKc4x6aRd1V8C/sLltSTb8rdY+ZBAjsaMWKWtPfHYkG/v98gEQUEj49O1LA8z7d2FopeeBLgrdZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Kawzqc/0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Kawzqc/0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 061CEC4CEE9;
	Mon,  3 Mar 2025 22:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741042537;
	bh=63TsZTSd/crK3QtRJl/eK+3TGJ5RyNi3hWdEpHwaAOg=;
	h=Date:To:From:Subject:From;
	b=Kawzqc/0fKVRj9khWyMFt8JBfifBEQjvTigTH22emkCCm9e6e1yCOiQyFWRu68DRj
	 ArYf5kT3KufW15Y3f+VEZaoq/Km8U01vsHH5soqMxiumY6i6CQLaydi29OpJP+7mXR
	 A+dy0JfIzmSs2En95996bv8Zi4kSMFqBAvLt5PVI=
Date: Mon, 03 Mar 2025 14:55:36 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,tj@kernel.org,tglx@linutronix.de,muchun.song@linux.dev,mkoutny@suse.com,mingo@redhat.com,luto@kernel.org,lorenzo.stoakes@oracle.com,lizefan.x@bytedance.com,liam.howlett@oracle.com,kirill.shutemov@linux.intel.com,jannh@google.com,ioworker0@gmail.com,hannes@cmpxchg.org,dave.hansen@linux.intel.com,corbet@lwn.net,bp@alien8.de,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-factor-out-large-folio-handling-from-folio_nr_pages-into-folio_large_nr_pages.patch added to mm-unstable branch
Message-Id: <20250303225537.061CEC4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: factor out large folio handling from folio_nr_pages() into folio_large_nr_pages()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-factor-out-large-folio-handling-from-folio_nr_pages-into-folio_large_nr_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-factor-out-large-folio-handling-from-folio_nr_pages-into-folio_large_nr_pages.patch

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
Subject: mm: factor out large folio handling from folio_nr_pages() into folio_large_nr_pages()
Date: Mon, 3 Mar 2025 17:29:55 +0100

Let's factor it out into a simple helper function.  This helper will also
come in handy when working with code where we know that our folio is
large.

While at it, let's consistently return a "long" value from all these
similar functions.  Note that we cannot use "unsigned int" (even though
_folio_nr_pages is of that type), because it would break some callers that
do stuff like "-folio_nr_pages()".  Both "int" or "unsigned long" would
work as well.

Maybe in the future we'll have the nr_pages readily available for all
large folios, maybe even for small folios, or maybe for none.

Link: https://lkml.kernel.org/r/20250303163014.1128035-3-david@redhat.com
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

 include/linux/mm.h |   28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

--- a/include/linux/mm.h~mm-factor-out-large-folio-handling-from-folio_nr_pages-into-folio_large_nr_pages
+++ a/include/linux/mm.h
@@ -1199,6 +1199,18 @@ static inline unsigned int folio_large_o
 	return folio->_flags_1 & 0xff;
 }
 
+#ifdef CONFIG_64BIT
+static inline long folio_large_nr_pages(const struct folio *folio)
+{
+	return folio->_folio_nr_pages;
+}
+#else
+static inline long folio_large_nr_pages(const struct folio *folio)
+{
+	return 1L << folio_large_order(folio);
+}
+#endif
+
 /*
  * compound_order() can be called without holding a reference, which means
  * that niceties like page_folio() don't work.  These callers should be
@@ -2141,11 +2153,7 @@ static inline long folio_nr_pages(const
 {
 	if (!folio_test_large(folio))
 		return 1;
-#ifdef CONFIG_64BIT
-	return folio->_folio_nr_pages;
-#else
-	return 1L << folio_large_order(folio);
-#endif
+	return folio_large_nr_pages(folio);
 }
 
 /* Only hugetlbfs can allocate folios larger than MAX_ORDER */
@@ -2160,24 +2168,20 @@ static inline long folio_nr_pages(const
  * page.  compound_nr() can be called on a tail page, and is defined to
  * return 1 in that case.
  */
-static inline unsigned long compound_nr(struct page *page)
+static inline long compound_nr(struct page *page)
 {
 	struct folio *folio = (struct folio *)page;
 
 	if (!test_bit(PG_head, &folio->flags))
 		return 1;
-#ifdef CONFIG_64BIT
-	return folio->_folio_nr_pages;
-#else
-	return 1L << folio_large_order(folio);
-#endif
+	return folio_large_nr_pages(folio);
 }
 
 /**
  * thp_nr_pages - The number of regular pages in this huge page.
  * @page: The head page of a huge page.
  */
-static inline int thp_nr_pages(struct page *page)
+static inline long thp_nr_pages(struct page *page)
 {
 	return folio_nr_pages((struct folio *)page);
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

