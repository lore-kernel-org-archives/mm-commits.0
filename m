Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBE30C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 13 Oct 2021 22:23:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD73A610CC
	for <mm-commits@archiver.kernel.org>; Wed, 13 Oct 2021 22:23:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231187AbhJMWZR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Oct 2021 18:25:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:46944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230507AbhJMWZR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 13 Oct 2021 18:25:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9007B610CC;
        Wed, 13 Oct 2021 22:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634163793;
        bh=85z5gdGuUnzGWfBeSFKxgULjlKVZEccVPdQ15w/rryo=;
        h=Date:From:To:Subject:From;
        b=gLsADeUksBWnizGmIrEK038cVrnRDD48fJsHnqUD4Gqk/pUY0AfxkYBZkqnTok2JW
         aDAqdlf7dQIdGJqMSWWsXTJ0dBrCuclXOUfwMbKMOmm9fSvGW8acfDBtJ8GbVe+/PJ
         hy8ujWPPXukrQe4ehayQfdW8n6iHcsWJYRIEpz1U=
Date:   Wed, 13 Oct 2021 15:23:13 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, pedrodemargomes@gmail.com,
        zhansayabagdaulet@gmail.com
Subject:  [to-be-updated]
 selftests-vm-add-ksm-huge-pages-merging-time-test.patch removed from -mm
 tree
Message-ID: <20211013222313.9PWAnXhGf%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: vm: add KSM huge pages merging time test
has been removed from the -mm tree.  Its filename was
     selftests-vm-add-ksm-huge-pages-merging-time-test.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Subject: selftests: vm: add KSM huge pages merging time test

Link: https://lkml.kernel.org/r/20211011055908.87140-1-pedrodemargomes@gmail.com
Signed-off-by: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Cc: Zhansaya Bagdauletkyzy <zhansayabagdaulet@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/ksm_tests.c |   40 +++++++++++++++++------
 1 file changed, 30 insertions(+), 10 deletions(-)

--- a/tools/testing/selftests/vm/ksm_tests.c~selftests-vm-add-ksm-huge-pages-merging-time-test
+++ a/tools/testing/selftests/vm/ksm_tests.c
@@ -5,6 +5,7 @@
 #include <time.h>
 #include <string.h>
 #include <numa.h>
+#include <err.h>
 
 #include "../kselftest.h"
 #include "../../../../include/vdso/time64.h"
@@ -34,7 +35,8 @@ enum ksm_test_name {
 	CHECK_KSM_ZERO_PAGE_MERGE,
 	CHECK_KSM_NUMA_MERGE,
 	KSM_MERGE_TIME,
-	KSM_COW_TIME
+	KSM_COW_TIME,
+	KSM_MERGE_TIME_HUGE_PAGES
 };
 
 static int ksm_write_sysfs(const char *file_path, unsigned long val)
@@ -100,6 +102,9 @@ static void print_help(void)
 	       " -P evaluate merging time and speed.\n"
 	       "    For this test, the size of duplicated memory area (in MiB)\n"
 	       "    must be provided using -s option\n"
+		   " -H evaluate merging time and speed of huge pages.\n"
+	       "    For this test, the size of duplicated memory area (in MiB)\n"
+	       "    must be provided using -s option\n"
 	       " -C evaluate the time required to break COW of merged pages.\n\n");
 
 	printf(" -a: specify the access protections of pages.\n"
@@ -118,10 +123,14 @@ static void print_help(void)
 	exit(0);
 }
 
-static void  *allocate_memory(void *ptr, int prot, int mapping, char data, size_t map_size)
+static void  *allocate_memory(void *ptr, int prot, int mapping, char data, size_t map_size,
+				 bool huge_page)
 {
 	void *map_ptr = mmap(ptr, map_size, PROT_WRITE, mapping, -1, 0);
 
+	if (huge_page && madvise(map_ptr, map_size, MADV_HUGEPAGE))
+		err(2, "MADV_HUGEPAGE");
+
 	if (!map_ptr) {
 		perror("mmap");
 		return NULL;
@@ -250,7 +259,7 @@ static int check_ksm_merge(int mapping,
 	}
 
 	/* fill pages with the same data and merge them */
-	map_ptr = allocate_memory(NULL, prot, mapping, '*', page_size * page_count);
+	map_ptr = allocate_memory(NULL, prot, mapping, '*', page_size * page_count, false);
 	if (!map_ptr)
 		return KSFT_FAIL;
 
@@ -282,7 +291,7 @@ static int check_ksm_unmerge(int mapping
 	}
 
 	/* fill pages with the same data and merge them */
-	map_ptr = allocate_memory(NULL, prot, mapping, '*', page_size * page_count);
+	map_ptr = allocate_memory(NULL, prot, mapping, '*', page_size * page_count, false);
 	if (!map_ptr)
 		return KSFT_FAIL;
 
@@ -325,7 +334,7 @@ static int check_ksm_zero_page_merge(int
 		return KSFT_FAIL;
 
 	/* fill pages with zero and try to merge them */
-	map_ptr = allocate_memory(NULL, prot, mapping, 0, page_size * page_count);
+	map_ptr = allocate_memory(NULL, prot, mapping, 0, page_size * page_count, false);
 	if (!map_ptr)
 		return KSFT_FAIL;
 
@@ -439,7 +448,7 @@ err_out:
 	return KSFT_FAIL;
 }
 
-static int ksm_merge_time(int mapping, int prot, int timeout, size_t map_size)
+static int ksm_merge_time(int mapping, int prot, int timeout, size_t map_size, bool huge_page)
 {
 	void *map_ptr;
 	struct timespec start_time, end_time;
@@ -447,7 +456,7 @@ static int ksm_merge_time(int mapping, i
 
 	map_size *= MB;
 
-	map_ptr = allocate_memory(NULL, prot, mapping, '*', map_size);
+	map_ptr = allocate_memory(NULL, prot, mapping, '*', map_size, huge_page);
 	if (!map_ptr)
 		return KSFT_FAIL;
 
@@ -489,7 +498,7 @@ static int ksm_cow_time(int mapping, int
 	/* page_count must be less than 2*page_size */
 	size_t page_count = 4000;
 
-	map_ptr = allocate_memory(NULL, prot, mapping, '*', page_size * page_count);
+	map_ptr = allocate_memory(NULL, prot, mapping, '*', page_size * page_count, false);
 	if (!map_ptr)
 		return KSFT_FAIL;
 
@@ -564,7 +573,7 @@ int main(int argc, char *argv[])
 	bool merge_across_nodes = KSM_MERGE_ACROSS_NODES_DEFAULT;
 	long size_MB = 0;
 
-	while ((opt = getopt(argc, argv, "ha:p:l:z:m:s:MUZNPC")) != -1) {
+	while ((opt = getopt(argc, argv, "ha:p:l:z:m:s:MUZNPCH")) != -1) {
 		switch (opt) {
 		case 'a':
 			prot = str_to_prot(optarg);
@@ -621,6 +630,9 @@ int main(int argc, char *argv[])
 		case 'C':
 			test_name = KSM_COW_TIME;
 			break;
+		case 'H':
+			test_name = KSM_MERGE_TIME_HUGE_PAGES;
+			break;
 		default:
 			return KSFT_FAIL;
 		}
@@ -668,12 +680,20 @@ int main(int argc, char *argv[])
 			return KSFT_FAIL;
 		}
 		ret = ksm_merge_time(MAP_PRIVATE | MAP_ANONYMOUS, prot, ksm_scan_limit_sec,
-				     size_MB);
+				     size_MB, false);
 		break;
 	case KSM_COW_TIME:
 		ret = ksm_cow_time(MAP_PRIVATE | MAP_ANONYMOUS, prot, ksm_scan_limit_sec,
 				   page_size);
 		break;
+	case KSM_MERGE_TIME_HUGE_PAGES:
+		if (size_MB == 0) {
+			printf("Option '-s' is required.\n");
+			return KSFT_FAIL;
+		}
+		ret = ksm_merge_time(MAP_PRIVATE | MAP_ANONYMOUS, prot, ksm_scan_limit_sec,
+				     size_MB, true);
+		break;
 	}
 
 	if (ksm_restore(&ksm_sysfs_old)) {
_

Patches currently in -mm which might be from pedrodemargomes@gmail.com are


