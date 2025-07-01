Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F3BD2F1FE2
	for <mm-commits@vger.kernel.org>; Tue,  1 Jul 2025 00:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751328965; cv=none; b=c3g0Jau7RbNFakoaYIB6UZsqTvbSGn479R1NZX3aru2x9++rF4E+lmPKJY1QtC2dueJdTKJpSTBkKZSbLFohdWxfBWvh0QiRzCWnKVeAbRFqxWMmtrk4dOLpqgkg1g8iRaAu1jXSwzX0Ju0xrgRZh6/2Do++6ngBnYUXnGApyyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751328965; c=relaxed/simple;
	bh=+IWSxokQTJsOHUGxFxlFII2bAuIpjeKhdeMQzV3yCcI=;
	h=Date:To:From:Subject:Message-Id; b=fWTQiCus51Dklq4BGOlduHp6Ys//oGLxrXB0vfNjMHLAzxTG1fi/cYqOscQeUKzjvUWGa6C6GQwQoYaP3GS1/Ph/Z5MZATUv+qoUa3KCQk+SkUkLBfM7PHYJPwDbLOtrlPkQmkVgQU2JAq9duePv3VJD8Nq9CFmDgPUdqM3JXhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=f3PZ5pVm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="f3PZ5pVm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D76E8C4CEE3;
	Tue,  1 Jul 2025 00:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751328964;
	bh=+IWSxokQTJsOHUGxFxlFII2bAuIpjeKhdeMQzV3yCcI=;
	h=Date:To:From:Subject:From;
	b=f3PZ5pVmUpdZEqT96alI1ZRygjzierdnfUyXjCWQlgLGcT5aNujrVRj4FQTGtofrv
	 6Eix4dHt0E9BJSm0E6LmCL2RjQtuIQgzzGD8bdH6pn1WREQr6aRg0fBI67I4tfmVRg
	 hg1jDkQoHNhpwttpWbb3vmbcx2iEb4vuFRWlMCpI=
Date: Mon, 30 Jun 2025 17:16:04 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,david@redhat.com,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-pagemap_scan-ioctl-add-pfn-zero-test-cases.patch added to mm-new branch
Message-Id: <20250701001604.D76E8C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: pagemap_scan ioctl: add PFN ZERO test cases
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-pagemap_scan-ioctl-add-pfn-zero-test-cases.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-pagemap_scan-ioctl-add-pfn-zero-test-cases.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: selftests/mm: pagemap_scan ioctl: add PFN ZERO test cases
Date: Mon, 30 Jun 2025 15:24:42 +0500

Add test cases to test the correctness of PFN ZERO flag of pagemap_scan
ioctl.  Test with normal pages backed memory and huge pages backed memory.

Link: https://lkml.kernel.org/r/20250630102443.137809-1-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/pagemap_ioctl.c |   57 ++++++++++++++++++-
 1 file changed, 56 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/pagemap_ioctl.c~selftests-mm-pagemap_scan-ioctl-add-pfn-zero-test-cases
+++ a/tools/testing/selftests/mm/pagemap_ioctl.c
@@ -1,4 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
+
 #define _GNU_SOURCE
 #include <stdio.h>
 #include <fcntl.h>
@@ -1480,6 +1481,57 @@ static void transact_test(int page_size)
 			      extra_thread_faults);
 }
 
+void zeropfn_tests(void)
+{
+	unsigned long long mem_size;
+	struct page_region vec;
+	int i, ret;
+	char *mem;
+
+	/* Test with page backed memory */
+	mem_size = 10 * page_size;
+	mem = mmap(NULL, mem_size, PROT_READ, MAP_PRIVATE | MAP_ANON, -1, 0);
+	if (mem == MAP_FAILED)
+		ksft_exit_fail_msg("error nomem\n");
+
+	/* Touch each page to ensure it's mapped */
+	for (i = 0; i < mem_size; i += page_size)
+		(void)((volatile char *)mem)[i];
+
+	ret = pagemap_ioctl(mem, mem_size, &vec, 1, 0,
+			    (mem_size / page_size), PAGE_IS_PFNZERO, 0, 0, PAGE_IS_PFNZERO);
+	if (ret < 0)
+		ksft_exit_fail_msg("error %d %d %s\n", ret, errno, strerror(errno));
+
+	ksft_test_result(ret == 1 && LEN(vec) == (mem_size / page_size),
+			 "%s all pages must have PFNZERO set\n", __func__);
+
+	munmap(mem, mem_size);
+
+	/* Test with huge page */
+	mem_size = 10 * hpage_size;
+	mem = memalign(hpage_size, mem_size);
+	if (!mem)
+		ksft_exit_fail_msg("error nomem\n");
+
+	ret = madvise(mem, mem_size, MADV_HUGEPAGE);
+	if (ret)
+		ksft_exit_fail_msg("madvise failed %d %s\n", errno, strerror(errno));
+
+	for (i = 0; i < mem_size; i += hpage_size)
+		(void)((volatile char *)mem)[i];
+
+	ret = pagemap_ioctl(mem, mem_size, &vec, 1, 0,
+			    (mem_size / page_size), PAGE_IS_PFNZERO, 0, 0, PAGE_IS_PFNZERO);
+	if (ret < 0)
+		ksft_exit_fail_msg("error %d %d %s\n", ret, errno, strerror(errno));
+
+	ksft_test_result(ret == 1 && LEN(vec) == (mem_size / page_size),
+			 "%s all huge pages must have PFNZERO set\n", __func__);
+
+	free(mem);
+}
+
 int main(int __attribute__((unused)) argc, char *argv[])
 {
 	int shmid, buf_size, fd, i, ret;
@@ -1494,7 +1546,7 @@ int main(int __attribute__((unused)) arg
 	if (init_uffd())
 		ksft_exit_pass();
 
-	ksft_set_plan(115);
+	ksft_set_plan(117);
 
 	page_size = getpagesize();
 	hpage_size = read_pmd_pagesize();
@@ -1669,6 +1721,9 @@ int main(int __attribute__((unused)) arg
 	/* 16. Userfaultfd tests */
 	userfaultfd_tests();
 
+	/* 17. ZEROPFN tests */
+	zeropfn_tests();
+
 	close(pagemap_fd);
 	ksft_exit_pass();
 }
_

Patches currently in -mm which might be from usama.anjum@collabora.com are

selftests-mm-pagemap_scan-ioctl-add-pfn-zero-test-cases.patch

