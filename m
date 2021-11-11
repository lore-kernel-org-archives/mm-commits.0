Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08B29C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:45:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E560B6113B
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:45:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234310AbhKKCr5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:47:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:53004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234044AbhKKCr5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:47:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7FA8560F46;
        Thu, 11 Nov 2021 02:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598708;
        bh=CnqJwDMfA9UraHWQ7OSpPdE00mnFOINNun9rBKKkkFE=;
        h=Date:From:To:Subject:From;
        b=vQLuoFi/31HxMJfkmWtDWpHNLFpu5aTolkMDlbNOL8ND2dzctcUrqcTuPy3y/j+Ab
         iAwUMuw1HqrKUhN264dodhsv8jjSSFNJOtHdAlPlaJWfvFFEzY7SpLnOp9ZznGxrf/
         7VdhvWBqAp1FeCQDazgOx8XqcfjLVJXp+WjvKtpI=
Date:   Wed, 10 Nov 2021 18:45:08 -0800
From:   akpm@linux-foundation.org
To:     almasrymina@google.com, ckennelly@google.com, kenchen@google.com,
        kirill@shutemov.name, mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, vbabka@suse.cz, wanjiabing@vivo.com
Subject:  [merged] mm-hugepages-add-hugetlb-vma-mremap-test.patch
 removed from -mm tree
Message-ID: <20211111024508.fSC2OqZWy%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, hugepages: add hugetlb vma mremap() test
has been removed from the -mm tree.  Its filename was
     mm-hugepages-add-hugetlb-vma-mremap-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mina Almasry <almasrymina@google.com>
Subject: mm, hugepages: add hugetlb vma mremap() test

[almasrymina@google.com: v8]
  Link: https://lkml.kernel.org/r/20211014200542.4126947-2-almasrymina@google.com
[wanjiabing@vivo.com: remove duplicated include in hugepage-mremap]
  Link: https://lkml.kernel.org/r/20211021122944.8857-1-wanjiabing@vivo.com
Link: https://lkml.kernel.org/r/20211013195825.3058275-2-almasrymina@google.com
Signed-off-by: Mina Almasry <almasrymina@google.com>
Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
Acked-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Ken Chen <kenchen@google.com>
Cc: Chris Kennelly <ckennelly@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Kirill Shutemov <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/.gitignore        |    1 
 tools/testing/selftests/vm/Makefile          |    1 
 tools/testing/selftests/vm/hugepage-mremap.c |  160 +++++++++++++++++
 tools/testing/selftests/vm/run_vmtests.sh    |   11 +
 4 files changed, 173 insertions(+)

--- a/tools/testing/selftests/vm/.gitignore~mm-hugepages-add-hugetlb-vma-mremap-test
+++ a/tools/testing/selftests/vm/.gitignore
@@ -1,5 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 hugepage-mmap
+hugepage-mremap
 hugepage-shm
 khugepaged
 map_hugetlb
--- /dev/null
+++ a/tools/testing/selftests/vm/hugepage-mremap.c
@@ -0,0 +1,160 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * hugepage-mremap:
+ *
+ * Example of remapping huge page memory in a user application using the
+ * mremap system call.  Code assumes a hugetlbfs filesystem is mounted
+ * at './huge'.  The code will use 10MB worth of huge pages.
+ */
+
+#define _GNU_SOURCE
+#include <stdlib.h>
+#include <stdio.h>
+#include <unistd.h>
+#include <sys/mman.h>
+#include <errno.h>
+#include <fcntl.h> /* Definition of O_* constants */
+#include <sys/syscall.h> /* Definition of SYS_* constants */
+#include <unistd.h>
+#include <linux/userfaultfd.h>
+#include <sys/ioctl.h>
+
+#define LENGTH (1UL * 1024 * 1024 * 1024)
+
+#define PROTECTION (PROT_READ | PROT_WRITE | PROT_EXEC)
+#define FLAGS (MAP_SHARED | MAP_ANONYMOUS)
+
+static void check_bytes(char *addr)
+{
+	printf("First hex is %x\n", *((unsigned int *)addr));
+}
+
+static void write_bytes(char *addr)
+{
+	unsigned long i;
+
+	for (i = 0; i < LENGTH; i++)
+		*(addr + i) = (char)i;
+}
+
+static int read_bytes(char *addr)
+{
+	unsigned long i;
+
+	check_bytes(addr);
+	for (i = 0; i < LENGTH; i++)
+		if (*(addr + i) != (char)i) {
+			printf("Mismatch at %lu\n", i);
+			return 1;
+		}
+	return 0;
+}
+
+static void register_region_with_uffd(char *addr, size_t len)
+{
+	long uffd; /* userfaultfd file descriptor */
+	struct uffdio_api uffdio_api;
+	struct uffdio_register uffdio_register;
+
+	/* Create and enable userfaultfd object. */
+
+	uffd = syscall(__NR_userfaultfd, O_CLOEXEC | O_NONBLOCK);
+	if (uffd == -1) {
+		perror("userfaultfd");
+		exit(1);
+	}
+
+	uffdio_api.api = UFFD_API;
+	uffdio_api.features = 0;
+	if (ioctl(uffd, UFFDIO_API, &uffdio_api) == -1) {
+		perror("ioctl-UFFDIO_API");
+		exit(1);
+	}
+
+	/* Create a private anonymous mapping. The memory will be
+	 * demand-zero paged--that is, not yet allocated. When we
+	 * actually touch the memory, it will be allocated via
+	 * the userfaultfd.
+	 */
+
+	addr = mmap(NULL, len, PROT_READ | PROT_WRITE,
+		    MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (addr == MAP_FAILED) {
+		perror("mmap");
+		exit(1);
+	}
+
+	printf("Address returned by mmap() = %p\n", addr);
+
+	/* Register the memory range of the mapping we just created for
+	 * handling by the userfaultfd object. In mode, we request to track
+	 * missing pages (i.e., pages that have not yet been faulted in).
+	 */
+
+	uffdio_register.range.start = (unsigned long)addr;
+	uffdio_register.range.len = len;
+	uffdio_register.mode = UFFDIO_REGISTER_MODE_MISSING;
+	if (ioctl(uffd, UFFDIO_REGISTER, &uffdio_register) == -1) {
+		perror("ioctl-UFFDIO_REGISTER");
+		exit(1);
+	}
+}
+
+int main(void)
+{
+	int ret = 0;
+
+	int fd = open("/huge/test", O_CREAT | O_RDWR, 0755);
+
+	if (fd < 0) {
+		perror("Open failed");
+		exit(1);
+	}
+
+	/* mmap to a PUD aligned address to hopefully trigger pmd sharing. */
+	unsigned long suggested_addr = 0x7eaa40000000;
+	void *haddr = mmap((void *)suggested_addr, LENGTH, PROTECTION,
+			   MAP_HUGETLB | MAP_SHARED | MAP_POPULATE, fd, 0);
+	printf("Map haddr: Returned address is %p\n", haddr);
+	if (haddr == MAP_FAILED) {
+		perror("mmap1");
+		exit(1);
+	}
+
+	/* mmap again to a dummy address to hopefully trigger pmd sharing. */
+	suggested_addr = 0x7daa40000000;
+	void *daddr = mmap((void *)suggested_addr, LENGTH, PROTECTION,
+			   MAP_HUGETLB | MAP_SHARED | MAP_POPULATE, fd, 0);
+	printf("Map daddr: Returned address is %p\n", daddr);
+	if (daddr == MAP_FAILED) {
+		perror("mmap3");
+		exit(1);
+	}
+
+	suggested_addr = 0x7faa40000000;
+	void *vaddr =
+		mmap((void *)suggested_addr, LENGTH, PROTECTION, FLAGS, -1, 0);
+	printf("Map vaddr: Returned address is %p\n", vaddr);
+	if (vaddr == MAP_FAILED) {
+		perror("mmap2");
+		exit(1);
+	}
+
+	register_region_with_uffd(haddr, LENGTH);
+
+	void *addr = mremap(haddr, LENGTH, LENGTH,
+			    MREMAP_MAYMOVE | MREMAP_FIXED, vaddr);
+	if (addr == MAP_FAILED) {
+		perror("mremap");
+		exit(1);
+	}
+
+	printf("Mremap: Returned address is %p\n", addr);
+	check_bytes(addr);
+	write_bytes(addr);
+	ret = read_bytes(addr);
+
+	munmap(addr, LENGTH);
+
+	return ret;
+}
--- a/tools/testing/selftests/vm/Makefile~mm-hugepages-add-hugetlb-vma-mremap-test
+++ a/tools/testing/selftests/vm/Makefile
@@ -29,6 +29,7 @@ TEST_GEN_FILES = compaction_test
 TEST_GEN_FILES += gup_test
 TEST_GEN_FILES += hmm-tests
 TEST_GEN_FILES += hugepage-mmap
+TEST_GEN_FILES += hugepage-mremap
 TEST_GEN_FILES += hugepage-shm
 TEST_GEN_FILES += khugepaged
 TEST_GEN_FILES += madv_populate
--- a/tools/testing/selftests/vm/run_vmtests.sh~mm-hugepages-add-hugetlb-vma-mremap-test
+++ a/tools/testing/selftests/vm/run_vmtests.sh
@@ -108,6 +108,17 @@ else
 	echo "[PASS]"
 fi
 
+echo "-----------------------"
+echo "running hugepage-mremap"
+echo "-----------------------"
+./hugepage-mremap
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

Patches currently in -mm which might be from almasrymina@google.com are


