Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86467349CC4
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622857; cv=none; b=rOucDChO8aTpjnQB+4Kgiag8fMemuyB8ZIz83mDOAsgg5h6CzodJgBMzWf68M0gKptomNQ3FKOSyP/D1znBeJZK+LhxVbp1xm7pxuccGRc0esuw6pgVsAkUgQtMrbnnBm+T3NjnuiXdhZWVPl+Y0YHw5rUfGNYw3mzWi7EiGV30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622857; c=relaxed/simple;
	bh=duQ+ZU8dqh+QhKNFzBU7lmf9XvcQF3QR1RNiUcmVc+A=;
	h=Date:To:From:Subject:Message-Id; b=a43LcxT+1qpZHDLKliC4G+2plSewg5t6ss89HhswkAfwVRsq+9n4zexRKG2Lm6sKQWn8NxGqDXebQFLnsHyccpfzTmQrBAr36HBQGxiCGUhAzwo8c/U4NiIEqmPTA2Q9xN3ei/JbjttbKiNLYHNHc3aeVFf8JrhlukROQvplmDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nrtMVUdY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nrtMVUdY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF5291F00A3D;
	Tue, 25 Aug 2026 01:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622854;
	bh=lK/3ynP0N2lBsrRPhifkUqCSveE2Cw+OLBydbDgDzP0=;
	h=Date:To:From:Subject;
	b=nrtMVUdY7I+KDxonR9SWF6xQDxHh9EDsiW9TmERVuTx68ZwW4D9oGAy30wCJzuKDd
	 ojCWn1XZ6UnNrFMNyP8BocrZdWLRA2B3PvduLOG0ugMUtMaTcWPnQHxsSNzcbjePb0
	 DMj2NU4ELmBElBrQunOHY8BuEtoxgrK82BoEf09Q=
Date: Mon, 24 Aug 2026 18:54:14 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,nico.pache@linux.dev,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kas@kernel.org,dev.jain@arm.com,david@kernel.org,baohua@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-add-mthp-collapse-test-cases.patch removed from -mm tree
Message-Id: <20260825015414.CF5291F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests: mm: add mTHP collapse test cases
has been removed from the -mm tree.  Its filename was
     selftests-mm-add-mthp-collapse-test-cases.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: selftests: mm: add mTHP collapse test cases
Date: Thu, 6 Aug 2026 11:34:15 +0800

Added a new command 'mthp_khugepaged' for mTHP collapse, along with the
'-c' parameter to specify the collapse order.  Additionally, added mTHP
collapse test cases for 'collapse_full', 'collapse_empty', and
'collapse_single_mthp' for anonymous folios.  All khugepaged test cases
passed.

Link: https://lore.kernel.org/f260058520214a9611922a96326bc54ba282fb73.1785985999.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
Tested-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/khugepaged.c   |  137 +++++++++++++++++---
 tools/testing/selftests/mm/run_vmtests.sh |    2 
 2 files changed, 120 insertions(+), 19 deletions(-)

--- a/tools/testing/selftests/mm/khugepaged.c~selftests-mm-add-mthp-collapse-test-cases
+++ a/tools/testing/selftests/mm/khugepaged.c
@@ -26,9 +26,11 @@
 
 #define BASE_ADDR ((void *)(1UL << 30))
 static unsigned long hpage_pmd_size;
+static int hpage_pmd_order;
 static unsigned long page_size;
 static int hpage_pmd_nr;
 static int anon_order;
+static int collapse_order;
 
 #define PID_SMAPS "/proc/self/smaps"
 #define TEST_FILE "collapse_test_file"
@@ -69,6 +71,7 @@ struct collapse_context {
 };
 
 static struct collapse_context *khugepaged_context;
+static struct collapse_context *mthp_khugepaged_context;
 static struct collapse_context *madvise_context;
 
 struct file_info {
@@ -554,25 +557,25 @@ static void madvise_collapse(const char
 }
 
 #define TICK 500000
-static bool wait_for_scan(const char *msg, char *p, int nr_hpages,
-			  struct mem_ops *ops)
+static bool wait_for_scan(const char *msg, char *p, size_t len,
+		int nr_hpages, int collap_order, struct mem_ops *ops)
 {
-	size_t len = nr_hpages * hpage_pmd_size;
+	unsigned long hpage_size = page_size << collap_order;
 	int full_scans;
 	int timeout = 6; /* 3 seconds */
 
 	/* Sanity check */
-	if (!ops->check_huge(p, len, 0, hpage_pmd_size))
+	if (!ops->check_huge(p, len, 0, hpage_size))
 		ksft_exit_fail_msg("Unexpected huge page\n");
 
-	madvise(p, nr_hpages * hpage_pmd_size, MADV_HUGEPAGE);
+	madvise(p, len, MADV_HUGEPAGE);
 
 	/* Wait until the second full_scan completed */
 	full_scans = thp_read_num("khugepaged/full_scans") + 2;
 
 	ksft_print_msg("%s...", msg);
 	while (timeout--) {
-		if (ops->check_huge(p, len, nr_hpages, hpage_pmd_size))
+		if (ops->check_huge(p, len, nr_hpages, hpage_size))
 			break;
 		if (thp_read_num("khugepaged/full_scans") >= full_scans)
 			break;
@@ -595,7 +598,7 @@ static void khugepaged_collapse(const ch
 	if (!is_tmpfs(ops) && ops == &__read_write_file_write_ops)
 		expect = false;
 
-	if (wait_for_scan(msg, p, nr_hpages, ops)) {
+	if (wait_for_scan(msg, p, len, nr_hpages, hpage_pmd_order, ops)) {
 		if (expect)
 			fail("Timeout");
 		else
@@ -617,12 +620,62 @@ static void khugepaged_collapse(const ch
 		fail("Fail");
 }
 
+static void mthp_khugepaged_collapse(const char *msg, char *p, int nr_hpages,
+				struct mem_ops *ops, bool expect)
+{
+	unsigned long hpage_size = page_size << collapse_order;
+	struct thp_settings settings = *thp_current_settings();
+	/* mTHP collpase only allocates PMD sized memory */
+	size_t len = hpage_pmd_size;
+
+	/* Set mTHP setting for mTHP collapse */
+	if (ops == &__anon_ops) {
+		settings.thp_enabled = THP_NEVER;
+		settings.hugepages[collapse_order].enabled = THP_MADVISE;
+	}
+
+	thp_push_settings(&settings);
+
+	if (wait_for_scan(msg, p, len, nr_hpages, collapse_order, ops)) {
+		if (expect)
+			fail("Timeout");
+		else
+			success("OK");
+
+		/* Restore THP settings for mTHP collapse. */
+		thp_pop_settings();
+		return;
+	}
+
+	/*
+	 * For file and shmem memory, khugepaged only retracts pte entries after
+	 * putting the new hugepage in the page cache. The hugepage must be
+	 * subsequently refaulted to install the pmd mapping for the mm.
+	 */
+	if (ops != &__anon_ops)
+		ops->fault(p, 0, nr_hpages * hpage_size);
+
+	if (ops->check_huge(p, len, expect ? nr_hpages : 0, hpage_size))
+		success("OK");
+	else
+		fail("Fail");
+
+	/* Restore THP settings for mTHP collapse. */
+	thp_pop_settings();
+}
+
 static struct collapse_context __khugepaged_context = {
 	.collapse = &khugepaged_collapse,
 	.enforce_pte_scan_limits = true,
 	.name = "khugepaged",
 };
 
+static struct collapse_context __mthp_khugepaged_context = {
+	.collapse = &mthp_khugepaged_collapse,
+	.enforce_pte_scan_limits = true,
+	.name = "mthp_khugepaged",
+};
+
 static struct collapse_context __madvise_context = {
 	.collapse = &madvise_collapse,
 	.enforce_pte_scan_limits = false,
@@ -661,10 +714,17 @@ static void alloc_at_fault(void)
 static void collapse_full(struct collapse_context *c, struct mem_ops *ops)
 {
 	void *p;
-	int nr_hpages = 4;
+	int nr_pmds = 4, nr_hpages = 4;
 	unsigned long size = nr_hpages * hpage_pmd_size;
 
-	p = ops->setup_area(nr_hpages);
+	/* Only try 1 PMD sized range for mTHP collapse. */
+	if (c == &__mthp_khugepaged_context) {
+		nr_pmds = 1;
+		nr_hpages = 1 << (hpage_pmd_order - collapse_order);
+		size = hpage_pmd_size;
+	}
+
+	p = ops->setup_area(nr_pmds);
 	ops->fault(p, 0, size);
 	c->collapse("Collapse multiple fully populated PTE table", p, nr_hpages,
 		    ops, true);
@@ -676,10 +736,31 @@ static void collapse_full(struct collaps
 
 static void collapse_empty(struct collapse_context *c, struct mem_ops *ops)
 {
+	int nr_hpages = 1;
+	void *p;
+
+	if (c == &__mthp_khugepaged_context)
+		nr_hpages = 1 << (hpage_pmd_order - collapse_order);
+
+	p = ops->setup_area(1);
+	c->collapse("Do not collapse empty PTE table", p, nr_hpages, ops, false);
+	ops->cleanup_area(p, hpage_pmd_size);
+	ksft_test_result_report(exit_status, "%s\n", __func__);
+}
+
+static void collapse_single_mthp(struct collapse_context *c, struct mem_ops *ops)
+{
+	unsigned long hpage_size = page_size << collapse_order;
 	void *p;
 
 	p = ops->setup_area(1);
-	c->collapse("Do not collapse empty PTE table", p, 1, ops, false);
+	/*
+	 * Only fault collapse_order sized ranges, and only check 1
+	 * collapse_order sized huge page.
+	 */
+	ops->fault(p, 0, hpage_size);
+	c->collapse("Collapse PTE table with half PTE entries present",
+		p, 1, ops, true);
 	ops->cleanup_area(p, hpage_pmd_size);
 	ksft_test_result_report(exit_status, "%s\n", __func__);
 }
@@ -1081,8 +1162,8 @@ static void madvise_retracted_page_table
 	ops->fault(p, 0, size);
 
 	/* Let khugepaged collapse and leave pmd cleared */
-	if (wait_for_scan("Collapse and leave PMD cleared", p, nr_hpages,
-			  ops)) {
+	if (wait_for_scan("Collapse and leave PMD cleared", p, size, nr_hpages,
+			  hpage_pmd_order, ops)) {
 		fail("Timeout");
 		return;
 	}
@@ -1098,17 +1179,19 @@ static void usage(void)
 {
 	fprintf(stderr, "\nUsage: ./khugepaged [OPTIONS] <test type> [dir]\n\n");
 	fprintf(stderr, "\t<test type>\t: <context>:<mem_type>\n");
-	fprintf(stderr, "\t<context>\t: [all|khugepaged|madvise]\n");
+	fprintf(stderr, "\t<context>\t: [all|khugepaged|mthp_khugepaged|madvise]\n");
 	fprintf(stderr, "\t<mem_type>\t: [all|anon|file|shmem]\n");
 	fprintf(stderr, "\n\t\"file,all\" mem_type requires [dir] argument\n");
 	fprintf(stderr, "\n\t\"file,all\" mem_type requires a file system\n");
 	fprintf(stderr,	"\twith PMD-sized large folio support\n");
 	fprintf(stderr, "\n\tif [dir] is a (sub)directory of a tmpfs mount, tmpfs must be\n");
 	fprintf(stderr,	"\tmounted with huge=advise option for khugepaged tests to work\n");
+	fprintf(stderr, "\n\tmthp_khugepaged only supports anon mem_type now.\n");
 	fprintf(stderr,	"\n\tSupported Options:\n");
 	fprintf(stderr,	"\t\t-h: This help message.\n");
 	fprintf(stderr,	"\t\t-s: mTHP size, expressed as page order.\n");
 	fprintf(stderr,	"\t\t    Defaults to 0. Use this size for anon or shmem allocations.\n");
+	fprintf(stderr,	"\t\t-c: collapse order for mTHP collapse, expressed as page order.\n");
 	exit(1);
 }
 
@@ -1118,11 +1201,14 @@ static void parse_test_type(int argc, ch
 	char *buf;
 	const char *token;
 
-	while ((opt = getopt(argc, argv, "s:h")) != -1) {
+	while ((opt = getopt(argc, argv, "s:c:h")) != -1) {
 		switch (opt) {
 		case 's':
 			anon_order = atoi(optarg);
 			break;
+		case 'c':
+			collapse_order = atoi(optarg);
+			break;
 		case 'h':
 		default:
 			usage();
@@ -1148,6 +1234,10 @@ static void parse_test_type(int argc, ch
 		madvise_context =  &__madvise_context;
 	} else if (!strcmp(token, "khugepaged")) {
 		khugepaged_context =  &__khugepaged_context;
+	} else if (!strcmp(token, "mthp_khugepaged")) {
+		mthp_khugepaged_context =  &__mthp_khugepaged_context;
+		if (collapse_order <= 0 || collapse_order >= hpage_pmd_order)
+			usage();
 	} else if (!strcmp(token, "madvise")) {
 		madvise_context =  &__madvise_context;
 	} else {
@@ -1163,14 +1253,20 @@ static void parse_test_type(int argc, ch
 		read_write_file_write_ops =  &__read_write_file_write_ops;
 		anon_ops = &__anon_ops;
 		shmem_ops = &__shmem_ops;
+		if (mthp_khugepaged_context)
+			usage();
 	} else if (!strcmp(buf, "anon")) {
 		anon_ops = &__anon_ops;
 	} else if (!strcmp(buf, "file")) {
 		read_only_file_ops =  &__read_only_file_ops;
 		read_write_file_read_ops =  &__read_write_file_read_ops;
 		read_write_file_write_ops =  &__read_write_file_write_ops;
+		if (mthp_khugepaged_context)
+			usage();
 	} else if (!strcmp(buf, "shmem")) {
 		shmem_ops = &__shmem_ops;
+		if (mthp_khugepaged_context)
+			usage();
 	} else {
 		usage();
 	}
@@ -1213,7 +1309,6 @@ static int nr_test_cases;
 
 int main(int argc, char **argv)
 {
-	int hpage_pmd_order;
 	struct thp_settings default_settings = {
 		.thp_enabled = THP_MADVISE,
 		.thp_defrag = THP_DEFRAG_ALWAYS,
@@ -1239,10 +1334,6 @@ int main(int argc, char **argv)
 	if (!thp_is_enabled())
 		ksft_exit_skip("Transparent Hugepages not available\n");
 
-	parse_test_type(argc, argv);
-
-	setbuf(stdout, NULL);
-
 	page_size = getpagesize();
 	hpage_pmd_size = read_pmd_pagesize();
 	if (!hpage_pmd_size)
@@ -1250,6 +1341,10 @@ int main(int argc, char **argv)
 	hpage_pmd_nr = hpage_pmd_size / page_size;
 	hpage_pmd_order = __builtin_ctz(hpage_pmd_nr);
 
+	parse_test_type(argc, argv);
+
+	setbuf(stdout, NULL);
+
 	default_settings.khugepaged.max_ptes_none = hpage_pmd_nr - 1;
 	default_settings.khugepaged.max_ptes_swap = hpage_pmd_nr / 8;
 	default_settings.khugepaged.max_ptes_shared = hpage_pmd_nr / 2;
@@ -1267,6 +1362,7 @@ int main(int argc, char **argv)
 	TEST(collapse_full, khugepaged_context, read_write_file_read_ops);
 	TEST(collapse_full, khugepaged_context, read_write_file_write_ops);
 	TEST(collapse_full, khugepaged_context, shmem_ops);
+	TEST(collapse_full, mthp_khugepaged_context, anon_ops);
 	TEST(collapse_full, madvise_context, anon_ops);
 	TEST(collapse_full, madvise_context, read_only_file_ops);
 	TEST(collapse_full, madvise_context, read_write_file_read_ops);
@@ -1274,8 +1370,11 @@ int main(int argc, char **argv)
 	TEST(collapse_full, madvise_context, shmem_ops);
 
 	TEST(collapse_empty, khugepaged_context, anon_ops);
+	TEST(collapse_empty, mthp_khugepaged_context, anon_ops);
 	TEST(collapse_empty, madvise_context, anon_ops);
 
+	TEST(collapse_single_mthp, mthp_khugepaged_context, anon_ops);
+
 	TEST(collapse_single_pte_entry, khugepaged_context, anon_ops);
 	TEST(collapse_single_pte_entry, khugepaged_context, read_only_file_ops);
 	TEST(collapse_single_pte_entry, khugepaged_context, read_write_file_read_ops);
--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-add-mthp-collapse-test-cases
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -410,6 +410,8 @@ CATEGORY="thp" run_test ./khugepaged all
 
 CATEGORY="thp" run_test ./khugepaged -s 4 all:shmem
 
+CATEGORY="thp" run_test ./khugepaged -c 4 mthp_khugepaged:anon
+
 # Try to create XFS if not provided
 if [ -z "${SPLIT_HUGE_PAGE_TEST_XFS_PATH}" ]; then
     if test_selected "thp"; then
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-fix-incorrect-vm_flags-usage-when-checking-allowable-orders-for-tmpfs.patch

