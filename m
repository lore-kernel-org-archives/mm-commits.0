Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5312368D7B
	for <mm-commits@vger.kernel.org>; Mon,  3 Aug 2026 23:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785798499; cv=none; b=W4C2kxlI6TMVAs4Ty86s/jFq+KJxY2NpEh00QnPUM6BBb0+W2bCvf2VeYUiNtcVFWpPqGQFmNdBq2ltDXZbiUPnQ/uHAqQmFIgJibPvFAD4V9MkKk+qMyXQpZzAbTEf8awlvSDJ3EqCqDq2Zq8vseSHM44rl9S7KW3i2khOoYLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785798499; c=relaxed/simple;
	bh=1AMQf3psGpYGKdCqkkoU62mgtvWG7Cw6N7JS0QI9lPA=;
	h=Date:To:From:Subject:Message-Id; b=KtU0o8EMYcUNRYOBYYrl0Epnnw+Z6Pn45/QDMnbjpmyKhgVPP2miTgttFCaNtIX7b49ZG8Ok21/Jc1smTMtvcwqwCboDvwnr4nMk5JGIYToDlK1MToGOIV1shBE6rOmmEl4gL9Dopt8zl0oOgfjIgC7q3OgkAVdzOM3L7jpHqzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EqhJQUer; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EqhJQUer"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 437641F000E9;
	Mon,  3 Aug 2026 23:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785798498;
	bh=07jr7SLA55EPBfv0um/XvHXpfpcZgj1fESWCIsTR0BE=;
	h=Date:To:From:Subject;
	b=EqhJQUeryBXBzs8myBWMw8ptqgb5nX89LTSEkIWSFbolCAqbgAUeq7xqbS6hSul4l
	 LcWbztJdy0YdKLahHNUQWVF9exem9u7fhi+y0KRa82G5386m9WVFBcYOauywrC1lDj
	 Uh2bhHiIpw7CuNtJtnaMkAuuK/Jy2VQKlfigOVf0=
Date: Mon, 03 Aug 2026 16:08:17 -0700
To: mm-commits@vger.kernel.org,yosry@kernel.org,vbabka@kernel.org,surenb@google.com,sj@kernel.org,shuah@kernel.org,rppt@kernel.org,peterx@redhat.com,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,jhubbard@nvidia.com,jgg@ziepe.ca,david@kernel.org,pratmal@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-use-pattern-matching-in-gitignore.patch added to mm-new branch
Message-Id: <20260803230818.437641F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: use pattern matching in .gitignore
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-use-pattern-matching-in-gitignore.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-use-pattern-matching-in-gitignore.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

Link: https://lore.kernel.org/20260803221732.3651981-3-pratmal@google.com
Signed-off-by: Pratyush Mallick <pratmal@google.com>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Suggested-by: Yosry Ahmed <yosry@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/.gitignore |   70 +-----------------------
 1 file changed, 3 insertions(+), 67 deletions(-)

--- a/tools/testing/selftests/mm/.gitignore~selftests-mm-use-pattern-matching-in-gitignore
+++ a/tools/testing/selftests/mm/.gitignore
@@ -1,68 +1,4 @@
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
_

Patches currently in -mm which might be from pratmal@google.com are

mm-page_reporting-add-page_reporting_delay_ms-module-parameter.patch
selftests-mm-rename-local_configh-to-local_configh_gen.patch
selftests-mm-use-pattern-matching-in-gitignore.patch

