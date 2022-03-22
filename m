Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A78E9C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:45:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230172AbiCVVrD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:47:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236451AbiCVVqo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:46:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 459D05F8FC
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:45:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 839816149F
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:45:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDC56C340F2;
        Tue, 22 Mar 2022 21:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985510;
        bh=q4zS/1ME6Kub7gmvh3UfUF6RtdaBL0kzq9W6jVdq3aM=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=or33exVIOlX8MT0MV8rGdpTvKYCn908k4NnSg0dDIOH7BEr+UCUiqyNGLyjkQtNUc
         P7iY/K2lbrCtOZLHJec7j4hNiA7LbHQfCee1MPWhaQphVCx4S2YJtXt9cu0RlVWNvG
         nes3TTU445epqRBViiG2XUUFgO2pBnPcPtmpYCAc=
Date:   Tue, 22 Mar 2022 14:45:09 -0700
To:     zhengqi.arch@bytedance.com, willy@infradead.org,
        song.bao.hua@hisilicon.com, osalvador@suse.de,
        mike.kravetz@oracle.com, mhocko@suse.com, fam.zheng@bytedance.com,
        duanxiongchun@bytedance.com, david@redhat.com, corbet@lwn.net,
        chenhuang5@huawei.com, bodeddub@amazon.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 131/227] selftests: vm: add a hugetlb test case
Message-Id: <20220322214509.DDC56C340F2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>
Subject: selftests: vm: add a hugetlb test case

Since the head vmemmap page frame associated with each HugeTLB page is
reused, we should hide the PG_head flag of tail struct page from the user.
Add a tese case to check whether it is work properly.  The test steps are
as follows.

  1) alloc 2MB hugeTLB
  2) get each page frame
  3) apply those APIs in each page frame
  4) Those APIs work completely the same as before.

Reading the flags of a page by /proc/kpageflags is done in
stable_page_flags(), which has invoked PageHead(), PageTail(),
PageCompound() and compound_head().  If those APIs work properly, the head
page must have 15 and 17 bits set.  And tail pages must have 16 and 17
bits set but 15 bit unset.  Those flags are checked in check_page_flags().

Link: https://lkml.kernel.org/r/20211101031651.75851-5-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Barry Song <song.bao.hua@hisilicon.com>
Cc: Bodeddula Balasubramaniam <bodeddub@amazon.com>
Cc: Chen Huang <chenhuang5@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Fam Zheng <fam.zheng@bytedance.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/.gitignore         |    1 
 tools/testing/selftests/vm/Makefile           |    1 
 tools/testing/selftests/vm/hugepage-vmemmap.c |  144 ++++++++++++++++
 tools/testing/selftests/vm/run_vmtests.sh     |   11 +
 4 files changed, 157 insertions(+)

--- a/tools/testing/selftests/vm/.gitignore~selftests-vm-add-a-hugetlb-test-case
+++ a/tools/testing/selftests/vm/.gitignore
@@ -2,6 +2,7 @@
 hugepage-mmap
 hugepage-mremap
 hugepage-shm
+hugepage-vmemmap
 khugepaged
 map_hugetlb
 map_populate
--- /dev/null
+++ a/tools/testing/selftests/vm/hugepage-vmemmap.c
@@ -0,0 +1,144 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * A test case of using hugepage memory in a user application using the
+ * mmap system call with MAP_HUGETLB flag.  Before running this program
+ * make sure the administrator has allocated enough default sized huge
+ * pages to cover the 2 MB allocation.
+ */
+#include <stdlib.h>
+#include <stdio.h>
+#include <unistd.h>
+#include <sys/mman.h>
+#include <fcntl.h>
+
+#define MAP_LENGTH		(2UL * 1024 * 1024)
+
+#ifndef MAP_HUGETLB
+#define MAP_HUGETLB		0x40000	/* arch specific */
+#endif
+
+#define PAGE_SIZE		4096
+
+#define PAGE_COMPOUND_HEAD	(1UL << 15)
+#define PAGE_COMPOUND_TAIL	(1UL << 16)
+#define PAGE_HUGE		(1UL << 17)
+
+#define HEAD_PAGE_FLAGS		(PAGE_COMPOUND_HEAD | PAGE_HUGE)
+#define TAIL_PAGE_FLAGS		(PAGE_COMPOUND_TAIL | PAGE_HUGE)
+
+#define PM_PFRAME_BITS		55
+#define PM_PFRAME_MASK		~((1UL << PM_PFRAME_BITS) - 1)
+
+/*
+ * For ia64 architecture, Linux kernel reserves Region number 4 for hugepages.
+ * That means the addresses starting with 0x800000... will need to be
+ * specified.  Specifying a fixed address is not required on ppc64, i386
+ * or x86_64.
+ */
+#ifdef __ia64__
+#define MAP_ADDR		(void *)(0x8000000000000000UL)
+#define MAP_FLAGS		(MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB | MAP_FIXED)
+#else
+#define MAP_ADDR		NULL
+#define MAP_FLAGS		(MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB)
+#endif
+
+static void write_bytes(char *addr, size_t length)
+{
+	unsigned long i;
+
+	for (i = 0; i < length; i++)
+		*(addr + i) = (char)i;
+}
+
+static unsigned long virt_to_pfn(void *addr)
+{
+	int fd;
+	unsigned long pagemap;
+
+	fd = open("/proc/self/pagemap", O_RDONLY);
+	if (fd < 0)
+		return -1UL;
+
+	lseek(fd, (unsigned long)addr / PAGE_SIZE * sizeof(pagemap), SEEK_SET);
+	read(fd, &pagemap, sizeof(pagemap));
+	close(fd);
+
+	return pagemap & ~PM_PFRAME_MASK;
+}
+
+static int check_page_flags(unsigned long pfn)
+{
+	int fd, i;
+	unsigned long pageflags;
+
+	fd = open("/proc/kpageflags", O_RDONLY);
+	if (fd < 0)
+		return -1;
+
+	lseek(fd, pfn * sizeof(pageflags), SEEK_SET);
+
+	read(fd, &pageflags, sizeof(pageflags));
+	if ((pageflags & HEAD_PAGE_FLAGS) != HEAD_PAGE_FLAGS) {
+		close(fd);
+		printf("Head page flags (%lx) is invalid\n", pageflags);
+		return -1;
+	}
+
+	/*
+	 * pages other than the first page must be tail and shouldn't be head;
+	 * this also verifies kernel has correctly set the fake page_head to tail
+	 * while hugetlb_free_vmemmap is enabled.
+	 */
+	for (i = 1; i < MAP_LENGTH / PAGE_SIZE; i++) {
+		read(fd, &pageflags, sizeof(pageflags));
+		if ((pageflags & TAIL_PAGE_FLAGS) != TAIL_PAGE_FLAGS ||
+		    (pageflags & HEAD_PAGE_FLAGS) == HEAD_PAGE_FLAGS) {
+			close(fd);
+			printf("Tail page flags (%lx) is invalid\n", pageflags);
+			return -1;
+		}
+	}
+
+	close(fd);
+
+	return 0;
+}
+
+int main(int argc, char **argv)
+{
+	void *addr;
+	unsigned long pfn;
+
+	addr = mmap(MAP_ADDR, MAP_LENGTH, PROT_READ | PROT_WRITE, MAP_FLAGS, -1, 0);
+	if (addr == MAP_FAILED) {
+		perror("mmap");
+		exit(1);
+	}
+
+	/* Trigger allocation of HugeTLB page. */
+	write_bytes(addr, MAP_LENGTH);
+
+	pfn = virt_to_pfn(addr);
+	if (pfn == -1UL) {
+		munmap(addr, MAP_LENGTH);
+		perror("virt_to_pfn");
+		exit(1);
+	}
+
+	printf("Returned address is %p whose pfn is %lx\n", addr, pfn);
+
+	if (check_page_flags(pfn) < 0) {
+		munmap(addr, MAP_LENGTH);
+		perror("check_page_flags");
+		exit(1);
+	}
+
+	/* munmap() length of MAP_HUGETLB memory must be hugepage aligned */
+	if (munmap(addr, MAP_LENGTH)) {
+		perror("munmap");
+		exit(1);
+	}
+
+	return 0;
+}
--- a/tools/testing/selftests/vm/Makefile~selftests-vm-add-a-hugetlb-test-case
+++ a/tools/testing/selftests/vm/Makefile
@@ -33,6 +33,7 @@ TEST_GEN_FILES += hmm-tests
 TEST_GEN_FILES += hugepage-mmap
 TEST_GEN_FILES += hugepage-mremap
 TEST_GEN_FILES += hugepage-shm
+TEST_GEN_FILES += hugepage-vmemmap
 TEST_GEN_FILES += khugepaged
 TEST_GEN_FILES += madv_populate
 TEST_GEN_FILES += map_fixed_noreplace
--- a/tools/testing/selftests/vm/run_vmtests.sh~selftests-vm-add-a-hugetlb-test-case
+++ a/tools/testing/selftests/vm/run_vmtests.sh
@@ -120,6 +120,17 @@ else
 fi
 rm -f $mnt/huge_mremap
 
+echo "------------------------"
+echo "running hugepage-vmemmap"
+echo "------------------------"
+./hugepage-vmemmap
+if [ $? -ne 0 ]; then
+	echo "[FAIL]"
+	exitcode=1
+else
+	echo "[PASS]"
+fi
+
 echo "NOTE: The above hugetlb tests provide minimal coverage.  Use"
 echo "      https://github.com/libhugetlbfs/libhugetlbfs.git for"
 echo "      hugetlb regression testing."
_
