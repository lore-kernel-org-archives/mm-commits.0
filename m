Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88B8B13C691
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291672; cv=none; b=CQZgE4lUyKMWlQbi9NDpGjoZvOiR/2c6/Z5M9PR7hBEeseNhyC98C48ohmakrlIyOtZNHEKD3DEWHE8d02GdWKOPd3u+DPEz3yYDXsrccIrm7skpcRQ1sk4B4XYoUU/RSCK5xALezIA2niRdoTO6eBJ8GD8NMFEYBfqdFg4Nr8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291672; c=relaxed/simple;
	bh=p/SdEnhciUbyPvna4UVqmj1Kd7/pikJslx0SvmB7yus=;
	h=Date:To:From:Subject:Message-Id; b=mXQ0cx8QzB59sclvEq7hsDuxX5hwCQxs1AKMPBx92ZFKF9C3SMP1MTwk4tZ2s8XcmFMyhBwKBZod4i+4bcPiwnSl5P6HDl3/htobglZgzuysN4WR68YrtcVIM96Mf4xj1RwjOzND3pJMZFddAxh4RZySndQrZZwT3x2Devh0s8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YPUteH/C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YPUteH/C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0006DC32782;
	Tue, 25 Jun 2024 05:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291672;
	bh=p/SdEnhciUbyPvna4UVqmj1Kd7/pikJslx0SvmB7yus=;
	h=Date:To:From:Subject:From;
	b=YPUteH/CfPmkPOsKaW0UoE38+cSufzlo1kKA8o0pF0bfoPszkyqqZlnLIZyiy2poI
	 +24t4/WQBMggcsSuuuk3ludmo24N6WkLGstJ9KEgBTFkOUgaWwDS5fUGD90upSCEh8
	 Ligc+MdVJu0Dn651l/kcyVW06FXJXQlOTNjRV+mo=
Date: Mon, 24 Jun 2024 22:01:11 -0700
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,shuah@kernel.org,peterx@redhat.com,Liam.Howlett@oracle.com,kent.overstreet@linux.dev,kees@kernel.org,jeffxu@chromium.org,david@redhat.com,dalias@libc.org,brauner@kernel.org,axelrasmussen@google.com,avagin@google.com,jhubbard@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-remove-local-__nr_-definitions.patch removed from -mm tree
Message-Id: <20240625050112.0006DC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: remove local __NR_* definitions
has been removed from the -mm tree.  Its filename was
     selftests-mm-remove-local-__nr_-definitions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: John Hubbard <jhubbard@nvidia.com>
Subject: selftests/mm: remove local __NR_* definitions
Date: Mon, 17 Jun 2024 19:24:22 -0700

This continues the work on getting the selftests to build without
requiring people to first run "make headers" [1].

Now that the system call numbers are in the correct, checked-in locations
in the kernel tree (./tools/include/uapi/asm/unistd*.h), make sure that
the mm selftests include that file (indirectly).

Doing so provides guaranteed definitions at build time, so remove all of
the checks for "ifdef __NR_xxx" in the mm selftests, because they will
always be true (defined).

[1] commit e076eaca5906 ("selftests: break the dependency upon local
header files")

Link: https://lkml.kernel.org/r/20240618022422.804305-7-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/hugepage-mremap.c      |    2 -
 tools/testing/selftests/mm/ksm_functional_tests.c |    8 ------
 tools/testing/selftests/mm/memfd_secret.c         |   14 ----------
 tools/testing/selftests/mm/mkdirty.c              |    8 ------
 tools/testing/selftests/mm/mlock2.h               |    1 
 tools/testing/selftests/mm/pagemap_ioctl.c        |    2 -
 tools/testing/selftests/mm/protection_keys.c      |    2 -
 tools/testing/selftests/mm/uffd-common.c          |    4 ---
 tools/testing/selftests/mm/uffd-stress.c          |   16 ------------
 tools/testing/selftests/mm/uffd-unit-tests.c      |   14 ----------
 10 files changed, 9 insertions(+), 62 deletions(-)

--- a/tools/testing/selftests/mm/hugepage-mremap.c~selftests-mm-remove-local-__nr_-definitions
+++ a/tools/testing/selftests/mm/hugepage-mremap.c
@@ -15,7 +15,7 @@
 #define _GNU_SOURCE
 #include <stdlib.h>
 #include <stdio.h>
-#include <unistd.h>
+#include <asm-generic/unistd.h>
 #include <sys/mman.h>
 #include <errno.h>
 #include <fcntl.h> /* Definition of O_* constants */
--- a/tools/testing/selftests/mm/ksm_functional_tests.c~selftests-mm-remove-local-__nr_-definitions
+++ a/tools/testing/selftests/mm/ksm_functional_tests.c
@@ -11,7 +11,7 @@
 #include <string.h>
 #include <stdbool.h>
 #include <stdint.h>
-#include <unistd.h>
+#include <asm-generic/unistd.h>
 #include <errno.h>
 #include <fcntl.h>
 #include <sys/mman.h>
@@ -369,7 +369,6 @@ unmap:
 	munmap(map, size);
 }
 
-#ifdef __NR_userfaultfd
 static void test_unmerge_uffd_wp(void)
 {
 	struct uffdio_writeprotect uffd_writeprotect;
@@ -430,7 +429,6 @@ close_uffd:
 unmap:
 	munmap(map, size);
 }
-#endif
 
 /* Verify that KSM can be enabled / queried with prctl. */
 static void test_prctl(void)
@@ -665,9 +663,7 @@ int main(int argc, char **argv)
 		exit(test_child_ksm());
 	}
 
-#ifdef __NR_userfaultfd
 	tests++;
-#endif
 
 	ksft_print_header();
 	ksft_set_plan(tests);
@@ -694,9 +690,7 @@ int main(int argc, char **argv)
 	test_unmerge();
 	test_unmerge_zero_pages();
 	test_unmerge_discarded();
-#ifdef __NR_userfaultfd
 	test_unmerge_uffd_wp();
-#endif
 
 	test_prot_none();
 
--- a/tools/testing/selftests/mm/memfd_secret.c~selftests-mm-remove-local-__nr_-definitions
+++ a/tools/testing/selftests/mm/memfd_secret.c
@@ -17,7 +17,7 @@
 
 #include <stdlib.h>
 #include <string.h>
-#include <unistd.h>
+#include <asm-generic/unistd.h>
 #include <errno.h>
 #include <stdio.h>
 #include <fcntl.h>
@@ -28,8 +28,6 @@
 #define pass(fmt, ...) ksft_test_result_pass(fmt, ##__VA_ARGS__)
 #define skip(fmt, ...) ksft_test_result_skip(fmt, ##__VA_ARGS__)
 
-#ifdef __NR_memfd_secret
-
 #define PATTERN	0x55
 
 static const int prot = PROT_READ | PROT_WRITE;
@@ -334,13 +332,3 @@ int main(int argc, char *argv[])
 
 	ksft_finished();
 }
-
-#else /* __NR_memfd_secret */
-
-int main(int argc, char *argv[])
-{
-	printf("skip: skipping memfd_secret test (missing __NR_memfd_secret)\n");
-	return KSFT_SKIP;
-}
-
-#endif /* __NR_memfd_secret */
--- a/tools/testing/selftests/mm/mkdirty.c~selftests-mm-remove-local-__nr_-definitions
+++ a/tools/testing/selftests/mm/mkdirty.c
@@ -9,7 +9,7 @@
  */
 #include <fcntl.h>
 #include <signal.h>
-#include <unistd.h>
+#include <asm-generic/unistd.h>
 #include <string.h>
 #include <errno.h>
 #include <stdlib.h>
@@ -265,7 +265,6 @@ munmap:
 	munmap(mmap_mem, mmap_size);
 }
 
-#ifdef __NR_userfaultfd
 static void test_uffdio_copy(void)
 {
 	struct uffdio_register uffdio_register;
@@ -322,7 +321,6 @@ munmap:
 	munmap(dst, pagesize);
 	free(src);
 }
-#endif /* __NR_userfaultfd */
 
 int main(void)
 {
@@ -335,9 +333,7 @@ int main(void)
 			       thpsize / 1024);
 		tests += 3;
 	}
-#ifdef __NR_userfaultfd
 	tests += 1;
-#endif /* __NR_userfaultfd */
 
 	ksft_print_header();
 	ksft_set_plan(tests);
@@ -367,9 +363,7 @@ int main(void)
 	if (thpsize)
 		test_pte_mapped_thp();
 	/* Placing a fresh page via userfaultfd may set the PTE dirty. */
-#ifdef __NR_userfaultfd
 	test_uffdio_copy();
-#endif /* __NR_userfaultfd */
 
 	err = ksft_get_fail_cnt();
 	if (err)
--- a/tools/testing/selftests/mm/mlock2.h~selftests-mm-remove-local-__nr_-definitions
+++ a/tools/testing/selftests/mm/mlock2.h
@@ -3,6 +3,7 @@
 #include <errno.h>
 #include <stdio.h>
 #include <stdlib.h>
+#include <asm-generic/unistd.h>
 
 static int mlock2_(void *start, size_t len, int flags)
 {
--- a/tools/testing/selftests/mm/pagemap_ioctl.c~selftests-mm-remove-local-__nr_-definitions
+++ a/tools/testing/selftests/mm/pagemap_ioctl.c
@@ -15,7 +15,7 @@
 #include <sys/ioctl.h>
 #include <sys/stat.h>
 #include <math.h>
-#include <asm/unistd.h>
+#include <asm-generic/unistd.h>
 #include <pthread.h>
 #include <sys/resource.h>
 #include <assert.h>
--- a/tools/testing/selftests/mm/protection_keys.c~selftests-mm-remove-local-__nr_-definitions
+++ a/tools/testing/selftests/mm/protection_keys.c
@@ -42,7 +42,7 @@
 #include <sys/wait.h>
 #include <sys/stat.h>
 #include <fcntl.h>
-#include <unistd.h>
+#include <asm-generic/unistd.h>
 #include <sys/ptrace.h>
 #include <setjmp.h>
 
--- a/tools/testing/selftests/mm/uffd-common.c~selftests-mm-remove-local-__nr_-definitions
+++ a/tools/testing/selftests/mm/uffd-common.c
@@ -673,11 +673,7 @@ int uffd_open_dev(unsigned int flags)
 
 int uffd_open_sys(unsigned int flags)
 {
-#ifdef __NR_userfaultfd
 	return syscall(__NR_userfaultfd, flags);
-#else
-	return -1;
-#endif
 }
 
 int uffd_open(unsigned int flags)
--- a/tools/testing/selftests/mm/uffd-stress.c~selftests-mm-remove-local-__nr_-definitions
+++ a/tools/testing/selftests/mm/uffd-stress.c
@@ -33,11 +33,9 @@
  * pthread_mutex_lock will also verify the atomicity of the memory
  * transfer (UFFDIO_COPY).
  */
-
+#include <asm-generic/unistd.h>
 #include "uffd-common.h"
 
-#ifdef __NR_userfaultfd
-
 #define BOUNCE_RANDOM		(1<<0)
 #define BOUNCE_RACINGFAULTS	(1<<1)
 #define BOUNCE_VERIFY		(1<<2)
@@ -466,15 +464,3 @@ int main(int argc, char **argv)
 	       nr_pages, nr_pages_per_cpu);
 	return userfaultfd_stress();
 }
-
-#else /* __NR_userfaultfd */
-
-#warning "missing __NR_userfaultfd definition"
-
-int main(void)
-{
-	printf("skip: Skipping userfaultfd test (missing __NR_userfaultfd)\n");
-	return KSFT_SKIP;
-}
-
-#endif /* __NR_userfaultfd */
--- a/tools/testing/selftests/mm/uffd-unit-tests.c~selftests-mm-remove-local-__nr_-definitions
+++ a/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -5,12 +5,11 @@
  *  Copyright (C) 2015-2023  Red Hat, Inc.
  */
 
+#include <asm-generic/unistd.h>
 #include "uffd-common.h"
 
 #include "../../../../mm/gup_test.h"
 
-#ifdef __NR_userfaultfd
-
 /* The unit test doesn't need a large or random size, make it 32MB for now */
 #define  UFFD_TEST_MEM_SIZE               (32UL << 20)
 
@@ -1554,14 +1553,3 @@ int main(int argc, char *argv[])
 	return ksft_get_fail_cnt() ? KSFT_FAIL : KSFT_PASS;
 }
 
-#else /* __NR_userfaultfd */
-
-#warning "missing __NR_userfaultfd definition"
-
-int main(void)
-{
-	printf("Skipping %s (missing __NR_userfaultfd)\n", __file__);
-	return KSFT_SKIP;
-}
-
-#endif /* __NR_userfaultfd */
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

selftests-mqueue-fix-5-warnings-about-signed-unsigned-mismatches.patch

