Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 653818BEF
	for <mm-commits@vger.kernel.org>; Sat,  8 Jun 2024 02:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717813690; cv=none; b=PmXsOXR+A50b+0rbN6t04rMAwpUnjw53faKmWl8IV3P7+ittBMcZ+XcyRHv9iUjAz5I/qb+/UXYn40rXnej8K4vbWbkKAkpp97QHjiEkjz/JDf80xXgJTK80+/mL4nOO+6sEn7ZLxGrxPlckRQhuyvEGuSYZmy4XpWcLoQQVjSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717813690; c=relaxed/simple;
	bh=Pw0NcauEjwt9H9nyyhyHgkLd8GUD15f5caS3Ux2LflE=;
	h=Date:To:From:Subject:Message-Id; b=ug3E9Y1lnGubLtiaOUHoK3R3wSj1s0kjkE+w1Mg0zODtCildGRLjRgl6aQHRjx+UUb6M6xcWfvYn5QcuZdoJUQoclQVIaXF9likWtXctMCxz+GStjSQP5dINzOvGnij9LgmbT2U9OxZNGjjUPhHZuyYXgfSAMP564QQ4mmV0K6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DnGyTbeY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DnGyTbeY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34728C2BBFC;
	Sat,  8 Jun 2024 02:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717813690;
	bh=Pw0NcauEjwt9H9nyyhyHgkLd8GUD15f5caS3Ux2LflE=;
	h=Date:To:From:Subject:From;
	b=DnGyTbeY0TsqHzVLVbbm9sn3m/KAOk5kyh7sss1b/433pFA2FDde1iZruENr9Kx5m
	 KaetoyeC+OPQuYVtYTQnel5K5kSO86v/fYkN5t9yCLGTwHdQHAHfKtHhtC1QVQaXBR
	 mRxs+7eLjqtWhJxxt0GWfw6w1QvoGVBR2IW2w4aI=
Date: Fri, 07 Jun 2024 19:28:09 -0700
To: mm-commits@vger.kernel.org,jeffxu@chromium.org,jhubbard@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-mseal-self_elf-factor-out-test-macros-and-other-duplicated-items.patch added to mm-unstable branch
Message-Id: <20240608022810.34728C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: mseal, self_elf: factor out test macros and other duplicated items
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-mseal-self_elf-factor-out-test-macros-and-other-duplicated-items.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-mseal-self_elf-factor-out-test-macros-and-other-duplicated-items.patch

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
Subject: selftests/mm: mseal, self_elf: factor out test macros and other duplicated items
Date: Fri, 7 Jun 2024 19:10:22 -0700

Clean up and move some copy-pasted items into mseal_helpers.h.

1. The test macros can be made safer and simpler, by observing that
   they are invariably called when about to return.  This means that the
   macros do not need an intrusive label to goto; they can simply return.

2. PKEY* items.  We cannot, unfortunately use pkey-helpers.h.  The
   best we can do is to factor out these few items into mseal_helpers.h.

3. These tests still need their own definition of u64, so also move
   that to the header file.

Link: https://lkml.kernel.org/r/20240608021023.176027-5-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Cc: Jeff Xu <jeffxu@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mseal_helpers.h |   40 +++++++++++++++
 tools/testing/selftests/mm/mseal_test.c    |   48 -------------------
 tools/testing/selftests/mm/seal_elf.c      |   32 ------------
 3 files changed, 40 insertions(+), 80 deletions(-)

--- a/tools/testing/selftests/mm/mseal_helpers.h~selftests-mm-mseal-self_elf-factor-out-test-macros-and-other-duplicated-items
+++ a/tools/testing/selftests/mm/mseal_helpers.h
@@ -3,3 +3,43 @@
 #ifndef __NR_mseal
 #define __NR_mseal 462
 #endif
+
+#define FAIL_TEST_IF_FALSE(test_passed)					\
+	do {								\
+		if (!(test_passed)) {					\
+			ksft_test_result_fail("%s: line:%d\n",		\
+						__func__, __LINE__);	\
+			return;						\
+		}							\
+	} while (0)
+
+#define SKIP_TEST_IF_FALSE(test_passed)					\
+	do {								\
+		if (!(test_passed)) {					\
+			ksft_test_result_skip("%s: line:%d\n",		\
+						__func__, __LINE__);	\
+			return;						\
+		}							\
+	} while (0)
+
+#define TEST_END_CHECK() ksft_test_result_pass("%s\n", __func__)
+
+#ifndef PKEY_DISABLE_ACCESS
+#define PKEY_DISABLE_ACCESS	0x1
+#endif
+
+#ifndef PKEY_DISABLE_WRITE
+#define PKEY_DISABLE_WRITE	0x2
+#endif
+
+#ifndef PKEY_BITS_PER_PKEY
+#define PKEY_BITS_PER_PKEY	2
+#endif
+
+#ifndef PKEY_MASK
+#define PKEY_MASK	(PKEY_DISABLE_ACCESS | PKEY_DISABLE_WRITE)
+#endif
+
+#ifndef u64
+#define u64 unsigned long long
+#endif
--- a/tools/testing/selftests/mm/mseal_test.c~selftests-mm-mseal-self_elf-factor-out-test-macros-and-other-duplicated-items
+++ a/tools/testing/selftests/mm/mseal_test.c
@@ -19,54 +19,6 @@
 #include <sys/stat.h>
 #include "mseal_helpers.h"
 
-/*
- * need those definition for manually build using gcc.
- * gcc -I ../../../../usr/include   -DDEBUG -O3  -DDEBUG -O3 mseal_test.c -o mseal_test
- */
-#ifndef PKEY_DISABLE_ACCESS
-# define PKEY_DISABLE_ACCESS    0x1
-#endif
-
-#ifndef PKEY_DISABLE_WRITE
-# define PKEY_DISABLE_WRITE     0x2
-#endif
-
-#ifndef PKEY_BITS_PER_PKEY
-#define PKEY_BITS_PER_PKEY      2
-#endif
-
-#ifndef PKEY_MASK
-#define PKEY_MASK       (PKEY_DISABLE_ACCESS | PKEY_DISABLE_WRITE)
-#endif
-
-#define FAIL_TEST_IF_FALSE(c) do {\
-		if (!(c)) {\
-			ksft_test_result_fail("%s, line:%d\n", __func__, __LINE__);\
-			goto test_end;\
-		} \
-	} \
-	while (0)
-
-#define SKIP_TEST_IF_FALSE(c) do {\
-		if (!(c)) {\
-			ksft_test_result_skip("%s, line:%d\n", __func__, __LINE__);\
-			goto test_end;\
-		} \
-	} \
-	while (0)
-
-
-#define TEST_END_CHECK() {\
-		ksft_test_result_pass("%s\n", __func__);\
-		return;\
-test_end:\
-		return;\
-}
-
-#ifndef u64
-#define u64 unsigned long long
-#endif
-
 static unsigned long get_vma_size(void *addr, int *prot)
 {
 	FILE *maps;
--- a/tools/testing/selftests/mm/seal_elf.c~selftests-mm-mseal-self_elf-factor-out-test-macros-and-other-duplicated-items
+++ a/tools/testing/selftests/mm/seal_elf.c
@@ -19,38 +19,6 @@
 #include "mseal_helpers.h"
 
 /*
- * need those definition for manually build using gcc.
- * gcc -I ../../../../usr/include   -DDEBUG -O3  -DDEBUG -O3 seal_elf.c -o seal_elf
- */
-#define FAIL_TEST_IF_FALSE(c) do {\
-		if (!(c)) {\
-			ksft_test_result_fail("%s, line:%d\n", __func__, __LINE__);\
-			goto test_end;\
-		} \
-	} \
-	while (0)
-
-#define SKIP_TEST_IF_FALSE(c) do {\
-		if (!(c)) {\
-			ksft_test_result_skip("%s, line:%d\n", __func__, __LINE__);\
-			goto test_end;\
-		} \
-	} \
-	while (0)
-
-
-#define TEST_END_CHECK() {\
-		ksft_test_result_pass("%s\n", __func__);\
-		return;\
-test_end:\
-		return;\
-}
-
-#ifndef u64
-#define u64 unsigned long long
-#endif
-
-/*
  * define sys_xyx to call syscall directly.
  */
 static int sys_mseal(void *start, size_t len)
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

selftests-mm-mseal-self_elf-fix-missing-__nr_mseal.patch
selftests-mm-fix-vm_utilc-build-failures-add-snapshot-of-fsh.patch
mm-selftests-kvm-mdwe-fixes-to-avoid-requiring-make-headers.patch
selftests-mm-mseal-self_elf-factor-out-test-macros-and-other-duplicated-items.patch
selftests-mm-mseal-self_elf-rename-test_end_check-to-report_test_pass.patch
selftests-mqueue-fix-5-warnings-about-signed-unsigned-mismatches.patch

