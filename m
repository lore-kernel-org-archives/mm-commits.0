Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF17C4D2EF6
	for <mm-commits@vger.kernel.org>; Mon, 11 May 2026 21:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778535257; cv=none; b=QeQHzMpRL5SC56T0WJY92RgxJINqayGkrZF7oEAP9VqS1THHmQjwMFpawYDz9cHLDuSj9270BKBUyfhDqgiFtoqg4stT8tsnLlmo75Wy6/gYv0JRUubrukjBYnoQ6QXLXPTMZ3PmRjCLCNUPvFGYTqhyrl4A7WJwU6cKiF20YXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778535257; c=relaxed/simple;
	bh=P/lGcIukvC4Gp7pFd3gRWhKrqpJV2+OG4pKpHvZPgKs=;
	h=Date:To:From:Subject:Message-Id; b=S3j4JoQxLwf8DLLN80SJdwFM6mBLg0gtfc3+6Rni2NikvyyEtV9xgXXl6MgYVswGpl6oASsNB0rVJkGpiVT+car61opeLfARrb9mCG/6PNej0yn1Dr9Wgnno+GOZuuhROexw2y6zl7eh3z887OkvvKPTewyzAPCp45ERg55GLwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=R5Fwuh1s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="R5Fwuh1s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B1C6C2BCB0;
	Mon, 11 May 2026 21:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778535257;
	bh=P/lGcIukvC4Gp7pFd3gRWhKrqpJV2+OG4pKpHvZPgKs=;
	h=Date:To:From:Subject:From;
	b=R5Fwuh1s6VkyzpXS5w9BUpFEfQ1n35yB3zd6MolnL/F7pxyL7YIO5SsYd8sxfaHCR
	 YaBCIjMkzQCkrrWbLsmyOdF6x/1gEDbmila1AtZ4D2UM80vLvdxovKK1xYtdm2PT72
	 nglzlslW4jfYrpoaidHhl3EjwlP1RloN2JxCAd4I=
Date: Mon, 11 May 2026 14:34:16 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-khugepaged-use-ksefltest-framework.patch added to mm-new branch
Message-Id: <20260511213417.5B1C6C2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: khugepaged: use kselftest framework
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-khugepaged-use-ksefltest-framework.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-khugepaged-use-ksefltest-framework.patch

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
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: selftests/mm: khugepaged: use kselftest framework
Date: Mon, 11 May 2026 19:27:58 +0300

Convert khugepaged tests to use kselftest framework for reporting and
tracking successful and failing runs.

The conversion is mostly about replacing printf()/perror() + exit() pairs
with their ksft_ counterparts.

The nice colored success and failure indications are left intact.

Replace the progress report in collapse_compound_extreme() with a single
ksft_print_msg() to avoid headache with formatting and make the test
output more concise.

Link: https://lore.kernel.org/20260511162840.375890-15-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Tested-by: Luiz Capitulino <luizcap@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Li Wang <li.wang@linux.dev>
Cc: Sarthak Sharma <sarthak.sharma@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/khugepaged.c |  312 +++++++++-------------
 1 file changed, 130 insertions(+), 182 deletions(-)

--- a/tools/testing/selftests/mm/khugepaged.c~selftests-mm-khugepaged-use-ksefltest-framework
+++ a/tools/testing/selftests/mm/khugepaged.c
@@ -86,17 +86,19 @@ static int exit_status;
 static void success(const char *msg)
 {
 	printf(" \e[32m%s\e[0m\n", msg);
+	exit_status = KSFT_PASS;
 }
 
 static void fail(const char *msg)
 {
 	printf(" \e[31m%s\e[0m\n", msg);
-	exit_status++;
+	exit_status = KSFT_FAIL;
 }
 
 static void skip(const char *msg)
 {
 	printf(" \e[33m%s\e[0m\n", msg);
+	exit_status = KSFT_SKIP;
 }
 
 static void restore_settings_atexit(void)
@@ -104,22 +106,24 @@ static void restore_settings_atexit(void
 	if (skip_settings_restore)
 		return;
 
-	printf("Restore THP and khugepaged settings...");
+	ksft_print_msg("Restore THP and khugepaged settings...");
 	thp_restore_settings();
 	success("OK");
 
 	skip_settings_restore = true;
+	ksft_print_cnts();
+	exit(exit_status);
 }
 
 static void restore_settings(int sig)
 {
 	/* exit() will invoke the restore_settings_atexit handler. */
-	exit(sig ? EXIT_FAILURE : exit_status);
+	exit(sig ? KSFT_FAIL : exit_status);
 }
 
 static void save_settings(void)
 {
-	printf("Save THP and khugepaged settings...");
+	ksft_print_msg("Save THP and khugepaged settings...");
 	if ((read_only_file_ops || read_write_file_read_ops ||
 	     read_write_file_write_ops) &&
 	    finfo.type == VMA_FILE)
@@ -145,19 +149,13 @@ static void get_finfo(const char *dir)
 
 	finfo.dir = dir;
 	stat(finfo.dir, &path_stat);
-	if (!S_ISDIR(path_stat.st_mode)) {
-		printf("%s: Not a directory (%s)\n", __func__, finfo.dir);
-		exit(EXIT_FAILURE);
-	}
+	if (!S_ISDIR(path_stat.st_mode))
+		ksft_exit_fail_msg("%s: Not a directory (%s)\n", __func__, finfo.dir);
 	if (snprintf(finfo.path, sizeof(finfo.path), "%s/" TEST_FILE,
-		     finfo.dir) >= sizeof(finfo.path)) {
-		printf("%s: Pathname is too long\n", __func__);
-		exit(EXIT_FAILURE);
-	}
-	if (statfs(finfo.dir, &fs)) {
-		perror("statfs()");
-		exit(EXIT_FAILURE);
-	}
+		     finfo.dir) >= sizeof(finfo.path))
+		ksft_exit_fail_msg("%s: Pathname is too long\n", __func__);
+	if (statfs(finfo.dir, &fs))
+		ksft_exit_fail_perror("statfs()");
 	finfo.type = fs.f_type == TMPFS_MAGIC ? VMA_SHMEM : VMA_FILE;
 	if (finfo.type == VMA_SHMEM)
 		return;
@@ -165,40 +163,30 @@ static void get_finfo(const char *dir)
 	/* Find owning device's queue/read_ahead_kb control */
 	if (snprintf(path, sizeof(path), "/sys/dev/block/%d:%d/uevent",
 		     major(path_stat.st_dev), minor(path_stat.st_dev))
-	    >= sizeof(path)) {
-		printf("%s: Pathname is too long\n", __func__);
-		exit(EXIT_FAILURE);
-	}
-	if (read_file(path, buf, sizeof(buf)) < 0) {
-		perror("read_file(read_num)");
-		exit(EXIT_FAILURE);
-	}
+	    >= sizeof(path))
+		ksft_exit_fail_msg("%s: Pathname is too long\n", __func__);
+	if (read_file(path, buf, sizeof(buf)) < 0)
+		ksft_exit_fail_perror("read_file(read_num)");
 	if (strstr(buf, "DEVTYPE=disk")) {
 		/* Found it */
 		if (snprintf(finfo.dev_queue_read_ahead_path,
 			     sizeof(finfo.dev_queue_read_ahead_path),
 			     "/sys/dev/block/%d:%d/queue/read_ahead_kb",
 			     major(path_stat.st_dev), minor(path_stat.st_dev))
-		    >= sizeof(finfo.dev_queue_read_ahead_path)) {
-			printf("%s: Pathname is too long\n", __func__);
-			exit(EXIT_FAILURE);
-		}
+		    >= sizeof(finfo.dev_queue_read_ahead_path))
+			ksft_exit_fail_msg("%s: Pathname is too long\n", __func__);
 		return;
 	}
-	if (!strstr(buf, "DEVTYPE=partition")) {
-		printf("%s: Unknown device type: %s\n", __func__, path);
-		exit(EXIT_FAILURE);
-	}
+	if (!strstr(buf, "DEVTYPE=partition"))
+		ksft_exit_fail_msg("%s: Unknown device type: %s\n", __func__, path);
 	/*
 	 * Partition of block device - need to find actual device.
 	 * Using naming convention that devnameN is partition of
 	 * device devname.
 	 */
 	str = strstr(buf, "DEVNAME=");
-	if (!str) {
-		printf("%s: Could not read: %s", __func__, path);
-		exit(EXIT_FAILURE);
-	}
+	if (!str)
+		ksft_exit_fail_msg("%s: Could not read: %s", __func__, path);
 	str += 8;
 	end = str;
 	while (*end) {
@@ -207,16 +195,13 @@ static void get_finfo(const char *dir)
 			if (snprintf(finfo.dev_queue_read_ahead_path,
 				     sizeof(finfo.dev_queue_read_ahead_path),
 				     "/sys/block/%s/queue/read_ahead_kb",
-				     str) >= sizeof(finfo.dev_queue_read_ahead_path)) {
-				printf("%s: Pathname is too long\n", __func__);
-				exit(EXIT_FAILURE);
-			}
+				     str) >= sizeof(finfo.dev_queue_read_ahead_path))
+				ksft_exit_fail_msg("%s: Pathname is too long\n", __func__);
 			return;
 		}
 		++end;
 	}
-	printf("%s: Could not read: %s\n", __func__, path);
-	exit(EXIT_FAILURE);
+	ksft_exit_fail_msg("%s: Could not read: %s\n", __func__, path);
 }
 
 static bool check_swap(void *addr, unsigned long size)
@@ -229,26 +214,19 @@ static bool check_swap(void *addr, unsig
 
 	ret = snprintf(addr_pattern, MAX_LINE_LENGTH, "%08lx-",
 		       (unsigned long) addr);
-	if (ret >= MAX_LINE_LENGTH) {
-		printf("%s: Pattern is too long\n", __func__);
-		exit(EXIT_FAILURE);
-	}
-
+	if (ret >= MAX_LINE_LENGTH)
+		ksft_exit_fail_msg("%s: Pattern is too long\n", __func__);
 
 	fp = fopen(PID_SMAPS, "r");
-	if (!fp) {
-		printf("%s: Failed to open file %s\n", __func__, PID_SMAPS);
-		exit(EXIT_FAILURE);
-	}
+	if (!fp)
+		ksft_exit_fail_msg("%s: Failed to open file %s\n", __func__, PID_SMAPS);
 	if (!check_for_pattern(fp, addr_pattern, buffer, sizeof(buffer)))
 		goto err_out;
 
 	ret = snprintf(addr_pattern, MAX_LINE_LENGTH, "Swap:%19ld kB",
 		       size >> 10);
-	if (ret >= MAX_LINE_LENGTH) {
-		printf("%s: Pattern is too long\n", __func__);
-		exit(EXIT_FAILURE);
-	}
+	if (ret >= MAX_LINE_LENGTH)
+		ksft_exit_fail_msg("%s: Pattern is too long\n", __func__);
 	/*
 	 * Fetch the Swap: in the same block and check whether it got
 	 * the expected number of hugeepages next.
@@ -271,10 +249,8 @@ static void *alloc_mapping(int nr)
 
 	p = mmap(BASE_ADDR, nr * hpage_pmd_size, PROT_READ | PROT_WRITE,
 		 MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
-	if (p != BASE_ADDR) {
-		printf("Failed to allocate VMA at %p\n", BASE_ADDR);
-		exit(EXIT_FAILURE);
-	}
+	if (p != BASE_ADDR)
+		ksft_exit_fail_msg("Failed to allocate VMA at %p\n", BASE_ADDR);
 
 	return p;
 }
@@ -324,19 +300,13 @@ static void *alloc_hpage(struct mem_ops
 	 * khugepaged on low-load system (like a test machine), which
 	 * would cause MADV_COLLAPSE to fail with EAGAIN.
 	 */
-	printf("Allocate huge page...");
-	if (madvise_collapse_retry(p, hpage_pmd_size)) {
-		perror("madvise(MADV_COLLAPSE)");
-		exit(EXIT_FAILURE);
-	}
-	if (!ops->check_huge(p, 1)) {
-		perror("madvise(MADV_COLLAPSE)");
-		exit(EXIT_FAILURE);
-	}
-	if (madvise(p, hpage_pmd_size, MADV_HUGEPAGE)) {
-		perror("madvise(MADV_HUGEPAGE)");
-		exit(EXIT_FAILURE);
-	}
+	ksft_print_msg("Allocate huge page...");
+	if (madvise_collapse_retry(p, hpage_pmd_size))
+		ksft_exit_fail_perror("madvise(MADV_COLLAPSE)");
+	if (!ops->check_huge(p, 1))
+		ksft_exit_fail_perror("madvise(MADV_COLLAPSE)");
+	if (madvise(p, hpage_pmd_size, MADV_HUGEPAGE))
+		ksft_exit_fail_perror("madvise(MADV_HUGEPAGE)");
 	success("OK");
 	return p;
 }
@@ -346,11 +316,9 @@ static void validate_memory(int *p, unsi
 	int i;
 
 	for (i = start / page_size; i < end / page_size; i++) {
-		if (p[i * page_size / sizeof(*p)] != i + 0xdead0000) {
-			printf("Page %d is corrupted: %#x\n",
-					i, p[i * page_size / sizeof(*p)]);
-			exit(EXIT_FAILURE);
-		}
+		if (p[i * page_size / sizeof(*p)] != i + 0xdead0000)
+			ksft_exit_fail_msg("Page %d is corrupted: %#x\n",
+					   i, p[i * page_size / sizeof(*p)]);
 	}
 }
 
@@ -384,14 +352,12 @@ static void *file_setup_area_common(int
 	int mmap_opt = setup == FILE_SETUP_READ_ONLY_FS ? MAP_PRIVATE : MAP_SHARED;
 
 	unlink(finfo.path);  /* Cleanup from previous failed tests */
-	printf("Creating %s for collapse%s...", finfo.path,
-	       finfo.type == VMA_SHMEM ? " (tmpfs)" : "");
+	ksft_print_msg("Creating %s for collapse%s...", finfo.path,
+		       finfo.type == VMA_SHMEM ? " (tmpfs)" : "");
 	fd = open(finfo.path, O_CREAT | O_RDWR | O_TRUNC | O_EXCL,
 		  777);
-	if (fd < 0) {
-		perror("open()");
-		exit(EXIT_FAILURE);
-	}
+	if (fd < 0)
+		ksft_exit_fail_perror("open()");
 
 	size = nr_hpages * hpage_pmd_size;
 	if (ftruncate(fd, size)) {
@@ -413,22 +379,18 @@ static void *file_setup_area_common(int
 	munmap(p, size);
 	success("OK");
 
-	printf("Opening %s %s for collapse...", finfo.path,
+	ksft_print_msg("Opening %s %s for collapse...", finfo.path,
 	       setup == FILE_SETUP_READ_ONLY_FS ? "read only" :
 	       setup == FILE_SETUP_READ_WRITE_FS_READ_DATA ?
 						  "read-write (read)" :
 						  "read-write (write)");
 	finfo.fd = open(finfo.path, open_opt, 777);
-	if (finfo.fd < 0) {
-		perror("open()");
-		exit(EXIT_FAILURE);
-	}
+	if (finfo.fd < 0)
+		ksft_exit_fail_perror("open()");
 	p = mmap(BASE_ADDR, size, mmap_prot,
 		 mmap_opt, finfo.fd, 0);
-	if (p == MAP_FAILED || p != BASE_ADDR) {
-		perror("mmap()");
-		exit(EXIT_FAILURE);
-	}
+	if (p == MAP_FAILED || p != BASE_ADDR)
+		ksft_exit_fail_perror("mmap()");
 
 	/* Drop page cache */
 	write_file("/proc/sys/vm/drop_caches", "3", 2);
@@ -463,9 +425,9 @@ static void file_fault_common(void *p, u
 {
 	if (madvise(((char *)p) + start, end - start, madv_ops)) {
 		if (madv_ops == MADV_POPULATE_READ)
-			perror("madvise(MADV_POPULATE_READ");
+			ksft_exit_fail_perror("madvise(MADV_POPULATE_READ");
 		else if (madv_ops == MADV_POPULATE_WRITE)
-			perror("madvise(MADV_POPULATE_WRITE");
+			ksft_exit_fail_perror("madvise(MADV_POPULATE_WRITE");
 		exit(EXIT_FAILURE);
 	}
 }
@@ -510,20 +472,14 @@ static void *shmem_setup_area(int nr_hpa
 	unsigned long size = nr_hpages * hpage_pmd_size;
 
 	finfo.fd = memfd_create("khugepaged-selftest-collapse-shmem", 0);
-	if (finfo.fd < 0)  {
-		perror("memfd_create()");
-		exit(EXIT_FAILURE);
-	}
-	if (ftruncate(finfo.fd, size)) {
-		perror("ftruncate()");
-		exit(EXIT_FAILURE);
-	}
+	if (finfo.fd < 0)
+		ksft_exit_fail_perror("memfd_create()");
+	if (ftruncate(finfo.fd, size))
+		ksft_exit_fail_perror("ftruncate()");
 	p = mmap(BASE_ADDR, size, PROT_READ | PROT_WRITE, MAP_SHARED, finfo.fd,
 		 0);
-	if (p != BASE_ADDR) {
-		perror("mmap()");
-		exit(EXIT_FAILURE);
-	}
+	if (p != BASE_ADDR)
+		ksft_exit_fail_perror("mmap()");
 	return p;
 }
 
@@ -597,7 +553,7 @@ static void __madvise_collapse(const cha
 	int ret;
 	struct thp_settings settings = *thp_current_settings();
 
-	printf("%s...", msg);
+	ksft_print_msg("%s...", msg);
 
 	/*
 	 * read&write file collapse succeeds for MADV_COLLAPSE because dirty
@@ -630,10 +586,8 @@ static void madvise_collapse(const char
 			     struct mem_ops *ops, bool expect)
 {
 	/* Sanity check */
-	if (!ops->check_huge(p, 0)) {
-		printf("Unexpected huge page\n");
-		exit(EXIT_FAILURE);
-	}
+	if (!ops->check_huge(p, 0))
+		ksft_exit_fail_msg("Unexpected huge page\n");
 	__madvise_collapse(msg, p, nr_hpages, ops, expect);
 }
 
@@ -645,17 +599,15 @@ static bool wait_for_scan(const char *ms
 	int timeout = 6; /* 3 seconds */
 
 	/* Sanity check */
-	if (!ops->check_huge(p, 0)) {
-		printf("Unexpected huge page\n");
-		exit(EXIT_FAILURE);
-	}
+	if (!ops->check_huge(p, 0))
+		ksft_exit_fail_msg("Unexpected huge page\n");
 
 	madvise(p, nr_hpages * hpage_pmd_size, MADV_HUGEPAGE);
 
 	/* Wait until the second full_scan completed */
 	full_scans = thp_read_num("khugepaged/full_scans") + 2;
 
-	printf("%s...", msg);
+	ksft_print_msg("%s...", msg);
 	while (timeout--) {
 		if (ops->check_huge(p, nr_hpages))
 			break;
@@ -722,7 +674,7 @@ static void alloc_at_fault(void)
 
 	p = alloc_mapping(1);
 	*p = 1;
-	printf("Allocate huge page on fault...");
+	ksft_print_msg("Allocate huge page on fault...");
 	if (check_huge_anon(p, 1, hpage_pmd_size))
 		success("OK");
 	else
@@ -731,12 +683,14 @@ static void alloc_at_fault(void)
 	thp_pop_settings();
 
 	madvise(p, page_size, MADV_DONTNEED);
-	printf("Split huge PMD on MADV_DONTNEED...");
+	ksft_print_msg("Split huge PMD on MADV_DONTNEED...");
 	if (check_huge_anon(p, 0, hpage_pmd_size))
 		success("OK");
 	else
 		fail("Fail");
 	munmap(p, hpage_pmd_size);
+
+	ksft_test_result_report(exit_status, "allocate on fault and split\n");
 }
 
 static void collapse_full(struct collapse_context *c, struct mem_ops *ops)
@@ -751,6 +705,8 @@ static void collapse_full(struct collaps
 		    ops, true);
 	validate_memory(p, 0, size);
 	ops->cleanup_area(p, size);
+
+	ksft_test_result_report(exit_status, "%s\n", __func__);
 }
 
 static void collapse_empty(struct collapse_context *c, struct mem_ops *ops)
@@ -760,6 +716,7 @@ static void collapse_empty(struct collap
 	p = ops->setup_area(1);
 	c->collapse("Do not collapse empty PTE table", p, 1, ops, false);
 	ops->cleanup_area(p, hpage_pmd_size);
+	ksft_test_result_report(exit_status, "%s\n", __func__);
 }
 
 static void collapse_single_pte_entry(struct collapse_context *c, struct mem_ops *ops)
@@ -771,6 +728,7 @@ static void collapse_single_pte_entry(st
 	c->collapse("Collapse PTE table with single PTE entry present", p,
 		    1, ops, true);
 	ops->cleanup_area(p, hpage_pmd_size);
+	ksft_test_result_report(exit_status, "%s\n", __func__);
 }
 
 static void collapse_max_ptes_none(struct collapse_context *c, struct mem_ops *ops)
@@ -810,6 +768,7 @@ static void collapse_max_ptes_none(struc
 skip:
 	ops->cleanup_area(p, hpage_pmd_size);
 	thp_pop_settings();
+	ksft_test_result_report(exit_status, "%s\n", __func__);
 }
 
 static void collapse_swapin_single_pte(struct collapse_context *c, struct mem_ops *ops)
@@ -819,11 +778,9 @@ static void collapse_swapin_single_pte(s
 	p = ops->setup_area(1);
 	ops->fault(p, 0, hpage_pmd_size);
 
-	printf("Swapout one page...");
-	if (madvise(p, page_size, MADV_PAGEOUT)) {
-		perror("madvise(MADV_PAGEOUT)");
-		exit(EXIT_FAILURE);
-	}
+	ksft_print_msg("Swapout one page...");
+	if (madvise(p, page_size, MADV_PAGEOUT))
+		ksft_exit_fail_perror("madvise(MADV_PAGEOUT)");
 	if (check_swap(p, page_size)) {
 		success("OK");
 	} else {
@@ -836,6 +793,7 @@ static void collapse_swapin_single_pte(s
 	validate_memory(p, 0, hpage_pmd_size);
 out:
 	ops->cleanup_area(p, hpage_pmd_size);
+	ksft_test_result_report(exit_status, "%s\n", __func__);
 }
 
 static void collapse_max_ptes_swap(struct collapse_context *c, struct mem_ops *ops)
@@ -846,11 +804,9 @@ static void collapse_max_ptes_swap(struc
 	p = ops->setup_area(1);
 	ops->fault(p, 0, hpage_pmd_size);
 
-	printf("Swapout %d of %d pages...", max_ptes_swap + 1, hpage_pmd_nr);
-	if (madvise(p, (max_ptes_swap + 1) * page_size, MADV_PAGEOUT)) {
-		perror("madvise(MADV_PAGEOUT)");
-		exit(EXIT_FAILURE);
-	}
+	ksft_print_msg("Swapout %d of %d pages...", max_ptes_swap + 1, hpage_pmd_nr);
+	if (madvise(p, (max_ptes_swap + 1) * page_size, MADV_PAGEOUT))
+		ksft_exit_fail_perror("madvise(MADV_PAGEOUT)");
 	if (check_swap(p, (max_ptes_swap + 1) * page_size)) {
 		success("OK");
 	} else {
@@ -864,12 +820,10 @@ static void collapse_max_ptes_swap(struc
 
 	if (c->enforce_pte_scan_limits) {
 		ops->fault(p, 0, hpage_pmd_size);
-		printf("Swapout %d of %d pages...", max_ptes_swap,
+		ksft_print_msg("Swapout %d of %d pages...", max_ptes_swap,
 		       hpage_pmd_nr);
-		if (madvise(p, max_ptes_swap * page_size, MADV_PAGEOUT)) {
-			perror("madvise(MADV_PAGEOUT)");
-			exit(EXIT_FAILURE);
-		}
+		if (madvise(p, max_ptes_swap * page_size, MADV_PAGEOUT))
+			ksft_exit_fail_perror("madvise(MADV_PAGEOUT)");
 		if (check_swap(p, max_ptes_swap * page_size)) {
 			success("OK");
 		} else {
@@ -883,6 +837,7 @@ static void collapse_max_ptes_swap(struc
 	}
 out:
 	ops->cleanup_area(p, hpage_pmd_size);
+	ksft_test_result_report(exit_status, "%s\n", __func__);
 }
 
 static void collapse_single_pte_entry_compound(struct collapse_context *c, struct mem_ops *ops)
@@ -899,7 +854,7 @@ static void collapse_single_pte_entry_co
 	}
 
 	madvise(p, hpage_pmd_size, MADV_NOHUGEPAGE);
-	printf("Split huge page leaving single PTE mapping compound page...");
+	ksft_print_msg("Split huge page leaving single PTE mapping compound page...");
 	madvise(p + page_size, hpage_pmd_size - page_size, MADV_DONTNEED);
 	if (ops->check_huge(p, 0))
 		success("OK");
@@ -911,6 +866,7 @@ static void collapse_single_pte_entry_co
 	validate_memory(p, 0, page_size);
 skip:
 	ops->cleanup_area(p, hpage_pmd_size);
+	ksft_test_result_report(exit_status, "%s\n", __func__);
 }
 
 static void collapse_full_of_compound(struct collapse_context *c, struct mem_ops *ops)
@@ -918,7 +874,7 @@ static void collapse_full_of_compound(st
 	void *p;
 
 	p = alloc_hpage(ops);
-	printf("Split huge page leaving single PTE page table full of compound pages...");
+	ksft_print_msg("Split huge page leaving single PTE page table full of compound pages...");
 	madvise(p, page_size, MADV_NOHUGEPAGE);
 	madvise(p, hpage_pmd_size, MADV_NOHUGEPAGE);
 	if (ops->check_huge(p, 0))
@@ -930,6 +886,7 @@ static void collapse_full_of_compound(st
 		    true);
 	validate_memory(p, 0, hpage_pmd_size);
 	ops->cleanup_area(p, hpage_pmd_size);
+	ksft_test_result_report(exit_status, "%s\n", __func__);
 }
 
 static void collapse_compound_extreme(struct collapse_context *c, struct mem_ops *ops)
@@ -938,16 +895,12 @@ static void collapse_compound_extreme(st
 	int i;
 
 	p = ops->setup_area(1);
+	ksft_print_msg("Construct PTE page table full of different PTE-mapped compound pages\n");
 	for (i = 0; i < hpage_pmd_nr; i++) {
-		printf("\rConstruct PTE page table full of different PTE-mapped compound pages %3d/%d...",
-				i + 1, hpage_pmd_nr);
-
 		madvise(BASE_ADDR, hpage_pmd_size, MADV_HUGEPAGE);
 		ops->fault(BASE_ADDR, 0, hpage_pmd_size);
-		if (!ops->check_huge(BASE_ADDR, 1)) {
-			printf("Failed to allocate huge page\n");
-			exit(EXIT_FAILURE);
-		}
+		if (!ops->check_huge(BASE_ADDR, 1))
+			ksft_exit_fail_msg("Failed to allocate huge page\n");
 		madvise(BASE_ADDR, hpage_pmd_size, MADV_NOHUGEPAGE);
 
 		p = mremap(BASE_ADDR - i * page_size,
@@ -955,20 +908,16 @@ static void collapse_compound_extreme(st
 				(i + 1) * page_size,
 				MREMAP_MAYMOVE | MREMAP_FIXED,
 				BASE_ADDR + 2 * hpage_pmd_size);
-		if (p == MAP_FAILED) {
-			perror("mremap+unmap");
-			exit(EXIT_FAILURE);
-		}
+		if (p == MAP_FAILED)
+			ksft_exit_fail_perror("mremap+unmap");
 
 		p = mremap(BASE_ADDR + 2 * hpage_pmd_size,
 				(i + 1) * page_size,
 				(i + 1) * page_size + hpage_pmd_size,
 				MREMAP_MAYMOVE | MREMAP_FIXED,
 				BASE_ADDR - (i + 1) * page_size);
-		if (p == MAP_FAILED) {
-			perror("mremap+alloc");
-			exit(EXIT_FAILURE);
-		}
+		if (p == MAP_FAILED)
+			ksft_exit_fail_perror("mremap+alloc");
 	}
 
 	ops->cleanup_area(BASE_ADDR, hpage_pmd_size);
@@ -983,6 +932,7 @@ static void collapse_compound_extreme(st
 
 	validate_memory(p, 0, hpage_pmd_size);
 	ops->cleanup_area(p, hpage_pmd_size);
+	ksft_test_result_report(exit_status, "%s\n", __func__);
 }
 
 static void collapse_fork(struct collapse_context *c, struct mem_ops *ops)
@@ -992,18 +942,17 @@ static void collapse_fork(struct collaps
 
 	p = ops->setup_area(1);
 
-	printf("Allocate small page...");
+	ksft_print_msg("Allocate small page...");
 	ops->fault(p, 0, page_size);
 	if (ops->check_huge(p, 0))
 		success("OK");
 	else
 		fail("Fail");
 
-	printf("Share small page over fork()...");
+	ksft_print_msg("Share small page over fork()...");
 	if (!fork()) {
 		/* Do not touch settings on child exit */
 		skip_settings_restore = true;
-		exit_status = 0;
 
 		if (ops->check_huge(p, 0))
 			success("OK");
@@ -1020,15 +969,16 @@ static void collapse_fork(struct collaps
 	}
 
 	wait(&wstatus);
-	exit_status += WEXITSTATUS(wstatus);
+	exit_status = WEXITSTATUS(wstatus);
 
-	printf("Check if parent still has small page...");
+	ksft_print_msg("Check if parent still has small page...");
 	if (ops->check_huge(p, 0))
 		success("OK");
 	else
 		fail("Fail");
 	validate_memory(p, 0, page_size);
 	ops->cleanup_area(p, hpage_pmd_size);
+	ksft_test_result_report(exit_status, "%s\n", __func__);
 }
 
 static void collapse_fork_compound(struct collapse_context *c, struct mem_ops *ops)
@@ -1037,18 +987,17 @@ static void collapse_fork_compound(struc
 	void *p;
 
 	p = alloc_hpage(ops);
-	printf("Share huge page over fork()...");
+	ksft_print_msg("Share huge page over fork()...");
 	if (!fork()) {
 		/* Do not touch settings on child exit */
 		skip_settings_restore = true;
-		exit_status = 0;
 
 		if (ops->check_huge(p, 1))
 			success("OK");
 		else
 			fail("Fail");
 
-		printf("Split huge page PMD in child process...");
+		ksft_print_msg("Split huge page PMD in child process...");
 		madvise(p, page_size, MADV_NOHUGEPAGE);
 		madvise(p, hpage_pmd_size, MADV_NOHUGEPAGE);
 		if (ops->check_huge(p, 0))
@@ -1069,15 +1018,16 @@ static void collapse_fork_compound(struc
 	}
 
 	wait(&wstatus);
-	exit_status += WEXITSTATUS(wstatus);
+	exit_status = WEXITSTATUS(wstatus);
 
-	printf("Check if parent still has huge page...");
+	ksft_print_msg("Check if parent still has huge page...");
 	if (ops->check_huge(p, 1))
 		success("OK");
 	else
 		fail("Fail");
 	validate_memory(p, 0, hpage_pmd_size);
 	ops->cleanup_area(p, hpage_pmd_size);
+	ksft_test_result_report(exit_status, "%s\n", __func__);
 }
 
 static void collapse_max_ptes_shared(struct collapse_context *c, struct mem_ops *ops)
@@ -1087,18 +1037,17 @@ static void collapse_max_ptes_shared(str
 	void *p;
 
 	p = alloc_hpage(ops);
-	printf("Share huge page over fork()...");
+	ksft_print_msg("Share huge page over fork()...");
 	if (!fork()) {
 		/* Do not touch settings on child exit */
 		skip_settings_restore = true;
-		exit_status = 0;
 
 		if (ops->check_huge(p, 1))
 			success("OK");
 		else
 			fail("Fail");
 
-		printf("Trigger CoW on page %d of %d...",
+		ksft_print_msg("Trigger CoW on page %d of %d...",
 				hpage_pmd_nr - max_ptes_shared - 1, hpage_pmd_nr);
 		ops->fault(p, 0, (hpage_pmd_nr - max_ptes_shared - 1) * page_size);
 		if (ops->check_huge(p, 0))
@@ -1110,7 +1059,7 @@ static void collapse_max_ptes_shared(str
 			    1, ops, !c->enforce_pte_scan_limits);
 
 		if (c->enforce_pte_scan_limits) {
-			printf("Trigger CoW on page %d of %d...",
+			ksft_print_msg("Trigger CoW on page %d of %d...",
 			       hpage_pmd_nr - max_ptes_shared, hpage_pmd_nr);
 			ops->fault(p, 0, (hpage_pmd_nr - max_ptes_shared) *
 				    page_size);
@@ -1129,15 +1078,16 @@ static void collapse_max_ptes_shared(str
 	}
 
 	wait(&wstatus);
-	exit_status += WEXITSTATUS(wstatus);
+	exit_status = WEXITSTATUS(wstatus);
 
-	printf("Check if parent still has huge page...");
+	ksft_print_msg("Check if parent still has huge page...");
 	if (ops->check_huge(p, 1))
 		success("OK");
 	else
 		fail("Fail");
 	validate_memory(p, 0, hpage_pmd_size);
 	ops->cleanup_area(p, hpage_pmd_size);
+	ksft_test_result_report(exit_status, "%s\n", __func__);
 }
 
 static void madvise_collapse_existing_thps(struct collapse_context *c,
@@ -1154,6 +1104,7 @@ static void madvise_collapse_existing_th
 	__madvise_collapse("Re-collapse PMD-mapped hugepage", p, 1, ops, true);
 	validate_memory(p, 0, hpage_pmd_size);
 	ops->cleanup_area(p, hpage_pmd_size);
+	ksft_test_result_report(exit_status, "%s\n", __func__);
 }
 
 /*
@@ -1181,6 +1132,7 @@ static void madvise_retracted_page_table
 		    true);
 	validate_memory(p, 0, size);
 	ops->cleanup_area(p, size);
+	ksft_test_result_report(exit_status, "%s\n", __func__);
 }
 
 static void usage(void)
@@ -1289,10 +1241,8 @@ static int nr_test_cases;
 
 #define TEST(t, c, o) do {						\
 	if (c && o) {							\
-		if (nr_test_cases >= MAX_TEST_CASES) {			\
-			printf("MAX_TEST_CASES is too small\n");	\
-			exit(EXIT_FAILURE);				\
-		}							\
+		if (nr_test_cases >= MAX_TEST_CASES)			\
+			ksft_exit_fail_msg("MAX_TEST_CASES is too small\n"); \
 		test_cases[nr_test_cases++] = (struct test_case){	\
 			.ctx	= c,					\
 			.ops	= o,					\
@@ -1325,10 +1275,10 @@ int main(int argc, char **argv)
 		.read_ahead_kb = 0,
 	};
 
-	if (!thp_is_enabled()) {
-		printf("Transparent Hugepages not available\n");
-		return KSFT_SKIP;
-	}
+	ksft_print_header();
+
+	if (!thp_is_enabled())
+		ksft_exit_skip("Transparent Hugepages not available\n");
 
 	parse_test_type(argc, argv);
 
@@ -1336,10 +1286,8 @@ int main(int argc, char **argv)
 
 	page_size = getpagesize();
 	hpage_pmd_size = read_pmd_pagesize();
-	if (!hpage_pmd_size) {
-		printf("Reading PMD pagesize failed");
-		exit(EXIT_FAILURE);
-	}
+	if (!hpage_pmd_size)
+		ksft_exit_fail_msg("Reading PMD pagesize failed\n");
 	hpage_pmd_nr = hpage_pmd_size / page_size;
 	hpage_pmd_order = __builtin_ctz(hpage_pmd_nr);
 
@@ -1355,8 +1303,6 @@ int main(int argc, char **argv)
 	save_settings();
 	thp_push_settings(&default_settings);
 
-	alloc_at_fault();
-
 	TEST(collapse_full, khugepaged_context, anon_ops);
 	TEST(collapse_full, khugepaged_context, read_only_file_ops);
 	TEST(collapse_full, khugepaged_context, read_write_file_read_ops);
@@ -1434,11 +1380,13 @@ int main(int argc, char **argv)
 	TEST(madvise_retracted_page_tables, madvise_context, read_write_file_read_ops);
 	TEST(madvise_retracted_page_tables, madvise_context, shmem_ops);
 
-	exit_status = KSFT_PASS;
+	ksft_set_plan(nr_test_cases + 1);
+
+	alloc_at_fault();
 	for (int i = 0; i < nr_test_cases; i++) {
 		struct test_case *t = &test_cases[i];
 
-		printf("\nRun test: %s (%s:%s)\n", t->desc, t->ctx->name, t->ops->name);
+		ksft_print_msg("\nRun test: %s (%s:%s)\n", t->desc, t->ctx->name, t->ops->name);
 		t->fn(t->ctx, t->ops);
 	}
 
_

Patches currently in -mm which might be from rppt@kernel.org are

maintainers-add-tree-for-kdump-and-kexec.patch
maintainers-add-kexec-list-to-live-update-entry.patch
sh-fix-fallout-from-zero_page-consolidation.patch
selftests-mm-hugetlb-read-hwpoison-add-sigbus-handler.patch
selftests-mm-migration-dont-assume-huge-page-is-twomeg.patch
selftests-mm-migration-make-nthreads-represent-number-of-working-threads.patch
selftests-mm-migration-properly-cleanup-forked-processes.patch
selftests-mm-run_vmtestssh-dont-gate-thp-and-ksm-tests-on-have_hugepages.patch
selftests-mm-merge-map_hugetlb-into-hugepage-mmap.patch
selftests-mm-rename-hugepage-tests-to-hugetlb.patch
selftests-mm-hugetlb-shm-use-kselftest-framework.patch
selftests-mm-hugetlb-vmemmap-use-kselftest-framework.patch
selftests-mm-hugetlb-madvise-use-kselftest-framework.patch
selftests-mm-hugetlb_madv_vs_map-use-kselftest-framework.patch
selftests-mm-hugetlb-read-hwpoison-use-kselftest-framework.patch
selftests-mm-khugepaged-group-tests-in-an-array.patch
selftests-mm-khugepaged-use-ksefltest-framework.patch
selftests-mm-ksm_tests-use-kselftest-framework.patch
selftests-mm-protection_keys-use-descriptive-test-names-in-the-output.patch
selftests-mm-protection_keys-use-kselftest-framework.patch
selftests-mm-uffd-common-use-kselftest-framework.patch
selftests-mm-uffd-stress-use-kselftest-framework.patch
selftests-mm-uffd-unit-tests-use-kselftest-framework.patch
selftests-mm-va_high_addr_switch-use-kselftest-framework.patch
selftests-mm-add-atexit-and-signal-handlers-to-thp_settings.patch
selftests-mm-rename-thp_settings-to-hugepage_settings.patch
selftests-mm-move-hugetlb-helpers-to-hugepage_settings.patch
selftests-mm-hugepage_settings-use-unsigned-long-in-detect_hugetlb_page_size.patch
selftests-mm-hugepage_settings-add-apis-to-get-and-set-nr_hugepages.patch
selftests-mm-hugepage_settings-rename-and-rework-get_free_hugepages.patch
selftests-mm-hugepage_settings-add-apis-for-hugetlb-setup-and-teardown.patch
selftests-mm-move-read_file-read_num-and-write_num-to-vm_util.patch
selftests-mm-vm_util-add-helpers-to-set-and-restore-shm-limits.patch
selftests-mm-compaction_test-use-hugetlb-helpers.patch
selftests-mm-cow-add-setup-of-hugetlb-pages.patch
selftests-mm-gup_longterm-add-setup-of-hugetlb-pages.patch
selftests-mm-gup_test-add-setup-of-hugetlb-pages.patch
selftests-mm-hmm-tests-add-setup-of-hugetlb-pages.patch
selftests-mm-hugepage_dio-add-setup-of-hugetlb-pages.patch
selftests-mm-hugetlb_fault_after_madv-add-setup-of-hugetlb-pages.patch
selftests-mm-hugetlb-madvise-add-setup-of-hugetlb-pages.patch
selftests-mm-hugetlb_madv_vs_map-add-setup-of-hugetlb-pages.patch
selftests-mm-hugetlb-mmap-add-setup-of-hugetlb-pages.patch
selftests-mm-hugetlb-mremap-add-setup-of-hugetlb-pages.patch
selftests-mm-hugetlb-shm-add-setup-of-hugetlb-pages.patch
selftests-mm-hugetlb-soft-offline-add-setup-of-hugetlb-pages.patch
selftests-mm-hugetlb-vmemmap-add-setup-of-hugetlb-pages.patch
selftests-mm-migration-add-setup-of-hugetlb-pages.patch
selftests-mm-pagemap_ioctl-add-setup-of-hugetlb-pages.patch
selftests-mm-protection_keys-use-library-code-for-hugetlb-setup.patch
selftests-mm-thuge-gen-add-setup-of-hugetlb-pages.patch
selftests-mm-uffd-stress-use-hugetlb_save-and-alloc-huge-pages.patch
selftests-mm-uffd-unit-tests-add-setup-of-hugetlb-pages.patch
selftests-mm-uffd-wp-mremap-add-setup-of-hugetlb-pages.patch
selftests-mm-va_high_addr_switch-add-setup-of-hugetlb-pages.patch
selftests-mm-va_high_addr_switchsh-drop-huge-pages-setup.patch
selftests-mm-run_vmtestssh-free-memory-if-available-memory-is-low.patch
selftests-mm-run_vmtestssh-drop-detection-and-setup-of-hugetlb.patch

