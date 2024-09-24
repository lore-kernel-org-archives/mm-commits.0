Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8467713D25E
	for <mm-commits@vger.kernel.org>; Tue, 24 Sep 2024 21:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727215177; cv=none; b=czzc+uLNblbIIV5U62F4k3ZlKCoM5lkwO/8msU37LBT9UffJyUnZpUYrxxhQ10ALptWyUfC14pukZoalUrjIYtgGtXVjwpFZGgjqR1dnvz3Ws2MBxsP4jMiVpiqgiepFrmz+4rCY4i6umCIe7x9wR/VrCtTBfLvlv5t3CwI0hvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727215177; c=relaxed/simple;
	bh=gsqPjJ1Dz3wX7TMgKBiBPEhZ62Q2VR6j0F/She6W2d0=;
	h=Date:To:From:Subject:Message-Id; b=SKiNlKDlsf46z2Mxw9215ODfYy+Sq6kfZsPbU7nnFezljNTNrITIjZ9/rgrkE302wceCVWD1jm1hkKL5KBhY3AGV6tSr/XFLA2LN4Vtwds6szvxsmXXXQVewbeAabl9t9rY6EzjEWqJt8QgNIzQmq6Tnunn2QwOU0sc9W8PXEhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BX7lG3Zv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BX7lG3Zv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DE88C4CEC4;
	Tue, 24 Sep 2024 21:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727215177;
	bh=gsqPjJ1Dz3wX7TMgKBiBPEhZ62Q2VR6j0F/She6W2d0=;
	h=Date:To:From:Subject:From;
	b=BX7lG3ZvCGJy6kGXayCuIE4hjOsFU0L9ffXmgiE8a90i6plV9zdM5W2h4FysFc4/K
	 D95mkVK4eLVEIz1/nIJvhKCCG5ITk2X/vi6S5OdTWsNYFQfKvfx8onM0y0QyqxUVVv
	 pTCrE/Fj2i1TV7iLg9jHVlF0lClFG76cQjS/Kb8Y=
Date: Tue, 24 Sep 2024 14:59:36 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,tsbogend@alpha.franken.de,surenb@google.com,shakeel.butt@linux.dev,richard.henderson@linaro.org,minchan@kernel.org,mattst88@gmail.com,Liam.Howlett@oracle.com,jcmvbkbc@gmail.com,James.Bottomley@HansenPartnership.com,ink@jurassic.park.msu.ru,deller@gmx.de,chris@zankel.net,arnd@arndb.de,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-add-test-for-process_madvise-pr_madv_self-flag-use.patch added to mm-unstable branch
Message-Id: <20240924215937.0DE88C4CEC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: add test for process_madvise PR_MADV_SELF flag use
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-add-test-for-process_madvise-pr_madv_self-flag-use.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-add-test-for-process_madvise-pr_madv_self-flag-use.patch

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: selftests/mm: add test for process_madvise PR_MADV_SELF flag use
Date: Tue, 24 Sep 2024 12:16:28 +0100

Add a new process_madvise() selftest, and add a test for the newly
introduced PR_MADV_SELF flag.

Assert that we can perform a vector operation of an operation that would
not be permitted on a remote mm (MADV_DONTNEED in this instance) on ones
in our own mm and that the operation is correctly peformed.

Link: https://lkml.kernel.org/r/c155cc65f732705f6bd8436a00a1821b3f2a80c5.1727176176.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Chris Zankel <chris@zankel.net>
Cc: Helge Deller <deller@gmx.de>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Richard Henderson <richard.henderson@linaro.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/.gitignore        |    1 
 tools/testing/selftests/mm/Makefile          |    1 
 tools/testing/selftests/mm/process_madvise.c |  115 +++++++++++++++++
 3 files changed, 117 insertions(+)

--- a/tools/testing/selftests/mm/.gitignore~selftests-mm-add-test-for-process_madvise-pr_madv_self-flag-use
+++ a/tools/testing/selftests/mm/.gitignore
@@ -34,6 +34,7 @@ gup_test
 va_128TBswitch
 map_fixed_noreplace
 write_to_hugetlbfs
+process_madvise
 hmm-tests
 memfd_secret
 soft-dirty
--- a/tools/testing/selftests/mm/Makefile~selftests-mm-add-test-for-process_madvise-pr_madv_self-flag-use
+++ a/tools/testing/selftests/mm/Makefile
@@ -79,6 +79,7 @@ TEST_GEN_FILES += hugetlb_fault_after_ma
 TEST_GEN_FILES += hugetlb_madv_vs_map
 TEST_GEN_FILES += hugetlb_dio
 TEST_GEN_FILES += droppable
+TEST_GEN_FILES += process_madvise
 
 ifneq ($(ARCH),arm64)
 TEST_GEN_FILES += soft-dirty
diff --git a/tools/testing/selftests/mm/process_madvise.c a/tools/testing/selftests/mm/process_madvise.c
new file mode 100644
--- /dev/null
+++ a/tools/testing/selftests/mm/process_madvise.c
@@ -0,0 +1,115 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#define _GNU_SOURCE
+#include "../kselftest_harness.h"
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/mman.h>
+#include <sys/uio.h>
+
+/* May not be available in host system yet. */
+#ifndef PR_MADV_SELF
+#define PR_MADV_SELF	(1<<0)
+#endif
+
+FIXTURE(process_madvise)
+{
+	unsigned long page_size;
+};
+
+FIXTURE_SETUP(process_madvise)
+{
+	self->page_size = (unsigned long)sysconf(_SC_PAGESIZE);
+};
+
+FIXTURE_TEARDOWN(process_madvise)
+{
+}
+
+static void populate_range(char *ptr, size_t len)
+{
+	memset(ptr, 'x', len);
+}
+
+static bool is_range_zeroed(char *ptr, size_t len)
+{
+	size_t i;
+
+	for (i = 0; i < len; i++) {
+		if (ptr[i] != '\0')
+			return false;
+	}
+
+	return true;
+}
+
+TEST_F(process_madvise, pr_madv_self)
+{
+	const unsigned long page_size = self->page_size;
+	struct iovec vec[3];
+	char *ptr_region, *ptr, *ptr2, *ptr3;
+
+	/* Establish a region in which to place VMAs. */
+	ptr_region = mmap(NULL, 100 * page_size, PROT_NONE,
+			  MAP_PRIVATE | MAP_ANON, -1, 0);
+	ASSERT_NE(ptr_region, MAP_FAILED);
+
+	/* Place a 5 page mapping offset by one page into the region. */
+	ptr = mmap(&ptr_region[page_size], 5 * page_size,
+		   PROT_READ | PROT_WRITE,
+		   MAP_FIXED | MAP_ANON | MAP_PRIVATE, -1, 0);
+	ASSERT_NE(ptr, MAP_FAILED);
+	populate_range(ptr, 5 * page_size);
+	vec[0].iov_base = ptr;
+	vec[0].iov_len = 5 * page_size;
+	/* Free the PROT_NONE region before this region. */
+	ASSERT_EQ(munmap(ptr_region, page_size), 0);
+
+	/* Place a 10 page mapping in the middle of the region. */
+	ptr2 = mmap(&ptr_region[50 * page_size], 10 * page_size,
+		    PROT_READ | PROT_WRITE,
+		    MAP_FIXED | MAP_ANON | MAP_PRIVATE, -1, 0);
+	ASSERT_NE(ptr2, MAP_FAILED);
+	populate_range(ptr2, 10 * page_size);
+	vec[1].iov_base = ptr2;
+	vec[1].iov_len = 10 * page_size;
+	/* Free the PROT_NONE region before this region. */
+	ASSERT_EQ(munmap(&ptr_region[6 * page_size], 44 * page_size), 0);
+
+	/* Place a 3 page mapping at the end of the region, offset by 1. */
+	ptr3 = mmap(&ptr_region[96 * page_size], 3 * page_size,
+		    PROT_READ | PROT_WRITE,
+		    MAP_FIXED | MAP_ANON | MAP_PRIVATE, -1, 0);
+	ASSERT_NE(ptr3, MAP_FAILED);
+	populate_range(ptr3, 3 * page_size);
+	vec[2].iov_base = ptr3;
+	vec[2].iov_len = 3 * page_size;
+	/* Free the PROT_NONE region before this region. */
+	ASSERT_EQ(munmap(&ptr_region[60 * page_size], 36 * page_size), 0);
+	/* Free the PROT_NONE region after this region. */
+	ASSERT_EQ(munmap(&ptr_region[99 * page_size], page_size), 0);
+
+	/*
+	 * OK now we should have three distinct regions of memory. Zap
+	 * them with MADV_DONTNEED. This should clear the populated ranges and
+	 * we can then assert on them being zeroed.
+	 *
+	 * The function returns the number of bytes advised, so assert this is
+	 * equal to the total size of the three regions.
+	 */
+	ASSERT_EQ(process_madvise(0, vec, 3, MADV_DONTNEED, PR_MADV_SELF),
+		  (5 + 10 + 3) * page_size);
+
+	/* Make sure these ranges are now zeroed. */
+	ASSERT_TRUE(is_range_zeroed(ptr, 5 * page_size));
+	ASSERT_TRUE(is_range_zeroed(ptr2, 10 * page_size));
+	ASSERT_TRUE(is_range_zeroed(ptr2, 3 * page_size));
+
+	/* Cleanup. */
+	ASSERT_EQ(munmap(ptr, 5 * page_size), 0);
+	ASSERT_EQ(munmap(ptr2, 10 * page_size), 0);
+	ASSERT_EQ(munmap(ptr3, 3 * page_size), 0);
+}
+
+TEST_HARNESS_MAIN
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

tools-fix-shared-radix-tree-build.patch
selftests-mm-add-pkey_sighandler_xx-hugetlb_dio-to-gitignore.patch
mm-madvise-introduce-pr_madv_self-flag-to-process_madvise.patch
selftests-mm-add-test-for-process_madvise-pr_madv_self-flag-use.patch

