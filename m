Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 538E757CBA
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 03:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725422253; cv=none; b=SSw3NcQ3Oo8kkKNRorJ5kaWf1PeficUrEyom+sbVpOGXaSHHQ8sWFX4n0Hpv4z1DX6GMEwwx+mpcBVXAFb6H7fr9DC3NVr07wfxX6ZvlIBugAshCyi7RiPXkJ4gB+wkelzUGv2301TKgni9iKP3Xvrac9KbD+Lq1w4WBSRhZqSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725422253; c=relaxed/simple;
	bh=PEI3G9ZlK/j/LUlerNtiJ1Pnja7Vnq/tTr6drAPupn4=;
	h=Date:To:From:Subject:Message-Id; b=ufpPWFs/h5eTR9QS+AT+DHeqIsz9YVU+koCe6adyHVZreludgUwVn/lN5muI56+lQmC0aE1F/abNGodq3GWFpuGCcMmFDQEPGib2yofPIqdoTf2x7WLYDQc3Nww+O4wZk1A+oPRSPaPMP1e+v/ubFpzqoq+A1pgSMnO9bULLhsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ps/ALqdy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ps/ALqdy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C946CC4CEC2;
	Wed,  4 Sep 2024 03:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725422252;
	bh=PEI3G9ZlK/j/LUlerNtiJ1Pnja7Vnq/tTr6drAPupn4=;
	h=Date:To:From:Subject:From;
	b=Ps/ALqdySTtb2AcssNOObxIO2ZSGnv4PAOkx6wV0ul45wvknIux4L1qZC88aDAvz5
	 0VJ+Lp4nJgDfHRp2V/4kIs/JsB8bMGxkGAXS8GHH0jBKHAFNyTC+SHa3rV+nhxh7Sy
	 UwohgM1AWz7H+SPSOYuv/Y21MhxNmL2w6AH4mzaY=
Date: Tue, 03 Sep 2024 20:57:32 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,torvalds@linux-foundation.org,shuah@kernel.org,pedro.falcato@gmail.com,mpe@ellerman.id.au,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,kees@kernel.org,jeffxu@chromium.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] selftests-mm-add-more-mseal-traversal-tests-fix.patch removed from -mm tree
Message-Id: <20240904035732.C946CC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests-mm-add-more-mseal-traversal-tests-fix
has been removed from the -mm tree.  Its filename was
     selftests-mm-add-more-mseal-traversal-tests-fix.patch

This patch was dropped because it was folded into selftests-mm-add-more-mseal-traversal-tests.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: selftests-mm-add-more-mseal-traversal-tests-fix
Date: Tue Aug 20 06:51:01 PM PDT 2024

remove incorrect comment, per review

Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Pedro Falcato <pedro.falcato@gmail.com>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mseal_test.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/tools/testing/selftests/mm/mseal_test.c~selftests-mm-add-more-mseal-traversal-tests-fix
+++ a/tools/testing/selftests/mm/mseal_test.c
@@ -774,11 +774,6 @@ static void test_seal_mprotect_partial_m
 	int ret;
 	int prot;
 
-	/*
-	 * Check if a partial mseal (that results in two vmas) works correctly.
-	 * It might mprotect the first, but it'll never touch the second (msealed) vma.
-	 */
-
 	setup_single_address(size, &ptr);
 	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

selftests-mm-add-more-mseal-traversal-tests.patch
selftests-mm-add-more-mseal-traversal-tests-fix-fix.patch
mm-remove-pageactive-fix.patch
documentation-cgroup-v2-clarify-that-zswapwriteback-is-ignored-if-zswap-is-disabled-fix.patch
mm-count-the-number-of-anonymous-thps-per-size-fix.patch
mm-memory-failure-add-unmap_poisoned_folio-fix.patch
mm-shmem-extend-shmem_unused_huge_shrink-to-all-sizes-fix.patch
mm-hugetlb-sort-out-global-lock-annotations-fix.patch
mm-hugetlb-sort-out-global-lock-annotations-fix-fix.patch
mmtmpfs-consider-end-of-file-write-in-shmem_is_huge-checkpatch-fixes.patch

