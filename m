Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5553416D32D
	for <mm-commits@vger.kernel.org>; Tue, 18 Jun 2024 20:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718743508; cv=none; b=pgO86+ZPG965GD5xA3kYXnnpBHshwx0DxxK9E+YRVWsac29ANX45rjnmFGshf6U/gnPz5lA6HWyn4crgarVquyoocyqQ+GzvtQ7Vl1/N0/QhUfJ1cvqfbCS9AuQ2A91ZDF0D/QVtlxmWmx/p2NtnV1vb5C9n2Trgix0NwhlHVdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718743508; c=relaxed/simple;
	bh=MQxunanN5eLcKvBiTGwINb91PXFYlwJOitczlz6PEAU=;
	h=Date:To:From:Subject:Message-Id; b=HBa/9NyOuxAlcDirPerISV6lL3xiSQlDk49y3qjfOFQbabPmquN2DY176iqK6Zorh/G+l4DXNBDRU0n2nme7eunF0YtVTd8xwBoLk/Owcu+UVLGZs1ipY3o5tUFLgXVs+mEUOA+/NbtWl18RtgPJDx5G4RjbL5ZOwyY9LLKMnYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VjvZMGt6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VjvZMGt6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF581C3277B;
	Tue, 18 Jun 2024 20:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718743507;
	bh=MQxunanN5eLcKvBiTGwINb91PXFYlwJOitczlz6PEAU=;
	h=Date:To:From:Subject:From;
	b=VjvZMGt6D4fedLAv4v7fkvL9oEZ/TJ4QuWcrBb9W1QZddoVjzjOHZMjhSeLDYVqMb
	 kv6hYyjYaUSmph+1rlwk4U9K1ak971wbxivZWGBAB/OI3ekCt3OBunhjx6yKN5quhV
	 Lsv0ZsSG0D15JoAx16O6bvH6NO3KknTO5vVaK9EY=
Date: Tue, 18 Jun 2024 13:45:07 -0700
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,shuah@kernel.org,peterx@redhat.com,Liam.Howlett@oracle.com,kent.overstreet@linux.dev,kees@kernel.org,jeffxu@chromium.org,david@redhat.com,dalias@libc.org,brauner@kernel.org,axelrasmussen@google.com,avagin@google.com,jhubbard@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-remove-local-__nr_-definitions.patch added to mm-unstable branch
Message-Id: <20240618204507.BF581C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: remove local __NR_* definitions
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-remove-local-__nr_-definitions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-remove-local-__nr_-definitions.patch

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
@@ -686,9 +684,7 @@ int main(int argc, char **argv)
 		exit(test_child_ksm());
 	}
 
-#ifdef __NR_userfaultfd
 	tests++;
-#endif
 
 	ksft_print_header();
 	ksft_set_plan(tests);
@@ -700,9 +696,7 @@ int main(int argc, char **argv)
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

selftests-mm-mseal-self_elf-fix-missing-__nr_mseal.patch
selftests-mm-mseal-self_elf-factor-out-test-macros-and-other-duplicated-items.patch
selftests-mm-mseal-self_elf-factor-out-test-macros-and-other-duplicated-items-fix.patch
selftests-mm-mseal-self_elf-rename-test_end_check-to-report_test_pass.patch
selftests-mm-fix-vm_utilc-build-failures-add-snapshot-of-fsh.patch
selftests-mm-kvm-mdwe-fixes-to-avoid-requiring-make-headers.patch
selftests-mm-remove-local-__nr_-definitions.patch
selftests-mqueue-fix-5-warnings-about-signed-unsigned-mismatches.patch

