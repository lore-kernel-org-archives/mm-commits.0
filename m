Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62C0F4219FC
	for <mm-commits@vger.kernel.org>; Thu, 11 Jun 2026 17:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781197980; cv=none; b=SbngQNyno5/givDZngqSM3jXvPMwuye5WaTpFGs7+OC6DtaQxYBSfFDkxDe81cyALDMjKDySDDzaO6x3H4reHsfWxkg6q76HLAJ1ZdbPxKdMApWpI2ce+kN7PJWVu+ZwAgwCPIqZcBz73YwRhgyaZHIFQ2c3X+xnQUnm8WYMpEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781197980; c=relaxed/simple;
	bh=HaFzQcLMxEorTNQXYjjipt+ybpFkfgebTyFoW2icG6U=;
	h=Date:To:From:Subject:Message-Id; b=Bu7trex9l8WcmhJ9aivfAOR7MI3NcKxPGYSCJs9Vgz7hDDZhDwLGrQS8EGw72EyTgtblmLCExKHG8tPh1FCpGoma2xgAJXhwyR0Q75X3tkNUevUhRq3MMsK0WaNLDghyAchri7in78Ka1L8pN2sA/XBXwkhaFCa3zDnMusGrjsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=S4Ftyt2z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="S4Ftyt2z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F18131F00893;
	Thu, 11 Jun 2026 17:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1781197979;
	bh=r9d2UqjIgP2m2B7lSYP2na2uLlgC/a8eQPNHS+7zNZQ=;
	h=Date:To:From:Subject;
	b=S4Ftyt2zQ5L87wUkGYVkV1HmFoiLiJijoC6Y0GbmgM9z5GqDk6gYh5DlwDRG2iDOw
	 dGmcGk+nPpUyroPFYjZZ4j7wfUIg9OhlukECXB5WXWNDAz67o6CgJAYrDXVrvrCVr1
	 m9/BWDXYYkh//uCEINSyqz/DG46halMM/4GWGmvk=
Date: Thu, 11 Jun 2026 10:12:58 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,venkat88@linux.ibm.com,shuah@kernel.org,ritesh.list@gmail.com,osalvador@suse.de,mhocko@kernel.org,linmiaohe@huawei.com,liam.howlett@oracle.com,dev.jain@arm.com,david@kernel.org,sayalip@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] selftests-mm-skip-uffd-stress-test-when-nr_pages_per_cpu-is-zero-fix.patch removed from -mm tree
Message-Id: <20260611171258.F18131F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: use ksft_exit_skip() instead of KSFT_SKIP in uffd-stress
has been removed from the -mm tree.  Its filename was
     selftests-mm-skip-uffd-stress-test-when-nr_pages_per_cpu-is-zero-fix.patch

This patch was dropped because it was folded into selftests-mm-skip-uffd-stress-test-when-nr_pages_per_cpu-is-zero.patch

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
selftests-mm-move-hwpoison-setup-into-run_test-and-silence-modprobe-output-for-memory-failure-category.patch
selftests-mm-clarify-alternate-unmapping-in-compaction_test.patch
selftests-mm-allow-pud-level-entries-in-compound-testcase-of-hmm-tests.patch
selftests-mm-remove-hardcoded-thp-sizing-assumptions-in-hmm-tests.patch

