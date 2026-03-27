Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E40293F99E9
	for <mm-commits@vger.kernel.org>; Fri, 27 Mar 2026 17:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774634365; cv=none; b=fhxdCCFTCiTWZBkVFckb3czGJPk33MnI3d8YIb867/q8ZiMxCq29PA4MTt+0CahCRm/kdRra6MyicJqBxzu39514yQBwb7MHY3AgBhVhmtXBWBlYtKt9bq9TMgts2G9XMuwNYKS5lOXyTgG7/N/3KBOvp5GrCrzD7m6nLyFlBt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774634365; c=relaxed/simple;
	bh=rYDihFJbfJu86t+Lg5ipYEfKpM5g936cD8mNe8oicBI=;
	h=Date:To:From:Subject:Message-Id; b=bqqqhYj8krQ5KcVt99syYMwEMiaZ+/fNXJ1RfNZTLYK0yBbEGXsV+Uea+rYVjHHhyP1XDNDJ5RS1F4f7xeo+cpKnFprbFNV7PCnC3GBsZdd8JaqSFBULZk5/vqMCERIqF0jt6laR9gJtEGnxjKEfpZvs1DA/W9Kn24QnLWUsWnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EuqB+y93; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EuqB+y93"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8271FC19423;
	Fri, 27 Mar 2026 17:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774634364;
	bh=rYDihFJbfJu86t+Lg5ipYEfKpM5g936cD8mNe8oicBI=;
	h=Date:To:From:Subject:From;
	b=EuqB+y93u2yAywuANVpTyaOVd+MzmeFvb2CYBha46f23CyQddcMFKsIJIow3LDjyl
	 IlnbDQ2Cyd745ZHFpZgI4j9Ee8KyvWB8gcqOiGdrIutdBGw5/+UiBQCTmCBh/oEcZ5
	 fPt1P7H9poVUaVIk6odiiRCHCA7OXayDD/VXKQgc=
Date: Fri, 27 Mar 2026 10:59:24 -0700
To: mm-commits@vger.kernel.org,sayalip@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] selftests-cgroup-extend-test_hugetlb_memcgc-to-support-all-huge-page-sizes.patch removed from -mm tree
Message-Id: <20260327175924.8271FC19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/cgroup: extend test_hugetlb_memcg.c to support all huge page sizes
has been removed from the -mm tree.  Its filename was
     selftests-cgroup-extend-test_hugetlb_memcgc-to-support-all-huge-page-sizes.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Sayali Patil <sayalip@linux.ibm.com>
Subject: selftests/cgroup: extend test_hugetlb_memcg.c to support all huge page sizes
Date: Thu, 12 Mar 2026 17:55:40 +0530

The hugetlb memcg selftest was previously skipped when the configured huge
page size was not 2MB, preventing the test from running on systems using
other default huge page sizes.

Detect the system's configured huge page size at runtime and use it for
the allocation instead of assuming a fixed 2MB size.  This allows the test
to run on configurations using non-2MB huge pages and avoids unnecessary
skips.

Link: https://lkml.kernel.org/r/e4e655c7d7c4e24b90d51530157d024854bff1cb.1773305678.git.sayalip@linux.ibm.com
Fixes: c0dddb7aa5f8 ("selftests: add a selftest to verify hugetlb usage in memcg")
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: "Michal Koutný" <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
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

a.patch

