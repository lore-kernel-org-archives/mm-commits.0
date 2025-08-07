Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E8B01D8A0A
	for <mm-commits@vger.kernel.org>; Thu,  7 Aug 2025 03:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754538285; cv=none; b=Amem1W4+hhgHaqgJ3WBL/HtvhyTwfvUsK3RF8jTqZNHVR5FiH3b5StUVteLzFcxdWwPusldkmW8TpSfB3oSu9N5h0EAG1A3IhiLAOgPuJ2NpoZditeJXizj2W3wJ4QzpovekDJwHum78iBtAiSshqywLA9U/uLrjhCMpB3MoVAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754538285; c=relaxed/simple;
	bh=ZMXq0EcBfCql5hQJSKlg6VpDiTjkAsNsGtuX5+nyA3Y=;
	h=Date:To:From:Subject:Message-Id; b=pULQeJebm1V/2iWRd7TQRo74N/EUSSJJKByBhEzZ5BZtKcV8QZ3jC8W3v/KdOPWk5mhQDS8ahuKjTTrWxaq2vRL6/Iq+dAsNkCkRNVZW68RXQ3C66OdyG3SbYJw7vw2cS4npOBC8xH1eiwZ+bDC+21l/Ci/Onyvt8axSVcbqpe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JTOg8POC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JTOg8POC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C567DC4CEEB;
	Thu,  7 Aug 2025 03:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754538284;
	bh=ZMXq0EcBfCql5hQJSKlg6VpDiTjkAsNsGtuX5+nyA3Y=;
	h=Date:To:From:Subject:From;
	b=JTOg8POCTeapBoDajrxfIabBC8ewnnXWL5K/lL7C7nHfmF0X64u5lLn1U3H6fIEPi
	 YiQe680TuUA30QGKQIkV1BPJQ7IUqfxqy6tiMtd0mO+964i2KkPjfxJnieQ44ABkYv
	 t1MOhXF6lkydJQOMtcJlDoVCD7qq+shw2FY8+wyw=
Date: Wed, 06 Aug 2025 20:44:44 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,sidhartha.kumar@oracle.com,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,peterx@redhat.com,paul.walmsley@sifive.com,palmer@dabbelt.com,npache@redhat.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,leon@kernel.org,jhubbard@nvidia.com,jgg@ziepe.ca,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,aou@eecs.berkeley.edu,alex@ghiti.fr,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-remove-unused-parameters.patch added to mm-new branch
Message-Id: <20250807034444.C567DC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: remove unused parameters
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-remove-unused-parameters.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-remove-unused-parameters.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: selftests/mm: remove unused parameters
Date: Thu, 31 Jul 2025 21:01:29 +0500

Cleanup code and remove the unused arguments

Link: https://lkml.kernel.org/r/20250731160132.1795351-6-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/ksm_tests.c            |   17 ++++--------
 tools/testing/selftests/mm/soft-dirty.c           |    4 +-
 tools/testing/selftests/mm/split_huge_page_test.c |    4 +-
 tools/testing/selftests/mm/uffd-common.c          |    4 +-
 tools/testing/selftests/mm/uffd-common.h          |    2 -
 tools/testing/selftests/mm/uffd-stress.c          |    2 -
 tools/testing/selftests/mm/uffd-unit-tests.c      |    8 ++---
 7 files changed, 19 insertions(+), 22 deletions(-)

--- a/tools/testing/selftests/mm/ksm_tests.c~selftests-mm-remove-unused-parameters
+++ a/tools/testing/selftests/mm/ksm_tests.c
@@ -238,8 +238,7 @@ static int ksm_merge_pages(int merge_typ
 	return 0;
 }
 
-static int ksm_unmerge_pages(void *addr, size_t size,
-			     struct timespec start_time, int timeout)
+static int ksm_unmerge_pages(void *addr, size_t size)
 {
 	if (madvise(addr, size, MADV_UNMERGEABLE)) {
 		perror("madvise");
@@ -456,7 +455,7 @@ static int get_first_mem_node(void)
 	return get_next_mem_node(numa_max_node());
 }
 
-static int check_ksm_numa_merge(int merge_type, int mapping, int prot, int timeout,
+static int check_ksm_numa_merge(int merge_type, int timeout,
 				bool merge_across_nodes, size_t page_size)
 {
 	void *numa1_map_ptr, *numa2_map_ptr;
@@ -520,8 +519,7 @@ err_out:
 	return KSFT_FAIL;
 }
 
-static int ksm_merge_hugepages_time(int merge_type, int mapping, int prot,
-				int timeout, size_t map_size)
+static int ksm_merge_hugepages_time(int merge_type, int timeout, size_t map_size)
 {
 	void *map_ptr, *map_ptr_orig;
 	struct timespec start_time, end_time;
@@ -656,7 +654,7 @@ static int ksm_unmerge_time(int merge_ty
 		perror("clock_gettime");
 		goto err_out;
 	}
-	if (ksm_unmerge_pages(map_ptr, map_size, start_time, timeout))
+	if (ksm_unmerge_pages(map_ptr, map_size))
 		goto err_out;
 	if (clock_gettime(CLOCK_MONOTONIC_RAW, &end_time)) {
 		perror("clock_gettime");
@@ -884,8 +882,8 @@ int main(int argc, char *argv[])
 						page_size);
 		break;
 	case CHECK_KSM_NUMA_MERGE:
-		ret = check_ksm_numa_merge(merge_type, MAP_PRIVATE | MAP_ANONYMOUS, prot,
-					ksm_scan_limit_sec, merge_across_nodes, page_size);
+		ret = check_ksm_numa_merge(merge_type, ksm_scan_limit_sec, merge_across_nodes,
+					   page_size);
 		break;
 	case KSM_MERGE_TIME:
 		if (size_MB == 0) {
@@ -900,8 +898,7 @@ int main(int argc, char *argv[])
 			printf("Option '-s' is required.\n");
 			return KSFT_FAIL;
 		}
-		ret = ksm_merge_hugepages_time(merge_type, MAP_PRIVATE | MAP_ANONYMOUS, prot,
-				ksm_scan_limit_sec, size_MB);
+		ret = ksm_merge_hugepages_time(merge_type, ksm_scan_limit_sec, size_MB);
 		break;
 	case KSM_UNMERGE_TIME:
 		if (size_MB == 0) {
--- a/tools/testing/selftests/mm/soft-dirty.c~selftests-mm-remove-unused-parameters
+++ a/tools/testing/selftests/mm/soft-dirty.c
@@ -76,7 +76,7 @@ static void test_vma_reuse(int pagemap_f
 	munmap(map2, pagesize);
 }
 
-static void test_hugepage(int pagemap_fd, int pagesize)
+static void test_hugepage(int pagemap_fd)
 {
 	char *map;
 	int i, ret;
@@ -210,7 +210,7 @@ int main(void)
 
 	test_simple(pagemap_fd, pagesize);
 	test_vma_reuse(pagemap_fd, pagesize);
-	test_hugepage(pagemap_fd, pagesize);
+	test_hugepage(pagemap_fd);
 	test_mprotect_anon(pagemap_fd, pagesize);
 	test_mprotect_file(pagemap_fd, pagesize);
 
--- a/tools/testing/selftests/mm/split_huge_page_test.c~selftests-mm-remove-unused-parameters
+++ a/tools/testing/selftests/mm/split_huge_page_test.c
@@ -107,7 +107,7 @@ static char *allocate_zero_filled_hugepa
 	return result;
 }
 
-static void verify_rss_anon_split_huge_page_all_zeroes(char *one_page, int nr_hpages, size_t len)
+static void verify_rss_anon_split_huge_page_all_zeroes(char *one_page, size_t len)
 {
 	unsigned long rss_anon_before, rss_anon_after;
 	size_t i;
@@ -143,7 +143,7 @@ void split_pmd_zero_pages(void)
 	size_t len = nr_hpages * pmd_pagesize;
 
 	one_page = allocate_zero_filled_hugepage(len);
-	verify_rss_anon_split_huge_page_all_zeroes(one_page, nr_hpages, len);
+	verify_rss_anon_split_huge_page_all_zeroes(one_page, len);
 	ksft_test_result_pass("Split zero filled huge pages successful\n");
 	free(one_page);
 }
--- a/tools/testing/selftests/mm/uffd-common.c~selftests-mm-remove-unused-parameters
+++ a/tools/testing/selftests/mm/uffd-common.c
@@ -416,7 +416,7 @@ static void continue_range(int ufd, __u6
 		    ret, (int64_t) req.mapped);
 }
 
-int uffd_read_msg(int ufd, struct uffd_msg *msg)
+int uffd_read_msg(struct uffd_msg *msg)
 {
 	int ret = read(uffd, msg, sizeof(*msg));
 
@@ -537,7 +537,7 @@ void *uffd_poll_thread(void *arg)
 		}
 		if (!(pollfd[0].revents & POLLIN))
 			err("pollfd[0].revents %d", pollfd[0].revents);
-		if (uffd_read_msg(uffd, &msg))
+		if (uffd_read_msg(&msg))
 			continue;
 		switch (msg.event) {
 		default:
--- a/tools/testing/selftests/mm/uffd-common.h~selftests-mm-remove-unused-parameters
+++ a/tools/testing/selftests/mm/uffd-common.h
@@ -117,7 +117,7 @@ void uffd_stats_report(struct uffd_args
 int uffd_test_ctx_init(uint64_t features, const char **errmsg);
 void uffd_test_ctx_clear(void);
 int userfaultfd_open(uint64_t *features);
-int uffd_read_msg(int ufd, struct uffd_msg *msg);
+int uffd_read_msg(struct uffd_msg *msg);
 void wp_range(int ufd, __u64 start, __u64 len, bool wp);
 void uffd_handle_page_fault(struct uffd_msg *msg, struct uffd_args *args);
 int __copy_page(int ufd, unsigned long offset, bool retry, bool wp);
--- a/tools/testing/selftests/mm/uffd-stress.c~selftests-mm-remove-unused-parameters
+++ a/tools/testing/selftests/mm/uffd-stress.c
@@ -137,7 +137,7 @@ static void *uffd_read_thread(void *arg)
 	/* from here cancellation is ok */
 
 	for (;;) {
-		if (uffd_read_msg(uffd, &msg))
+		if (uffd_read_msg(&msg))
 			continue;
 		uffd_handle_page_fault(&msg, args);
 	}
--- a/tools/testing/selftests/mm/uffd-unit-tests.c~selftests-mm-remove-unused-parameters
+++ a/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -248,7 +248,7 @@ static void *fork_event_consumer(void *d
 	ready_for_fork = true;
 
 	/* Read until a full msg received */
-	while (uffd_read_msg(args->parent_uffd, &msg));
+	while (uffd_read_msg(&msg));
 
 	if (msg.event != UFFD_EVENT_FORK)
 		err("wrong message: %u\n", msg.event);
@@ -1352,11 +1352,11 @@ static void *uffd_mmap_changing_thread(v
 	return NULL;
 }
 
-static void uffd_consume_message(int fd)
+static void uffd_consume_message(void)
 {
 	struct uffd_msg msg = { 0 };
 
-	while (uffd_read_msg(fd, &msg));
+	while (uffd_read_msg(&msg));
 }
 
 static void uffd_mmap_changing_test(uffd_test_args_t *targs)
@@ -1407,7 +1407,7 @@ static void uffd_mmap_changing_test(uffd
 	 * All succeeded above!  Recycle everything.  Start by reading the
 	 * event so as to kick the thread roll again..
 	 */
-	uffd_consume_message(uffd);
+	uffd_consume_message();
 
 	ret = pthread_join(tid, NULL);
 	assert(ret == 0);
_

Patches currently in -mm which might be from usama.anjum@collabora.com are

selftests-mm-add-wunreachable-code-and-fix-warnings.patch
selftests-mm-protection_keys-fix-dead-code.patch
selftests-kselftesth-add-__unused-macro.patch
selftests-mm-add-wunused-family-of-flags.patch
selftests-mm-remove-unused-parameters.patch
selftests-mm-mark-unused-arguments-with-__unused.patch
selftests-mm-mark-unused-arguments-with-__unused-2.patch
selftests-mm-fix-unused-parameter-warnings-for-different-architectures.patch

