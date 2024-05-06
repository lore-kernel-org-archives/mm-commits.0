Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5714FA94A
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714956038; cv=none; b=Z3PFisC+yPYD8IOAn6E5vXh17mIY/hN2P8s3aw9yAPTTvVTTw6Gc7pQZLaevpNMehaFsdC7SbHlhc68zkCU5sS9wUMXI+HlESJr8lmm8AjMxV9JKuwBwPvV1if4f4iYIPhr79qYHxiVs6hn+3F0Y40JWVU651m+fiF87g1wceu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714956038; c=relaxed/simple;
	bh=ifwVHEXfDpAsieOoALKMoOM90OVZ9VAHRZrdRdMXOxg=;
	h=Date:To:From:Subject:Message-Id; b=ZTtuO3xRMAlYsBAlAgrttagmB47+mEmsEU31HktLKd9ZKXG9EtIonrvu0kzDTiUCwx66ndGCaMLc92AqbwmiJfF29PRY0Ixk1WkaHptRrK5Y5/MpVim/t26aSjtRWoZNw64TtG3x4wXrXOgwL/m8W7Y4Te9IaqH/Ycx82D8//x0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bmpql4VV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bmpql4VV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD921C113CC;
	Mon,  6 May 2024 00:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714956037;
	bh=ifwVHEXfDpAsieOoALKMoOM90OVZ9VAHRZrdRdMXOxg=;
	h=Date:To:From:Subject:From;
	b=bmpql4VVhLGcDX49z7HlzdvUBAbeI3C5rzZ+4WYChTehySQO65oyS/g1OPxbsS+FV
	 alUaKeEZBeD/6WD3Je6647lL84ullSliq1e1Oxabe8+YHyHB9TpAdVhFSAclNJUCqX
	 GksiwPZTxipmTbdTtiVSGBgGNwr+nw6fhXRJc36A=
Date: Sun, 05 May 2024 17:40:37 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ysato@users.sourceforge.jp,willy@infradead.org,shy828301@gmail.com,ryan.roberts@arm.com,richardycc@google.com,peterx@redhat.com,naoya.horiguchi@nec.com,muchun.song@linux.dev,linmiaohe@huawei.com,jcmvbkbc@gmail.com,hughd@google.com,glaubitz@physik.fu-berlin.de,fengwei.yin@intel.com,dalias@libc.org,corbet@lwn.net,chris@zankel.net,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-allow-for-detecting-underflows-with-page_mapcount-again-fix.patch removed from -mm tree
Message-Id: <20240506004037.DD921C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-allow-for-detecting-underflows-with-page_mapcount-again-fix
has been removed from the -mm tree.  Its filename was
     mm-allow-for-detecting-underflows-with-page_mapcount-again-fix.patch

This patch was dropped because it was folded into mm-allow-for-detecting-underflows-with-page_mapcount-again.patch

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm-allow-for-detecting-underflows-with-page_mapcount-again-fix
Date: Wed, 24 Apr 2024 10:50:09 +0200

Let's make page_mapcount() slighly more efficient by inlining the
page_type_has_type() check.

Link: https://lkml.kernel.org/r/1af4fd61-7926-47c8-be45-833c0dbec08b@redhat.com
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

 include/linux/mm.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/include/linux/mm.h~mm-allow-for-detecting-underflows-with-page_mapcount-again-fix
+++ a/include/linux/mm.h
@@ -1229,10 +1229,11 @@ static inline void page_mapcount_reset(s
  */
 static inline int page_mapcount(struct page *page)
 {
-	int mapcount = atomic_read(&page->_mapcount);
+	int mapcount = atomic_read(&page->_mapcount) + 1;
 
 	/* Handle page_has_type() pages */
-	mapcount = page_type_has_type(mapcount) ? 0 : mapcount + 1;
+	if (mapcount < PAGE_MAPCOUNT_RESERVE + 1)
+		mapcount = 0;
 	if (unlikely(PageCompound(page)))
 		mapcount += folio_entire_mapcount(page_folio(page));
 
_

Patches currently in -mm which might be from david@redhat.com are

drivers-virt-acrn-fix-pfnmap-pte-checks-in-acrn_vm_ram_map.patch
mm-pass-vma-instead-of-mm-to-follow_pte.patch
mm-follow_pte-improvements.patch
mm-allow-for-detecting-underflows-with-page_mapcount-again.patch
mm-rmap-always-inline-anon-file-rmap-duplication-of-a-single-pte.patch
mm-rmap-add-fast-path-for-small-folios-when-adding-removing-duplicating.patch
mm-track-mapcount-of-large-folios-in-single-value.patch
mm-improve-folio_likely_mapped_shared-using-the-mapcount-of-large-folios.patch
mm-make-folio_mapcount-return-0-for-small-typed-folios.patch
mm-make-folio_mapcount-return-0-for-small-typed-folios-fix.patch
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
fs-proc-task_mmu-convert-pagemap_hugetlb_range-to-work-on-folios.patch
fs-proc-task_mmu-convert-smaps_hugetlb_range-to-work-on-folios.patch
mm-huge_memory-improve-split_huge_page_to_list_to_order-return-value-documentation.patch
mm-huge_memory-improve-split_huge_page_to_list_to_order-return-value-documentation-v2.patch
mm-khugepaged-replace-page_mapcount-check-by-folio_likely_mapped_shared.patch
selftests-mm-cow-flag-vmsplice-hugetlb-tests-as-xfail.patch
mm-hugetlb-document-why-hugetlb-uses-folio_mapcount-for-cow-reuse-decisions.patch
selftests-mm-gup_longterm-test-unsharing-logic-when-r-o-pinning.patch

