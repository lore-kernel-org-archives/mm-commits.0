Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BB2729CF0;
	Thu,  6 Mar 2025 05:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741239435; cv=none; b=eRZ5M65GuBGiyYi5m13dcJT5Y+C2qAGB5T3F84ylJ85I1eNYmtIcK0Z6U3Yx3iIA54N7n7Ac3Fdiona8Z5RRUmed747y8fG2ulO4aV8ECIQiKNNLT7TzjK3RLYlocc+LY3ShK5q2wri8LuelMxRnZkn8pzkhzrd5xQSJIQ7h0pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741239435; c=relaxed/simple;
	bh=73wOer435KEO+xT7ApVbipXjk3w8zCtg6rEEom70tFM=;
	h=Date:To:From:Subject:Message-Id; b=ELGLl+TKn9zjR6UxEQvfHNrwbEm9+CkUEaCr56eRqO9cl530aPe98EWk1a25prToGTByn6lzmu+s7tpx2UxyYJUhYcRQdfaHe8rC+Zasra4OJHxpBlch1NEH3rDHY/gi1craqHTxNURYd4TusQjrD5ivbSHpuqDPhCTBNe3UKbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sNwzsSHj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sNwzsSHj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D52AC4CEE4;
	Thu,  6 Mar 2025 05:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741239433;
	bh=73wOer435KEO+xT7ApVbipXjk3w8zCtg6rEEom70tFM=;
	h=Date:To:From:Subject:From;
	b=sNwzsSHjT3AI/OzAuCOT243vv7MAvMXZWxOe9nAgEZBiWjCZNQP+jghbsHkGBVOdL
	 OnIRorGSDixuGHJb0c+GcSASz8+tD8JPvS3Ubx7vwrW3+iUz6LXXp83m2ly92asOfu
	 GLrXFn+I/ylHkrjX/sFWakjCBNaBvWwN51EzX4cg=
Date: Wed, 05 Mar 2025 21:37:12 -0800
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,stable@vger.kernel.org,shuah@kernel.org,peterx@redhat.com,liwang@redhat.com,Liam.Howlett@oracle.com,kent.overstreet@linux.dev,kees@kernel.org,jeffxu@chromium.org,david@redhat.com,dave.hansen@intel.com,dalias@libc.org,brauner@kernel.org,axelrasmussen@google.com,avagin@google.com,jhubbard@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] revert-selftests-mm-remove-local-__nr_-definitions.patch removed from -mm tree
Message-Id: <20250306053713.7D52AC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Revert "selftests/mm: remove local __NR_* definitions"
has been removed from the -mm tree.  Its filename was
     revert-selftests-mm-remove-local-__nr_-definitions.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: John Hubbard <jhubbard@nvidia.com>
Subject: Revert "selftests/mm: remove local __NR_* definitions"
Date: Thu, 13 Feb 2025 19:38:50 -0800

This reverts commit a5c6bc590094a1a73cf6fa3f505e1945d2bf2461.

The general approach described in commit e076eaca5906 ("selftests: break
the dependency upon local header files") was taken one step too far here:
it should not have been extended to include the syscall numbers.  This is
because doing so would require per-arch support in tools/include/uapi, and
no such support exists.

This revert fixes two separate reports of test failures, from Dave
Hansen[1], and Li Wang[2].  An excerpt of Dave's report:

Before this commit (a5c6bc590094a1a73cf6fa3f505e1945d2bf2461) things are
fine.  But after, I get:

	running PKEY tests for unsupported CPU/OS

An excerpt of Li's report:

    I just found that mlock2_() return a wrong value in mlock2-test

[1] https://lore.kernel.org/dc585017-6740-4cab-a536-b12b37a7582d@intel.com
[2] https://lore.kernel.org/CAEemH2eW=UMu9+turT2jRie7+6ewUazXmA6kL+VBo3cGDGU6RA@mail.gmail.com

Link: https://lkml.kernel.org/r/20250214033850.235171-1-jhubbard@nvidia.com
Fixes: a5c6bc590094 ("selftests/mm: remove local __NR_* definitions")
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Li Wang <liwang@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: Andrei Vagin <avagin@google.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rich Felker <dalias@libc.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/hugepage-mremap.c      |    2 -
 tools/testing/selftests/mm/ksm_functional_tests.c |    8 +++++-
 tools/testing/selftests/mm/memfd_secret.c         |   14 ++++++++++-
 tools/testing/selftests/mm/mkdirty.c              |    8 +++++-
 tools/testing/selftests/mm/mlock2.h               |    1 
 tools/testing/selftests/mm/protection_keys.c      |    2 -
 tools/testing/selftests/mm/uffd-common.c          |    4 +++
 tools/testing/selftests/mm/uffd-stress.c          |   15 +++++++++++-
 tools/testing/selftests/mm/uffd-unit-tests.c      |   14 ++++++++++-
 9 files changed, 60 insertions(+), 8 deletions(-)

--- a/tools/testing/selftests/mm/hugepage-mremap.c~revert-selftests-mm-remove-local-__nr_-definitions
+++ a/tools/testing/selftests/mm/hugepage-mremap.c
@@ -15,7 +15,7 @@
 #define _GNU_SOURCE
 #include <stdlib.h>
 #include <stdio.h>
-#include <asm-generic/unistd.h>
+#include <unistd.h>
 #include <sys/mman.h>
 #include <errno.h>
 #include <fcntl.h> /* Definition of O_* constants */
--- a/tools/testing/selftests/mm/ksm_functional_tests.c~revert-selftests-mm-remove-local-__nr_-definitions
+++ a/tools/testing/selftests/mm/ksm_functional_tests.c
@@ -11,7 +11,7 @@
 #include <string.h>
 #include <stdbool.h>
 #include <stdint.h>
-#include <asm-generic/unistd.h>
+#include <unistd.h>
 #include <errno.h>
 #include <fcntl.h>
 #include <sys/mman.h>
@@ -369,6 +369,7 @@ unmap:
 	munmap(map, size);
 }
 
+#ifdef __NR_userfaultfd
 static void test_unmerge_uffd_wp(void)
 {
 	struct uffdio_writeprotect uffd_writeprotect;
@@ -429,6 +430,7 @@ close_uffd:
 unmap:
 	munmap(map, size);
 }
+#endif
 
 /* Verify that KSM can be enabled / queried with prctl. */
 static void test_prctl(void)
@@ -684,7 +686,9 @@ int main(int argc, char **argv)
 		exit(test_child_ksm());
 	}
 
+#ifdef __NR_userfaultfd
 	tests++;
+#endif
 
 	ksft_print_header();
 	ksft_set_plan(tests);
@@ -696,7 +700,9 @@ int main(int argc, char **argv)
 	test_unmerge();
 	test_unmerge_zero_pages();
 	test_unmerge_discarded();
+#ifdef __NR_userfaultfd
 	test_unmerge_uffd_wp();
+#endif
 
 	test_prot_none();
 
--- a/tools/testing/selftests/mm/memfd_secret.c~revert-selftests-mm-remove-local-__nr_-definitions
+++ a/tools/testing/selftests/mm/memfd_secret.c
@@ -17,7 +17,7 @@
 
 #include <stdlib.h>
 #include <string.h>
-#include <asm-generic/unistd.h>
+#include <unistd.h>
 #include <errno.h>
 #include <stdio.h>
 #include <fcntl.h>
@@ -28,6 +28,8 @@
 #define pass(fmt, ...) ksft_test_result_pass(fmt, ##__VA_ARGS__)
 #define skip(fmt, ...) ksft_test_result_skip(fmt, ##__VA_ARGS__)
 
+#ifdef __NR_memfd_secret
+
 #define PATTERN	0x55
 
 static const int prot = PROT_READ | PROT_WRITE;
@@ -332,3 +334,13 @@ int main(int argc, char *argv[])
 
 	ksft_finished();
 }
+
+#else /* __NR_memfd_secret */
+
+int main(int argc, char *argv[])
+{
+	printf("skip: skipping memfd_secret test (missing __NR_memfd_secret)\n");
+	return KSFT_SKIP;
+}
+
+#endif /* __NR_memfd_secret */
--- a/tools/testing/selftests/mm/mkdirty.c~revert-selftests-mm-remove-local-__nr_-definitions
+++ a/tools/testing/selftests/mm/mkdirty.c
@@ -9,7 +9,7 @@
  */
 #include <fcntl.h>
 #include <signal.h>
-#include <asm-generic/unistd.h>
+#include <unistd.h>
 #include <string.h>
 #include <errno.h>
 #include <stdlib.h>
@@ -265,6 +265,7 @@ munmap:
 	munmap(mmap_mem, mmap_size);
 }
 
+#ifdef __NR_userfaultfd
 static void test_uffdio_copy(void)
 {
 	struct uffdio_register uffdio_register;
@@ -322,6 +323,7 @@ munmap:
 	munmap(dst, pagesize);
 	free(src);
 }
+#endif /* __NR_userfaultfd */
 
 int main(void)
 {
@@ -334,7 +336,9 @@ int main(void)
 			       thpsize / 1024);
 		tests += 3;
 	}
+#ifdef __NR_userfaultfd
 	tests += 1;
+#endif /* __NR_userfaultfd */
 
 	ksft_print_header();
 	ksft_set_plan(tests);
@@ -364,7 +368,9 @@ int main(void)
 	if (thpsize)
 		test_pte_mapped_thp();
 	/* Placing a fresh page via userfaultfd may set the PTE dirty. */
+#ifdef __NR_userfaultfd
 	test_uffdio_copy();
+#endif /* __NR_userfaultfd */
 
 	err = ksft_get_fail_cnt();
 	if (err)
--- a/tools/testing/selftests/mm/mlock2.h~revert-selftests-mm-remove-local-__nr_-definitions
+++ a/tools/testing/selftests/mm/mlock2.h
@@ -3,7 +3,6 @@
 #include <errno.h>
 #include <stdio.h>
 #include <stdlib.h>
-#include <asm-generic/unistd.h>
 
 static int mlock2_(void *start, size_t len, int flags)
 {
--- a/tools/testing/selftests/mm/protection_keys.c~revert-selftests-mm-remove-local-__nr_-definitions
+++ a/tools/testing/selftests/mm/protection_keys.c
@@ -42,7 +42,7 @@
 #include <sys/wait.h>
 #include <sys/stat.h>
 #include <fcntl.h>
-#include <asm-generic/unistd.h>
+#include <unistd.h>
 #include <sys/ptrace.h>
 #include <setjmp.h>
 
--- a/tools/testing/selftests/mm/uffd-common.c~revert-selftests-mm-remove-local-__nr_-definitions
+++ a/tools/testing/selftests/mm/uffd-common.c
@@ -673,7 +673,11 @@ int uffd_open_dev(unsigned int flags)
 
 int uffd_open_sys(unsigned int flags)
 {
+#ifdef __NR_userfaultfd
 	return syscall(__NR_userfaultfd, flags);
+#else
+	return -1;
+#endif
 }
 
 int uffd_open(unsigned int flags)
--- a/tools/testing/selftests/mm/uffd-stress.c~revert-selftests-mm-remove-local-__nr_-definitions
+++ a/tools/testing/selftests/mm/uffd-stress.c
@@ -33,10 +33,11 @@
  * pthread_mutex_lock will also verify the atomicity of the memory
  * transfer (UFFDIO_COPY).
  */
-#include <asm-generic/unistd.h>
+
 #include "uffd-common.h"
 
 uint64_t features;
+#ifdef __NR_userfaultfd
 
 #define BOUNCE_RANDOM		(1<<0)
 #define BOUNCE_RACINGFAULTS	(1<<1)
@@ -471,3 +472,15 @@ int main(int argc, char **argv)
 	       nr_pages, nr_pages_per_cpu);
 	return userfaultfd_stress();
 }
+
+#else /* __NR_userfaultfd */
+
+#warning "missing __NR_userfaultfd definition"
+
+int main(void)
+{
+	printf("skip: Skipping userfaultfd test (missing __NR_userfaultfd)\n");
+	return KSFT_SKIP;
+}
+
+#endif /* __NR_userfaultfd */
--- a/tools/testing/selftests/mm/uffd-unit-tests.c~revert-selftests-mm-remove-local-__nr_-definitions
+++ a/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -5,11 +5,12 @@
  *  Copyright (C) 2015-2023  Red Hat, Inc.
  */
 
-#include <asm-generic/unistd.h>
 #include "uffd-common.h"
 
 #include "../../../../mm/gup_test.h"
 
+#ifdef __NR_userfaultfd
+
 /* The unit test doesn't need a large or random size, make it 32MB for now */
 #define  UFFD_TEST_MEM_SIZE               (32UL << 20)
 
@@ -1558,3 +1559,14 @@ int main(int argc, char *argv[])
 	return ksft_get_fail_cnt() ? KSFT_FAIL : KSFT_PASS;
 }
 
+#else /* __NR_userfaultfd */
+
+#warning "missing __NR_userfaultfd definition"
+
+int main(void)
+{
+	printf("Skipping %s (missing __NR_userfaultfd)\n", __file__);
+	return KSFT_SKIP;
+}
+
+#endif /* __NR_userfaultfd */
_

Patches currently in -mm which might be from jhubbard@nvidia.com are


