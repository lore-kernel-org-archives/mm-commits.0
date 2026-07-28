Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 074C423393E
	for <mm-commits@vger.kernel.org>; Tue, 28 Jul 2026 00:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785199140; cv=none; b=RLfvoTlyweSPP2i2SDgSsXo5zK48DrpgJ4hRVsJmK34QtMjA50c7+zx2NqJgmr44CBq6hGXB++9X0gIEAZVZMhUFSZm3Phn7iuNcaSdlk4A/YLksR9PI4tV2H3CCXnvFfCnhpUhFhkFdFUskA2pUD5U/F+ePuIIx6YR9vNB+zHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785199140; c=relaxed/simple;
	bh=N61HAc3y9tyN5b0Da1j4CfWpx0fI4/fXQTVNwz2kfmY=;
	h=Date:To:From:Subject:Message-Id; b=IwKbmfV1X65BnKOh7rBUiVzakyI2jl6Za77FWrIw3gpvrmH0rSB0S9kxBHjdT9+vnvrvyvRItstysgCtTdNBgO0W4S837h8ls1o7BPzEXmkz60qMNd2zsuqR7Zf/UWfCrQoj3zawZwcutbOOROyLfE9xL6bNkQmYVhVBkORBHxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iPKZq4Q+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iPKZq4Q+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77FB91F000E9;
	Tue, 28 Jul 2026 00:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785199138;
	bh=cCGCMPQiDOocC9O+e/wEYGSbydqnqifl3eQ+BbWQC3A=;
	h=Date:To:From:Subject;
	b=iPKZq4Q+S8PfK54cJZV8ZNYvg2V/H0OaEYoDpyurUoEa4opQ7Qa2fTZ5nKJOmMcgi
	 Ig6bU3EXvMKK6HlmPvIo1QVYNa3n4YQ9sgpqXNodqZBI5sHo9FXVeFD7D/2jLhGsxZ
	 DZHg9soxr0gGndk1QplOIbI5XTa7iqlckqI+BrSg=
Date: Mon, 27 Jul 2026 17:38:58 -0700
To: mm-commits@vger.kernel.org,skinsburskii@gmail.com,leon@kernel.org,jgg@ziepe.ca,david@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hmm-make-config_hmm_mirror-select-config_mmu_notifier.patch added to mm-unstable branch
Message-Id: <20260728003858.77FB91F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hmm: make CONFIG_HMM_MIRROR select CONFIG_MMU_NOTIFIER
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hmm-make-config_hmm_mirror-select-config_mmu_notifier.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hmm-make-config_hmm_mirror-select-config_mmu_notifier.patch

This patch will later appear in the mm-unstable branch at
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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/hmm: make CONFIG_HMM_MIRROR select CONFIG_MMU_NOTIFIER
Date: Mon Jul 27 05:31:14 PM PDT 2026

hmm doesn't currently build well with MMU_NOTIFIER=n:

With microblaze
https://download.01.org/0day-ci/archive/20260702/202607021433.DYT5fDqE-lkp@intel.com/config
(CONFIG_MMU_NOTIFIER=n):

mm/hmm.c: In function 'hmm_range_fault_unlocked_timeout':
mm/hmm.c:804:25: error: implicit declaration of function 'mmu_interval_read_begin'; did you mean 'mmu_interval_check_retry'? [-Wimplicit-function-declaration]
  804 |                         mmu_interval_read_begin(range->notifier);
      |                         ^~~~~~~~~~~~~~~~~~~~~~~
      |                         mmu_interval_check_retry

Quoting Stanislav:

:  Documentation/mm/hmm.rst explicitly states:
: 
:  "Address space mirroring's main objective is to allow duplication of a
:  range of CPU page table into a device page table; HMM helps keep both
:  synchronized.  A device driver that wants to mirror a process address
:  space must start with the registration of a mmu_interval_notifier"
: 
:  I think making CONFIG_HMM_MIRROR dependent on the CONFIG_MMU_NOTIFIER
:  is the right thing to do.

So select MMU_NOTIFIER if hmm.c is to be compiled.

Cc: David Hildenbrand <david@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Stanislav Kinsburskii <skinsburskii@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/Kconfig~mm-hmm-make-config_hmm_mirror-select-config_mmu_notifier
+++ a/mm/Kconfig
@@ -1250,6 +1250,7 @@ config ZONE_DEVICE
 config HMM_MIRROR
 	bool
 	depends on MMU
+	select MMU_NOTIFIER
 
 config GET_FREE_REGION
 	bool
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-mincore-use-walk_page_range_vma-in-do_mincore-fix.patch
csky-implement-flush_cache_vmap-in-c.patch
mm-annotate-data-race-in-cpu_needs_drain-fix.patch
mm-zsmalloc-encode-class-index-in-obj-value-for-lockless-class-lookup-fix.patch
mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix.patch
mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix-fix.patch
mm-rmap-use-huge_ptep_get-in-try_to_migrate_one-checkpatch-fixes.patch
mm-mprotect-use-huge_ptep_get-for-hugetlb-fix.patch
mm-drop-stale-folio_ref_count==1-check-in-do_swap_page-reuse-logic-fix.patch
alloc_tag-add-ioctl-to-proc-allocinfo-fix.patch
mm-hmm-make-config_hmm_mirror-select-config_mmu_notifier.patch
mm-vma-add-and-use-vma__pgoff-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

