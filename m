Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C94A9181D04
	for <mm-commits@vger.kernel.org>; Wed, 10 Apr 2024 21:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712782817; cv=none; b=Le2AselkDxkUDvEkZIT2+DgO+6UUvxTCM+uq0JgSfLKiRxKttYy4Gr3Vaalls9nx1/Qn8GBXaX8DSW1IF8A45advNfXJrmpvV2rPV5vNRDMTRUV4neqQjYjFLSNAlOPbEHi6kG+M2Et6GYrPWB2NbKO8OB7d7h+1DUfG4ed5apo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712782817; c=relaxed/simple;
	bh=WJeMltK+/5FgnlPoI9JATWWuuoCZnlFsEeYtVE7fVxA=;
	h=Date:To:From:Subject:Message-Id; b=hSLTdQ3QZsynSLKGSc+YQkbxv1SNGf7VFSMzHJ72Uy2wekaAg6PMdQMUIcHBUedFKsWH0dxCrswcLIufpvu14TQZ+Gb9OQjkLyrTinBWzyBSmHXdjN96RRMHFh7X0QUCawMrO13heSlTk7wHOk3hEHsR6f+AaYIuTJYLYiZO2Sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rw5qV8aw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rw5qV8aw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A650C433F1;
	Wed, 10 Apr 2024 21:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712782817;
	bh=WJeMltK+/5FgnlPoI9JATWWuuoCZnlFsEeYtVE7fVxA=;
	h=Date:To:From:Subject:From;
	b=rw5qV8awm8lM15DD1JmE+KPRkG+jMzwaRK9NzdIG/yjU20tYPIQUaj2T/lv+MVrpO
	 1nfas8VrfofhV+UCxhjvk03U7o5obU97sxod6jdXB/N+jRj9CwYYtzqym0EgE//cg3
	 HxdXbroLrfMeRX+K+uAL1GL9ABglR0OkEB8iRNjU=
Date: Wed, 10 Apr 2024 14:00:17 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ysato@users.sourceforge.jp,willy@infradead.org,shy828301@gmail.com,ryan.roberts@arm.com,richardycc@google.com,peterx@redhat.com,naoya.horiguchi@nec.com,muchun.song@linux.dev,linmiaohe@huawei.com,jcmvbkbc@gmail.com,hughd@google.com,glaubitz@physik.fu-berlin.de,fengwei.yin@intel.com,dalias@libc.org,corbet@lwn.net,chris@zankel.net,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-improve-folio_likely_mapped_shared-using-the-mapcount-of-large-folios.patch added to mm-unstable branch
Message-Id: <20240410210017.9A650C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: improve folio_likely_mapped_shared() using the mapcount of large folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-improve-folio_likely_mapped_shared-using-the-mapcount-of-large-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-improve-folio_likely_mapped_shared-using-the-mapcount-of-large-folios.patch

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
Subject: mm: improve folio_likely_mapped_shared() using the mapcount of large folios
Date: Tue, 9 Apr 2024 21:22:48 +0200

We can now read the mapcount of large folios very efficiently.  Use it to
improve our handling of partially-mappable folios, falling back to making
a guess only in case the folio is not "obviously mapped shared".

We can now better detect partially-mappable folios where the first page is
not mapped as "mapped shared", reducing "false negatives"; but false
negatives are still possible.

While at it, fixup a wrong comment (false positive vs.  false negative)
for KSM folios.

Link: https://lkml.kernel.org/r/20240409192301.907377-6-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Hugh Dickins <hughd@google.com>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Richard Chang <richardycc@google.com>
Cc: Rich Felker <dalias@libc.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

--- a/include/linux/mm.h~mm-improve-folio_likely_mapped_shared-using-the-mapcount-of-large-folios
+++ a/include/linux/mm.h
@@ -2183,7 +2183,7 @@ static inline size_t folio_size(struct f
  *       indicate "mapped shared" (false positive) when two VMAs in the same MM
  *       cover the same file range.
  *    #. For (small) KSM folios, the return value can wrongly indicate "mapped
- *       shared" (false negative), when the folio is mapped multiple times into
+ *       shared" (false positive), when the folio is mapped multiple times into
  *       the same MM.
  *
  * Further, this function only considers current page table mappings that
@@ -2200,7 +2200,22 @@ static inline size_t folio_size(struct f
  */
 static inline bool folio_likely_mapped_shared(struct folio *folio)
 {
-	return page_mapcount(folio_page(folio, 0)) > 1;
+	int mapcount = folio_mapcount(folio);
+
+	/* Only partially-mappable folios require more care. */
+	if (!folio_test_large(folio) || unlikely(folio_test_hugetlb(folio)))
+		return mapcount > 1;
+
+	/* A single mapping implies "mapped exclusively". */
+	if (mapcount <= 1)
+		return false;
+
+	/* If any page is mapped more than once we treat it "mapped shared". */
+	if (folio_entire_mapcount(folio) || mapcount > folio_nr_pages(folio))
+		return true;
+
+	/* Let's guess based on the first subpage. */
+	return atomic_read(&folio->_mapcount) > 0;
 }
 
 #ifndef HAVE_ARCH_MAKE_PAGE_ACCESSIBLE
_

Patches currently in -mm which might be from david@redhat.com are

mm-madvise-make-madv_populate_readwrite-handle-vm_fault_retry-properly.patch
mm-madvise-dont-perform-madvise-vma-walk-for-madv_populate_readwrite.patch
mm-userfaultfd-dont-place-zeropages-when-zeropages-are-disallowed.patch
s390-mm-re-enable-the-shared-zeropage-for-pv-and-skeys-kvm-guests.patch
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

