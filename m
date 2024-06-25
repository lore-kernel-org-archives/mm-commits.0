Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32C481448C1
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291665; cv=none; b=UjICHoAPdag+r08j+inyHe/meZ+gbsmi1BCq5WX/2i0igK/W2DZ8L2tXeWJG8sSELoOFzQCcYO7yi17TdcLOOPkPSqEgpI2OH1ABsp6kNKwIxcZBolV+knnpKVF9JYNYlqxbMhSg2fHXDcKh7XiHmd4PWhkA+mBgaiD3R1UiuIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291665; c=relaxed/simple;
	bh=UCAgEwea08EvXYL76ZIqlGgv8ZigM+kf4JaXgP0VX5A=;
	h=Date:To:From:Subject:Message-Id; b=WW2dY2j+f5E4Lm5yallvBSsxltP5MsJ7BIoQtQeSDsuJDYsNgq66ToxoZyWnHYD1g4y2wDK+mf9WjiroaFwRKYXmKaKbYjROOiQqpZKnc1RiT/gpDHOqycWjRXY6JJqJKEXNpSW+S3JtYjCV/wUWfCeVroNNtI6vy3oYMOoYFt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=x8r5UQVv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="x8r5UQVv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08C93C32782;
	Tue, 25 Jun 2024 05:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291665;
	bh=UCAgEwea08EvXYL76ZIqlGgv8ZigM+kf4JaXgP0VX5A=;
	h=Date:To:From:Subject:From;
	b=x8r5UQVvZ35pbhqHfhYvv5dTS0c938QiR3OcYlfuYnPc9aojuaEvF31aSrh8OhNNg
	 nVwvcOfXct3y+OqbAOFc1Y6VPklrg1KmSypDvliAYqNaLwbQtmH9uGhNPS1fs+c4h6
	 CaT0x1AjgwaUDlO0EWqilDNqiTXCQEAI9LMcbsBg=
Date: Mon, 24 Jun 2024 22:01:04 -0700
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,shuah@kernel.org,peterx@redhat.com,Liam.Howlett@oracle.com,kent.overstreet@linux.dev,kees@kernel.org,jeffxu@chromium.org,david@redhat.com,dalias@libc.org,brauner@kernel.org,axelrasmussen@google.com,avagin@google.com,jhubbard@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-mseal-self_elf-factor-out-test-macros-and-other-duplicated-items.patch removed from -mm tree
Message-Id: <20240625050105.08C93C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: mseal, self_elf: factor out test macros and other duplicated items
has been removed from the -mm tree.  Its filename was
     selftests-mm-mseal-self_elf-factor-out-test-macros-and-other-duplicated-items.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: John Hubbard <jhubbard@nvidia.com>
Subject: selftests/mm: mseal, self_elf: factor out test macros and other duplicated items
Date: Mon, 17 Jun 2024 19:24:18 -0700

Clean up and move some copy-pasted items into a new mseal_helpers.h.

1. The test macros can be made safer and simpler, by observing that
   they are invariably called when about to return.  This means that the
   macros do not need an intrusive label to goto; they can simply return.

2. PKEY* items.  We cannot, unfortunately use pkey-helpers.h.  The
   best we can do is to factor out these few items into mseal_helpers.h.

3. These tests still need their own definition of u64, so also move
   that to the header file.

4.  Be sure to include the new mseal_helpers.h in the Makefile
   dependencies.

[jhubbard@nvidia.com: include the new mseal_helpers.h in Makefile dependencies]
  Link: https://lkml.kernel.org/r/01685978-f6b1-4c24-8397-22cd3c24b91a@nvidia.com
Link: https://lkml.kernel.org/r/20240618022422.804305-3-jhubbard@nvidia.com
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

 tools/testing/selftests/mm/Makefile        |    1 
 tools/testing/selftests/mm/mseal_helpers.h |   41 +++++++++++++++
 tools/testing/selftests/mm/mseal_test.c    |   49 -------------------
 tools/testing/selftests/mm/seal_elf.c      |   33 ------------
 4 files changed, 44 insertions(+), 80 deletions(-)

--- a/tools/testing/selftests/mm/Makefile~selftests-mm-mseal-self_elf-factor-out-test-macros-and-other-duplicated-items
+++ a/tools/testing/selftests/mm/Makefile
@@ -2,6 +2,7 @@
 # Makefile for mm selftests
 
 LOCAL_HDRS += $(selfdir)/mm/local_config.h $(top_srcdir)/mm/gup_test.h
+LOCAL_HDRS += $(selfdir)/mm/mseal_helpers.h
 
 include local_config.mk
 
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

selftests-mqueue-fix-5-warnings-about-signed-unsigned-mismatches.patch

