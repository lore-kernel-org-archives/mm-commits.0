Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 228FC233942
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622828; cv=none; b=s0trHJJoo5R3E+NNNdoYFNBpKJuie1XgXks65NXgq7hGxLYUfkz0kGqGEX9dmEhhXRy53ZhK3l0cFR76/nX9sU7kX8ANRa0dBXue1nR6d0pmxqNS88fRbMlfAB/wJdZVt80OEeqAZQp2X0YUpbMLpkhFQeRgx4YwBy1+LhYEOaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622828; c=relaxed/simple;
	bh=kuuIcCeATHpIIzHKKTCscz9uFfQvlsOUA6lVo8Ky2CU=;
	h=Date:To:From:Subject:Message-Id; b=SW8GXvVnFZACKCsIv4dGFxS4nM2tWoCBw5dttIVpc7k8hIXwacyWGKDGU6JJdE79FIDgpCUAYd3m2cwBg64fsOin2DLQOyMNdqfuXVdxwzutXaxdAlhEoU50hs7rkLiv0b2EvREjwFSZvCgr8hz4GQbVckoF3AhQed6yXoX2oMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ndvAS+BC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ndvAS+BC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAD5F1F000E9;
	Tue, 25 Aug 2026 01:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622827;
	bh=GE2gkxnyLb6d904ZZXqsNLTE8XUNxS0dyCGXsxapRLE=;
	h=Date:To:From:Subject;
	b=ndvAS+BCFTC+okPwBOa4k85NQ66S2EEmeDo+6mVWKwU1unayqXL3A9VWzYUrBCd61
	 RXAVt2wANhuB4VPgNcmFHX5wK6WWqLEsCVfFhy914pVaBDj1kEZqHUgAsHunUFOc3k
	 Ct2QmV6S9nmQE/qi9MmUxvmfPekovGmTJevKxW/w=
Date: Mon, 24 Aug 2026 18:53:46 -0700
To: mm-commits@vger.kernel.org,yosry@kernel.org,vbabka@kernel.org,surenb@google.com,sj@kernel.org,shuah@kernel.org,rppt@kernel.org,peterx@redhat.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,jhubbard@nvidia.com,jgg@ziepe.ca,david@kernel.org,pratmal@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-use-pattern-matching-in-gitignore.patch removed from -mm tree
Message-Id: <20260825015346.EAD5F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: use pattern matching in .gitignore
has been removed from the -mm tree.  Its filename was
     selftests-mm-use-pattern-matching-in-gitignore.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pratyush Mallick <pratmal@google.com>
Subject: selftests/mm: use pattern matching in .gitignore
Date: Mon, 3 Aug 2026 22:17:32 +0000

The current .gitignore hardcodes each generated test binary by name,
requiring updates every time a new test is added.

Switch to the pattern-matching approach similar to KVM:selftests.  Ignore
everything by default and then allow source extensions (.c, .h, .sh) and
tracked non-source files.

Note that local_config.h was renamed to local_config.h_gen in a previous
patch so that un-ignoring *.h files does not cause generated build
artifacts to become untracked.

[akpm@linux-foundation.org: fix botched merge resolution]
Link: https://lore.kernel.org/20260803221732.3651981-3-pratmal@google.com
Signed-off-by: Pratyush Mallick <pratmal@google.com>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Suggested-by: Yosry Ahmed <yosry@kernel.org>
Reviewed-by: SJ Park <sj@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: "Liam R. Howlett" <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/.gitignore |   76 ++----------------------
 1 file changed, 9 insertions(+), 67 deletions(-)

--- a/tools/testing/selftests/mm/.gitignore~selftests-mm-use-pattern-matching-in-gitignore
+++ a/tools/testing/selftests/mm/.gitignore
@@ -1,68 +1,10 @@
 # SPDX-License-Identifier: GPL-2.0-only
-cow
-hugepage-mmap
-hugepage-mremap
-hugepage-shm
-hugepage-vmemmap
-hugetlb-mmap
-hugetlb-mremap
-hugetlb-shm
-hugetlb-vmemmap
-hugetlb-madvise
-hugetlb-read-hwpoison
-hugetlb-soft-offline
-khugepaged
-map_hugetlb
-map_populate
-thuge-gen
-compaction_test
-memory-failure
-migration
-mlock2-tests
-mrelease_test
-mremap_dontunmap
-mremap_test
-on-fault-limit
-transhuge-stress
-pagemap_ioctl
-pfnmap
-process_madv
-*.tmp*
-protection_keys
-protection_keys_32
-protection_keys_64
-madv_populate
-uffd-stress
-uffd-unit-tests
-uffd-wp-mremap
-mlock-intersect-test
-mlock-random-test
-virtual_address_range
-gup_test
-va_128TBswitch
-map_fixed_noreplace
-write_to_hugetlbfs
-hmm-tests
-memfd_secret
-soft-dirty
-split_huge_page_test
-ksm_tests
-local_config.h
-local_config.mk
-ksm_functional_tests
-mdwe_test
-gup_longterm
-mkdirty
-va_high_addr_switch
-hugetlb_fault_after_madv
-hugetlb_madv_vs_map
-mseal_test
-droppable
-hugetlb_dio
-pkey_sighandler_tests_32
-pkey_sighandler_tests_64
-guard-regions
-merge
-prctl_thp_disable
-rmap
-folio_split_race_test
+*
+!/**/
+!*.c
+!*.h
+!*.sh
+!.gitignore
+!Makefile
+!config
+!settings
_

Patches currently in -mm which might be from pratmal@google.com are


