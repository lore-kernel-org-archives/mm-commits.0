Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6647053B8
	for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2024 23:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711062367; cv=none; b=SAzHAQKBpbgzL3GftbVQqo1a6DjlxtJA8H48ntuPKSffg8vb3jqHSj3l1Dh15qIiIrNe+8WY3jDnY5rv5ITzT3ekh4ILpR1tM3+F/ZjpqtvWFvEfZh9JZNLVimZBWwO/EBrl0GJ5reWdx8aQul7xA61WsOL4dwEEcktXANNhH64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711062367; c=relaxed/simple;
	bh=EMTsDTNCccBiopKfbYj2m7MbCAq7YTBFTjGh8o+Hhfw=;
	h=Date:To:From:Subject:Message-Id; b=RI/8Sp+fqPKQ7mgMM+/iHJwn131K46LGYDTc1FAqA3/7Q5I0Fq2zECsV830TtXAXmuvw5pdLV4Lxq3VrI5KKbaOpu8/PJXo4Bf9/9z7D1sPg8De8KyFSAwhrhdGSBIvIi0NMg0aBfN4qGkH2u3AdH0L7FgQ7Lp0D+stGwKwbsNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UPTLzsMy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UPTLzsMy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7BC4C433F1;
	Thu, 21 Mar 2024 23:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711062367;
	bh=EMTsDTNCccBiopKfbYj2m7MbCAq7YTBFTjGh8o+Hhfw=;
	h=Date:To:From:Subject:From;
	b=UPTLzsMyisO765q16TlTKIeZtCA7DA3nmUlOOrGj7V+0r5mh5FnQLKv0YoPh2cEjh
	 rycWim5/uGK7UIws0tAU19qS8F9tS7IMpVMtjI4KCi9lNdh1jokYhUCijK3vmatGFD
	 1N3ElmRcFUMy8tQpCdNqkPtbaldC3MskMdbq29E0=
Date: Thu, 21 Mar 2024 16:06:06 -0700
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,npache@redhat.com,muchun.song@linux.dev,david@redhat.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-run_vmtestssh-fix-hugetlb-mem-size-calculation.patch added to mm-unstable branch
Message-Id: <20240321230606.E7BC4C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: run_vmtests.sh: fix hugetlb mem size calculation
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-run_vmtestssh-fix-hugetlb-mem-size-calculation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-run_vmtestssh-fix-hugetlb-mem-size-calculation.patch

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
Subject: selftests/mm: run_vmtests.sh: fix hugetlb mem size calculation
Date: Thu, 21 Mar 2024 17:50:47 -0400

The script calculates a mininum required size of hugetlb memories, but
it'll stop working with <1MB huge page sizes, reporting all zeros even if
huge pages are available.

In reality, the calculation doesn't really need to be as comlicated
either.  Make it simpler and work for KB-level hugepages too.

Link: https://lkml.kernel.org/r/20240321215047.678172-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/run_vmtests.sh |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-run_vmtestssh-fix-hugetlb-mem-size-calculation
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -152,9 +152,13 @@ done < /proc/meminfo
 # both of these requirements into account and attempt to increase
 # number of huge pages available.
 nr_cpus=$(nproc)
-hpgsize_MB=$((hpgsize_KB / 1024))
-half_ufd_size_MB=$((((nr_cpus * hpgsize_MB + 127) / 128) * 128))
-needmem_KB=$((half_ufd_size_MB * 2 * 1024))
+uffd_min_KB=$((hpgsize_KB * nr_cpus * 2))
+hugetlb_min_KB=$((256 * 1024))
+if [[ $uffd_min_KB -gt $hugetlb_min_KB ]]; then
+	needmem_KB=$uffd_min_KB
+else
+	needmem_KB=$hugetlb_min_KB
+fi
 
 # set proper nr_hugepages
 if [ -n "$freepgs" ] && [ -n "$hpgsize_KB" ]; then
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-memory-fix-missing-pte-marker-for-page-on-pte-zaps.patch
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
mm-kconfig-config_pgtable_has_huge_leaves.patch
mm-hugetlb-declare-hugetlbfs_pagecache_present-non-static.patch
mm-make-hpage_pxd_-macros-even-if-thp.patch
mm-introduce-vma_pgtable_walk_beginend.patch
mm-gup-drop-folio_fast_pin_allowed-in-hugepd-processing.patch
mm-gup-refactor-record_subpages-to-find-1st-small-page.patch
mm-gup-handle-hugetlb-for-no_page_table.patch
mm-gup-cache-pudp-in-follow_pud_mask.patch
mm-gup-handle-huge-pud-for-follow_pud_mask.patch
mm-gup-handle-huge-pmd-for-follow_pmd_mask.patch
mm-gup-handle-hugepd-for-follow_page.patch
mm-gup-handle-hugetlb-in-the-generic-follow_page_mask-code.patch
selftests-mm-run_vmtestssh-fix-hugetlb-mem-size-calculation.patch

