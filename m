Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6BEEC4167B
	for <mm-commits@archiver.kernel.org>; Thu,  7 Dec 2023 22:05:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235307AbjLGWEz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 7 Dec 2023 17:04:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235331AbjLGWEv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Dec 2023 17:04:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 313E110F9
        for <mm-commits@vger.kernel.org>; Thu,  7 Dec 2023 14:04:46 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2B33C433C8;
        Thu,  7 Dec 2023 22:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701986685;
        bh=fME7+Qw/SrdTXMyPxdxhPhJ9U2Y2r7tQnlaR5ZgzGso=;
        h=Date:To:From:Subject:From;
        b=Zm7rdL4HdrNOuSRt7pnW9Bs/LI73ZHVZjM8i0Jo+q7p1BrXidRqtYrbmFGKV0B/eR
         tmqN5PU13SX70nHx/P7TcW3LEeNOXvASuTIb45h6OW2qF6QhthxyWmxuc6YH3HzwLr
         wkJWjmXZ0ymiGC7jN5hybFRckFakV7qFlPhakAz4=
Date:   Thu, 07 Dec 2023 14:04:45 -0800
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, yuzhao@google.com,
        ying.huang@intel.com, willy@infradead.org,
        wangkefeng.wang@huawei.com, v-songbaohua@oppo.com, vbabka@suse.cz,
        shy828301@gmail.com, rientjes@google.com, mcgrof@kernel.org,
        kirill.shutemov@linux.intel.com, jhubbard@nvidia.com,
        itaru.kitayama@gmail.com, hughd@google.com, fengwei.yin@intel.com,
        david@redhat.com, catalin.marinas@arm.com, apopple@nvidia.com,
        anshuman.khandual@arm.com, ryan.roberts@arm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-cow-add-tests-for-anonymous-multi-size-thp.patch added to mm-unstable branch
Message-Id: <20231207220445.C2B33C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mm/cow: add tests for anonymous multi-size THP
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-cow-add-tests-for-anonymous-multi-size-thp.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-cow-add-tests-for-anonymous-multi-size-thp.patch

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
Subject: selftests/mm/cow: add tests for anonymous multi-size THP
Date: Thu, 7 Dec 2023 16:12:11 +0000

Add tests similar to the existing PMD-sized THP tests, but which operate
on memory backed by (PTE-mapped) multi-size THP.  This reuses all the
existing infrastructure.  If the test suite detects that multi-size THP is
not supported by the kernel, the new tests are skipped.

Link: https://lkml.kernel.org/r/20231207161211.2374093-11-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Tested-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Tested-by: John Hubbard <jhubbard@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Itaru Kitayama <itaru.kitayama@gmail.com>
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

 tools/testing/selftests/mm/cow.c |   84 ++++++++++++++++++++++++-----
 1 file changed, 72 insertions(+), 12 deletions(-)

--- a/tools/testing/selftests/mm/cow.c~selftests-mm-cow-add-tests-for-anonymous-multi-size-thp
+++ a/tools/testing/selftests/mm/cow.c
@@ -29,15 +29,49 @@
 #include "../../../../mm/gup_test.h"
 #include "../kselftest.h"
 #include "vm_util.h"
+#include "thp_settings.h"
 
 static size_t pagesize;
 static int pagemap_fd;
 static size_t pmdsize;
+static int nr_thpsizes;
+static size_t thpsizes[20];
 static int nr_hugetlbsizes;
 static size_t hugetlbsizes[10];
 static int gup_fd;
 static bool has_huge_zeropage;
 
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
+	if (!pmdsize)
+		return 0;
+
+	orders = 1UL << sz2ord(pmdsize);
+	orders |= thp_supported_orders();
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
 static void detect_huge_zeropage(void)
 {
 	int fd = open("/sys/kernel/mm/transparent_hugepage/use_zero_page",
@@ -1101,15 +1135,27 @@ static void run_anon_test_case(struct te
 
 	run_with_base_page(test_case->fn, test_case->desc);
 	run_with_base_page_swap(test_case->fn, test_case->desc);
-	if (pmdsize) {
-		run_with_thp(test_case->fn, test_case->desc, pmdsize);
-		run_with_thp_swap(test_case->fn, test_case->desc, pmdsize);
-		run_with_pte_mapped_thp(test_case->fn, test_case->desc, pmdsize);
-		run_with_pte_mapped_thp_swap(test_case->fn, test_case->desc, pmdsize);
-		run_with_single_pte_of_thp(test_case->fn, test_case->desc, pmdsize);
-		run_with_single_pte_of_thp_swap(test_case->fn, test_case->desc, pmdsize);
-		run_with_partial_mremap_thp(test_case->fn, test_case->desc, pmdsize);
-		run_with_partial_shared_thp(test_case->fn, test_case->desc, pmdsize);
+	for (i = 0; i < nr_thpsizes; i++) {
+		size_t size = thpsizes[i];
+		struct thp_settings settings = *thp_current_settings();
+
+		settings.hugepages[sz2ord(pmdsize)].enabled = THP_NEVER;
+		settings.hugepages[sz2ord(size)].enabled = THP_ALWAYS;
+		thp_push_settings(&settings);
+
+		if (size == pmdsize) {
+			run_with_thp(test_case->fn, test_case->desc, size);
+			run_with_thp_swap(test_case->fn, test_case->desc, size);
+		}
+
+		run_with_pte_mapped_thp(test_case->fn, test_case->desc, size);
+		run_with_pte_mapped_thp_swap(test_case->fn, test_case->desc, size);
+		run_with_single_pte_of_thp(test_case->fn, test_case->desc, size);
+		run_with_single_pte_of_thp_swap(test_case->fn, test_case->desc, size);
+		run_with_partial_mremap_thp(test_case->fn, test_case->desc, size);
+		run_with_partial_shared_thp(test_case->fn, test_case->desc, size);
+
+		thp_pop_settings();
 	}
 	for (i = 0; i < nr_hugetlbsizes; i++)
 		run_with_hugetlb(test_case->fn, test_case->desc,
@@ -1130,8 +1176,9 @@ static int tests_per_anon_test_case(void
 {
 	int tests = 2 + nr_hugetlbsizes;
 
+	tests += 6 * nr_thpsizes;
 	if (pmdsize)
-		tests += 8;
+		tests += 2;
 	return tests;
 }
 
@@ -1689,15 +1736,23 @@ static int tests_per_non_anon_test_case(
 int main(int argc, char **argv)
 {
 	int err;
+	struct thp_settings default_settings;
 
 	pagesize = getpagesize();
 	pmdsize = read_pmd_pagesize();
 	if (pmdsize) {
+		/* Only if THP is supported. */
+		thp_read_settings(&default_settings);
+		default_settings.hugepages[sz2ord(pmdsize)].enabled = THP_INHERIT;
+		thp_save_settings();
+		thp_push_settings(&default_settings);
+
 		ksft_print_msg("[INFO] detected PMD size: %zu KiB\n",
 			       pmdsize / 1024);
-		ksft_print_msg("[INFO] detected THP size: %zu KiB\n",
-			       pmdsize / 1024);
+
+		nr_thpsizes = detect_thp_sizes(thpsizes, ARRAY_SIZE(thpsizes));
 	}
+
 	nr_hugetlbsizes = detect_hugetlb_page_sizes(hugetlbsizes,
 						    ARRAY_SIZE(hugetlbsizes));
 	detect_huge_zeropage();
@@ -1716,6 +1771,11 @@ int main(int argc, char **argv)
 	run_anon_thp_test_cases();
 	run_non_anon_test_cases();
 
+	if (pmdsize) {
+		/* Only if THP is supported. */
+		thp_restore_settings();
+	}
+
 	err = ksft_get_fail_cnt();
 	if (err)
 		ksft_exit_fail_msg("%d out of %d tests failed\n",
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

mm-readahead-do-not-allow-order-1-folio.patch
mm-allow-deferred-splitting-of-arbitrary-anon-large-folios.patch
mm-non-pmd-mappable-large-folios-for-folio_add_new_anon_rmap.patch
mm-thp-introduce-multi-size-thp-sysfs-interface.patch
mm-thp-support-allocation-of-anonymous-multi-size-thp.patch
selftests-mm-kugepaged-restore-thp-settings-at-exit.patch
selftests-mm-factor-out-thp-settings-management.patch
selftests-mm-support-multi-size-thp-interface-in-thp_settings.patch
selftests-mm-khugepaged-enlighten-for-multi-size-thp.patch
selftests-mm-cow-generalize-do_run_with_thp-helper.patch
selftests-mm-cow-add-tests-for-anonymous-multi-size-thp.patch

