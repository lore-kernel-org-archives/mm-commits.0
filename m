Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 042C41114
	for <mm-commits@vger.kernel.org>; Thu, 26 Sep 2024 12:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727354293; cv=none; b=iqnx/MU13Ei/M6XWDaDZ325DgVonU7R14SckuI6WvyTcedcWpj79BBAn8x60NcbaO5Vb9agRweAXAGPOFJCeHMNurE5Jl5ufoiCYnZGUNdW6OZJ3ZW1KrsRgpqOLYB0aEE8+wzbGdI6DZ6QXT3kh2MJWX/buKtNE6E/eERpJw6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727354293; c=relaxed/simple;
	bh=Ox5jr9bbjEJmZuyssy52u/6MtFDm1zI9k5Oe60VSQHE=;
	h=Date:To:From:Subject:Message-Id; b=Jm5vwziWph4sW3wdLxB9BDWZ7xG1eMvMgWb9k3bOrsVLE2VE0C8LPrClod3Kk5XBVPM9nNk01XW7sMjQcXnWEg8kdtkQTXllPlNHh6WspPA+NsYKHTKapqCoXlKf8dZMf+qad7t3niEJUTedWIZ2GJEjAd5v9Y0fhLROCPW8xd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=j3I+1YVs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="j3I+1YVs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C1A4C4CEC5;
	Thu, 26 Sep 2024 12:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727354292;
	bh=Ox5jr9bbjEJmZuyssy52u/6MtFDm1zI9k5Oe60VSQHE=;
	h=Date:To:From:Subject:From;
	b=j3I+1YVsdWrCLpEhLwYi511P2oXdyxMkXTQVcfUtOzviNEbUp4PikfHM9oB+LckM7
	 VjFWeCYgJZFxDleEVjgAOknWE/xBpubiFkXFa4hqtCEE36/0mOyFEhHHVt1vcQtJa9
	 RfYQ1m0TzVyyPwcv+00BgRE6wJ7P3ngG6flXXqns=
Date: Thu, 26 Sep 2024 05:38:11 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,tsbogend@alpha.franken.de,surenb@google.com,shakeel.butt@linux.dev,richard.henderson@linaro.org,pedro.falcato@gmail.com,minchan@kernel.org,mattst88@gmail.com,Liam.Howlett@oracle.com,jcmvbkbc@gmail.com,James.Bottomley@HansenPartnership.com,ink@jurassic.park.msu.ru,deller@gmx.de,chris@zankel.net,arnd@arndb.de,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] selftests-mm-add-test-for-process_madvise-pr_madv_self-flag-use.patch removed from -mm tree
Message-Id: <20240926123812.7C1A4C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: add test for process_madvise PR_MADV_SELF flag use
has been removed from the -mm tree.  Its filename was
     selftests-mm-add-test-for-process_madvise-pr_madv_self-flag-use.patch

This patch was dropped because an updated version will be issued

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
Cc: Pedro Falcato <pedro.falcato@gmail.com>
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
mm-refactor-mm_access-to-not-return-null.patch
mm-refactor-mm_access-to-not-return-null-fix.patch

