Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9491C57C8D
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 03:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725422254; cv=none; b=c4D/CsowImVwbw7EsWm07BKb+aJ+C0oTUbcgAf3ffdVQ9w4qh1y7l7RLJuSHCUxi3cRdZVez7RDprYHUDCdymoFZ0rw1GyYqrX3zlz5Ykyy6HJBhzSwVdyTaDVN7nVvJxHYdZl2EuiQrLOBImYa1LFAZMnBCCX6UDFLSvzcLLj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725422254; c=relaxed/simple;
	bh=TNwqlKz80bUnfuh9OT1cyjfPMh7yXspJxiBX1l8frOU=;
	h=Date:To:From:Subject:Message-Id; b=cXzI1+o4NLrq3iDhtTrK2zouSD8jbUFvOpVNFZkthylj8rQmqKiSXR6cn98BKqnht8w4x1emdrD7DvOFh563iwf3/nK2z/CRUP2KoTtyTb2YIy2Km9tlLPaYBvHzLn9huyLNSjgk5KNXPE0PzFOQ8JP9dfuXl4YVuGbB9+V/+7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pFDEw6R9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pFDEw6R9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D0BAC4CEC2;
	Wed,  4 Sep 2024 03:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725422254;
	bh=TNwqlKz80bUnfuh9OT1cyjfPMh7yXspJxiBX1l8frOU=;
	h=Date:To:From:Subject:From;
	b=pFDEw6R9vnsYs1VjOi7F4GKHQX6vKLq2z4qKPolZGcvZKswRUzDLkSWWWHdIHhLG3
	 1PpX9AKQHb6aBIlsWBvJbPeJOI3VxIsU4ys4Ysrs+oXjYly192ygiQOrli6Q4Z94IP
	 w1vqkPhdYCKLrA85vCsmjW9EjIh3O9H1/TFmSWKk=
Date: Tue, 03 Sep 2024 20:57:33 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,torvalds@linux-foundation.org,shuah@kernel.org,pedro.falcato@gmail.com,mpe@ellerman.id.au,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,kees@kernel.org,jeffxu@chromium.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] selftests-mm-add-more-mseal-traversal-tests-fix-fix.patch removed from -mm tree
Message-Id: <20240904035734.2D0BAC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests-mm-add-more-mseal-traversal-tests-fix-fix
has been removed from the -mm tree.  Its filename was
     selftests-mm-add-more-mseal-traversal-tests-fix-fix.patch

This patch was dropped because it was folded into selftests-mm-add-more-mseal-traversal-tests.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: selftests-mm-add-more-mseal-traversal-tests-fix-fix
Date: Fri Aug 30 03:15:52 PM PDT 2024

remove the correct comment, per Pedro

Cc: Jeff Xu <jeffxu@chromium.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Pedro Falcato <pedro.falcato@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mseal_test.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/tools/testing/selftests/mm/mseal_test.c~selftests-mm-add-more-mseal-traversal-tests-fix-fix
+++ a/tools/testing/selftests/mm/mseal_test.c
@@ -774,6 +774,11 @@ static void test_seal_mprotect_partial_m
 	int ret;
 	int prot;
 
+	/*
+	 * Check if a partial mseal (that results in two vmas) works correctly.
+	 * It might mprotect the first, but it'll never touch the second (msealed) vma.
+	 */
+
 	setup_single_address(size, &ptr);
 	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
 
@@ -1022,11 +1027,6 @@ static void test_seal_munmap_partial_acr
 	int ret;
 	int prot;
 
-	/*
-	 * Check if a partial mseal (that results in two vmas) works correctly.
-	 * It might unmap the first, but it'll never unmap the second (msealed) vma.
-	 */
-
 	setup_single_address(size, &ptr);
 	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

selftests-mm-add-more-mseal-traversal-tests.patch
mm-remove-pageactive-fix.patch
documentation-cgroup-v2-clarify-that-zswapwriteback-is-ignored-if-zswap-is-disabled-fix.patch
mm-count-the-number-of-anonymous-thps-per-size-fix.patch
mm-memory-failure-add-unmap_poisoned_folio-fix.patch
mm-shmem-extend-shmem_unused_huge_shrink-to-all-sizes-fix.patch
mm-hugetlb-sort-out-global-lock-annotations-fix.patch
mm-hugetlb-sort-out-global-lock-annotations-fix-fix.patch
mmtmpfs-consider-end-of-file-write-in-shmem_is_huge-checkpatch-fixes.patch

