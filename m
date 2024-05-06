Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 886065250
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714956076; cv=none; b=DEk6Nf5h+nWaYcBaE+r4rBXyURFNIBFKCvlqNBbxhLJXAuh6k/+DA96m+LOuWw/a5Cqrbu4jLktS+kISnSnWB1WGb9jsCVGAXaMMF9lzsKJuoQUIALoyaNMSrlfj95DIJ+jijxDQX4WrDQPv3wj23ohPm9FAZmfdMcItfHY7Fnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714956076; c=relaxed/simple;
	bh=bkxRHeqeyxnMDq7RY/hoO9zensw4qqFqkNh1+Y/EmX8=;
	h=Date:To:From:Subject:Message-Id; b=dEHK25xvpnM5NxiRQkiOtmHvSUzFYs9nmuZ9SANzZ1ftytaqhA7t997VdH4H7VPrAHmznvJQm8Y/L4TEr2p3mD8LNojgwVFB8O9U3IglLT/NrpUq7gn1JInEkRIYYXl1Lj6Pm4bPru+nz2MEkP86yt7tBxXt0+vVWsSwdhk1C/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fQeb8BT7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fQeb8BT7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02C33C113CC;
	Mon,  6 May 2024 00:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714956076;
	bh=bkxRHeqeyxnMDq7RY/hoO9zensw4qqFqkNh1+Y/EmX8=;
	h=Date:To:From:Subject:From;
	b=fQeb8BT7U4H5jCkoELx1kL6LB2RgZxLkkvMoOVfxG3AWgIRCcJFIFngbKN9a9s+Kp
	 BudI5Gg3i6WE6LgEdmbfdvgnt9h9RhLD4Xp+C8ebJDOpsJjrMKODzhNqb3sL5UjXQZ
	 g+KyjzNBx1Mgg8cISdqTxS+jGXUkIe/b0NxLsJ7g=
Date: Sun, 05 May 2024 17:41:15 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ysato@users.sourceforge.jp,willy@infradead.org,shy828301@gmail.com,ryan.roberts@arm.com,richardycc@google.com,peterx@redhat.com,naoya.horiguchi@nec.com,muchun.song@linux.dev,linmiaohe@huawei.com,jcmvbkbc@gmail.com,hughd@google.com,glaubitz@physik.fu-berlin.de,fengwei.yin@intel.com,dalias@libc.org,corbet@lwn.net,chris@zankel.net,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-make-folio_mapcount-return-0-for-small-typed-folios-fix.patch removed from -mm tree
Message-Id: <20240506004116.02C33C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-make-folio_mapcount-return-0-for-small-typed-folios-fix
has been removed from the -mm tree.  Its filename was
     mm-make-folio_mapcount-return-0-for-small-typed-folios-fix.patch

This patch was dropped because it was folded into mm-make-folio_mapcount-return-0-for-small-typed-folios.patch

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm-make-folio_mapcount-return-0-for-small-typed-folios-fix
Date: Wed, 24 Apr 2024 10:56:17 +0200

Just like page_mapcount(), let's make folio_mapcount() slightly more
efficient.

Link: https://lkml.kernel.org/r/c30fcda1-ed87-46f5-8297-cdedbddac009@redhat.com
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

 include/linux/mm.h |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/include/linux/mm.h~mm-make-folio_mapcount-return-0-for-small-typed-folios-fix
+++ a/include/linux/mm.h
@@ -1271,8 +1271,11 @@ static inline int folio_mapcount(const s
 	int mapcount;
 
 	if (likely(!folio_test_large(folio))) {
-		mapcount = atomic_read(&folio->_mapcount);
-		return page_type_has_type(mapcount) ? 0 : mapcount + 1;
+		mapcount = atomic_read(&folio->_mapcount) + 1;
+		/* Handle page_has_type() pages */
+		if (mapcount < PAGE_MAPCOUNT_RESERVE + 1)
+			mapcount = 0;
+		return mapcount;
 	}
 	return folio_large_mapcount(folio);
 }
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

