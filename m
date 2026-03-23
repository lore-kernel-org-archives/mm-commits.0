Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33ABC17C203
	for <mm-commits@vger.kernel.org>; Mon, 23 Mar 2026 01:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774229053; cv=none; b=PfDE45HKswMXQ6Aa8dL/+31R9TFyjF5tk+EIVXZNoF8E7QOqgfbGENf5EBxornKQZzdIUJYLvNcvgHygyoE7H2Mea+k3TXOmZdd06n9Uvg3t8AQeoJ6gmmKub6WwSWC07S85MF6hF7uqXPLtL4kgh8/fyl3uS2VDZwjTshfzA+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774229053; c=relaxed/simple;
	bh=iblmoSQYNDB4A4h95F5H2Jy04/ejofSsmJSeP9phKZk=;
	h=Date:To:From:Subject:Message-Id; b=Dr5iBtjsFoDEN90RF4hOuVSfVPUvDJ/CY6ssDVUUa1POEO6Va3O7FZb500DaN+ZuDSjNWTZy7J9WWdm+H4xmmBaHKa4t6U4O6hd9e1z3CPs3XOtoSwfqNDiHbvEFdE9V8kIRZBYY3MvBQtIGbI0ARtkIa/0Ny8El1dkv3+yDwu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QeeqWlj7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QeeqWlj7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 995E7C19424;
	Mon, 23 Mar 2026 01:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774229052;
	bh=iblmoSQYNDB4A4h95F5H2Jy04/ejofSsmJSeP9phKZk=;
	h=Date:To:From:Subject:From;
	b=QeeqWlj7v2rcbbaMP9nrhj6Zy2eQh/gYeBsbtGZWTgiJjjZSLgU5Vd92DL6e3DbVr
	 qGo52nVyHw23XZJ0eO7AzQRF3JO5la6qoiXtJ/A1eEnD4dmJbI2y456dRYC0+KscpN
	 HkFqzMzEBCZwep3Byvbz+amZQ/F80gEkmP2zBhtY=
Date: Sun, 22 Mar 2026 18:24:11 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,ryan.roberts@arm.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lance.yang@linux.dev,hughd@google.com,dev.jain@arm.com,david@kernel.org,bas@dfinity.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,adam.bratschikaye@dfinity.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-add-folio_split-and-filemap_get_entry-race-test-fix-2.patch added to mm-new branch
Message-Id: <20260323012412.995E7C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: fix sashiko complains on folio_split_race_test
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-add-folio_split-and-filemap_get_entry-race-test-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-add-folio_split-and-filemap_get_entry-race-test-fix-2.patch

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
From: Zi Yan <ziy@nvidia.com>
Subject: selftests/mm: fix sashiko complains on folio_split_race_test
Date: Sun, 22 Mar 2026 19:53:54 -0400

1. use PRIu64 for uint64_t
2. add pthread_barrier_t to ensure main thread starts to punch holes when
   all reader threads are spawned.

Link: https://lkml.kernel.org/r/B0985749-939D-4256-B9B9-C54C0734CF72@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: Adam Bratschi-Kaye <adam.bratschikaye@dfinity.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Bas van Dijk <bas@dfinity.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/folio_split_race_test.c |   17 +++++++++--
 1 file changed, 14 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/mm/folio_split_race_test.c~selftests-mm-add-folio_split-and-filemap_get_entry-race-test-fix-2
+++ a/tools/testing/selftests/mm/folio_split_race_test.c
@@ -46,6 +46,7 @@ struct shared_ctl {
 	atomic_uint_fast32_t stop;
 	atomic_size_t reader_failures;
 	atomic_size_t reader_verified;
+	pthread_barrier_t barrier;
 };
 
 static void fill_page(unsigned char *base, size_t page_idx)
@@ -78,14 +79,14 @@ static bool check_page(unsigned char *ba
 		}
 		if (all_zero) {
 			ksft_print_msg(
-				"CORRUPTED: page %zu (huge page %zu) is ALL ZEROS\n",
+				"CORRUPTED: page %zu (huge page %" PRIu64 ") is ALL ZEROS\n",
 				page_idx,
 				(page_idx * page_size) / pmd_pagesize);
 		} else {
 			ksft_print_msg(
-				"CORRUPTED: page %zu (huge page %zu): expected idx %zu, got %lu\n",
+				"CORRUPTED: page %zu (huge page %" PRIu64 "): expected idx %zu, got %" PRIu64 "\n",
 				page_idx, (page_idx * page_size) / pmd_pagesize,
-				page_idx, (unsigned long)got_idx);
+				page_idx, got_idx);
 		}
 		return false;
 	}
@@ -110,6 +111,8 @@ static void *reader_thread(void *arg)
 	atomic_size_t *verified = ra->verified;
 	size_t page_idx;
 
+	pthread_barrier_wait(&ctl->barrier);
+
 	while (atomic_load_explicit(&ctl->stop, memory_order_acquire) == 0) {
 		for (page_idx = (size_t)tid; page_idx < TOTAL_PAGES;
 		     page_idx += NUM_READER_THREADS) {
@@ -178,8 +181,14 @@ static size_t run_iteration(void)
 	if (!check_huge_shmem(mmap_base, NR_PMD_PAGE, pmd_pagesize))
 		ksft_exit_fail_msg("No shmem THP is allocated\n");
 
+	if (pthread_barrier_init(&ctl.barrier, NULL, NUM_READER_THREADS + 1) != 0)
+		ksft_exit_fail_msg("pthread_barrier_init failed\n");
+
 	create_readers(threads, args, mmap_base, &ctl);
 
+	/* Wait for all reader threads to be ready before punching holes. */
+	pthread_barrier_wait(&ctl.barrier);
+
 	for (i = 0; i < TOTAL_PAGES; i++) {
 		if (i % PUNCH_INTERVAL != 0)
 			continue;
@@ -198,6 +207,8 @@ static size_t run_iteration(void)
 	for (i = 0; i < NUM_READER_THREADS; i++)
 		pthread_join(threads[i], NULL);
 
+	pthread_barrier_destroy(&ctl.barrier);
+
 	reader_failures = atomic_load_explicit(&ctl.reader_failures,
 					       memory_order_acquire);
 	reader_verified = atomic_load_explicit(&ctl.reader_verified,
_

Patches currently in -mm which might be from ziy@nvidia.com are

selftests-mm-add-folio_split-and-filemap_get_entry-race-test.patch
selftests-mm-add-folio_split-and-filemap_get_entry-race-test-v4.patch
selftests-mm-add-folio_split-and-filemap_get_entry-race-test-fix.patch
selftests-mm-add-folio_split-and-filemap_get_entry-race-test-fix-2.patch

