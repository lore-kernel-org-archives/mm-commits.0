Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D82F1346E56
	for <mm-commits@vger.kernel.org>; Thu, 25 Jun 2026 21:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782421344; cv=none; b=nMDMZG1Pd3yHJGFFLosI6eh/8JG5Op1Qty1QwXdo27ZRuH4mdRG1wDRFCrjC73k6bsHTT3JHRkVHeZ/Kz9aU4LQnMxU1zV+ksOrd3QbVk3ZmVxOTZZ7n8oIubTOULvWkD1/QvI49u0LyKbaSVF2Eos3E7Subau797l8EltHEcps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782421344; c=relaxed/simple;
	bh=+tylqv0Pl/2B/YrqcvMddEwcaWUvHBY0q3O3GGwO2ok=;
	h=Date:To:From:Subject:Message-Id; b=Cp2cuwMooPlEs+h5K0UpoKFs2HN/ceVZH2jiLkm5kIWrapF8CVri+969pLbC81+Al1BKoKHQWB1orb79aFUKegc4ga/u3UXsii0hYiMDlIGQsBC84aBHw1SxJYemv2jgyn6tTqn9lDf2eQ7bUBzA2UZh9ZUuNkHq2UjbUaLrOAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=K7oaAPMC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="K7oaAPMC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F9DA1F000E9;
	Thu, 25 Jun 2026 21:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782421342;
	bh=/O0zDj6qbcxmvYvbOsM4JlWrNsX47oU9gPhJ8PCfjPc=;
	h=Date:To:From:Subject;
	b=K7oaAPMCcypgLWhSYC12N9vkp0e6dBCK7+9rBRVJ5JItqu4KA+vdO3wR8e6/zQ3C8
	 K8JAD2tqFbQYzHM6zi3MoeJaeYyMM5pjmu6BUfDGBf5KRO60DIPrLCVCfEdjpW1jyo
	 7MGXX6C3pPKT//BmBIcuxgkk9GVNTAOTTXV8BOe0=
Date: Thu, 25 Jun 2026 14:02:21 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,shuah@kernel.org,ritesh.list@gmail.com,osalvador@suse.de,mhocko@kernel.org,linmiaohe@huawei.com,liam.howlett@oracle.com,dev.jain@arm.com,david@kernel.org,sayalip@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-ksm-numa-merge-test-for-systems-with-memoryless-numa-nodes.patch added to mm-new branch
Message-Id: <20260625210222.5F9DA1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: fix ksm NUMA merge test for systems with memoryless NUMA nodes
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-fix-ksm-numa-merge-test-for-systems-with-memoryless-numa-nodes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-ksm-numa-merge-test-for-systems-with-memoryless-numa-nodes.patch

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
Subject: selftests/mm: fix ksm NUMA merge test for systems with memoryless NUMA nodes
Date: Thu, 25 Jun 2026 18:10:17 +0530

The KSM NUMA merge test allocates identical pages on different NUMA nodes
and verifies KSM behavior with merge_across_nodes enabled and disabled.

On systems with memoryless NUMA nodes, for example:
 #numactl  -H
      available: 2 nodes (0,4)
      .....
      node 0 cpus: 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
      node 0 size: 14825 MB
      node 0 free: 1382 MB
      node 4 cpus:
      node 4 size: 0 MB
      node 4 free: 0 MB

the test may attempt to allocate memory on a node without memory, causing
numa_alloc_onnode() to fail and resulting in a spurious test failure.

Add count_mem_nodes() helper to count only nodes with memory and use it
instead of numa_num_configured_nodes() to ensure the test runs only on
systems with at least two NUMA nodes that have memory.  Skip the test
otherwise.

Before patch:
       ---------------------------
	running ./ksm_tests -N -m 1
       ---------------------------
        mbind: Invalid argument
        ok 1 KSM NUMA merging
	Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
        [PASS]
       ok 1 ksm_tests -N -m 1
       ---------------------------
        running ./ksm_tests -N -m 0
       ---------------------------
        mbind: Invalid argument
        not ok 1 KSM NUMA merging
	Totals: pass:0 fail:1 xfail:0 xpass:0 skip:0 error:0
        [FAIL]
       not ok 2 ksm_tests -N -m 0 # exit=1

After patch:
       ---------------------------
        running ./ksm_tests -N -m 1
       ---------------------------
        SKIP At least 2 NUMA nodes with memory must be available
	Totals: pass:0 fail:0 xfail:0 xpass:0 skip:1 error:0
        [SKIP]
        ok 1 ksm_tests -N -m 1 # SKIP
       ---------------------------
        running ./ksm_tests -N -m 0
       ---------------------------
        SKIP At least 2 NUMA nodes with memory must be available
	Totals: pass:0 fail:0 xfail:0 xpass:0 skip:1 error:0
        [SKIP]
        ok 2 ksm_tests -N -m 0 # SKIP

Link: https://lore.kernel.org/8540b58ef1fdbc2e5cb2f9fe28a2d2a54a5bc6a8.1782365671.git.sayalip@linux.ibm.com
Fixes: e3820ab252dd ("selftest/vm: fix ksm selftest to run with different NUMA topologies")
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/ksm_tests.c |   26 +++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

--- a/tools/testing/selftests/mm/ksm_tests.c~selftests-mm-fix-ksm-numa-merge-test-for-systems-with-memoryless-numa-nodes
+++ a/tools/testing/selftests/mm/ksm_tests.c
@@ -450,6 +450,18 @@ static int get_first_mem_node(void)
 	return get_next_mem_node(numa_max_node());
 }
 
+static int count_mem_nodes(void)
+{
+	int node, count = 0;
+
+	for (node = 0; node <= numa_max_node(); node++) {
+		if (numa_node_size(node, NULL) > 0)
+			count++;
+	}
+
+	return count;
+}
+
 static int check_ksm_numa_merge(int merge_type, int mapping, int prot, int timeout,
 				bool merge_across_nodes, size_t page_size)
 {
@@ -463,14 +475,12 @@ static int check_ksm_numa_merge(int merg
 		return KSFT_FAIL;
 	}
 
-	if (numa_available() < 0) {
-		ksft_print_msg("NUMA support not enabled\n");
-		return KSFT_SKIP;
-	}
-	if (numa_num_configured_nodes() <= 1) {
-		ksft_print_msg("At least 2 NUMA nodes must be available\n");
-		return KSFT_SKIP;
-	}
+	if (numa_available() < 0)
+		ksft_exit_skip("NUMA support not enabled\n");
+
+	if (count_mem_nodes() <= 1)
+		ksft_exit_skip("At least 2 NUMA nodes with memory must be available\n");
+
 	if (ksm_write_sysfs(KSM_FP("merge_across_nodes"), merge_across_nodes))
 		return KSFT_FAIL;
 
_

Patches currently in -mm which might be from sayalip@linux.ibm.com are

selftests-mm-handle-einval-when-configuring-gigantic-hugepages.patch
selftests-mm-fix-ksm-numa-merge-test-for-systems-with-memoryless-numa-nodes.patch

