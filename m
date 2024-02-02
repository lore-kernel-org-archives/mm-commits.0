Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F16561682
	for <mm-commits@vger.kernel.org>; Fri,  2 Feb 2024 12:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706876011; cv=none; b=lwqrfp+d3w0+qK7jNCqAvSK+qJP7aFzA9t7BwJH+f3Ym14diH+uCgC02cjCrRtOTd7V4VCErOKaResuS9icJMd9088k4uj5D8E65H8af1So4tWL4lzDOQbjS/375N/PzKHrz2c/UAo+uSPP2hgI4wFESaixSRRuoRTb8luuBOp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706876011; c=relaxed/simple;
	bh=Db6uKAfHW6QKl3DzSoBDUjwIvLAoFBBdhDIwTwFAzPk=;
	h=Date:To:From:Subject:Message-Id; b=Bcv9cqkTDGiDxJapkJHsFPQnXl+AcpI/c868CObtNnoViA7EZWO7vYIcvvCuBwYvgsoL1bnzNOHIyO/HJlpzcmlkuyMiGjafjEmb0QJMx6Ob7ZUg0kgo5QaiiBca+PaEZZHuI0Dz+68xKuUJm05sG/S6Iq5uJwMUgmTK8O9CrGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HSo1OXar; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HSo1OXar"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 206EDC43399;
	Fri,  2 Feb 2024 12:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706876011;
	bh=Db6uKAfHW6QKl3DzSoBDUjwIvLAoFBBdhDIwTwFAzPk=;
	h=Date:To:From:Subject:From;
	b=HSo1OXarnUH5fuiX4C5KuRRSHLJBkd4y+lpvcw8xIW6aSUvI58yyjEHB5T3Ee6GE9
	 GiGTdnKxt6nFWMMtFXM1Xo2c3ntB7QL9TDTbk9glOPZvsTG7Vc9aktGws09Lncji06
	 eP+tSQQC/2Ez4Xb4gKtjBf+/lremIrN1MqUAU8/4=
Date: Fri, 02 Feb 2024 04:13:29 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-thuge-gen-conform-to-tap-format-output.patch added to mm-unstable branch
Message-Id: <20240202121331.206EDC43399@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: thuge-gen: conform to TAP format output
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-thuge-gen-conform-to-tap-format-output.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-thuge-gen-conform-to-tap-format-output.patch

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
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: selftests/mm: thuge-gen: conform to TAP format output
Date: Wed, 31 Jan 2024 19:05:20 +0500

Conform the layout, informational and status messages to TAP. No
functional change is intended other than the layout of output messages.

Also remove un-needed logging which isn't enabled. Skip a hugepage size
if it has less free pages to avoid unnecessary failures. For examples,
some systems may not have 1GB hugepage free. So skip 1GB for testing in
this test instead of failing the entire test.

Link: https://lkml.kernel.org/r/20240131140528.320252-10-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/thuge-gen.c |  147 +++++++++++------------
 1 file changed, 75 insertions(+), 72 deletions(-)

--- a/tools/testing/selftests/mm/thuge-gen.c~selftests-mm-thuge-gen-conform-to-tap-format-output
+++ a/tools/testing/selftests/mm/thuge-gen.c
@@ -4,7 +4,7 @@
    Before running this huge pages for each huge page size must have been
    reserved.
    For large pages beyond MAX_PAGE_ORDER (like 1GB on x86) boot options must
-   be used.
+   be used. 1GB wouldn't be tested if it isn't available.
    Also shmmax must be increased.
    And you need to run as root to work around some weird permissions in shm.
    And nothing using huge pages should run in parallel.
@@ -26,8 +26,7 @@
 #include <stdarg.h>
 #include <string.h>
 #include "vm_util.h"
-
-#define err(x) perror(x), exit(1)
+#include "../kselftest.h"
 
 #define MAP_HUGE_2MB    (21 << MAP_HUGE_SHIFT)
 #define MAP_HUGE_1GB    (30 << MAP_HUGE_SHIFT)
@@ -44,11 +43,8 @@
 #define SHM_HUGE_1GB    (30 << SHM_HUGE_SHIFT)
 
 #define NUM_PAGESIZES   5
-
 #define NUM_PAGES 4
 
-#define Dprintf(fmt...) // printf(fmt)
-
 unsigned long page_sizes[NUM_PAGESIZES];
 int num_page_sizes;
 
@@ -60,28 +56,15 @@ int ilog2(unsigned long v)
 	return l;
 }
 
-void find_pagesizes(void)
-{
-	glob_t g;
-	int i;
-	glob("/sys/kernel/mm/hugepages/hugepages-*kB", 0, NULL, &g);
-	assert(g.gl_pathc <= NUM_PAGESIZES);
-	for (i = 0; i < g.gl_pathc; i++) {
-		sscanf(g.gl_pathv[i], "/sys/kernel/mm/hugepages/hugepages-%lukB",
-				&page_sizes[i]);
-		page_sizes[i] <<= 10;
-		printf("Found %luMB\n", page_sizes[i] >> 20);
-	}
-	num_page_sizes = g.gl_pathc;
-	globfree(&g);
-}
-
 void show(unsigned long ps)
 {
 	char buf[100];
+
 	if (ps == getpagesize())
 		return;
-	printf("%luMB: ", ps >> 20);
+
+	ksft_print_msg("%luMB: ", ps >> 20);
+
 	fflush(stdout);
 	snprintf(buf, sizeof buf,
 		"cat /sys/kernel/mm/hugepages/hugepages-%lukB/free_hugepages",
@@ -105,7 +88,7 @@ unsigned long read_sysfs(int warn, char
 	f = fopen(buf, "r");
 	if (!f) {
 		if (warn)
-			printf("missing %s\n", buf);
+			ksft_print_msg("missing %s\n", buf);
 		return 0;
 	}
 	if (getline(&line, &linelen, f) > 0) {
@@ -119,123 +102,143 @@ unsigned long read_sysfs(int warn, char
 unsigned long read_free(unsigned long ps)
 {
 	return read_sysfs(ps != getpagesize(),
-			"/sys/kernel/mm/hugepages/hugepages-%lukB/free_hugepages",
-			ps >> 10);
+			  "/sys/kernel/mm/hugepages/hugepages-%lukB/free_hugepages",
+			  ps >> 10);
 }
 
 void test_mmap(unsigned long size, unsigned flags)
 {
 	char *map;
 	unsigned long before, after;
-	int err;
 
 	before = read_free(size);
 	map = mmap(NULL, size*NUM_PAGES, PROT_READ|PROT_WRITE,
 			MAP_PRIVATE|MAP_ANONYMOUS|MAP_HUGETLB|flags, -1, 0);
+	if (map == MAP_FAILED)
+		ksft_exit_fail_msg("mmap: %s\n", strerror(errno));
 
-	if (map == (char *)-1) err("mmap");
 	memset(map, 0xff, size*NUM_PAGES);
 	after = read_free(size);
-	Dprintf("before %lu after %lu diff %ld size %lu\n",
-		before, after, before - after, size);
-	assert(size == getpagesize() || (before - after) == NUM_PAGES);
+
 	show(size);
-	err = munmap(map, size * NUM_PAGES);
-	assert(!err);
+	ksft_test_result(size == getpagesize() || (before - after) == NUM_PAGES,
+			 "%s mmap\n", __func__);
+
+	if (munmap(map, size * NUM_PAGES))
+		ksft_exit_fail_msg("%s: unmap %s\n", __func__, strerror(errno));
 }
 
 void test_shmget(unsigned long size, unsigned flags)
 {
 	int id;
 	unsigned long before, after;
-	int err;
+	struct shm_info i;
+	char *map;
 
 	before = read_free(size);
 	id = shmget(IPC_PRIVATE, size * NUM_PAGES, IPC_CREAT|0600|flags);
-	if (id < 0) err("shmget");
-
-	struct shm_info i;
-	if (shmctl(id, SHM_INFO, (void *)&i) < 0) err("shmctl");
-	Dprintf("alloc %lu res %lu\n", i.shm_tot, i.shm_rss);
+	if (id < 0) {
+		if (errno == EPERM) {
+			ksft_test_result_skip("shmget requires root privileges: %s\n",
+					      strerror(errno));
+			return;
+		}
+		ksft_exit_fail_msg("shmget: %s\n", strerror(errno));
+	}
 
+	if (shmctl(id, SHM_INFO, (void *)&i) < 0)
+		ksft_exit_fail_msg("shmctl: %s\n", strerror(errno));
 
-	Dprintf("id %d\n", id);
-	char *map = shmat(id, NULL, 0600);
-	if (map == (char*)-1) err("shmat");
+	map = shmat(id, NULL, 0600);
+	if (map == MAP_FAILED)
+		ksft_exit_fail_msg("shmat: %s\n", strerror(errno));
 
 	shmctl(id, IPC_RMID, NULL);
 
 	memset(map, 0xff, size*NUM_PAGES);
 	after = read_free(size);
 
-	Dprintf("before %lu after %lu diff %ld size %lu\n",
-		before, after, before - after, size);
-	assert(size == getpagesize() || (before - after) == NUM_PAGES);
 	show(size);
-	err = shmdt(map);
-	assert(!err);
+	ksft_test_result(size == getpagesize() || (before - after) == NUM_PAGES,
+			 "%s: mmap\n", __func__);
+	if (shmdt(map))
+		ksft_exit_fail_msg("%s: shmdt: %s\n", __func__, strerror(errno));
 }
 
-void sanity_checks(void)
+void find_pagesizes(void)
 {
-	int i;
 	unsigned long largest = getpagesize();
+	int i;
+	glob_t g;
 
-	for (i = 0; i < num_page_sizes; i++) {
-		if (page_sizes[i] > largest)
+	glob("/sys/kernel/mm/hugepages/hugepages-*kB", 0, NULL, &g);
+	assert(g.gl_pathc <= NUM_PAGESIZES);
+	for (i = 0; (i < g.gl_pathc) && (num_page_sizes < NUM_PAGESIZES); i++) {
+		sscanf(g.gl_pathv[i], "/sys/kernel/mm/hugepages/hugepages-%lukB",
+				&page_sizes[num_page_sizes]);
+		page_sizes[num_page_sizes] <<= 10;
+		ksft_print_msg("Found %luMB\n", page_sizes[i] >> 20);
+
+		if (page_sizes[num_page_sizes] > largest)
 			largest = page_sizes[i];
 
-		if (read_free(page_sizes[i]) < NUM_PAGES) {
-			printf("Not enough huge pages for page size %lu MB, need %u\n",
-				page_sizes[i] >> 20,
-				NUM_PAGES);
-			exit(0);
-		}
+		if (read_free(page_sizes[num_page_sizes]) >= NUM_PAGES)
+			num_page_sizes++;
+		else
+			ksft_print_msg("SKIP for size %lu MB as not enough huge pages, need %u\n",
+				       page_sizes[num_page_sizes] >> 20, NUM_PAGES);
 	}
+	globfree(&g);
 
-	if (read_sysfs(0, "/proc/sys/kernel/shmmax") < NUM_PAGES * largest) {
-		printf("Please do echo %lu > /proc/sys/kernel/shmmax", largest * NUM_PAGES);
-		exit(0);
-	}
+	if (read_sysfs(0, "/proc/sys/kernel/shmmax") < NUM_PAGES * largest)
+		ksft_exit_fail_msg("Please do echo %lu > /proc/sys/kernel/shmmax",
+				   largest * NUM_PAGES);
 
 #if defined(__x86_64__)
 	if (largest != 1U<<30) {
-		printf("No GB pages available on x86-64\n"
-		       "Please boot with hugepagesz=1G hugepages=%d\n", NUM_PAGES);
-		exit(0);
+		ksft_exit_fail_msg("No GB pages available on x86-64\n"
+				   "Please boot with hugepagesz=1G hugepages=%d\n", NUM_PAGES);
 	}
 #endif
 }
 
 int main(void)
 {
-	int i;
 	unsigned default_hps = default_huge_page_size();
+	int i;
+
+	ksft_print_header();
 
 	find_pagesizes();
 
-	sanity_checks();
+	if (!num_page_sizes)
+		ksft_finished();
+
+	ksft_set_plan(2 * num_page_sizes + 3);
 
 	for (i = 0; i < num_page_sizes; i++) {
 		unsigned long ps = page_sizes[i];
 		int arg = ilog2(ps) << MAP_HUGE_SHIFT;
-		printf("Testing %luMB mmap with shift %x\n", ps >> 20, arg);
+
+		ksft_print_msg("Testing %luMB mmap with shift %x\n", ps >> 20, arg);
 		test_mmap(ps, MAP_HUGETLB | arg);
 	}
-	printf("Testing default huge mmap\n");
+
+	ksft_print_msg("Testing default huge mmap\n");
 	test_mmap(default_hps, MAP_HUGETLB);
 
-	puts("Testing non-huge shmget");
+	ksft_print_msg("Testing non-huge shmget\n");
 	test_shmget(getpagesize(), 0);
 
 	for (i = 0; i < num_page_sizes; i++) {
 		unsigned long ps = page_sizes[i];
 		int arg = ilog2(ps) << SHM_HUGE_SHIFT;
-		printf("Testing %luMB shmget with shift %x\n", ps >> 20, arg);
+		ksft_print_msg("Testing %luMB shmget with shift %x\n", ps >> 20, arg);
 		test_shmget(ps, SHM_HUGETLB | arg);
 	}
-	puts("default huge shmget");
+
+	ksft_print_msg("default huge shmget\n");
 	test_shmget(default_hps, SHM_HUGETLB);
 
-	return 0;
+	ksft_finished();
 }
_

Patches currently in -mm which might be from usama.anjum@collabora.com are

selftests-core-include-linux-close_rangeh-for-close_range_-macros.patch
selftests-mm-map_fixed_noreplace-conform-test-to-tap-format-output.patch
selftests-mm-map_hugetlb-conform-test-to-tap-format-output.patch
selftests-mm-map_populate-conform-test-to-tap-format-output.patch
selftests-mm-mlock-random-test-conform-test-to-tap-format-output.patch
selftests-mm-mlock2-tests-conform-test-to-tap-format-output.patch
selftests-mm-mrelease_test-conform-test-to-tap-format-output.patch
selftests-mm-mremap_dontunmap-conform-test-to-tap-format-output.patch
selftests-mm-split_huge_page_test-conform-test-to-tap-format-output.patch
selftests-mm-thp_settings-conform-to-tap-format-output.patch
selftests-mm-thuge-gen-conform-to-tap-format-output.patch
selftests-mm-transhuge-stress-conform-to-tap-format-output.patch
selftests-mm-virtual_address_range-conform-to-tap-format-output.patch
selftests-mm-hugetlb_reparenting_test-do-not-unmount.patch
selftests-mm-run_vmtests-remove-sudo-and-conform-to-tap.patch
selftests-mm-run_vmtests-remove-sudo-and-conform-to-tap-fix.patch
selftests-mm-save-and-restore-nr_hugepages-value.patch
selftests-mm-protection_keys-save-restore-nr_hugepages-settings.patch
selftests-mm-run_vmtestssh-add-missing-tests.patch
selftests-mm-run_vmtestssh-add-missing-tests-fix.patch
selftests-mm-hugepage-shm-conform-test-to-tap-format-output.patch
selftests-mm-hugepage-vmemmap-conform-test-to-tap-format-output.patch
selftests-mm-hugetlb-madvise-conform-test-to-tap-format-output.patch
selftests-mm-khugepaged-conform-test-to-tap-format-output.patch
selftests-mm-hugetlb-read-hwpoison-conform-test-to-tap-format-output.patch
selftests-mm-config-add-missing-configs.patch

