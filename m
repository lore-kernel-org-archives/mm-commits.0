Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AD5E37714
	for <mm-commits@vger.kernel.org>; Wed, 17 Apr 2024 21:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713390104; cv=none; b=HWATUfO9nn7pcG7qsGVI+UwCp1ewlyTx5qHfyCSmlCeIDlizWPe53KXvk7cCSVbkH+fGJBSEF3LiNTUR5bHSHt1MnEmIgobGQBO3jLgzc0VDiWJfu+MnxS56CgdTwtD6o6WxeRFHaHndQdG0vfaIZW2baRewSWv2ewHsTjPCEkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713390104; c=relaxed/simple;
	bh=sz+LQ65RKYqbfuriHfa70bMK7r25YwfXc8fGzlukCeI=;
	h=Date:To:From:Subject:Message-Id; b=ulRC30bxdwTz3YAz54u7RNcc1Tpb5rQ36Sgcks9t+DFNVOOupbAImK8jyDtoyPbvucn7cUx3tz2cI15A3EOwEiPrE97WwH+EswxgmXNEYFGp/bY0RIWszMQMotmwhFwUFF83DTzofMsMgzRPx28Lo58HZ/fAewN6/AtYeHv4DaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JDRiA/A5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JDRiA/A5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FC0FC072AA;
	Wed, 17 Apr 2024 21:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713390104;
	bh=sz+LQ65RKYqbfuriHfa70bMK7r25YwfXc8fGzlukCeI=;
	h=Date:To:From:Subject:From;
	b=JDRiA/A5BJ6XiaBz9RPI8JYbFAmZwq7Izj1PJ8y8ghINPb6UOnkk19wvBUtn7txsQ
	 2il91oA/GDgMgT0bu6w2ZZ3xaTrzMs4q9COKzl70g1PJNkao6RFFs33kkeVoGGxnAh
	 8/K/laG+UzYZCGKRoOtuqYtRWYFqQ5owzsW/MG1E=
Date: Wed, 17 Apr 2024 14:41:43 -0700
To: mm-commits@vger.kernel.org,rientjes@google.com,muchun.song@linux.dev,david@redhat.com,almasrymina@google.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-assert-hugetlb_lock-in-__hugetlb_cgroup_commit_charge.patch added to mm-unstable branch
Message-Id: <20240417214144.3FC0FC072AA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: assert hugetlb_lock in __hugetlb_cgroup_commit_charge
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-assert-hugetlb_lock-in-__hugetlb_cgroup_commit_charge.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-assert-hugetlb_lock-in-__hugetlb_cgroup_commit_charge.patch

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
Subject: mm/hugetlb: assert hugetlb_lock in __hugetlb_cgroup_commit_charge
Date: Wed, 17 Apr 2024 17:18:36 -0400

This is similar to __hugetlb_cgroup_uncharge_folio() where it relies on
holding hugetlb_lock.  Add the similar assertion like the other one, since
it looks like such things may help some day.

Link: https://lkml.kernel.org/r/20240417211836.2742593-4-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_cgroup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb_cgroup.c~mm-hugetlb-assert-hugetlb_lock-in-__hugetlb_cgroup_commit_charge
+++ a/mm/hugetlb_cgroup.c
@@ -308,7 +308,7 @@ static void __hugetlb_cgroup_commit_char
 {
 	if (hugetlb_cgroup_disabled() || !h_cg)
 		return;
-
+	lockdep_assert_held(&hugetlb_lock);
 	__set_hugetlb_cgroup(folio, h_cg, rsvd);
 	if (!rsvd) {
 		unsigned long usage =
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-hugetlb-fix-missing-hugetlb_lock-for-resv-uncharge.patch
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
mm-hugetlb-assert-hugetlb_lock-in-__hugetlb_cgroup_commit_charge.patch

