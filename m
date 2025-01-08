Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDC7A19408C
	for <mm-commits@vger.kernel.org>; Wed,  8 Jan 2025 04:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736311848; cv=none; b=VFJ1wMgMBoLkqNmuO9nJ8MY0zn/rs2IjccfRoLsztN4eC5mxPtKK0Rnt27juqSC+6W42nO/n4Gq8/+ffPiHcru3aZaFq0TzjGjF91fq4H/9V9gf6q2XFUmUToA0o5xueeBApRsQ9odcDlSLjwlFMGxRECm1SRC2W4/bh2rpeNjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736311848; c=relaxed/simple;
	bh=aWbmD+Ubu8ZZXQWNkXDcH0ufwHcZwKTgF8MoYqZbkck=;
	h=Date:To:From:Subject:Message-Id; b=Ae4dQVX8pBQFND5f+w+60OeBY86YHwpiVRSofI0zoZ7GYdzYmOpmNULtJc1jgDxh4qZ2mHmRXTQCjgsYNc1SC6wbyJtMXFE7Aj3JXbue3oy/EfEBHCAopQVGhEq9nKt5c09Ysy/Z6cBW+UIerQmSqiqXc2pBi/0qlBHAA9dXENI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=quhUcRQa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="quhUcRQa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57E34C4CED0;
	Wed,  8 Jan 2025 04:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736311847;
	bh=aWbmD+Ubu8ZZXQWNkXDcH0ufwHcZwKTgF8MoYqZbkck=;
	h=Date:To:From:Subject:From;
	b=quhUcRQaxXkVCFNPAPtJZBuYGIQV4XCdnTdjRwvIdf3iTmA2Su7ALOJCiqrChQOQf
	 aStmsJ/4tmXWTsxMUVxaiGAqEAGSZh4YoSFdSWnFhZm/IbzxlnrAXKr0FQHdTEogd8
	 4O6zVsU6PpJ183MHJJDtGzaR3h3zXMiThEHbTp1k=
Date: Tue, 07 Jan 2025 20:50:46 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,shuah@kernel.org,peterx@redhat.com,muchun.song@linux.dev,mark.rutland@arm.com,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,jannh@google.com,david@redhat.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-introduce-uffd-wp-mremap-regression-test.patch added to mm-unstable branch
Message-Id: <20250108045047.57E34C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: introduce uffd-wp-mremap regression test
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-introduce-uffd-wp-mremap-regression-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-introduce-uffd-wp-mremap-regression-test.patch

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
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: selftests/mm: introduce uffd-wp-mremap regression test
Date: Tue, 7 Jan 2025 14:47:53 +0000

Introduce a test that registers a range of memory for
UFFDIO_WRITEPROTECT_MODE_WP without UFFD_FEATURE_EVENT_REMAP.  First check
that the uffd-wp bit is set for every PTE in the range.  Then mremap() the
range to a new location and check that the uffd-wp bit is clear for every
PTE in the range.

Run the test for small folios, all supported THP sizes and all supported
hugetlb sizes, and for swapped out memory, shared and private.

There was previously a bug in the kernel where the uffd-wp bits remained
set in all PTEs for this case, after fixing the kernel, the tests all
pass.

Link: https://lkml.kernel.org/r/20250107144755.1871363-3-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/.gitignore       |    1 
 tools/testing/selftests/mm/Makefile         |    2 
 tools/testing/selftests/mm/run_vmtests.sh   |    1 
 tools/testing/selftests/mm/uffd-wp-mremap.c |  380 ++++++++++++++++++
 4 files changed, 384 insertions(+)

--- a/tools/testing/selftests/mm/.gitignore~selftests-mm-introduce-uffd-wp-mremap-regression-test
+++ a/tools/testing/selftests/mm/.gitignore
@@ -27,6 +27,7 @@ protection_keys_64
 madv_populate
 uffd-stress
 uffd-unit-tests
+uffd-wp-mremap
 mlock-intersect-test
 mlock-random-test
 virtual_address_range
--- a/tools/testing/selftests/mm/Makefile~selftests-mm-introduce-uffd-wp-mremap-regression-test
+++ a/tools/testing/selftests/mm/Makefile
@@ -88,6 +88,7 @@ TEST_GEN_FILES += thuge-gen
 TEST_GEN_FILES += transhuge-stress
 TEST_GEN_FILES += uffd-stress
 TEST_GEN_FILES += uffd-unit-tests
+TEST_GEN_FILES += uffd-wp-mremap
 TEST_GEN_FILES += split_huge_page_test
 TEST_GEN_FILES += ksm_tests
 TEST_GEN_FILES += ksm_functional_tests
@@ -158,6 +159,7 @@ $(TEST_GEN_FILES): vm_util.c thp_setting
 
 $(OUTPUT)/uffd-stress: uffd-common.c
 $(OUTPUT)/uffd-unit-tests: uffd-common.c
+$(OUTPUT)/uffd-wp-mremap: uffd-common.c
 $(OUTPUT)/protection_keys: pkey_util.c
 $(OUTPUT)/pkey_sighandler_tests: pkey_util.c
 
--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-introduce-uffd-wp-mremap-regression-test
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -307,6 +307,7 @@ CATEGORY="userfaultfd" run_test ${uffd_s
 CATEGORY="userfaultfd" run_test ${uffd_stress_bin} hugetlb-private "$half_ufd_size_MB" 32
 CATEGORY="userfaultfd" run_test ${uffd_stress_bin} shmem 20 16
 CATEGORY="userfaultfd" run_test ${uffd_stress_bin} shmem-private 20 16
+CATEGORY="userfaultfd" run_test ./uffd-wp-mremap
 
 #cleanup
 echo "$nr_hugepgs" > /proc/sys/vm/nr_hugepages
diff --git a/tools/testing/selftests/mm/uffd-wp-mremap.c a/tools/testing/selftests/mm/uffd-wp-mremap.c
new file mode 100644
--- /dev/null
+++ a/tools/testing/selftests/mm/uffd-wp-mremap.c
@@ -0,0 +1,380 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#define _GNU_SOURCE
+#include <stdbool.h>
+#include <stdint.h>
+#include <fcntl.h>
+#include <assert.h>
+#include <linux/mman.h>
+#include <sys/mman.h>
+#include "../kselftest.h"
+#include "thp_settings.h"
+#include "uffd-common.h"
+
+static int pagemap_fd;
+static size_t pagesize;
+static int nr_pagesizes = 1;
+static int nr_thpsizes;
+static size_t thpsizes[20];
+static int nr_hugetlbsizes;
+static size_t hugetlbsizes[10];
+
+static int sz2ord(size_t size)
+{
+	return __builtin_ctzll(size / pagesize);
+}
+
+static int detect_thp_sizes(size_t sizes[], int max)
+{
+	int count = 0;
+	unsigned long orders;
+	size_t kb;
+	int i;
+
+	/* thp not supported at all. */
+	if (!read_pmd_pagesize())
+		return 0;
+
+	orders = thp_supported_orders();
+
+	for (i = 0; orders && count < max; i++) {
+		if (!(orders & (1UL << i)))
+			continue;
+		orders &= ~(1UL << i);
+		kb = (pagesize >> 10) << i;
+		sizes[count++] = kb * 1024;
+		ksft_print_msg("[INFO] detected THP size: %zu KiB\n", kb);
+	}
+
+	return count;
+}
+
+static void *mmap_aligned(size_t size, int prot, int flags)
+{
+	size_t mmap_size = size * 2;
+	char *mmap_mem, *mem;
+
+	mmap_mem = mmap(NULL, mmap_size, prot, flags, -1, 0);
+	if (mmap_mem == MAP_FAILED)
+		return mmap_mem;
+
+	mem = (char *)(((uintptr_t)mmap_mem + size - 1) & ~(size - 1));
+	munmap(mmap_mem, mem - mmap_mem);
+	munmap(mem + size, mmap_mem + mmap_size - mem - size);
+
+	return mem;
+}
+
+static void *alloc_one_folio(size_t size, bool private, bool hugetlb)
+{
+	bool thp = !hugetlb && size > pagesize;
+	int flags = MAP_ANONYMOUS;
+	int prot = PROT_READ | PROT_WRITE;
+	char *mem, *addr;
+
+	assert((size & (size - 1)) == 0);
+
+	if (private)
+		flags |= MAP_PRIVATE;
+	else
+		flags |= MAP_SHARED;
+
+	/*
+	 * For THP, we must explicitly enable the THP size, allocate twice the
+	 * required space then manually align.
+	 */
+	if (thp) {
+		struct thp_settings settings = *thp_current_settings();
+
+		if (private)
+			settings.hugepages[sz2ord(size)].enabled = THP_ALWAYS;
+		else
+			settings.shmem_hugepages[sz2ord(size)].enabled = SHMEM_ALWAYS;
+
+		thp_push_settings(&settings);
+
+		mem = mmap_aligned(size, prot, flags);
+	} else {
+		if (hugetlb) {
+			flags |= MAP_HUGETLB;
+			flags |= __builtin_ctzll(size) << MAP_HUGE_SHIFT;
+		}
+
+		mem = mmap(NULL, size, prot, flags, -1, 0);
+	}
+
+	if (mem == MAP_FAILED) {
+		mem = NULL;
+		goto out;
+	}
+
+	assert(((uintptr_t)mem & (size - 1)) == 0);
+
+	/*
+	 * Populate the folio by writing the first byte and check that all pages
+	 * are populated. Finally set the whole thing to non-zero data to avoid
+	 * kernel from mapping it back to the zero page.
+	 */
+	mem[0] = 1;
+	for (addr = mem; addr < mem + size; addr += pagesize) {
+		if (!pagemap_is_populated(pagemap_fd, addr)) {
+			munmap(mem, size);
+			mem = NULL;
+			goto out;
+		}
+	}
+	memset(mem, 1, size);
+out:
+	if (thp)
+		thp_pop_settings();
+
+	return mem;
+}
+
+static bool check_uffd_wp_state(void *mem, size_t size, bool expect)
+{
+	uint64_t pte;
+	void *addr;
+
+	for (addr = mem; addr < mem + size; addr += pagesize) {
+		pte = pagemap_get_entry(pagemap_fd, addr);
+		if (!!(pte & PM_UFFD_WP) != expect) {
+			ksft_test_result_fail("uffd-wp not %s for pte %lu!\n",
+					      expect ? "set" : "clear",
+					      (addr - mem) / pagesize);
+			return false;
+		}
+	}
+
+	return true;
+}
+
+static bool range_is_swapped(void *addr, size_t size)
+{
+	for (; size; addr += pagesize, size -= pagesize)
+		if (!pagemap_is_swapped(pagemap_fd, addr))
+			return false;
+	return true;
+}
+
+static void test_one_folio(size_t size, bool private, bool swapout, bool hugetlb)
+{
+	struct uffdio_writeprotect wp_prms;
+	uint64_t features = 0;
+	void *addr = NULL;
+	void *mem = NULL;
+
+	assert(!(hugetlb && swapout));
+
+	ksft_print_msg("[RUN] %s(size=%zu, private=%s, swapout=%s, hugetlb=%s)\n",
+				__func__,
+				size,
+				private ? "true" : "false",
+				swapout ? "true" : "false",
+				hugetlb ? "true" : "false");
+
+	/* Allocate a folio of required size and type. */
+	mem = alloc_one_folio(size, private, hugetlb);
+	if (!mem) {
+		ksft_test_result_fail("alloc_one_folio() failed\n");
+		goto out;
+	}
+
+	/* Register range for uffd-wp. */
+	if (userfaultfd_open(&features)) {
+		ksft_test_result_fail("userfaultfd_open() failed\n");
+		goto out;
+	}
+	if (uffd_register(uffd, mem, size, false, true, false)) {
+		ksft_test_result_fail("uffd_register() failed\n");
+		goto out;
+	}
+	wp_prms.mode = UFFDIO_WRITEPROTECT_MODE_WP;
+	wp_prms.range.start = (uintptr_t)mem;
+	wp_prms.range.len = size;
+	if (ioctl(uffd, UFFDIO_WRITEPROTECT, &wp_prms)) {
+		ksft_test_result_fail("ioctl(UFFDIO_WRITEPROTECT) failed\n");
+		goto out;
+	}
+
+	if (swapout) {
+		madvise(mem, size, MADV_PAGEOUT);
+		if (!range_is_swapped(mem, size)) {
+			ksft_test_result_skip("MADV_PAGEOUT did not work, is swap enabled?\n");
+			goto out;
+		}
+	}
+
+	/* Check that uffd-wp is set for all PTEs in range. */
+	if (!check_uffd_wp_state(mem, size, true))
+		goto out;
+
+	/*
+	 * Move the mapping to a new, aligned location. Since
+	 * UFFD_FEATURE_EVENT_REMAP is not set, we expect the uffd-wp bit for
+	 * each PTE to be cleared in the new mapping.
+	 */
+	addr = mmap_aligned(size, PROT_NONE, MAP_PRIVATE | MAP_ANONYMOUS);
+	if (addr == MAP_FAILED) {
+		ksft_test_result_fail("mmap_aligned() failed\n");
+		goto out;
+	}
+	if (mremap(mem, size, size, MREMAP_FIXED | MREMAP_MAYMOVE, addr) == MAP_FAILED) {
+		ksft_test_result_fail("mremap() failed\n");
+		munmap(addr, size);
+		goto out;
+	}
+	mem = addr;
+
+	/* Check that uffd-wp is cleared for all PTEs in range. */
+	if (!check_uffd_wp_state(mem, size, false))
+		goto out;
+
+	ksft_test_result_pass("%s(size=%zu, private=%s, swapout=%s, hugetlb=%s)\n",
+				__func__,
+				size,
+				private ? "true" : "false",
+				swapout ? "true" : "false",
+				hugetlb ? "true" : "false");
+out:
+	if (mem)
+		munmap(mem, size);
+	if (uffd >= 0) {
+		close(uffd);
+		uffd = -1;
+	}
+}
+
+struct testcase {
+	size_t *sizes;
+	int *nr_sizes;
+	bool private;
+	bool swapout;
+	bool hugetlb;
+};
+
+static const struct testcase testcases[] = {
+	/* base pages. */
+	{
+		.sizes = &pagesize,
+		.nr_sizes = &nr_pagesizes,
+		.private = false,
+		.swapout = false,
+		.hugetlb = false,
+	},
+	{
+		.sizes = &pagesize,
+		.nr_sizes = &nr_pagesizes,
+		.private = true,
+		.swapout = false,
+		.hugetlb = false,
+	},
+	{
+		.sizes = &pagesize,
+		.nr_sizes = &nr_pagesizes,
+		.private = false,
+		.swapout = true,
+		.hugetlb = false,
+	},
+	{
+		.sizes = &pagesize,
+		.nr_sizes = &nr_pagesizes,
+		.private = true,
+		.swapout = true,
+		.hugetlb = false,
+	},
+
+	/* thp. */
+	{
+		.sizes = thpsizes,
+		.nr_sizes = &nr_thpsizes,
+		.private = false,
+		.swapout = false,
+		.hugetlb = false,
+	},
+	{
+		.sizes = thpsizes,
+		.nr_sizes = &nr_thpsizes,
+		.private = true,
+		.swapout = false,
+		.hugetlb = false,
+	},
+	{
+		.sizes = thpsizes,
+		.nr_sizes = &nr_thpsizes,
+		.private = false,
+		.swapout = true,
+		.hugetlb = false,
+	},
+	{
+		.sizes = thpsizes,
+		.nr_sizes = &nr_thpsizes,
+		.private = true,
+		.swapout = true,
+		.hugetlb = false,
+	},
+
+	/* hugetlb. */
+	{
+		.sizes = hugetlbsizes,
+		.nr_sizes = &nr_hugetlbsizes,
+		.private = false,
+		.swapout = false,
+		.hugetlb = true,
+	},
+	{
+		.sizes = hugetlbsizes,
+		.nr_sizes = &nr_hugetlbsizes,
+		.private = true,
+		.swapout = false,
+		.hugetlb = true,
+	},
+};
+
+int main(int argc, char **argv)
+{
+	struct thp_settings settings;
+	int i, j, plan = 0;
+
+	pagesize = getpagesize();
+	nr_thpsizes = detect_thp_sizes(thpsizes, ARRAY_SIZE(thpsizes));
+	nr_hugetlbsizes = detect_hugetlb_page_sizes(hugetlbsizes,
+						    ARRAY_SIZE(hugetlbsizes));
+
+	/* If THP is supported, save THP settings and initially disable THP. */
+	if (nr_thpsizes) {
+		thp_save_settings();
+		thp_read_settings(&settings);
+		for (i = 0; i < NR_ORDERS; i++) {
+			settings.hugepages[i].enabled = THP_NEVER;
+			settings.shmem_hugepages[i].enabled = SHMEM_NEVER;
+		}
+		thp_push_settings(&settings);
+	}
+
+	for (i = 0; i < ARRAY_SIZE(testcases); i++)
+		plan += *testcases[i].nr_sizes;
+	ksft_set_plan(plan);
+
+	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
+	if (pagemap_fd < 0)
+		ksft_exit_fail_msg("opening pagemap failed\n");
+
+	for (i = 0; i < ARRAY_SIZE(testcases); i++) {
+		const struct testcase *tc = &testcases[i];
+
+		for (j = 0; j < *tc->nr_sizes; j++)
+			test_one_folio(tc->sizes[j], tc->private, tc->swapout,
+				       tc->hugetlb);
+	}
+
+	/* If THP is supported, restore original THP settings. */
+	if (nr_thpsizes)
+		thp_restore_settings();
+
+	i = ksft_get_fail_cnt();
+	if (i)
+		ksft_exit_fail_msg("%d out of %d tests failed\n",
+				   i, ksft_test_num());
+	ksft_exit_pass();
+}
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

mm-clear-uffd-wp-pte-pmd-state-on-mremap.patch
selftests-mm-introduce-uffd-wp-mremap-regression-test.patch

