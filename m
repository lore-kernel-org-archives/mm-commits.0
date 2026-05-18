Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1325A37CD4F
	for <mm-commits@vger.kernel.org>; Mon, 18 May 2026 21:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779141586; cv=none; b=jZ8FbLMon+v7F4vTz9/B1Wpds7sySEE37+Miu3/pVYkWp1z4uPTgK6xefJRBhSqg5pYvFuZPa8rLFyFJWdqxh2n5VNbWS8nQloWIiIoCunkOHz3yEp757UjuND94gGvzqVv8XEQon7OhSEYNt7v8Or6R/LxRJXOfRcGYJmmQikU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779141586; c=relaxed/simple;
	bh=xB+w6HAkYcIdtEakNkXGssHCLB/YsCM370X5EIJsl5A=;
	h=Date:To:From:Subject:Message-Id; b=Kyi3zCrQfPPVPXaYO0ZoMJioKqdxDNrsSC3A9HJQA1SoW47+qlicpqVU9xAYn5EJuDLoGJvMBSQhYDrozwUN7wnf22sbRc06ztxSe3f3rKuhsqwXa6rzIbmXy2eEyJF8qzJ2Zp66dNdh6FTtbVjndHbgp8CRLZPoZYPfeVqkQuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EUqvb+6t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EUqvb+6t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D46FDC2BCB7;
	Mon, 18 May 2026 21:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779141585;
	bh=xB+w6HAkYcIdtEakNkXGssHCLB/YsCM370X5EIJsl5A=;
	h=Date:To:From:Subject:From;
	b=EUqvb+6tLB3yRL8V8m8UrfmI9HmIbT2XKkU1XTeO7kaOdOGeqmtYzRB6MxwZpoAvt
	 reMR9U2LC+agmOThAZOIvTdSS6HzB6T4G/BNNAeci07FaYQ2ATtQVJtuWhedu6shIU
	 pQt6NO8zZp9xGeiJgnRC6GUCDCsxh2njyZTVKJE4=
Date: Mon, 18 May 2026 14:59:45 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] selftests-mm-add-writable-file-collapse-tests-for-khugepaged.patch removed from -mm tree
Message-Id: <20260518215945.D46FDC2BCB7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: add writable-file collapse tests for khugepaged
has been removed from the -mm tree.  Its filename was
     selftests-mm-add-writable-file-collapse-tests-for-khugepaged.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: selftests/mm: add writable-file collapse tests for khugepaged
Date: Wed, 29 Apr 2026 11:35:37 -0400

collapse_file() now supports collapsing clean pagecache folios from
writable files, so add corresponding tests.

Note that madvise(MADV_COLLAPSE) works for dirty pagecache folios from
writable files, because collapse_single_pmd() triggers a synchronous
writeback when first attempt of collapse_file() fails.  That writeback
makes dirty folios clean and the retry of collapse_file() succeeds.

Link: https://lore.kernel.org/20260429153538.727855-10-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Mason <clm@fb.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: David Sterba <dsterba@suse.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/khugepaged.c |  113 ++++++++++++++++------
 1 file changed, 86 insertions(+), 27 deletions(-)

--- a/tools/testing/selftests/mm/khugepaged.c~selftests-mm-add-writable-file-collapse-tests-for-khugepaged
+++ a/tools/testing/selftests/mm/khugepaged.c
@@ -41,6 +41,12 @@ enum vma_type {
 	VMA_SHMEM,
 };
 
+enum file_setup_ops {
+	FILE_SETUP_READ_ONLY_FS,
+	FILE_SETUP_READ_WRITE_FS_READ_DATA,
+	FILE_SETUP_READ_WRITE_FS_WRITE_DATA,
+};
+
 struct mem_ops {
 	void *(*setup_area)(int nr_hpages);
 	void (*cleanup_area)(void *p, unsigned long size);
@@ -50,7 +56,8 @@ struct mem_ops {
 };
 
 static struct mem_ops *read_only_file_ops;
-static struct mem_ops *read_write_file_ops;
+static struct mem_ops *read_write_file_read_ops;
+static struct mem_ops *read_write_file_write_ops;
 static struct mem_ops *anon_ops;
 static struct mem_ops *shmem_ops;
 
@@ -113,7 +120,8 @@ static void restore_settings(int sig)
 static void save_settings(void)
 {
 	printf("Save THP and khugepaged settings...");
-	if ((read_only_file_ops || read_write_file_ops) &&
+	if ((read_only_file_ops || read_write_file_read_ops ||
+	     read_write_file_write_ops) &&
 	    finfo.type == VMA_FILE)
 		thp_set_read_ahead_path(finfo.dev_queue_read_ahead_path);
 	thp_save_settings();
@@ -366,14 +374,14 @@ static bool anon_check_huge(void *addr,
 	return check_huge_anon(addr, nr_hpages, hpage_pmd_size);
 }
 
-static void *file_setup_area_common(int nr_hpages, bool read_only)
+static void *file_setup_area_common(int nr_hpages, enum file_setup_ops setup)
 {
 	int fd;
 	void *p;
 	unsigned long size;
-	int open_opt = read_only ? O_RDONLY : O_RDWR;
-	int mmap_prot = read_only ? PROT_READ : (PROT_READ | PROT_WRITE);
-	int mmap_opt = read_only ? MAP_PRIVATE : MAP_SHARED;
+	int open_opt = setup == FILE_SETUP_READ_ONLY_FS ? O_RDONLY : O_RDWR;
+	int mmap_prot = setup == FILE_SETUP_READ_ONLY_FS ? PROT_READ : (PROT_READ | PROT_WRITE);
+	int mmap_opt = setup == FILE_SETUP_READ_ONLY_FS ? MAP_PRIVATE : MAP_SHARED;
 
 	unlink(finfo.path);  /* Cleanup from previous failed tests */
 	printf("Creating %s for collapse%s...", finfo.path,
@@ -406,7 +414,10 @@ static void *file_setup_area_common(int
 	success("OK");
 
 	printf("Opening %s %s for collapse...", finfo.path,
-	       read_only ? "read only" : "read-write");
+	       setup == FILE_SETUP_READ_ONLY_FS ? "read only" :
+	       setup == FILE_SETUP_READ_WRITE_FS_READ_DATA ?
+						  "read-write (read)" :
+						  "read-write (write)");
 	finfo.fd = open(finfo.path, open_opt, 777);
 	if (finfo.fd < 0) {
 		perror("open()");
@@ -427,12 +438,17 @@ static void *file_setup_area_common(int
 
 static void *file_setup_read_only_area(int nr_hpages)
 {
-	return file_setup_area_common(nr_hpages, /* read_only= */ true);
+	return file_setup_area_common(nr_hpages, FILE_SETUP_READ_ONLY_FS);
+}
+
+static void *file_setup_read_write_fs_read_area(int nr_hpages)
+{
+	return file_setup_area_common(nr_hpages, FILE_SETUP_READ_WRITE_FS_READ_DATA);
 }
 
-static void *file_setup_read_write_area(int nr_hpages)
+static void *file_setup_read_write_fs_write_area(int nr_hpages)
 {
-	return file_setup_area_common(nr_hpages, /* read_only= */ false);
+	return file_setup_area_common(nr_hpages, FILE_SETUP_READ_WRITE_FS_WRITE_DATA);
 }
 
 static void file_cleanup_area(void *p, unsigned long size)
@@ -459,6 +475,17 @@ static void file_fault_read(void *p, uns
 	file_fault_common(p, start, end, MADV_POPULATE_READ);
 }
 
+static void file_fault_read_and_flush(void *p, unsigned long start, unsigned long end)
+{
+	file_fault_common(p, start, end, MADV_POPULATE_READ);
+
+	/*
+	 * make folio clean, since dirty folios from read&write file are
+	 * rejected and not flushed
+	 */
+	msync((char *)p + start, end - start, MS_SYNC);
+}
+
 static void file_fault_write(void *p, unsigned long start, unsigned long end)
 {
 	file_fault_common(p, start, end, MADV_POPULATE_WRITE);
@@ -527,8 +554,16 @@ static struct mem_ops __read_only_file_o
 	.name = "file",
 };
 
-static struct mem_ops __read_write_file_ops = {
-	.setup_area = &file_setup_read_write_area,
+static struct mem_ops __read_write_file_read_ops = {
+	.setup_area = &file_setup_read_write_fs_read_area,
+	.cleanup_area = &file_cleanup_area,
+	.fault = &file_fault_read_and_flush,
+	.check_huge = &file_check_huge,
+	.name = "file",
+};
+
+static struct mem_ops __read_write_file_write_ops = {
+	.setup_area = &file_setup_read_write_fs_write_area,
 	.cleanup_area = &file_cleanup_area,
 	.fault = &file_fault_write,
 	.check_huge = &file_check_huge,
@@ -546,7 +581,8 @@ static struct mem_ops __shmem_ops = {
 static bool is_tmpfs(struct mem_ops *ops)
 {
 	return (ops == &__read_only_file_ops ||
-		ops == &__read_write_file_ops) &&
+		ops == &__read_write_file_read_ops ||
+		ops == &__read_write_file_write_ops) &&
 	       finfo.type == VMA_SHMEM;
 }
 
@@ -563,9 +599,11 @@ static void __madvise_collapse(const cha
 
 	printf("%s...", msg);
 
-	/* read&write file collapse always fail */
-	if (!is_tmpfs(ops) && ops == &__read_write_file_ops)
-		expect = false;
+	/*
+	 * read&write file collapse succeeds for MADV_COLLAPSE because dirty
+	 * folios are written back after collapse fails for dirty folios and
+	 * another collapse is attempted.
+	 */
 
 	/*
 	 * Prevent khugepaged interference and tests that MADV_COLLAPSE
@@ -633,8 +671,11 @@ static bool wait_for_scan(const char *ms
 static void khugepaged_collapse(const char *msg, char *p, int nr_hpages,
 				struct mem_ops *ops, bool expect)
 {
-	/* read&write file collapse always fail */
-	if (!is_tmpfs(ops) && ops == &__read_write_file_ops)
+	/*
+	 * read&write file collapse fails since khugepaged does not flush
+	 * the target dirty folios
+	 */
+	if (!is_tmpfs(ops) && ops == &__read_write_file_write_ops)
 		expect = false;
 
 	if (wait_for_scan(msg, p, nr_hpages, ops)) {
@@ -757,6 +798,9 @@ static void collapse_max_ptes_none(struc
 	validate_memory(p, 0, (hpage_pmd_nr - max_ptes_none - fault_nr_pages) * page_size);
 
 	if (c->enforce_pte_scan_limits) {
+		ops->cleanup_area(p, hpage_pmd_size);
+		p = ops->setup_area(1);
+
 		ops->fault(p, 0, (hpage_pmd_nr - max_ptes_none) * page_size);
 		c->collapse("Collapse with max_ptes_none PTEs empty", p, 1, ops,
 			    true);
@@ -1204,21 +1248,24 @@ static void parse_test_type(int argc, ch
 
 	if (!strcmp(buf, "all")) {
 		read_only_file_ops =  &__read_only_file_ops;
-		read_write_file_ops =  &__read_write_file_ops;
+		read_write_file_read_ops =  &__read_write_file_read_ops;
+		read_write_file_write_ops =  &__read_write_file_write_ops;
 		anon_ops = &__anon_ops;
 		shmem_ops = &__shmem_ops;
 	} else if (!strcmp(buf, "anon")) {
 		anon_ops = &__anon_ops;
 	} else if (!strcmp(buf, "file")) {
 		read_only_file_ops =  &__read_only_file_ops;
-		read_write_file_ops =  &__read_write_file_ops;
+		read_write_file_read_ops =  &__read_write_file_read_ops;
+		read_write_file_write_ops =  &__read_write_file_write_ops;
 	} else if (!strcmp(buf, "shmem")) {
 		shmem_ops = &__shmem_ops;
 	} else {
 		usage();
 	}
 
-	if (!read_only_file_ops && !read_write_file_ops)
+	if (!read_only_file_ops && !read_write_file_read_ops &&
+	    !read_write_file_write_ops)
 		return;
 
 	if (argc != 2)
@@ -1291,11 +1338,13 @@ int main(int argc, char **argv)
 
 	TEST(collapse_full, khugepaged_context, anon_ops);
 	TEST(collapse_full, khugepaged_context, read_only_file_ops);
-	TEST(collapse_full, khugepaged_context, read_write_file_ops);
+	TEST(collapse_full, khugepaged_context, read_write_file_read_ops);
+	TEST(collapse_full, khugepaged_context, read_write_file_write_ops);
 	TEST(collapse_full, khugepaged_context, shmem_ops);
 	TEST(collapse_full, madvise_context, anon_ops);
 	TEST(collapse_full, madvise_context, read_only_file_ops);
-	TEST(collapse_full, madvise_context, read_write_file_ops);
+	TEST(collapse_full, madvise_context, read_write_file_read_ops);
+	TEST(collapse_full, madvise_context, read_write_file_write_ops);
 	TEST(collapse_full, madvise_context, shmem_ops);
 
 	TEST(collapse_empty, khugepaged_context, anon_ops);
@@ -1303,30 +1352,38 @@ int main(int argc, char **argv)
 
 	TEST(collapse_single_pte_entry, khugepaged_context, anon_ops);
 	TEST(collapse_single_pte_entry, khugepaged_context, read_only_file_ops);
-	TEST(collapse_single_pte_entry, khugepaged_context, read_write_file_ops);
+	TEST(collapse_single_pte_entry, khugepaged_context, read_write_file_read_ops);
+	TEST(collapse_single_pte_entry, khugepaged_context, read_write_file_write_ops);
 	TEST(collapse_single_pte_entry, khugepaged_context, shmem_ops);
 	TEST(collapse_single_pte_entry, madvise_context, anon_ops);
 	TEST(collapse_single_pte_entry, madvise_context, read_only_file_ops);
-	TEST(collapse_single_pte_entry, madvise_context, read_write_file_ops);
+	TEST(collapse_single_pte_entry, madvise_context, read_write_file_read_ops);
+	TEST(collapse_single_pte_entry, madvise_context, read_write_file_write_ops);
 	TEST(collapse_single_pte_entry, madvise_context, shmem_ops);
 
 	TEST(collapse_max_ptes_none, khugepaged_context, anon_ops);
 	TEST(collapse_max_ptes_none, khugepaged_context, read_only_file_ops);
-	TEST(collapse_max_ptes_none, khugepaged_context, read_write_file_ops);
+	TEST(collapse_max_ptes_none, khugepaged_context, read_write_file_read_ops);
+	TEST(collapse_max_ptes_none, khugepaged_context, read_write_file_write_ops);
 	TEST(collapse_max_ptes_none, madvise_context, anon_ops);
 	TEST(collapse_max_ptes_none, madvise_context, read_only_file_ops);
-	TEST(collapse_max_ptes_none, madvise_context, read_write_file_ops);
+	TEST(collapse_max_ptes_none, madvise_context, read_write_file_read_ops);
+	TEST(collapse_max_ptes_none, madvise_context, read_write_file_write_ops);
 
 	TEST(collapse_single_pte_entry_compound, khugepaged_context, anon_ops);
 	TEST(collapse_single_pte_entry_compound, khugepaged_context, read_only_file_ops);
+	TEST(collapse_single_pte_entry_compound, khugepaged_context, read_write_file_read_ops);
 	TEST(collapse_single_pte_entry_compound, madvise_context, anon_ops);
 	TEST(collapse_single_pte_entry_compound, madvise_context, read_only_file_ops);
+	TEST(collapse_single_pte_entry_compound, madvise_context, read_write_file_read_ops);
 
 	TEST(collapse_full_of_compound, khugepaged_context, anon_ops);
 	TEST(collapse_full_of_compound, khugepaged_context, read_only_file_ops);
+	TEST(collapse_full_of_compound, khugepaged_context, read_write_file_read_ops);
 	TEST(collapse_full_of_compound, khugepaged_context, shmem_ops);
 	TEST(collapse_full_of_compound, madvise_context, anon_ops);
 	TEST(collapse_full_of_compound, madvise_context, read_only_file_ops);
+	TEST(collapse_full_of_compound, madvise_context, read_write_file_read_ops);
 	TEST(collapse_full_of_compound, madvise_context, shmem_ops);
 
 	TEST(collapse_compound_extreme, khugepaged_context, anon_ops);
@@ -1349,9 +1406,11 @@ int main(int argc, char **argv)
 
 	TEST(madvise_collapse_existing_thps, madvise_context, anon_ops);
 	TEST(madvise_collapse_existing_thps, madvise_context, read_only_file_ops);
+	TEST(madvise_collapse_existing_thps, madvise_context, read_write_file_read_ops);
 	TEST(madvise_collapse_existing_thps, madvise_context, shmem_ops);
 
 	TEST(madvise_retracted_page_tables, madvise_context, read_only_file_ops);
+	TEST(madvise_retracted_page_tables, madvise_context, read_write_file_read_ops);
 	TEST(madvise_retracted_page_tables, madvise_context, shmem_ops);
 
 	restore_settings(0);
_

Patches currently in -mm which might be from ziy@nvidia.com are


