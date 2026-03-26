Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42EBC38F22F
	for <mm-commits@vger.kernel.org>; Thu, 26 Mar 2026 01:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774489378; cv=none; b=px2ejrrDj45B2bsXGN4BMVqsW3Ah92i+dsLoGOjcaeuDRirwUnNGs76koa/SmxIWDz+OsjPhmiZlGsCzQu4gM0OxBkW5yPdKS/kDB3orHbDNu4+Dk+3udmrS0803NPjrXBSWAGp6e1QHu9MHIUqjVs5fLjrNC81aAdXuytrce4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774489378; c=relaxed/simple;
	bh=UDdXKYliXPpLglc/1zuafZ06vZVSzpzGFXJwCRsMb5Q=;
	h=Date:To:From:Subject:Message-Id; b=AwfXDRfGya0qZ8fNH4bc8eawuH61FU3l2Bfv5hnOcu0DquZaUx48qEnIg3CKeu8JzsyvhKr+UasiBD58M6KY5USqWwRXRWapUd56cj/qsekWNU++ZtCW8OtddTLFUbjpQ5nlQDcFnyCerY603XvE+wNPK/5DAwI9m4LJ/fznfFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Bk1VYdcm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Bk1VYdcm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C94F0C4CEF7;
	Thu, 26 Mar 2026 01:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774489377;
	bh=UDdXKYliXPpLglc/1zuafZ06vZVSzpzGFXJwCRsMb5Q=;
	h=Date:To:From:Subject:From;
	b=Bk1VYdcmlEhScIY9dJbipA9INsq5cgP4jlGQNfr+GLY6H8oJnfg8qHFa+4JJr5E6I
	 acY4uZyjg5UHem4QToAabNmn5MzrnoUCrzLZ6evocUFocxG6dxUNIwgXJWZWjKUg0E
	 4VEQGKg1f6lms+ZcSUCX71dgJKqzqlCRzu9Br7i0=
Date: Wed, 25 Mar 2026 18:42:57 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,ryan.roberts@arm.com,npache@redhat.com,ljs@kernel.org,liam.howlett@oracle.com,lance.yang@linux.dev,hughd@google.com,dev.jain@arm.com,david@kernel.org,bas@dfinity.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,adam.bratschikaye@dfinity.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] selftests-mm-add-folio_split-and-filemap_get_entry-race-test-fix-2.patch removed from -mm tree
Message-Id: <20260326014257.C94F0C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: fix sashiko complains on folio_split_race_test
has been removed from the -mm tree.  Its filename was
     selftests-mm-add-folio_split-and-filemap_get_entry-race-test-fix-2.patch

This patch was dropped because it was folded into selftests-mm-add-folio_split-and-filemap_get_entry-race-test.patch

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

