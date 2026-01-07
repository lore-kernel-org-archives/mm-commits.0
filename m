Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C82633A9FD
	for <mm-commits@vger.kernel.org>; Wed,  7 Jan 2026 17:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767806499; cv=none; b=CQSCBNRSbCIU07yLkEUG7S9liF8aYMYHt/sc8chSmUYjqEni4yxAqCmrfW7AFn6s20HfTV9ep7PLtvYwQOwCG4xN+7uKByLnNTeLoSHZGvMUsd5+gXisBBoX8RCnBpUrDAVO0IuHsF23D2mT97c4Q2xlgOwWYzxKWh6rxX6iQ7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767806499; c=relaxed/simple;
	bh=yguCqtcgZ82RJjVFan+4DyD2LuW/nwSK4+uLS487WDQ=;
	h=Date:To:From:Subject:Message-Id; b=JzgNarRgcuTQhLCmpdDCCXfUFd4HeR9u+BZYB+HTx/DJVkKIK2B3bHvytt56AK9ogWGREotdjO2uwg1NLPZtg2j0dhpj2BLzw+c+EXYRygi4GanqvW8mJK+5ChjE/PPrk0DAz2rzcpKgyFxinF9XW1Qxd2xEaz5uBQ/7Rgjlh2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M/XRq6Lc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M/XRq6Lc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14D28C4CEF7;
	Wed,  7 Jan 2026 17:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767806498;
	bh=yguCqtcgZ82RJjVFan+4DyD2LuW/nwSK4+uLS487WDQ=;
	h=Date:To:From:Subject:From;
	b=M/XRq6LcgEBy/m5BbTmnVBJxmMRtSwvSJ2dCn6KwRflusjkZ0BDuKykhAaAkQzISu
	 ZkTfmxDblhN3FDBsAnQhqSSFeNgY4F57HmV6AXGj2Q1OT5EeTXqCaN+ZHWj98qqe1f
	 Rf6KjKXfecmivn+4NNlvBVNgmgU/VeFvWMcYxqK0=
Date: Wed, 07 Jan 2026 09:21:37 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,Usama.Anjum@arm.com,surenb@google.com,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,pabeni@redhat.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,linyunsheng@huawei.com,Liam.Howlett@oracle.com,jhubbard@nvidia.com,jgg@nvidia.com,david@kernel.org,broonie@kernel.org,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-usage-of-force_read-in-cow-tests.patch added to mm-new branch
Message-Id: <20260107172138.14D28C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: fix usage of FORCE_READ() in cow tests
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-fix-usage-of-force_read-in-cow-tests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-usage-of-force_read-in-cow-tests.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Kevin Brodsky <kevin.brodsky@arm.com>
Subject: selftests/mm: fix usage of FORCE_READ() in cow tests
Date: Wed, 7 Jan 2026 16:48:38 +0000

Commit 5bbc2b785e63 ("selftests/mm: fix FORCE_READ to read input value
correctly") modified FORCE_READ() to take a value instead of a pointer. 
It also changed most of the call sites accordingly, but missed many of
them in cow.c.  In those cases, we ended up with the pointer itself being
read, not the memory it points to.

No failure occurred as a result, so it looks like the tests work just fine
without faulting in.  However, the huge_zeropage tests explicitly check
that pages are populated, so those became skipped.

Convert all the remaining FORCE_READ() to fault in the mapped page, as was
originally intended.  This allows the huge_zeropage tests to run again (3
tests in total).

Link: https://lkml.kernel.org/r/20260107164842.3289559-5-kevin.brodsky@arm.com
Fixes: 5bbc2b785e63 ("selftests/mm: fix FORCE_READ to read input value correctly")
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Usama Anjum <Usama.Anjum@arm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/cow.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/tools/testing/selftests/mm/cow.c~selftests-mm-fix-usage-of-force_read-in-cow-tests
+++ a/tools/testing/selftests/mm/cow.c
@@ -1612,8 +1612,8 @@ static void run_with_huge_zeropage(non_a
 	 * the first sub-page and test if we get another sub-page populated
 	 * automatically.
 	 */
-	FORCE_READ(mem);
-	FORCE_READ(smem);
+	FORCE_READ(*mem);
+	FORCE_READ(*smem);
 	if (!pagemap_is_populated(pagemap_fd, mem + pagesize) ||
 	    !pagemap_is_populated(pagemap_fd, smem + pagesize)) {
 		ksft_test_result_skip("Did not get THPs populated\n");
@@ -1663,8 +1663,8 @@ static void run_with_memfd(non_anon_test
 	}
 
 	/* Fault the page in. */
-	FORCE_READ(mem);
-	FORCE_READ(smem);
+	FORCE_READ(*mem);
+	FORCE_READ(*smem);
 
 	fn(mem, smem, pagesize);
 munmap:
@@ -1719,8 +1719,8 @@ static void run_with_tmpfile(non_anon_te
 	}
 
 	/* Fault the page in. */
-	FORCE_READ(mem);
-	FORCE_READ(smem);
+	FORCE_READ(*mem);
+	FORCE_READ(*smem);
 
 	fn(mem, smem, pagesize);
 munmap:
@@ -1773,8 +1773,8 @@ static void run_with_memfd_hugetlb(non_a
 	}
 
 	/* Fault the page in. */
-	FORCE_READ(mem);
-	FORCE_READ(smem);
+	FORCE_READ(*mem);
+	FORCE_READ(*smem);
 
 	fn(mem, smem, hugetlbsize);
 munmap:
_

Patches currently in -mm which might be from kevin.brodsky@arm.com are

x86-xen-simplify-flush_lazy_mmu.patch
powerpc-mm-implement-arch_flush_lazy_mmu_mode.patch
sparc-mm-implement-arch_flush_lazy_mmu_mode.patch
mm-clarify-lazy_mmu-sleeping-constraints.patch
mm-introduce-config_arch_has_lazy_mmu_mode.patch
mm-introduce-generic-lazy_mmu-helpers.patch
mm-bail-out-of-lazy_mmu_mode_-in-interrupt-context.patch
mm-enable-lazy_mmu-sections-to-nest.patch
arm64-mm-replace-tif_lazy_mmu-with-is_lazy_mmu_mode_active.patch
powerpc-mm-replace-batch-active-with-is_lazy_mmu_mode_active.patch
sparc-mm-replace-batch-active-with-is_lazy_mmu_mode_active.patch
x86-xen-use-lazy_mmu_state-when-context-switching.patch
mm-add-basic-tests-for-lazy_mmu.patch
mm-add-basic-tests-for-lazy_mmu-fix-fix-fix.patch
selftests-mm-default-kdir-to-build-directory.patch
selftests-mm-remove-flaky-header-check.patch
selftests-mm-pass-down-full-cc-and-cflags-to-check_configsh.patch
selftests-mm-fix-usage-of-force_read-in-cow-tests.patch
selftests-mm-introduce-helper-to-read-every-page-in-range.patch
selftests-mm-fix-faulting-in-code-in-pagemap_ioctl-test.patch
selftests-mm-fix-exit-code-in-pagemap_ioctl.patch
selftests-mm-report-skip-in-pfnmap-if-a-check-fails.patch

