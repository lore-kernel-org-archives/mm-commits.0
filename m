Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86D502BF3F3;
	Thu,  2 Jul 2026 02:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782957821; cv=none; b=kBNBT/atYv0gjkMVRFbffJidNXr9kg2CiAxjTcCuI5kXrHbIqJH7sULG0tPwUxhS3QeIuUXAoXvBer3cZlU15D+4pf5DWbsckKAkmC3CFIw7p97QBc6OeV5MC8aRokVUpA5/fD1Dju9wR7wd8tDry7Hbykxn/UyOQ/Ul3UjG5/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782957821; c=relaxed/simple;
	bh=8YPAfHBcDCfo5pesfDtCQYAROeYO5MvsCrUgj78zWS4=;
	h=Date:To:From:Subject:Message-Id; b=hWkeBPp1x2BkrpL7XhYlnC554kApwnGwmj9G5cQ79Y0TYVO2Y++yMC628avFpkCx4ONmrjnnN9nRRdX+KXVTC2Ce1oIVvdwiXAAwv4+a244/68w3vPD40sVg3BvbPbm5j8JVBVLwzAsCfpQR9k5nkk6YGxz7e0yCR8ImVihCl74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AQWHTDZ/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AQWHTDZ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AAB21F000E9;
	Thu,  2 Jul 2026 02:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782957820;
	bh=tusNmJdChen/hKhlT5jV69uGmOBdTi3PPNgb7CHXQfs=;
	h=Date:To:From:Subject;
	b=AQWHTDZ/weXB+kT13VlLhhTOTAMai5epr3cr3aEupyeiLwArTFz18z7b51KIWr+yY
	 9b/GPjlKukhRTfhwianjKgwhwoAbh9OiD8vfiYNm1DvQltmiG2mJeSRt2/TKR3j5lI
	 GtFqKAcSjvOyMAYGISllvZmyXfjlfMsEaeHuRU00=
Date: Wed, 01 Jul 2026 19:03:39 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,usama.anjum@arm.com,surenb@google.com,stable@vger.kernel.org,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,zenghui.yu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-mm-pagemap_ioctl-use-the-correct-page-size-for-transact_test.patch removed from -mm tree
Message-Id: <20260702020340.5AAB21F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: pagemap_ioctl: use the correct page size for transact_test()
has been removed from the -mm tree.  Its filename was
     selftests-mm-pagemap_ioctl-use-the-correct-page-size-for-transact_test.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zenghui Yu <zenghui.yu@linux.dev>
Subject: selftests/mm: pagemap_ioctl: use the correct page size for transact_test()
Date: Sun, 28 Jun 2026 18:11:18 +0800

There are several places in transact_test() where we use the hardcoded
0x1000 (4k) as page size, which is not always correct for architectures
supporting multiple page sizes.

Switch to use the correct page size.  Otherwise ./ksft_pagemap.sh on a
16k-page-size arm64 box fails with

 $ ./ksft_pagemap.sh
 [...]
 # ok 96 mprotect_tests Both pages written after remap and mprotect
 # ok 97 mprotect_tests Clear and make the pages written
 # Bail out! ioctl failed
 # # Planned tests != run tests (117 != 97)
 # # Totals: pass:97 fail:0 xfail:0 xpass:0 skip:0 error:0
 # [FAIL]
 not ok 1 pagemap_ioctl # exit=1
 # SUMMARY: PASS=0 SKIP=0 FAIL=1
 1..1

Link: https://lore.kernel.org/20260628101118.35861-1-zenghui.yu@linux.dev
Fixes: 46fd75d4a3c9 ("selftests: mm: add pagemap ioctl tests")
Signed-off-by: Zenghui Yu <zenghui.yu@linux.dev>
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zenghui Yu <zenghui.yu@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/pagemap_ioctl.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/tools/testing/selftests/mm/pagemap_ioctl.c~selftests-mm-pagemap_ioctl-use-the-correct-page-size-for-transact_test
+++ a/tools/testing/selftests/mm/pagemap_ioctl.c
@@ -1368,7 +1368,7 @@ void *thread_proc(void *mem)
 			ksft_exit_fail_msg("pthread_barrier_wait\n");
 
 		for (i = 0; i < access_per_thread; ++i)
-			__atomic_add_fetch(m + i * (0x1000 / sizeof(*m)), 1, __ATOMIC_SEQ_CST);
+			__atomic_add_fetch(m + i * (page_size / sizeof(*m)), 1, __ATOMIC_SEQ_CST);
 
 		ret = pthread_barrier_wait(&end_barrier);
 		if (ret && ret != PTHREAD_BARRIER_SERIAL_THREAD)
@@ -1403,15 +1403,15 @@ static void transact_test(int page_size)
 	if (pthread_barrier_init(&end_barrier, NULL, nthreads + 1))
 		ksft_exit_fail_msg("pthread_barrier_init\n");
 
-	mem = mmap(NULL, 0x1000 * nthreads * pages_per_thread, PROT_READ | PROT_WRITE,
+	mem = mmap(NULL, page_size * nthreads * pages_per_thread, PROT_READ | PROT_WRITE,
 		   MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
 	if (mem == MAP_FAILED)
 		ksft_exit_fail_msg("Error mmap %s.\n", strerror(errno));
 
-	wp_init(mem, 0x1000 * nthreads * pages_per_thread);
-	wp_addr_range(mem, 0x1000 * nthreads * pages_per_thread);
+	wp_init(mem, page_size * nthreads * pages_per_thread);
+	wp_addr_range(mem, page_size * nthreads * pages_per_thread);
 
-	memset(mem, 0, 0x1000 * nthreads * pages_per_thread);
+	memset(mem, 0, page_size * nthreads * pages_per_thread);
 
 	count = get_dirty_pages_reset(mem, nthreads * pages_per_thread, 1, page_size);
 	ksft_test_result(count > 0, "%s count %u\n", __func__, count);
@@ -1420,7 +1420,7 @@ static void transact_test(int page_size)
 
 	finish = 0;
 	for (i = 0; i < nthreads; ++i)
-		pthread_create(&th, NULL, thread_proc, mem + 0x1000 * i * pages_per_thread);
+		pthread_create(&th, NULL, thread_proc, mem + page_size * i * pages_per_thread);
 
 	extra_pages = 0;
 	for (i = 0; i < iter_count; ++i) {
_

Patches currently in -mm which might be from zenghui.yu@linux.dev are

tools-mm-add-thp_swap_allocator_test-binary-to-gitignore.patch

