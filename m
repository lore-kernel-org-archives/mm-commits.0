Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 396E9399D0B
	for <mm-commits@vger.kernel.org>; Mon, 18 May 2026 22:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779142938; cv=none; b=Si43TCxjZ8H2MGZcu6CR6NH7od+CQjhDTQ2Hr9cGIDg2IUhvDvRRpcH8lffdJ/7DDyiPcVfH9pIZ2ngS6zDlp6n9wdSM3sOvWmD4lpCstGCoY/yEAtUwCTkJnoy51sMl1uJcZ7vu6GLMefJuEt+mpXGvhlxREB1/0pVORXhfS3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779142938; c=relaxed/simple;
	bh=N5TwGV9rw/BdctdtShZ7Ht2emjVs06j7Uh5afO9ZwWE=;
	h=Date:To:From:Subject:Message-Id; b=ok9tlMcEby+uh4TkwtPR2S6vqjx8ljbJhegJmz1d9/WpAEkyzuUMliRiDxOoQcaF1j6xXPFleIGQEwort4eraTLeLWvRMTmWfUipfLQK2i2TFsYUZK3HeGyUHJRf636e0QXi4LWzEowj1kzjyTMDwTT9IqFuWdwro4SiYH3YjqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WH8+6c72; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WH8+6c72"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04C98C2BCB7;
	Mon, 18 May 2026 22:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779142938;
	bh=N5TwGV9rw/BdctdtShZ7Ht2emjVs06j7Uh5afO9ZwWE=;
	h=Date:To:From:Subject:From;
	b=WH8+6c72rxxcHGmW5tsWERoKoibRWM4SOAPx3KH+wEcNNj8JHoJIHKg3EANf7rB8d
	 R2R3hG75bAIatQ07Jigsk9wX/jhfqIuh1sprjUDyfsjLTVx8ncMhuGBInpdMrO6sls
	 ENSuKWCzSGdsK6a2z7Hqaumbp3GReddt2s63up3g=
Date: Mon, 18 May 2026 15:22:17 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-add-writable-file-collapse-tests-for-khugepaged.patch added to mm-unstable branch
Message-Id: <20260518222218.04C98C2BCB7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: add writable-file collapse tests for khugepaged
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-add-writable-file-collapse-tests-for-khugepaged.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-add-writable-file-collapse-tests-for-khugepaged.patch

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
From: Zi Yan <ziy@nvidia.com>
Subject: selftests/mm: add writable-file collapse tests for khugepaged
Date: Sun, 17 May 2026 09:54:16 -0400

collapse_file() now supports collapsing clean pagecache folios from
writable files, so add corresponding tests.

Note that madvise(MADV_COLLAPSE) works for dirty pagecache folios from
writable files, because collapse_single_pmd() triggers a synchronous
writeback when first attempt of collapse_file() fails.  That writeback
makes dirty folios clean and the retry of collapse_file() succeeds.

Link: https://lore.kernel.org/20260517135416.1434539-15-ziy@nvidia.com
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

 tools/testing/selftests/mm/khugepaged.c |  111 ++++++++++++++++------
 1 file changed, 85 insertions(+), 26 deletions(-)

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
@@ -366,10 +374,10 @@ static bool anon_check_huge(void *addr,
 	return check_huge_anon(addr, nr_hpages, hpage_pmd_size);
 }
 
-static void *file_setup_area_common(int nr_hpages, bool read_only)
+static void *file_setup_area_common(int nr_hpages, enum file_setup_ops setup)
 {
-	const int open_opt = read_only ? O_RDONLY : O_RDWR;
-	const int mmap_prot = read_only ? PROT_READ : (PROT_READ | PROT_WRITE);
+	const int open_opt = setup == FILE_SETUP_READ_ONLY_FS ? O_RDONLY : O_RDWR;
+	const int mmap_prot = setup == FILE_SETUP_READ_ONLY_FS ? PROT_READ : (PROT_READ | PROT_WRITE);
 	int fd;
 	void *p;
 	unsigned long size;
@@ -405,7 +413,10 @@ static void *file_setup_area_common(int
 	success("OK");
 
 	printf("Opening %s %s for collapse...", finfo.path,
-	       read_only ? "read-only" : "read-write");
+	       setup == FILE_SETUP_READ_ONLY_FS ? "read-only" :
+	       setup == FILE_SETUP_READ_WRITE_FS_READ_DATA ?
+						  "read-write (read)" :
+						  "read-write (write)");
 	finfo.fd = open(finfo.path, open_opt, 777);
 	if (finfo.fd < 0) {
 		perror("open()");
@@ -425,12 +436,17 @@ static void *file_setup_area_common(int
 
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
@@ -448,6 +464,16 @@ static void file_fault_read(void *p, uns
 	}
 }
 
+static void file_fault_read_and_flush(void *p, unsigned long start, unsigned long end)
+{
+	file_fault_read(p, start, end);
+	/*
+	 * make folio clean, since dirty folios from read&write file are
+	 * rejected and not flushed
+	 */
+	msync((char *)p + start, end - start, MS_SYNC);
+}
+
 static void file_fault_write(void *p, unsigned long start, unsigned long end)
 {
 	if (madvise(((char *)p) + start, end - start, MADV_POPULATE_WRITE)) {
@@ -519,8 +545,16 @@ static struct mem_ops __read_only_file_o
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
@@ -537,7 +571,9 @@ static struct mem_ops __shmem_ops = {
 
 static bool is_tmpfs(struct mem_ops *ops)
 {
-	return (ops == &__read_only_file_ops || ops == &__read_write_file_ops) &&
+	return (ops == &__read_only_file_ops ||
+		ops == &__read_write_file_read_ops ||
+		ops == &__read_write_file_write_ops) &&
 	       finfo.type == VMA_SHMEM;
 }
 
@@ -554,9 +590,11 @@ static void __madvise_collapse(const cha
 
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
@@ -624,8 +662,11 @@ static bool wait_for_scan(const char *ms
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
@@ -748,6 +789,9 @@ static void collapse_max_ptes_none(struc
 	validate_memory(p, 0, (hpage_pmd_nr - max_ptes_none - fault_nr_pages) * page_size);
 
 	if (c->enforce_pte_scan_limits) {
+		ops->cleanup_area(p, hpage_pmd_size);
+		p = ops->setup_area(1);
+
 		ops->fault(p, 0, (hpage_pmd_nr - max_ptes_none) * page_size);
 		c->collapse("Collapse with max_ptes_none PTEs empty", p, 1, ops,
 			    true);
@@ -1195,21 +1239,24 @@ static void parse_test_type(int argc, ch
 
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
@@ -1282,11 +1329,13 @@ int main(int argc, char **argv)
 
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
@@ -1294,30 +1343,38 @@ int main(int argc, char **argv)
 
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
@@ -1340,9 +1397,11 @@ int main(int argc, char **argv)
 
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

mm-khugepaged-remove-read_only_thp_for_fs-check.patch
mm-khugepaged-add-folio-dirty-check-after-try_to_unmap.patch
mm-huge_memory-remove-read_only_thp_for_fs-from-file_thp_enabled.patch
mm-khugepaged-remove-read_only_thp_for_fs-check-in-hugepage_enabled.patch
mm-remove-read_only_thp_for_fs-kconfig-option.patch
mm-fs-remove-filemap_nr_thps-functions-and-their-users.patch
fs-remove-nr_thps-from-struct-address_space.patch
mm-huge_memory-remove-folio-split-check-for-read_only_thp_for_fs.patch
mm-truncate-use-folio_split-in-truncate_inode_partial_folio.patch
fs-btrfs-remove-a-comment-referring-to-read_only_thp_for_fs.patch
selftests-mm-remove-read_only_thp_for_fs-in-khugepaged.patch
selftests-mm-remove-read_only_thp_for_fs-code-from-guard-regions.patch
mm-khugepaged-enable-clean-pagecache-folio-collapse-for-writable-files.patch
selftests-mm-add-writable-file-collapse-tests-for-khugepaged.patch

