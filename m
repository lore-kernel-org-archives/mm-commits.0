Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 719C855C336
	for <mm-commits@vger.kernel.org>; Tue,  8 Sep 2026 19:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788894739; cv=none; b=I7IeVK4nVn+ITdtCZZTC3h0Zrnh79ANlsEMThKDjV4TLBr9Zk6oFfBzRpW07wHOApuSjR1vQejXhu/QqSpQ2ggHRjg4qghic6KGuoO60KvYeu1TmifRy7aFBnyzDpLNex2Zq6+g23eu0AjJ/RsgWzdQkS99B3MAhp+WceAbF7pU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788894739; c=relaxed/simple;
	bh=j5OkgUwrZOnLPXHXvDBm1cPD3fSAXleLRA18N90r+sU=;
	h=Date:To:From:Subject:Message-Id; b=JJ7BrrWFj9YxPAyZGu+E5lQviHEtzIh3fjPQK51jpW7CRgL38Snp25dV0O+d3sZgNDCYjUPv1tCRoNfNBLarO5XNWJCNh+ggHtSDeGNqXS98K2xYCAv5fDmCzXjT3xhkWn0A/wxMVq7JgDB+sD1GX5U2cTIWg6cGbdcwgKzhvUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tyH88lqY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tyH88lqY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC35F1F00A3A;
	Tue,  8 Sep 2026 19:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788894736;
	bh=TpGE+BeyJxmmTMCXnAg9IZA4K1gYc6Iacs0bIYXPKw0=;
	h=Date:To:From:Subject;
	b=tyH88lqY1xkg/js8AiRzAffAvepVDWzNv2HpB9uslIZ5OsHY8tDAyYKIL6Jzc1ROZ
	 /oT5sPVaNsv00uVjUXjzLWrxH2Kj6Dq9VCuDlB71kOwGaVLZdgiWE45FgzLpmiSbb7
	 yGl2yVthSVPqcdovlnHRuf5bdjkJsz52ceKuDcJM=
Date: Tue, 08 Sep 2026 12:12:16 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,gourry@gourry.net,david@kernel.org,zenghui.yu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-size-truncation-in-pagemap_ioctl-test.patch added to mm-new branch
Message-Id: <20260908191216.BC35F1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: fix size truncation in pagemap_ioctl test
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-fix-size-truncation-in-pagemap_ioctl-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-size-truncation-in-pagemap_ioctl-test.patch

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
From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
Subject: selftests/mm: fix size truncation in pagemap_ioctl test
Date: Tue, 8 Sep 2026 21:41:15 +0800

Patch series "selftests/mm: pagemap_ioctl test fixes and cleanups", v2.

This series fixes a size truncation bug in the pagemap_ioctl test that
breaks it on arm64 systems with 64K base pages, and applies two small
cleanups suggested during the review of the fix.


This patch (of 3):

On arm64 with 64K base pages, the huge page size is 512 MiB, and
hpage_unit_tests() builds a 5 GiB range (10 * 512 MiB) for its tests. 
This exceeds the range of the int size parameters of gethugepage(),
wp_addr_range() and pagemap_ioctl().  The implicit truncation to 1 GiB
makes gethugepage() allocate a too small buffer, while the callers keep
operating on the original 5 GiB range, resulting in spurious failures or
SIGSEGV.

Fix the truncation by changing those size parameters to size_t, and for
consistency, also convert the remaining size-related parameters and
variables that use int, long or unsigned long long to size_t.

Link: https://lore.kernel.org/20260908134117.84405-1-zenghui.yu@linux.dev
Link: https://lore.kernel.org/20260908134117.84405-2-zenghui.yu@linux.dev
Fixes: 46fd75d4a3c9 ("selftests: mm: add pagemap ioctl tests")
Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
Assisted-by: GLM-5.3 OpenCode
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Gregory Price <gourry@gourry.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/pagemap_ioctl.c |   55 ++++++++++---------
 1 file changed, 29 insertions(+), 26 deletions(-)

--- a/tools/testing/selftests/mm/pagemap_ioctl.c~selftests-mm-fix-size-truncation-in-pagemap_ioctl-test
+++ a/tools/testing/selftests/mm/pagemap_ioctl.c
@@ -43,7 +43,7 @@ const char *progname;
 
 #define LEN(region)	((region.end - region.start)/page_size)
 
-static long pagemap_ioctl(void *start, int len, void *vec, int vec_len, int flag,
+static long pagemap_ioctl(void *start, size_t len, void *vec, size_t vec_len, int flag,
 			  int max_pages, long required_mask, long anyof_mask, long excluded_mask,
 			  long return_mask)
 {
@@ -64,7 +64,7 @@ static long pagemap_ioctl(void *start, i
 	return ioctl(pagemap_fd, PAGEMAP_SCAN, &arg);
 }
 
-static long pagemap_ioc(void *start, int len, void *vec, int vec_len, int flag,
+static long pagemap_ioc(void *start, size_t len, void *vec, size_t vec_len, int flag,
 			int max_pages, long required_mask, long anyof_mask, long excluded_mask,
 			long return_mask, long *walk_end)
 {
@@ -115,7 +115,7 @@ int init_uffd(void)
 	return 0;
 }
 
-int wp_init(void *addr, long size)
+int wp_init(void *addr, size_t size)
 {
 	struct uffdio_register uffdio_register;
 	struct uffdio_writeprotect wp;
@@ -139,7 +139,7 @@ int wp_init(void *addr, long size)
 	return 0;
 }
 
-int wp_free(void *addr, long size)
+int wp_free(void *addr, size_t size)
 {
 	struct uffdio_register uffdio_register;
 
@@ -151,7 +151,7 @@ int wp_free(void *addr, long size)
 	return 0;
 }
 
-int wp_addr_range(void *addr, int size)
+int wp_addr_range(void *addr, size_t size)
 {
 	if (pagemap_ioctl(addr, size, NULL, 0,
 			  PM_SCAN_WP_MATCHING | PM_SCAN_CHECK_WPASYNC,
@@ -161,7 +161,7 @@ int wp_addr_range(void *addr, int size)
 	return 0;
 }
 
-void *gethugetlb_mem(int size, int *shmid)
+void *gethugetlb_mem(size_t size, int *shmid)
 {
 	char *mem;
 
@@ -187,7 +187,8 @@ void *gethugetlb_mem(int size, int *shmi
 
 int userfaultfd_tests(void)
 {
-	long mem_size, vec_size, written, num_pages = 16;
+	size_t mem_size, vec_size, num_pages = 16;
+	long written;
 	char *mem, *vec;
 
 	mem_size = num_pages * page_size;
@@ -228,9 +229,10 @@ int userfaultfd_tests(void)
 	return 0;
 }
 
-int get_reads(struct page_region *vec, int vec_size)
+int get_reads(struct page_region *vec, size_t vec_size)
 {
-	int i, sum = 0;
+	size_t i;
+	int sum = 0;
 
 	for (i = 0; i < vec_size; i++)
 		sum += LEN(vec[i]);
@@ -240,7 +242,7 @@ int get_reads(struct page_region *vec, i
 
 int sanity_tests_sd(void)
 {
-	unsigned long long mem_size, vec_size, i, total_pages = 0;
+	size_t mem_size, vec_size, i, total_pages = 0;
 	long ret, ret2, ret3;
 	int num_pages = 1000;
 	int total_writes, total_reads, reads, count;
@@ -330,7 +332,7 @@ int sanity_tests_sd(void)
 	if (ret < 0)
 		ksft_exit_fail_msg("error %ld %d %s\n", ret, errno, strerror(errno));
 
-	ksft_test_result((unsigned long long)ret == mem_size/(page_size * 2),
+	ksft_test_result((size_t)ret == mem_size/(page_size * 2),
 			 "%s Repeated pattern of written and non-written pages\n", __func__);
 
 	/* 4. Repeated pattern of written and non-written pages in parts */
@@ -681,9 +683,9 @@ int sanity_tests_sd(void)
 	return 0;
 }
 
-int base_tests(char *prefix, char *mem, unsigned long long mem_size, int skip)
+int base_tests(char *prefix, char *mem, size_t mem_size, int skip)
 {
-	unsigned long long vec_size;
+	size_t vec_size;
 	int written;
 	struct page_region *vec, *vec2;
 
@@ -786,7 +788,7 @@ int base_tests(char *prefix, char *mem,
 	return 0;
 }
 
-void *gethugepage(int map_size)
+void *gethugepage(size_t map_size)
 {
 	int ret;
 	char *map;
@@ -809,8 +811,8 @@ int hpage_unit_tests(void)
 	char *map;
 	int ret, ret2;
 	size_t num_pages = 10;
-	unsigned long long map_size = hpage_size * num_pages;
-	unsigned long long vec_size = map_size/page_size;
+	size_t map_size = hpage_size * num_pages;
+	size_t vec_size = map_size/page_size;
 	struct page_region *vec, *vec2;
 
 	vec = calloc(vec_size, sizeof(struct page_region));
@@ -1001,8 +1003,9 @@ int hpage_unit_tests(void)
 int unmapped_region_tests(void)
 {
 	void *start = (void *)0x10000000;
-	int written, len = 0x00040000;
-	long vec_size = len / page_size;
+	int written;
+	size_t len = 0x00040000;
+	size_t vec_size = len / page_size;
 	struct page_region *vec = calloc(vec_size, sizeof(struct page_region));
 	if (!vec)
 		ksft_exit_fail_msg("error nomem\n");
@@ -1071,7 +1074,7 @@ static void test_simple(void)
  * with no page table, exercising pagemap_scan_pte_hole(); a base-page range
  * leaves pte_none entries.
  */
-static void unpopulated_written_test(const char *name, char *mem, long size,
+static void unpopulated_written_test(const char *name, char *mem, size_t size,
 				     bool use_thp)
 {
 	long npages = size / page_size, fast = 0, slow = 0, ret;
@@ -1114,7 +1117,7 @@ out:
 
 static void unpopulated_scan_test(void)
 {
-	long mem_size = 16 * page_size;
+	size_t mem_size = 16 * page_size;
 	char *mem;
 
 	mem = mmap(NULL, mem_size, PROT_READ | PROT_WRITE,
@@ -1156,8 +1159,8 @@ static void unpopulated_thp_scan_test(vo
 
 int sanity_tests(void)
 {
-	unsigned long long mem_size, vec_size;
-	long ret, fd, i, buf_size, nr_pages;
+	size_t mem_size, vec_size, i, buf_size;
+	long ret, fd, nr_pages;
 	struct page_region *vec;
 	char *mem, *fmem;
 	struct stat sbuf;
@@ -1581,9 +1584,9 @@ static void transact_test(int page_size)
 
 void zeropfn_tests(void)
 {
-	unsigned long long mem_size;
+	size_t mem_size, i;
 	struct page_region vec;
-	int i, ret;
+	int ret;
 	char *mmap_mem, *mem;
 
 	/* Test with normal memory */
@@ -1641,8 +1644,8 @@ void zeropfn_tests(void)
 
 int main(int __attribute__((unused)) argc, char *argv[])
 {
-	int shmid, buf_size, fd, i, ret;
-	unsigned long long mem_size;
+	int shmid, fd, ret;
+	size_t mem_size, buf_size, i;
 	char *mem, *map, *fmem;
 	struct stat sbuf;
 
_

Patches currently in -mm which might be from zenghui.yu@linux.dev are

selftests-mm-fix-incorrect-skip-output-in-pkey_sighandler_tests.patch
mm-damon-core-remove-declaration-of-__damon_commit_ctx.patch
selftests-mm-remove-unreachable-returns-after-ksft-exit-helpers.patch
docs-mm-damon-design-fix-broken-ref-usage-and-a-typo.patch
selftests-mm-fix-size-truncation-in-pagemap_ioctl-test.patch
selftests-mm-mark-file-local-symbols-of-pagemap_ioctlc-static.patch
selftests-mm-init-page-sizes-early-in-pagemap_ioctl-test.patch

