Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 493C62BAE2
	for <mm-commits@vger.kernel.org>; Wed, 17 Apr 2024 21:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713390004; cv=none; b=utTCnNS5cqtDhIMngZwIbcJSeLho7QnnfnQ6XGsNZdcFXf5CLn7Nts6or4KwHHhqCmXWnyuvw4qXzuzNy+rA61pJFsHod3dfJraV2hZ3SGtl0RXWcDObstxsb7xlpRXsorUL5Pn7e2M7F6yxGUa3k91Wq/EPdKpEMHY8mA1hU+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713390004; c=relaxed/simple;
	bh=FsSPPkWVmc5aUJArvs71oZJHh9h3lLS6M7prJxRPpAw=;
	h=Date:To:From:Subject:Message-Id; b=rX6aEEDjBfZUWVsuCL2Yyw8AX0+L/P0aDloyRUuIcZi0tdu9owDgBmi00pTzkVuiqYZ+yCFCfzrUwUsv5bBiXHJJveuac5w/cIDhzbhoH9pJiBbaiMOSNWIgs/DjiMpunZ/OQzVcDOPOnn3UzyDG/hZ/lG64f2SLmoyZfFYWvfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qL0rg/Vg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qL0rg/Vg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2142C3277B;
	Wed, 17 Apr 2024 21:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713390004;
	bh=FsSPPkWVmc5aUJArvs71oZJHh9h3lLS6M7prJxRPpAw=;
	h=Date:To:From:Subject:From;
	b=qL0rg/Vg76ummFdfY5z0nCwJX81jqbgcInxWXFK/dyTh7lS3iJl/dtqL7+e6AkdAz
	 uizvh2+CGT0OeW81+VbuCGRjS+Uh7B6tzw0MR43xOCfW9RkZEXQjbPqW2ybO9ibzrd
	 x5i6E99YS21B8rxrkrwoBTvDnTSPF2Ivm4vrZdgU=
Date: Wed, 17 Apr 2024 14:40:03 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,osalvador@suse.de,muchun.song@linux.dev,linmiaohe@huawei.com,david@redhat.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-always-initialise-folio-_deferred_list-fix.patch added to mm-unstable branch
Message-Id: <20240417214003.F2142C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fixup! mm: always initialise folio->_deferred_list
has been added to the -mm mm-unstable branch.  Its filename is
     mm-always-initialise-folio-_deferred_list-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-always-initialise-folio-_deferred_list-fix.patch

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
From: Peter Xu <peterx@redhat.com>
Subject: fixup! mm: always initialise folio->_deferred_list
Date: Wed, 17 Apr 2024 17:18:34 -0400

Current mm-unstable will hit this when running test_hugetlb_memcg.  This
fixes the crash for me.

Link: https://lkml.kernel.org/r/20240417211836.2742593-2-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/memcontrol.c~mm-always-initialise-folio-_deferred_list-fix
+++ a/mm/memcontrol.c
@@ -7401,6 +7401,7 @@ static void uncharge_folio(struct folio
 
 	VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
 	VM_BUG_ON_FOLIO(folio_order(folio) > 1 &&
+			!folio_test_hugetlb(folio) &&
 			!list_empty(&folio->_deferred_list), folio);
 
 	/*
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-hmm-process-pud-swap-entry-without-pud_huge.patch
mm-gup-cache-p4d-in-follow_p4d_mask.patch
mm-gup-check-p4d-presence-before-going-on.patch
mm-x86-change-pxd_huge-behavior-to-exclude-swap-entries.patch
mm-sparc-change-pxd_huge-behavior-to-exclude-swap-entries.patch
mm-arm-use-macros-to-define-pmd-pud-helpers.patch
mm-arm-redefine-pmd_huge-with-pmd_leaf.patch
mm-arm64-merge-pxd_huge-and-pxd_leaf-definitions.patch
mm-powerpc-redefine-pxd_huge-with-pxd_leaf.patch
mm-gup-merge-pxd-huge-mapping-checks.patch
mm-treewide-replace-pxd_huge-with-pxd_leaf.patch
mm-treewide-remove-pxd_huge.patch
mm-arm-remove-pmd_thp_or_huge.patch
mm-document-pxd_leaf-api.patch
mm-always-initialise-folio-_deferred_list-fix.patch
selftests-mm-run_vmtestssh-fix-hugetlb-mem-size-calculation.patch
selftests-mm-run_vmtestssh-fix-hugetlb-mem-size-calculation-fix.patch
mm-kconfig-config_pgtable_has_huge_leaves.patch
mm-hugetlb-declare-hugetlbfs_pagecache_present-non-static.patch
mm-make-hpage_pxd_-macros-even-if-thp.patch
mm-introduce-vma_pgtable_walk_beginend.patch
mm-arch-provide-pud_pfn-fallback.patch
mm-arch-provide-pud_pfn-fallback-fix.patch
mm-gup-drop-folio_fast_pin_allowed-in-hugepd-processing.patch
mm-gup-refactor-record_subpages-to-find-1st-small-page.patch
mm-gup-handle-hugetlb-for-no_page_table.patch
mm-gup-cache-pudp-in-follow_pud_mask.patch
mm-gup-handle-huge-pud-for-follow_pud_mask.patch
mm-gup-handle-huge-pmd-for-follow_pmd_mask.patch
mm-gup-handle-huge-pmd-for-follow_pmd_mask-fix.patch
mm-gup-handle-hugepd-for-follow_page.patch
mm-gup-handle-hugetlb-in-the-generic-follow_page_mask-code.patch
mm-allow-anon-exclusive-check-over-hugetlb-tail-pages.patch

