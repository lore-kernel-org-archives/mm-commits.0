Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74765E728D9
	for <mm-commits@archiver.kernel.org>; Fri, 29 Sep 2023 19:09:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233837AbjI2TI7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Sep 2023 15:08:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233859AbjI2TI6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Sep 2023 15:08:58 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7834A199
        for <mm-commits@vger.kernel.org>; Fri, 29 Sep 2023 12:08:55 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D076C433C8;
        Fri, 29 Sep 2023 19:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696014535;
        bh=uIQL/SoR930ziElMyBgjUA4Hh910+k0O6ZXU1gZA9CE=;
        h=Date:To:From:Subject:From;
        b=C/eTXiUIQQ7TTyimIjq6UCC5tAXd0oPEqx/mrTGpm/TnJglP9xfAzt9CoBnz5qrHC
         tdMqb9ZHs8Yare49xshkxrzlktXewzWO3ft4vbaXJcMnzHe6gKYAD1aK4EpA57LZTz
         pQYCNpt0/y66TGhPfirNcGnhSFZm8hbMFdhH5wfQ=
Date:   Fri, 29 Sep 2023 12:08:54 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, yuzhao@google.com,
        ying.huang@intel.com, willy@infradead.org, vbabka@suse.cz,
        shy828301@gmail.com, rientjes@google.com, mcgrof@kernel.org,
        kirill.shutemov@linux.intel.com, jhubbard@nvidia.com,
        itaru.kitayama@gmail.com, hughd@google.com, fengwei.yin@intel.com,
        david@redhat.com, catalin.marinas@arm.com,
        anshuman.khandual@arm.com, ryan.roberts@arm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-cow-add-tests-for-small-order-anon-thp.patch added to mm-unstable branch
Message-Id: <20230929190855.0D076C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mm/cow: add tests for small-order anon THP
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-cow-add-tests-for-small-order-anon-thp.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-cow-add-tests-for-small-order-anon-thp.patch

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
Subject: selftests/mm/cow: add tests for small-order anon THP
Date: Fri, 29 Sep 2023 12:44:20 +0100

Add tests similar to the existing THP tests, but which operate on memory
backed by smaller-order, PTE-mapped THP.  This reuses all the existing
infrastructure.  If the test suite detects that small-order THP is not
supported by the kernel, the new tests are skipped.

Link: https://lkml.kernel.org/r/20230929114421.3761121-10-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Itaru Kitayama <itaru.kitayama@gmail.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/cow.c |   93 +++++++++++++++++++++++++++++
 1 file changed, 93 insertions(+)

--- a/tools/testing/selftests/mm/cow.c~selftests-mm-cow-add-tests-for-small-order-anon-thp
+++ a/tools/testing/selftests/mm/cow.c
@@ -33,10 +33,13 @@
 static size_t pagesize;
 static int pagemap_fd;
 static size_t pmdsize;
+static size_t ptesize;
 static int nr_hugetlbsizes;
 static size_t hugetlbsizes[10];
 static int gup_fd;
 static bool has_huge_zeropage;
+static unsigned int orig_anon_orders;
+static bool orig_anon_orders_valid;
 
 static void detect_huge_zeropage(void)
 {
@@ -1118,6 +1121,14 @@ static void run_anon_test_case(struct te
 		run_with_partial_mremap_thp(test_case->fn, test_case->desc, pmdsize);
 		run_with_partial_shared_thp(test_case->fn, test_case->desc, pmdsize);
 	}
+	if (ptesize) {
+		run_with_pte_mapped_thp(test_case->fn, test_case->desc, ptesize);
+		run_with_pte_mapped_thp_swap(test_case->fn, test_case->desc, ptesize);
+		run_with_single_pte_of_thp(test_case->fn, test_case->desc, ptesize);
+		run_with_single_pte_of_thp_swap(test_case->fn, test_case->desc, ptesize);
+		run_with_partial_mremap_thp(test_case->fn, test_case->desc, ptesize);
+		run_with_partial_shared_thp(test_case->fn, test_case->desc, ptesize);
+	}
 	for (i = 0; i < nr_hugetlbsizes; i++)
 		run_with_hugetlb(test_case->fn, test_case->desc,
 				 hugetlbsizes[i]);
@@ -1139,6 +1150,8 @@ static int tests_per_anon_test_case(void
 
 	if (pmdsize)
 		tests += 8;
+	if (ptesize)
+		tests += 6;
 	return tests;
 }
 
@@ -1693,6 +1706,80 @@ static int tests_per_non_anon_test_case(
 	return tests;
 }
 
+#define ANON_ORDERS_FILE "/sys/kernel/mm/transparent_hugepage/anon_orders"
+
+static int read_anon_orders(unsigned int *orders)
+{
+	ssize_t buflen = 80;
+	char buf[buflen];
+	int fd;
+
+	fd = open(ANON_ORDERS_FILE, O_RDONLY);
+	if (fd == -1)
+		return -1;
+
+	buflen = read(fd, buf, buflen);
+	close(fd);
+
+	if (buflen < 1)
+		return -1;
+
+	*orders = strtoul(buf, NULL, 16);
+
+	return 0;
+}
+
+static int write_anon_orders(unsigned int orders)
+{
+	ssize_t buflen = 80;
+	char buf[buflen];
+	int fd;
+
+	fd = open(ANON_ORDERS_FILE, O_WRONLY);
+	if (fd == -1)
+		return -1;
+
+	buflen = snprintf(buf, buflen, "0x%08x\n", orders);
+	buflen = write(fd, buf, buflen);
+	close(fd);
+
+	if (buflen < 1)
+		return -1;
+
+	return 0;
+}
+
+static size_t save_thp_anon_orders(void)
+{
+	/*
+	 * If the kernel supports multiple orders for anon THP (indicated by the
+	 * presence of anon_orders file), configure it for the PMD-order and the
+	 * PMD-order - 1, which we will report back and use as the PTE-order THP
+	 * size. Save the original value so that it can be restored on exit. If
+	 * the kernel does not support multiple orders, report back 0 for the
+	 * PTE-size so those tests are skipped.
+	 */
+
+	int pteorder = sz2ord(pmdsize) - 1;
+	unsigned int orders = (1UL << sz2ord(pmdsize)) | (1UL << pteorder);
+
+	if (read_anon_orders(&orig_anon_orders))
+		return 0;
+
+	orig_anon_orders_valid = true;
+
+	if (write_anon_orders(orders))
+		return 0;
+
+	return pagesize << pteorder;
+}
+
+static void restore_thp_anon_orders(void)
+{
+	if (orig_anon_orders_valid)
+		write_anon_orders(orig_anon_orders);
+}
+
 int main(int argc, char **argv)
 {
 	int err;
@@ -1702,6 +1789,10 @@ int main(int argc, char **argv)
 	if (pmdsize)
 		ksft_print_msg("[INFO] detected PMD-mapped THP size: %zu KiB\n",
 			       pmdsize / 1024);
+	ptesize = save_thp_anon_orders();
+	if (ptesize)
+		ksft_print_msg("[INFO] configured PTE-mapped THP size: %zu KiB\n",
+			       ptesize / 1024);
 	nr_hugetlbsizes = detect_hugetlb_page_sizes(hugetlbsizes,
 						    ARRAY_SIZE(hugetlbsizes));
 	detect_huge_zeropage();
@@ -1720,6 +1811,8 @@ int main(int argc, char **argv)
 	run_anon_thp_test_cases();
 	run_non_anon_test_cases();
 
+	restore_thp_anon_orders();
+
 	err = ksft_get_fail_cnt();
 	if (err)
 		ksft_exit_fail_msg("%d out of %d tests failed\n",
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

mm-hugetlb-add-huge-page-size-param-to-set_huge_pte_at.patch
arm64-hugetlb-fix-set_huge_pte_at-to-work-with-all-swap-entries.patch
mm-allow-deferred-splitting-of-arbitrary-anon-large-folios.patch
mm-non-pmd-mappable-large-folios-for-folio_add_new_anon_rmap.patch
mm-thp-account-pte-mapped-anonymous-thp-usage.patch
mm-thp-introduce-anon_orders-and-anon_always_mask-sysfs-files.patch
mm-thp-extend-thp-to-allocate-anonymous-large-folios.patch
mm-thp-add-recommend-option-for-anon_orders.patch
arm64-mm-override-arch_wants_pte_order.patch
selftests-mm-cow-generalize-do_run_with_thp-helper.patch
selftests-mm-cow-add-tests-for-small-order-anon-thp.patch

