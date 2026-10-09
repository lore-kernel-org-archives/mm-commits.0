Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82E263F9A13
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525450; cv=none; b=hcVIIFQD2kPItau/KyyHstNKTDvVFDHdOOHmDy5B9I6kOsQVz3FvFWomu1LfERY5eclH3AHvAJ0h+6UfTbvJe6FDDzvpc4QluE6J6SwpGyZjorLlfiQFjgH/SFg49oaXsF3ujPPCeisN3t9Mdb9IWQ61lM7erKMNG4mfMDRM0Ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525450; c=relaxed/simple;
	bh=DQkD0DcMdLlapJqNX7iedoJN+kg9dsU3kVxgA+wHrns=;
	h=Date:To:From:Subject:Message-Id; b=qeXRndtQycgL/Wr4qrTPxM/baCYMDMyXviXfw2gGt3SFns1MuvlgoAsKKfB57HGTxoWtEm9k6UFdFKuXnvOJ52Mc9MXAK82YaEEi/Ws3oeRLoft68xseis7uyL6mkirAzZ9QqBXFdQhvZBrR4kTprr9nJCJKdqYAncu/GrGGw7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=o2NiFZSN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="o2NiFZSN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 592DA1F00893;
	Fri,  9 Oct 2026 05:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525449;
	bh=FUeZco7CexD5baPPgkvLLtKj5f1SLRbpY+/SBJ7Fq9Y=;
	h=Date:To:From:Subject;
	b=o2NiFZSN47PZK0sryLuCMcAYmDghd4Ng6n2UfXYyHdNj7Eelxge+qaO+YvKFRAjx+
	 6+duAMJ+qwfIm1oMITJQRpEng7uiPbSGvpEqemv75vLUirWRU7aYjOgHzQGNXtblDy
	 fWnGehQbHjhpY/8JjOti/OGRcCcucfWLd+k6sXqg=
Date: Thu, 08 Oct 2026 22:57:28 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,gourry@gourry.net,david@kernel.org,zenghui.yu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-mark-file-local-symbols-of-pagemap_ioctlc-static.patch removed from -mm tree
Message-Id: <20261009055729.592DA1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: mark file-local symbols of pagemap_ioctl.c static
has been removed from the -mm tree.  Its filename was
     selftests-mm-mark-file-local-symbols-of-pagemap_ioctlc-static.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
Subject: selftests/mm: mark file-local symbols of pagemap_ioctl.c static
Date: Tue, 8 Sep 2026 21:43:14 +0800

The file-scope variables (pagemap_fd, uffd, page_size, hpage_size and
progname) and most functions of the pagemap_ioctl test are only used
locally, but lack the static storage class.  Mark them static so that the
compiler can catch accidental outer references.

Link: https://lore.kernel.org/20260908134315.84431-1-zenghui.yu@linux.dev
Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Gregory Price <gourry@gourry.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 tools/testing/selftests/mm/pagemap_ioctl.c |   43 +++++++++----------
 1 file changed, 21 insertions(+), 22 deletions(-)

--- a/tools/testing/selftests/mm/pagemap_ioctl.c~selftests-mm-mark-file-local-symbols-of-pagemap_ioctlc-static
+++ a/tools/testing/selftests/mm/pagemap_ioctl.c
@@ -36,11 +36,11 @@
 
 #define TEST_ITERATIONS 100
 #define PAGEMAP "/proc/self/pagemap"
-int pagemap_fd;
-int uffd;
-size_t page_size;
-size_t hpage_size;
-const char *progname;
+static int pagemap_fd;
+static int uffd;
+static size_t page_size;
+static size_t hpage_size;
+static const char *progname;
 
 #define LEN(region)	((region.end - region.start)/page_size)
 
@@ -92,8 +92,7 @@ static long pagemap_ioc(void *start, siz
 	return ret;
 }
 
-
-int init_uffd(void)
+static int init_uffd(void)
 {
 	struct uffdio_api uffdio_api;
 
@@ -116,7 +115,7 @@ int init_uffd(void)
 	return 0;
 }
 
-int wp_init(void *addr, size_t size)
+static int wp_init(void *addr, size_t size)
 {
 	struct uffdio_register uffdio_register;
 	struct uffdio_writeprotect wp;
@@ -140,7 +139,7 @@ int wp_init(void *addr, size_t size)
 	return 0;
 }
 
-int wp_free(void *addr, size_t size)
+static int wp_free(void *addr, size_t size)
 {
 	struct uffdio_register uffdio_register;
 
@@ -152,7 +151,7 @@ int wp_free(void *addr, size_t size)
 	return 0;
 }
 
-int wp_addr_range(void *addr, size_t size)
+static int wp_addr_range(void *addr, size_t size)
 {
 	if (pagemap_ioctl(addr, size, NULL, 0,
 			  PM_SCAN_WP_MATCHING | PM_SCAN_CHECK_WPASYNC,
@@ -162,7 +161,7 @@ int wp_addr_range(void *addr, size_t siz
 	return 0;
 }
 
-void *gethugetlb_mem(size_t size, int *shmid)
+static void *gethugetlb_mem(size_t size, int *shmid)
 {
 	char *mem;
 
@@ -186,7 +185,7 @@ void *gethugetlb_mem(size_t size, int *s
 	return mem;
 }
 
-int userfaultfd_tests(void)
+static int userfaultfd_tests(void)
 {
 	size_t mem_size, vec_size, num_pages = 16;
 	long written;
@@ -230,7 +229,7 @@ int userfaultfd_tests(void)
 	return 0;
 }
 
-int get_reads(struct page_region *vec, size_t vec_size)
+static int get_reads(struct page_region *vec, size_t vec_size)
 {
 	size_t i;
 	int sum = 0;
@@ -241,7 +240,7 @@ int get_reads(struct page_region *vec, s
 	return sum;
 }
 
-int sanity_tests_sd(void)
+static int sanity_tests_sd(void)
 {
 	size_t mem_size, vec_size, i, total_pages = 0;
 	long ret, ret2, ret3;
@@ -684,7 +683,7 @@ int sanity_tests_sd(void)
 	return 0;
 }
 
-int base_tests(char *prefix, char *mem, size_t mem_size, int skip)
+static int base_tests(char *prefix, char *mem, size_t mem_size, int skip)
 {
 	size_t vec_size;
 	int written;
@@ -789,7 +788,7 @@ int base_tests(char *prefix, char *mem,
 	return 0;
 }
 
-void *gethugepage(size_t map_size)
+static void *gethugepage(size_t map_size)
 {
 	int ret;
 	char *map;
@@ -807,7 +806,7 @@ void *gethugepage(size_t map_size)
 	return map;
 }
 
-int hpage_unit_tests(void)
+static int hpage_unit_tests(void)
 {
 	char *map;
 	int ret, ret2;
@@ -1001,7 +1000,7 @@ int hpage_unit_tests(void)
 	return 0;
 }
 
-int unmapped_region_tests(void)
+static int unmapped_region_tests(void)
 {
 	void *start = (void *)0x10000000;
 	int written;
@@ -1158,7 +1157,7 @@ static void unpopulated_thp_scan_test(vo
 	munmap(area, 2 * hpage_size);
 }
 
-int sanity_tests(void)
+static int sanity_tests(void)
 {
 	size_t mem_size, vec_size, i, buf_size;
 	long ret, fd, nr_pages;
@@ -1330,7 +1329,7 @@ int sanity_tests(void)
 	return 0;
 }
 
-int mprotect_tests(void)
+static int mprotect_tests(void)
 {
 	int ret;
 	char *mem, *mem2;
@@ -1450,7 +1449,7 @@ static ssize_t get_dirty_pages_reset(cha
 	return cnt;
 }
 
-void *thread_proc(void *mem)
+static void *thread_proc(void *mem)
 {
 	int *m = mem;
 	long curr_faults, faults;
@@ -1583,7 +1582,7 @@ static void transact_test(int page_size)
 			      extra_thread_faults);
 }
 
-void zeropfn_tests(void)
+static void zeropfn_tests(void)
 {
 	size_t mem_size, i;
 	struct page_region vec;
_

Patches currently in -mm which might be from zenghui.yu@linux.dev are

selftests-damon-stop-kdamond-on-error-exits-of-no-op-commit-test.patch
selftests-damon-ignore-test-generated-damon_dump_output.patch
mm-damon-api-remove-unused-nr_damos_-enumerators.patch

