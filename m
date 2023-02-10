Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EE98C636D7
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 22:40:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233425AbjBJWks (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Feb 2023 17:40:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233499AbjBJWkr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Feb 2023 17:40:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02F4A7395D
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 14:40:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9561B61EB7
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 22:40:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6029C433D2;
        Fri, 10 Feb 2023 22:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676068845;
        bh=n1AxrPTb+8eCakXJoDI1pnQTZ9BtcWvzh0j2Qg5iCJE=;
        h=Date:To:From:Subject:From;
        b=lPW5j2RIWRUtAbPscb21IqRmWztX6LRNO3Q4uVZaCMvPm8S69TIsCGgk9I/AO5JIg
         eU+Ruxkn+cmF5a/IMLLhB6mr9R9+QbVng5oyMVDPxH0/6dU7eJjFtuaPM59ilWr18H
         iHouK1soIEoNYlezTCELPJXgoUWAlrTlrgYdYgr0=
Date:   Fri, 10 Feb 2023 14:40:44 -0800
To:     mm-commits@vger.kernel.org, yang.yang29@zte.com.cn,
        ran.xiaokai@zte.com.cn, jiang.xuexin@zte.com.cn,
        imbrenda@linux.ibm.com, david@redhat.com, xu.xin16@zte.com.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftest-add-testing-unsharing-and-counting-ksm-zero-page-v6.patch added to mm-unstable branch
Message-Id: <20230210224044.E6029C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftest-add-testing-unsharing-and-counting-ksm-zero-page-v6
has been added to the -mm mm-unstable branch.  Its filename is
     selftest-add-testing-unsharing-and-counting-ksm-zero-page-v6.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftest-add-testing-unsharing-and-counting-ksm-zero-page-v6.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: xu xin <xu.xin16@zte.com.cn>
Subject: selftest-add-testing-unsharing-and-counting-ksm-zero-page-v6
Date: Fri, 10 Feb 2023 09:21:57 +0800 (CST)

v5->v6:
According to David's suggestions, the following changes are made:
1) Rename check_ksm_zero_pages_count() -> ksm_get_zero_pages(), and do the
   comparison outside.
2) Open all global fd from main() rather than the test case.
3) Remove COW-related test codes and focus on explicit unmerging here.
4) Add some coments to explain why wait_two_full_scans is required.
5) Clean up some unneed changes.

Link: https://lkml.kernel.org/r/202302100921574141612@zte.com.cn
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
Reviewed-by: Xiaokai Ran <ran.xiaokai@zte.com.cn>
Reviewed-by: Yang Yang <yang.yang29@zte.com.cn>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Xuexin Jiang <jiang.xuexin@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/tools/testing/selftests/mm/ksm_functional_tests.c~selftest-add-testing-unsharing-and-counting-ksm-zero-page-v6
+++ a/tools/testing/selftests/mm/ksm_functional_tests.c
@@ -24,6 +24,7 @@
 
 #define KiB 1024u
 #define MiB (1024 * KiB)
+#define PageSize (4 * KiB)
 
 static int ksm_fd;
 static int ksm_full_scans_fd;
@@ -59,9 +60,8 @@ static bool range_maps_duplicates(char *
 	return false;
 }
 
-static bool check_ksm_zero_pages_count(unsigned long zero_size)
+static long ksm_get_zero_pages(void)
 {
-	unsigned long pages_expected = zero_size / (4 * KiB);
 	char buf[20];
 	ssize_t read_size;
 	unsigned long ksm_zero_pages;
@@ -72,7 +72,7 @@ static bool check_ksm_zero_pages_count(u
 	buf[read_size] = 0;
 	ksm_zero_pages = strtol(buf, NULL, 10);
 
-	return ksm_zero_pages == pages_expected;
+	return ksm_zero_pages;
 }
 
 static long ksm_get_full_scans(void)
@@ -109,13 +109,7 @@ static inline int ksm_merge(void)
 	/* Wait for two full scans such that any possible merging happened. */
 	if (write(ksm_fd, "1", 1) != 1)
 		return -errno;
-	return wait_two_full_scans();
-}
 
-static inline int make_cow(char *map, char val, unsigned long size)
-{
-
-	memset(map, val, size);
 	return wait_two_full_scans();
 }
 
@@ -129,6 +123,12 @@ static int unmerge_zero_page(char *start
 		return ret;
 	}
 
+	/*
+	 * Wait for two full scans such that any possible unmerging of zero
+	 * pages happened. Why? Because the unmerge action of zero pages is not
+	 * done in the context of madvise(), but in the context of
+	 * unshare_zero_pages() of the ksmd thread.
+	 */
 	return wait_two_full_scans();
 }
 
@@ -193,16 +193,15 @@ static void test_unmerge_zero_pages(void
 {
 	const unsigned int size = 2 * MiB;
 	char *map;
+	unsigned long pages_expected;
 
 	ksft_print_msg("[RUN] %s\n", __func__);
 
 	/* Confirm the interfaces*/
-	ksm_zero_pages_fd = open("/sys/kernel/mm/ksm/zero_pages_sharing", O_RDONLY);
 	if (ksm_zero_pages_fd < 0) {
 		ksft_test_result_skip("open(\"/sys/kernel/mm/ksm/zero_pages_sharing\") failed\n");
 		return;
 	}
-	ksm_use_zero_pages_fd = open("/sys/kernel/mm/ksm/use_zero_pages", O_RDWR);
 	if (ksm_use_zero_pages_fd < 0) {
 		ksft_test_result_skip("open \"/sys/kernel/mm/ksm/use_zero_pages\" failed\n");
 		return;
@@ -214,27 +213,20 @@ static void test_unmerge_zero_pages(void
 
 	/* Mmap zero pages*/
 	map = mmap_and_merge_range(0x00, size);
+	if (map == MAP_FAILED)
+		return;
 
-	/* Case 1: make Writing on ksm zero pages (COW) */
-	if (make_cow(map, 0xcf, size / 2)) {
-		ksft_test_result_fail("COW failed\n");
+	if (unmerge_zero_page(map + size / 2, size / 2))
 		goto unmap;
-	}
-	ksft_test_result(check_ksm_zero_pages_count(size / 2),
-						"zero page count react to cow\n");
 
-	/* Case 2: Call madvise(xxx, MADV_UNMERGEABLE)*/
-	if (unmerge_zero_page(map + size / 2, size / 4)) {
-		ksft_test_result_fail("unmerge_zero_page failed\n");
-		goto unmap;
-	}
-	ksft_test_result(check_ksm_zero_pages_count(size / 4),
+	/* Check if zero_pages_sharing can be update correctly when unmerge */
+	pages_expected = (size / 2) / PageSize;
+	ksft_test_result(pages_expected == ksm_get_zero_pages(),
 						"zero page count react to unmerge\n");
 
-	/*Check if ksm pages are really unmerged */
-	ksft_test_result(!range_maps_duplicates(map + size / 2, size / 4),
+	/* Check if ksm zero pages are really unmerged */
+	ksft_test_result(!range_maps_duplicates(map + size / 2, size / 2),
 						"KSM zero pages were unmerged\n");
-
 unmap:
 	munmap(map, size);
 }
@@ -354,10 +346,11 @@ int main(int argc, char **argv)
 	ksm_full_scans_fd = open("/sys/kernel/mm/ksm/full_scans", O_RDONLY);
 	if (ksm_full_scans_fd < 0)
 		ksft_exit_skip("open(\"/sys/kernel/mm/ksm/full_scans\") failed\n");
-
 	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
 	if (pagemap_fd < 0)
 		ksft_exit_skip("open(\"/proc/self/pagemap\") failed\n");
+	ksm_zero_pages_fd = open("/sys/kernel/mm/ksm/zero_pages_sharing", O_RDONLY);
+	ksm_use_zero_pages_fd = open("/sys/kernel/mm/ksm/use_zero_pages", O_RDWR);
 
 	test_unmerge();
 	test_unmerge_zero_pages();
_

Patches currently in -mm which might be from xu.xin16@zte.com.cn are

ksm-abstract-the-function-try_to_get_old_rmap_item.patch
ksm-abstract-the-function-try_to_get_old_rmap_item-v6.patch
ksm-support-unsharing-zero-pages-placed-by-ksm.patch
ksm-count-all-zero-pages-placed-by-ksm.patch
ksm-count-zero-pages-for-each-process.patch
ksm-add-zero_pages_sharing-documentation.patch
selftest-add-testing-unsharing-and-counting-ksm-zero-page.patch
selftest-add-testing-unsharing-and-counting-ksm-zero-page-v6.patch

