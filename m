Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D092113B5A6
	for <mm-commits@vger.kernel.org>; Wed, 24 Apr 2024 21:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713993130; cv=none; b=gw5F+IXHVuANbo0/REy1jNekdMf0ECGbb85eKwau15SqwC54gPYAShGl53Hh0/jK9mNfRaTG8EZ/RcVeziFcyEenGKI3d5W7bjysMMAzR5MoLWxPoPXVSlZd1dZXxA/uZS1UM6/5oWpAgZrUMy8akXNLjq+73/S0+amSRSyM78A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713993130; c=relaxed/simple;
	bh=L8V+m7eYmXWGtU1CetTYf0Ed/cb+IECdJmXICkYJhaI=;
	h=Date:To:From:Subject:Message-Id; b=sUjMCwkQcKyttOMcqjVGDXGtKoi9lHSaMIhjWP1ewbJdjUvMraZSpb/4P+ZsfgMwnpj9p7CPX4RfVAXT5+CZLlYIx+khXT3QaATHGTPByazHasKY/+xy08dvAK33rHKkPhfoc/i7zPTI9IxtLvU93gn2gwcPk+XDPGOvd66PjTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=u41+6hyH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="u41+6hyH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 507B2C113CD;
	Wed, 24 Apr 2024 21:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713993130;
	bh=L8V+m7eYmXWGtU1CetTYf0Ed/cb+IECdJmXICkYJhaI=;
	h=Date:To:From:Subject:From;
	b=u41+6hyHf0ONv2dIBsOEXr1TOtGa7CcTkhq6Ac+7ZoUIgRFPffFaM0UvovraGhpoW
	 TgVyY5P3hmlNa0nWpSLyTYBQO6fXLdngml8isT3D8XrQ0R/AIf+m6v0RbB3DaHep7N
	 fuVUHPyH258940yiEaPwANFALCCsaV3klpTLUAs8=
Date: Wed, 24 Apr 2024 14:12:09 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ysato@users.sourceforge.jp,willy@infradead.org,shy828301@gmail.com,ryan.roberts@arm.com,richardycc@google.com,peterx@redhat.com,naoya.horiguchi@nec.com,muchun.song@linux.dev,linmiaohe@huawei.com,jcmvbkbc@gmail.com,hughd@google.com,glaubitz@physik.fu-berlin.de,fengwei.yin@intel.com,dalias@libc.org,corbet@lwn.net,chris@zankel.net,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-make-folio_mapcount-return-0-for-small-typed-folios-fix.patch added to mm-unstable branch
Message-Id: <20240424211210.507B2C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-make-folio_mapcount-return-0-for-small-typed-folios-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-make-folio_mapcount-return-0-for-small-typed-folios-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-make-folio_mapcount-return-0-for-small-typed-folios-fix.patch

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
@@ -1270,8 +1270,11 @@ static inline int folio_mapcount(const s
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
loongarch-tlb-fix-error-parameter-ptep-set-but-not-used-due-to-__tlb_remove_tlb_entry.patch

