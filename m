Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A2FF3BB57
	for <mm-commits@vger.kernel.org>; Tue, 15 Sep 2026 00:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789433362; cv=none; b=V0qRVgF7YGdOYKELOvRaA391FIrsJ+XnJILG01ewvDpq9TFNT9GVoJZtfw8cjc0Dp+XV66c7x7N+rza4A7oJVXrfhHFuoWmRQRSeRodmbN5fcpjz6wfruWrSeVCW1CnZuMs/V33IhDqmxuHIFLd0mKtjAhPJqOsjnRHPgmLAc+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789433362; c=relaxed/simple;
	bh=unhM8hDs9CPz9lnoHhhy7IzUPXNd9SMGbCwQLm9wQ/8=;
	h=Date:To:From:Subject:Message-Id; b=VKp5I0pkbehsJIgQbHKbMHE26RaJN148MEwSLLn8ep+xFamBZ34aTlIhJ7eryZCPH+6EH4iKDnOy3nd7nnn861fmJ7xv23FGyn/fwrnHQHfUmZcUZPK1SO5LzvNwVa6OO+vOQHFDv4JHB7QGRdohdbZbYztDTPE5NxtG9G/aPLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CQVpwr9F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CQVpwr9F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDD451F000FF;
	Tue, 15 Sep 2026 00:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789433361;
	bh=1npo5FCrsfEUIsZj1ay/FJTq4mjXQKT5MfGz9txiZE8=;
	h=Date:To:From:Subject;
	b=CQVpwr9Fy0ZMaBb3qpelAvFrPlVTJhNfS9QOCvKtwE3JRTPJWN6CuVSngq3as2Zco
	 /ndDZQPvt0YQp1Nc44hiYUhWpIvLe4eSQBYOo8Rv/jJRYabdpgg+8vLF5KwJm9zck8
	 hFNGdw29CnCN38CCN053eJngDv/C5PMT1dWVpVFo=
Date: Mon, 14 Sep 2026 17:49:20 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,leitao@debian.org,guillaume@morinfr.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-hugetlb_madv_vs_map-add-underflow-test.patch added to mm-new branch
Message-Id: <20260915004920.DDD451F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: hugetlb_madv_vs_map: add underflow test
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-hugetlb_madv_vs_map-add-underflow-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-hugetlb_madv_vs_map-add-underflow-test.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Guillaume Morin <guillaume@morinfr.org>
Subject: selftests/mm: hugetlb_madv_vs_map: add underflow test
Date: Mon, 14 Sep 2026 17:36:21 +0200

Add a test that checks for underflows when a parent unmaps the page first.
Also check that when the child exits the reserve count is correct.

Link: https://lore.kernel.org/all/alEJkwn5VlTTH_ZX@bender.morinfr.org/
Link: https://lore.kernel.org/aqgUdbtumaO8RiIb@bender.morinfr.org
Signed-off-by: Guillaume Morin <guillaume@morinfr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Mike Rapoport <rppt@kernel.org>
---

 tools/testing/selftests/mm/hugepage_settings.c   |    9 
 tools/testing/selftests/mm/hugepage_settings.h   |    1 
 tools/testing/selftests/mm/hugetlb_madv_vs_map.c |  141 +++++++++++--
 3 files changed, 130 insertions(+), 21 deletions(-)

--- a/tools/testing/selftests/mm/hugepage_settings.c~selftests-mm-hugetlb_madv_vs_map-add-underflow-test
+++ a/tools/testing/selftests/mm/hugepage_settings.c
@@ -449,6 +449,15 @@ unsigned long hugetlb_free_pages(unsigne
 	return read_num(path);
 }
 
+unsigned long hugetlb_nr_resv_pages(unsigned long size)
+{
+	char path[PATH_MAX];
+
+	hugetlb_sysfs_path(path, sizeof(path), size, "resv_hugepages");
+
+	return read_num(path);
+}
+
 static bool __hugetlb_setup(unsigned long size, unsigned long nr)
 {
 	unsigned long free = hugetlb_free_pages(size);
--- a/tools/testing/selftests/mm/hugepage_settings.h~selftests-mm-hugetlb_madv_vs_map-add-underflow-test
+++ a/tools/testing/selftests/mm/hugepage_settings.h
@@ -98,6 +98,7 @@ unsigned long default_huge_page_size(voi
 unsigned long hugetlb_nr_pages(unsigned long size);
 void hugetlb_set_nr_pages(unsigned long size, unsigned long nr);
 unsigned long hugetlb_free_pages(unsigned long size);
+unsigned long hugetlb_nr_resv_pages(unsigned long size);
 
 static inline void hugetlb_save_settings(void)
 {
--- a/tools/testing/selftests/mm/hugetlb_madv_vs_map.c~selftests-mm-hugetlb_madv_vs_map-add-underflow-test
+++ a/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
@@ -3,18 +3,6 @@
  * A test case that must run on a system with one and only one huge page available.
  *	# echo 1 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
  *
- * During setup, the test allocates the only available page, and starts three threads:
- *  - thread1:
- *	* madvise(MADV_DONTNEED) on the allocated huge page
- *  - thread 2:
- *	* Write to the allocated huge page
- *  - thread 3:
- *	* Try to allocated an extra huge page (which must not available)
- *
- *  The test fails if thread3 is able to allocate a page.
- *
- *  Touching the first page after thread3's allocation will raise a SIGBUS
- *
  *  Author: Breno Leitao <leitao@debian.org>
  */
 #include <pthread.h>
@@ -22,6 +10,7 @@
 #include <stdlib.h>
 #include <sys/mman.h>
 #include <sys/types.h>
+#include <sys/wait.h>
 #include <unistd.h>
 
 #include "vm_util.h"
@@ -74,7 +63,21 @@ void *map_extra(void *unused)
 	return NULL;
 }
 
-int main(void)
+/* During setup in main, the only available page was allocated. This test then
+ * starts three threads:
+ *
+ * - thread1:
+ *	* madvise(MADV_DONTNEED) on the allocated huge page
+ *  - thread 2:
+ *	* Write to the allocated huge page
+ *  - thread 3:
+ *	* Try to allocated an extra huge page (which must not available)
+ *
+ *  The test fails if thread3 is able to allocate a page.
+ *
+ *  Touching the first page after thread3's allocation will raise a SIGBUS
+ */
+void test_madv_vs_map(void)
 {
 	pthread_t thread1, thread2, thread3;
 	void *ret;
@@ -85,13 +88,6 @@ int main(void)
 	 */
 	int max = 10;
 
-	ksft_print_header();
-	ksft_set_plan(1);
-
-	if (!hugetlb_setup_default_exact(1))
-		ksft_exit_skip("This test needs one and only one page to execute. Got %lu\n",
-			       hugetlb_free_default_pages());
-
 	mmap_size = default_huge_page_size();
 
 	while (max--) {
@@ -100,7 +96,7 @@ int main(void)
 				-1, 0);
 
 		if ((unsigned long)huge_ptr == -1)
-			ksft_exit_fail_msg("Failed to allocate huge page\n");
+			ksft_exit_fail_perror("Failed to allocate huge page");
 
 		pthread_create(&thread1, NULL, madv, NULL);
 		pthread_create(&thread2, NULL, touch, NULL);
@@ -120,5 +116,108 @@ int main(void)
 	}
 
 	ksft_test_result_pass("No unexpected huge page allocations\n");
+}
+
+/*  We create a child process, then unmap the page in the parent while the child
+ *  waits and verify that there is no underflow of the reserved count. We also
+ *  verify that after the child exits, the reserved count is properly restored.
+ */
+void test_underflow(void)
+{
+	pid_t pid;
+	int pipe_fds[2];
+	unsigned long nr_reserved = 0;
+
+	huge_ptr = mmap(NULL, mmap_size, PROT_READ | PROT_WRITE,
+			MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB, -1, 0);
+
+	if ((unsigned long)huge_ptr == -1)
+		ksft_exit_fail_perror("Failed to allocate huge page");
+
+	nr_reserved = hugetlb_nr_resv_pages(default_huge_page_size());
+	if (nr_reserved != 1)
+		ksft_exit_fail_msg("Unexpected number of reserved pages: %lu, expected 1\n",
+				   nr_reserved);
+
+	/* Force the fault to ensure the reservation is consumed */
+	*huge_ptr = 0;
+	nr_reserved = hugetlb_nr_resv_pages(default_huge_page_size());
+	if (nr_reserved != 0)
+		ksft_exit_fail_msg("Unexpected number of reserved pages: %lu, expected 0\n",
+				   nr_reserved);
+
+	if (pipe(pipe_fds) != 0)
+		ksft_exit_fail_perror("pipe failed");
+
+	pid = fork();
+	if (pid < 0)
+		ksft_exit_fail_perror("fork failed");
+
+	if (pid == 0) {
+		/* Child: Simply wait for the parent */
+		char b;
+
+		close(pipe_fds[1]);
+		if (read(pipe_fds[0], &b, 1) < 0)
+			ksft_perror("child read failed");
+		/* Let the parent do the cleanup */
+		_exit(0);
+	}
+
+	/* Parent */
+	close(pipe_fds[0]);
+
+	/* First unmap, this will close the vma */
+	if (munmap(huge_ptr, mmap_size) != 0) {
+		ksft_perror("munmap failed");
+		goto err_cleanup;
+	}
+
+	nr_reserved = hugetlb_nr_resv_pages(default_huge_page_size());
+	if (nr_reserved == 0) {
+		ksft_test_result_pass("Underflow not present!\n");
+	} else {
+		ksft_test_result_fail("Unexpected HugePages_Rsvd=%ld after munmap, should be 0\n",
+				      nr_reserved);
+		goto err_cleanup;
+	}
+	/* Make the child exit, this should restore HugePages_Rsvd to 0 */
+	if (write(pipe_fds[1], &nr_reserved, 1) < 0) {
+		/* If write failed, the child is likely already gone */
+		ksft_exit_fail_perror("write failed");
+	}
+	close(pipe_fds[1]);
+	if (waitpid(pid, NULL, 0) <= 0)
+		ksft_exit_fail_msg("waitpid failed\n");
+
+	nr_reserved = hugetlb_nr_resv_pages(default_huge_page_size());
+	if (nr_reserved == 0)
+		ksft_test_result_pass("After the child dies, HugePages_Rsvd is properly set to 0\n");
+	else
+		ksft_exit_fail_msg("Unexpected HugePages_Rsvd=%ld after the child termination munmap, should be 0\n", nr_reserved);
+
+	return;
+
+err_cleanup:
+	if (write(pipe_fds[1], &nr_reserved, 1) < 0)
+		ksft_exit_fail_perror("write failed");
+	if (waitpid(pid, NULL, 0) <= 0)
+		ksft_exit_fail_perror("waitpid failed");
+
+	ksft_exit_fail();
+}
+
+int main(void)
+{
+	ksft_print_header();
+	ksft_set_plan(3);
+
+	if (!hugetlb_setup_default_exact(1))
+		ksft_exit_skip("This test needs one and only one page to execute. Got %lu\n",
+			       hugetlb_free_default_pages());
+
+	test_madv_vs_map();
+	test_underflow();
+
 	ksft_finished();
 }
_

Patches currently in -mm which might be from guillaume@morinfr.org are

selftests-mm-hugetlb_madv_vs_map-add-underflow-test.patch

