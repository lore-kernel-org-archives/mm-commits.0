Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF975C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:44:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB72A6136A
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:44:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233694AbhKEUqi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:46:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:41506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233055AbhKEUqh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:46:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 339436136A;
        Fri,  5 Nov 2021 20:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636145037;
        bh=gEfqlLcFkmfYsYfMe813v1IrjynanjwWLqYY7B16zMk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=hoq4aRx0pEIov68MFssHKAdUs72VYxX+xbHY9lgXz9kJU+Vz5jpq+Zypzol97tLLb
         pbbQrs0dHzrm04DTb6uzMwoyzItsOycKSuWNB1AeyxUCU6dI8SS7fCon8Erj0icmkv
         pWHlsagX84qQgWoLiYs3oqr/Dbm8c6GokJV49uVM=
Date:   Fri, 05 Nov 2021 13:43:56 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, pedrodemargomes@gmail.com,
        torvalds@linux-foundation.org, zhansayabagdaulet@gmail.com
Subject:  [patch 178/262] selftests: vm: add KSM huge pages merging
 time test
Message-ID: <20211105204356.UebjPpi5N%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Subject: selftests: vm: add KSM huge pages merging time test

Add test case of KSM merging time using mostly huge pages

Link: https://lkml.kernel.org/r/20211013044045.360251-1-pedrodemargomes@gmail.com
Signed-off-by: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Cc: Zhansaya Bagdauletkyzy <zhansayabagdaulet@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/ksm_tests.c |  125 ++++++++++++++++++++++-
 1 file changed, 124 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/vm/ksm_tests.c~selftests-vm-add-ksm-huge-pages-merging-time-test
+++ a/tools/testing/selftests/vm/ksm_tests.c
@@ -5,6 +5,10 @@
 #include <time.h>
 #include <string.h>
 #include <numa.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <stdint.h>
+#include <err.h>
 
 #include "../kselftest.h"
 #include "../../../../include/vdso/time64.h"
@@ -18,6 +22,15 @@
 #define KSM_MERGE_ACROSS_NODES_DEFAULT true
 #define MB (1ul << 20)
 
+#define PAGE_SHIFT 12
+#define HPAGE_SHIFT 21
+
+#define PAGE_SIZE (1 << PAGE_SHIFT)
+#define HPAGE_SIZE (1 << HPAGE_SHIFT)
+
+#define PAGEMAP_PRESENT(ent)	(((ent) & (1ull << 63)) != 0)
+#define PAGEMAP_PFN(ent)	((ent) & ((1ull << 55) - 1))
+
 struct ksm_sysfs {
 	unsigned long max_page_sharing;
 	unsigned long merge_across_nodes;
@@ -34,6 +47,7 @@ enum ksm_test_name {
 	CHECK_KSM_ZERO_PAGE_MERGE,
 	CHECK_KSM_NUMA_MERGE,
 	KSM_MERGE_TIME,
+	KSM_MERGE_TIME_HUGE_PAGES,
 	KSM_COW_TIME
 };
 
@@ -100,6 +114,9 @@ static void print_help(void)
 	       " -P evaluate merging time and speed.\n"
 	       "    For this test, the size of duplicated memory area (in MiB)\n"
 	       "    must be provided using -s option\n"
+				 " -H evaluate merging time and speed of area allocated mostly with huge pages\n"
+	       "    For this test, the size of duplicated memory area (in MiB)\n"
+	       "    must be provided using -s option\n"
 	       " -C evaluate the time required to break COW of merged pages.\n\n");
 
 	printf(" -a: specify the access protections of pages.\n"
@@ -439,6 +456,101 @@ err_out:
 	return KSFT_FAIL;
 }
 
+int64_t allocate_transhuge(void *ptr, int pagemap_fd)
+{
+	uint64_t ent[2];
+
+	/* drop pmd */
+	if (mmap(ptr, HPAGE_SIZE, PROT_READ | PROT_WRITE,
+				MAP_FIXED | MAP_ANONYMOUS |
+				MAP_NORESERVE | MAP_PRIVATE, -1, 0) != ptr)
+		errx(2, "mmap transhuge");
+
+	if (madvise(ptr, HPAGE_SIZE, MADV_HUGEPAGE))
+		err(2, "MADV_HUGEPAGE");
+
+	/* allocate transparent huge page */
+	*(volatile void **)ptr = ptr;
+
+	if (pread(pagemap_fd, ent, sizeof(ent),
+			(uintptr_t)ptr >> (PAGE_SHIFT - 3)) != sizeof(ent))
+		err(2, "read pagemap");
+
+	if (PAGEMAP_PRESENT(ent[0]) && PAGEMAP_PRESENT(ent[1]) &&
+	    PAGEMAP_PFN(ent[0]) + 1 == PAGEMAP_PFN(ent[1]) &&
+	    !(PAGEMAP_PFN(ent[0]) & ((1 << (HPAGE_SHIFT - PAGE_SHIFT)) - 1)))
+		return PAGEMAP_PFN(ent[0]);
+
+	return -1;
+}
+
+static int ksm_merge_hugepages_time(int mapping, int prot, int timeout, size_t map_size)
+{
+	void *map_ptr, *map_ptr_orig;
+	struct timespec start_time, end_time;
+	unsigned long scan_time_ns;
+	int pagemap_fd, n_normal_pages, n_huge_pages;
+
+	map_size *= MB;
+	size_t len = map_size;
+
+	len -= len % HPAGE_SIZE;
+	map_ptr_orig = mmap(NULL, len + HPAGE_SIZE, PROT_READ | PROT_WRITE,
+			MAP_ANONYMOUS | MAP_NORESERVE | MAP_PRIVATE, -1, 0);
+	map_ptr = map_ptr_orig + HPAGE_SIZE - (uintptr_t)map_ptr_orig % HPAGE_SIZE;
+
+	if (map_ptr_orig == MAP_FAILED)
+		err(2, "initial mmap");
+
+	if (madvise(map_ptr, len + HPAGE_SIZE, MADV_HUGEPAGE))
+		err(2, "MADV_HUGEPAGE");
+
+	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
+	if (pagemap_fd < 0)
+		err(2, "open pagemap");
+
+	n_normal_pages = 0;
+	n_huge_pages = 0;
+	for (void *p = map_ptr; p < map_ptr + len; p += HPAGE_SIZE) {
+		if (allocate_transhuge(p, pagemap_fd) < 0)
+			n_normal_pages++;
+		else
+			n_huge_pages++;
+	}
+	printf("Number of normal pages:    %d\n", n_normal_pages);
+	printf("Number of huge pages:    %d\n", n_huge_pages);
+
+	memset(map_ptr, '*', len);
+
+	if (clock_gettime(CLOCK_MONOTONIC_RAW, &start_time)) {
+		perror("clock_gettime");
+		goto err_out;
+	}
+	if (ksm_merge_pages(map_ptr, map_size, start_time, timeout))
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
+	munmap(map_ptr_orig, len + HPAGE_SIZE);
+	return KSFT_PASS;
+
+err_out:
+	printf("Not OK\n");
+	munmap(map_ptr_orig, len + HPAGE_SIZE);
+	return KSFT_FAIL;
+}
+
 static int ksm_merge_time(int mapping, int prot, int timeout, size_t map_size)
 {
 	void *map_ptr;
@@ -564,7 +676,7 @@ int main(int argc, char *argv[])
 	bool merge_across_nodes = KSM_MERGE_ACROSS_NODES_DEFAULT;
 	long size_MB = 0;
 
-	while ((opt = getopt(argc, argv, "ha:p:l:z:m:s:MUZNPC")) != -1) {
+	while ((opt = getopt(argc, argv, "ha:p:l:z:m:s:MUZNPCH")) != -1) {
 		switch (opt) {
 		case 'a':
 			prot = str_to_prot(optarg);
@@ -618,6 +730,9 @@ int main(int argc, char *argv[])
 		case 'P':
 			test_name = KSM_MERGE_TIME;
 			break;
+		case 'H':
+			test_name = KSM_MERGE_TIME_HUGE_PAGES;
+			break;
 		case 'C':
 			test_name = KSM_COW_TIME;
 			break;
@@ -670,6 +785,14 @@ int main(int argc, char *argv[])
 		ret = ksm_merge_time(MAP_PRIVATE | MAP_ANONYMOUS, prot, ksm_scan_limit_sec,
 				     size_MB);
 		break;
+	case KSM_MERGE_TIME_HUGE_PAGES:
+		if (size_MB == 0) {
+			printf("Option '-s' is required.\n");
+			return KSFT_FAIL;
+		}
+		ret = ksm_merge_hugepages_time(MAP_PRIVATE | MAP_ANONYMOUS, prot,
+				ksm_scan_limit_sec, size_MB);
+		break;
 	case KSM_COW_TIME:
 		ret = ksm_cow_time(MAP_PRIVATE | MAP_ANONYMOUS, prot, ksm_scan_limit_sec,
 				   page_size);
_
