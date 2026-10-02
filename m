Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06B381C75F9
	for <mm-commits@vger.kernel.org>; Fri,  2 Oct 2026 00:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790901467; cv=none; b=OcXUwshzydHgfrhPmo6hQ7vd3u9kb15HxQGRE0ZdOqS4rg8ozmFvov7vw0AnoxCBupL0A9t9u9w2rpSkttskocL/r0fCg5+wD2ywtJwW+J5LxbiWXu13MZRq1A19Ry89C2+9I1pEtiMZUE+8lq8eo49TNvn7HaxaS553tZ64ZlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790901467; c=relaxed/simple;
	bh=Y65U8n2td2YkCL8MtMRUfKC4LXhyj29ZrXei9SRB+qQ=;
	h=Date:To:From:Subject:Message-Id; b=oN2rDOXiUogH1fZmMjbevplVH5QcWoX+ToPRKvfvK5bRAqfGABF6PWj1S4svgDV50OwqannDZcX+o2RKZ24mOpx8NeeC7gesPDIEvjdAMxR+boirTQB8BkL3MKb0mU7MjIVMayCI07TD+M7BmEZvnmbGdCA3Hf5DxiLO/4JmoBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=K2zWz89e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="K2zWz89e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F8A71F000FF;
	Fri,  2 Oct 2026 00:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790901465;
	bh=NScWVmfLR6E1YdIZkDyWoj9D0GLpLGgiZ6vhPbpCNl4=;
	h=Date:To:From:Subject;
	b=K2zWz89eap3qQoCFp/+V9qsyo6TjKTOMHTqlTIPHmMN8TwqglS59UQZXNzpF2C29L
	 CFPky+CAv8xAfEAZCN3Je7H14qPZjF3qmwmbRlriKt7YxZEJWS6cNhx+P+i3HAqsl2
	 pWYcYDFjvbWy6xWCNqS9UIbqhV7142nIEmcqnSSw=
Date: Thu, 01 Oct 2026 17:37:44 -0700
To: mm-commits@vger.kernel.org,yeoreum.yun@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kselftest-mm-remove-check_huge_shmem.patch added to mm-unstable branch
Message-Id: <20261002003745.5F8A71F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kselftest: mm: remove check_huge_shmem()
has been added to the -mm mm-unstable branch.  Its filename is
     kselftest-mm-remove-check_huge_shmem.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kselftest-mm-remove-check_huge_shmem.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

kselftest-mm-fix-potential-failure-for-merged-vma-in-guard-regions.patch
kselftest-mm-remove-exclusion-of-building-soft-dirty-test-in-arm64.patch
kselftest-mm-return-fail-when-child-test-result-is-fail-in-khugepaged.patch
kselftest-mm-fix-intermittent-failure-khugepaged-test.patch
kselftest-mm-prevent-random-failure-of-huge-page-split-for-khugepaged.patch
kselftest-mm-replace-usage-of-proc-self-smaps-for-__check_pmd_huge.patch
kselftest-mm-integrate-huge-page-checks.patch
kselftest-mm-remove-check_huge_shmem.patch

