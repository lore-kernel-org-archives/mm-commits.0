Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E84A03BF68D
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896694; cv=none; b=iXnrh4qBzfNjLTbpYc9edyOCDctCdDOtzR4BrgOB3103OvE0h2C99mwxGBwxcibsHclZLOY+t9gVb8oR8IADE4vpvz/TtNr2R7e4TCZc4lL+f2SlTrMRDKW0M+iY7lW7v7i/Pdn8Wfu/egCYdSgqAf0JtfJ32mEJhfuuLppjT2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896694; c=relaxed/simple;
	bh=1JnQhxWpQ2iY0iOI7XMheCw+QR3MLpmPtZ4EQPgn/4A=;
	h=Date:To:From:Subject:Message-Id; b=gPYTJuyqDEEOY38CE282LRXylEE/WYhGnThY/j5/1WlQte+hXOlrT/ISqCRxiBCxUIuuxaSEZ+owSV0f74sTU+2Uv2w8kQxqhQL+o5oeLdL9AYSblQSLtYY5Ry//Q2E6+qCH9lG44EDDJcT0unPwRYr6sHaP/VS0jIBRYe0pnf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=I0tteUz4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="I0tteUz4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 393621F000E9;
	Wed,  5 Aug 2026 02:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896692;
	bh=AImzPhWTfrNoEAxkj5XLUn5RJT2dNahSOMebn9iKr6E=;
	h=Date:To:From:Subject;
	b=I0tteUz4iREdAXVvvmAVnYCTXyh1Jc4JXCVHV1dCmOb6ZQQDVESmMIPg6esXMDaH6
	 vNAbkiFADqpp5MvBvLPrbx6xUhvTxKTxAOIeEhXSUOQ9PNN6LWlqOfh/xBtr6qmT3n
	 LVFaz8KHgQBpF+JFNW1KuJXx1aHe6X3LZCQDwczE=
Date: Tue, 04 Aug 2026 19:24:51 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,sj@kernel.org,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,leon@kernel.org,jgg@ziepe.ca,david@kernel.org,balbirs@nvidia.com,lihongfu@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-fix-memleak-in-migration-benchmark.patch removed from -mm tree
Message-Id: <20260805022452.393621F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: fix memleak in migration benchmark
has been removed from the -mm tree.  Its filename was
     selftests-mm-fix-memleak-in-migration-benchmark.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: Balbir Singh <balbirs@nvidia.com>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Balbir Singh <balbirs@nvidia.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Hongfu Li <lihongfu@kylinos.cn>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
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

selftests-mm-factor-out-hmm_buffer_alloc-to-consolidate-buffer-setup.patch
selftests-mm-fix-bug_on-checking-wrong-variable-in-mremap_dontunmap.patch
mm-swap-fix-swap_cluster_lock-config_swap-stub-signature-mismatch.patch
mm-use-a-folio-in-the-softleaf_is_device_private-path.patch
selftests-prctl-fix-non-anonymous-vma-mapping-in-set-anon-vma-name-test.patch

