Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B42F3C001DB
	for <mm-commits@archiver.kernel.org>; Fri,  4 Aug 2023 18:33:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbjHDSdu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Aug 2023 14:33:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231669AbjHDSdM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 4 Aug 2023 14:33:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24CC559FC
        for <mm-commits@vger.kernel.org>; Fri,  4 Aug 2023 11:29:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 11B8262103
        for <mm-commits@vger.kernel.org>; Fri,  4 Aug 2023 18:28:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66268C433C7;
        Fri,  4 Aug 2023 18:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691173700;
        bh=2bRJJrF7eBDOW1vr+XNoLL7YyhefEqiEUf5pkQt+0ro=;
        h=Date:To:From:Subject:From;
        b=fQ4+crHzLAGnMLc5hMfQATRorZkkpfzc6zWhv32BDSRamW44xftPesLfKXI7kA3Nr
         4RdssXg/wbwVC+gTB6+X6AYTLXbvWX/3rwq3I+g5NjkZUUFJB2Ba6FQEP+5fJpX+9P
         eALIGZTeMxr3rVs0C7WeyFzNtpwv6tCh5gLffFNM=
Date:   Fri, 04 Aug 2023 11:28:19 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        torvalds@linux-foundation.org, shuah@kernel.org, peterx@redhat.com,
        pbonzini@redhat.com, mgorman@techsingularity.net, mgorman@suse.de,
        liubo254@huawei.com, jhubbard@nvidia.com, jgg@ziepe.ca,
        hughd@google.com, david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftest-mm-ksm_functional_tests-add-prot_none-test.patch added to mm-unstable branch
Message-Id: <20230804182820.66268C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftest/mm: ksm_functional_tests: Add PROT_NONE test
has been added to the -mm mm-unstable branch.  Its filename is
     selftest-mm-ksm_functional_tests-add-prot_none-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftest-mm-ksm_functional_tests-add-prot_none-test.patch

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
Subject: selftest/mm: ksm_functional_tests: Add PROT_NONE test
Date: Thu, 3 Aug 2023 16:32:08 +0200

Let's test whether merging and unmerging in PROT_NONE areas works as
expected.

Pass a page protection to mmap_and_merge_range(), which will trigger
an mprotect() after writing to the pages, but before enabling merging.

Make sure that unsharing works as expected, by performing a ptrace write
(using /proc/self/mem) and by setting MADV_UNMERGEABLE.

Note that this implicitly tests that ptrace writes in an inaccessible
(PROT_NONE) mapping work as expected.

Link: https://lkml.kernel.org/r/20230803143208.383663-8-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: liubo <liubo254@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/ksm_functional_tests.c |   59 ++++++++++--
 1 file changed, 52 insertions(+), 7 deletions(-)

--- a/tools/testing/selftests/mm/ksm_functional_tests.c~selftest-mm-ksm_functional_tests-add-prot_none-test
+++ a/tools/testing/selftests/mm/ksm_functional_tests.c
@@ -27,6 +27,7 @@
 #define KiB 1024u
 #define MiB (1024 * KiB)
 
+static int mem_fd;
 static int ksm_fd;
 static int ksm_full_scans_fd;
 static int proc_self_ksm_stat_fd;
@@ -144,7 +145,8 @@ static int ksm_unmerge(void)
 	return 0;
 }
 
-static char *mmap_and_merge_range(char val, unsigned long size, bool use_prctl)
+static char *mmap_and_merge_range(char val, unsigned long size, int prot,
+				  bool use_prctl)
 {
 	char *map;
 	int ret;
@@ -176,6 +178,11 @@ static char *mmap_and_merge_range(char v
 	/* Make sure each page contains the same values to merge them. */
 	memset(map, val, size);
 
+	if (mprotect(map, size, prot)) {
+		ksft_test_result_skip("mprotect() failed\n");
+		goto unmap;
+	}
+
 	if (use_prctl) {
 		ret = prctl(PR_SET_MEMORY_MERGE, 1, 0, 0, 0);
 		if (ret < 0 && errno == EINVAL) {
@@ -218,7 +225,7 @@ static void test_unmerge(void)
 
 	ksft_print_msg("[RUN] %s\n", __func__);
 
-	map = mmap_and_merge_range(0xcf, size, false);
+	map = mmap_and_merge_range(0xcf, size, PROT_READ | PROT_WRITE, false);
 	if (map == MAP_FAILED)
 		return;
 
@@ -256,7 +263,7 @@ static void test_unmerge_zero_pages(void
 	}
 
 	/* Let KSM deduplicate zero pages. */
-	map = mmap_and_merge_range(0x00, size, false);
+	map = mmap_and_merge_range(0x00, size, PROT_READ | PROT_WRITE, false);
 	if (map == MAP_FAILED)
 		return;
 
@@ -304,7 +311,7 @@ static void test_unmerge_discarded(void)
 
 	ksft_print_msg("[RUN] %s\n", __func__);
 
-	map = mmap_and_merge_range(0xcf, size, false);
+	map = mmap_and_merge_range(0xcf, size, PROT_READ | PROT_WRITE, false);
 	if (map == MAP_FAILED)
 		return;
 
@@ -336,7 +343,7 @@ static void test_unmerge_uffd_wp(void)
 
 	ksft_print_msg("[RUN] %s\n", __func__);
 
-	map = mmap_and_merge_range(0xcf, size, false);
+	map = mmap_and_merge_range(0xcf, size, PROT_READ | PROT_WRITE, false);
 	if (map == MAP_FAILED)
 		return;
 
@@ -479,7 +486,7 @@ static void test_prctl_unmerge(void)
 
 	ksft_print_msg("[RUN] %s\n", __func__);
 
-	map = mmap_and_merge_range(0xcf, size, true);
+	map = mmap_and_merge_range(0xcf, size, PROT_READ | PROT_WRITE, true);
 	if (map == MAP_FAILED)
 		return;
 
@@ -494,9 +501,42 @@ unmap:
 	munmap(map, size);
 }
 
+static void test_prot_none(void)
+{
+	const unsigned int size = 2 * MiB;
+	char *map;
+	int i;
+
+	ksft_print_msg("[RUN] %s\n", __func__);
+
+	map = mmap_and_merge_range(0x11, size, PROT_NONE, false);
+	if (map == MAP_FAILED)
+		goto unmap;
+
+	/* Store a unique value in each page on one half using ptrace */
+	for (i = 0; i < size / 2; i += pagesize) {
+		lseek(mem_fd, (uintptr_t) map + i, SEEK_SET);
+		if (write(mem_fd, &i, sizeof(size)) != sizeof(size)) {
+			ksft_test_result_fail("ptrace write failed\n");
+			goto unmap;
+		}
+	}
+
+	/* Trigger unsharing on the other half. */
+	if (madvise(map + size / 2, size / 2, MADV_UNMERGEABLE)) {
+		ksft_test_result_fail("MADV_UNMERGEABLE failed\n");
+		goto unmap;
+	}
+
+	ksft_test_result(!range_maps_duplicates(map, size),
+			 "Pages were unmerged\n");
+unmap:
+	munmap(map, size);
+}
+
 int main(int argc, char **argv)
 {
-	unsigned int tests = 6;
+	unsigned int tests = 7;
 	int err;
 
 #ifdef __NR_userfaultfd
@@ -508,6 +548,9 @@ int main(int argc, char **argv)
 
 	pagesize = getpagesize();
 
+	mem_fd = open("/proc/self/mem", O_RDWR);
+	if (mem_fd < 0)
+		ksft_exit_fail_msg("opening /proc/self/mem failed\n");
 	ksm_fd = open("/sys/kernel/mm/ksm/run", O_RDWR);
 	if (ksm_fd < 0)
 		ksft_exit_skip("open(\"/sys/kernel/mm/ksm/run\") failed\n");
@@ -529,6 +572,8 @@ int main(int argc, char **argv)
 	test_unmerge_uffd_wp();
 #endif
 
+	test_prot_none();
+
 	test_prctl();
 	test_prctl_fork();
 	test_prctl_unmerge();
_

Patches currently in -mm which might be from david@redhat.com are

mm-gup-reintroduce-foll_numa-as-foll_honor_numa_fault.patch
smaps-use-vm_normal_page_pmd-instead-of-follow_trans_huge_pmd.patch
mm-memory_hotplug-document-the-signal_pending-check-in-offline_pages.patch
kvm-explicitly-set-foll_honor_numa_fault-in-hva_to_pfn_slow.patch
mm-gup-dont-implicitly-set-foll_honor_numa_fault.patch
pgtable-improve-pte_protnone-comment.patch
selftest-mm-ksm_functional_tests-test-in-mmap_and_merge_range-if-anything-got-merged.patch
selftest-mm-ksm_functional_tests-add-prot_none-test.patch

