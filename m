Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD41F36A37A
	for <mm-commits@vger.kernel.org>; Sun, 21 Jun 2026 18:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782067154; cv=none; b=fkpFpe2xUmYC0gHjdxMtw57G/u25DtG188gu73GBkO4iHFnhkMCZk8wqznTTcUuKqbtaoF02sJUzFhBtNMuEz0dqKJqphCESy/pJ74reCVVHY6v6ey/IwP3xPAeB2m+bk+98qPhuG4Uax+cDZOiu062Sm/+DvSI5DEeQqrweYVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782067154; c=relaxed/simple;
	bh=FHAhqJLY+YH3oYZ0/2UXE0WLXFwuH5bCAA5cTxYZ7Gc=;
	h=Date:To:From:Subject:Message-Id; b=EPdH2bZz7vscIzcU0JARdTZiQrzbSLJMPIzpOoq/e4NDrMNL/yXpA6X/K50tFoNffrDH0Y6lVlODNM5XRALwYsQjI/M9ARe/Cxb7KPUC8exz2oVFlxbiAAzrzGsbisZYpLOKQXd0RJErBsMP/aizPz0ETMPXFxE3xX5G+2KYrSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ExkNbf0m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ExkNbf0m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B0641F00A3A;
	Sun, 21 Jun 2026 18:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782067152;
	bh=PYyHrSZzIuGvH+KPmU/Hii7fYvvlKlpRuHlQV1dm7kY=;
	h=Date:To:From:Subject;
	b=ExkNbf0mi/G9/Eqx1R+JwjM/Zh41JEfSLJd3tlY+FhUVnyhcnZO+Be7XUu7ePCjM1
	 1Epw6QiyrKUC9r9Ack02MP+25r+DPkVRL9VozitJBMPW3Ul3gjDXNcYhWzrdwFkrfk
	 y+n5abcJcW/uEraXk3NqsYbsTqd0tKCSDKUcqYHM=
Date: Sun, 21 Jun 2026 11:39:11 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,sarthak.sharma@arm.com,ryan.roberts@arm.com,peterx@redhat.com,npache@redhat.com,mhocko@suse.com,luizcap@redhat.com,ljs@kernel.org,li.wang@linux.dev,liam@infradead.org,leon@kernel.org,lance.yang@linux.dev,jhubbard@nvidia.com,jgg@ziepe.ca,donettom@linux.ibm.com,dev.jain@arm.com,david@kernel.org,broonie@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-hugepage_settings-rename-and-rework-get_free_hugepages.patch removed from -mm tree
Message-Id: <20260621183912.5B0641F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: hugepage_settings: rename and rework get_free_hugepages()
has been removed from the -mm tree.  Its filename was
     selftests-mm-hugepage_settings-rename-and-rework-get_free_hugepages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: selftests/mm: hugepage_settings: rename and rework get_free_hugepages()
Date: Mon, 11 May 2026 19:28:11 +0300

...  to hugetlb_free_default_pages() for consistency with
hugetlb_nr_default_pages().

Make hugetlb_free_default_pages() use hugetlb_sysfs_path() helper instead
of parsing /proc/meminfo.

Link: https://lore.kernel.org/20260511162840.375890-28-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Tested-by: Luiz Capitulino <luizcap@redhat.com>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
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
Cc: Li Wang <li.wang@linux.dev>
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/hugepage_settings.c        |   28 +++-------
 tools/testing/selftests/mm/hugepage_settings.h        |   12 +++-
 tools/testing/selftests/mm/hugetlb-madvise.c          |    4 -
 tools/testing/selftests/mm/hugetlb_dio.c              |    6 +-
 tools/testing/selftests/mm/hugetlb_fault_after_madv.c |    2 
 tools/testing/selftests/mm/hugetlb_madv_vs_map.c      |    2 
 tools/testing/selftests/mm/uffd-stress.c              |    2 
 7 files changed, 28 insertions(+), 28 deletions(-)

--- a/tools/testing/selftests/mm/hugepage_settings.c~selftests-mm-hugepage_settings-rename-and-rework-get_free_hugepages
+++ a/tools/testing/selftests/mm/hugepage_settings.c
@@ -445,25 +445,6 @@ unsigned long default_huge_page_size(voi
 	return hps;
 }
 
-unsigned long get_free_hugepages(void)
-{
-	unsigned long fhp = 0;
-	char *line = NULL;
-	size_t linelen = 0;
-	FILE *f = fopen("/proc/meminfo", "r");
-
-	if (!f)
-		return fhp;
-	while (getline(&line, &linelen, f) > 0) {
-		if (sscanf(line, "HugePages_Free:      %lu", &fhp) == 1)
-			break;
-	}
-
-	free(line);
-	fclose(f);
-	return fhp;
-}
-
 static void hugetlb_sysfs_path(char *buf, size_t buflen,
 			       unsigned long size, const char *attr)
 {
@@ -488,3 +469,12 @@ void hugetlb_set_nr_pages(unsigned long
 
 	write_num(path, nr);
 }
+
+unsigned long hugetlb_free_pages(unsigned long size)
+{
+	char path[PATH_MAX];
+
+	hugetlb_sysfs_path(path, sizeof(path), size, "free_hugepages");
+
+	return read_num(path);
+}
--- a/tools/testing/selftests/mm/hugepage_settings.h~selftests-mm-hugepage_settings-rename-and-rework-get_free_hugepages
+++ a/tools/testing/selftests/mm/hugepage_settings.h
@@ -92,10 +92,10 @@ bool thp_is_enabled(void);
 
 int detect_hugetlb_page_sizes(unsigned long sizes[], int max);
 unsigned long default_huge_page_size(void);
-unsigned long get_free_hugepages(void);
 
 unsigned long hugetlb_nr_pages(unsigned long size);
 void hugetlb_set_nr_pages(unsigned long size, unsigned long nr);
+unsigned long hugetlb_free_pages(unsigned long size);
 
 static inline unsigned long hugetlb_nr_default_pages(void)
 {
@@ -117,4 +117,14 @@ static inline void hugetlb_set_nr_defaul
 	hugetlb_set_nr_pages(size, nr);
 }
 
+static inline unsigned long hugetlb_free_default_pages(void)
+{
+	unsigned long size = default_huge_page_size();
+
+	if (!size)
+		return 0;
+
+	return hugetlb_free_pages(size);
+}
+
 #endif /* __HUGEPAGE_SETTINGS_H__ */
--- a/tools/testing/selftests/mm/hugetlb_dio.c~selftests-mm-hugepage_settings-rename-and-rework-get_free_hugepages
+++ a/tools/testing/selftests/mm/hugetlb_dio.c
@@ -93,7 +93,7 @@ static void run_dio_using_hugetlb(int fd
 		ksft_exit_fail_perror("lseek failed\n");
 
 	/* Get the free huge pages before allocation */
-	free_hpage_b = get_free_hugepages();
+	free_hpage_b = hugetlb_free_default_pages();
 	if (free_hpage_b == 0) {
 		close(fd);
 		ksft_exit_skip("No free hugepage, exiting!\n");
@@ -121,7 +121,7 @@ static void run_dio_using_hugetlb(int fd
 	munmap(orig_buffer, h_pagesize);
 
 	/* Get the free huge pages after unmap*/
-	free_hpage_a = get_free_hugepages();
+	free_hpage_a = hugetlb_free_default_pages();
 
 	ksft_print_msg("No. Free pages before allocation : %d\n", free_hpage_b);
 	ksft_print_msg("No. Free pages after munmap : %d\n", free_hpage_a);
@@ -142,7 +142,7 @@ int main(void)
 	ksft_print_header();
 
 	/* Check if huge pages are free */
-	if (!get_free_hugepages())
+	if (!hugetlb_free_default_pages())
 		ksft_exit_skip("No free hugepage, exiting\n");
 
 	fd = open("/tmp", O_TMPFILE | O_RDWR | O_DIRECT, 0664);
--- a/tools/testing/selftests/mm/hugetlb_fault_after_madv.c~selftests-mm-hugepage_settings-rename-and-rework-get_free_hugepages
+++ a/tools/testing/selftests/mm/hugetlb_fault_after_madv.c
@@ -78,7 +78,7 @@ int main(void)
 	ksft_print_msg("[INFO] detected default hugetlb page size: %zu KiB\n",
 		       huge_page_size / 1024);
 
-	free_hugepages = get_free_hugepages();
+	free_hugepages = hugetlb_free_default_pages();
 	if (free_hugepages != 1) {
 		ksft_exit_skip("This test needs one and only one page to execute. Got %lu\n",
 			       free_hugepages);
--- a/tools/testing/selftests/mm/hugetlb-madvise.c~selftests-mm-hugepage_settings-rename-and-rework-get_free_hugepages
+++ a/tools/testing/selftests/mm/hugetlb-madvise.c
@@ -27,7 +27,7 @@
 
 #define validate_free_pages(exp_free)					\
 	do {								\
-		unsigned long fhp = get_free_hugepages();		\
+		unsigned long fhp = hugetlb_free_default_pages();		\
 		if (fhp != (exp_free))					\
 			ksft_exit_fail_msg("Unexpected number of free "	\
 				"huge pages %lu, expected %lu line %d\n", \
@@ -68,7 +68,7 @@ int main(int argc, char **argv)
 	if (!base_page_size)
 		ksft_exit_fail_msg("Unable to determine base page size\n");
 
-	free_hugepages = get_free_hugepages();
+	free_hugepages = hugetlb_free_default_pages();
 	if (free_hugepages < MIN_FREE_PAGES)
 		ksft_exit_skip("Not enough free huge pages (have %lu, need %d)\n", free_hugepages, MIN_FREE_PAGES);
 
--- a/tools/testing/selftests/mm/hugetlb_madv_vs_map.c~selftests-mm-hugepage_settings-rename-and-rework-get_free_hugepages
+++ a/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
@@ -89,7 +89,7 @@ int main(void)
 	ksft_print_header();
 	ksft_set_plan(1);
 
-	free_hugepages = get_free_hugepages();
+	free_hugepages = hugetlb_free_default_pages();
 
 	if (free_hugepages != 1)
 		ksft_exit_skip("This test needs one and only one page to execute. Got %lu\n",
--- a/tools/testing/selftests/mm/uffd-stress.c~selftests-mm-hugepage_settings-rename-and-rework-get_free_hugepages
+++ a/tools/testing/selftests/mm/uffd-stress.c
@@ -481,7 +481,7 @@ int main(int argc, char **argv)
 	 * for racy extra reservation of hugepages.
 	 */
 	if (gopts->test_type == TEST_HUGETLB &&
-	   get_free_hugepages() < 2 * (bytes / gopts->page_size) + gopts->nr_parallel - 1)
+	   hugetlb_free_default_pages() < 2 * (bytes / gopts->page_size) + gopts->nr_parallel - 1)
 		ksft_exit_skip("Skipping userfaultfd... not enough hugepages\n");
 
 	gopts->nr_pages_per_cpu = bytes / gopts->page_size / gopts->nr_parallel;
_

Patches currently in -mm which might be from rppt@kernel.org are


