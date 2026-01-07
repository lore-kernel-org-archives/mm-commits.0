Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFE2434B69F
	for <mm-commits@vger.kernel.org>; Wed,  7 Jan 2026 17:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767806494; cv=none; b=Ka+kRGxeu5zrs/SSini6QM1/1VnnZ0nnm12s3XxUnTylzJI1DV6g7eb/rx57fTM6LucxdoqFgMFoVsLsGaNTKxt3/2WveN88bmBFkx/Wa4LuPNTBxBdvfSaHUidkSEtBxwneY4B6MJrTv8tucnvjDnrKTO0etVALNpInpmoYZeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767806494; c=relaxed/simple;
	bh=2L3XN5Fzxdseua4NJChz95Elf3DPbtCeUcs39ytTzaY=;
	h=Date:To:From:Subject:Message-Id; b=hYLSiXsNwfQExF2bBLD/A1nFB6JCpQk691Ti3DMidZuvlnGdJAFLj7IuQ474KhKMq/ruVWS7SUon8IQuT4KJuj5633yhosNkNyUF864hvTjjSEZMP2QO5FwKqgintnDSvxiEKn7N/RSGnrQe4zDrVODff3YVpw/karSsN+P0DHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=R78B5um6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="R78B5um6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33EDAC4CEF7;
	Wed,  7 Jan 2026 17:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767806493;
	bh=2L3XN5Fzxdseua4NJChz95Elf3DPbtCeUcs39ytTzaY=;
	h=Date:To:From:Subject:From;
	b=R78B5um6C0yJ58c2Cq4Pi0dhXjag1LGHZIWud6qMd6GFks9jfN/Jx6jVb6WoUQSWN
	 smnxw8tZ0VWfKFCVJ3YRenOXI7bnr/7oz6UfpoMi+ul6T4Ak32Anv94Rye7TQ16MWg
	 Kn5Gh2BV/qwPS9vOIXR94q+lAiB+/0AWByqHmrbs=
Date: Wed, 07 Jan 2026 09:21:32 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,Usama.Anjum@arm.com,surenb@google.com,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,pabeni@redhat.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,linyunsheng@huawei.com,Liam.Howlett@oracle.com,jhubbard@nvidia.com,jgg@nvidia.com,david@kernel.org,broonie@kernel.org,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-remove-flaky-header-check.patch added to mm-new branch
Message-Id: <20260107172133.33EDAC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: remove flaky header check
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-remove-flaky-header-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-remove-flaky-header-check.patch

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
Subject: selftests/mm: remove flaky header check
Date: Wed, 7 Jan 2026 16:48:36 +0000

Commit 96ed62ea0298 ("mm: page_frag: fix a compile error when kernel is
not compiled") introduced a check to avoid attempting to build the
page_frag module if <linux/page_frag_cache.h> is missing.

Unfortunately this check only works if KDIR points to /lib/modules/...  or
an in-tree kernel build.  It always fails if KDIR points to an out-of-tree
build (i.e.  when the kernel was built with O=...  make) because only
generated headers are present under $KDIR/include/ in that case.

A recent commit switched KDIR to default to the kernel's build directory,
so that check is no longer justified.

Link: https://lkml.kernel.org/r/20260107164842.3289559-3-kevin.brodsky@arm.com
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Yunsheng Lin <linyunsheng@huawei.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Usama Anjum <Usama.Anjum@arm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/Makefile |    4 ----
 1 file changed, 4 deletions(-)

--- a/tools/testing/selftests/mm/Makefile~selftests-mm-remove-flaky-header-check
+++ a/tools/testing/selftests/mm/Makefile
@@ -46,12 +46,8 @@ CFLAGS += -U_FORTIFY_SOURCE
 
 KDIR ?= $(if $(O),$(O),$(realpath ../../../..))
 ifneq (,$(wildcard $(KDIR)/Module.symvers))
-ifneq (,$(wildcard $(KDIR)/include/linux/page_frag_cache.h))
 TEST_GEN_MODS_DIR := page_frag
 else
-PAGE_FRAG_WARNING = "missing page_frag_cache.h, please use a newer kernel"
-endif
-else
 PAGE_FRAG_WARNING = "missing Module.symvers, please have the kernel built first"
 endif
 
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

