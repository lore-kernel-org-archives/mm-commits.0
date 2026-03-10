Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3C1840DFC3
	for <mm-commits@vger.kernel.org>; Tue, 10 Mar 2026 16:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773160999; cv=none; b=AV9XVeaj3y8/vBkei95+qL6Z3zcP81XmTCu/jM0zTqMqAZOhhN6IOyBq3hCwUl6ZN7rW4Yj46coaP6bCaoo7bRtoKTMC1TlGDBlgCqaXaMqnqNxj7Ex7Q4LWe+4PZoT950dYbT4xRzZ7ueu+tsaKC1XjiQIyNfVVSS1zy+3u1Wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773160999; c=relaxed/simple;
	bh=E5d85eZBnJT6nIcRPPcix8QRae8XEMSdHUNZneb8fo4=;
	h=Date:To:From:Subject:Message-Id; b=BuZ6R/LNK8nfoCrBJubLCqOznT6XsY1ECthZzFvGtgBh1pA5YTx2YttpDI6hG/eruoCOadF5Y09BE/rHl78Hmz7J5yy27ICgKBTqBU1BkY0n7ceU05kTTQaqevsls5H5Spwn8nMDVUyM4L1SAK3kZmwbi5lPvkgTK6i96h8zKUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GoyIOJOE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GoyIOJOE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 349E8C19423;
	Tue, 10 Mar 2026 16:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773160999;
	bh=E5d85eZBnJT6nIcRPPcix8QRae8XEMSdHUNZneb8fo4=;
	h=Date:To:From:Subject:From;
	b=GoyIOJOEissdh+HNmWDjpgoge2ftQ4CRSindHO+F+44c4rwvOIqPRzWSY2IwlksGN
	 2VtjfLwKY11Gisfpdm5shLsSQ9c368b9Zqo3FgjJ03XULlXuDMTznbVsRLZIor5JxG
	 7cqFRpVSlDt1B6iZUI1RrJV5ko8l6mHRQ3qAcfsk=
Date: Tue, 10 Mar 2026 09:43:18 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,usama.anjum@collabora.com,tj@kernel.org,shuah@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,ritesh.list@gmail.com,osalvador@suse.de,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,hannes@cmpxchg.org,dev.jain@arm.com,david@kernel.org,sayalip@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-skip-uffd-stress-test-when-nr_pages_per_cpu-is-zero.patch added to mm-new branch
Message-Id: <20260310164319.349E8C19423@smtp.kernel.org>
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
Date: Tue, 10 Mar 2026 15:19:28 +0530

uffd-stress currently fails when the computed nr_pages_per_cpu evaluates
to zero:

nr_pages_per_cpu = bytes / page_size / nr_parallel

This can occur on systems with large hugepage sizes (e.g.  1GB) and a high
number of CPUs, where the total allocated memory is sufficient overall but
not enough to provide at least one page per cpu.

In such cases, the failure is due to insufficient test resources rather
than incorrect kernel behaviour.  Update the test to treat this condition
as a test skip instead of reporting an error.

Link: https://lkml.kernel.org/r/cca7aee2b9ed290ed1ac231edf2c9451e01ca204.1773134177.git.sayalip@linux.ibm.com
Fixes: db0f1c138f18 ("selftests/mm: print some details when uffd-stress gets bad params")
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: "Michal Koutný" <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-stress.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/mm/uffd-stress.c~selftests-mm-skip-uffd-stress-test-when-nr_pages_per_cpu-is-zero
+++ a/tools/testing/selftests/mm/uffd-stress.c
@@ -491,9 +491,9 @@ int main(int argc, char **argv)
 
 	gopts->nr_pages_per_cpu = bytes / gopts->page_size / gopts->nr_parallel;
 	if (!gopts->nr_pages_per_cpu) {
-		_err("pages_per_cpu = 0, cannot test (%lu / %lu / %lu)",
-			bytes, gopts->page_size, gopts->nr_parallel);
-		usage();
+		ksft_print_msg("pages_per_cpu = 0, cannot test (%lu / %lu / %lu)\n",
+			       bytes, gopts->page_size, gopts->nr_parallel);
+		return KSFT_SKIP;
 	}
 
 	bounces = atoi(argv[3]);
_

Patches currently in -mm which might be from sayalip@linux.ibm.com are

selftests-mm-restore-default-nr_hugepages-value-during-cleanup-in-charge_reserved_hugetlbsh.patch
selftests-mm-fix-hugetlb-pathname-construction-in-charge_reserved_hugetlbsh.patch
selftests-mm-fix-hugetlb-pathname-construction-in-hugetlb_reparenting_testsh.patch
selftest-mm-fix-cgroup-task-placement-and-tolerance-in-hugetlb_reparenting_testsh.patch
selftests-mm-size-tmpfs-according-to-pmd-page-size-in-split_huge_page_test.patch
selftest-mm-adjust-hugepage-mremap-test-size-for-large-huge-pages.patch
selftest-mm-register-existing-mapping-with-userfaultfd-in-hugepage-mremap.patch
selftests-mm-ensure-destination-is-hugetlb-backed-in-hugepage-mremap.patch
selftests-mm-skip-uffd-wp-mremap-if-uffd-write-protect-is-unsupported.patch
selftests-mm-skip-uffd-stress-test-when-nr_pages_per_cpu-is-zero.patch
selftests-mm-fix-double-increment-in-linked-list-cleanup-in-compaction_test.patch
selftests-mm-move-hwpoison-setup-into-run_test-and-silence-modprobe-output-for-memory-failure-category.patch
selftests-cgroup-extend-test_hugetlb_memcgc-to-support-all-huge-page-sizes.patch

