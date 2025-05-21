Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 858491CEEB2
	for <mm-commits@vger.kernel.org>; Wed, 21 May 2025 16:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747846620; cv=none; b=hlVNKPHjxex+9OQziYL6XwfzDvRDvRsNGtAyCi3jq2vtnPVmwses15KQV58waquiiqf/DoFTG3LaSr68qbJ4vZPzWWdODb+jA4pbCXAp3eCsV/60NjpCEEx4mfKhNOwR2a0hhGA2FZGKCpKyjw2Y+IFlUrcteV+ktJ9Q06kYdXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747846620; c=relaxed/simple;
	bh=2kam+XvEohv2uTRgU8RGq9EfTRTtFBCzejSDFe7w4DE=;
	h=Date:To:From:Subject:Message-Id; b=L9Hoo9u3gfkE/AafAiNrlsyHaWFzYaN7HFsNx2YxfQxsY2VaX1ZnJcMqy+FkpR68lHTyXXq55V3pkUKUipXZlSaLPbX2VyDEcGkhXGDJCFAAYsBKTd+aKz7vHcge90w65cuHi1TLAwVwT+SuOaO0Zw24/QBJA6i10RCkaU61bqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WZJ8h6S3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WZJ8h6S3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4795C4CEE4;
	Wed, 21 May 2025 16:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747846619;
	bh=2kam+XvEohv2uTRgU8RGq9EfTRTtFBCzejSDFe7w4DE=;
	h=Date:To:From:Subject:From;
	b=WZJ8h6S3lzipFHgg0aau6oWR4DVNvKQQH2jiQpFdV2ShYa6ZoQheg9TqM5sidQg8C
	 Q5YWWNN3j/BrzS/J5Nshvmh1xaGSX1FssD29Dwdc9gW+1DM/h+BUlPRbkzXm3PneHV
	 Nke9In/rdj2V0VtkqQGZOPDZqbWGPHpE2Pdmf3HU=
Date: Wed, 21 May 2025 09:56:59 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,peterx@redhat.com,mingo@redhat.com,lorenzo.stoakes@oracle.com,dev.jain@arm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-add-simple-vm_pfnmap-tests-based-on-mmaping-dev-mem.patch removed from -mm tree
Message-Id: <20250521165659.D4795C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: add simple VM_PFNMAP tests based on mmap'ing /dev/mem
has been removed from the -mm tree.  Its filename was
     selftests-mm-add-simple-vm_pfnmap-tests-based-on-mmaping-dev-mem.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: selftests/mm: add simple VM_PFNMAP tests based on mmap'ing /dev/mem
Date: Fri, 9 May 2025 17:30:32 +0200

Let's test some basic functionality using /dev/mem.  These tests will
implicitly cover some PAT (Page Attribute Handling) handling on x86.

These tests will only run when /dev/mem access to the first two pages in
physical address space is possible and allowed; otherwise, the tests are
skipped.

On current x86-64 with PAT inside a VM, all tests pass:

	TAP version 13
	1..6
	# Starting 6 tests from 1 test cases.
	#  RUN           pfnmap.madvise_disallowed ...
	#            OK  pfnmap.madvise_disallowed
	ok 1 pfnmap.madvise_disallowed
	#  RUN           pfnmap.munmap_split ...
	#            OK  pfnmap.munmap_split
	ok 2 pfnmap.munmap_split
	#  RUN           pfnmap.mremap_fixed ...
	#            OK  pfnmap.mremap_fixed
	ok 3 pfnmap.mremap_fixed
	#  RUN           pfnmap.mremap_shrink ...
	#            OK  pfnmap.mremap_shrink
	ok 4 pfnmap.mremap_shrink
	#  RUN           pfnmap.mremap_expand ...
	#            OK  pfnmap.mremap_expand
	ok 5 pfnmap.mremap_expand
	#  RUN           pfnmap.fork ...
	#            OK  pfnmap.fork
	ok 6 pfnmap.fork
	# PASSED: 6 / 6 tests passed.
	# Totals: pass:6 fail:0 xfail:0 xpass:0 skip:0 error:0

However, we are able to trigger:

[   27.888251] x86/PAT: pfnmap:1790 freeing invalid memtype [mem 0x00000000-0x00000fff]

There are probably more things worth testing in the future, such as
MAP_PRIVATE handling.  But this set of tests is sufficient to cover most
of the things we will rework regarding PAT handling.

Link: https://lkml.kernel.org/r/20250509153033.952746-1-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/.gitignore     |    1 
 tools/testing/selftests/mm/Makefile       |    1 
 tools/testing/selftests/mm/pfnmap.c       |  196 ++++++++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh |    4 
 4 files changed, 202 insertions(+)

--- a/tools/testing/selftests/mm/.gitignore~selftests-mm-add-simple-vm_pfnmap-tests-based-on-mmaping-dev-mem
+++ a/tools/testing/selftests/mm/.gitignore
@@ -20,6 +20,7 @@ mremap_test
 on-fault-limit
 transhuge-stress
 pagemap_ioctl
+pfnmap
 *.tmp*
 protection_keys
 protection_keys_32
--- a/tools/testing/selftests/mm/Makefile~selftests-mm-add-simple-vm_pfnmap-tests-based-on-mmaping-dev-mem
+++ a/tools/testing/selftests/mm/Makefile
@@ -84,6 +84,7 @@ TEST_GEN_FILES += mremap_test
 TEST_GEN_FILES += mseal_test
 TEST_GEN_FILES += on-fault-limit
 TEST_GEN_FILES += pagemap_ioctl
+TEST_GEN_FILES += pfnmap
 TEST_GEN_FILES += thuge-gen
 TEST_GEN_FILES += transhuge-stress
 TEST_GEN_FILES += uffd-stress
diff --git a/tools/testing/selftests/mm/pfnmap.c a/tools/testing/selftests/mm/pfnmap.c
new file mode 100644
--- /dev/null
+++ a/tools/testing/selftests/mm/pfnmap.c
@@ -0,0 +1,196 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Basic VM_PFNMAP tests relying on mmap() of '/dev/mem'
+ *
+ * Copyright 2025, Red Hat, Inc.
+ *
+ * Author(s): David Hildenbrand <david@redhat.com>
+ */
+#define _GNU_SOURCE
+#include <stdlib.h>
+#include <string.h>
+#include <stdint.h>
+#include <unistd.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <signal.h>
+#include <setjmp.h>
+#include <linux/mman.h>
+#include <sys/mman.h>
+#include <sys/wait.h>
+
+#include "../kselftest_harness.h"
+#include "vm_util.h"
+
+static sigjmp_buf sigjmp_buf_env;
+
+static void signal_handler(int sig)
+{
+	siglongjmp(sigjmp_buf_env, -EFAULT);
+}
+
+static int test_read_access(char *addr, size_t size, size_t pagesize)
+{
+	size_t offs;
+	int ret;
+
+	if (signal(SIGSEGV, signal_handler) == SIG_ERR)
+		return -EINVAL;
+
+	ret = sigsetjmp(sigjmp_buf_env, 1);
+	if (!ret) {
+		for (offs = 0; offs < size; offs += pagesize)
+			/* Force a read that the compiler cannot optimize out. */
+			*((volatile char *)(addr + offs));
+	}
+	if (signal(SIGSEGV, signal_handler) == SIG_ERR)
+		return -EINVAL;
+
+	return ret;
+}
+
+FIXTURE(pfnmap)
+{
+	size_t pagesize;
+	int dev_mem_fd;
+	char *addr1;
+	size_t size1;
+	char *addr2;
+	size_t size2;
+};
+
+FIXTURE_SETUP(pfnmap)
+{
+	self->pagesize = getpagesize();
+
+	self->dev_mem_fd = open("/dev/mem", O_RDONLY);
+	if (self->dev_mem_fd < 0)
+		SKIP(return, "Cannot open '/dev/mem'\n");
+
+	/* We'll require the first two pages throughout our tests ... */
+	self->size1 = self->pagesize * 2;
+	self->addr1 = mmap(NULL, self->size1, PROT_READ, MAP_SHARED,
+			   self->dev_mem_fd, 0);
+	if (self->addr1 == MAP_FAILED)
+		SKIP(return, "Cannot mmap '/dev/mem'\n");
+
+	/* ... and want to be able to read from them. */
+	if (test_read_access(self->addr1, self->size1, self->pagesize))
+		SKIP(return, "Cannot read-access mmap'ed '/dev/mem'\n");
+
+	self->size2 = 0;
+	self->addr2 = MAP_FAILED;
+}
+
+FIXTURE_TEARDOWN(pfnmap)
+{
+	if (self->addr2 != MAP_FAILED)
+		munmap(self->addr2, self->size2);
+	if (self->addr1 != MAP_FAILED)
+		munmap(self->addr1, self->size1);
+	if (self->dev_mem_fd >= 0)
+		close(self->dev_mem_fd);
+}
+
+TEST_F(pfnmap, madvise_disallowed)
+{
+	int advices[] = {
+		MADV_DONTNEED,
+		MADV_DONTNEED_LOCKED,
+		MADV_FREE,
+		MADV_WIPEONFORK,
+		MADV_COLD,
+		MADV_PAGEOUT,
+		MADV_POPULATE_READ,
+		MADV_POPULATE_WRITE,
+	};
+	int i;
+
+	/* All these advices must be rejected. */
+	for (i = 0; i < ARRAY_SIZE(advices); i++) {
+		EXPECT_LT(madvise(self->addr1, self->pagesize, advices[i]), 0);
+		EXPECT_EQ(errno, EINVAL);
+	}
+}
+
+TEST_F(pfnmap, munmap_split)
+{
+	/*
+	 * Unmap the first page. This munmap() call is not really expected to
+	 * fail, but we might be able to trigger other internal issues.
+	 */
+	ASSERT_EQ(munmap(self->addr1, self->pagesize), 0);
+
+	/*
+	 * Remap the first page while the second page is still mapped. This
+	 * makes sure that any PAT tracking on x86 will allow for mmap()'ing
+	 * a page again while some parts of the first mmap() are still
+	 * around.
+	 */
+	self->size2 = self->pagesize;
+	self->addr2 = mmap(NULL, self->pagesize, PROT_READ, MAP_SHARED,
+			   self->dev_mem_fd, 0);
+	ASSERT_NE(self->addr2, MAP_FAILED);
+}
+
+TEST_F(pfnmap, mremap_fixed)
+{
+	char *ret;
+
+	/* Reserve a destination area. */
+	self->size2 = self->size1;
+	self->addr2 = mmap(NULL, self->size2, PROT_READ, MAP_ANON | MAP_PRIVATE,
+			   -1, 0);
+	ASSERT_NE(self->addr2, MAP_FAILED);
+
+	/* mremap() over our destination. */
+	ret = mremap(self->addr1, self->size1, self->size2,
+		     MREMAP_FIXED | MREMAP_MAYMOVE, self->addr2);
+	ASSERT_NE(ret, MAP_FAILED);
+}
+
+TEST_F(pfnmap, mremap_shrink)
+{
+	char *ret;
+
+	/* Shrinking is expected to work. */
+	ret = mremap(self->addr1, self->size1, self->size1 - self->pagesize, 0);
+	ASSERT_NE(ret, MAP_FAILED);
+}
+
+TEST_F(pfnmap, mremap_expand)
+{
+	/*
+	 * Growing is not expected to work, and getting it right would
+	 * be challenging. So this test primarily serves as an early warning
+	 * that something that probably should never work suddenly works.
+	 */
+	self->size2 = self->size1 + self->pagesize;
+	self->addr2 = mremap(self->addr1, self->size1, self->size2, MREMAP_MAYMOVE);
+	ASSERT_EQ(self->addr2, MAP_FAILED);
+}
+
+TEST_F(pfnmap, fork)
+{
+	pid_t pid;
+	int ret;
+
+	/* fork() a child and test if the child can access the pages. */
+	pid = fork();
+	ASSERT_GE(pid, 0);
+
+	if (!pid) {
+		EXPECT_EQ(test_read_access(self->addr1, self->size1,
+					   self->pagesize), 0);
+		exit(0);
+	}
+
+	wait(&ret);
+	if (WIFEXITED(ret))
+		ret = WEXITSTATUS(ret);
+	else
+		ret = -EINVAL;
+	ASSERT_EQ(ret, 0);
+}
+
+TEST_HARNESS_MAIN
--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-add-simple-vm_pfnmap-tests-based-on-mmaping-dev-mem
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -63,6 +63,8 @@ separated by spaces:
 	test soft dirty page bit semantics
 - pagemap
 	test pagemap_scan IOCTL
+- pfnmap
+	tests for VM_PFNMAP handling
 - cow
 	test copy-on-write semantics
 - thp
@@ -472,6 +474,8 @@ fi
 
 CATEGORY="pagemap" run_test ./pagemap_ioctl
 
+CATEGORY="pfnmap" run_test ./pfnmap
+
 # COW tests
 CATEGORY="cow" run_test ./cow
 
_

Patches currently in -mm which might be from david@redhat.com are


