Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 710F059E329
	for <mm-commits@vger.kernel.org>; Tue,  8 Sep 2026 19:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788894741; cv=none; b=QuvUzd9Y25RLb0rP+5DSrSmQNvIpAgxQc+bANYXWyYgAUCr4XK3b4NhaMy6mTL1Ott1KpSEXSNmF+aXD8IbdeKCGyos72uzknLI3sS0VjlRzbHtoli2or77F2nAtjQZGdUjaZF9GX2BPclhRwcF3Lh6oAXVcBiCxEQ3Qsi/+In4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788894741; c=relaxed/simple;
	bh=93YnWemCO+e6QpnF/BZdqxyVk39OdeWRYPr3tJGWvdE=;
	h=Date:To:From:Subject:Message-Id; b=huE44cBNTV7EHQkitCLZZN3fGJ3m0RgXwkQ+6lqnJE8VonMxlcfmbTGYZjjE1P1r1KCe15Jk7uC3P6GJrasa0kQmopU6cddzfh7DDE/TCDz3t1AHWVgUJkc+6F0IgSx/acaXq1y+mXENkrgGcWqQ1akhY6c1yPe0mGlxV2XTjTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Dj0W+sl4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Dj0W+sl4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E57FC1F00A3D;
	Tue,  8 Sep 2026 19:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788894739;
	bh=6MbO78/6yg521GxUPM0qKLzc/LV7eMNgW0IfpDoVdm4=;
	h=Date:To:From:Subject;
	b=Dj0W+sl4K/m5S4wtupmu1u+DtY+jJ1/k0Ts/ybRt/eYOjUsXim9UvCZsmzoY1uiPU
	 V/64QIxPS4JzaV2MXaSishiqa37vnIxM5jq6Nof1akDEZN/Oj5pPt1uK3HGLmuTRLp
	 bigavZ4k3TqkkBrhGAQx4JJYm2+QLK0jm3ggUO1A=
Date: Tue, 08 Sep 2026 12:12:18 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,gourry@gourry.net,david@kernel.org,zenghui.yu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-mark-file-local-symbols-of-pagemap_ioctlc-static.patch added to mm-new branch
Message-Id: <20260908191218.E57FC1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: mark file-local symbols of pagemap_ioctl.c static
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-mark-file-local-symbols-of-pagemap_ioctlc-static.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-mark-file-local-symbols-of-pagemap_ioctlc-static.patch

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
Subject: selftests/mm: mark file-local symbols of pagemap_ioctl.c static
Date: Tue, 8 Sep 2026 21:43:14 +0800

The file-scope variables (pagemap_fd, uffd, page_size, hpage_size and
progname) and most functions of the pagemap_ioctl test are only used
locally, but lack the static storage class.  Mark them static so that the
compiler can catch accidental outer references.

Link: https://lore.kernel.org/20260908134315.84431-1-zenghui.yu@linux.dev
Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
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

 tools/testing/selftests/mm/pagemap_ioctl.c |   43 +++++++++----------
 1 file changed, 21 insertions(+), 22 deletions(-)

--- a/tools/testing/selftests/mm/pagemap_ioctl.c~selftests-mm-mark-file-local-symbols-of-pagemap_ioctlc-static
+++ a/tools/testing/selftests/mm/pagemap_ioctl.c
@@ -35,11 +35,11 @@
 
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
 
@@ -91,8 +91,7 @@ static long pagemap_ioc(void *start, siz
 	return ret;
 }
 
-
-int init_uffd(void)
+static int init_uffd(void)
 {
 	struct uffdio_api uffdio_api;
 
@@ -115,7 +114,7 @@ int init_uffd(void)
 	return 0;
 }
 
-int wp_init(void *addr, size_t size)
+static int wp_init(void *addr, size_t size)
 {
 	struct uffdio_register uffdio_register;
 	struct uffdio_writeprotect wp;
@@ -139,7 +138,7 @@ int wp_init(void *addr, size_t size)
 	return 0;
 }
 
-int wp_free(void *addr, size_t size)
+static int wp_free(void *addr, size_t size)
 {
 	struct uffdio_register uffdio_register;
 
@@ -151,7 +150,7 @@ int wp_free(void *addr, size_t size)
 	return 0;
 }
 
-int wp_addr_range(void *addr, size_t size)
+static int wp_addr_range(void *addr, size_t size)
 {
 	if (pagemap_ioctl(addr, size, NULL, 0,
 			  PM_SCAN_WP_MATCHING | PM_SCAN_CHECK_WPASYNC,
@@ -161,7 +160,7 @@ int wp_addr_range(void *addr, size_t siz
 	return 0;
 }
 
-void *gethugetlb_mem(size_t size, int *shmid)
+static void *gethugetlb_mem(size_t size, int *shmid)
 {
 	char *mem;
 
@@ -185,7 +184,7 @@ void *gethugetlb_mem(size_t size, int *s
 	return mem;
 }
 
-int userfaultfd_tests(void)
+static int userfaultfd_tests(void)
 {
 	size_t mem_size, vec_size, num_pages = 16;
 	long written;
@@ -229,7 +228,7 @@ int userfaultfd_tests(void)
 	return 0;
 }
 
-int get_reads(struct page_region *vec, size_t vec_size)
+static int get_reads(struct page_region *vec, size_t vec_size)
 {
 	size_t i;
 	int sum = 0;
@@ -240,7 +239,7 @@ int get_reads(struct page_region *vec, s
 	return sum;
 }
 
-int sanity_tests_sd(void)
+static int sanity_tests_sd(void)
 {
 	size_t mem_size, vec_size, i, total_pages = 0;
 	long ret, ret2, ret3;
@@ -683,7 +682,7 @@ int sanity_tests_sd(void)
 	return 0;
 }
 
-int base_tests(char *prefix, char *mem, size_t mem_size, int skip)
+static int base_tests(char *prefix, char *mem, size_t mem_size, int skip)
 {
 	size_t vec_size;
 	int written;
@@ -788,7 +787,7 @@ int base_tests(char *prefix, char *mem,
 	return 0;
 }
 
-void *gethugepage(size_t map_size)
+static void *gethugepage(size_t map_size)
 {
 	int ret;
 	char *map;
@@ -806,7 +805,7 @@ void *gethugepage(size_t map_size)
 	return map;
 }
 
-int hpage_unit_tests(void)
+static int hpage_unit_tests(void)
 {
 	char *map;
 	int ret, ret2;
@@ -1000,7 +999,7 @@ int hpage_unit_tests(void)
 	return 0;
 }
 
-int unmapped_region_tests(void)
+static int unmapped_region_tests(void)
 {
 	void *start = (void *)0x10000000;
 	int written;
@@ -1157,7 +1156,7 @@ static void unpopulated_thp_scan_test(vo
 	munmap(area, 2 * hpage_size);
 }
 
-int sanity_tests(void)
+static int sanity_tests(void)
 {
 	size_t mem_size, vec_size, i, buf_size;
 	long ret, fd, nr_pages;
@@ -1329,7 +1328,7 @@ int sanity_tests(void)
 	return 0;
 }
 
-int mprotect_tests(void)
+static int mprotect_tests(void)
 {
 	int ret;
 	char *mem, *mem2;
@@ -1449,7 +1448,7 @@ static ssize_t get_dirty_pages_reset(cha
 	return cnt;
 }
 
-void *thread_proc(void *mem)
+static void *thread_proc(void *mem)
 {
 	int *m = mem;
 	long curr_faults, faults;
@@ -1582,7 +1581,7 @@ static void transact_test(int page_size)
 			      extra_thread_faults);
 }
 
-void zeropfn_tests(void)
+static void zeropfn_tests(void)
 {
 	size_t mem_size, i;
 	struct page_region vec;
_

Patches currently in -mm which might be from zenghui.yu@linux.dev are

selftests-mm-fix-incorrect-skip-output-in-pkey_sighandler_tests.patch
mm-damon-core-remove-declaration-of-__damon_commit_ctx.patch
selftests-mm-remove-unreachable-returns-after-ksft-exit-helpers.patch
docs-mm-damon-design-fix-broken-ref-usage-and-a-typo.patch
selftests-mm-fix-size-truncation-in-pagemap_ioctl-test.patch
selftests-mm-mark-file-local-symbols-of-pagemap_ioctlc-static.patch
selftests-mm-init-page-sizes-early-in-pagemap_ioctl-test.patch

