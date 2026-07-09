Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 645293EDE5D
	for <mm-commits@vger.kernel.org>; Thu,  9 Jul 2026 22:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783637486; cv=none; b=VKb2/h4qVrEAz2YzW43V8CUlUQ1Z6wW0SFOMH7N9lUCSux63rn9s3ctU8Cl5krlXTlD4mEyk5D0iflhs4M5/Y4B8FMiVeCIFLjz7lfeIKNgldM1hjVbLoYCCtFzC3QvSyQYL755LzEBvqEuK27kEmhYwwCdgfxxxAZ8iygRmJ2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783637486; c=relaxed/simple;
	bh=VAlWBac+2r0s+eih3EwvqvoVbVIin06GzFEA7uO4y7Q=;
	h=Date:To:From:Subject:Message-Id; b=DH540iwJiFarGMxYo+1m/LrHVFuUf3c4UbPs+t4oyNjZRb9avV+Y0c3BeCvkFcLR866sDudBoYe13SHrHA8X+Jj1N8GlQ6I9YRapKpEPdZRVcNSmi77ydSHaSLRvMGmW8502lzxfI5WYSsHxJadNU47NburW7RBOD3vvHhr1Bjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GhYkM0AW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GhYkM0AW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0B521F00A3A;
	Thu,  9 Jul 2026 22:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783637484;
	bh=NTolCQBz1qSPM1LDatyFfLFwbIWpbgbidpZdWiIJkR4=;
	h=Date:To:From:Subject;
	b=GhYkM0AWuUhcTEPe+smI/gpdDYpAM2HSQXMX0Z5YzaJFq+so19KazrHJt6lWUnShf
	 EiE2w61AqshHGmkMllpV1ZnyzuUtpnAKUtF0kBkSkP0UZQ3mRFNslpYWUbhi8xq5Gw
	 r4hjxEmouFkoaZj4E63Qqx1RsGwHU3XQjXeCj744=
Date: Thu, 09 Jul 2026 15:51:23 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,sj@kernel.org,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,leon@kernel.org,jgg@ziepe.ca,david@kernel.org,balbirs@nvidia.com,lihongfu@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-memleak-in-migration-benchmark.patch added to mm-new branch
Message-Id: <20260709225123.E0B521F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: fix memleak in migration benchmark
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-fix-memleak-in-migration-benchmark.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-memleak-in-migration-benchmark.patch

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
From: Hongfu Li <lihongfu@kylinos.cn>
Subject: selftests/mm: fix memleak in migration benchmark
Date: Thu, 9 Jul 2026 16:18:43 +0800

Several early return paths in run_migration_benchmark() skip
hmm_buffer_free(), leaking the buffer.  Replace with a single cleanup
label.

Link: https://lore.kernel.org/20260709081843.1451202-1-lihongfu@kylinos.cn
Fixes: 271a7b2e3c13 ("selftests/mm/hmm-tests: new throughput tests including THP")
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Hongfu Li <lihongfu@kylinos.cn>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/hmm-tests.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

--- a/tools/testing/selftests/mm/hmm-tests.c~selftests-mm-fix-memleak-in-migration-benchmark
+++ a/tools/testing/selftests/mm/hmm-tests.c
@@ -2829,8 +2829,11 @@ static inline int run_migration_benchmar
 	buffer->ptr = mmap(NULL, buffer_size, PROT_READ | PROT_WRITE,
 			  MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
 
-	if (buffer->ptr == MAP_FAILED)
-		return -1;
+	if (buffer->ptr == MAP_FAILED) {
+		buffer->ptr = NULL;
+		ret = -1;
+		goto cleanup;
+	}
 
 	/* Apply THP hint if requested */
 	if (use_thp)
@@ -2839,7 +2842,7 @@ static inline int run_migration_benchmar
 		ret = madvise(buffer->ptr, buffer_size, MADV_NOHUGEPAGE);
 
 	if (ret)
-		return ret;
+		goto cleanup;
 
 	/* Initialize memory to make sure pages are allocated */
 	ptr = (int *)buffer->ptr;
@@ -2849,11 +2852,11 @@ static inline int run_migration_benchmar
 	/* Warmup iteration */
 	ret = hmm_migrate_sys_to_dev(fd, buffer, npages);
 	if (ret)
-		return ret;
+		goto cleanup;
 
 	ret = hmm_migrate_dev_to_sys(fd, buffer, npages);
 	if (ret)
-		return ret;
+		goto cleanup;
 
 	/* Benchmark iterations */
 	for (i = 0; i < iterations; i++) {
@@ -2862,7 +2865,7 @@ static inline int run_migration_benchmar
 
 		ret = hmm_migrate_sys_to_dev(fd, buffer, npages);
 		if (ret)
-			return ret;
+			goto cleanup;
 
 		end = get_time_ms();
 		s2d_total += (end - start);
@@ -2872,7 +2875,7 @@ static inline int run_migration_benchmar
 
 		ret = hmm_migrate_dev_to_sys(fd, buffer, npages);
 		if (ret)
-			return ret;
+			goto cleanup;
 
 		end = get_time_ms();
 		d2s_total += (end - start);
@@ -2886,9 +2889,9 @@ static inline int run_migration_benchmar
 	results->throughput_d2s = (buffer_size / (1024.0 * 1024.0 * 1024.0)) /
 				 (results->dev_to_sys_time / 1000.0);
 
-	/* Cleanup */
+cleanup:
 	hmm_buffer_free(buffer);
-	return 0;
+	return ret;
 }
 
 /*
_

Patches currently in -mm which might be from lihongfu@kylinos.cn are

selftests-mm-move-pkey-selftest-helpers-to-pkey_utilc.patch
selftests-mm-unify-pkey-sighandler-selftest-assertions-and-tracing.patch
selftests-mm-use-pkey_assert-on-clone_raw-failure-in-pkey-test.patch
selftests-mm-add-missing-mmap-return-checks-in-pkey-tests.patch
selftests-mm-add-missing-pthread_create-return-checks-in-pkey-tests.patch
selftests-mm-fix-clone-cleartid-race-in-pkey-sighandler-tests.patch
selftests-mm-fix-memleak-in-migration-benchmark.patch

