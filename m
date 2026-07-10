Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 657A834EEFD
	for <mm-commits@vger.kernel.org>; Fri, 10 Jul 2026 01:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783648411; cv=none; b=YkmHupZS/BlYWM/92WKcQ1/lQrRgavcgT0p9FoZyRUSqSjkSFQ2c+b+/6Yl13mBxJg6REfyugEHWnewT6XnrQ5j80CwFnwqLa8PEcp4KFEc7G/3r4T4KJ3vkqUzA/o88xpK0xvDn1o8IWOHuXRoO2GOQVOCjM3YVP+QNrKLFEpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783648411; c=relaxed/simple;
	bh=NmW6JIUIu3eBzqyr5uMxjaFubUIxjveDVKWeEthCOlg=;
	h=Date:To:From:Subject:Message-Id; b=qXNtyzwatbkB7XRsLGt7iwcXPE6BXJk+iawho/FPVfTykeeVqQmlRcwDn/N3luRjqAvipx/8wahO24r76jc0FcO8p6uLHrMT1lTKdllRqmLRUWgJZYn+zZVJoBt+P3lJgaZIGlIw/woeoqqlIy4h3txkJ80OKELoFPTS6p4jDm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rGDyiHub; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rGDyiHub"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E56271F000E9;
	Fri, 10 Jul 2026 01:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783648410;
	bh=PxEkYLB3QjNjEaD+9RZ6ndJYrMzcmqO/PxlFVyASq34=;
	h=Date:To:From:Subject;
	b=rGDyiHubplPDBJiTx4QdUafDjaYSlvMSFNuEnYzfbMCCnC/B+lp1rIDdAV6cOehj7
	 E9k2nLFj5g3Fi0IIsNFTVI0x5C1Um0/zGny7zxHuSl2HvnWt31G5OfPGob+sfn3AYb
	 DME+uxDF8uEnbX31BW8XhzRZwel+fqtLb75p+bX4=
Date: Thu, 09 Jul 2026 18:53:29 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,shuah@kernel.org,ritesh.list@gmail.com,osalvador@suse.de,mhocko@kernel.org,linmiaohe@huawei.com,liam.howlett@oracle.com,dev.jain@arm.com,david@kernel.org,sayalip@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-ksm-numa-merge-test-for-systems-with-memoryless-numa-nodes.patch added to mm-new branch
Message-Id: <20260710015329.E56271F000E9@smtp.kernel.org>
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
Date: Wed, 8 Jul 2026 12:29:06 +0530

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

The test currently checks numa_num_configured_nodes() to determine whether
sufficient NUMA nodes are available.  However, configured nodes do not
necessarily have memory.

Reuse the existing get_first_mem_node() and get_next_mem_node() helpers to
locate NUMA nodes that actually contain memory, and skip the test when
fewer than two such nodes are available.

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
        At least 2 NUMA nodes with memory must be available
	ok 1
	SKIP KSM NUMA merging
	Totals: pass:0 fail:0 xfail:0 xpass:0 skip:1 error:0
        [PASS]
        ok 1 ksm_tests -N -m 1
       ---------------------------
        running ./ksm_tests -N -m 0
       ---------------------------
        At least 2 NUMA nodes with memory must be available
	ok 1
	SKIP KSM NUMA merging
	Totals: pass:0 fail:0 xfail:0 xpass:0 skip:1 error:0
        [PASS]
        ok 2 ksm_tests -N -m 0

Link: https://lore.kernel.org/78a3b0e3fb94004c0710872c5bab6f7381b7d63c.1783446924.git.sayalip@linux.ibm.com
Fixes: e3820ab252dd ("selftest/vm: fix ksm selftest to run with different NUMA topologies")
Co-developed-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
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

 tools/testing/selftests/mm/ksm_tests.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/tools/testing/selftests/mm/ksm_tests.c~selftests-mm-fix-ksm-numa-merge-test-for-systems-with-memoryless-numa-nodes
+++ a/tools/testing/selftests/mm/ksm_tests.c
@@ -440,9 +440,9 @@ static int get_next_mem_node(int node)
 		mem_node = i % (max_node + 1);
 		node_size = numa_node_size(mem_node, NULL);
 		if (node_size > 0)
-			break;
+			return mem_node;
 	}
-	return mem_node;
+	return -ENODEV;
 }
 
 static int get_first_mem_node(void)
@@ -455,8 +455,8 @@ static int check_ksm_numa_merge(int merg
 {
 	void *numa1_map_ptr, *numa2_map_ptr;
 	struct timespec start_time;
+	int first_node, second_node;
 	int page_count = 2;
-	int first_node;
 
 	if (clock_gettime(CLOCK_MONOTONIC_RAW, &start_time)) {
 		ksft_perror("clock_gettime");
@@ -467,17 +467,19 @@ static int check_ksm_numa_merge(int merg
 		ksft_print_msg("NUMA support not enabled\n");
 		return KSFT_SKIP;
 	}
-	if (numa_num_configured_nodes() <= 1) {
-		ksft_print_msg("At least 2 NUMA nodes must be available\n");
+	first_node = get_first_mem_node();
+	second_node = get_next_mem_node(first_node);
+
+	if (second_node < 0) {
+		ksft_print_msg("At least 2 NUMA nodes with memory must be available\n");
 		return KSFT_SKIP;
 	}
 	if (ksm_write_sysfs(KSM_FP("merge_across_nodes"), merge_across_nodes))
 		return KSFT_FAIL;
 
 	/* allocate 2 pages in 2 different NUMA nodes and fill them with the same data */
-	first_node = get_first_mem_node();
 	numa1_map_ptr = numa_alloc_onnode(page_size, first_node);
-	numa2_map_ptr = numa_alloc_onnode(page_size, get_next_mem_node(first_node));
+	numa2_map_ptr = numa_alloc_onnode(page_size, second_node);
 	if (!numa1_map_ptr || !numa2_map_ptr) {
 		ksft_perror("numa_alloc_onnode");
 		return KSFT_FAIL;
_

Patches currently in -mm which might be from sayalip@linux.ibm.com are

selftests-mm-handle-einval-when-configuring-gigantic-hugepages.patch
selftests-mm-fix-ksm-numa-merge-test-for-systems-with-memoryless-numa-nodes.patch
selftests-mm-fix-ternary-operator-precedence-in-ksm_tests.patch

