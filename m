Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DAE62D97A6;
	Sun, 28 Jun 2026 18:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782670422; cv=none; b=SXHRizpy87EvmFvGBUtTBWAq0sTgiLXALz/yDjfgM8uUrNK8MB5Q88x5N6HNrwekUAYRnug3whLiv2ffcZOwmJC+hTOh1qNhqaUUU4/gmzqHFUxaHW+47FFMoSEZFJo5VVQxA8TnOl98vIVEkdi0Ezq58mALDJy4HJETx1PO7IQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782670422; c=relaxed/simple;
	bh=t23BjGZGabv85Zic5MK+11K19WQfmO6kzOf6UScGI2s=;
	h=Date:To:From:Subject:Message-Id; b=RPqI2ylQvz1cgsFpTNzqtO11MghqOJ34Xshq0vzThLtFlizyHiFBpd76RoyR3AKuxfJan0Bu3I8lXKuLjjtnGsoCMDFOSQv26i3IILmUD+aVLI4+4oax3b8C+vLJloFFWuq+ef0RoXEqMwyGauxgHtrU9unieTTrpAf7spNiNBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rM7nCpXk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rM7nCpXk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 003401F000E9;
	Sun, 28 Jun 2026 18:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782670421;
	bh=sFnf9yyJ4ucbfP+ocRrnEqYza8B4UD8xSXvLW4TNVE0=;
	h=Date:To:From:Subject;
	b=rM7nCpXkuI2qqVxopJcMRBscSvGbuiGmnKhOcBFcNF+/bKbH0bmgjQCudI3wg//A9
	 GIK3dz82NNFZbJBOZrv1txKs2Hn6LpJbS9z3Hamno98SRP/R608Zthit8HXyPXju25
	 9HPFJ0o1U8p2sRZatT87cSrZqgauk39Rn2l7fpaU=
Date: Sun, 28 Jun 2026 11:13:37 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,usama.anjum@arm.com,surenb@google.com,stable@vger.kernel.org,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,zenghui.yu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-pagemap_ioctl-use-the-correct-page-size-for-transact_test.patch added to mm-hotfixes-unstable branch
Message-Id: <20260628181341.003401F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: pagemap_ioctl: use the correct page size for transact_test()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-mm-pagemap_ioctl-use-the-correct-page-size-for-transact_test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-pagemap_ioctl-use-the-correct-page-size-for-transact_test.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

selftests-mm-pagemap_ioctl-use-the-correct-page-size-for-transact_test.patch
tools-mm-add-thp_swap_allocator_test-binary-to-gitignore.patch
docs-pagemap-fix-flags-location-member-name-and-sample-code.patch

