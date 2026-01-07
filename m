Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3DB3357A3C
	for <mm-commits@vger.kernel.org>; Wed,  7 Jan 2026 17:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767806505; cv=none; b=AqbMxuSPp1EJxubSvAPaXaq2l5T0nY3MlPqKxq6ccuh3xQOxgZuD4A7Rvp4swPASb0YfTUnUFK8TilwvElG7T2mhRHxyY6taZE6HbieSptWmvc+1VlVrNF/DdnrOQNRScU+1MylMestiF1pHDL/w3KFUqcFkgggokckPNlqyAbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767806505; c=relaxed/simple;
	bh=qTDAdnRkbadUy3Y0gT08CzXCCpx2I/31E2un6Lo+Ijs=;
	h=Date:To:From:Subject:Message-Id; b=sDNdDtzu4GeU1Cpy5CDL1OZ2PDZ8YCN3cxnJ2AceWrNhSoIE+zC5NTahQYOc1+zMOpH2qqMcpwsfGn94CapXJ8Ha4BY36B286MFpdl1JKyhz5MewaCsN8YMZ/c8bANhUfWqrv5ho2r8NQNeiaDkxon97EUTUkCYriTlVMw4dg5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jI8+vDeT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jI8+vDeT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06729C4CEF1;
	Wed,  7 Jan 2026 17:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767806504;
	bh=qTDAdnRkbadUy3Y0gT08CzXCCpx2I/31E2un6Lo+Ijs=;
	h=Date:To:From:Subject:From;
	b=jI8+vDeTOaeuO63H9NG1K+GC6a4g6Bt6MnIiVsJghhNn3TQzBW1hXfu+Bb1kEAYNG
	 UDb7TI7fzT+Cg8s64l+0hlcCNX/W66ToqfkDfg+mL9NR+fRDtr5kmK37XqpzAqMPG9
	 fmaQcEAyHPlBJWrLVCADdHNGqljIrlCakuT1iF+k=
Date: Wed, 07 Jan 2026 09:21:43 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,Usama.Anjum@arm.com,surenb@google.com,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,pabeni@redhat.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,linyunsheng@huawei.com,Liam.Howlett@oracle.com,jhubbard@nvidia.com,jgg@nvidia.com,david@kernel.org,broonie@kernel.org,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-faulting-in-code-in-pagemap_ioctl-test.patch added to mm-new branch
Message-Id: <20260107172144.06729C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: fix faulting-in code in pagemap_ioctl test
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-fix-faulting-in-code-in-pagemap_ioctl-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-faulting-in-code-in-pagemap_ioctl-test.patch

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
Subject: selftests/mm: fix faulting-in code in pagemap_ioctl test
Date: Wed, 7 Jan 2026 16:48:40 +0000

One of the pagemap_ioctl tests attempts to fault in pages by memcpy()'ing
them to an unused buffer.  This probably worked originally, but since
commit 46036188ea1f ("selftests/mm: build with -O2") the compiler is free
to optimise away that unused buffer and the memcpy() with it.  As a result
there might not be any resident page in the mapping and the test may fail.

We don't need to copy all that memory anyway.  Just fault in every page.

Link: https://lkml.kernel.org/r/20260107164842.3289559-7-kevin.brodsky@arm.com
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Usama Anjum <Usama.Anjum@arm.com>
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
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/pagemap_ioctl.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/tools/testing/selftests/mm/pagemap_ioctl.c~selftests-mm-fix-faulting-in-code-in-pagemap_ioctl-test
+++ a/tools/testing/selftests/mm/pagemap_ioctl.c
@@ -1056,7 +1056,6 @@ int sanity_tests(void)
 	struct page_region *vec;
 	char *mem, *fmem;
 	struct stat sbuf;
-	char *tmp_buf;
 
 	/* 1. wrong operation */
 	mem_size = 10 * page_size;
@@ -1167,8 +1166,7 @@ int sanity_tests(void)
 	if (fmem == MAP_FAILED)
 		ksft_exit_fail_msg("error nomem %d %s\n", errno, strerror(errno));
 
-	tmp_buf = malloc(sbuf.st_size);
-	memcpy(tmp_buf, fmem, sbuf.st_size);
+	force_read_pages_in_range(fmem, sbuf.st_size);
 
 	ret = pagemap_ioctl(fmem, sbuf.st_size, vec, vec_size, 0, 0,
 			    0, PAGEMAP_NON_WRITTEN_BITS, 0, PAGEMAP_NON_WRITTEN_BITS);
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

