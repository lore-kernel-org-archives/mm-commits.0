Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A04F3446CE
	for <mm-commits@vger.kernel.org>; Thu, 21 May 2026 21:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779400533; cv=none; b=BfmazYmKvZEkmokiKYy8aqWNgBHxPmiYwOUlYjA0ZRcfwtEN07h+orVMiGQnxiWL98DhwvMR7Z4a0FbTUHxn2XRTRT/9AeudfCz8DRLKG8WLYKO7AutOS6Zm8mXiysEd5BPKXvm/6UUZd7kv1PQNwvfR539MZ7A5wtVhQVsdspI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779400533; c=relaxed/simple;
	bh=+/Q0xccIuLJ/67/AWtbr+xnDwFZu+0zniXGOETZdHXo=;
	h=Date:To:From:Subject:Message-Id; b=FJpxjP87hcVOT5as1MqaMSTqnuw21/9qsxbR51biPMCpW9495h/cI65ElnTeVOePUkyqul9y522SJ+aHCWIzt10XtXOJ2dSFehda5koEOoOtZRfi2Uj9+vQSd0xObnv4jePJxUbKAtkN7zzixa6M+94ZrUtt1OeEO+p6AvhablU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qu/HLQXD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qu/HLQXD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F46A1F000E9;
	Thu, 21 May 2026 21:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779400532;
	bh=MYCcZicksoJWQwbtBjw1hY3KQZcQt5gBXJw3N9NHX44=;
	h=Date:To:From:Subject;
	b=qu/HLQXDyYlQkdtGbwHQJVtHaI8AxdYwmYKYsmpPUSzqr6ayBydFOmKiPzKkkHLYD
	 6fPujP8r3f5isN05DlxiSONrl18qLrdUmk6wk9M2vlXKgtaLl1YvdDupWjuk6kf4Ju
	 mHsShYGRKInNZtqqt3RQxbOr2NttbrH/T5J8SHrc=
Date: Thu, 21 May 2026 14:55:31 -0700
To: mm-commits@vger.kernel.org,sayalip@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-skip-uffd-stress-test-when-nr_pages_per_cpu-is-zero-fix.patch added to mm-new branch
Message-Id: <20260521215532.4F46A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: use ksft_exit_skip() instead of KSFT_SKIP in uffd-stress
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-skip-uffd-stress-test-when-nr_pages_per_cpu-is-zero-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-skip-uffd-stress-test-when-nr_pages_per_cpu-is-zero-fix.patch

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
Subject: selftests/mm: use ksft_exit_skip() instead of KSFT_SKIP in uffd-stress
Date: Thu, 21 May 2026 13:32:51 +0530

When nr_pages_per_cpu evaluates to zero, the test is skipped by printing a
message and returning KSFT_SKIP manually.

Replace this with ksft_exit_skip(), which prints the skip message and
exits with the correct skip status in a single helper, making the code
consistent with other selftests.

Link: https://lore.kernel.org/88202b56-1dc5-43e2-9d1f-a0823a9531f0@linux.ibm.com
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-stress.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/uffd-stress.c~selftests-mm-skip-uffd-stress-test-when-nr_pages_per_cpu-is-zero-fix
+++ a/tools/testing/selftests/mm/uffd-stress.c
@@ -489,9 +489,8 @@ int main(int argc, char **argv)
 
 	gopts->nr_pages_per_cpu = bytes / gopts->page_size / gopts->nr_parallel;
 	if (!gopts->nr_pages_per_cpu) {
-		ksft_print_msg("pages_per_cpu = 0, cannot test (%zu / %lu / %lu)\n",
+		ksft_exit_skip("pages_per_cpu = 0, cannot test (%zu / %lu / %lu)\n",
 			       bytes, gopts->page_size, gopts->nr_parallel);
-		return KSFT_SKIP;
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

