Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC745EB64D9
	for <mm-commits@archiver.kernel.org>; Fri,  7 Jul 2023 21:06:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232628AbjGGVGQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Jul 2023 17:06:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232729AbjGGVGL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Jul 2023 17:06:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E2F1268E
        for <mm-commits@vger.kernel.org>; Fri,  7 Jul 2023 14:06:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED61D61A51
        for <mm-commits@vger.kernel.org>; Fri,  7 Jul 2023 21:06:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 535B7C433C8;
        Fri,  7 Jul 2023 21:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688763967;
        bh=RZ2UkLxQ7nPHI9rtEqIWWb79XDPJZ8uC4p9gy4rhjU8=;
        h=Date:To:From:Subject:From;
        b=FaQtnj5o6ZmOPVRNGR497HqSgd2rV+FtVenlrfj0fQZXQsOjccr/tZE3a7+npjQKv
         HFX3LcokU3c0AdMiCkv7rm5vrNQAaITYdNyTQ144wLXpJjbjBCoE/CkbDVkSsK4wb/
         KDYkmzLrrSxDffArp9wfKMFHY5U/MRLYiIuYKGM4=
Date:   Fri, 07 Jul 2023 14:06:05 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, shy828301@gmail.com,
        naoya.horiguchi@nec.com, mike.kravetz@oracle.com,
        linmiaohe@huawei.com, jthoughton@google.com,
        axelrasmussen@google.com, jiaqiyan@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-add-tests-for-hwpoison-hugetlbfs-read.patch added to mm-unstable branch
Message-Id: <20230707210607.535B7C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mm: add tests for HWPOISON hugetlbfs read
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-add-tests-for-hwpoison-hugetlbfs-read.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-add-tests-for-hwpoison-hugetlbfs-read.patch

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
From: Jiaqi Yan <jiaqiyan@google.com>
Subject: selftests/mm: add tests for HWPOISON hugetlbfs read
Date: Fri, 7 Jul 2023 20:19:04 +0000

Add tests for the improvement made to read operation on HWPOISON
hugetlb page with different read granularities. For each chunk size,
three read scenarios are tested:
1. Simple regression test on read without HWPOISON.
2. Sequential read page by page should succeed until encounters the 1st
   raw HWPOISON subpage.
3. After skip a raw HWPOISON subpage by lseek, read()s always succeed.

Link: https://lkml.kernel.org/r/20230707201904.953262-5-jiaqiyan@google.com
Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
Acked-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/.gitignore              |    1 
 tools/testing/selftests/mm/Makefile                |    1 
 tools/testing/selftests/mm/hugetlb-read-hwpoison.c |  322 +++++++++++
 3 files changed, 324 insertions(+)

--- a/tools/testing/selftests/mm/.gitignore~selftests-mm-add-tests-for-hwpoison-hugetlbfs-read
+++ a/tools/testing/selftests/mm/.gitignore
@@ -5,6 +5,7 @@ hugepage-mremap
 hugepage-shm
 hugepage-vmemmap
 hugetlb-madvise
+hugetlb-read-hwpoison
 khugepaged
 map_hugetlb
 map_populate
--- /dev/null
+++ a/tools/testing/selftests/mm/hugetlb-read-hwpoison.c
@@ -0,0 +1,322 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#define _GNU_SOURCE
+#include <stdlib.h>
+#include <stdio.h>
+#include <string.h>
+
+#include <linux/magic.h>
+#include <sys/mman.h>
+#include <sys/statfs.h>
+#include <errno.h>
+#include <stdbool.h>
+
+#include "../kselftest.h"
+
+#define PREFIX " ... "
+#define ERROR_PREFIX " !!! "
+
+#define MAX_WRITE_READ_CHUNK_SIZE (getpagesize() * 16)
+#define MAX(a, b) (((a) > (b)) ? (a) : (b))
+
+enum test_status {
+	TEST_PASSED = 0,
+	TEST_FAILED = 1,
+	TEST_SKIPPED = 2,
+};
+
+static char *status_to_str(enum test_status status)
+{
+	switch (status) {
+	case TEST_PASSED:
+		return "TEST_PASSED";
+	case TEST_FAILED:
+		return "TEST_FAILED";
+	case TEST_SKIPPED:
+		return "TEST_SKIPPED";
+	default:
+		return "TEST_???";
+	}
+}
+
+static int setup_filemap(char *filemap, size_t len, size_t wr_chunk_size)
+{
+	char iter = 0;
+
+	for (size_t offset = 0; offset < len;
+	     offset += wr_chunk_size) {
+		iter++;
+		memset(filemap + offset, iter, wr_chunk_size);
+	}
+
+	return 0;
+}
+
+static bool verify_chunk(char *buf, size_t len, char val)
+{
+	size_t i;
+
+	for (i = 0; i < len; ++i) {
+		if (buf[i] != val) {
+			printf(PREFIX ERROR_PREFIX "check fail: buf[%lu] = %u != %u\n",
+				i, buf[i], val);
+			return false;
+		}
+	}
+
+	return true;
+}
+
+static bool seek_read_hugepage_filemap(int fd, size_t len, size_t wr_chunk_size,
+				       off_t offset, size_t expected)
+{
+	char buf[MAX_WRITE_READ_CHUNK_SIZE];
+	ssize_t ret_count = 0;
+	ssize_t total_ret_count = 0;
+	char val = offset / wr_chunk_size + offset % wr_chunk_size;
+
+	printf(PREFIX PREFIX "init val=%u with offset=0x%lx\n", val, offset);
+	printf(PREFIX PREFIX "expect to read 0x%lx bytes of data in total\n",
+	       expected);
+	if (lseek(fd, offset, SEEK_SET) < 0) {
+		perror(PREFIX ERROR_PREFIX "seek failed");
+		return false;
+	}
+
+	while (offset + total_ret_count < len) {
+		ret_count = read(fd, buf, wr_chunk_size);
+		if (ret_count == 0) {
+			printf(PREFIX PREFIX "read reach end of the file\n");
+			break;
+		} else if (ret_count < 0) {
+			perror(PREFIX ERROR_PREFIX "read failed");
+			break;
+		}
+		++val;
+		if (!verify_chunk(buf, ret_count, val))
+			return false;
+
+		total_ret_count += ret_count;
+	}
+	printf(PREFIX PREFIX "actually read 0x%lx bytes of data in total\n",
+	       total_ret_count);
+
+	return total_ret_count == expected;
+}
+
+static bool read_hugepage_filemap(int fd, size_t len,
+				  size_t wr_chunk_size, size_t expected)
+{
+	char buf[MAX_WRITE_READ_CHUNK_SIZE];
+	ssize_t ret_count = 0;
+	ssize_t total_ret_count = 0;
+	char val = 0;
+
+	printf(PREFIX PREFIX "expect to read 0x%lx bytes of data in total\n",
+	       expected);
+	while (total_ret_count < len) {
+		ret_count = read(fd, buf, wr_chunk_size);
+		if (ret_count == 0) {
+			printf(PREFIX PREFIX "read reach end of the file\n");
+			break;
+		} else if (ret_count < 0) {
+			perror(PREFIX ERROR_PREFIX "read failed");
+			break;
+		}
+		++val;
+		if (!verify_chunk(buf, ret_count, val))
+			return false;
+
+		total_ret_count += ret_count;
+	}
+	printf(PREFIX PREFIX "actually read 0x%lx bytes of data in total\n",
+	       total_ret_count);
+
+	return total_ret_count == expected;
+}
+
+static enum test_status
+test_hugetlb_read(int fd, size_t len, size_t wr_chunk_size)
+{
+	enum test_status status = TEST_SKIPPED;
+	char *filemap = NULL;
+
+	if (ftruncate(fd, len) < 0) {
+		perror(PREFIX ERROR_PREFIX "ftruncate failed");
+		return status;
+	}
+
+	filemap = mmap(NULL, len, PROT_READ | PROT_WRITE,
+		       MAP_SHARED | MAP_POPULATE, fd, 0);
+	if (filemap == MAP_FAILED) {
+		perror(PREFIX ERROR_PREFIX "mmap for primary mapping failed");
+		goto done;
+	}
+
+	setup_filemap(filemap, len, wr_chunk_size);
+	status = TEST_FAILED;
+
+	if (read_hugepage_filemap(fd, len, wr_chunk_size, len))
+		status = TEST_PASSED;
+
+	munmap(filemap, len);
+done:
+	if (ftruncate(fd, 0) < 0) {
+		perror(PREFIX ERROR_PREFIX "ftruncate back to 0 failed");
+		status = TEST_FAILED;
+	}
+
+	return status;
+}
+
+static enum test_status
+test_hugetlb_read_hwpoison(int fd, size_t len, size_t wr_chunk_size,
+			   bool skip_hwpoison_page)
+{
+	enum test_status status = TEST_SKIPPED;
+	char *filemap = NULL;
+	char *hwp_addr = NULL;
+	const unsigned long pagesize = getpagesize();
+
+	if (ftruncate(fd, len) < 0) {
+		perror(PREFIX ERROR_PREFIX "ftruncate failed");
+		return status;
+	}
+
+	filemap = mmap(NULL, len, PROT_READ | PROT_WRITE,
+		       MAP_SHARED | MAP_POPULATE, fd, 0);
+	if (filemap == MAP_FAILED) {
+		perror(PREFIX ERROR_PREFIX "mmap for primary mapping failed");
+		goto done;
+	}
+
+	setup_filemap(filemap, len, wr_chunk_size);
+	status = TEST_FAILED;
+
+	/*
+	 * Poisoned hugetlb page layout (assume hugepagesize=2MB):
+	 * |<---------------------- 1MB ---------------------->|
+	 * |<---- healthy page ---->|<---- HWPOISON page ----->|
+	 * |<------------------- (1MB - 8KB) ----------------->|
+	 */
+	hwp_addr = filemap + len / 2 + pagesize;
+	if (madvise(hwp_addr, pagesize, MADV_HWPOISON) < 0) {
+		perror(PREFIX ERROR_PREFIX "MADV_HWPOISON failed");
+		goto unmap;
+	}
+
+	if (!skip_hwpoison_page) {
+		/*
+		 * Userspace should be able to read (1MB + 1 page) from
+		 * the beginning of the HWPOISONed hugepage.
+		 */
+		if (read_hugepage_filemap(fd, len, wr_chunk_size,
+					  len / 2 + pagesize))
+			status = TEST_PASSED;
+	} else {
+		/*
+		 * Userspace should be able to read (1MB - 2 pages) from
+		 * HWPOISONed hugepage.
+		 */
+		if (seek_read_hugepage_filemap(fd, len, wr_chunk_size,
+					       len / 2 + MAX(2 * pagesize, wr_chunk_size),
+					       len / 2 - MAX(2 * pagesize, wr_chunk_size)))
+			status = TEST_PASSED;
+	}
+
+unmap:
+	munmap(filemap, len);
+done:
+	if (ftruncate(fd, 0) < 0) {
+		perror(PREFIX ERROR_PREFIX "ftruncate back to 0 failed");
+		status = TEST_FAILED;
+	}
+
+	return status;
+}
+
+static int create_hugetlbfs_file(struct statfs *file_stat)
+{
+	int fd;
+
+	fd = memfd_create("hugetlb_tmp", MFD_HUGETLB);
+	if (fd < 0) {
+		perror(PREFIX ERROR_PREFIX "could not open hugetlbfs file");
+		return -1;
+	}
+
+	memset(file_stat, 0, sizeof(*file_stat));
+	if (fstatfs(fd, file_stat)) {
+		perror(PREFIX ERROR_PREFIX "fstatfs failed");
+		goto close;
+	}
+	if (file_stat->f_type != HUGETLBFS_MAGIC) {
+		printf(PREFIX ERROR_PREFIX "not hugetlbfs file\n");
+		goto close;
+	}
+
+	return fd;
+close:
+	close(fd);
+	return -1;
+}
+
+int main(void)
+{
+	int fd;
+	struct statfs file_stat;
+	enum test_status status;
+	/* Test read() in different granularity. */
+	size_t wr_chunk_sizes[] = {
+		getpagesize() / 2, getpagesize(),
+		getpagesize() * 2, getpagesize() * 4
+	};
+	size_t i;
+
+	for (i = 0; i < ARRAY_SIZE(wr_chunk_sizes); ++i) {
+		printf("Write/read chunk size=0x%lx\n",
+		       wr_chunk_sizes[i]);
+
+		fd = create_hugetlbfs_file(&file_stat);
+		if (fd < 0)
+			goto create_failure;
+		printf(PREFIX "HugeTLB read regression test...\n");
+		status = test_hugetlb_read(fd, file_stat.f_bsize,
+					   wr_chunk_sizes[i]);
+		printf(PREFIX "HugeTLB read regression test...%s\n",
+		       status_to_str(status));
+		close(fd);
+		if (status == TEST_FAILED)
+			return -1;
+
+		fd = create_hugetlbfs_file(&file_stat);
+		if (fd < 0)
+			goto create_failure;
+		printf(PREFIX "HugeTLB read HWPOISON test...\n");
+		status = test_hugetlb_read_hwpoison(fd, file_stat.f_bsize,
+						    wr_chunk_sizes[i], false);
+		printf(PREFIX "HugeTLB read HWPOISON test...%s\n",
+		       status_to_str(status));
+		close(fd);
+		if (status == TEST_FAILED)
+			return -1;
+
+		fd = create_hugetlbfs_file(&file_stat);
+		if (fd < 0)
+			goto create_failure;
+		printf(PREFIX "HugeTLB seek then read HWPOISON test...\n");
+		status = test_hugetlb_read_hwpoison(fd, file_stat.f_bsize,
+						    wr_chunk_sizes[i], true);
+		printf(PREFIX "HugeTLB seek then read HWPOISON test...%s\n",
+		       status_to_str(status));
+		close(fd);
+		if (status == TEST_FAILED)
+			return -1;
+	}
+
+	return 0;
+
+create_failure:
+	printf(ERROR_PREFIX "Abort test: failed to create hugetlbfs file\n");
+	return -1;
+}
--- a/tools/testing/selftests/mm/Makefile~selftests-mm-add-tests-for-hwpoison-hugetlbfs-read
+++ a/tools/testing/selftests/mm/Makefile
@@ -41,6 +41,7 @@ TEST_GEN_PROGS += gup_longterm
 TEST_GEN_PROGS += gup_test
 TEST_GEN_PROGS += hmm-tests
 TEST_GEN_PROGS += hugetlb-madvise
+TEST_GEN_PROGS += hugetlb-read-hwpoison
 TEST_GEN_PROGS += hugepage-mmap
 TEST_GEN_PROGS += hugepage-mremap
 TEST_GEN_PROGS += hugepage-shm
_

Patches currently in -mm which might be from jiaqiyan@google.com are

mm-hwpoison-delete-all-entries-before-traversal-in-__folio_free_raw_hwp.patch
mm-hwpoison-check-if-a-subpage-of-a-hugetlb-folio-is-raw-hwpoison.patch
hugetlbfs-improve-read-hwpoison-hugepage.patch
selftests-mm-add-tests-for-hwpoison-hugetlbfs-read.patch

