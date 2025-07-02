Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A9EB1F03D9
	for <mm-commits@vger.kernel.org>; Wed,  2 Jul 2025 21:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751491826; cv=none; b=Os2QFNakADSbPpd0UYX2wPv5SmuhIS1fN0hYDOi17D2KZlOdSekV0EbRmHH9ZeuBpL8HDMjYW8QhKYOTADTEwg5T8J9aHDT6uoivRUrzdx45UsJlEfO+boWYj5ZnB0ZSE4Kn3UAdmA3TuQq0y32LMLIlk00qDxooo8sLR6opdPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751491826; c=relaxed/simple;
	bh=PoUE+GVejvOfkQBdd1LtiOlzahDSbctcKUf47u1+vao=;
	h=Date:To:From:Subject:Message-Id; b=lTPVKT9n1mYrSWrQ7YenP3nUSdjKMKYpw7IdykAPrnYOKoyuGZg+gGU2buyfTcULBWCvDMAqS5wO/cXOQXfZJol2maJFdLLqj4bxBnbgHDJcTEXL8UmsgbSKAnzLyuvSEAjBTzwsw11BY7qPYcGoInI1Y0cV/FoCfGmBEKQdWqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0psncPMa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0psncPMa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F10E4C4CEEE;
	Wed,  2 Jul 2025 21:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751491826;
	bh=PoUE+GVejvOfkQBdd1LtiOlzahDSbctcKUf47u1+vao=;
	h=Date:To:From:Subject:From;
	b=0psncPMa47WWSwza1apHvmJSTWDzZEGl28WwD8uGzknPabuETBRHi7BKSJrORjoyx
	 TGj9VhrVLJWa355/P/im5Et/AQyRjjjXGMhH/V77IF6ln2kNcS3oI1nzCJdPtuzX1e
	 wf2dXluinNhnQDS4bfRAQVAYMJUE/hkh2aGbyNwA=
Date: Wed, 02 Jul 2025 14:30:25 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,david@redhat.com,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-pagemap_scan-ioctl-add-pfn-zero-test-cases.patch added to mm-new branch
Message-Id: <20250702213025.F10E4C4CEEE@smtp.kernel.org>
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
Date: Wed, 2 Jul 2025 19:20:51 +0500

Add test cases to test the correctness of PFN ZERO flag of pagemap_scan
ioctl.  Test with normal pages backed memory and huge pages backed memory.

Link: https://lkml.kernel.org/r/20250702142052.45116-1-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/pagemap_ioctl.c |   86 ++++++++++++++++++-
 1 file changed, 85 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/pagemap_ioctl.c~selftests-mm-pagemap_scan-ioctl-add-pfn-zero-test-cases
+++ a/tools/testing/selftests/mm/pagemap_ioctl.c
@@ -1,4 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
+
 #define _GNU_SOURCE
 #include <stdio.h>
 #include <fcntl.h>
@@ -1480,6 +1481,86 @@ static void transact_test(int page_size)
 			      extra_thread_faults);
 }
 
+bool is_use_zero_page_set(void)
+{
+	ssize_t bytes_read;
+	char buffer[2];
+	int fd;
+
+	fd = open("/sys/kernel/mm/transparent_hugepage/use_zero_page", O_RDONLY);
+	if (fd < 0)
+		return 0;
+
+	bytes_read = read(fd, buffer, sizeof(buffer) - 1);
+	if (bytes_read <= 0) {
+		close(fd);
+		return 0;
+	}
+
+	close(fd);
+	if (atoi(buffer) != 1)
+		return 0;
+
+	return 1;
+}
+
+void zeropfn_tests(void)
+{
+	unsigned long long mem_size;
+	struct page_region vec;
+	int i, ret;
+	char *mem;
+
+	/* Test with normal memory */
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
+	/* Test with huge page if user_zero_page is set to 1 */
+	if (!is_use_zero_page_set()) {
+		ksft_test_result_skip("%s use_zero_page not supported or set to 1\n", __func__);
+		return;
+	}
+
+	mem_size = 10 * hpage_size;
+	mem = memalign(hpage_size, mem_size);
+	if (!mem)
+		ksft_exit_fail_msg("error nomem\n");
+
+	ret = madvise(mem, mem_size, MADV_HUGEPAGE);
+	if (!ret) {
+		for (i = 0; i < mem_size; i += hpage_size)
+			(void)((volatile char *)mem)[i];
+
+		ret = pagemap_ioctl(mem, mem_size, &vec, 1, 0,
+				    (mem_size / page_size), PAGE_IS_PFNZERO, 0, 0, PAGE_IS_PFNZERO);
+		if (ret < 0)
+			ksft_exit_fail_msg("error %d %d %s\n", ret, errno, strerror(errno));
+
+		ksft_test_result(ret == 1 && LEN(vec) == (mem_size / page_size),
+				 "%s all huge pages must have PFNZERO set\n", __func__);
+
+		free(mem);
+	} else {
+		ksft_test_result_skip("%s huge page not supported\n", __func__);
+	}
+}
+
 int main(int __attribute__((unused)) argc, char *argv[])
 {
 	int shmid, buf_size, fd, i, ret;
@@ -1494,7 +1575,7 @@ int main(int __attribute__((unused)) arg
 	if (init_uffd())
 		ksft_exit_pass();
 
-	ksft_set_plan(115);
+	ksft_set_plan(117);
 
 	page_size = getpagesize();
 	hpage_size = read_pmd_pagesize();
@@ -1669,6 +1750,9 @@ int main(int __attribute__((unused)) arg
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

