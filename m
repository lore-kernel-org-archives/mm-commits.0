Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0501FC43217
	for <mm-commits@archiver.kernel.org>; Wed, 16 Nov 2022 22:44:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233188AbiKPWo2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Nov 2022 17:44:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238934AbiKPWoE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 16 Nov 2022 17:44:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9F8C5BD5C
        for <mm-commits@vger.kernel.org>; Wed, 16 Nov 2022 14:43:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4840AB81EE6
        for <mm-commits@vger.kernel.org>; Wed, 16 Nov 2022 22:43:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEF25C433C1;
        Wed, 16 Nov 2022 22:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668638626;
        bh=YC3GN11nTrG+CyULfa0290eqxvmfovP2QLJ+lQvtNww=;
        h=Date:To:From:Subject:From;
        b=nTqH3rHP5Cfj4RvlxEkh9w7KUrzYhYkt7hDVcfn36XWWBVLyCXTGa3cPjjcsl5g+f
         dopSTUzeYkV9CbJoF5lQVtCSpS+7TbWdYnVpTjH4dlxJJN6ibeKZVTz9jTXuspFyJz
         NTl7kP/UKuqixM8JwUhRNV+t9uXuM5d3FJbUTcek=
Date:   Wed, 16 Nov 2022 14:43:45 -0800
To:     mm-commits@vger.kernel.org, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-vm-cow-basic-cow-tests-for-non-anonymous-pages.patch added to mm-unstable branch
Message-Id: <20221116224345.DEF25C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm: cow: basic COW tests for non-anonymous pages
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-vm-cow-basic-cow-tests-for-non-anonymous-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-vm-cow-basic-cow-tests-for-non-anonymous-pages.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: selftests/vm: cow: basic COW tests for non-anonymous pages
Date: Wed, 16 Nov 2022 11:26:41 +0100

Let's add basic tests for COW with non-anonymous pages in private
mappings: write access should properly trigger COW and result in the
private changes not being visible through other page mappings.

Especially, add tests for:
* Zeropage
* Huge zeropage
* Ordinary pagecache pages via memfd and tmpfile()
* Hugetlb pages via memfd

Fortunately, all tests pass.

Link: https://lkml.kernel.org/r/20221116102659.70287-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/cow.c |  338 ++++++++++++++++++++++++++++-
 1 file changed, 337 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/vm/cow.c~selftests-vm-cow-basic-cow-tests-for-non-anonymous-pages
+++ a/tools/testing/selftests/vm/cow.c
@@ -19,6 +19,7 @@
 #include <sys/mman.h>
 #include <sys/ioctl.h>
 #include <sys/wait.h>
+#include <linux/memfd.h>
 
 #include "local_config.h"
 #ifdef LOCAL_CONFIG_HAVE_LIBURING
@@ -35,6 +36,7 @@ static size_t thpsize;
 static int nr_hugetlbsizes;
 static size_t hugetlbsizes[10];
 static int gup_fd;
+static bool has_huge_zeropage;
 
 static void detect_thpsize(void)
 {
@@ -64,6 +66,31 @@ static void detect_thpsize(void)
 	close(fd);
 }
 
+static void detect_huge_zeropage(void)
+{
+	int fd = open("/sys/kernel/mm/transparent_hugepage/use_zero_page",
+		      O_RDONLY);
+	size_t enabled = 0;
+	char buf[15];
+	int ret;
+
+	if (fd < 0)
+		return;
+
+	ret = pread(fd, buf, sizeof(buf), 0);
+	if (ret > 0 && ret < sizeof(buf)) {
+		buf[ret] = 0;
+
+		enabled = strtoul(buf, NULL, 10);
+		if (enabled == 1) {
+			has_huge_zeropage = true;
+			ksft_print_msg("[INFO] huge zeropage is enabled\n");
+		}
+	}
+
+	close(fd);
+}
+
 static void detect_hugetlbsizes(void)
 {
 	DIR *dir = opendir("/sys/kernel/mm/hugepages/");
@@ -1148,6 +1175,312 @@ static int tests_per_anon_test_case(void
 	return tests;
 }
 
+typedef void (*non_anon_test_fn)(char *mem, const char *smem, size_t size);
+
+static void test_cow(char *mem, const char *smem, size_t size)
+{
+	char *old = malloc(size);
+
+	/* Backup the original content. */
+	memcpy(old, smem, size);
+
+	/* Modify the page. */
+	memset(mem, 0xff, size);
+
+	/* See if we still read the old values via the other mapping. */
+	ksft_test_result(!memcmp(smem, old, size),
+			 "Other mapping not modified\n");
+	free(old);
+}
+
+static void run_with_zeropage(non_anon_test_fn fn, const char *desc)
+{
+	char *mem, *smem, tmp;
+
+	ksft_print_msg("[RUN] %s ... with shared zeropage\n", desc);
+
+	mem = mmap(NULL, pagesize, PROT_READ | PROT_WRITE,
+		   MAP_PRIVATE | MAP_ANON, -1, 0);
+	if (mem == MAP_FAILED) {
+		ksft_test_result_fail("mmap() failed\n");
+		return;
+	}
+
+	smem = mmap(NULL, pagesize, PROT_READ, MAP_PRIVATE | MAP_ANON, -1, 0);
+	if (mem == MAP_FAILED) {
+		ksft_test_result_fail("mmap() failed\n");
+		goto munmap;
+	}
+
+	/* Read from the page to populate the shared zeropage. */
+	tmp = *mem + *smem;
+	asm volatile("" : "+r" (tmp));
+
+	fn(mem, smem, pagesize);
+munmap:
+	munmap(mem, pagesize);
+	if (smem != MAP_FAILED)
+		munmap(smem, pagesize);
+}
+
+static void run_with_huge_zeropage(non_anon_test_fn fn, const char *desc)
+{
+	char *mem, *smem, *mmap_mem, *mmap_smem, tmp;
+	size_t mmap_size;
+	int ret;
+
+	ksft_print_msg("[RUN] %s ... with huge zeropage\n", desc);
+
+	if (!has_huge_zeropage) {
+		ksft_test_result_skip("Huge zeropage not enabled\n");
+		return;
+	}
+
+	/* For alignment purposes, we need twice the thp size. */
+	mmap_size = 2 * thpsize;
+	mmap_mem = mmap(NULL, mmap_size, PROT_READ | PROT_WRITE,
+			MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (mmap_mem == MAP_FAILED) {
+		ksft_test_result_fail("mmap() failed\n");
+		return;
+	}
+	mmap_smem = mmap(NULL, mmap_size, PROT_READ,
+			 MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (mmap_smem == MAP_FAILED) {
+		ksft_test_result_fail("mmap() failed\n");
+		goto munmap;
+	}
+
+	/* We need a THP-aligned memory area. */
+	mem = (char *)(((uintptr_t)mmap_mem + thpsize) & ~(thpsize - 1));
+	smem = (char *)(((uintptr_t)mmap_smem + thpsize) & ~(thpsize - 1));
+
+	ret = madvise(mem, thpsize, MADV_HUGEPAGE);
+	ret |= madvise(smem, thpsize, MADV_HUGEPAGE);
+	if (ret) {
+		ksft_test_result_fail("MADV_HUGEPAGE failed\n");
+		goto munmap;
+	}
+
+	/*
+	 * Read from the memory to populate the huge shared zeropage. Read from
+	 * the first sub-page and test if we get another sub-page populated
+	 * automatically.
+	 */
+	tmp = *mem + *smem;
+	asm volatile("" : "+r" (tmp));
+	if (!pagemap_is_populated(pagemap_fd, mem + pagesize) ||
+	    !pagemap_is_populated(pagemap_fd, smem + pagesize)) {
+		ksft_test_result_skip("Did not get THPs populated\n");
+		goto munmap;
+	}
+
+	fn(mem, smem, thpsize);
+munmap:
+	munmap(mmap_mem, mmap_size);
+	if (mmap_smem != MAP_FAILED)
+		munmap(mmap_smem, mmap_size);
+}
+
+static void run_with_memfd(non_anon_test_fn fn, const char *desc)
+{
+	char *mem, *smem, tmp;
+	int fd;
+
+	ksft_print_msg("[RUN] %s ... with memfd\n", desc);
+
+	fd = memfd_create("test", 0);
+	if (fd < 0) {
+		ksft_test_result_fail("memfd_create() failed\n");
+		return;
+	}
+
+	/* File consists of a single page filled with zeroes. */
+	if (fallocate(fd, 0, 0, pagesize)) {
+		ksft_test_result_fail("fallocate() failed\n");
+		goto close;
+	}
+
+	/* Create a private mapping of the memfd. */
+	mem = mmap(NULL, pagesize, PROT_READ | PROT_WRITE, MAP_PRIVATE, fd, 0);
+	if (mem == MAP_FAILED) {
+		ksft_test_result_fail("mmap() failed\n");
+		goto close;
+	}
+	smem = mmap(NULL, pagesize, PROT_READ, MAP_SHARED, fd, 0);
+	if (mem == MAP_FAILED) {
+		ksft_test_result_fail("mmap() failed\n");
+		goto munmap;
+	}
+
+	/* Fault the page in. */
+	tmp = *mem + *smem;
+	asm volatile("" : "+r" (tmp));
+
+	fn(mem, smem, pagesize);
+munmap:
+	munmap(mem, pagesize);
+	if (smem != MAP_FAILED)
+		munmap(smem, pagesize);
+close:
+	close(fd);
+}
+
+static void run_with_tmpfile(non_anon_test_fn fn, const char *desc)
+{
+	char *mem, *smem, tmp;
+	FILE *file;
+	int fd;
+
+	ksft_print_msg("[RUN] %s ... with tmpfile\n", desc);
+
+	file = tmpfile();
+	if (!file) {
+		ksft_test_result_fail("tmpfile() failed\n");
+		return;
+	}
+
+	fd = fileno(file);
+	if (fd < 0) {
+		ksft_test_result_skip("fileno() failed\n");
+		return;
+	}
+
+	/* File consists of a single page filled with zeroes. */
+	if (fallocate(fd, 0, 0, pagesize)) {
+		ksft_test_result_fail("fallocate() failed\n");
+		goto close;
+	}
+
+	/* Create a private mapping of the memfd. */
+	mem = mmap(NULL, pagesize, PROT_READ | PROT_WRITE, MAP_PRIVATE, fd, 0);
+	if (mem == MAP_FAILED) {
+		ksft_test_result_fail("mmap() failed\n");
+		goto close;
+	}
+	smem = mmap(NULL, pagesize, PROT_READ, MAP_SHARED, fd, 0);
+	if (mem == MAP_FAILED) {
+		ksft_test_result_fail("mmap() failed\n");
+		goto munmap;
+	}
+
+	/* Fault the page in. */
+	tmp = *mem + *smem;
+	asm volatile("" : "+r" (tmp));
+
+	fn(mem, smem, pagesize);
+munmap:
+	munmap(mem, pagesize);
+	if (smem != MAP_FAILED)
+		munmap(smem, pagesize);
+close:
+	fclose(file);
+}
+
+static void run_with_memfd_hugetlb(non_anon_test_fn fn, const char *desc,
+				   size_t hugetlbsize)
+{
+	int flags = MFD_HUGETLB;
+	char *mem, *smem, tmp;
+	int fd;
+
+	ksft_print_msg("[RUN] %s ... with memfd hugetlb (%zu kB)\n", desc,
+		       hugetlbsize / 1024);
+
+	flags |= __builtin_ctzll(hugetlbsize) << MFD_HUGE_SHIFT;
+
+	fd = memfd_create("test", flags);
+	if (fd < 0) {
+		ksft_test_result_skip("memfd_create() failed\n");
+		return;
+	}
+
+	/* File consists of a single page filled with zeroes. */
+	if (fallocate(fd, 0, 0, hugetlbsize)) {
+		ksft_test_result_skip("need more free huge pages\n");
+		goto close;
+	}
+
+	/* Create a private mapping of the memfd. */
+	mem = mmap(NULL, hugetlbsize, PROT_READ | PROT_WRITE, MAP_PRIVATE, fd,
+		   0);
+	if (mem == MAP_FAILED) {
+		ksft_test_result_skip("need more free huge pages\n");
+		goto close;
+	}
+	smem = mmap(NULL, hugetlbsize, PROT_READ, MAP_SHARED, fd, 0);
+	if (mem == MAP_FAILED) {
+		ksft_test_result_fail("mmap() failed\n");
+		goto munmap;
+	}
+
+	/* Fault the page in. */
+	tmp = *mem + *smem;
+	asm volatile("" : "+r" (tmp));
+
+	fn(mem, smem, hugetlbsize);
+munmap:
+	munmap(mem, hugetlbsize);
+	if (mem != MAP_FAILED)
+		munmap(smem, hugetlbsize);
+close:
+	close(fd);
+}
+
+struct non_anon_test_case {
+	const char *desc;
+	non_anon_test_fn fn;
+};
+
+/*
+ * Test cases that target any pages in private mappings that are non anonymous:
+ * pages that may get shared via COW ndependent of fork(). This includes
+ * the shared zeropage(s), pagecache pages, ...
+ */
+static const struct non_anon_test_case non_anon_test_cases[] = {
+	/*
+	 * Basic COW test without any GUP. If we miss to break COW, changes are
+	 * visible via other private/shared mappings.
+	 */
+	{
+		"Basic COW",
+		test_cow,
+	},
+};
+
+static void run_non_anon_test_case(struct non_anon_test_case const *test_case)
+{
+	int i;
+
+	run_with_zeropage(test_case->fn, test_case->desc);
+	run_with_memfd(test_case->fn, test_case->desc);
+	run_with_tmpfile(test_case->fn, test_case->desc);
+	if (thpsize)
+		run_with_huge_zeropage(test_case->fn, test_case->desc);
+	for (i = 0; i < nr_hugetlbsizes; i++)
+		run_with_memfd_hugetlb(test_case->fn, test_case->desc,
+				       hugetlbsizes[i]);
+}
+
+static void run_non_anon_test_cases(void)
+{
+	int i;
+
+	ksft_print_msg("[RUN] Non-anonymous memory tests in private mappings\n");
+
+	for (i = 0; i < ARRAY_SIZE(non_anon_test_cases); i++)
+		run_non_anon_test_case(&non_anon_test_cases[i]);
+}
+
+static int tests_per_non_anon_test_case(void)
+{
+	int tests = 3 + nr_hugetlbsizes;
+
+	if (thpsize)
+		tests += 1;
+	return tests;
+}
+
 int main(int argc, char **argv)
 {
 	int err;
@@ -1155,9 +1488,11 @@ int main(int argc, char **argv)
 	pagesize = getpagesize();
 	detect_thpsize();
 	detect_hugetlbsizes();
+	detect_huge_zeropage();
 
 	ksft_print_header();
-	ksft_set_plan(ARRAY_SIZE(anon_test_cases) * tests_per_anon_test_case());
+	ksft_set_plan(ARRAY_SIZE(anon_test_cases) * tests_per_anon_test_case() +
+		      ARRAY_SIZE(non_anon_test_cases) * tests_per_non_anon_test_case());
 
 	gup_fd = open("/sys/kernel/debug/gup_test", O_RDWR);
 	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
@@ -1165,6 +1500,7 @@ int main(int argc, char **argv)
 		ksft_exit_fail_msg("opening pagemap failed\n");
 
 	run_anon_test_cases();
+	run_non_anon_test_cases();
 
 	err = ksft_get_fail_cnt();
 	if (err)
_

Patches currently in -mm which might be from david@redhat.com are

selftests-vm-add-ksm-unmerge-tests.patch
mm-pagewalk-dont-trigger-test_walk-in-walk_page_vma.patch
selftests-vm-add-test-to-measure-madv_unmergeable-performance.patch
mm-ksm-simplify-break_ksm-to-not-rely-on-vm_fault_write.patch
mm-remove-vm_fault_write.patch
mm-ksm-fix-ksm-cow-breaking-with-userfaultfd-wp-via-fault_flag_unshare.patch
mm-pagewalk-add-walk_page_range_vma.patch
mm-ksm-convert-break_ksm-to-use-walk_page_range_vma.patch
mm-gup-remove-foll_migration.patch
mm-mprotect-minor-can_change_pte_writable-cleanups.patch
mm-huge_memory-try-avoiding-write-faults-when-changing-pmd-protection.patch
mm-mprotect-factor-out-check-whether-manual-pte-write-upgrades-are-required.patch
mm-autonuma-use-can_change_ptepmd_writable-to-replace-savedwrite.patch
mm-remove-unused-savedwrite-infrastructure.patch
selftests-vm-anon_cow-add-mprotect-optimization-tests.patch
selftests-vm-anon_cow-prepare-for-non-anonymous-cow-tests.patch
selftests-vm-cow-basic-cow-tests-for-non-anonymous-pages.patch
selftests-vm-cow-r-o-long-term-pinning-reliability-tests-for-non-anon-pages.patch
mm-add-early-fault_flag_unshare-consistency-checks.patch
mm-add-early-fault_flag_write-consistency-checks.patch
mm-rework-handling-in-do_wp_page-based-on-private-vs-shared-mappings.patch
mm-dont-call-vm_ops-huge_fault-in-wp_huge_pmd-wp_huge_pud-for-private-mappings.patch
mm-extend-fault_flag_unshare-support-to-anything-in-a-cow-mapping.patch
mm-gup-reliable-r-o-long-term-pinning-in-cow-mappings.patch
rdma-umem-remove-foll_force-usage.patch
rdma-usnic-remove-foll_force-usage.patch
rdma-siw-remove-foll_force-usage.patch
media-videobuf-dma-sg-remove-foll_force-usage.patch
drm-etnaviv-remove-foll_force-usage.patch
media-pci-ivtv-remove-foll_force-usage.patch
mm-frame-vector-remove-foll_force-usage.patch
drm-exynos-remove-foll_force-usage.patch
rdma-hw-qib-qib_user_pages-remove-foll_force-usage.patch
habanalabs-remove-foll_force-usage.patch

