Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832277;
	b=0Tg/FpmVP72GrIH9KK3bHXaiXt4TI3h5lK0I3hcXUGty3Fgm8lSLPwVqlsjZL9j25uwr
	 dMv5axc+fX54x3QWKfJUaXH+21+7wExOzzstOZuP5Hjv0OwSyx79PNeBIkqppfnn4F4fs
	 twPVLJ818jHTfHEg/u8jYztNLf6896EYVtLN0LNXSedA+gEJgcDx05MFRE2d10h3pCAi0
	 yZKCQllmdZ58072aJ77e/ntEBK6r99HOrf6OfVLw+fi7t1eiY77IyjsS/uPMMP8MA21+p
	 PIvKZPPrdPDIjUxAnPAx18JzvNiZGhTQTlG/6KFvpIsT/fGwwEi6oj6oFznPrr6nQWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832277;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=ZL7FiCSV8zG5v3Wvw7EzpjPO9rZ/M+xZgLLFokM1jpw=;
	b=dMCa2IBUtXTKaTgdmKXI5BYFptXStjwxBt/tdIs8XHKRB5HN9cCNnFGXWtGh1glhzEO0
	 k2csttdeG2Yu5jtaoYyGdskXHgk6604KGIwVuxBqTKKKTbNVf6brnlevFl/oBaW9d4Ufa
	 rxNu6TZWMe7B5hQpj6ilBtZvEe2MyDzbC7vwhr77INbD05hwJxFf+vstsg93STD3eFUyj
	 UAKpaABOKlFXt5RpoXPFdDRSVTp7XXHMvHU+HfmNR9ZJAGWSf7vQ1yCfozxCvw7sflBV5
	 ZObys85pa3boJwQ91yQJ6AhhnukjGwlQ6FczjZhvG80lpFE6Mvwae5EkXc2d0cq8z6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=DWz+szaF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE4B8606A31B
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 08:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=DWz+szaF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DE111F01825;
	Sat, 24 Oct 2026 08:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832276;
	bh=ZL7FiCSV8zG5v3Wvw7EzpjPO9rZ/M+xZgLLFokM1jpw=;
	h=Date:To:From:Subject;
	b=DWz+szaFFZIV1jWsYZUFYTCyX++hwoKL0aHKA8mIxJpXyVd71lHhAp9xF6EF4Bm9B
	 VQ1KlMTQrUgbSZqC2jwuWjVaSJeJEH+TQVv0nUHwEpqN882eP2LP4nrsqm3SRo6mVJ
	 IEn3CkjByubyfCDCjehwMcgmCFGmXij1/8bsgt0g=
Date: Sat, 24 Oct 2026 01:57:56 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,usama.arif@linux.dev,surenb@google.com,shuah@kernel.org,sarthak.sharma@arm.com,ryan.roberts@arm.com,rppt@kernel.org,nico.pache@linux.dev,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kevin.brodsky@arm.com,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,yeoreum.yun@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kselftest-mm-remove-check_huge_shmem.patch removed from -mm tree
Message-Id: <20261024085756.8DE111F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: kselftest: mm: remove check_huge_shmem()
has been removed from the -mm tree.  Its filename was
     kselftest-mm-remove-check_huge_shmem.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yeoreum Yun <yeoreum.yun@arm.com>
Subject: kselftest: mm: remove check_huge_shmem()
Date: Thu, 01 Oct 2026 22:17:54 +0100

check_huge_shmem() was required to distinguish shmem huge pages because
/proc/self/smaps reports them using a dedicated “ShmemPmdMapped” entry,
as opposed to “FilePmdMapped” for file-backed huge pages.

Now that /proc/self/smaps is no longer used to detect huge pages and
/proc/kpageflags is used instead, it is sufficient to distinguish
between file-backed and anonymous pages since the ShmemPmdMapped is also
kind of file-backed.

Therefore, remove check_huge_shmem() and use check_huge_file() instead
and cleanup khugepaged's check_huge operation in mem_ops.

Link: https://lore.kernel.org/20261001-fix_split-v9-4-0f4ba8bbdbdf@arm.com
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
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
@@ -486,11 +486,6 @@ bool check_huge_file(void *addr, size_t
 	return __check_type(addr, len, scan_mapping_size, CHECK_TYPE_FILE);
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


