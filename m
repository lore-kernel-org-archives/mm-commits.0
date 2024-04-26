Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 258E38473
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714101450; cv=none; b=gJLVQWnjOniiOOog66UX8EAQcrVOLqD8HIVCEVDkP3yNepOq+lVYHaELI3Dixab3OvQh+OSEcfpEFVHzda80Jl98iLwnzcEBi6DbXnp5V576f+zHaAczs9oy4uOVg3QhWikvPPFe9jAqFP+yQwT1Ye6d64TUNuPXez6y4NsaUd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714101450; c=relaxed/simple;
	bh=VPIftw3a6u/XsAOewH6G8Q6wRJr0DBlfbHjtOOTpPoc=;
	h=Date:To:From:Subject:Message-Id; b=OZJi0aOpJj3GiNqptTY6Hd1mNlcZhNS//2JmG9txEtdrd+sZCmzIkHiIjmcTOGyvdUnAqjU3lxS4EjCsh/vrfLDE2d+XhFdmHxccKfec1kHF75K7KFXplBZNqNSfWRmtbaYRJHJ1Rb4xhLn9BtmCJgK8DXGVIo2N9gifmqXueLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UJT1kE+Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UJT1kE+Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B5BFC113CD;
	Fri, 26 Apr 2024 03:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714101449;
	bh=VPIftw3a6u/XsAOewH6G8Q6wRJr0DBlfbHjtOOTpPoc=;
	h=Date:To:From:Subject:From;
	b=UJT1kE+YktWfi1V0r2LKY7ygrby8S3gnSmGBUckVZAJMtSLbP5lnREDORGUEb5ugW
	 kwtUAmHZ2nJnoITNuxjYVM6ClqfrpfObelqwgAeJ32A4GyUzHAFIwIAXVZLKQSO6jo
	 1/7My2+Q65bxRb8elMOpfqptOcXgMsLDeCqhOZyg=
Date: Thu, 25 Apr 2024 20:17:29 -0700
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,ryan.roberts@arm.com,muchun.song@linux.dev,david@redhat.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] selftests-mm-run_vmtestssh-fix-hugetlb-mem-size-calculation-fix.patch removed from -mm tree
Message-Id: <20240426031729.8B5BFC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fixup! selftests/mm: run_vmtests.sh: fix hugetlb mem size calculation
has been removed from the -mm tree.  Its filename was
     selftests-mm-run_vmtestssh-fix-hugetlb-mem-size-calculation-fix.patch

This patch was dropped because it was folded into selftests-mm-run_vmtestssh-fix-hugetlb-mem-size-calculation.patch

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: fixup! selftests/mm: run_vmtests.sh: fix hugetlb mem size calculation
Date: Wed, 3 Apr 2024 16:03:24 -0400

Fix up a breakage on uffd hugetlb test due to removal of a temp variable,
as reported by Ryan [1].

Instead of using the previous calculation, use the largest we can
have (which is put in freepgs) and cut it into half for userfault tests.

[1] https://lore.kernel.org/r/1c20b717-c5b5-4bdf-8fcd-d46db135b7fa@arm.com

Link: https://lkml.kernel.org/r/20240403200324.1603493-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reported-by: Ryan Roberts <ryan.roberts@arm.com>
Tested-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/run_vmtests.sh |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-run_vmtestssh-fix-hugetlb-mem-size-calculation-fix
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -298,7 +298,8 @@ CATEGORY="userfaultfd" run_test ./uffd-u
 uffd_stress_bin=./uffd-stress
 CATEGORY="userfaultfd" run_test ${uffd_stress_bin} anon 20 16
 # Hugetlb tests require source and destination huge pages. Pass in half
-# the size ($half_ufd_size_MB), which is used for *each*.
+# the size of the free pages we have, which is used for *each*.
+half_ufd_size_MB=$((freepgs / 2))
 CATEGORY="userfaultfd" run_test ${uffd_stress_bin} hugetlb "$half_ufd_size_MB" 32
 CATEGORY="userfaultfd" run_test ${uffd_stress_bin} hugetlb-private "$half_ufd_size_MB" 32
 CATEGORY="userfaultfd" run_test ${uffd_stress_bin} shmem 20 16
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
selftests-mm-run_vmtestssh-fix-hugetlb-mem-size-calculation.patch
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

