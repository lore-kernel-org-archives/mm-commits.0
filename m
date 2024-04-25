Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67F7612E61;
	Thu, 25 Apr 2024 02:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714012517; cv=none; b=ELeYja86c/22wi6sy47+SjDL7H8k+GvuQIkfDQ8c/gVwyYIM9IVcU58xNshfjg3PqM1t0qKH1ZGYUqD9we8DkcFDCZebqEjygm64+KhnuGeWL0fjKsIJLKNKQp+zg4oyB9V88p5+9Yqt5RiDhWKrFHX2uFOSiZMOyKgJS9OTBBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714012517; c=relaxed/simple;
	bh=ze1PyyLmIavS7HF4Bt64TkK6Fwjh2lnKD9UOEPBZ7Jw=;
	h=Date:To:From:Subject:Message-Id; b=FQtY7CyPaGWDU9Q5Y3vxeWTsCezYjBNF2kmvsrIlZEzuynzts19tfyEkel0YqTiGMr7u4Qn52hdNS0gtL53j8mXGOkJdmeDyB9DVqleyacMoClxcQC3fymfNSzgqyhdHcUsLc7ePVWDk/Gipsrz9uXUMqtLB6YdxF/UuLi8n6Rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oFXVw80W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oFXVw80W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1BE0C113CD;
	Thu, 25 Apr 2024 02:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714012517;
	bh=ze1PyyLmIavS7HF4Bt64TkK6Fwjh2lnKD9UOEPBZ7Jw=;
	h=Date:To:From:Subject:From;
	b=oFXVw80Wv5PhRhZM6svbutnNbywo0mzCj9KFvPB3nXd67PNCQvc2AfA8MuxzTER4I
	 iOUatpY6vegiMKUOd9yWodT6hSQS26Q1beJ904vwcsKJxyW/E4vpg7EqXBzHdTMbt+
	 lS4c5JUrLI7i0Yb2gDRD4DSZC3IzoLUxvxuZ/WlQ=
Date: Wed, 24 Apr 2024 19:35:16 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,david@redhat.com,almasrymina@google.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-hugetlb-fix-missing-hugetlb_lock-for-resv-uncharge.patch removed from -mm tree
Message-Id: <20240425023516.F1BE0C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: fix missing hugetlb_lock for resv uncharge
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-missing-hugetlb_lock-for-resv-uncharge.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/hugetlb: fix missing hugetlb_lock for resv uncharge
Date: Wed, 17 Apr 2024 17:18:35 -0400

There is a recent report on UFFDIO_COPY over hugetlb:

https://lore.kernel.org/all/000000000000ee06de0616177560@google.com/

350:	lockdep_assert_held(&hugetlb_lock);

Should be an issue in hugetlb but triggered in an userfault context, where
it goes into the unlikely path where two threads modifying the resv map
together.  Mike has a fix in that path for resv uncharge but it looks like
the locking criteria was overlooked: hugetlb_cgroup_uncharge_folio_rsvd()
will update the cgroup pointer, so it requires to be called with the lock
held.

Link: https://lkml.kernel.org/r/20240417211836.2742593-3-peterx@redhat.com
Fixes: 79aa925bf239 ("hugetlb_cgroup: fix reservation accounting")
Signed-off-by: Peter Xu <peterx@redhat.com>
Reported-by: syzbot+4b8077a5fccc61c385a1@syzkaller.appspotmail.com
Reviewed-by: Mina Almasry <almasrymina@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-missing-hugetlb_lock-for-resv-uncharge
+++ a/mm/hugetlb.c
@@ -3268,9 +3268,12 @@ struct folio *alloc_hugetlb_folio(struct
 
 		rsv_adjust = hugepage_subpool_put_pages(spool, 1);
 		hugetlb_acct_memory(h, -rsv_adjust);
-		if (deferred_reserve)
+		if (deferred_reserve) {
+			spin_lock_irq(&hugetlb_lock);
 			hugetlb_cgroup_uncharge_folio_rsvd(hstate_index(h),
 					pages_per_huge_page(h), folio);
+			spin_unlock_irq(&hugetlb_lock);
+		}
 	}
 
 	if (!memcg_charge_ret)
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
mm-free-non-hugetlb-large-folios-in-a-batch-fix.patch
mm-hugetlb-assert-hugetlb_lock-in-__hugetlb_cgroup_commit_charge.patch
mm-page_table_check-support-userfault-wr-protect-entries.patch

