Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 206471C1742
	for <mm-commits@vger.kernel.org>; Fri, 30 Aug 2024 22:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725056221; cv=none; b=LbYny3lzPxeBEVGxT2Uksif/QB/S0edeW8qPdKBGIo8z6gnkM7gFsb5vaKUY0qEbW+HeKZLvBFTDLrKE39Lp1X34+GdG4qH8BjDVEv2nNCjWwhRdKRu6eZPwJTu3mENxKbgVOExsSZF9dETrSEX+WypkRM4sutKXImGz/ldzBD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725056221; c=relaxed/simple;
	bh=DGYnUHLSYzOITrl8pHWVDwm0zo901/N/CLkoXoXQob8=;
	h=Date:To:From:Subject:Message-Id; b=GI1vy/a4a7QQ4eKKZjd228vzSkumD43DeaLRSe+bjSrszCyVa5xwSPsRHMp+t6P2AIE+fURIqSbOn24ooB1L+RQmEVaZyndgDub+bwJD7YaieKYw/5RItkNeDjznsaS/DURbOXGwQbVg4RvkyiF2kTdH6bwR5kiZnRwlYfcsXKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mwTJxGXz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mwTJxGXz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81C0CC4CEC2;
	Fri, 30 Aug 2024 22:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725056220;
	bh=DGYnUHLSYzOITrl8pHWVDwm0zo901/N/CLkoXoXQob8=;
	h=Date:To:From:Subject:From;
	b=mwTJxGXzAFl1ovDpsucQdsA1UYCJxi1VoeCL9o3wBTj4msU8EfmZuT2JuTQLcG8xX
	 8UWT0Drg+k09rjzoZARPucM+z9jQvyy9VHx0kZQs//xkAJch2jvGzenOI9UePuMceY
	 G4xA48NKiz7qjuhKM0jcdCs6QviNT1Tr+61chwyA=
Date: Fri, 30 Aug 2024 15:16:59 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,torvalds@linux-foundation.org,shuah@kernel.org,pedro.falcato@gmail.com,mpe@ellerman.id.au,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,kees@kernel.org,jeffxu@chromium.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-add-more-mseal-traversal-tests-fix-fix.patch added to mm-unstable branch
Message-Id: <20240830221700.81C0CC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests-mm-add-more-mseal-traversal-tests-fix-fix
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-add-more-mseal-traversal-tests-fix-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-add-more-mseal-traversal-tests-fix-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Cc: Pedro Falcato <pedro.falcato@gmail.com>
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

include-linux-mmzoneh-clean-up-watermark-accessors.patch
mm-remove-legacy-install_special_mapping-code-checkpatch-fixes.patch
mm-contig_alloc-support-__gfp_comp-fix.patch
selftests-mm-add-more-mseal-traversal-tests-fix.patch
selftests-mm-add-more-mseal-traversal-tests-fix-fix.patch
mm-remove-pageactive-fix.patch
selftests-test_zswap-add-test-for-hierarchical-zswapwriteback-fix.patch
mm-count-the-number-of-anonymous-thps-per-size-fix.patch
mm-shmem-extend-shmem_unused_huge_shrink-to-all-sizes-fix.patch
mm-hugetlb-sort-out-global-lock-annotations-fix.patch
mm-hugetlb-sort-out-global-lock-annotations-fix-fix.patch
fault-inject-improve-build-for-config_fault_injection=n-fix.patch
fault-inject-improve-build-for-config_fault_injection=n-fix-2.patch
fault-inject-improve-build-for-config_fault_injection=n-fix-3.patch

