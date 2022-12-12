Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26A6FC001B2
	for <mm-commits@archiver.kernel.org>; Mon, 12 Dec 2022 02:13:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229475AbiLLCNj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Dec 2022 21:13:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230462AbiLLCNf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Dec 2022 21:13:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 770D05FC4
        for <mm-commits@vger.kernel.org>; Sun, 11 Dec 2022 18:13:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0D06E60EC6
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 02:13:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58EF2C433F1;
        Mon, 12 Dec 2022 02:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670811213;
        bh=V/aBZYt+Vm3tZwKuyhsJ9RkYzr0dH4O+oXOkD092phw=;
        h=Date:To:From:Subject:From;
        b=HPJiNCBAIaTD7mrCdeH54v7Ptc92g8AJuoAcJtAdUZL8D+6WpwCfrwvQbH1k1pCWd
         MvLCkv+IvoQANzG6NgoSHGap19p8ruC4mr1ydxND1yDqMHQ7jIKLLiVKqMQwHgtdnu
         BmlTwIYovJlgN/VQPgxWkLLPhQNwot7U6SqurJt0=
Date:   Sun, 11 Dec 2022 18:13:32 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        shuah@kernel.org, peterx@redhat.com, jhubbard@nvidia.com,
        jgg@nvidia.com, hughd@google.com, aarcange@redhat.com,
        david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-vm-add-test-to-measure-madv_unmergeable-performance.patch removed from -mm tree
Message-Id: <20221212021333.58EF2C433F1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/vm: add test to measure MADV_UNMERGEABLE performance
has been removed from the -mm tree.  Its filename was
     selftests-vm-add-test-to-measure-madv_unmergeable-performance.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: selftests/vm: add test to measure MADV_UNMERGEABLE performance
Date: Fri, 21 Oct 2022 12:11:33 +0200

Let's add a test to measure performance of KSM breaking not triggered via
COW, but triggered by disabling KSM on an area filled with KSM pages via
MADV_UNMERGEABLE.

Link: https://lkml.kernel.org/r/20221021101141.84170-2-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Peter Xu <peterx@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/ksm_tests.c |   76 ++++++++++++++++++++++-
 1 file changed, 74 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/vm/ksm_tests.c~selftests-vm-add-test-to-measure-madv_unmergeable-performance
+++ a/tools/testing/selftests/vm/ksm_tests.c
@@ -40,6 +40,7 @@ enum ksm_test_name {
 	CHECK_KSM_NUMA_MERGE,
 	KSM_MERGE_TIME,
 	KSM_MERGE_TIME_HUGE_PAGES,
+	KSM_UNMERGE_TIME,
 	KSM_COW_TIME
 };
 
@@ -108,7 +109,10 @@ static void print_help(void)
 	       " -P evaluate merging time and speed.\n"
 	       "    For this test, the size of duplicated memory area (in MiB)\n"
 	       "    must be provided using -s option\n"
-				 " -H evaluate merging time and speed of area allocated mostly with huge pages\n"
+	       " -H evaluate merging time and speed of area allocated mostly with huge pages\n"
+	       "    For this test, the size of duplicated memory area (in MiB)\n"
+	       "    must be provided using -s option\n"
+	       " -D evaluate unmerging time and speed when disabling KSM.\n"
 	       "    For this test, the size of duplicated memory area (in MiB)\n"
 	       "    must be provided using -s option\n"
 	       " -C evaluate the time required to break COW of merged pages.\n\n");
@@ -188,6 +192,16 @@ static int ksm_merge_pages(void *addr, s
 	return 0;
 }
 
+static int ksm_unmerge_pages(void *addr, size_t size,
+			     struct timespec start_time, int timeout)
+{
+	if (madvise(addr, size, MADV_UNMERGEABLE)) {
+		perror("madvise");
+		return 1;
+	}
+	return 0;
+}
+
 static bool assert_ksm_pages_count(long dupl_page_count)
 {
 	unsigned long max_page_sharing, pages_sharing, pages_shared;
@@ -560,6 +574,53 @@ err_out:
 	return KSFT_FAIL;
 }
 
+static int ksm_unmerge_time(int mapping, int prot, int timeout, size_t map_size)
+{
+	void *map_ptr;
+	struct timespec start_time, end_time;
+	unsigned long scan_time_ns;
+
+	map_size *= MB;
+
+	map_ptr = allocate_memory(NULL, prot, mapping, '*', map_size);
+	if (!map_ptr)
+		return KSFT_FAIL;
+	if (clock_gettime(CLOCK_MONOTONIC_RAW, &start_time)) {
+		perror("clock_gettime");
+		goto err_out;
+	}
+	if (ksm_merge_pages(map_ptr, map_size, start_time, timeout))
+		goto err_out;
+
+	if (clock_gettime(CLOCK_MONOTONIC_RAW, &start_time)) {
+		perror("clock_gettime");
+		goto err_out;
+	}
+	if (ksm_unmerge_pages(map_ptr, map_size, start_time, timeout))
+		goto err_out;
+	if (clock_gettime(CLOCK_MONOTONIC_RAW, &end_time)) {
+		perror("clock_gettime");
+		goto err_out;
+	}
+
+	scan_time_ns = (end_time.tv_sec - start_time.tv_sec) * NSEC_PER_SEC +
+		       (end_time.tv_nsec - start_time.tv_nsec);
+
+	printf("Total size:    %lu MiB\n", map_size / MB);
+	printf("Total time:    %ld.%09ld s\n", scan_time_ns / NSEC_PER_SEC,
+	       scan_time_ns % NSEC_PER_SEC);
+	printf("Average speed:  %.3f MiB/s\n", (map_size / MB) /
+					       ((double)scan_time_ns / NSEC_PER_SEC));
+
+	munmap(map_ptr, map_size);
+	return KSFT_PASS;
+
+err_out:
+	printf("Not OK\n");
+	munmap(map_ptr, map_size);
+	return KSFT_FAIL;
+}
+
 static int ksm_cow_time(int mapping, int prot, int timeout, size_t page_size)
 {
 	void *map_ptr;
@@ -644,7 +705,7 @@ int main(int argc, char *argv[])
 	bool merge_across_nodes = KSM_MERGE_ACROSS_NODES_DEFAULT;
 	long size_MB = 0;
 
-	while ((opt = getopt(argc, argv, "ha:p:l:z:m:s:MUZNPCH")) != -1) {
+	while ((opt = getopt(argc, argv, "ha:p:l:z:m:s:MUZNPCHD")) != -1) {
 		switch (opt) {
 		case 'a':
 			prot = str_to_prot(optarg);
@@ -701,6 +762,9 @@ int main(int argc, char *argv[])
 		case 'H':
 			test_name = KSM_MERGE_TIME_HUGE_PAGES;
 			break;
+		case 'D':
+			test_name = KSM_UNMERGE_TIME;
+			break;
 		case 'C':
 			test_name = KSM_COW_TIME;
 			break;
@@ -762,6 +826,14 @@ int main(int argc, char *argv[])
 		ret = ksm_merge_hugepages_time(MAP_PRIVATE | MAP_ANONYMOUS, prot,
 				ksm_scan_limit_sec, size_MB);
 		break;
+	case KSM_UNMERGE_TIME:
+		if (size_MB == 0) {
+			printf("Option '-s' is required.\n");
+			return KSFT_FAIL;
+		}
+		ret = ksm_unmerge_time(MAP_PRIVATE | MAP_ANONYMOUS, prot,
+				       ksm_scan_limit_sec, size_MB);
+		break;
 	case KSM_COW_TIME:
 		ret = ksm_cow_time(MAP_PRIVATE | MAP_ANONYMOUS, prot, ksm_scan_limit_sec,
 				   page_size);
_

Patches currently in -mm which might be from david@redhat.com are


