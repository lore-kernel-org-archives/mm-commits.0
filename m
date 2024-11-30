Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C01F01EB3D
	for <mm-commits@vger.kernel.org>; Sat, 30 Nov 2024 04:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732939532; cv=none; b=eXchBSdD5IHw6G9EYPS04i49t4HWuQ+Yxz9sjg13EGxtrpvnw0b4NdOIlCuk7fVU63GKv9BpzScQ0VgcbkGWc1ZQsbFok/LbaGDDv6anir7dDj3lMamQfG9syrTcgvQxSgwTcBrvB0mHMl24lq7ClNaNpsjbiywkFvUk0BDcU3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732939532; c=relaxed/simple;
	bh=qT7kqRweROxloBjP78qY8EWDFu4bmyRSUO+5+QSoE28=;
	h=Date:To:From:Subject:Message-Id; b=eShexYi/mFO0zELi24fQi8lXna48rMx8m+23KBkZi3GKAT0RNg1t5R4V2Y14/rKHMPG5VVtXMPKqPl9JhRCtTWgEgM8itiK7edWrjwiz585fo8EfANm4z8f90yjsR4SNATePmKO7ccPpXx642oYKVUHQljhfedK4ed6TxErXyDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XQg5Y8Vu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XQg5Y8Vu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EB19C4CECC;
	Sat, 30 Nov 2024 04:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732939532;
	bh=qT7kqRweROxloBjP78qY8EWDFu4bmyRSUO+5+QSoE28=;
	h=Date:To:From:Subject:From;
	b=XQg5Y8VuQ0lo65YWe8OzqbLQIQNR7Kh0AhRNWgAyfQtapunNM+CW5xCMyBAFlCQv7
	 uO5oWjqd8EcLdI4bOtfxFNCS9rYqEB86DUZfxlr0qpYv5Y+TRT2VIxhP64KMPnizt+
	 1pBUCJLe3cMBc/y7sCpWz00dSLegF86POwn3K8K0=
Date: Fri, 29 Nov 2024 20:05:31 -0800
To: mm-commits@vger.kernel.org,jeffxu@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftest-mm-remove-seal_elf.patch added to mm-unstable branch
Message-Id: <20241130040532.3EB19C4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftest/mm: remove seal_elf
has been added to the -mm mm-unstable branch.  Its filename is
     selftest-mm-remove-seal_elf.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftest-mm-remove-seal_elf.patch

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
From: Jeff Xu <jeffxu@chromium.org>
Subject: selftest/mm: remove seal_elf
Date: Sat, 16 Nov 2024 00:50:58 +0000

Remove seal_elf, which is a demo of mseal, we no longer need this.

Link: https://lkml.kernel.org/r/20241116005058.69091-1-jeffxu@chromium.org
Signed-off-by: Jeff Xu <jeffxu@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/.gitignore |    1 
 tools/testing/selftests/mm/Makefile   |    1 
 tools/testing/selftests/mm/seal_elf.c |  137 ------------------------
 3 files changed, 139 deletions(-)

--- a/tools/testing/selftests/mm/.gitignore~selftest-mm-remove-seal_elf
+++ a/tools/testing/selftests/mm/.gitignore
@@ -52,7 +52,6 @@ va_high_addr_switch
 hugetlb_fault_after_madv
 hugetlb_madv_vs_map
 mseal_test
-seal_elf
 droppable
 hugetlb_dio
 pkey_sighandler_tests_32
--- a/tools/testing/selftests/mm/Makefile~selftest-mm-remove-seal_elf
+++ a/tools/testing/selftests/mm/Makefile
@@ -75,7 +75,6 @@ TEST_GEN_FILES += mrelease_test
 TEST_GEN_FILES += mremap_dontunmap
 TEST_GEN_FILES += mremap_test
 TEST_GEN_FILES += mseal_test
-TEST_GEN_FILES += seal_elf
 TEST_GEN_FILES += on-fault-limit
 TEST_GEN_FILES += pagemap_ioctl
 TEST_GEN_FILES += thuge-gen
diff --git a/tools/testing/selftests/mm/seal_elf.c a/tools/testing/selftests/mm/seal_elf.c
deleted file mode 100644
--- a/tools/testing/selftests/mm/seal_elf.c
+++ /dev/null
@@ -1,137 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-#define _GNU_SOURCE
-#include <sys/mman.h>
-#include <stdint.h>
-#include <asm-generic/unistd.h>
-#include <string.h>
-#include <sys/time.h>
-#include <sys/resource.h>
-#include <stdbool.h>
-#include "../kselftest.h"
-#include <syscall.h>
-#include <errno.h>
-#include <stdio.h>
-#include <stdlib.h>
-#include <fcntl.h>
-#include <sys/ioctl.h>
-#include <sys/vfs.h>
-#include <sys/stat.h>
-#include "mseal_helpers.h"
-
-/*
- * define sys_xyx to call syscall directly.
- */
-static int sys_mseal(void *start, size_t len)
-{
-	int sret;
-
-	errno = 0;
-	sret = syscall(__NR_mseal, start, len, 0);
-	return sret;
-}
-
-static inline int sys_mprotect(void *ptr, size_t size, unsigned long prot)
-{
-	int sret;
-
-	errno = 0;
-	sret = syscall(__NR_mprotect, ptr, size, prot);
-	return sret;
-}
-
-static bool seal_support(void)
-{
-	int ret;
-	void *ptr;
-	unsigned long page_size = getpagesize();
-
-	ptr = mmap(NULL, page_size, PROT_READ, MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
-	if (ptr == (void *) -1)
-		return false;
-
-	ret = sys_mseal(ptr, page_size);
-	if (ret < 0)
-		return false;
-
-	return true;
-}
-
-const char somestr[4096] = {"READONLY"};
-
-static void test_seal_elf(void)
-{
-	int ret;
-	FILE *maps;
-	char line[512];
-	uintptr_t  addr_start, addr_end;
-	char prot[5];
-	char filename[256];
-	unsigned long page_size = getpagesize();
-	unsigned long long ptr = (unsigned long long) somestr;
-	char *somestr2 = (char *)somestr;
-
-	/*
-	 * Modify the protection of readonly somestr
-	 */
-	if (((unsigned long long)ptr % page_size) != 0)
-		ptr = (unsigned long long)ptr & ~(page_size - 1);
-
-	ksft_print_msg("somestr = %s\n", somestr);
-	ksft_print_msg("change protection to rw\n");
-	ret = sys_mprotect((void *)ptr, page_size, PROT_READ|PROT_WRITE);
-	FAIL_TEST_IF_FALSE(!ret);
-	*somestr2 = 'A';
-	ksft_print_msg("somestr is modified to: %s\n", somestr);
-	ret = sys_mprotect((void *)ptr, page_size, PROT_READ);
-	FAIL_TEST_IF_FALSE(!ret);
-
-	maps = fopen("/proc/self/maps", "r");
-	FAIL_TEST_IF_FALSE(maps);
-
-	/*
-	 * apply sealing to elf binary
-	 */
-	while (fgets(line, sizeof(line), maps)) {
-		if (sscanf(line, "%lx-%lx %4s %*x %*x:%*x %*u %255[^\n]",
-			&addr_start, &addr_end, prot, filename) == 4) {
-			if (strlen(filename)) {
-				/*
-				 * seal the mapping if read only.
-				 */
-				if (strstr(prot, "r-")) {
-					ret = sys_mseal((void *)addr_start, addr_end - addr_start);
-					FAIL_TEST_IF_FALSE(!ret);
-					ksft_print_msg("sealed: %lx-%lx %s %s\n",
-						addr_start, addr_end, prot, filename);
-					if ((uintptr_t) somestr >= addr_start &&
-						(uintptr_t) somestr <= addr_end)
-						ksft_print_msg("mapping for somestr found\n");
-				}
-			}
-		}
-	}
-	fclose(maps);
-
-	ret = sys_mprotect((void *)ptr, page_size, PROT_READ | PROT_WRITE);
-	FAIL_TEST_IF_FALSE(ret < 0);
-	ksft_print_msg("somestr is sealed, mprotect is rejected\n");
-
-	REPORT_TEST_PASS();
-}
-
-int main(int argc, char **argv)
-{
-	bool test_seal = seal_support();
-
-	ksft_print_header();
-	ksft_print_msg("pid=%d\n", getpid());
-
-	if (!test_seal)
-		ksft_exit_skip("sealing not supported, check CONFIG_64BIT\n");
-
-	ksft_set_plan(1);
-
-	test_seal_elf();
-
-	ksft_finished();
-}
_

Patches currently in -mm which might be from jeffxu@chromium.org are

selftest-mm-remove-seal_elf.patch

