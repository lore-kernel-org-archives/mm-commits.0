Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4120038B
	for <mm-commits@vger.kernel.org>; Fri, 14 Jun 2024 04:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718340895; cv=none; b=UPXhZh/dXToCx7Cdy4qEZJU1AEb9Tt3F+NbivNlY4PKNvPwV2ishnycrwVYUk3Kmnawesg2oCY4iOYVZgoc+rpWhKBqgc+bHdzq6vCmaEUgaskSeDKj6YipagEEfbRIDTbpLaKwoeOIqJ4fkuzgSm1hYrBBfxyXgcjPdyEegiRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718340895; c=relaxed/simple;
	bh=t5JtClvHlqNVrBo03VufcejQGHyl8vJfCOFINaC74uk=;
	h=Date:To:From:Subject:Message-Id; b=jEC/WFLNGYFspLd9MQpdJJ9caQL7n8VYoFJzzLmh0RulmoqYuMCTaxozONiv9zSuU8Z4AB+xGK+ZaIQ3Vt8EzgXZmPTpgfZtkWIPMNJ7I8hxabuynlFrvc1RScJUCe+NI6ZlOM069SaGGBYq+4fWGyFtCpto+a168MT3Ehwdstc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EJyjA5qi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EJyjA5qi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4980C2BD10;
	Fri, 14 Jun 2024 04:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718340894;
	bh=t5JtClvHlqNVrBo03VufcejQGHyl8vJfCOFINaC74uk=;
	h=Date:To:From:Subject:From;
	b=EJyjA5qiObU6sbaUH9wMG2LAU9Kiz2uwf5RvCxMz96syngzVsFo3cVjARK+Dhye6k
	 f8uuU++MpBv292EFlc/2uvsxVsVYJQJxrtat201YK5dL9c2w4GWbpN5Mt/xRv/K9WG
	 5Xbn2dHNOELBz3GZIcX0bAh5tF8R1ua7AIZVRISU=
Date: Thu, 13 Jun 2024 21:54:54 -0700
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,shuah@kernel.org,peterx@redhat.com,Liam.Howlett@oracle.com,kent.overstreet@linux.dev,kees@kernel.org,jeffxu@chromium.org,david@redhat.com,dalias@libc.org,brauner@kernel.org,axelrasmussen@google.com,avagin@google.com,jhubbard@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-mseal-self_elf-factor-out-test-macros-and-other-duplicated-items.patch added to mm-unstable branch
Message-Id: <20240614045454.B4980C2BD10@smtp.kernel.org>
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
Date: Thu, 13 Jun 2024 19:30:05 -0700

Clean up and move some copy-pasted items into a new mseal_helpers.h.

1. The test macros can be made safer and simpler, by observing that
   they are invariably called when about to return.  This means that the
   macros do not need an intrusive label to goto; they can simply return.

2. PKEY* items.  We cannot, unfortunately use pkey-helpers.h.  The
   best we can do is to factor out these few items into mseal_helpers.h.

3. These tests still need their own definition of u64, so also move
   that to the header file.

Link: https://lkml.kernel.org/r/20240614023009.221547-3-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: David Hildenbrand <david@redhat.com>
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

 tools/testing/selftests/mm/mseal_helpers.h |   41 +++++++++++++++
 tools/testing/selftests/mm/mseal_test.c    |   49 -------------------
 tools/testing/selftests/mm/seal_elf.c      |   33 ------------
 3 files changed, 43 insertions(+), 80 deletions(-)

--- /dev/null
+++ a/tools/testing/selftests/mm/mseal_helpers.h
@@ -0,0 +1,41 @@
+/* SPDX-License-Identifier: GPL-2.0 */
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
@@ -17,54 +17,7 @@
 #include <sys/ioctl.h>
 #include <sys/vfs.h>
 #include <sys/stat.h>
-
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
+#include "mseal_helpers.h"
 
 static unsigned long get_vma_size(void *addr, int *prot)
 {
--- a/tools/testing/selftests/mm/seal_elf.c~selftests-mm-mseal-self_elf-factor-out-test-macros-and-other-duplicated-items
+++ a/tools/testing/selftests/mm/seal_elf.c
@@ -16,38 +16,7 @@
 #include <sys/ioctl.h>
 #include <sys/vfs.h>
 #include <sys/stat.h>
-
-/*
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
+#include "mseal_helpers.h"
 
 /*
  * define sys_xyx to call syscall directly.
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

selftests-mm-mseal-self_elf-fix-missing-__nr_mseal.patch
selftests-mm-mseal-self_elf-factor-out-test-macros-and-other-duplicated-items.patch
selftests-mm-mseal-self_elf-rename-test_end_check-to-report_test_pass.patch
selftests-mm-fix-vm_utilc-build-failures-add-snapshot-of-fsh.patch
selftests-mm-kvm-mdwe-fixes-to-avoid-requiring-make-headers.patch
selftests-mm-remove-local-__nr_-definitions.patch
selftests-mqueue-fix-5-warnings-about-signed-unsigned-mismatches.patch

