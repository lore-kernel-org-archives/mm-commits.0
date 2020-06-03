From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 068/131] khugepaged: introduce 'max_ptes_shared'
 tunable
Date: Wed, 03 Jun 2020 16:00:30 -0700
Message-ID: <20200603230030.9ZAXhDHr5%akpm@linux-foundation.org>
References: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725821AbgFCXAd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Jun 2020 19:00:33 -0400
In-Reply-To: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, akpm@linux-foundation.org, colin.king@canonical.com, jhubbard@nvidia.com, kirill.shutemov@linux.intel.com, linux-mm@kvack.org, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, rcampbell@nvidia.com, torvalds@linux-foundation.org, william.kucharski@oracle.com, yang.shi@linux.alibaba.com, ziy@nvidia.com

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: khugepaged: introduce 'max_ptes_shared' tunable

'max_ptes_shared' specifies how many pages can be shared across multiple
processes.  Exceeding the number would block the collapse::

	/sys/kernel/mm/transparent_hugepage/khugepaged/max_ptes_shared

A higher value may increase memory footprint for some workloads.

By default, at least half of pages has to be not shared.

[colin.king@canonical.com: fix several spelling mistakes]
  Link: http://lkml.kernel.org/r/20200420084241.65433-1-colin.king@canonical.com
Link: http://lkml.kernel.org/r/20200416160026.16538-9-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Tested-by: Zi Yan <ziy@nvidia.com>
Acked-by: Yang Shi <yang.shi@linux.alibaba.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/transhuge.rst |    7 +
 include/trace/events/huge_memory.h         |    3 
 mm/khugepaged.c                            |   52 ++++++++++-
 tools/testing/selftests/vm/khugepaged.c    |   83 +++++++++++++++++++
 4 files changed, 140 insertions(+), 5 deletions(-)

--- a/Documentation/admin-guide/mm/transhuge.rst~khugepaged-introduce-max_ptes_shared-tunable
+++ a/Documentation/admin-guide/mm/transhuge.rst
@@ -220,6 +220,13 @@ memory. A lower value can prevent THPs f
 collapsed, resulting fewer pages being collapsed into
 THPs, and lower memory access performance.
 
+``max_ptes_shared`` specifies how many pages can be shared across multiple
+processes. Exceeding the number would block the collapse::
+
+	/sys/kernel/mm/transparent_hugepage/khugepaged/max_ptes_shared
+
+A higher value may increase memory footprint for some workloads.
+
 Boot parameter
 ==============
 
--- a/include/trace/events/huge_memory.h~khugepaged-introduce-max_ptes_shared-tunable
+++ a/include/trace/events/huge_memory.h
@@ -12,6 +12,8 @@
 	EM( SCAN_SUCCEED,		"succeeded")			\
 	EM( SCAN_PMD_NULL,		"pmd_null")			\
 	EM( SCAN_EXCEED_NONE_PTE,	"exceed_none_pte")		\
+	EM( SCAN_EXCEED_SWAP_PTE,	"exceed_swap_pte")		\
+	EM( SCAN_EXCEED_SHARED_PTE,	"exceed_shared_pte")		\
 	EM( SCAN_PTE_NON_PRESENT,	"pte_non_present")		\
 	EM( SCAN_PTE_UFFD_WP,		"pte_uffd_wp")			\
 	EM( SCAN_PAGE_RO,		"no_writable_page")		\
@@ -31,7 +33,6 @@
 	EM( SCAN_DEL_PAGE_LRU,		"could_not_delete_page_from_lru")\
 	EM( SCAN_ALLOC_HUGE_PAGE_FAIL,	"alloc_huge_page_failed")	\
 	EM( SCAN_CGROUP_CHARGE_FAIL,	"ccgroup_charge_failed")	\
-	EM( SCAN_EXCEED_SWAP_PTE,	"exceed_swap_pte")		\
 	EM( SCAN_TRUNCATED,		"truncated")			\
 	EMe(SCAN_PAGE_HAS_PRIVATE,	"page_has_private")		\
 
--- a/mm/khugepaged.c~khugepaged-introduce-max_ptes_shared-tunable
+++ a/mm/khugepaged.c
@@ -28,6 +28,8 @@ enum scan_result {
 	SCAN_SUCCEED,
 	SCAN_PMD_NULL,
 	SCAN_EXCEED_NONE_PTE,
+	SCAN_EXCEED_SWAP_PTE,
+	SCAN_EXCEED_SHARED_PTE,
 	SCAN_PTE_NON_PRESENT,
 	SCAN_PTE_UFFD_WP,
 	SCAN_PAGE_RO,
@@ -47,7 +49,6 @@ enum scan_result {
 	SCAN_DEL_PAGE_LRU,
 	SCAN_ALLOC_HUGE_PAGE_FAIL,
 	SCAN_CGROUP_CHARGE_FAIL,
-	SCAN_EXCEED_SWAP_PTE,
 	SCAN_TRUNCATED,
 	SCAN_PAGE_HAS_PRIVATE,
 };
@@ -72,6 +73,7 @@ static DECLARE_WAIT_QUEUE_HEAD(khugepage
  */
 static unsigned int khugepaged_max_ptes_none __read_mostly;
 static unsigned int khugepaged_max_ptes_swap __read_mostly;
+static unsigned int khugepaged_max_ptes_shared __read_mostly;
 
 #define MM_SLOTS_HASH_BITS 10
 static __read_mostly DEFINE_HASHTABLE(mm_slots_hash, MM_SLOTS_HASH_BITS);
@@ -291,15 +293,43 @@ static struct kobj_attribute khugepaged_
 	__ATTR(max_ptes_swap, 0644, khugepaged_max_ptes_swap_show,
 	       khugepaged_max_ptes_swap_store);
 
+static ssize_t khugepaged_max_ptes_shared_show(struct kobject *kobj,
+					     struct kobj_attribute *attr,
+					     char *buf)
+{
+	return sprintf(buf, "%u\n", khugepaged_max_ptes_shared);
+}
+
+static ssize_t khugepaged_max_ptes_shared_store(struct kobject *kobj,
+					      struct kobj_attribute *attr,
+					      const char *buf, size_t count)
+{
+	int err;
+	unsigned long max_ptes_shared;
+
+	err  = kstrtoul(buf, 10, &max_ptes_shared);
+	if (err || max_ptes_shared > HPAGE_PMD_NR-1)
+		return -EINVAL;
+
+	khugepaged_max_ptes_shared = max_ptes_shared;
+
+	return count;
+}
+
+static struct kobj_attribute khugepaged_max_ptes_shared_attr =
+	__ATTR(max_ptes_shared, 0644, khugepaged_max_ptes_shared_show,
+	       khugepaged_max_ptes_shared_store);
+
 static struct attribute *khugepaged_attr[] = {
 	&khugepaged_defrag_attr.attr,
 	&khugepaged_max_ptes_none_attr.attr,
+	&khugepaged_max_ptes_swap_attr.attr,
+	&khugepaged_max_ptes_shared_attr.attr,
 	&pages_to_scan_attr.attr,
 	&pages_collapsed_attr.attr,
 	&full_scans_attr.attr,
 	&scan_sleep_millisecs_attr.attr,
 	&alloc_sleep_millisecs_attr.attr,
-	&khugepaged_max_ptes_swap_attr.attr,
 	NULL,
 };
 
@@ -359,6 +389,7 @@ int __init khugepaged_init(void)
 	khugepaged_pages_to_scan = HPAGE_PMD_NR * 8;
 	khugepaged_max_ptes_none = HPAGE_PMD_NR - 1;
 	khugepaged_max_ptes_swap = HPAGE_PMD_NR / 8;
+	khugepaged_max_ptes_shared = HPAGE_PMD_NR / 2;
 
 	return 0;
 }
@@ -557,7 +588,7 @@ static int __collapse_huge_page_isolate(
 {
 	struct page *page = NULL;
 	pte_t *_pte;
-	int none_or_zero = 0, result = 0, referenced = 0;
+	int none_or_zero = 0, shared = 0, result = 0, referenced = 0;
 	bool writable = false;
 
 	for (_pte = pte; _pte < pte+HPAGE_PMD_NR;
@@ -585,6 +616,12 @@ static int __collapse_huge_page_isolate(
 
 		VM_BUG_ON_PAGE(!PageAnon(page), page);
 
+		if (page_mapcount(page) > 1 &&
+				++shared > khugepaged_max_ptes_shared) {
+			result = SCAN_EXCEED_SHARED_PTE;
+			goto out;
+		}
+
 		if (PageCompound(page)) {
 			struct page *p;
 			page = compound_head(page);
@@ -1168,7 +1205,8 @@ static int khugepaged_scan_pmd(struct mm
 {
 	pmd_t *pmd;
 	pte_t *pte, *_pte;
-	int ret = 0, none_or_zero = 0, result = 0, referenced = 0;
+	int ret = 0, result = 0, referenced = 0;
+	int none_or_zero = 0, shared = 0;
 	struct page *page = NULL;
 	unsigned long _address;
 	spinlock_t *ptl;
@@ -1240,6 +1278,12 @@ static int khugepaged_scan_pmd(struct mm
 			goto out_unmap;
 		}
 
+		if (page_mapcount(page) > 1 &&
+				++shared > khugepaged_max_ptes_shared) {
+			result = SCAN_EXCEED_SHARED_PTE;
+			goto out_unmap;
+		}
+
 		page = compound_head(page);
 
 		/*
--- a/tools/testing/selftests/vm/khugepaged.c~khugepaged-introduce-max_ptes_shared-tunable
+++ a/tools/testing/selftests/vm/khugepaged.c
@@ -78,6 +78,7 @@ struct khugepaged_settings {
 	unsigned int scan_sleep_millisecs;
 	unsigned int max_ptes_none;
 	unsigned int max_ptes_swap;
+	unsigned int max_ptes_shared;
 	unsigned long pages_to_scan;
 };
 
@@ -277,6 +278,7 @@ static void write_settings(struct settin
 			khugepaged->scan_sleep_millisecs);
 	write_num("khugepaged/max_ptes_none", khugepaged->max_ptes_none);
 	write_num("khugepaged/max_ptes_swap", khugepaged->max_ptes_swap);
+	write_num("khugepaged/max_ptes_shared", khugepaged->max_ptes_shared);
 	write_num("khugepaged/pages_to_scan", khugepaged->pages_to_scan);
 }
 
@@ -313,6 +315,7 @@ static void save_settings(void)
 			read_num("khugepaged/scan_sleep_millisecs"),
 		.max_ptes_none = read_num("khugepaged/max_ptes_none"),
 		.max_ptes_swap = read_num("khugepaged/max_ptes_swap"),
+		.max_ptes_shared = read_num("khugepaged/max_ptes_shared"),
 		.pages_to_scan = read_num("khugepaged/pages_to_scan"),
 	};
 	success("OK");
@@ -896,12 +899,90 @@ static void collapse_fork_compound(void)
 			fail("Fail");
 		fill_memory(p, 0, page_size);
 
+		write_num("khugepaged/max_ptes_shared", hpage_pmd_nr - 1);
 		if (wait_for_scan("Collapse PTE table full of compound pages in child", p))
 			fail("Timeout");
 		else if (check_huge(p))
 			success("OK");
 		else
 			fail("Fail");
+		write_num("khugepaged/max_ptes_shared",
+				default_settings.khugepaged.max_ptes_shared);
+
+		validate_memory(p, 0, hpage_pmd_size);
+		munmap(p, hpage_pmd_size);
+		exit(exit_status);
+	}
+
+	wait(&wstatus);
+	exit_status += WEXITSTATUS(wstatus);
+
+	printf("Check if parent still has huge page...");
+	if (check_huge(p))
+		success("OK");
+	else
+		fail("Fail");
+	validate_memory(p, 0, hpage_pmd_size);
+	munmap(p, hpage_pmd_size);
+}
+
+static void collapse_max_ptes_shared()
+{
+	int max_ptes_shared = read_num("khugepaged/max_ptes_shared");
+	int wstatus;
+	void *p;
+
+	p = alloc_mapping();
+
+	printf("Allocate huge page...");
+	madvise(p, hpage_pmd_size, MADV_HUGEPAGE);
+	fill_memory(p, 0, hpage_pmd_size);
+	if (check_huge(p))
+		success("OK");
+	else
+		fail("Fail");
+
+	printf("Share huge page over fork()...");
+	if (!fork()) {
+		/* Do not touch settings on child exit */
+		skip_settings_restore = true;
+		exit_status = 0;
+
+		if (check_huge(p))
+			success("OK");
+		else
+			fail("Fail");
+
+		printf("Trigger CoW on page %d of %d...",
+				hpage_pmd_nr - max_ptes_shared - 1, hpage_pmd_nr);
+		fill_memory(p, 0, (hpage_pmd_nr - max_ptes_shared - 1) * page_size);
+		if (!check_huge(p))
+			success("OK");
+		else
+			fail("Fail");
+
+		if (wait_for_scan("Do not collapse with max_ptes_shared exceeded", p))
+			fail("Timeout");
+		else if (!check_huge(p))
+			success("OK");
+		else
+			fail("Fail");
+
+		printf("Trigger CoW on page %d of %d...",
+				hpage_pmd_nr - max_ptes_shared, hpage_pmd_nr);
+		fill_memory(p, 0, (hpage_pmd_nr - max_ptes_shared) * page_size);
+		if (!check_huge(p))
+			success("OK");
+		else
+			fail("Fail");
+
+
+		if (wait_for_scan("Collapse with max_ptes_shared PTEs shared", p))
+			fail("Timeout");
+		else if (check_huge(p))
+			success("OK");
+		else
+			fail("Fail");
 
 		validate_memory(p, 0, hpage_pmd_size);
 		munmap(p, hpage_pmd_size);
@@ -930,6 +1011,7 @@ int main(void)
 
 	default_settings.khugepaged.max_ptes_none = hpage_pmd_nr - 1;
 	default_settings.khugepaged.max_ptes_swap = hpage_pmd_nr / 8;
+	default_settings.khugepaged.max_ptes_shared = hpage_pmd_nr / 2;
 	default_settings.khugepaged.pages_to_scan = hpage_pmd_nr * 8;
 
 	save_settings();
@@ -947,6 +1029,7 @@ int main(void)
 	collapse_compound_extreme();
 	collapse_fork();
 	collapse_fork_compound();
+	collapse_max_ptes_shared();
 
 	restore_settings(0);
 }
_
