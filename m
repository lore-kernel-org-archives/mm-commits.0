Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 140AF36F8EA
	for <mm-commits@vger.kernel.org>; Sun, 21 Jun 2026 18:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782067181; cv=none; b=GQpQlmb+0xeKC8ZLWp0GDNI+zCxCENMYNkSq0iWAbbMSYrtQUL4tbcaSSXSVInGOYAdhGe4enqPWDv3an/OoNRB97LnhCSSahDYyWVEGKotWVrJ41pqTP3nanuzmz/0qmNUwJiey7dAi0tShZtp2v4LPFbJaLI9vmcPDns+gTUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782067181; c=relaxed/simple;
	bh=roR4+9QKDtjXWKI8Y1vIgxl07dU4wcb5BiKzFz4gw7w=;
	h=Date:To:From:Subject:Message-Id; b=NTbRzyTwzZNv3P+HNUoHtarmq1gGfjq2+D9gjeii7OTNmdvxWswOVubJzbKD9nFpwhXCaVGulAdE1bCwJi7/rcAV07qWODR2IJWqSfhVsryYz4qazRwT5WGDXxYo7xgEIkpKsGdWPA1v9Mojsy0ns1WcWtReFLCG4iBmgOdX5PI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=z53qPyoJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="z53qPyoJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1A2B1F00A3A;
	Sun, 21 Jun 2026 18:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782067180;
	bh=2bGYvujwwqCZsgzOLRyD2Hk0gNvRU+22ia/yO5VX9Zk=;
	h=Date:To:From:Subject;
	b=z53qPyoJ4Jt9Tjy/6fFCTg3KWJZYi5GGik78iFRJ/lsXwRQYaHOGWxZxfyCaQZCow
	 ot2ub8lcGDXtSA8d2K08ZHiWpeWzf09K/IeesI2D5TNHcvmdac/cNvmLhr3g9OXuBe
	 /eriqGRSOR/cX6S/IoPOkeSFUD1nIw+mAVj0dupA=
Date: Sun, 21 Jun 2026 11:39:39 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,sarthak.sharma@arm.com,ryan.roberts@arm.com,peterx@redhat.com,npache@redhat.com,mhocko@suse.com,luizcap@redhat.com,ljs@kernel.org,li.wang@linux.dev,liam@infradead.org,leon@kernel.org,lance.yang@linux.dev,jhubbard@nvidia.com,jgg@ziepe.ca,donettom@linux.ibm.com,dev.jain@arm.com,david@kernel.org,broonie@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-thuge-gen-add-setup-of-hugetlb-pages.patch removed from -mm tree
Message-Id: <20260621183939.E1A2B1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: thuge-gen: add setup of HugeTLB pages
has been removed from the -mm tree.  Its filename was
     selftests-mm-thuge-gen-add-setup-of-hugetlb-pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: selftests/mm: thuge-gen: add setup of HugeTLB pages
Date: Mon, 11 May 2026 19:28:32 +0300

thuge-gen skips tests if there are no free huge pages prepared by a
wrapper script and shm liimts in proc are too low.

Replace custom detection of huge pages with the library functions and add
setup of HugeTLB pages and shm limits to the test and make sure that the
original settings are restored on the test exit.

Link: https://lore.kernel.org/20260511162840.375890-49-rppt@kernel.org
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

 tools/testing/selftests/mm/thuge-gen.c |   95 ++---------------------
 1 file changed, 12 insertions(+), 83 deletions(-)

--- a/tools/testing/selftests/mm/thuge-gen.c~selftests-mm-thuge-gen-add-setup-of-hugetlb-pages
+++ a/tools/testing/selftests/mm/thuge-gen.c
@@ -1,17 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Test selecting other page sizes for mmap/shmget.
-
-   Before running this huge pages for each huge page size must have been
-   reserved.
-   For large pages beyond MAX_PAGE_ORDER (like 1GB on x86) boot options must
-   be used. 1GB wouldn't be tested if it isn't available.
-   Also shmmax must be increased.
-   And you need to run as root to work around some weird permissions in shm.
-   And nothing using huge pages should run in parallel.
-   When the program aborts you may need to clean up the shm segments with
-   ipcrm -m by hand, like this
-   sudo ipcs | awk '$1 == "0x00000000" {print $2}' | xargs -n1 sudo ipcrm -m
-   (warning this will remove all if someone else uses them) */
+/* Test selecting other page sizes for mmap/shmget. */
 
 #define _GNU_SOURCE
 #include <sys/mman.h>
@@ -21,8 +9,6 @@
 #include <sys/ipc.h>
 #include <sys/shm.h>
 #include <sys/stat.h>
-#include <glob.h>
-#include <assert.h>
 #include <unistd.h>
 #include <stdarg.h>
 #include <string.h>
@@ -38,15 +24,6 @@
 #ifndef SHM_HUGE_SHIFT
 #define SHM_HUGE_SHIFT  26
 #endif
-#ifndef SHM_HUGE_MASK
-#define SHM_HUGE_MASK   0x3f
-#endif
-#ifndef SHM_HUGE_2MB
-#define SHM_HUGE_2MB    (21 << SHM_HUGE_SHIFT)
-#endif
-#ifndef SHM_HUGE_1GB
-#define SHM_HUGE_1GB    (30 << SHM_HUGE_SHIFT)
-#endif
 
 #define NUM_PAGESIZES   5
 #define NUM_PAGES 4
@@ -64,32 +41,10 @@ int ilog2(unsigned long v)
 
 void show(unsigned long ps)
 {
-	char buf[100];
-
 	if (ps == getpagesize())
 		return;
 
-	ksft_print_msg("%luMB: ", ps >> 20);
-
-	fflush(stdout);
-	snprintf(buf, sizeof buf,
-		"cat /sys/kernel/mm/hugepages/hugepages-%lukB/free_hugepages",
-		ps >> 10);
-	system(buf);
-}
-
-unsigned long read_free(unsigned long ps)
-{
-	unsigned long val = 0;
-	char buf[100];
-
-	snprintf(buf, sizeof(buf),
-		 "/sys/kernel/mm/hugepages/hugepages-%lukB/free_hugepages",
-		 ps >> 10);
-	if (read_sysfs(buf, &val) && ps != getpagesize())
-		ksft_print_msg("missing %s\n", buf);
-
-	return val;
+	ksft_print_msg("%luMB: %lu\n", ps >> 20, hugetlb_free_pages(ps));
 }
 
 void test_mmap(unsigned long size, unsigned flags)
@@ -97,14 +52,14 @@ void test_mmap(unsigned long size, unsig
 	char *map;
 	unsigned long before, after;
 
-	before = read_free(size);
+	before = hugetlb_free_pages(size);
 	map = mmap(NULL, size*NUM_PAGES, PROT_READ|PROT_WRITE,
 			MAP_PRIVATE|MAP_ANONYMOUS|MAP_HUGETLB|flags, -1, 0);
 	if (map == MAP_FAILED)
 		ksft_exit_fail_msg("mmap: %s\n", strerror(errno));
 
 	memset(map, 0xff, size*NUM_PAGES);
-	after = read_free(size);
+	after = hugetlb_free_pages(size);
 
 	show(size);
 	ksft_test_result(size == getpagesize() || (before - after) == NUM_PAGES,
@@ -121,7 +76,7 @@ void test_shmget(unsigned long size, uns
 	struct shm_info i;
 	char *map;
 
-	before = read_free(size);
+	before = hugetlb_free_pages(size);
 	id = shmget(IPC_PRIVATE, size * NUM_PAGES, IPC_CREAT|0600|flags);
 	if (id < 0) {
 		if (errno == EPERM) {
@@ -142,7 +97,7 @@ void test_shmget(unsigned long size, uns
 	shmctl(id, IPC_RMID, NULL);
 
 	memset(map, 0xff, size*NUM_PAGES);
-	after = read_free(size);
+	after = hugetlb_free_pages(size);
 
 	show(size);
 	ksft_test_result(size == getpagesize() || (before - after) == NUM_PAGES,
@@ -154,43 +109,15 @@ void test_shmget(unsigned long size, uns
 void find_pagesizes(void)
 {
 	unsigned long largest = getpagesize();
-	unsigned long shmmax_val = 0;
 	int i;
-	glob_t g;
 
-	glob("/sys/kernel/mm/hugepages/hugepages-*kB", 0, NULL, &g);
-	assert(g.gl_pathc <= NUM_PAGESIZES);
-	for (i = 0; (i < g.gl_pathc) && (num_page_sizes < NUM_PAGESIZES); i++) {
-		sscanf(g.gl_pathv[i], "/sys/kernel/mm/hugepages/hugepages-%lukB",
-				&page_sizes[num_page_sizes]);
-		page_sizes[num_page_sizes] <<= 10;
-		ksft_print_msg("Found %luMB\n", page_sizes[i] >> 20);
+	num_page_sizes = hugetlb_setup(NUM_PAGES, page_sizes, ARRAY_SIZE(page_sizes));
 
-		if (page_sizes[num_page_sizes] > largest)
+	for (i = 0; i < num_page_sizes; i++)
+		if (page_sizes[i] > largest)
 			largest = page_sizes[i];
 
-		if (read_free(page_sizes[num_page_sizes]) >= NUM_PAGES)
-			num_page_sizes++;
-		else
-			ksft_print_msg("SKIP for size %lu MB as not enough huge pages, need %u\n",
-				       page_sizes[num_page_sizes] >> 20, NUM_PAGES);
-	}
-	globfree(&g);
-
-	read_sysfs("/proc/sys/kernel/shmmax", &shmmax_val);
-	if (shmmax_val < NUM_PAGES * largest) {
-		ksft_print_msg("WARNING: shmmax is too small to run this test.\n");
-		ksft_print_msg("Please run the following command to increase shmmax:\n");
-		ksft_print_msg("echo %lu > /proc/sys/kernel/shmmax\n", largest * NUM_PAGES);
-		ksft_exit_skip("Test skipped due to insufficient shmmax value.\n");
-	}
-
-#if defined(__x86_64__)
-	if (largest != 1U<<30) {
-		ksft_exit_skip("No GB pages available on x86-64\n"
-				   "Please boot with hugepagesz=1G hugepages=%d\n", NUM_PAGES);
-	}
-#endif
+	shm_limits_prepare(NUM_PAGES * largest);
 }
 
 int main(void)
@@ -233,3 +160,5 @@ int main(void)
 
 	ksft_finished();
 }
+
+SHM_LIMITS_RESTORE()
_

Patches currently in -mm which might be from rppt@kernel.org are


