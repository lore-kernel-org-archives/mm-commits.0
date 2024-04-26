Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28F902F36
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714101340; cv=none; b=aBiVClNNXaSuV5G8O7fpVanokE9K0J+7hlgfSQkhbtPOyb3/ixCLD07tYJTng0TUmfNuAx34opTfZ0rYlELy2m4N4J+1Jy7lduI5wKm+hXxBaNXHKJMVGytH9/QKtfzJNasVoZ8wsaPdBw7lRFftciydFEYxTWi6LTPjNOIs8rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714101340; c=relaxed/simple;
	bh=QGLChc9OH8AoKZUQmjAmzlMVNb7FI86CoqZlPdWjLxg=;
	h=Date:To:From:Subject:Message-Id; b=ji7doMq0FsRElnjZKSHQZA9pza1JOui01P6ImZm90e1P6SHN2JsLj+tfvsium+QBRwmT6pPdJQLJVvVD3KLfcQL4Q/ny53ZwCL17NDd4o6QyTqRmC0VlNfyZBZq18cE+1Ruhf0Pfx6w6Iz587mvbK3JNmogGHgdHtZyiFqOFYu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jhmUnitC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jhmUnitC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A453BC113CD;
	Fri, 26 Apr 2024 03:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714101339;
	bh=QGLChc9OH8AoKZUQmjAmzlMVNb7FI86CoqZlPdWjLxg=;
	h=Date:To:From:Subject:From;
	b=jhmUnitCXd3FUTQy7ndBcCj0xk42GkTljeEGof+g4rgS9AsIzvdMU5w9Myy8kuZxz
	 PPDnqF2S0oIwIuSvyDyEZ0hxzcRqCcmzty3T8+fvijGOkGn2OtDv0JQrow14Hqavnx
	 G+xZp1Ce6T+QtPHxCLyn7coabZukdk3YCEgCsHvs=
Date: Thu, 25 Apr 2024 20:15:39 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,osalvador@suse.de,muchun.song@linux.dev,linmiaohe@huawei.com,david@redhat.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-always-initialise-folio-_deferred_list-fix.patch removed from -mm tree
Message-Id: <20240426031539.A453BC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fixup! mm: always initialise folio->_deferred_list
has been removed from the -mm tree.  Its filename was
     mm-always-initialise-folio-_deferred_list-fix.patch

This patch was dropped because it was folded into mm-always-initialise-folio-_deferred_list.patch

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

mm-userfaultfd-reset-ptes-when-close-for-wr-protected-ones.patch
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
mm-always-initialise-folio-_deferred_list.patch
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
mm-free-non-hugetlb-large-folios-in-a-batch-fix.patch
mm-hugetlb-assert-hugetlb_lock-in-__hugetlb_cgroup_commit_charge.patch
mm-page_table_check-support-userfault-wr-protect-entries.patch

