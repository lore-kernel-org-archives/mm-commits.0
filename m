Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5059C001DF
	for <mm-commits@archiver.kernel.org>; Fri,  4 Aug 2023 18:33:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229455AbjHDSdf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Aug 2023 14:33:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbjHDSb4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 4 Aug 2023 14:31:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2D64559F
        for <mm-commits@vger.kernel.org>; Fri,  4 Aug 2023 11:28:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F33156210F
        for <mm-commits@vger.kernel.org>; Fri,  4 Aug 2023 18:28:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56136C433C8;
        Fri,  4 Aug 2023 18:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691173698;
        bh=ORwy8rEITDjnfEd/kd171ve45nMhJFNN6O7jSc6vTsk=;
        h=Date:To:From:Subject:From;
        b=xhD3yo4w/eDs8ajLwsXJJ6qEZCf0h98G2d8xavPzkxkCs0JOtMiRoXZEyU2kmQxTC
         fj8mOe0yJfQKEWoI0t1P4BJ8XI8yetaqkiuzuQkdFekpv6PXOq1IImRQjdu/MqTnpE
         c4Gkc72b28ilIo8P6UtU8gOmfCmbdMIwlNtkG7wo=
Date:   Fri, 04 Aug 2023 11:28:17 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        torvalds@linux-foundation.org, shuah@kernel.org, peterx@redhat.com,
        pbonzini@redhat.com, mgorman@techsingularity.net, mgorman@suse.de,
        liubo254@huawei.com, jhubbard@nvidia.com, jgg@ziepe.ca,
        hughd@google.com, david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftest-mm-ksm_functional_tests-test-in-mmap_and_merge_range-if-anything-got-merged.patch added to mm-unstable branch
Message-Id: <20230804182818.56136C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftest/mm: ksm_functional_tests: test in mmap_and_merge_range() if anything got merged
has been added to the -mm mm-unstable branch.  Its filename is
     selftest-mm-ksm_functional_tests-test-in-mmap_and_merge_range-if-anything-got-merged.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftest-mm-ksm_functional_tests-test-in-mmap_and_merge_range-if-anything-got-merged.patch

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
Subject: selftest/mm: ksm_functional_tests: test in mmap_and_merge_range() if anything got merged
Date: Thu, 3 Aug 2023 16:32:07 +0200

Let's extend mmap_and_merge_range() to test if anything in the current
process was merged. range_maps_duplicates() is too unreliable for that
use case, so instead look at KSM stats.

Trigger a complete unmerge first, to cleanup the stable tree and
stabilize accounting of merged pages.

Note that we're using /proc/self/ksm_merging_pages instead of
/proc/self/ksm_stat, because that one is available in more existing
kernels.

If /proc/self/ksm_merging_pages can't be opened, we can't perform any
checks and simply skip them.

We have to special-case the shared zeropage for now. But the only user
-- test_unmerge_zero_pages() -- performs its own merge checks.

Link: https://lkml.kernel.org/r/20230803143208.383663-7-david@redhat.com
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

 tools/testing/selftests/mm/ksm_functional_tests.c |   47 ++++++++++++
 1 file changed, 47 insertions(+)

--- a/tools/testing/selftests/mm/ksm_functional_tests.c~selftest-mm-ksm_functional_tests-test-in-mmap_and_merge_range-if-anything-got-merged
+++ a/tools/testing/selftests/mm/ksm_functional_tests.c
@@ -30,6 +30,7 @@
 static int ksm_fd;
 static int ksm_full_scans_fd;
 static int proc_self_ksm_stat_fd;
+static int proc_self_ksm_merging_pages_fd;
 static int ksm_use_zero_pages_fd;
 static int pagemap_fd;
 static size_t pagesize;
@@ -88,6 +89,22 @@ static long get_my_ksm_zero_pages(void)
 	return my_ksm_zero_pages;
 }
 
+static long get_my_merging_pages(void)
+{
+	char buf[10];
+	ssize_t ret;
+
+	if (proc_self_ksm_merging_pages_fd < 0)
+		return proc_self_ksm_merging_pages_fd;
+
+	ret = pread(proc_self_ksm_merging_pages_fd, buf, sizeof(buf) - 1, 0);
+	if (ret <= 0)
+		return -errno;
+	buf[ret] = 0;
+
+	return strtol(buf, NULL, 10);
+}
+
 static long ksm_get_full_scans(void)
 {
 	char buf[10];
@@ -120,11 +137,29 @@ static int ksm_merge(void)
 	return 0;
 }
 
+static int ksm_unmerge(void)
+{
+	if (write(ksm_fd, "2", 1) != 1)
+		return -errno;
+	return 0;
+}
+
 static char *mmap_and_merge_range(char val, unsigned long size, bool use_prctl)
 {
 	char *map;
 	int ret;
 
+	/* Stabilize accounting by disabling KSM completely. */
+	if (ksm_unmerge()) {
+		ksft_test_result_fail("Disabling (unmerging) KSM failed\n");
+		goto unmap;
+	}
+
+	if (get_my_merging_pages() > 0) {
+		ksft_test_result_fail("Still pages merged\n");
+		goto unmap;
+	}
+
 	map = mmap(NULL, size, PROT_READ|PROT_WRITE,
 		   MAP_PRIVATE|MAP_ANON, -1, 0);
 	if (map == MAP_FAILED) {
@@ -160,6 +195,16 @@ static char *mmap_and_merge_range(char v
 		ksft_test_result_fail("Running KSM failed\n");
 		goto unmap;
 	}
+
+	/*
+	 * Check if anything was merged at all. Ignore the zero page that is
+	 * accounted differently (depending on kernel support).
+	 */
+	if (val && !get_my_merging_pages()) {
+		ksft_test_result_fail("No pages got merged\n");
+		goto unmap;
+	}
+
 	return map;
 unmap:
 	munmap(map, size);
@@ -473,6 +518,8 @@ int main(int argc, char **argv)
 	if (pagemap_fd < 0)
 		ksft_exit_skip("open(\"/proc/self/pagemap\") failed\n");
 	proc_self_ksm_stat_fd = open("/proc/self/ksm_stat", O_RDONLY);
+	proc_self_ksm_merging_pages_fd = open("/proc/self/ksm_merging_pages",
+					      O_RDONLY);
 	ksm_use_zero_pages_fd = open("/sys/kernel/mm/ksm/use_zero_pages", O_RDWR);
 
 	test_unmerge();
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

