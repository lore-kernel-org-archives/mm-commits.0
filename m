Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60A713FC5B7
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525449; cv=none; b=BnrvJ2vo0vtxSTch/Zaoa+XWxtACl6XkcJsVAFYI3GrIJ0gFc4lKIU3iEBtMM8Ao5J6O4MSduBctDRfGizcNJ8o5ti6NkSZS1QDYmSxXQZtpYlXR5bbUSYjdJ6h6j/wThWIjOPL+B4Zl5IOBhBchnJB5CvLr484KM9RXjeb3IHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525449; c=relaxed/simple;
	bh=5nizga+4zJuJuVQ267mWHNGdNd6X4KjN8YvmQn6kAHI=;
	h=Date:To:From:Subject:Message-Id; b=u4ZDDm7zaFP4T95XsKCVERNTvWToE0adlLvQtTeY342d9wb5G2GjZb9G00H/i6vjBSiFvErymcKiDH7SFv5N2C67BgsXesLKdpOcc9y1hiakHjvnKnbvVKjOnON+1YX5Rigse1N9Z+cJMgyN9EO8nVvVEzYDaNFBMxsOs3jws2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hEp0z9gh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hEp0z9gh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34C451F000FF;
	Fri,  9 Oct 2026 05:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525448;
	bh=TCFk2tO7kz3x6X0y8Z4Arh5+E9IpuzS3wHLd97vfx8w=;
	h=Date:To:From:Subject;
	b=hEp0z9ghuZwR0T2hbPE6nfQcNGndBI2LRjvIj4/qQ3+LfxZX9r8SjI5rpgWmriPXV
	 7SNAhkQF70Fmgbj99YkBB5GdKAoVWiLpzfBnSvlqAcJMvGFLHYCU/tsEm2hAuFGMzO
	 ZPO0qdaZ7Lncv444uB0Kjas6MFrGYZmPA+VdImSc=
Date: Thu, 08 Oct 2026 22:57:27 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,gourry@gourry.net,david@kernel.org,zenghui.yu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-fix-size-truncation-in-pagemap_ioctl-test.patch removed from -mm tree
Message-Id: <20261009055728.34C451F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: fix size truncation in pagemap_ioctl test
has been removed from the -mm tree.  Its filename was
     selftests-mm-fix-size-truncation-in-pagemap_ioctl-test.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Assisted-by: GLM-5.3 OpenCode
Cc: Gregory Price <gourry@gourry.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 tools/testing/selftests/mm/pagemap_ioctl.c |   55 ++++++++++---------
 1 file changed, 29 insertions(+), 26 deletions(-)

--- a/tools/testing/selftests/mm/pagemap_ioctl.c~selftests-mm-fix-size-truncation-in-pagemap_ioctl-test
+++ a/tools/testing/selftests/mm/pagemap_ioctl.c
@@ -44,7 +44,7 @@ const char *progname;
 
 #define LEN(region)	((region.end - region.start)/page_size)
 
-static long pagemap_ioctl(void *start, int len, void *vec, int vec_len, int flag,
+static long pagemap_ioctl(void *start, size_t len, void *vec, size_t vec_len, int flag,
 			  int max_pages, long required_mask, long anyof_mask, long excluded_mask,
 			  long return_mask)
 {
@@ -65,7 +65,7 @@ static long pagemap_ioctl(void *start, i
 	return ioctl(pagemap_fd, PAGEMAP_SCAN, &arg);
 }
 
-static long pagemap_ioc(void *start, int len, void *vec, int vec_len, int flag,
+static long pagemap_ioc(void *start, size_t len, void *vec, size_t vec_len, int flag,
 			int max_pages, long required_mask, long anyof_mask, long excluded_mask,
 			long return_mask, long *walk_end)
 {
@@ -116,7 +116,7 @@ int init_uffd(void)
 	return 0;
 }
 
-int wp_init(void *addr, long size)
+int wp_init(void *addr, size_t size)
 {
 	struct uffdio_register uffdio_register;
 	struct uffdio_writeprotect wp;
@@ -140,7 +140,7 @@ int wp_init(void *addr, long size)
 	return 0;
 }
 
-int wp_free(void *addr, long size)
+int wp_free(void *addr, size_t size)
 {
 	struct uffdio_register uffdio_register;
 
@@ -152,7 +152,7 @@ int wp_free(void *addr, long size)
 	return 0;
 }
 
-int wp_addr_range(void *addr, int size)
+int wp_addr_range(void *addr, size_t size)
 {
 	if (pagemap_ioctl(addr, size, NULL, 0,
 			  PM_SCAN_WP_MATCHING | PM_SCAN_CHECK_WPASYNC,
@@ -162,7 +162,7 @@ int wp_addr_range(void *addr, int size)
 	return 0;
 }
 
-void *gethugetlb_mem(int size, int *shmid)
+void *gethugetlb_mem(size_t size, int *shmid)
 {
 	char *mem;
 
@@ -188,7 +188,8 @@ void *gethugetlb_mem(int size, int *shmi
 
 int userfaultfd_tests(void)
 {
-	long mem_size, vec_size, written, num_pages = 16;
+	size_t mem_size, vec_size, num_pages = 16;
+	long written;
 	char *mem, *vec;
 
 	mem_size = num_pages * page_size;
@@ -229,9 +230,10 @@ int userfaultfd_tests(void)
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
@@ -241,7 +243,7 @@ int get_reads(struct page_region *vec, i
 
 int sanity_tests_sd(void)
 {
-	unsigned long long mem_size, vec_size, i, total_pages = 0;
+	size_t mem_size, vec_size, i, total_pages = 0;
 	long ret, ret2, ret3;
 	int num_pages = 1000;
 	int total_writes, total_reads, reads, count;
@@ -331,7 +333,7 @@ int sanity_tests_sd(void)
 	if (ret < 0)
 		ksft_exit_fail_msg("error %ld %d %s\n", ret, errno, strerror(errno));
 
-	ksft_test_result((unsigned long long)ret == mem_size/(page_size * 2),
+	ksft_test_result((size_t)ret == mem_size/(page_size * 2),
 			 "%s Repeated pattern of written and non-written pages\n", __func__);
 
 	/* 4. Repeated pattern of written and non-written pages in parts */
@@ -682,9 +684,9 @@ int sanity_tests_sd(void)
 	return 0;
 }
 
-int base_tests(char *prefix, char *mem, unsigned long long mem_size, int skip)
+int base_tests(char *prefix, char *mem, size_t mem_size, int skip)
 {
-	unsigned long long vec_size;
+	size_t vec_size;
 	int written;
 	struct page_region *vec, *vec2;
 
@@ -787,7 +789,7 @@ int base_tests(char *prefix, char *mem,
 	return 0;
 }
 
-void *gethugepage(int map_size)
+void *gethugepage(size_t map_size)
 {
 	int ret;
 	char *map;
@@ -810,8 +812,8 @@ int hpage_unit_tests(void)
 	char *map;
 	int ret, ret2;
 	size_t num_pages = 10;
-	unsigned long long map_size = hpage_size * num_pages;
-	unsigned long long vec_size = map_size/page_size;
+	size_t map_size = hpage_size * num_pages;
+	size_t vec_size = map_size/page_size;
 	struct page_region *vec, *vec2;
 
 	vec = calloc(vec_size, sizeof(struct page_region));
@@ -1002,8 +1004,9 @@ int hpage_unit_tests(void)
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
@@ -1072,7 +1075,7 @@ static void test_simple(void)
  * with no page table, exercising pagemap_scan_pte_hole(); a base-page range
  * leaves pte_none entries.
  */
-static void unpopulated_written_test(const char *name, char *mem, long size,
+static void unpopulated_written_test(const char *name, char *mem, size_t size,
 				     bool use_thp)
 {
 	long npages = size / page_size, fast = 0, slow = 0, ret;
@@ -1115,7 +1118,7 @@ out:
 
 static void unpopulated_scan_test(void)
 {
-	long mem_size = 16 * page_size;
+	size_t mem_size = 16 * page_size;
 	char *mem;
 
 	mem = mmap(NULL, mem_size, PROT_READ | PROT_WRITE,
@@ -1157,8 +1160,8 @@ static void unpopulated_thp_scan_test(vo
 
 int sanity_tests(void)
 {
-	unsigned long long mem_size, vec_size;
-	long ret, fd, i, buf_size, nr_pages;
+	size_t mem_size, vec_size, i, buf_size;
+	long ret, fd, nr_pages;
 	struct page_region *vec;
 	char *mem, *fmem;
 	struct stat sbuf;
@@ -1582,9 +1585,9 @@ static void transact_test(int page_size)
 
 void zeropfn_tests(void)
 {
-	unsigned long long mem_size;
+	size_t mem_size, i;
 	struct page_region vec;
-	int i, ret;
+	int ret;
 	char *mmap_mem, *mem;
 
 	/* Test with normal memory */
@@ -1642,8 +1645,8 @@ void zeropfn_tests(void)
 
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

selftests-damon-stop-kdamond-on-error-exits-of-no-op-commit-test.patch
selftests-damon-ignore-test-generated-damon_dump_output.patch
mm-damon-api-remove-unused-nr_damos_-enumerators.patch

