Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5040349CF0
	for <mm-commits@vger.kernel.org>; Thu, 21 May 2026 21:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779400532; cv=none; b=uJoauLQ6mAS6qwvT8NOYNyvoIVFvEggP7EcjJu9VivYBSCpRUbRADy2DdGudVik5f9fkfwmcNE7ktnq5m96PLZvPhuZ/j0r5WVwcfEl9oI2zyMj4VPRBzAo9NU1Zg4+FeRW3wztgsEzfhZyEYMhX7fDyKh23gyoiLb9hLjQSdN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779400532; c=relaxed/simple;
	bh=oqPRvKfDjPOIFPZzmqSfvE295BE0gABIT+JZzPNqF9I=;
	h=Date:To:From:Subject:Message-Id; b=EMO9m7CucccLihh37Jap9d/PeUPhBWpL4mv6Rgvh7K9P9QdKKmHqNBXVzEbJpLIYoMcTCqzH19Hok9lcHtgk6LMT3wY6JpMlpoI7nQXxmppypNdtxoBm4aBWYRa2UVz1dHLqGqCu8q2Gob9ijxO54wiZ4EBJF+BeHV2+Cf6+Z3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=o2YOFfOi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="o2YOFfOi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 451931F000E9;
	Thu, 21 May 2026 21:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779400530;
	bh=ubuZJY3qYtzJbLnjz7+qJvVFfRfQNJxwEYfpZemKO88=;
	h=Date:To:From:Subject;
	b=o2YOFfOiFxMdGSuAftNOLH9Jvb4iplZaWAgW2m3QNLdSsm6NLKREkFQIWpRJUlWuh
	 fb4ZT4eWOm0HpoPUeyJ7KD+06drse3ihSgM5ig/PTrPaPPKNKy6WTUVTFjuRSc8GeT
	 1QNoqBHI4PlC+xpDEX5XNkxQ88P1f0tMULI0lefs=
Date: Thu, 21 May 2026 14:55:29 -0700
To: mm-commits@vger.kernel.org,sayalip@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-skip-uffd-stress-test-when-nr_pages_per_cpu-is-zero.patch added to mm-new branch
Message-Id: <20260521215530.451931F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: skip uffd-stress test when nr_pages_per_cpu is zero
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-skip-uffd-stress-test-when-nr_pages_per_cpu-is-zero.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-skip-uffd-stress-test-when-nr_pages_per_cpu-is-zero.patch

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
From: Sayali Patil <sayalip@linux.ibm.com>
Subject: selftests/mm: skip uffd-stress test when nr_pages_per_cpu is zero
Date: Thu, 21 May 2026 12:17:51 +0530

uffd-stress currently fails when the computed nr_pages_per_cpu evaluates
to zero:

nr_pages_per_cpu = bytes / page_size / nr_parallel

This can occur on systems with large hugepage sizes (e.g.  1GB) and a high
number of CPUs, where the total allocated memory is sufficient overall but
not enough to provide at least one page per cpu.

In such cases, the failure is due to insufficient test resources rather
than incorrect kernel behaviour.  Update the test to treat this condition
as a test skip instead of reporting an error.

Link: https://lore.kernel.org/0707e9a0f1b3dd904c4a069b91db317f9c160faa.1779296493.git.sayalip@linux.ibm.com
Fixes: db0f1c138f18 ("selftests/mm: print some details when uffd-stress gets bad params")
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-stress.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/mm/uffd-stress.c~selftests-mm-skip-uffd-stress-test-when-nr_pages_per_cpu-is-zero
+++ a/tools/testing/selftests/mm/uffd-stress.c
@@ -489,9 +489,9 @@ int main(int argc, char **argv)
 
 	gopts->nr_pages_per_cpu = bytes / gopts->page_size / gopts->nr_parallel;
 	if (!gopts->nr_pages_per_cpu) {
-		_err("pages_per_cpu = 0, cannot test (%lu / %lu / %lu)",
-			bytes, gopts->page_size, gopts->nr_parallel);
-		usage();
+		ksft_print_msg("pages_per_cpu = 0, cannot test (%zu / %lu / %lu)\n",
+			       bytes, gopts->page_size, gopts->nr_parallel);
+		return KSFT_SKIP;
 	}
 
 	bounces = atoi(argv[3]);
_

Patches currently in -mm which might be from sayalip@linux.ibm.com are

selftests-mm-restore-default-nr_hugepages-value-via-exit-trap-in-charge_reserved_hugetlbsh.patch
selftests-mm-fix-hugetlb-pathname-construction-in-charge_reserved_hugetlbsh.patch
selftests-mm-restore-default-nr_hugepages-value-via-exit-trap-in-hugetlb_reparenting_testsh.patch
selftests-mm-fix-hugetlb-pathname-construction-in-hugetlb_reparenting_testsh.patch
selftests-mm-fix-cgroup-task-placement-and-drop-memorycurrent-checks-in-hugetlb_reparenting_testsh.patch
selftests-mm-size-tmpfs-according-to-pmd-page-size-in-split_huge_page_test.patch
selftests-mm-free-dynamically-allocated-pmd-sized-buffers-in-split_huge_page_test.patch
selftest-mm-register-existing-mapping-with-userfaultfd-in-hugetlb-mremap.patch
selftests-mm-ensure-destination-is-hugetlb-backed-in-hugetlb-mremap.patch
selftests-mm-skip-uffd-wp-mremap-if-uffd-write-protect-is-unsupported.patch
selftests-mm-skip-uffd-stress-test-when-nr_pages_per_cpu-is-zero.patch
selftests-mm-skip-uffd-stress-test-when-nr_pages_per_cpu-is-zero-fix.patch
selftests-mm-move-hwpoison-setup-into-run_test-and-silence-modprobe-output-for-memory-failure-category.patch
selftests-mm-clarify-alternate-unmapping-in-compaction_test.patch

