Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3810139DBCA
	for <mm-commits@vger.kernel.org>; Tue, 10 Mar 2026 16:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773161006; cv=none; b=ULle4JO6Wl96C4Y9wwpRdL/YJ+09lWU6LCOTkP6WGTVKQg84dGjIhAzoAk5mYYuuDchPl/6R9r2mq4/MGkhqE/NQM1WNPgwb1O4jqOLAI95BWLZgwrMG/zi8Y9UmVbinWrgLxCvrrbOSBu6EJQsGs8zY2fnejMsj3m8OgHLgT74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773161006; c=relaxed/simple;
	bh=6vajycp2gxKdcVm0A18nqP9HqAOrr5UnglBqmdoh3X0=;
	h=Date:To:From:Subject:Message-Id; b=WM8ZvnleALY+Df+heC85QgNMqbOX236hmsKYLG/2ntxaSSvtl7zf5trHX581OS9AH0olXe61Tgl9ZfulUr/xqOX25dNxWMICFmUg97+ksawuht/pfpZrnjiJkqBJvdGT9frOKMs1tek1g+vgP6sxRyP8TwXWIPBD7rs0eW31SqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=19BQARE/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="19BQARE/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBDD6C19423;
	Tue, 10 Mar 2026 16:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773161005;
	bh=6vajycp2gxKdcVm0A18nqP9HqAOrr5UnglBqmdoh3X0=;
	h=Date:To:From:Subject:From;
	b=19BQARE/P56GMkOP+iEXQWhs9aI79RhtXf39dHNIIrV3V23UHGuNhy2Vbeoum4071
	 80Pa/9tLx+zytiQUZQ0SqWB+rN6Uxutoymw5jY6aODFvQZXWf0TwDH1fey6N6LWv/f
	 r6M6EmZ6jkVy479/H10KuCGVJ0cV4r0lhbLV0+ZI=
Date: Tue, 10 Mar 2026 09:43:25 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,usama.anjum@collabora.com,tj@kernel.org,shuah@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,ritesh.list@gmail.com,osalvador@suse.de,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,hannes@cmpxchg.org,dev.jain@arm.com,david@kernel.org,sayalip@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-cgroup-extend-test_hugetlb_memcgc-to-support-all-huge-page-sizes.patch added to mm-new branch
Message-Id: <20260310164325.DBDD6C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/cgroup: extend test_hugetlb_memcg.c to support all huge page sizes
has been added to the -mm mm-new branch.  Its filename is
     selftests-cgroup-extend-test_hugetlb_memcgc-to-support-all-huge-page-sizes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-cgroup-extend-test_hugetlb_memcgc-to-support-all-huge-page-sizes.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Sayali Patil <sayalip@linux.ibm.com>
Subject: selftests/cgroup: extend test_hugetlb_memcg.c to support all huge page sizes
Date: Tue, 10 Mar 2026 15:19:31 +0530

The hugetlb memcg selftest was previously skipped when the configured huge
page size was not 2MB, preventing the test from running on systems using
other default huge page sizes.

Detect the system's configured huge page size at runtime and use it for
the allocation instead of assuming a fixed 2MB size.  This allows the test
to run on configurations using non-2MB huge pages and avoids unnecessary
skips.

Link: https://lkml.kernel.org/r/97f1fc6020b1d63d1d73de6edd1525d91e4f7123.1773134177.git.sayalip@linux.ibm.com
Fixes: c0dddb7aa5f8 ("selftests: add a selftest to verify hugetlb usage in memcg")
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: "Michal Koutný" <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cgroup/test_hugetlb_memcg.c |   66 +++++++---
 1 file changed, 48 insertions(+), 18 deletions(-)

--- a/tools/testing/selftests/cgroup/test_hugetlb_memcg.c~selftests-cgroup-extend-test_hugetlb_memcgc-to-support-all-huge-page-sizes
+++ a/tools/testing/selftests/cgroup/test_hugetlb_memcg.c
@@ -12,10 +12,15 @@
 
 #define ADDR ((void *)(0x0UL))
 #define FLAGS (MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB)
-/* mapping 8 MBs == 4 hugepages */
-#define LENGTH (8UL*1024*1024)
 #define PROTECTION (PROT_READ | PROT_WRITE)
 
+/*
+ * This value matches the kernel's MEMCG_CHARGE_BATCH definition:
+ * see include/linux/memcontrol.h. If the kernel value changes, this
+ * test constant must be updated accordingly to stay consistent.
+ */
+#define MEMCG_CHARGE_BATCH 64U
+
 /* borrowed from mm/hmm-tests.c */
 static long get_hugepage_size(void)
 {
@@ -84,11 +89,11 @@ static unsigned int check_first(char *ad
 	return *(unsigned int *)addr;
 }
 
-static void write_data(char *addr)
+static void write_data(char *addr, size_t length)
 {
 	unsigned long i;
 
-	for (i = 0; i < LENGTH; i++)
+	for (i = 0; i < length; i++)
 		*(addr + i) = (char)i;
 }
 
@@ -96,26 +101,31 @@ static int hugetlb_test_program(const ch
 {
 	char *test_group = (char *)arg;
 	void *addr;
+	long hpage_size = get_hugepage_size() * 1024;
 	long old_current, expected_current, current;
 	int ret = EXIT_FAILURE;
+	size_t length = 4 * hpage_size;
+	int pagesize, nr_pages;
+
+	pagesize = getpagesize();
 
 	old_current = cg_read_long(test_group, "memory.current");
 	set_nr_hugepages(20);
 	current = cg_read_long(test_group, "memory.current");
-	if (current - old_current >= MB(2)) {
+	if (current - old_current >= hpage_size) {
 		ksft_print_msg(
 			"setting nr_hugepages should not increase hugepage usage.\n");
 		ksft_print_msg("before: %ld, after: %ld\n", old_current, current);
 		return EXIT_FAILURE;
 	}
 
-	addr = mmap(ADDR, LENGTH, PROTECTION, FLAGS, 0, 0);
+	addr = mmap(ADDR, length, PROTECTION, FLAGS, 0, 0);
 	if (addr == MAP_FAILED) {
 		ksft_print_msg("fail to mmap.\n");
 		return EXIT_FAILURE;
 	}
 	current = cg_read_long(test_group, "memory.current");
-	if (current - old_current >= MB(2)) {
+	if (current - old_current >= hpage_size) {
 		ksft_print_msg("mmap should not increase hugepage usage.\n");
 		ksft_print_msg("before: %ld, after: %ld\n", old_current, current);
 		goto out_failed_munmap;
@@ -124,10 +134,24 @@ static int hugetlb_test_program(const ch
 
 	/* read the first page */
 	check_first(addr);
-	expected_current = old_current + MB(2);
+	nr_pages = hpage_size / pagesize;
+	expected_current = old_current + hpage_size;
 	current = cg_read_long(test_group, "memory.current");
-	if (!values_close(expected_current, current, 5)) {
-		ksft_print_msg("memory usage should increase by around 2MB.\n");
+	if (nr_pages < MEMCG_CHARGE_BATCH && current == old_current) {
+		/*
+		 * Memory cgroup charging uses per-CPU stocks and batched updates to the
+		 *  memcg usage counters. For hugetlb allocations, the number of pages
+		 *  that memcg charges is expressed in base pages (nr_pages), not
+		 *  in hugepage units. When the charge for an allocation is smaller than
+		 *  the internal batching threshold  (nr_pages <  MEMCG_CHARGE_BATCH),
+		 *  it may be fully satisfied from the CPU’s local stock. In such
+		 *  cases memory.current does not necessarily
+		 *  increase.
+		 *  Therefore, Treat a zero delta as valid behaviour here.
+		 */
+		ksft_print_msg("no visible memcg charge, allocation consumed from local stock.\n");
+	} else if (!values_close(expected_current, current, 5)) {
+		ksft_print_msg("memory usage should increase by ~1 huge page.\n");
 		ksft_print_msg(
 			"expected memory: %ld, actual memory: %ld\n",
 			expected_current, current);
@@ -135,11 +159,11 @@ static int hugetlb_test_program(const ch
 	}
 
 	/* write to the whole range */
-	write_data(addr);
+	write_data(addr, length);
 	current = cg_read_long(test_group, "memory.current");
-	expected_current = old_current + MB(8);
+	expected_current = old_current + length;
 	if (!values_close(expected_current, current, 5)) {
-		ksft_print_msg("memory usage should increase by around 8MB.\n");
+		ksft_print_msg("memory usage should increase by around 4 huge pages.\n");
 		ksft_print_msg(
 			"expected memory: %ld, actual memory: %ld\n",
 			expected_current, current);
@@ -147,7 +171,7 @@ static int hugetlb_test_program(const ch
 	}
 
 	/* unmap the whole range */
-	munmap(addr, LENGTH);
+	munmap(addr, length);
 	current = cg_read_long(test_group, "memory.current");
 	expected_current = old_current;
 	if (!values_close(expected_current, current, 5)) {
@@ -162,13 +186,15 @@ static int hugetlb_test_program(const ch
 	return ret;
 
 out_failed_munmap:
-	munmap(addr, LENGTH);
+	munmap(addr, length);
 	return ret;
 }
 
 static int test_hugetlb_memcg(char *root)
 {
 	int ret = KSFT_FAIL;
+	int num_pages = 20;
+	long hpage_size = get_hugepage_size();
 	char *test_group;
 
 	test_group = cg_name(root, "hugetlb_memcg_test");
@@ -177,7 +203,7 @@ static int test_hugetlb_memcg(char *root
 		goto out;
 	}
 
-	if (cg_write(test_group, "memory.max", "100M")) {
+	if (cg_write_numeric(test_group, "memory.max", num_pages * hpage_size * 1024)) {
 		ksft_print_msg("fail to set cgroup memory limit.\n");
 		goto out;
 	}
@@ -200,6 +226,7 @@ int main(int argc, char **argv)
 {
 	char root[PATH_MAX];
 	int ret = EXIT_SUCCESS, has_memory_hugetlb_acc;
+	long val;
 
 	has_memory_hugetlb_acc = proc_mount_contains("memory_hugetlb_accounting");
 	if (has_memory_hugetlb_acc < 0)
@@ -208,12 +235,15 @@ int main(int argc, char **argv)
 		ksft_exit_skip("memory hugetlb accounting is disabled\n");
 
 	/* Unit is kB! */
-	if (get_hugepage_size() != 2048) {
-		ksft_print_msg("test_hugetlb_memcg requires 2MB hugepages\n");
+	val = get_hugepage_size();
+	if (val < 0) {
+		ksft_print_msg("Failed to read hugepage size\n");
 		ksft_test_result_skip("test_hugetlb_memcg\n");
 		return ret;
 	}
 
+	ksft_print_msg("Hugepage size: %ld kB\n", val);
+
 	if (cg_find_unified_root(root, sizeof(root), NULL))
 		ksft_exit_skip("cgroup v2 isn't mounted\n");
 
_

Patches currently in -mm which might be from sayalip@linux.ibm.com are

selftests-mm-restore-default-nr_hugepages-value-during-cleanup-in-charge_reserved_hugetlbsh.patch
selftests-mm-fix-hugetlb-pathname-construction-in-charge_reserved_hugetlbsh.patch
selftests-mm-fix-hugetlb-pathname-construction-in-hugetlb_reparenting_testsh.patch
selftest-mm-fix-cgroup-task-placement-and-tolerance-in-hugetlb_reparenting_testsh.patch
selftests-mm-size-tmpfs-according-to-pmd-page-size-in-split_huge_page_test.patch
selftest-mm-adjust-hugepage-mremap-test-size-for-large-huge-pages.patch
selftest-mm-register-existing-mapping-with-userfaultfd-in-hugepage-mremap.patch
selftests-mm-ensure-destination-is-hugetlb-backed-in-hugepage-mremap.patch
selftests-mm-skip-uffd-wp-mremap-if-uffd-write-protect-is-unsupported.patch
selftests-mm-skip-uffd-stress-test-when-nr_pages_per_cpu-is-zero.patch
selftests-mm-fix-double-increment-in-linked-list-cleanup-in-compaction_test.patch
selftests-mm-move-hwpoison-setup-into-run_test-and-silence-modprobe-output-for-memory-failure-category.patch
selftests-cgroup-extend-test_hugetlb_memcgc-to-support-all-huge-page-sizes.patch

