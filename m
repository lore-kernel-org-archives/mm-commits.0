Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D8C2586C3
	for <mm-commits@vger.kernel.org>; Wed,  5 Mar 2025 22:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741213311; cv=none; b=E7icBCxskHOxru01OKFcvErj4R8bH3NYsu6MGoB6m0fhc++9cIIIsiyE1aLF7rE58P/RKuN24MpbWlW3ES0JKgM5xopkpSB3wEHhQKNRWRjyUmm8g/Z/zun85l44rJwracWVvLY/U2JEu0c1WSYgvzJttvYNaf0wuhq8ew6lJys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741213311; c=relaxed/simple;
	bh=8szMDMyQHKAMWBYYr8Ku3/3rEitgs0m4jaCmfsR6WwE=;
	h=Date:To:From:Subject:Message-Id; b=D2h+sEx1rzNbCpMhQ4WclI0Q2WCZwdXPEjtK2wByunNF61PbKUSg/WeB7v+T32Kanv0eSnE8LUG1gcKg+tSfZ/b+vu5F/munZ2PnK3bee3oUKBkPQR01rC1xzKse8ZlB+ISMSONS8jmfy2GWCSQhlKvlbZdF1giSrXA8zziq76k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CtBXSQsG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CtBXSQsG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED66BC4CED1;
	Wed,  5 Mar 2025 22:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741213311;
	bh=8szMDMyQHKAMWBYYr8Ku3/3rEitgs0m4jaCmfsR6WwE=;
	h=Date:To:From:Subject:From;
	b=CtBXSQsGomR6YKPhWrc3m9A8Txj5XVsSGDDQVkbescnPnrY/2S2pm4sQBi4yyMZSi
	 uPN/xnQppl3r17xHEJJCSJzwqK6E38oEakhAFJVauIYh1Ude5jYzRzVZVKyQoJeDlY
	 eUBDAyRSLb8pvMVhyIt+ymsM5DNRU41G5Ea16lbs=
Date: Wed, 05 Mar 2025 14:21:50 -0800
To: mm-commits@vger.kernel.org,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-let-_folio_nr_pages-overlay-memcg_data-in-first-tail-page-fix.patch added to mm-unstable branch
Message-Id: <20250305222150.ED66BC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fixup: mm: let _folio_nr_pages overlay memcg_data in first tail page
has been added to the -mm mm-unstable branch.  Its filename is
     mm-let-_folio_nr_pages-overlay-memcg_data-in-first-tail-page-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-let-_folio_nr_pages-overlay-memcg_data-in-first-tail-page-fix.patch

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
Subject: fixup: mm: let _folio_nr_pages overlay memcg_data in first tail page
Date: Wed, 5 Mar 2025 11:14:52 +0100

Make "make htmldoc" happy by marking non-private placeholder entries
private.

Link: https://lkml.kernel.org/r/a97f8a91-ec41-4796-81e3-7c9e0e491ba4@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/include/linux/mm_types.h~mm-let-_folio_nr_pages-overlay-memcg_data-in-first-tail-page-fix
+++ a/include/linux/mm_types.h
@@ -381,18 +381,20 @@ struct folio {
 		struct {
 			unsigned long _flags_1;
 			unsigned long _head_1;
-	/* public: */
 			union {
 				struct {
+	/* public: */
 					atomic_t _large_mapcount;
 					atomic_t _entire_mapcount;
 					atomic_t _nr_pages_mapped;
 					atomic_t _pincount;
+	/* private: the union with struct page is transitional */
 				};
 				unsigned long _usable_1[4];
 			};
 			atomic_t _mapcount_1;
 			atomic_t _refcount_1;
+	/* public: */
 #ifdef NR_PAGES_IN_LARGE_FOLIO
 			unsigned int _nr_pages;
 #endif /* NR_PAGES_IN_LARGE_FOLIO */
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
mm-let-_folio_nr_pages-overlay-memcg_data-in-first-tail-page-fix.patch
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

