Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 145D1225D7
	for <mm-commits@vger.kernel.org>; Sun,  1 Sep 2024 23:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725234612; cv=none; b=hxqEjSjWHQGvSePAnw4WzBP1MIYfpI6Og8IFTQHKwcPUUkXYLWKoY4A+X9oh6p4NXi55chkWninLrJ45z9C7rdpno38n/fPaIMb/pryQiAH2dCQBfRk0x5HoceE4ZUAcz48QA2aUMbAdwP/yRyc0nRarO7GGZKJdx44pI9HnxcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725234612; c=relaxed/simple;
	bh=WBZsdRhMHryPUOsfr+hGo9V7gf5z2ePk0KcEotPdoLo=;
	h=Date:To:From:Subject:Message-Id; b=kR+OPsyAl6qQ2KLfuLjJ70nOFZ0mCRaCz10GX3utLEqBFg0strMJl+Ayls45U1P3IW6WUWrz55f1Su+0rZZtoS88drD13D99FM08h6+MUk3Rr2g0Hv9IxnvWqT+uQt5fS83CWh9fIemX4LKeLCv6Pgl4AqhsjTh/7stluQf+Qd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZS9CUKYl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZS9CUKYl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 784DCC4CEC3;
	Sun,  1 Sep 2024 23:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725234611;
	bh=WBZsdRhMHryPUOsfr+hGo9V7gf5z2ePk0KcEotPdoLo=;
	h=Date:To:From:Subject:From;
	b=ZS9CUKYlzufocERvnjJlR+LY8ThPEn0+zCKTakBywr1ECCfCT6vdXoYcqw/4JTgrm
	 nXQ6WItaj8EhkP/7hQlhesyGxz350yzIvWKIUSvMMx0/wT5pShZeDbYRn3zQGSdBHI
	 /Kqam0633TiNCUFjqhISFy/gV8up8q9vSKW+eMh8=
Date: Sun, 01 Sep 2024 16:50:10 -0700
To: mm-commits@vger.kernel.org,linmiaohe@huawei.com,david@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-add-unmap_poisoned_folio-fix.patch added to mm-unstable branch
Message-Id: <20240901235011.784DCC4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-memory-failure-add-unmap_poisoned_folio-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failure-add-unmap_poisoned_folio-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-add-unmap_poisoned_folio-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memory-failure-add-unmap_poisoned_folio-fix
Date: Sun Sep  1 04:48:53 PM PDT 2024

whitespace tweak, per Miaohe Lin

Link: https://lkml.kernel.org/r/1f80c7e3-c30d-1ac1-6a36-d1a5f5907f7c@huawei.com
Cc: David Hildenbrand <david@redhat.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/memory-failure.c~mm-memory-failure-add-unmap_poisoned_folio-fix
+++ a/mm/memory-failure.c
@@ -1558,6 +1558,7 @@ void unmap_poisoned_folio(struct folio *
 {
 	if (folio_test_hugetlb(folio) && !folio_test_anon(folio)) {
 		struct address_space *mapping;
+
 		/*
 		 * For hugetlb folios in shared mappings, try_to_unmap
 		 * could potentially call huge_pmd_unshare.  Because of
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

include-linux-mmzoneh-clean-up-watermark-accessors.patch
mm-remove-legacy-install_special_mapping-code-checkpatch-fixes.patch
mm-contig_alloc-support-__gfp_comp-fix.patch
selftests-mm-add-more-mseal-traversal-tests-fix.patch
selftests-mm-add-more-mseal-traversal-tests-fix-fix.patch
mm-remove-pageactive-fix.patch
selftests-test_zswap-add-test-for-hierarchical-zswapwriteback-fix.patch
mm-count-the-number-of-anonymous-thps-per-size-fix.patch
mm-memory-failure-add-unmap_poisoned_folio-fix.patch
mm-shmem-extend-shmem_unused_huge_shrink-to-all-sizes-fix.patch
mm-hugetlb-sort-out-global-lock-annotations-fix.patch
mm-hugetlb-sort-out-global-lock-annotations-fix-fix.patch
lib-maple_treec-remove-unused-functions.patch
fault-inject-improve-build-for-config_fault_injection=n-fix.patch
fault-inject-improve-build-for-config_fault_injection=n-fix-2.patch
fault-inject-improve-build-for-config_fault_injection=n-fix-3.patch

