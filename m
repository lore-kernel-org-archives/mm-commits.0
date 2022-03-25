Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92F60C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:13:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353605AbiCYBPD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:15:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357195AbiCYBPC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:15:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57B071CB33
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:13:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B575C6187F
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:13:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D20FC340ED;
        Fri, 25 Mar 2022 01:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648170802;
        bh=ugxmKcwauGRBDKCLRAr6kw+JNfSoFi0qJVoQK/YWAKc=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=rrRaYDZU0kMo0cLzLhvU5v+VJX8Tbll4IvLpyjzZoccXXJ/oZnsn4knGjz4aWpA9x
         lXZ8jlHGOfI8pIPZs8c1sAqOKqezILHReNn8yrI/sawzprExhc3yYWRp1Jdw9p4CdQ
         aaKe/BMgmQQ3FR3OIOBfnZZlyqICEhaRU2UTmF74=
Date:   Thu, 24 Mar 2022 18:13:21 -0700
To:     skhan@linuxfoundation.org, rppt@kernel.org, peterx@redhat.com,
        naoya.horiguchi@linux.dev, mhocko@suse.com, david@redhat.com,
        axelrasmussen@google.com, almasrymina@google.com,
        aarcange@redhat.com, mike.kravetz@oracle.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 096/114] selftests/vm: add hugetlb madvise MADV_DONTNEED MADV_REMOVE test
Message-Id: <20220325011322.0D20FC340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: selftests/vm: add hugetlb madvise MADV_DONTNEED MADV_REMOVE test

Now that MADV_DONTNEED support for hugetlb is enabled, add corresponding
tests.  MADV_REMOVE has been enabled for some time, but no tests exist so
add them as well.

Link: https://lkml.kernel.org/r/20220215002348.128823-3-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/.gitignore        |    1 
 tools/testing/selftests/vm/Makefile          |    1 
 tools/testing/selftests/vm/hugetlb-madvise.c |  410 +++++++++++++++++
 tools/testing/selftests/vm/run_vmtests.sh    |   12 
 4 files changed, 424 insertions(+)

--- a/tools/testing/selftests/vm/.gitignore~selftests-vm-add-hugetlb-madvise-madv_dontneed-madv_remove-test
+++ a/tools/testing/selftests/vm/.gitignore
@@ -3,6 +3,7 @@ hugepage-mmap
 hugepage-mremap
 hugepage-shm
 hugepage-vmemmap
+hugetlb-madvise
 khugepaged
 map_hugetlb
 map_populate
--- /dev/null
+++ a/tools/testing/selftests/vm/hugetlb-madvise.c
@@ -0,0 +1,410 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * hugepage-madvise:
+ *
+ * Basic functional testing of madvise MADV_DONTNEED and MADV_REMOVE
+ * on hugetlb mappings.
+ *
+ * Before running this test, make sure the administrator has pre-allocated
+ * at least MIN_FREE_PAGES hugetlb pages and they are free.  In addition,
+ * the test takes an argument that is the path to a file in a hugetlbfs
+ * filesystem.  Therefore, a hugetlbfs filesystem must be mounted on some
+ * directory.
+ */
+
+#include <stdlib.h>
+#include <stdio.h>
+#include <unistd.h>
+#include <sys/mman.h>
+#define __USE_GNU
+#include <fcntl.h>
+
+#define USAGE	"USAGE: %s <hugepagefile_name>\n"
+#define MIN_FREE_PAGES	20
+#define NR_HUGE_PAGES	10	/* common number of pages to map/allocate */
+
+#define validate_free_pages(exp_free)					\
+	do {								\
+		int fhp = get_free_hugepages();				\
+		if (fhp != (exp_free)) {				\
+			printf("Unexpected number of free huge "	\
+				"pages line %d\n", __LINE__);		\
+			exit(1);					\
+		}							\
+	} while (0)
+
+unsigned long huge_page_size;
+unsigned long base_page_size;
+
+/*
+ * default_huge_page_size copied from mlock2-tests.c
+ */
+unsigned long default_huge_page_size(void)
+{
+	unsigned long hps = 0;
+	char *line = NULL;
+	size_t linelen = 0;
+	FILE *f = fopen("/proc/meminfo", "r");
+
+	if (!f)
+		return 0;
+	while (getline(&line, &linelen, f) > 0) {
+		if (sscanf(line, "Hugepagesize:       %lu kB", &hps) == 1) {
+			hps <<= 10;
+			break;
+		}
+	}
+
+	free(line);
+	fclose(f);
+	return hps;
+}
+
+unsigned long get_free_hugepages(void)
+{
+	unsigned long fhp = 0;
+	char *line = NULL;
+	size_t linelen = 0;
+	FILE *f = fopen("/proc/meminfo", "r");
+
+	if (!f)
+		return fhp;
+	while (getline(&line, &linelen, f) > 0) {
+		if (sscanf(line, "HugePages_Free:      %lu", &fhp) == 1)
+			break;
+	}
+
+	free(line);
+	fclose(f);
+	return fhp;
+}
+
+void write_fault_pages(void *addr, unsigned long nr_pages)
+{
+	unsigned long i;
+
+	for (i = 0; i < nr_pages; i++)
+		*((unsigned long *)(addr + (i * huge_page_size))) = i;
+}
+
+void read_fault_pages(void *addr, unsigned long nr_pages)
+{
+	unsigned long i, tmp;
+
+	for (i = 0; i < nr_pages; i++)
+		tmp += *((unsigned long *)(addr + (i * huge_page_size)));
+}
+
+int main(int argc, char **argv)
+{
+	unsigned long free_hugepages;
+	void *addr, *addr2;
+	int fd;
+	int ret;
+
+	if (argc != 2) {
+		printf(USAGE, argv[0]);
+		exit(1);
+	}
+
+	huge_page_size = default_huge_page_size();
+	if (!huge_page_size) {
+		printf("Unable to determine huge page size, exiting!\n");
+		exit(1);
+	}
+	base_page_size = sysconf(_SC_PAGE_SIZE);
+	if (!huge_page_size) {
+		printf("Unable to determine base page size, exiting!\n");
+		exit(1);
+	}
+
+	free_hugepages = get_free_hugepages();
+	if (free_hugepages < MIN_FREE_PAGES) {
+		printf("Not enough free huge pages to test, exiting!\n");
+		exit(1);
+	}
+
+	fd = open(argv[1], O_CREAT | O_RDWR, 0755);
+	if (fd < 0) {
+		perror("Open failed");
+		exit(1);
+	}
+
+	/*
+	 * Test validity of MADV_DONTNEED addr and length arguments.  mmap
+	 * size is NR_HUGE_PAGES + 2.  One page at the beginning and end of
+	 * the mapping will be unmapped so we KNOW there is nothing mapped
+	 * there.
+	 */
+	addr = mmap(NULL, (NR_HUGE_PAGES + 2) * huge_page_size,
+			PROT_READ | PROT_WRITE,
+			MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB,
+			-1, 0);
+	if (addr == MAP_FAILED) {
+		perror("mmap");
+		exit(1);
+	}
+	if (munmap(addr, huge_page_size) ||
+			munmap(addr + (NR_HUGE_PAGES + 1) * huge_page_size,
+				huge_page_size)) {
+		perror("munmap");
+		exit(1);
+	}
+	addr = addr + huge_page_size;
+
+	write_fault_pages(addr, NR_HUGE_PAGES);
+	validate_free_pages(free_hugepages - NR_HUGE_PAGES);
+
+	/* addr before mapping should fail */
+	ret = madvise(addr - base_page_size, NR_HUGE_PAGES * huge_page_size,
+		MADV_DONTNEED);
+	if (!ret) {
+		printf("Unexpected success of madvise call with invalid addr line %d\n",
+				__LINE__);
+			exit(1);
+	}
+
+	/* addr + length after mapping should fail */
+	ret = madvise(addr, (NR_HUGE_PAGES * huge_page_size) + base_page_size,
+		MADV_DONTNEED);
+	if (!ret) {
+		printf("Unexpected success of madvise call with invalid length line %d\n",
+				__LINE__);
+			exit(1);
+	}
+
+	(void)munmap(addr, NR_HUGE_PAGES * huge_page_size);
+
+	/*
+	 * Test alignment of MADV_DONTNEED addr and length arguments
+	 */
+	addr = mmap(NULL, NR_HUGE_PAGES * huge_page_size,
+			PROT_READ | PROT_WRITE,
+			MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB,
+			-1, 0);
+	if (addr == MAP_FAILED) {
+		perror("mmap");
+		exit(1);
+	}
+	write_fault_pages(addr, NR_HUGE_PAGES);
+	validate_free_pages(free_hugepages - NR_HUGE_PAGES);
+
+	/* addr is not huge page size aligned and should fail */
+	ret = madvise(addr + base_page_size,
+			NR_HUGE_PAGES * huge_page_size - base_page_size,
+			MADV_DONTNEED);
+	if (!ret) {
+		printf("Unexpected success of madvise call with unaligned start address %d\n",
+				__LINE__);
+			exit(1);
+	}
+
+	/* addr + length should be aligned up to huge page size */
+	if (madvise(addr,
+			((NR_HUGE_PAGES - 1) * huge_page_size) + base_page_size,
+			MADV_DONTNEED)) {
+		perror("madvise");
+		exit(1);
+	}
+
+	/* should free all pages in mapping */
+	validate_free_pages(free_hugepages);
+
+	(void)munmap(addr, NR_HUGE_PAGES * huge_page_size);
+
+	/*
+	 * Test MADV_DONTNEED on anonymous private mapping
+	 */
+	addr = mmap(NULL, NR_HUGE_PAGES * huge_page_size,
+			PROT_READ | PROT_WRITE,
+			MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB,
+			-1, 0);
+	if (addr == MAP_FAILED) {
+		perror("mmap");
+		exit(1);
+	}
+	write_fault_pages(addr, NR_HUGE_PAGES);
+	validate_free_pages(free_hugepages - NR_HUGE_PAGES);
+
+	if (madvise(addr, NR_HUGE_PAGES * huge_page_size, MADV_DONTNEED)) {
+		perror("madvise");
+		exit(1);
+	}
+
+	/* should free all pages in mapping */
+	validate_free_pages(free_hugepages);
+
+	(void)munmap(addr, NR_HUGE_PAGES * huge_page_size);
+
+	/*
+	 * Test MADV_DONTNEED on private mapping of hugetlb file
+	 */
+	if (fallocate(fd, 0, 0, NR_HUGE_PAGES * huge_page_size)) {
+		perror("fallocate");
+		exit(1);
+	}
+	validate_free_pages(free_hugepages - NR_HUGE_PAGES);
+
+	addr = mmap(NULL, NR_HUGE_PAGES * huge_page_size,
+			PROT_READ | PROT_WRITE,
+			MAP_PRIVATE, fd, 0);
+	if (addr == MAP_FAILED) {
+		perror("mmap");
+		exit(1);
+	}
+
+	/* read should not consume any pages */
+	read_fault_pages(addr, NR_HUGE_PAGES);
+	validate_free_pages(free_hugepages - NR_HUGE_PAGES);
+
+	/* madvise should not free any pages */
+	if (madvise(addr, NR_HUGE_PAGES * huge_page_size, MADV_DONTNEED)) {
+		perror("madvise");
+		exit(1);
+	}
+	validate_free_pages(free_hugepages - NR_HUGE_PAGES);
+
+	/* writes should allocate private pages */
+	write_fault_pages(addr, NR_HUGE_PAGES);
+	validate_free_pages(free_hugepages - (2 * NR_HUGE_PAGES));
+
+	/* madvise should free private pages */
+	if (madvise(addr, NR_HUGE_PAGES * huge_page_size, MADV_DONTNEED)) {
+		perror("madvise");
+		exit(1);
+	}
+	validate_free_pages(free_hugepages - NR_HUGE_PAGES);
+
+	/* writes should allocate private pages */
+	write_fault_pages(addr, NR_HUGE_PAGES);
+	validate_free_pages(free_hugepages - (2 * NR_HUGE_PAGES));
+
+	/*
+	 * The fallocate below certainly should free the pages associated
+	 * with the file.  However, pages in the private mapping are also
+	 * freed.  This is not the 'correct' behavior, but is expected
+	 * because this is how it has worked since the initial hugetlb
+	 * implementation.
+	 */
+	if (fallocate(fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
+					0, NR_HUGE_PAGES * huge_page_size)) {
+		perror("fallocate");
+		exit(1);
+	}
+	validate_free_pages(free_hugepages);
+
+	(void)munmap(addr, NR_HUGE_PAGES * huge_page_size);
+
+	/*
+	 * Test MADV_DONTNEED on shared mapping of hugetlb file
+	 */
+	if (fallocate(fd, 0, 0, NR_HUGE_PAGES * huge_page_size)) {
+		perror("fallocate");
+		exit(1);
+	}
+	validate_free_pages(free_hugepages - NR_HUGE_PAGES);
+
+	addr = mmap(NULL, NR_HUGE_PAGES * huge_page_size,
+			PROT_READ | PROT_WRITE,
+			MAP_SHARED, fd, 0);
+	if (addr == MAP_FAILED) {
+		perror("mmap");
+		exit(1);
+	}
+
+	/* write should not consume any pages */
+	write_fault_pages(addr, NR_HUGE_PAGES);
+	validate_free_pages(free_hugepages - NR_HUGE_PAGES);
+
+	/* madvise should not free any pages */
+	if (madvise(addr, NR_HUGE_PAGES * huge_page_size, MADV_DONTNEED)) {
+		perror("madvise");
+		exit(1);
+	}
+	validate_free_pages(free_hugepages - NR_HUGE_PAGES);
+
+	/*
+	 * Test MADV_REMOVE on shared mapping of hugetlb file
+	 *
+	 * madvise is same as hole punch and should free all pages.
+	 */
+	if (madvise(addr, NR_HUGE_PAGES * huge_page_size, MADV_REMOVE)) {
+		perror("madvise");
+		exit(1);
+	}
+	validate_free_pages(free_hugepages);
+	(void)munmap(addr, NR_HUGE_PAGES * huge_page_size);
+
+	/*
+	 * Test MADV_REMOVE on shared and private mapping of hugetlb file
+	 */
+	if (fallocate(fd, 0, 0, NR_HUGE_PAGES * huge_page_size)) {
+		perror("fallocate");
+		exit(1);
+	}
+	validate_free_pages(free_hugepages - NR_HUGE_PAGES);
+
+	addr = mmap(NULL, NR_HUGE_PAGES * huge_page_size,
+			PROT_READ | PROT_WRITE,
+			MAP_SHARED, fd, 0);
+	if (addr == MAP_FAILED) {
+		perror("mmap");
+		exit(1);
+	}
+
+	/* shared write should not consume any additional pages */
+	write_fault_pages(addr, NR_HUGE_PAGES);
+	validate_free_pages(free_hugepages - NR_HUGE_PAGES);
+
+	addr2 = mmap(NULL, NR_HUGE_PAGES * huge_page_size,
+			PROT_READ | PROT_WRITE,
+			MAP_PRIVATE, fd, 0);
+	if (addr2 == MAP_FAILED) {
+		perror("mmap");
+		exit(1);
+	}
+
+	/* private read should not consume any pages */
+	read_fault_pages(addr2, NR_HUGE_PAGES);
+	validate_free_pages(free_hugepages - NR_HUGE_PAGES);
+
+	/* private write should consume additional pages */
+	write_fault_pages(addr2, NR_HUGE_PAGES);
+	validate_free_pages(free_hugepages - (2 * NR_HUGE_PAGES));
+
+	/* madvise of shared mapping should not free any pages */
+	if (madvise(addr, NR_HUGE_PAGES * huge_page_size, MADV_DONTNEED)) {
+		perror("madvise");
+		exit(1);
+	}
+	validate_free_pages(free_hugepages - (2 * NR_HUGE_PAGES));
+
+	/* madvise of private mapping should free private pages */
+	if (madvise(addr2, NR_HUGE_PAGES * huge_page_size, MADV_DONTNEED)) {
+		perror("madvise");
+		exit(1);
+	}
+	validate_free_pages(free_hugepages - NR_HUGE_PAGES);
+
+	/* private write should consume additional pages again */
+	write_fault_pages(addr2, NR_HUGE_PAGES);
+	validate_free_pages(free_hugepages - (2 * NR_HUGE_PAGES));
+
+	/*
+	 * madvise should free both file and private pages although this is
+	 * not correct.  private pages should not be freed, but this is
+	 * expected.  See comment associated with FALLOC_FL_PUNCH_HOLE call.
+	 */
+	if (madvise(addr, NR_HUGE_PAGES * huge_page_size, MADV_REMOVE)) {
+		perror("madvise");
+		exit(1);
+	}
+	validate_free_pages(free_hugepages);
+
+	(void)munmap(addr, NR_HUGE_PAGES * huge_page_size);
+	(void)munmap(addr2, NR_HUGE_PAGES * huge_page_size);
+
+	close(fd);
+	unlink(argv[1]);
+	return 0;
+}
--- a/tools/testing/selftests/vm/Makefile~selftests-vm-add-hugetlb-madvise-madv_dontneed-madv_remove-test
+++ a/tools/testing/selftests/vm/Makefile
@@ -30,6 +30,7 @@ LDLIBS = -lrt -lpthread
 TEST_GEN_FILES = compaction_test
 TEST_GEN_FILES += gup_test
 TEST_GEN_FILES += hmm-tests
+TEST_GEN_FILES += hugetlb-madvise
 TEST_GEN_FILES += hugepage-mmap
 TEST_GEN_FILES += hugepage-mremap
 TEST_GEN_FILES += hugepage-shm
--- a/tools/testing/selftests/vm/run_vmtests.sh~selftests-vm-add-hugetlb-madvise-madv_dontneed-madv_remove-test
+++ a/tools/testing/selftests/vm/run_vmtests.sh
@@ -131,6 +131,18 @@ else
 	echo "[PASS]"
 fi
 
+echo "-----------------------"
+echo "running hugetlb-madvise"
+echo "-----------------------"
+./hugetlb-madvise $mnt/madvise-test
+if [ $? -ne 0 ]; then
+	echo "[FAIL]"
+	exitcode=1
+else
+	echo "[PASS]"
+fi
+rm -f $mnt/madvise-test
+
 echo "NOTE: The above hugetlb tests provide minimal coverage.  Use"
 echo "      https://github.com/libhugetlbfs/libhugetlbfs.git for"
 echo "      hugetlb regression testing."
_
