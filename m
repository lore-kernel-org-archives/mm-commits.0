Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6B901401B
	for <mm-commits@vger.kernel.org>; Tue,  8 Jul 2025 00:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751933384; cv=none; b=gb+1n7614Zpfhsj4TKrd2rjPoGTumIY0JXAyydwDs2FgagBPO9SbawwwKYvQoE3uLzcYcqYBXWjektW4trpaSc3Y86Paq6Y0NX8fvl0zL8wmwIElKsT0EATsf1deKXE+Q/qfbhmYFXy9F6MMuKkvtzJTtgsrSRwd3V7SF72qmhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751933384; c=relaxed/simple;
	bh=cjN5XTAC+oXG9H8OZ8BhcomGO10ZmUE3NIWK00gijkE=;
	h=Date:To:From:Subject:Message-Id; b=gwNO4DCOJsM8VSvp5leKlKLFhxymDQ9qFTkNTYobUlIHh6E9odKgxOyFePmoxRZ6Hk9T2ORJvW7Fw7GjcaCE+XZ00pYyEPRGDkisDpViSOWiVpX/bCYNCIOeVbytalUILwnna/3gZ7TVWTYxHKjovuKn3iT3IzRmWxfuWRpfNSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qkPjW09J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qkPjW09J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83516C4CEE3;
	Tue,  8 Jul 2025 00:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751933384;
	bh=cjN5XTAC+oXG9H8OZ8BhcomGO10ZmUE3NIWK00gijkE=;
	h=Date:To:From:Subject:From;
	b=qkPjW09JtyYTvLTMCMTD1srvNwQWDNfURcJ/z6foj29phJrSZYWbZEeC1E9MDF84j
	 AniLL9MroyDThMI2QrvoRItL365E+obVV6NiZiul9PYBFHp77HBWgoQhAe70kBPpt7
	 lGWIySC0Ban0G3UOiS/5uoq6jqlio8aNurvHqbcQ=
Date: Mon, 07 Jul 2025 17:09:43 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,david@redhat.com,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-pagemap_scan-ioctl-add-pfn-zero-test-cases.patch added to mm-new branch
Message-Id: <20250708000944.83516C4CEE3@smtp.kernel.org>
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
Date: Mon, 7 Jul 2025 12:33:20 +0500

Add test cases to test the correctness of PFN ZERO flag of pagemap_scan
ioctl.  Test with normal pages backed memory and huge pages backed memory.

Link: https://lkml.kernel.org/r/20250707073321.106431-1-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/cow.c           |   27 -------
 tools/testing/selftests/mm/pagemap_ioctl.c |   72 ++++++++++++++++++-
 tools/testing/selftests/mm/vm_util.c       |   23 ++++++
 tools/testing/selftests/mm/vm_util.h       |    2 
 4 files changed, 95 insertions(+), 29 deletions(-)

--- a/tools/testing/selftests/mm/cow.c~selftests-mm-pagemap_scan-ioctl-add-pfn-zero-test-cases
+++ a/tools/testing/selftests/mm/cow.c
@@ -72,31 +72,6 @@ static int detect_thp_sizes(size_t sizes
 	return count;
 }
 
-static void detect_huge_zeropage(void)
-{
-	int fd = open("/sys/kernel/mm/transparent_hugepage/use_zero_page",
-		      O_RDONLY);
-	size_t enabled = 0;
-	char buf[15];
-	int ret;
-
-	if (fd < 0)
-		return;
-
-	ret = pread(fd, buf, sizeof(buf), 0);
-	if (ret > 0 && ret < sizeof(buf)) {
-		buf[ret] = 0;
-
-		enabled = strtoul(buf, NULL, 10);
-		if (enabled == 1) {
-			has_huge_zeropage = true;
-			ksft_print_msg("[INFO] huge zeropage is enabled\n");
-		}
-	}
-
-	close(fd);
-}
-
 static bool range_is_swapped(void *addr, size_t size)
 {
 	for (; size; addr += pagesize, size -= pagesize)
@@ -1903,7 +1878,7 @@ int main(int argc, char **argv)
 	}
 	nr_hugetlbsizes = detect_hugetlb_page_sizes(hugetlbsizes,
 						    ARRAY_SIZE(hugetlbsizes));
-	detect_huge_zeropage();
+	has_huge_zeropage = detect_huge_zeropage();
 
 	ksft_set_plan(ARRAY_SIZE(anon_test_cases) * tests_per_anon_test_case() +
 		      ARRAY_SIZE(anon_thp_test_cases) * tests_per_anon_thp_test_case() +
--- a/tools/testing/selftests/mm/pagemap_ioctl.c~selftests-mm-pagemap_scan-ioctl-add-pfn-zero-test-cases
+++ a/tools/testing/selftests/mm/pagemap_ioctl.c
@@ -1,4 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
+
 #define _GNU_SOURCE
 #include <stdio.h>
 #include <fcntl.h>
@@ -34,8 +35,8 @@
 #define PAGEMAP "/proc/self/pagemap"
 int pagemap_fd;
 int uffd;
-unsigned long page_size;
-unsigned int hpage_size;
+size_t page_size;
+size_t hpage_size;
 const char *progname;
 
 #define LEN(region)	((region.end - region.start)/page_size)
@@ -1480,6 +1481,68 @@ static void transact_test(int page_size)
 			      extra_thread_faults);
 }
 
+void zeropfn_tests(void)
+{
+	unsigned long long mem_size;
+	struct page_region vec;
+	int i, ret;
+	char *mmap_mem, *mem;
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
+	if (!detect_huge_zeropage()) {
+		ksft_test_result_skip("%s use_zero_page not supported or set to 1\n", __func__);
+		return;
+	}
+
+	mem_size = 2 * hpage_size;
+	mmap_mem = mmap(NULL, mem_size, PROT_READ | PROT_WRITE,
+			MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (mmap_mem == MAP_FAILED)
+		ksft_exit_fail_msg("error nomem\n");
+
+	/* We need a THP-aligned memory area. */
+	mem = (char *)(((uintptr_t)mmap_mem + hpage_size) & ~(hpage_size - 1));
+
+	ret = madvise(mem, hpage_size, MADV_HUGEPAGE);
+	if (!ret) {
+		char tmp = *mem;
+
+		asm volatile("" : "+r" (tmp));
+
+		ret = pagemap_ioctl(mem, hpage_size, &vec, 1, 0,
+				    0, PAGE_IS_PFNZERO, 0, 0, PAGE_IS_PFNZERO);
+		if (ret < 0)
+			ksft_exit_fail_msg("error %d %d %s\n", ret, errno, strerror(errno));
+
+		ksft_test_result(ret == 1 && LEN(vec) == (hpage_size / page_size),
+				 "%s all huge pages must have PFNZERO set\n", __func__);
+	} else {
+		ksft_test_result_skip("%s huge page not supported\n", __func__);
+	}
+
+	munmap(mmap_mem, mem_size);
+}
+
 int main(int __attribute__((unused)) argc, char *argv[])
 {
 	int shmid, buf_size, fd, i, ret;
@@ -1494,7 +1557,7 @@ int main(int __attribute__((unused)) arg
 	if (init_uffd())
 		ksft_exit_pass();
 
-	ksft_set_plan(115);
+	ksft_set_plan(117);
 
 	page_size = getpagesize();
 	hpage_size = read_pmd_pagesize();
@@ -1669,6 +1732,9 @@ int main(int __attribute__((unused)) arg
 	/* 16. Userfaultfd tests */
 	userfaultfd_tests();
 
+	/* 17. ZEROPFN tests */
+	zeropfn_tests();
+
 	close(pagemap_fd);
 	ksft_exit_pass();
 }
--- a/tools/testing/selftests/mm/vm_util.c~selftests-mm-pagemap_scan-ioctl-add-pfn-zero-test-cases
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -567,3 +567,26 @@ void *sys_mremap(void *old_address, unsi
 			       old_size, new_size, flags,
 			       (unsigned long)new_address);
 }
+
+bool detect_huge_zeropage(void)
+{
+	int fd = open("/sys/kernel/mm/transparent_hugepage/use_zero_page",
+		      O_RDONLY);
+	bool enabled = 0;
+	char buf[15];
+	int ret;
+
+	if (fd < 0)
+		return 0;
+
+	ret = pread(fd, buf, sizeof(buf), 0);
+	if (ret > 0 && ret < sizeof(buf)) {
+		buf[ret] = 0;
+
+		if (strtoul(buf, NULL, 10) == 1)
+			enabled = 1;
+	}
+
+	close(fd);
+	return enabled;
+}
--- a/tools/testing/selftests/mm/vm_util.h~selftests-mm-pagemap_scan-ioctl-add-pfn-zero-test-cases
+++ a/tools/testing/selftests/mm/vm_util.h
@@ -74,6 +74,8 @@ static inline void skip_test_dodgy_fs(co
 extern volatile sig_atomic_t signal_jump_set;
 extern sigjmp_buf signal_jmp_buf;
 
+bool detect_huge_zeropage(void);
+
 /*
  * Ignore the checkpatch warning, we must read from x but don't want to do
  * anything with it in order to trigger a read page fault. We therefore must use
_

Patches currently in -mm which might be from usama.anjum@collabora.com are

selftests-mm-pagemap_scan-ioctl-add-pfn-zero-test-cases.patch

