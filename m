Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85007C04E69
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:00:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236779AbjHKXAD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:00:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231894AbjHKW7g (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 18:59:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B6623A85
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 15:59:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 095E2671E7
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 22:59:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58840C433C7;
        Fri, 11 Aug 2023 22:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794759;
        bh=8q6+B3yyKTF4YRKJimJ1TpOa2uLVTnGlxHwa7kcIzls=;
        h=Date:To:From:Subject:From;
        b=PKfR6SmVSQl4xZtNc6eR6h02POFvXVKefKjBxMIku2y1NvhlOVUOh0eqOB87ywat2
         92xho2yhvBMe/zy+AIfn89JXPmktVmpQABuINksCzgCnu3FqNGEDpCptiM8CvTtQAB
         bOuo6uliPYAnfPXZ0uxu44xry795o7+yspxeQ0OI=
Date:   Fri, 11 Aug 2023 15:59:18 -0700
To:     mm-commits@vger.kernel.org, yang.yang29@zte.com.cn,
        ran.xiaokai@zte.com.cn, jiang.xuexin@zte.com.cn,
        imbrenda@linux.ibm.com, david@redhat.com, xu.xin16@zte.com.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftest-add-a-testcase-of-ksm-zero-pages.patch removed from -mm tree
Message-Id: <20230811225919.58840C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftest: add a testcase of ksm zero pages
has been removed from the -mm tree.  Its filename was
     selftest-add-a-testcase-of-ksm-zero-pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: xu xin <xu.xin16@zte.com.cn>
Subject: selftest: add a testcase of ksm zero pages
Date: Tue, 13 Jun 2023 11:09:47 +0800

Add a function test_unmerge_zero_page() to test the functionality on
unsharing and counting ksm-placed zero pages and counting of this patch
series.

test_unmerge_zero_page() actually contains four subjct test objects:
(1) whether the count of ksm zero pages can update correctly after merging;
(2) whether the count of ksm zero pages can update correctly after
    unmerging by madvise(...MADV_UNMERGEABLE);
(3) whether the count of ksm zero pages can update correctly after
	unmerging by triggering write fault.
(4) whether ksm zero pages are really unmerged.

Link: https://lkml.kernel.org/r/20230613030947.186089-1-yang.yang29@zte.com.cn
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Xiaokai Ran <ran.xiaokai@zte.com.cn>
Reviewed-by: Yang Yang <yang.yang29@zte.com.cn>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Xuexin Jiang <jiang.xuexin@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/ksm_functional_tests.c |   98 +++++++++++-
 1 file changed, 97 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/ksm_functional_tests.c~selftest-add-a-testcase-of-ksm-zero-pages
+++ a/tools/testing/selftests/mm/ksm_functional_tests.c
@@ -29,6 +29,8 @@
 
 static int ksm_fd;
 static int ksm_full_scans_fd;
+static int proc_self_ksm_stat_fd;
+static int ksm_use_zero_pages_fd;
 static int pagemap_fd;
 static size_t pagesize;
 
@@ -59,6 +61,33 @@ static bool range_maps_duplicates(char *
 	return false;
 }
 
+static long get_my_ksm_zero_pages(void)
+{
+	char buf[200];
+	char *substr_ksm_zero;
+	size_t value_pos;
+	ssize_t read_size;
+	unsigned long my_ksm_zero_pages;
+
+	if (!proc_self_ksm_stat_fd)
+		return 0;
+
+	read_size = pread(proc_self_ksm_stat_fd, buf, sizeof(buf) - 1, 0);
+	if (read_size < 0)
+		return -errno;
+
+	buf[read_size] = 0;
+
+	substr_ksm_zero = strstr(buf, "ksm_zero_pages");
+	if (!substr_ksm_zero)
+		return 0;
+
+	value_pos = strcspn(substr_ksm_zero, "0123456789");
+	my_ksm_zero_pages = strtol(substr_ksm_zero + value_pos, NULL, 10);
+
+	return my_ksm_zero_pages;
+}
+
 static long ksm_get_full_scans(void)
 {
 	char buf[10];
@@ -159,6 +188,70 @@ unmap:
 	munmap(map, size);
 }
 
+static void test_unmerge_zero_pages(void)
+{
+	const unsigned int size = 2 * MiB;
+	char *map;
+	unsigned int offs;
+	unsigned long pages_expected;
+
+	ksft_print_msg("[RUN] %s\n", __func__);
+
+	if (proc_self_ksm_stat_fd < 0) {
+		ksft_test_result_skip("open(\"/proc/self/ksm_stat\") failed\n");
+		return;
+	}
+	if (ksm_use_zero_pages_fd < 0) {
+		ksft_test_result_skip("open \"/sys/kernel/mm/ksm/use_zero_pages\" failed\n");
+		return;
+	}
+	if (write(ksm_use_zero_pages_fd, "1", 1) != 1) {
+		ksft_test_result_skip("write \"/sys/kernel/mm/ksm/use_zero_pages\" failed\n");
+		return;
+	}
+
+	/* Let KSM deduplicate zero pages. */
+	map = mmap_and_merge_range(0x00, size, false);
+	if (map == MAP_FAILED)
+		return;
+
+	/* Check if ksm_zero_pages is updated correctly after KSM merging */
+	pages_expected = size / pagesize;
+	if (pages_expected != get_my_ksm_zero_pages()) {
+		ksft_test_result_fail("'ksm_zero_pages' updated after merging\n");
+		goto unmap;
+	}
+
+	/* Try to unmerge half of the region */
+	if (madvise(map, size / 2, MADV_UNMERGEABLE)) {
+		ksft_test_result_fail("MADV_UNMERGEABLE failed\n");
+		goto unmap;
+	}
+
+	/* Check if ksm_zero_pages is updated correctly after unmerging */
+	pages_expected /= 2;
+	if (pages_expected != get_my_ksm_zero_pages()) {
+		ksft_test_result_fail("'ksm_zero_pages' updated after unmerging\n");
+		goto unmap;
+	}
+
+	/* Trigger unmerging of the other half by writing to the pages. */
+	for (offs = size / 2; offs < size; offs += pagesize)
+		*((unsigned int *)&map[offs]) = offs;
+
+	/* Now we should have no zeropages remaining. */
+	if (get_my_ksm_zero_pages()) {
+		ksft_test_result_fail("'ksm_zero_pages' updated after write fault\n");
+		goto unmap;
+	}
+
+	/* Check if ksm zero pages are really unmerged */
+	ksft_test_result(!range_maps_duplicates(map, size),
+			"KSM zero pages were unmerged\n");
+unmap:
+	munmap(map, size);
+}
+
 static void test_unmerge_discarded(void)
 {
 	const unsigned int size = 2 * MiB;
@@ -358,7 +451,7 @@ unmap:
 
 int main(int argc, char **argv)
 {
-	unsigned int tests = 5;
+	unsigned int tests = 6;
 	int err;
 
 #ifdef __NR_userfaultfd
@@ -379,8 +472,11 @@ int main(int argc, char **argv)
 	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
 	if (pagemap_fd < 0)
 		ksft_exit_skip("open(\"/proc/self/pagemap\") failed\n");
+	proc_self_ksm_stat_fd = open("/proc/self/ksm_stat", O_RDONLY);
+	ksm_use_zero_pages_fd = open("/sys/kernel/mm/ksm/use_zero_pages", O_RDWR);
 
 	test_unmerge();
+	test_unmerge_zero_pages();
 	test_unmerge_discarded();
 #ifdef __NR_userfaultfd
 	test_unmerge_uffd_wp();
_

Patches currently in -mm which might be from xu.xin16@zte.com.cn are


