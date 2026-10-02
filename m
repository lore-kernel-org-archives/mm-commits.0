Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1005823D28C
	for <mm-commits@vger.kernel.org>; Fri,  2 Oct 2026 00:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790901208; cv=none; b=bPNnvOu8jiO+8qu4Mb0TR4LuT8oZ9Gk7j+1phviLoIHwb8Na8QCyW79KsY0uIEasSVmXdpaDTA3K3Vrz6b7/TkI8qvxMDFGnB9DkEE5KC1qHxLcZdfTwpn/AKgaEYhlkXJ2rvgY2MKPXoACJfcWk5hroePi3x3+1G/q/R/IsLcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790901208; c=relaxed/simple;
	bh=TONI8XWtuJlCC/l0HiBVOOu14UFM14gUYy1j1tmZFRM=;
	h=Date:To:From:Subject:Message-Id; b=NkFt7FJ0AwF4MDjJcyLaN5iMLoz+sl9yFRswhbwZC4o90ZP6xjvE1xpxUUbAyVjl486RIZoWMS1yer7W4sc/5MytFs7Eedv0XOhK8cJ3yNM+ZiI2qmK5TNWo518mZAZcob0Q+5Bo5yoDyaDXBu6n0MZJT9KVOb9ruB3rFIbiV8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QhXUXc5k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QhXUXc5k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7E5A1F00893;
	Fri,  2 Oct 2026 00:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790901207;
	bh=U1Udt5EKUhloZSLitLFy6+eZmOD5PyLZZB0Q2Xah7f0=;
	h=Date:To:From:Subject;
	b=QhXUXc5k73IJMRX75L5fcfhH+ojV9xLwEwXY4KCLI9AJs9tbNo/3ol6CgKidObaZv
	 Vm2PYSebA0b3HrUnFee2F5Sw6qXgppxdHErNdstjcZe/W8ECawWHf995f18nCLMwrE
	 T9xSdw/bXLZSeeg0Fx/U0wrNBOFjTqcVp2+6+tVo=
Date: Thu, 01 Oct 2026 17:33:26 -0700
To: mm-commits@vger.kernel.org,yeoreum.yun@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] kselftest-mm-remove-check_huge_shmem.patch removed from -mm tree
Message-Id: <20261002003326.D7E5A1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kselftest: mm: remove check_huge_shmem()
has been removed from the -mm tree.  Its filename was
     kselftest-mm-remove-check_huge_shmem.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Yeoreum Yun <yeoreum.yun@arm.com>
Subject: kselftest: mm: remove check_huge_shmem()
Date: Thu, 24 Sep 2026 20:11:19 +0100

check_huge_shmem() was required to distinguish shmem huge pages because
/proc/self/smaps reports them using a dedicated “ShmemPmdMapped”
entry, as opposed to “FilePmdMapped” for file-backed huge pages.

Now that /proc/self/smaps is no longer used to detect huge pages and
/proc/kpageflags is used instead, it is sufficient to distinguish between
file-backed and anonymous pages since the ShmemPmdMapped is also kind of
file-backed.

Therefore, remove check_huge_shmem() and use check_huge_file() instead and
cleanup khugepaged's check_huge operation in mem_ops.

Link: https://lore.kernel.org/20260924-fix_split-v8-4-cba7359d882a@arm.com
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
---

 tools/testing/selftests/mm/folio_split_race_test.c |    2 
 tools/testing/selftests/mm/khugepaged.c            |   38 +----------
 tools/testing/selftests/mm/uffd-common.c           |    4 -
 tools/testing/selftests/mm/vm_util.c               |    5 -
 tools/testing/selftests/mm/vm_util.h               |    1 
 5 files changed, 9 insertions(+), 41 deletions(-)

--- a/tools/testing/selftests/mm/folio_split_race_test.c~kselftest-mm-remove-check_huge_shmem
+++ a/tools/testing/selftests/mm/folio_split_race_test.c
@@ -181,7 +181,7 @@ static uint64_t run_iteration(void)
 	for (i = 0; i < TOTAL_PAGES; i++)
 		fill_page(mmap_base, i);
 
-	if (!check_huge_shmem(mmap_base, FILE_SIZE, NR_PMD_PAGE, pmd_pagesize))
+	if (!check_huge_file(mmap_base, FILE_SIZE, NR_PMD_PAGE, pmd_pagesize))
 		ksft_exit_fail_msg("No shmem THP is allocated\n");
 
 	if (pthread_barrier_init(&ctl.barrier, NULL, NUM_READER_THREADS + 1) != 0)
--- a/tools/testing/selftests/mm/khugepaged.c~kselftest-mm-remove-check_huge_shmem
+++ a/tools/testing/selftests/mm/khugepaged.c
@@ -57,7 +57,7 @@ struct mem_ops {
 	void *(*setup_area)(int nr_hpages);
 	void (*cleanup_area)(void *p, unsigned long size);
 	void (*fault)(void *p, unsigned long start, unsigned long end);
-	bool (*check_huge)(void *addr, size_t len, int nr_hpages, unsigned long hpage_size);
+	bool (*check_huge)(void *addr, size_t len, int nr_hpages, uint64_t hpage_size);
 	const char *name;
 };
 
@@ -343,12 +343,6 @@ static void anon_fault(void *p, unsigned
 	fill_memory(p, start, end);
 }
 
-static bool anon_check_huge(void *addr, size_t len, int nr_hpages,
-		unsigned long hpage_size)
-{
-	return check_huge_anon(addr, len, nr_hpages, hpage_size);
-}
-
 static void *file_setup_area_common(int nr_hpages, enum file_setup_ops setup)
 {
 	const int open_opt = setup == FILE_SETUP_READ_ONLY_FS ? O_RDONLY : O_RDWR;
@@ -444,20 +438,6 @@ static void file_fault_write(void *p, un
 		ksft_exit_fail_perror("madvise(MADV_POPULATE_WRITE)");
 }
 
-static bool file_check_huge(void *addr, size_t len, int nr_hpages,
-		unsigned long hpage_size)
-{
-	switch (finfo.type) {
-	case VMA_FILE:
-		return check_huge_file(addr, len, nr_hpages, hpage_size);
-	case VMA_SHMEM:
-		return check_huge_shmem(addr, len, nr_hpages, hpage_size);
-	default:
-		ksft_exit_fail_msg("Unknown VMA type\n");
-		return false;
-	}
-}
-
 static void *shmem_setup_area(int nr_hpages)
 {
 	void *p;
@@ -481,17 +461,11 @@ static void shmem_cleanup_area(void *p,
 	close(finfo.fd);
 }
 
-static bool shmem_check_huge(void *addr, size_t len, int nr_hpages,
-		unsigned long hpage_size)
-{
-	return check_huge_shmem(addr, len, nr_hpages, hpage_size);
-}
-
 static struct mem_ops __anon_ops = {
 	.setup_area = &anon_setup_area,
 	.cleanup_area = &anon_cleanup_area,
 	.fault = &anon_fault,
-	.check_huge = &anon_check_huge,
+	.check_huge = &check_huge_anon,
 	.name = "anon",
 };
 
@@ -499,7 +473,7 @@ static struct mem_ops __read_only_file_o
 	.setup_area = &file_setup_read_only_area,
 	.cleanup_area = &file_cleanup_area,
 	.fault = &file_fault_read,
-	.check_huge = &file_check_huge,
+	.check_huge = &check_huge_file,
 	.name = "file",
 };
 
@@ -507,7 +481,7 @@ static struct mem_ops __read_write_file_
 	.setup_area = &file_setup_read_write_fs_read_area,
 	.cleanup_area = &file_cleanup_area,
 	.fault = &file_fault_read_and_flush,
-	.check_huge = &file_check_huge,
+	.check_huge = &check_huge_file,
 	.name = "file",
 };
 
@@ -515,7 +489,7 @@ static struct mem_ops __read_write_file_
 	.setup_area = &file_setup_read_write_fs_write_area,
 	.cleanup_area = &file_cleanup_area,
 	.fault = &file_fault_write,
-	.check_huge = &file_check_huge,
+	.check_huge = &check_huge_file,
 	.name = "file",
 };
 
@@ -523,7 +497,7 @@ static struct mem_ops __shmem_ops = {
 	.setup_area = &shmem_setup_area,
 	.cleanup_area = &shmem_cleanup_area,
 	.fault = &anon_fault,
-	.check_huge = &shmem_check_huge,
+	.check_huge = &check_huge_file,
 	.name = "shmem",
 };
 
--- a/tools/testing/selftests/mm/uffd-common.c~kselftest-mm-remove-check_huge_shmem
+++ a/tools/testing/selftests/mm/uffd-common.c
@@ -196,8 +196,8 @@ static void shmem_check_pmd_mapping(uffd
 {
 	size_t len = expect_nr_hpages * read_pmd_pagesize();
 
-	if (!check_huge_shmem(gopts->area_dst_alias, len, expect_nr_hpages,
-			      read_pmd_pagesize()))
+	if (!check_huge_file(gopts->area_dst_alias, len, expect_nr_hpages,
+			     read_pmd_pagesize()))
 		err("Did not find expected %d number of hugepages",
 		    expect_nr_hpages);
 }
--- a/tools/testing/selftests/mm/vm_util.c~kselftest-mm-remove-check_huge_shmem
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -470,11 +470,6 @@ bool check_huge_file(void *addr, size_t
 	return __check_huge(addr, len, nr_hpages, hpage_size, CHECK_HUGE_FILE);
 }
 
-bool check_huge_shmem(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
-{
-	return check_huge_file(addr, len, nr_hpages, hpage_size);
-}
-
 int64_t allocate_transhuge(void *ptr, int pagemap_fd)
 {
 	uint64_t ent[2];
--- a/tools/testing/selftests/mm/vm_util.h~kselftest-mm-remove-check_huge_shmem
+++ a/tools/testing/selftests/mm/vm_util.h
@@ -96,7 +96,6 @@ uint64_t read_pmd_pagesize(void);
 unsigned long rss_anon(void);
 bool check_huge_anon(void *addr, size_t len, int nr_hpages, uint64_t hpage_size);
 bool check_huge_file(void *addr, size_t len, int nr_hpages, uint64_t hpage_size);
-bool check_huge_shmem(void *addr, size_t len, int nr_hpages, uint64_t hpage_size);
 int64_t allocate_transhuge(void *ptr, int pagemap_fd);
 int pageflags_get(unsigned long pfn, int kpageflags_fd, uint64_t *flags);
 int gather_folio_orders(char *vaddr_start, size_t len,
_

Patches currently in -mm which might be from yeoreum.yun@arm.com are

kselftest-mm-fix-potential-failure-for-merged-vma-in-guard-regions.patch
kselftest-mm-remove-exclusion-of-building-soft-dirty-test-in-arm64.patch
kselftest-mm-return-fail-when-child-test-result-is-fail-in-khugepaged.patch
kselftest-mm-fix-intermittent-failure-khugepaged-test.patch

