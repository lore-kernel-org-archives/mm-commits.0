Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6352C3DA7C
	for <mm-commits@archiver.kernel.org>; Fri, 30 Dec 2022 22:02:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235506AbiL3WCA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:02:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235715AbiL3WBr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 30 Dec 2022 17:01:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4600A19C37
        for <mm-commits@vger.kernel.org>; Fri, 30 Dec 2022 14:01:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D50E961C2E
        for <mm-commits@vger.kernel.org>; Fri, 30 Dec 2022 22:01:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36817C433D2;
        Fri, 30 Dec 2022 22:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1672437704;
        bh=+2TxSWeYappoOxaJut4GkbemvzvFJoEOIEKgWFAxWFA=;
        h=Date:To:From:Subject:From;
        b=o5WMdCTf2PGquQd3BwpTReBGgfDQvamRi3kA7nKg+Fe6F5fysFL7+ASIBMPiP+Epk
         m1rCJkdgKPGhA6J0YSzoaHkcFGrYJK+vfCvoYnz1xyVeboMGxwv4hCC0qxEsvkghc3
         MGkKa5zlrd4NNmbAMiXufCh3p52CI9EpStKHhIig=
Date:   Fri, 30 Dec 2022 14:01:43 -0800
To:     mm-commits@vger.kernel.org, yang.yang29@zte.com.cn,
        ran.xiaokai@zte.com.cn, jiang.xuexin@zte.com.cn,
        imbrenda@linux.ibm.com, david@redhat.com, xu.xin16@zte.com.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftest-add-testing-unsharing-and-counting-ksm-zero-page.patch added to mm-unstable branch
Message-Id: <20221230220144.36817C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftest: add testing unsharing and counting ksm zero page
has been added to the -mm mm-unstable branch.  Its filename is
     selftest-add-testing-unsharing-and-counting-ksm-zero-page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftest-add-testing-unsharing-and-counting-ksm-zero-page.patch

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
Subject: selftest: add testing unsharing and counting ksm zero page
Date: Fri, 30 Dec 2022 09:18:47 +0800 (CST)

Add a function test_unmerge_zero_page() to test the functionality on
unsharing and counting ksm-placed zero pages and counting of this patch
series.

test_unmerge_zero_page() actually contains three subjct test objects:
	1) whether the count of ksm zero page can react correctly to cow
	   (copy on write);
	2) whether the count of ksm zero page can react correctly to unmerge;
	3) whether ksm zero pages are really unmerged.

Link: https://lkml.kernel.org/r/202212300918477352037@zte.com.cn
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
Reviewed-by: Xiaokai Ran <ran.xiaokai@zte.com.cn>
Reviewed-by: Yang Yang <yang.yang29@zte.com.cn>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Xuexin Jiang <jiang.xuexin@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/tools/testing/selftests/vm/ksm_functional_tests.c~selftest-add-testing-unsharing-and-counting-ksm-zero-page
+++ a/tools/testing/selftests/vm/ksm_functional_tests.c
@@ -27,6 +27,8 @@
 
 static int ksm_fd;
 static int ksm_full_scans_fd;
+static int ksm_zero_pages_fd;
+static int ksm_use_zero_pages_fd;
 static int pagemap_fd;
 static size_t pagesize;
 
@@ -57,6 +59,22 @@ static bool range_maps_duplicates(char *
 	return false;
 }
 
+static bool check_ksm_zero_pages_count(unsigned long zero_size)
+{
+	unsigned long pages_expected = zero_size / (4 * KiB);
+	char buf[20];
+	ssize_t read_size;
+	unsigned long ksm_zero_pages;
+
+	read_size = pread(ksm_zero_pages_fd, buf, sizeof(buf) - 1, 0);
+	if (read_size < 0)
+		return -errno;
+	buf[read_size] = 0;
+	ksm_zero_pages = strtol(buf, NULL, 10);
+
+	return ksm_zero_pages == pages_expected;
+}
+
 static long ksm_get_full_scans(void)
 {
 	char buf[10];
@@ -70,15 +88,12 @@ static long ksm_get_full_scans(void)
 	return strtol(buf, NULL, 10);
 }
 
-static int ksm_merge(void)
+static int wait_two_full_scans(void)
 {
 	long start_scans, end_scans;
 
-	/* Wait for two full scans such that any possible merging happened. */
 	start_scans = ksm_get_full_scans();
 	if (start_scans < 0)
-		return start_scans;
-	if (write(ksm_fd, "1", 1) != 1)
 		return -errno;
 	do {
 		end_scans = ksm_get_full_scans();
@@ -89,6 +104,34 @@ static int ksm_merge(void)
 	return 0;
 }
 
+static inline int ksm_merge(void)
+{
+	/* Wait for two full scans such that any possible merging happened. */
+	if (write(ksm_fd, "1", 1) != 1)
+		return -errno;
+	return wait_two_full_scans();
+}
+
+static inline int make_cow(char *map, char val, unsigned long size)
+{
+
+	memset(map, val, size);
+	return wait_two_full_scans();
+}
+
+static int unmerge_zero_page(char *start, unsigned long size)
+{
+	int ret;
+
+	ret = madvise(start, size, MADV_UNMERGEABLE);
+	if (ret) {
+		ksft_test_result_fail("MADV_UNMERGEABLE failed\n");
+		return ret;
+	}
+
+	return wait_two_full_scans();
+}
+
 static char *mmap_and_merge_range(char val, unsigned long size)
 {
 	char *map;
@@ -146,6 +189,56 @@ unmap:
 	munmap(map, size);
 }
 
+static void test_unmerge_zero_pages(void)
+{
+	const unsigned int size = 2 * MiB;
+	char *map;
+
+	ksft_print_msg("[RUN] %s\n", __func__);
+
+	/* Confirm the interfaces*/
+	ksm_zero_pages_fd = open("/sys/kernel/mm/ksm/zero_pages_sharing", O_RDONLY);
+	if (ksm_zero_pages_fd < 0) {
+		ksft_test_result_skip("open(\"/sys/kernel/mm/ksm/zero_pages_sharing\") failed\n");
+		return;
+	}
+	ksm_use_zero_pages_fd = open("/sys/kernel/mm/ksm/use_zero_pages", O_RDWR);
+	if (ksm_use_zero_pages_fd < 0) {
+		ksft_test_result_skip("open \"/sys/kernel/mm/ksm/use_zero_pages\" failed\n");
+		return;
+	}
+	if (write(ksm_use_zero_pages_fd, "1", 1) != 1) {
+		ksft_test_result_skip("write \"/sys/kernel/mm/ksm/use_zero_pages\" failed\n");
+		return;
+	}
+
+	/* Mmap zero pages*/
+	map = mmap_and_merge_range(0x00, size);
+
+	/* Case 1: make Writing on ksm zero pages (COW) */
+	if (make_cow(map, 0xcf, size / 2)) {
+		ksft_test_result_fail("COW failed\n");
+		goto unmap;
+	}
+	ksft_test_result(check_ksm_zero_pages_count(size / 2),
+						"zero page count react to cow\n");
+
+	/* Case 2: Call madvise(xxx, MADV_UNMERGEABLE)*/
+	if (unmerge_zero_page(map + size / 2, size / 4)) {
+		ksft_test_result_fail("unmerge_zero_page failed\n");
+		goto unmap;
+	}
+	ksft_test_result(check_ksm_zero_pages_count(size / 4),
+						"zero page count react to unmerge\n");
+
+	/*Check if ksm pages are really unmerged */
+	ksft_test_result(!range_maps_duplicates(map + size / 2, size / 4),
+						"KSM zero pages were unmerged\n");
+
+unmap:
+	munmap(map, size);
+}
+
 static void test_unmerge_discarded(void)
 {
 	const unsigned int size = 2 * MiB;
@@ -261,11 +354,13 @@ int main(int argc, char **argv)
 	ksm_full_scans_fd = open("/sys/kernel/mm/ksm/full_scans", O_RDONLY);
 	if (ksm_full_scans_fd < 0)
 		ksft_exit_skip("open(\"/sys/kernel/mm/ksm/full_scans\") failed\n");
+
 	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
 	if (pagemap_fd < 0)
 		ksft_exit_skip("open(\"/proc/self/pagemap\") failed\n");
 
 	test_unmerge();
+	test_unmerge_zero_pages();
 	test_unmerge_discarded();
 #ifdef __NR_userfaultfd
 	test_unmerge_uffd_wp();
_

Patches currently in -mm which might be from xu.xin16@zte.com.cn are

ksm-abstract-the-function-try_to_get_old_rmap_item.patch
ksm-support-unsharing-zero-pages-placed-by-ksm.patch
ksm-count-all-zero-pages-placed-by-ksm.patch
ksm-count-zero-pages-for-each-process.patch
ksm-add-zero_pages_sharing-documentation.patch
selftest-add-testing-unsharing-and-counting-ksm-zero-page.patch

