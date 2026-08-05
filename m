Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A4A03BED7A
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896697; cv=none; b=YQZqd9CSrNdy5prvX67cb3r1TLJsg/lDgRYsAVOE9oKYfF3+BX4OXw38v6zQDa4UWdG8B1oQFCXL6KlsWTBgohuD2pMpGW0jKLzGua44v3xhi8hRe9Q1KYOaj5J+RSlZE3tGDjWAEuwHBS9Mi/rp3K6/ABU44LfCIud4BIe9DDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896697; c=relaxed/simple;
	bh=LcLIdbqHtSjwqMjHxEwjIK+fNtj3OTWCq/2ogTia0Vs=;
	h=Date:To:From:Subject:Message-Id; b=UtWyt8ylufrYm3MVuqd7MAMN103g8p5kW1dr0Oam1bRqZ/Ezz655k5TnxoGmkZqr/4psLtTcvA5VnK7lzgdCLxz8/GOW2YVbjdna8ZMMno6MjZQ2GPoPJ7rMcAGeK3dTDsnAeHNHZ0FNqs79+rXowYEDU/8saqdYzpwRAy774tU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=v6EbcmuO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="v6EbcmuO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C36B41F000E9;
	Wed,  5 Aug 2026 02:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896695;
	bh=Oi5xQzLShxogfl47BGAEt1SxMGXE8l2psWWW++XQIsM=;
	h=Date:To:From:Subject;
	b=v6EbcmuOuOjAOfs6laGtCmcR7G5d8tcqI5zRiSKBHoZTV3dJO2HhS0xoGCwzQXnhr
	 j2AjnEYgVnb57ah0eyBjJOWvn2jAM5MGuDtl/WGE3c9+b62tiyWCIttyPFQef1IUVm
	 7fQToO30PiAS1SPCRWRqRQ9/FW/8LjS7/jVThaOA=
Date: Tue, 04 Aug 2026 19:24:55 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,shuah@kernel.org,ritesh.list@gmail.com,osalvador@suse.de,mhocko@kernel.org,linmiaohe@huawei.com,liam@infradead.org,dev.jain@arm.com,david@kernel.org,sayalip@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-fix-ksm-numa-merge-test-for-systems-with-memoryless-numa-nodes.patch removed from -mm tree
Message-Id: <20260805022455.C36B41F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: fix ksm NUMA merge test for systems with memoryless NUMA nodes
has been removed from the -mm tree.  Its filename was
     selftests-mm-fix-ksm-numa-merge-test-for-systems-with-memoryless-numa-nodes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Cc: Liam Howlett <liam@infradead.org>
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


