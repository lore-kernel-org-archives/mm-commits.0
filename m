Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0073A929
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560106; cv=none; b=tM63mst+ixTiP19sdIqLI7cO8WcJMD3aZZ5JaOCq2pUKoOGF3YR2la0nLzVCctbzH/X0ynp+Z79fS8ZFFaVdbmg7+uQEsCcdZZX6iltGBXUxVYVIopojTOe/ZIixemI44TP15YPC0yg7Aa09Z0p9HrbUiwEmpfiwmeuZDOMSe+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560106; c=relaxed/simple;
	bh=sNLaAvNZfLfCHhBnqxK+lnKKqniBrPshdvn49GBlWus=;
	h=Date:To:From:Subject:Message-Id; b=Br+3lmy4Bz1zcPPGj1oSy81UiPGaTzz3hjzb2jBmQTRPybXJVjCxik9CRS0uLsfnP+XGXxQpxk4Brz7rAPcxWRPmSbr9Stn3i5mJ/m2K6EQoFvSM30TgMaxiSxCzhoSSmg/0d6glex4gmJNxvJVMcWXO9c8yQay2kDQsARUfeXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HnUTT5xm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HnUTT5xm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4AC9C43390;
	Thu, 22 Feb 2024 00:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560105;
	bh=sNLaAvNZfLfCHhBnqxK+lnKKqniBrPshdvn49GBlWus=;
	h=Date:To:From:Subject:From;
	b=HnUTT5xm13E9bWJOcDqL9ArWdKdoTp/hI6gNhn5Dke7NzEPg0/PdqEpleBUTQLNMY
	 6yt1mf91CLHGGuXCwKLb0lcmW1Ql68hdYzLJL9XxmElLXDtNidawp0aJwEPpoCQTVN
	 QvVpa/Y/R2soDE6yo7BwkrMmhtCwlWXwEViAUal0=
Date: Wed, 21 Feb 2024 16:01:45 -0800
To: mm-commits@vger.kernel.org,vegard.nossum@oracle.com,songmuchun@bytedance.com,shy828301@gmail.com,shuah@kernel.org,rppt@kernel.org,riel@surriel.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-new-test-that-steals-pages.patch removed from -mm tree
Message-Id: <20240222000145.B4AC9C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: new test that steals pages
has been removed from the -mm tree.  Its filename was
     selftests-mm-new-test-that-steals-pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Breno Leitao <leitao@debian.org>
Subject: selftests/mm: new test that steals pages
Date: Fri, 5 Jan 2024 07:54:19 -0800

This test stresses the race between of madvise(DONTNEED), a page fault
and a parallel huge page mmap, which should fail due to lack of
available page available for mapping.

This test case must run on a system with one and only one huge page
available.

	# echo 1 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages

During setup, the test allocates the only available page, and starts
three threads:

  - thread 1:
      * madvise(MADV_DONTNEED) on the allocated huge page
  - thread 2:
      * Write to the allocated huge page
  - thread 3:
      * Tries to allocated (steal) an extra huge page (which is not
        available)

thread 3 should never succeed in the allocation, since the only huge
page was never unmapped, and should be reserved.

Touching the old page after thread3 allocation will raise a SIGBUS.

Link: https://lkml.kernel.org/r/20240105155419.1939484-2-leitao@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vegard Nossum <vegard.nossum@oracle.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/.gitignore            |    1 
 tools/testing/selftests/mm/Makefile              |    1 
 tools/testing/selftests/mm/hugetlb_madv_vs_map.c |  124 +++++++++++++
 3 files changed, 126 insertions(+)

--- a/tools/testing/selftests/mm/.gitignore~selftests-mm-new-test-that-steals-pages
+++ a/tools/testing/selftests/mm/.gitignore
@@ -46,3 +46,4 @@ gup_longterm
 mkdirty
 va_high_addr_switch
 hugetlb_fault_after_madv
+hugetlb_madv_vs_map
--- /dev/null
+++ a/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
@@ -0,0 +1,124 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * A test case that must run on a system with one and only one huge page available.
+ *	# echo 1 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
+ *
+ * During setup, the test allocates the only available page, and starts three threads:
+ *  - thread1:
+ *	* madvise(MADV_DONTNEED) on the allocated huge page
+ *  - thread 2:
+ *	* Write to the allocated huge page
+ *  - thread 3:
+ *	* Try to allocated an extra huge page (which must not available)
+ *
+ *  The test fails if thread3 is able to allocate a page.
+ *
+ *  Touching the first page after thread3's allocation will raise a SIGBUS
+ *
+ *  Author: Breno Leitao <leitao@debian.org>
+ */
+#include <pthread.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <sys/mman.h>
+#include <sys/types.h>
+#include <unistd.h>
+
+#include "vm_util.h"
+#include "../kselftest.h"
+
+#define MMAP_SIZE (1 << 21)
+#define INLOOP_ITER 100
+
+char *huge_ptr;
+
+/* Touch the memory while it is being madvised() */
+void *touch(void *unused)
+{
+	for (int i = 0; i < INLOOP_ITER; i++)
+		huge_ptr[0] = '.';
+
+	return NULL;
+}
+
+void *madv(void *unused)
+{
+	for (int i = 0; i < INLOOP_ITER; i++)
+		madvise(huge_ptr, MMAP_SIZE, MADV_DONTNEED);
+
+	return NULL;
+}
+
+/*
+ * We got here, and there must be no huge page available for mapping
+ * The other hugepage should be flipping from used <-> reserved, because
+ * of madvise(DONTNEED).
+ */
+void *map_extra(void *unused)
+{
+	void *ptr;
+
+	for (int i = 0; i < INLOOP_ITER; i++) {
+		ptr = mmap(NULL, MMAP_SIZE, PROT_READ | PROT_WRITE,
+			   MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB,
+			   -1, 0);
+
+		if ((long)ptr != -1) {
+			/* Touching the other page now will cause a SIGBUG
+			 * huge_ptr[0] = '1';
+			 */
+			return ptr;
+		}
+	}
+
+	return NULL;
+}
+
+int main(void)
+{
+	pthread_t thread1, thread2, thread3;
+	unsigned long free_hugepages;
+	void *ret;
+
+	/*
+	 * On kernel 6.7, we are able to reproduce the problem with ~10
+	 * interactions
+	 */
+	int max = 10;
+
+	free_hugepages = get_free_hugepages();
+
+	if (free_hugepages != 1) {
+		ksft_exit_skip("This test needs one and only one page to execute. Got %lu\n",
+			       free_hugepages);
+	}
+
+	while (max--) {
+		huge_ptr = mmap(NULL, MMAP_SIZE, PROT_READ | PROT_WRITE,
+				MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB,
+				-1, 0);
+
+		if ((unsigned long)huge_ptr == -1) {
+			ksft_exit_skip("Failed to allocated huge page\n");
+			return KSFT_SKIP;
+		}
+
+		pthread_create(&thread1, NULL, madv, NULL);
+		pthread_create(&thread2, NULL, touch, NULL);
+		pthread_create(&thread3, NULL, map_extra, NULL);
+
+		pthread_join(thread1, NULL);
+		pthread_join(thread2, NULL);
+		pthread_join(thread3, &ret);
+
+		if (ret) {
+			ksft_test_result_fail("Unexpected huge page allocation\n");
+			return KSFT_FAIL;
+		}
+
+		/* Unmap and restart */
+		munmap(huge_ptr, MMAP_SIZE);
+	}
+
+	return KSFT_PASS;
+}
--- a/tools/testing/selftests/mm/Makefile~selftests-mm-new-test-that-steals-pages
+++ a/tools/testing/selftests/mm/Makefile
@@ -70,6 +70,7 @@ TEST_GEN_FILES += ksm_tests
 TEST_GEN_FILES += ksm_functional_tests
 TEST_GEN_FILES += mdwe_test
 TEST_GEN_FILES += hugetlb_fault_after_madv
+TEST_GEN_FILES += hugetlb_madv_vs_map
 
 ifneq ($(ARCH),arm64)
 TEST_GEN_FILES += soft-dirty
_

Patches currently in -mm which might be from leitao@debian.org are


