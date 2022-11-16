Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55F94C43219
	for <mm-commits@archiver.kernel.org>; Wed, 16 Nov 2022 22:44:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbiKPWo3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Nov 2022 17:44:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234529AbiKPWoF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 16 Nov 2022 17:44:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 859696C70F
        for <mm-commits@vger.kernel.org>; Wed, 16 Nov 2022 14:43:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2134561FFE
        for <mm-commits@vger.kernel.org>; Wed, 16 Nov 2022 22:43:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7691BC433D6;
        Wed, 16 Nov 2022 22:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668638628;
        bh=X/gTyji+nVhxMSPOccE6cHbgdROBt2lF0IRa7Dyrve8=;
        h=Date:To:From:Subject:From;
        b=oyYIhKvgnZTM4P6c1cKYX4SsMd6t3oLzfPHOPLA1nQ5/U7GbO5iUp39wCKI9D51E1
         hNM72i4OrJ1RaBGx5FxjeALitdpoVFPUi4cwz2cTpZ6feu0FI63KEWfrnOfqdGh2p3
         eb9vHNNWZh+JD/+UVBNxISSNLmlOyVqIUiILjEpY=
Date:   Wed, 16 Nov 2022 14:43:47 -0800
To:     mm-commits@vger.kernel.org, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-vm-cow-r-o-long-term-pinning-reliability-tests-for-non-anon-pages.patch added to mm-unstable branch
Message-Id: <20221116224348.7691BC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm: cow: R/O long-term pinning reliability tests for non-anon pages
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-vm-cow-r-o-long-term-pinning-reliability-tests-for-non-anon-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-vm-cow-r-o-long-term-pinning-reliability-tests-for-non-anon-pages.patch

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
Subject: selftests/vm: cow: R/O long-term pinning reliability tests for non-anon pages
Date: Wed, 16 Nov 2022 11:26:42 +0100

Let's test whether R/O long-term pinning is reliable for non-anonymous
memory: when R/O long-term pinning a page, the expectation is that we
break COW early before pinning, such that actual write access via the
page tables won't break COW later and end up replacing the R/O-pinned
page in the page table.

Consequently, R/O long-term pinning in private mappings would only target
exclusive anonymous pages.

For now, all tests fail:
	# [RUN] R/O longterm GUP pin ... with shared zeropage
	not ok 151 Longterm R/O pin is reliable
	# [RUN] R/O longterm GUP pin ... with memfd
	not ok 152 Longterm R/O pin is reliable
	# [RUN] R/O longterm GUP pin ... with tmpfile
	not ok 153 Longterm R/O pin is reliable
	# [RUN] R/O longterm GUP pin ... with huge zeropage
	not ok 154 Longterm R/O pin is reliable
	# [RUN] R/O longterm GUP pin ... with memfd hugetlb (2048 kB)
	not ok 155 Longterm R/O pin is reliable
	# [RUN] R/O longterm GUP pin ... with memfd hugetlb (1048576 kB)
	not ok 156 Longterm R/O pin is reliable
	# [RUN] R/O longterm GUP-fast pin ... with shared zeropage
	not ok 157 Longterm R/O pin is reliable
	# [RUN] R/O longterm GUP-fast pin ... with memfd
	not ok 158 Longterm R/O pin is reliable
	# [RUN] R/O longterm GUP-fast pin ... with tmpfile
	not ok 159 Longterm R/O pin is reliable
	# [RUN] R/O longterm GUP-fast pin ... with huge zeropage
	not ok 160 Longterm R/O pin is reliable
	# [RUN] R/O longterm GUP-fast pin ... with memfd hugetlb (2048 kB)
	not ok 161 Longterm R/O pin is reliable
	# [RUN] R/O longterm GUP-fast pin ... with memfd hugetlb (1048576 kB)
	not ok 162 Longterm R/O pin is reliable

Link: https://lkml.kernel.org/r/20221116102659.70287-4-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/cow.c |   28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/vm/cow.c~selftests-vm-cow-r-o-long-term-pinning-reliability-tests-for-non-anon-pages
+++ a/tools/testing/selftests/vm/cow.c
@@ -561,6 +561,7 @@ static void test_iouring_fork(char *mem,
 #endif /* LOCAL_CONFIG_HAVE_LIBURING */
 
 enum ro_pin_test {
+	RO_PIN_TEST,
 	RO_PIN_TEST_SHARED,
 	RO_PIN_TEST_PREVIOUSLY_SHARED,
 	RO_PIN_TEST_RO_EXCLUSIVE,
@@ -593,6 +594,8 @@ static void do_test_ro_pin(char *mem, si
 	}
 
 	switch (test) {
+	case RO_PIN_TEST:
+		break;
 	case RO_PIN_TEST_SHARED:
 	case RO_PIN_TEST_PREVIOUSLY_SHARED:
 		/*
@@ -1193,6 +1196,16 @@ static void test_cow(char *mem, const ch
 	free(old);
 }
 
+static void test_ro_pin(char *mem, const char *smem, size_t size)
+{
+	do_test_ro_pin(mem, size, RO_PIN_TEST, false);
+}
+
+static void test_ro_fast_pin(char *mem, const char *smem, size_t size)
+{
+	do_test_ro_pin(mem, size, RO_PIN_TEST, true);
+}
+
 static void run_with_zeropage(non_anon_test_fn fn, const char *desc)
 {
 	char *mem, *smem, tmp;
@@ -1433,7 +1446,7 @@ struct non_anon_test_case {
 };
 
 /*
- * Test cases that target any pages in private mappings that are non anonymous:
+ * Test cases that target any pages in private mappings that are not anonymous:
  * pages that may get shared via COW ndependent of fork(). This includes
  * the shared zeropage(s), pagecache pages, ...
  */
@@ -1446,6 +1459,19 @@ static const struct non_anon_test_case n
 		"Basic COW",
 		test_cow,
 	},
+	/*
+	 * Take a R/O longterm pin. When modifying the page via the page table,
+	 * the page content change must be visible via the pin.
+	 */
+	{
+		"R/O longterm GUP pin",
+		test_ro_pin,
+	},
+	/* Same as above, but using GUP-fast. */
+	{
+		"R/O longterm GUP-fast pin",
+		test_ro_fast_pin,
+	},
 };
 
 static void run_non_anon_test_case(struct non_anon_test_case const *test_case)
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

