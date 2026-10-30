Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793343120;
	b=TNrKlLO1GYnBAiEGZ/5cUgWsEwJKsvHXtJe/PkOzHG7DJYUPQ1PFgE0f7W9sRtMu/rBz
	 RfJjUzFC795L+t4673WYYS0XgXVBjeuz6WEmGlApmkF32zi56dvWK6nhHySJlWdZO23Kl
	 E0VBMYn2vRxKOzrSwZfv8hQF8d2MEKadJOOpYrWR0KXEXv5H+V3/CJ8K+V+Lk66UjavIt
	 cat3m9gDtzWAMRWAyYxC3EUBOYvrMjhSfFuEciE9zjuE7ZiDP19U3JBwRs6Hk9q7cRnlA
	 K13zFYDJBWCRivyxy5ntKzOohok1naxPnCTMNd6AImqyktjFCPR7KYMHEectZz4579w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793343120;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=MKwYgcrmZnjxrmqFQlPDkwM5gKoIoUYjTsj+bX2KCR8=;
	b=faasZleWWPAW+OrWlRucgBwk7CGy90rMKckH4J/hZrH5K7yRXHFBSl+jgXvWgSILAGPN
	 PhKKcL+FcNnXR4t52tYZsxf8urPNhj+4vlRJwcacboEWM2RW/7n4xjMV7ICsjiJ3k58jh
	 YlZqsCWtUq0fZt+Dz1/vp52GC+f2/rHpPxtdJ3goyGkAYpE0X7RuAFkbaKSf5SLh3Ir9x
	 99FxGwDACe0MR0+Qo0FfeLBABwStDITLeqoSecsANu1hqf95oTKMYh1128EhjmFyVoeMr
	 N7bQ3dcRGlou9t6QnQnOYs7Y9vJJFS/BILU7I/y/hEHP5pcfCiKX5nRY7Dr7UNQBPIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=HTroyhXr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A43FC606A31A
	for <mm-commits@vger.kernel.org>; Fri, 30 Oct 2026 06:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=HTroyhXr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35F571F000C1;
	Fri, 30 Oct 2026 06:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793343119;
	bh=MKwYgcrmZnjxrmqFQlPDkwM5gKoIoUYjTsj+bX2KCR8=;
	h=Date:To:From:Subject;
	b=HTroyhXr8bnBCJlqzA5ncXrbBCa6ZxWhWpD6JGS8bpHIvahiM/gksdQ6c3cb4686Y
	 2Ll9JTVpPV9R6MWylmNxbU3ufwpNpHsvPIpQ1IgoBH3hejtDtH0cmsLIDPVmCgJfFB
	 o2Ip4c6HygUerIMWHLsYI2IiyUYVL8aazywmAYQI=
Date: Thu, 29 Oct 2026 23:51:58 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,
	usama.arif@linux.dev,surenb@google.com,shuah@kernel.org,
	sarthak.sharma@arm.com,ryan.roberts@arm.com,rppt@kernel.org,
	peterx@redhat.com,nico.pache@linux.dev,mhocko@suse.com,ljs@kernel.org,
	liam@infradead.org,leon@kernel.org,lance.yang@linux.dev,kas@kernel.org,
	jgg@ziepe.ca,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,
	baohua@kernel.org,yeoreum.yun@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kselftest-mm-remove-hpage_size-and-hpage_shift-macro.patch added to mm-new branch
Message-Id: <20261030065159.35F571F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: kselftest: mm: remove HPAGE_SIZE and HPAGE_SHIFT macro
has been added to the -mm mm-new branch.  Its filename is
     kselftest-mm-remove-hpage_size-and-hpage_shift-macro.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kselftest-mm-remove-hpage_size-and-hpage_shift-macro.patch

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
From: Yeoreum Yun <yeoreum.yun@arm.com>
Subject: kselftest: mm: remove HPAGE_SIZE and HPAGE_SHIFT macro
Date: Tue, 13 Oct 2026 11:37:04 +0100

HPAGE_SIZE and HPAGE_SHIFT macro is written based on the 4KB PAGE_SIZE.
When this macro is used in some test, test result would be strange in
the system where PAGE_SIZE is more then 4KB.

Here is the example with transhuge-stress test with 16KB PAGE_SIZE:

  transhuge-stress: allocate 61073 transhuge pages, using 122146 MiB virtual memory and 1908 MiB of ram
    3.292 s/loop, 0.054 ms/page,  37106.002 MiB/s	2566 succeed, 58507 failed, 2566 different pages
    0.591 s/loop, 0.010 ms/page, 206850.792 MiB/s	   0 succeed, 61073 failed,    0 different pages
    0.527 s/loop, 0.009 ms/page, 231895.107 MiB/s	   0 succeed, 61073 failed,    0 different pages
    0.527 s/loop, 0.009 ms/page, 231839.704 MiB/s	   0 succeed, 61073 failed,    0 different pages
    0.528 s/loop, 0.009 ms/page, 231544.782 MiB/s	   0 succeed, 61073 failed,    0 different pages
    0.528 s/loop, 0.009 ms/page, 231462.074 MiB/s	   0 succeed, 61073 failed,    0 different pages
    0.527 s/loop, 0.009 ms/page, 231770.300 MiB/s	   0 succeed, 61073 failed,    0 different pages
    ...
  ok 1 Completed

Remove the HPAGE_SIZE and HPAGE_SHIFT macro and introduce pmd_pshift()
helper to get the HPAGE_SHIFT properly. For HPAGE_SIZE, use pre-existing
helper, pmd_psize().

Also, run the KSM_MERGE_TIME_HUGE_PAGES test with a size of 512 MiB,
which is the least common multiple of the PMD sizes for 4 KiB, 16 KiB,
and 64 KiB base pages. Since allocate_transhuge() allocates mappings in
PMD-sized units, the test may fail with the previous size of 100 MiB,
which is not a multiple of the PMD size when the base page size is
16 KiB or 64 KiB.

After this patch, output of transhuge-stress:

  transhuge-stress: allocate 3817 transhuge pages, using 122146 MiB virtual memory and 119 MiB of ram
    2.558 s/loop, 0.670 ms/page,  47755.759 MiB/s	2585 succeed, 1232 failed, 2585 different pages
    2.640 s/loop, 0.692 ms/page,  46268.432 MiB/s	2585 succeed, 1232 failed, 2585 different pages
    2.635 s/loop, 0.690 ms/page,  46360.298 MiB/s	2585 succeed, 1232 failed, 2585 different pages
    2.782 s/loop, 0.729 ms/page,  43899.795 MiB/s	2616 succeed, 1201 failed, 2616 different pages
    2.692 s/loop, 0.705 ms/page,  45380.876 MiB/s	2627 succeed, 1190 failed, 2627 different pages
    2.612 s/loop, 0.684 ms/page,  46765.812 MiB/s	2628 succeed, 1189 failed, 2628 different pages
    2.683 s/loop, 0.703 ms/page,  45520.990 MiB/s	2630 succeed, 1187 failed, 2630 different pages
    2.727 s/loop, 0.714 ms/page,  44789.321 MiB/s	2631 succeed, 1186 failed, 2631 different pages
    ...
  ok 1 Completed

Link: https://lore.kernel.org/20261013-fix_hpage_macro-v7-2-3d77129e0557@arm.com
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Sarthak Sharma <sarthak.sharma@arm.com>
---

 tools/testing/selftests/mm/guard-regions.c    |   10 +++-
 tools/testing/selftests/mm/ksm_tests.c        |   16 ++++--
 tools/testing/selftests/mm/run_vmtests.sh     |    4 -
 tools/testing/selftests/mm/transhuge-stress.c |   25 ++++++----
 tools/testing/selftests/mm/vm_util.c          |   38 +++++++++++++---
 tools/testing/selftests/mm/vm_util.h          |    9 +--
 6 files changed, 71 insertions(+), 31 deletions(-)

--- a/tools/testing/selftests/mm/guard-regions.c~kselftest-mm-remove-hpage_size-and-hpage_shift-macro
+++ a/tools/testing/selftests/mm/guard-regions.c
@@ -2194,14 +2194,20 @@ TEST_F(guard_regions, pagemap_scan)
 TEST_F(guard_regions, collapse)
 {
 	const unsigned long page_size = self->page_size;
-	const unsigned long size = 2 * HPAGE_SIZE;
-	const unsigned long num_pages = size / page_size;
+	const uint64_t hpage_size = pmd_psize();
+	unsigned long size, num_pages;
 	char *ptr;
 	int i;
 
 	if (!thp_available())
 		SKIP(return, "Transparent Hugepages not available\n");
 
+	if (!hpage_size)
+		ksft_exit_fail_msg("reading hpage_size failed\n");
+
+	size = 2 * hpage_size;
+	num_pages = size / page_size;
+
 	/* Need file to be correct size for tests for non-anon. */
 	if (variant->backing != ANON_BACKED)
 		ASSERT_EQ(ftruncate(self->fd, size), 0);
--- a/tools/testing/selftests/mm/ksm_tests.c~kselftest-mm-remove-hpage_size-and-hpage_shift-macro
+++ a/tools/testing/selftests/mm/ksm_tests.c
@@ -520,19 +520,23 @@ static int ksm_merge_hugepages_time(int
 	struct timespec start_time, end_time;
 	unsigned long scan_time_ns;
 	int pagemap_fd, n_normal_pages, n_huge_pages;
+	const uint64_t hpage_size = pmd_psize();
 
 	if (!thp_is_enabled()) {
 		ksft_print_msg("Transparent Hugepages not available\n");
 		return KSFT_SKIP;
 	}
 
+	if (!hpage_size)
+		ksft_exit_fail_msg("reading hpage_size failed\n");
+
 	map_size *= MB;
 	size_t len = map_size;
 
-	len -= len % HPAGE_SIZE;
-	map_ptr_orig = mmap(NULL, len + HPAGE_SIZE, PROT_READ | PROT_WRITE,
+	len -= len % hpage_size;
+	map_ptr_orig = mmap(NULL, len + hpage_size, PROT_READ | PROT_WRITE,
 			MAP_ANONYMOUS | MAP_NORESERVE | MAP_PRIVATE, -1, 0);
-	map_ptr = map_ptr_orig + HPAGE_SIZE - (uintptr_t)map_ptr_orig % HPAGE_SIZE;
+	map_ptr = map_ptr_orig + hpage_size - (uintptr_t)map_ptr_orig % hpage_size;
 
 	if (map_ptr_orig == MAP_FAILED)
 		err(2, "initial mmap");
@@ -546,7 +550,7 @@ static int ksm_merge_hugepages_time(int
 
 	n_normal_pages = 0;
 	n_huge_pages = 0;
-	for (void *p = map_ptr; p < map_ptr + len; p += HPAGE_SIZE) {
+	for (void *p = map_ptr; p < map_ptr + len; p += hpage_size) {
 		if (allocate_transhuge(p, pagemap_fd) < 0)
 			n_normal_pages++;
 		else
@@ -577,11 +581,11 @@ static int ksm_merge_hugepages_time(int
 	ksft_print_msg("Average speed:  %.3f MiB/s\n", (map_size / MB) /
 					       ((double)scan_time_ns / NSEC_PER_SEC));
 
-	munmap(map_ptr_orig, len + HPAGE_SIZE);
+	munmap(map_ptr_orig, len + hpage_size);
 	return KSFT_PASS;
 
 err_out:
-	munmap(map_ptr_orig, len + HPAGE_SIZE);
+	munmap(map_ptr_orig, len + hpage_size);
 	return KSFT_FAIL;
 }
 
--- a/tools/testing/selftests/mm/run_vmtests.sh~kselftest-mm-remove-hpage_size-and-hpage_shift-macro
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -356,8 +356,8 @@ fi
 CATEGORY="memfd_secret" run_test ./memfd_secret
 fi
 
-# KSM KSM_MERGE_TIME_HUGE_PAGES test with size of 100
-CATEGORY="ksm" run_test ./ksm_tests -H -s 100
+# KSM KSM_MERGE_TIME_HUGE_PAGES test with size of 512
+CATEGORY="ksm" run_test ./ksm_tests -H -s 512
 # KSM KSM_MERGE_TIME test with size of 100
 CATEGORY="ksm" run_test ./ksm_tests -P -s 100
 # KSM MADV_MERGEABLE test with 10 identical pages
--- a/tools/testing/selftests/mm/transhuge-stress.c~kselftest-mm-remove-hpage_size-and-hpage_shift-macro
+++ a/tools/testing/selftests/mm/transhuge-stress.c
@@ -34,12 +34,17 @@ int main(int argc, char **argv)
 	size_t map_len;
 	int pagemap_fd;
 	int duration = 0;
+	const uint64_t hpage_size = pmd_psize();
+	const uint64_t hpage_shift = pmd_pshift();
 
 	ksft_print_header();
 
 	if (!thp_is_enabled())
 		ksft_exit_skip("Transparent Hugepages not available\n");
 
+	if (!hpage_size || !hpage_shift)
+		ksft_exit_fail_msg("reading hpage_size failed\n");
+
 	ram = sysconf(_SC_PHYS_PAGES);
 	if (ram > SIZE_MAX / psize() / 4)
 		ram = SIZE_MAX / 4;
@@ -69,23 +74,23 @@ int main(int argc, char **argv)
 	}
 
 	warnx("allocate %zd transhuge pages, using %zd MiB virtual memory"
-	      " and %zd MiB of ram", len >> HPAGE_SHIFT, len >> 20,
-	      ram >> (20 + HPAGE_SHIFT - pshift() - 1));
+	      " and %zd MiB of ram", len >> hpage_shift, len >> 20,
+	      ram >> (20 + hpage_shift - pshift() - 1));
 
 	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
 	if (pagemap_fd < 0)
 		ksft_exit_fail_msg("open pagemap\n");
 
-	len -= len % HPAGE_SIZE;
-	ptr = mmap(NULL, len + HPAGE_SIZE, PROT_RW, mmap_flags, backing_fd, 0);
+	len -= len % hpage_size;
+	ptr = mmap(NULL, len + hpage_size, PROT_RW, mmap_flags, backing_fd, 0);
 	if (ptr == MAP_FAILED)
 		ksft_exit_fail_msg("initial mmap");
-	ptr += HPAGE_SIZE - (uintptr_t)ptr % HPAGE_SIZE;
+	ptr += hpage_size - (uintptr_t)ptr % hpage_size;
 
 	if (madvise(ptr, len, MADV_HUGEPAGE))
 		ksft_exit_fail_msg("MADV_HUGEPAGE");
 
-	map_len = ram >> (HPAGE_SHIFT - 1);
+	map_len = ram >> (hpage_shift - 1);
 	map = malloc(map_len);
 	if (!map)
 		ksft_exit_fail_msg("map malloc\n");
@@ -98,7 +103,7 @@ int main(int argc, char **argv)
 		memset(map, 0, map_len);
 
 		clock_gettime(CLOCK_MONOTONIC, &a);
-		for (p = ptr; p < ptr + len; p += HPAGE_SIZE) {
+		for (p = ptr; p < ptr + len; p += hpage_size) {
 			int64_t pfn;
 
 			pfn = allocate_transhuge(p, pagemap_fd);
@@ -106,7 +111,7 @@ int main(int argc, char **argv)
 			if (pfn < 0) {
 				nr_failed++;
 			} else {
-				size_t idx = pfn >> (HPAGE_SHIFT - pshift());
+				size_t idx = pfn >> (hpage_shift - pshift());
 
 				nr_succeed++;
 				if (idx >= map_len) {
@@ -122,7 +127,7 @@ int main(int argc, char **argv)
 			}
 
 			/* split transhuge page, keep last page */
-			if (madvise(p, HPAGE_SIZE - psize(), MADV_DONTNEED))
+			if (madvise(p, hpage_size - psize(), MADV_DONTNEED))
 				ksft_exit_fail_msg("MADV_DONTNEED");
 		}
 		clock_gettime(CLOCK_MONOTONIC, &b);
@@ -130,7 +135,7 @@ int main(int argc, char **argv)
 
 		ksft_print_msg("%.3f s/loop, %.3f ms/page, %10.3f MiB/s\t"
 			       "%4d succeed, %4d failed, %4d different pages\n",
-			       s, s * 1000 / (len >> HPAGE_SHIFT), len / s / (1 << 20),
+			       s, s * 1000 / (len >> hpage_shift), len / s / (1 << 20),
 			       nr_succeed, nr_failed, nr_pages);
 
 		if (duration > 0 && b.tv_sec - start.tv_sec >= duration) {
--- a/tools/testing/selftests/mm/vm_util.c~kselftest-mm-remove-hpage_size-and-hpage_shift-macro
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -21,6 +21,8 @@
 
 unsigned int __page_size;
 unsigned int __page_shift;
+uint64_t __pmd_psize = -1ull;
+uint64_t __pmd_pshift = -1ull;
 
 uint64_t pagemap_get_entry(int fd, char *start)
 {
@@ -161,19 +163,40 @@ uint64_t pmd_psize(void)
 	char buf[20];
 	ssize_t num_read;
 
+	if (__pmd_psize != -1ull)
+		return __pmd_psize;
+
 	fd = open(PMD_SIZE_FILE_PATH, O_RDONLY);
-	if (fd == -1)
+	if (fd == -1) {
+		__pmd_psize = 0;
 		return 0;
+	}
 
 	num_read = read(fd, buf, 19);
 	if (num_read < 1) {
+		__pmd_psize = 0;
 		close(fd);
 		return 0;
 	}
 	buf[num_read] = '\0';
 	close(fd);
 
-	return strtoul(buf, NULL, 10);
+	__pmd_psize = strtoul(buf, NULL, 10);
+
+	return __pmd_psize;
+}
+
+uint64_t pmd_pshift(void)
+{
+	if (__pmd_pshift != -1ull)
+		return __pmd_pshift;
+
+	if (__pmd_psize == -1ull)
+		__pmd_psize = pmd_psize();
+
+	__pmd_pshift = (__pmd_psize > 0) ? ffsl(__pmd_psize) - 1 : 0;
+
+	return __pmd_pshift;
 }
 
 unsigned long rss_anon(void)
@@ -489,14 +512,19 @@ bool check_huge_file(void *addr, size_t
 int64_t allocate_transhuge(void *ptr, int pagemap_fd)
 {
 	uint64_t ent[2];
+	const uint64_t hpage_size = pmd_psize();
+	const uint64_t hpage_shift = pmd_pshift();
+
+	if (!hpage_size || !hpage_shift)
+		return -1;
 
 	/* drop pmd */
-	if (mmap(ptr, HPAGE_SIZE, PROT_READ | PROT_WRITE,
+	if (mmap(ptr, hpage_size, PROT_READ | PROT_WRITE,
 		 MAP_FIXED | MAP_ANONYMOUS |
 		 MAP_NORESERVE | MAP_PRIVATE, -1, 0) != ptr)
 		ksft_exit_fail_msg("mmap transhuge\n");
 
-	if (madvise(ptr, HPAGE_SIZE, MADV_HUGEPAGE))
+	if (madvise(ptr, hpage_size, MADV_HUGEPAGE))
 		ksft_exit_fail_msg("MADV_HUGEPAGE\n");
 
 	/* allocate transparent huge page */
@@ -508,7 +536,7 @@ int64_t allocate_transhuge(void *ptr, in
 
 	if (PAGEMAP_PRESENT(ent[0]) && PAGEMAP_PRESENT(ent[1]) &&
 	    PAGEMAP_PFN(ent[0]) + 1 == PAGEMAP_PFN(ent[1]) &&
-	    !(PAGEMAP_PFN(ent[0]) & ((1 << (HPAGE_SHIFT - pshift())) - 1)))
+	    !(PAGEMAP_PFN(ent[0]) & ((1 << (hpage_shift - pshift())) - 1)))
 		return PAGEMAP_PFN(ent[0]);
 
 	return -1;
--- a/tools/testing/selftests/mm/vm_util.h~kselftest-mm-remove-hpage_size-and-hpage_shift-macro
+++ a/tools/testing/selftests/mm/vm_util.h
@@ -35,6 +35,8 @@
 
 extern unsigned int __page_size;
 extern unsigned int __page_shift;
+extern uint64_t __pmd_psize;
+extern uint64_t __pmd_pshift;
 
 /*
  * Represents an open fd and PROCMAP_QUERY state for binary (via ioctl)
@@ -93,6 +95,7 @@ unsigned long pagemap_get_pfn(int fd, ch
 void clear_softdirty(void);
 bool check_for_pattern(FILE *fp, const char *pattern, char *buf, size_t len);
 uint64_t pmd_psize(void);
+uint64_t pmd_pshift(void);
 unsigned long rss_anon(void);
 bool check_huge_anon(void *addr, size_t len, int nr_hpages, uint64_t hpage_size);
 bool check_huge_file(void *addr, size_t len, int nr_hpages, uint64_t hpage_size);
@@ -168,12 +171,6 @@ int ksm_stop(void);
 int get_hardware_corrupted_size(unsigned long *val);
 int unpoison_memory(unsigned long pfn);
 
-/*
- * On ppc64 this will only work with radix 2M hugepage size
- */
-#define HPAGE_SHIFT 21
-#define HPAGE_SIZE (1 << HPAGE_SHIFT)
-
 #define PAGEMAP_PRESENT(ent)	(((ent) & (1ull << 63)) != 0)
 #define PAGEMAP_PFN(ent)	((ent) & ((1ull << 55) - 1))
 
_

Patches currently in -mm which might be from yeoreum.yun@arm.com are

kselftest-mm-rename-read_pmd_pagesize-to-pmd_psize.patch
kselftest-mm-remove-hpage_size-and-hpage_shift-macro.patch
kselftest-mm-introduce-size_to_shift-helper.patch

