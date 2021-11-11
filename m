Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD227C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:46:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9764861284
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:46:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234397AbhKKCtp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:49:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:54436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234393AbhKKCto (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:49:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B947061247;
        Thu, 11 Nov 2021 02:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598816;
        bh=hAdT3yl8RPuv/QnQJjWexr4t9S9xz/vhIJ9JJDy2sJI=;
        h=Date:From:To:Subject:From;
        b=Ad7Kp3AAFa2pzW40YwP4JBvowq3/L4yS7jFnHADwGP6f53E/lbcAQGPPPFYmvbSnW
         0aaRP4IbJ5/hik3UEQ8ltS5fPM5tDUiwxTaQ0Lut+K6sE414RN0lRgMyOKxEEiPjZC
         YsVLemH2lqbBCw8z0GEZzPLIZE2ZYKh4w5WKVJyk=
Date:   Wed, 10 Nov 2021 18:46:55 -0800
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, hughd@google.com,
        mm-commits@vger.kernel.org, pasha.tatashin@soleen.com,
        shuah@kernel.org, tyhicks@linux.microsoft.com,
        zhansayabagdaulet@gmail.com
Subject:  [merged]
 selftest-vm-fix-ksm-selftest-to-run-with-different-numa-topologies.patch
 removed from -mm tree
Message-ID: <20211111024655.nbVCKKvH0%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftest/vm: fix ksm selftest to run with different NUMA topologies
has been removed from the -mm tree.  Its filename was
     selftest-vm-fix-ksm-selftest-to-run-with-different-numa-topologies.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: selftest/vm: fix ksm selftest to run with different NUMA topologies

Platforms can have non-contiguous NUMA nodes like below

 #numactl  -H
available: 2 nodes (0,8)
.....
node distances:
node   0   8
  0:  10  40
  8:  40  10

 #numactl  -H
available: 1 nodes (1)
....
node distances:
node   1
  1:  10

Hence update the test to not assume the presence of Node 0 and 1 and also
use numa_num_configured_nodes() instead of numa_max_node for finding
whether to skip the test.

Link: https://lkml.kernel.org/r/20210914141414.350759-1-aneesh.kumar@linux.ibm.com
Fixes: 82e717ad3501 ("selftests: vm: add KSM merging across nodes test")
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Zhansaya Bagdauletkyzy <zhansayabagdaulet@gmail.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Tyler Hicks <tyhicks@linux.microsoft.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/ksm_tests.c |   29 ++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/vm/ksm_tests.c~selftest-vm-fix-ksm-selftest-to-run-with-different-numa-topologies
+++ a/tools/testing/selftests/vm/ksm_tests.c
@@ -354,12 +354,34 @@ err_out:
 	return KSFT_FAIL;
 }
 
+static int get_next_mem_node(int node)
+{
+
+	long node_size;
+	int mem_node = 0;
+	int i, max_node = numa_max_node();
+
+	for (i = node + 1; i <= max_node + node; i++) {
+		mem_node = i % (max_node + 1);
+		node_size = numa_node_size(mem_node, NULL);
+		if (node_size > 0)
+			break;
+	}
+	return mem_node;
+}
+
+static int get_first_mem_node(void)
+{
+	return get_next_mem_node(numa_max_node());
+}
+
 static int check_ksm_numa_merge(int mapping, int prot, int timeout, bool merge_across_nodes,
 				size_t page_size)
 {
 	void *numa1_map_ptr, *numa2_map_ptr;
 	struct timespec start_time;
 	int page_count = 2;
+	int first_node;
 
 	if (clock_gettime(CLOCK_MONOTONIC_RAW, &start_time)) {
 		perror("clock_gettime");
@@ -370,7 +392,7 @@ static int check_ksm_numa_merge(int mapp
 		perror("NUMA support not enabled");
 		return KSFT_SKIP;
 	}
-	if (numa_max_node() < 1) {
+	if (numa_num_configured_nodes() <= 1) {
 		printf("At least 2 NUMA nodes must be available\n");
 		return KSFT_SKIP;
 	}
@@ -378,8 +400,9 @@ static int check_ksm_numa_merge(int mapp
 		return KSFT_FAIL;
 
 	/* allocate 2 pages in 2 different NUMA nodes and fill them with the same data */
-	numa1_map_ptr = numa_alloc_onnode(page_size, 0);
-	numa2_map_ptr = numa_alloc_onnode(page_size, 1);
+	first_node = get_first_mem_node();
+	numa1_map_ptr = numa_alloc_onnode(page_size, first_node);
+	numa2_map_ptr = numa_alloc_onnode(page_size, get_next_mem_node(first_node));
 	if (!numa1_map_ptr || !numa2_map_ptr) {
 		perror("numa_alloc_onnode");
 		return KSFT_FAIL;
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are


