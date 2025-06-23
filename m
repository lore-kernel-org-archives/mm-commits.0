Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCB5519E7F9
	for <mm-commits@vger.kernel.org>; Mon, 23 Jun 2025 22:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717185; cv=none; b=O+pzl7dLIeJcsI/2PXmbD9h2R8S3eJzyH0dB2E7v4Mxex+GHxGub/Awvg1qUy4BQhCyb7aOFOK6yP4GrsgdeLXbgZQG2u0l5SnHJCK2FO8M18gnq9J9P2N9ORI3FJGIfyTfG27atX3oi0eJEoZtqER30gxqOWcmJIkG13X8kMUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717185; c=relaxed/simple;
	bh=HW4PMDOTakgvzKjj5q1LUTzP1kiVOpcbUHMK+kP9fDE=;
	h=Date:To:From:Subject:Message-Id; b=jsFU/4ULmwSarqDa67loEPJbH2R9LkX7E7jd92mw3ni9y0CbrrvDrFAssf7BnuyZpVJJZiElDitPYKK5lF3qgq8zL1QhorurqLgDuUibVlBbw09KAYKZyUrkDsyRrqkkQKn1QkTgq8mUPjxIa1SD0NO8Cf97SW728ONfHoff3RI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Xt8G4e9T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Xt8G4e9T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84E08C4CEED;
	Mon, 23 Jun 2025 22:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750717185;
	bh=HW4PMDOTakgvzKjj5q1LUTzP1kiVOpcbUHMK+kP9fDE=;
	h=Date:To:From:Subject:From;
	b=Xt8G4e9TsXVlzujUzV+FarH6dLX9xLY2R/EvSJUqVusGCgGLDer/pE4U2B0dNNdrD
	 kEDZtFUsXiPcLMfs3OXsmsKIQeZK93m+OdE7dvpDIXxnD5pVbJXWc3tQefqydkdtUj
	 iXOA8ieusUUd6bFOCQsvMKPok0/kIb7aWMaKtueY=
Date: Mon, 23 Jun 2025 15:19:44 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,shuah@kernel.org,ryncsn@gmail.com,lorenzo.stoakes@oracle.com,david@redhat.com,brauner@kernel.org,lianux.mm@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] selftests-mm-add-test-for-batch_processmadv_dontneed.patch removed from -mm tree
Message-Id: <20250623221945.84E08C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: add test for (BATCH_PROCESS)MADV_DONTNEED
has been removed from the -mm tree.  Its filename was
     selftests-mm-add-test-for-batch_processmadv_dontneed.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Lian Wang <lianux.mm@gmail.com>
Subject: selftests/mm: add test for (BATCH_PROCESS)MADV_DONTNEED
Date: Sat, 21 Jun 2025 21:30:03 +0800

Let's add a simple test for MADV_DONTNEED and PROCESS_MADV_DONTNEED,
and inspired by SeongJae Park's test at GitHub[1] add batch test
for PROCESS_MADV_DONTNEED.  For now it is influenced by workload and
needs add some race conditions tested. We can add this later.

Link: https://lkml.kernel.org/r/20250621133003.4733-1-lianux.mm@gmail.com
Link: https://github.com/sjp38/eval_proc_madvise	[1]
Signed-off-by: Lian Wang <lianux.mm@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/.gitignore      |    1 
 tools/testing/selftests/mm/Makefile        |    1 
 tools/testing/selftests/mm/madv_dontneed.c |  220 +++++++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh  |    5 
 4 files changed, 227 insertions(+)

--- a/tools/testing/selftests/mm/.gitignore~selftests-mm-add-test-for-batch_processmadv_dontneed
+++ a/tools/testing/selftests/mm/.gitignore
@@ -25,6 +25,7 @@ pfnmap
 protection_keys
 protection_keys_32
 protection_keys_64
+madv_dontneed
 madv_populate
 uffd-stress
 uffd-unit-tests
diff --git a/tools/testing/selftests/mm/madv_dontneed.c a/tools/testing/selftests/mm/madv_dontneed.c
new file mode 100644
--- /dev/null
+++ a/tools/testing/selftests/mm/madv_dontneed.c
@@ -0,0 +1,220 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * MADV_DONTNEED and PROCESS_MADV_DONTNEED tests
+ *
+ * Copyright (C) 2025, Linx Software Corp.
+ *
+ * Author(s): Lian Wang <lianux.mm@gmail.com>
+ */
+#define _GNU_SOURCE
+#include <stdlib.h>
+#include <string.h>
+#include <stdbool.h>
+#include <stdint.h>
+#include <unistd.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <linux/mman.h>
+#include <sys/mman.h>
+#include <sys/syscall.h>
+#include "vm_util.h"
+#include <time.h>
+
+#include "../kselftest.h"
+
+/*
+ * For now, we're using 2 MiB of private anonymous memory for all tests.
+ */
+#define SIZE (256 * 1024 * 1024)
+
+static size_t pagesize;
+
+static void sense_support(void)
+{
+	char *addr;
+	int ret;
+
+	addr = mmap(0, pagesize, PROT_READ | PROT_WRITE,
+		    MAP_ANONYMOUS | MAP_PRIVATE, 0, 0);
+	if (!addr)
+		ksft_exit_fail_msg("mmap failed\n");
+
+	ret = madvise(addr, pagesize, MADV_DONTNEED);
+	if (ret)
+		ksft_exit_skip("MADV_DONTNEED is not available\n");
+
+	munmap(addr, pagesize);
+}
+
+/*
+ * Read pagemap to check page is present in mermory
+ */
+static bool is_page_present(void *addr)
+{
+	uintptr_t vaddr = (uintptr_t)addr;
+	uintptr_t offset = (vaddr / pagesize) * sizeof(uint64_t);
+	ssize_t bytes_read;
+	uint64_t entry;
+	bool ret;
+	int fd;
+
+	fd = open("/proc/self/pagemap", O_RDONLY);
+	if (fd < 0) {
+		ksft_exit_fail_msg("opening pagemap failed\n");
+		ret = false;
+	}
+
+	if ((lseek(fd, offset, SEEK_SET)) == -1) {
+		close(fd);
+		ret = false;
+	}
+
+	bytes_read = read(fd, &entry, sizeof(entry));
+	close(fd);
+
+	if (bytes_read != sizeof(entry)) {
+		perror("read failed");
+		return false;
+	}
+
+	if (entry & (1ULL << 63))
+		ret = true;
+
+	return ret;
+}
+
+/*
+ * test madvsise_dontneed
+ */
+static void test_madv_dontneed(void)
+{
+	unsigned long rss_anon_before, rss_anon_after;
+	bool present, rss;
+	char *addr;
+	int ret;
+
+	ksft_print_msg("[RUN] %s\n", __func__);
+
+	addr = mmap(0, SIZE, PROT_READ | PROT_WRITE,
+		    MAP_ANONYMOUS | MAP_PRIVATE, 0, 0);
+	if (!addr)
+		ksft_exit_fail_msg("mmap failed\n");
+
+	memset(addr, 0x7A, SIZE);
+
+	rss_anon_before = rss_anon();
+	if (!rss_anon_before)
+		ksft_exit_fail_msg("No RssAnon is allocated before dontneed\n");
+	ret = madvise(addr, SIZE, MADV_DONTNEED);
+	ksft_test_result(!ret, "MADV_DONTNEED\n");
+
+	rss_anon_after = rss_anon();
+	if (rss_anon_after < rss_anon_before)
+		rss = true;
+	ksft_test_result(rss, "MADV_DONTNEED rss is correct\n");
+
+	for (size_t i = 0; i < SIZE; i += pagesize) {
+		present = is_page_present(addr + i);
+		if (present) {
+			ksft_print_msg("Page not zero at offset %zu\n",
+				       (size_t)i);
+		}
+	}
+
+	ksft_test_result(!present, "MADV_DONTNEED page is present\n");
+	munmap(addr, SIZE);
+}
+
+/*
+ * Measure performance of batched process_madvise vs madvise
+ */
+static int measure_process_madvise_batching(int hint, int total_size,
+					    int single_unit, int batch_size)
+{
+	struct iovec *vec = malloc(sizeof(*vec) * batch_size);
+	struct timespec start, end;
+	unsigned long elapsed_ns = 0;
+	unsigned long nr_measures = 0;
+	pid_t pid = getpid();
+	char *buf;
+	int pidfd;
+
+	pidfd = syscall(SYS_pidfd_open, pid, 0);
+	if (pidfd == -1) {
+		perror("pidfd_open fail");
+		return -1;
+	}
+
+	buf = mmap(NULL, total_size, PROT_READ | PROT_WRITE,
+		   MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (buf == MAP_FAILED) {
+		perror("mmap fail");
+		goto out;
+	}
+
+	if (!vec) {
+		perror("malloc vec failed");
+		goto unmap_out;
+	}
+
+	while (elapsed_ns < 5UL * 1000 * 1000 * 1000) {
+		memset(buf, 0x7A, total_size);
+
+		clock_gettime(CLOCK_MONOTONIC, &start);
+
+		for (int off = 0; off < total_size;
+		     off += single_unit * batch_size) {
+			for (int i = 0; i < batch_size; i++) {
+				vec[i].iov_base = buf + off + i * single_unit;
+				vec[i].iov_len = single_unit;
+			}
+			syscall(SYS_process_madvise, pidfd, vec, batch_size,
+				hint, 0);
+		}
+
+		clock_gettime(CLOCK_MONOTONIC, &end);
+		elapsed_ns += (end.tv_sec - start.tv_sec) * 1e9 +
+			      (end.tv_nsec - start.tv_nsec);
+		nr_measures++;
+	}
+
+	ksft_print_msg("[RESULT] batch=%d time=%.3f us/op\n", batch_size,
+		       (double)(elapsed_ns / nr_measures) /
+			       (total_size / single_unit));
+
+	free(vec);
+unmap_out:
+	munmap(buf, total_size);
+out:
+	close(pidfd);
+	return 0;
+}
+
+static void test_perf_batch_process(void)
+{
+	ksft_print_msg("[RUN] %s\n", __func__);
+	measure_process_madvise_batching(MADV_DONTNEED, SIZE, pagesize, 1);
+	measure_process_madvise_batching(MADV_DONTNEED, SIZE, pagesize, 2);
+	measure_process_madvise_batching(MADV_DONTNEED, SIZE, pagesize, 4);
+	ksft_test_result(1, "All test were done\n");
+}
+
+int main(int argc, char **argv)
+{
+	int err;
+
+	pagesize = getpagesize();
+
+	ksft_print_header();
+	ksft_set_plan(4);
+
+	sense_support();
+	test_madv_dontneed();
+	test_perf_batch_process();
+
+	err = ksft_get_fail_cnt();
+	if (err)
+		ksft_exit_fail_msg("%d out of %d tests failed\n", err,
+				   ksft_test_num());
+	ksft_exit_pass();
+}
--- a/tools/testing/selftests/mm/Makefile~selftests-mm-add-test-for-batch_processmadv_dontneed
+++ a/tools/testing/selftests/mm/Makefile
@@ -67,6 +67,7 @@ TEST_GEN_FILES += hugepage-mremap
 TEST_GEN_FILES += hugepage-shm
 TEST_GEN_FILES += hugepage-vmemmap
 TEST_GEN_FILES += khugepaged
+TEST_GEN_FILES += madv_dontneed
 TEST_GEN_FILES += madv_populate
 TEST_GEN_FILES += map_fixed_noreplace
 TEST_GEN_FILES += map_hugetlb
--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-add-test-for-batch_processmadv_dontneed
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -47,6 +47,8 @@ separated by spaces:
 	hmm smoke tests
 - madv_guard
 	test madvise(2) MADV_GUARD_INSTALL and MADV_GUARD_REMOVE options
+- madv_dontneed
+	test memadvise(2) MADV_DONTNEED and PROCESS_MADV_DONTNEED options
 - madv_populate
 	test memadvise(2) MADV_POPULATE_{READ,WRITE} options
 - memfd_secret
@@ -422,6 +424,9 @@ CATEGORY="hmm" run_test bash ./test_hmm.
 # MADV_GUARD_INSTALL and MADV_GUARD_REMOVE tests
 CATEGORY="madv_guard" run_test ./guard-regions
 
+# MADV_DONTNEED and PROCESS_DONTNEED tests
+CATEGORY="madv_dontneed" run_test ./madv_dontneed
+
 # MADV_POPULATE_READ and MADV_POPULATE_WRITE tests
 CATEGORY="madv_populate" run_test ./madv_populate
 
_

Patches currently in -mm which might be from lianux.mm@gmail.com are


