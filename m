Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55DB64CE13
	for <mm-commits@vger.kernel.org>; Wed, 20 Dec 2023 22:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dY+VGj9b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D167BC433C8;
	Wed, 20 Dec 2023 22:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703112556;
	bh=HjT8/4a8NF9hq/ELKoVwWgy/QI7Rs72Awxba6YAmkcw=;
	h=Date:To:From:Subject:From;
	b=dY+VGj9bpIS5KDGznEsKa5N/FXU9jVS7RuWi3PBI+xFPVRKSvoe/C8t5ZHkfn9NNe
	 jSsU5/zoDok8pfB1wQKyVe/RT3kusUW74XEdf0j7TB/KlzlYWJBdO+CORCg4e7edfX
	 Vf0D39zMZQkis4OUNNEUbMnYo7xqPVK2UkI2ccBM=
Date: Wed, 20 Dec 2023 14:49:16 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,ying.huang@intel.com,willy@infradead.org,wangkefeng.wang@huawei.com,v-songbaohua@oppo.com,vbabka@suse.cz,shy828301@gmail.com,rientjes@google.com,mcgrof@kernel.org,kirill.shutemov@linux.intel.com,jhubbard@nvidia.com,itaru.kitayama@gmail.com,hughd@google.com,fengwei.yin@intel.com,david@redhat.com,catalin.marinas@arm.com,apopple@nvidia.com,anshuman.khandual@arm.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-cow-add-tests-for-anonymous-multi-size-thp.patch removed from -mm tree
Message-Id: <20231220224916.D167BC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm/cow: add tests for anonymous multi-size THP
has been removed from the -mm tree.  Its filename was
     selftests-mm-cow-add-tests-for-anonymous-multi-size-thp.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

 tools/testing/selftests/mm/cow.c |   82 ++++++++++++++++++++++++-----
 1 file changed, 70 insertions(+), 12 deletions(-)

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
 
@@ -1689,16 +1736,22 @@ static int tests_per_non_anon_test_case(
 int main(int argc, char **argv)
 {
 	int err;
+	struct thp_settings default_settings;
 
 	ksft_print_header();
 
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
+		nr_thpsizes = detect_thp_sizes(thpsizes, ARRAY_SIZE(thpsizes));
 	}
 	nr_hugetlbsizes = detect_hugetlb_page_sizes(hugetlbsizes,
 						    ARRAY_SIZE(hugetlbsizes));
@@ -1717,6 +1770,11 @@ int main(int argc, char **argv)
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

selftests-mm-log-run_vmtestssh-results-in-tap-format.patch

