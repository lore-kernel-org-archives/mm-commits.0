Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93AF518EAB
	for <mm-commits@vger.kernel.org>; Tue, 11 Jun 2024 22:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718143256; cv=none; b=p8lOiChgZB/tb+F1Q/pogoraF0+RC66CTZwHvwgsS9154K9sXwGDADZ/N4mpVOYUANylMxvkriHzZOVGJHgRh38ML64uy0aiXwl0W+yIaWh4Ih7D/iNvY0ETJ8fxS9pJpHHjCWAAWj0AdEKZ0qMyAZYQvNL+IGl061E28iCJzws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718143256; c=relaxed/simple;
	bh=LHadjlN+PkSaqS5FB/P8WtEmt6FoBDeIKnfVBEszA6A=;
	h=Date:To:From:Subject:Message-Id; b=jbpQDY/SLzRr0lvdCNRj8Jl25HT6goHY6BNf6uX2qOBNVon49D11Z0MzaH2DA5uwZOJdh9sJNtDsrUyZTruAc24aSPfMIK15zbt8vAwmYyguueH9zw5b1K14O/QhE2s0Df56FETVKkr8w5qkWmHtvOLMojPSPzaXMkfS2HXpJdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WHrSD9/r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WHrSD9/r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DFA9C2BD10;
	Tue, 11 Jun 2024 22:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718143256;
	bh=LHadjlN+PkSaqS5FB/P8WtEmt6FoBDeIKnfVBEszA6A=;
	h=Date:To:From:Subject:From;
	b=WHrSD9/rvnE+/1Kbe1nCWF2ruhZHGQ2a2A0FrHpHO8JhyPr6AeqAPnTckazmaHbu3
	 QKyaeM28ldxIGbZ1Kq4HWtnha2VFZ1aWV7YGq2RvCuoDDb3c0SD07q1QHrIIh6Z5QW
	 ApYRjKpPSN66DwWwxbMRGHzUJGrzU23OKAu8aYQk=
Date: Tue, 11 Jun 2024 15:00:55 -0700
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-page_maybe_dma_pinned-fix.patch added to mm-unstable branch
Message-Id: <20240611220056.0DFA9C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-remove-page_maybe_dma_pinned-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-page_maybe_dma_pinned-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-page_maybe_dma_pinned-fix.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm-remove-page_maybe_dma_pinned-fix
Date: Thu, 6 Jun 2024 11:36:29 +0800

fix pin_user_pages.rst underlining

Link: https://lkml.kernel.org/r/61b256c7-4989-44ec-83db-f34a1bd4be2d@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/core-api/pin_user_pages.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/core-api/pin_user_pages.rst~mm-remove-page_maybe_dma_pinned-fix
+++ a/Documentation/core-api/pin_user_pages.rst
@@ -197,7 +197,7 @@ INCORRECT (uses FOLL_GET calls):
     put_page()
 
 folio_maybe_dma_pinned(): the whole point of pinning
-===================================================
+====================================================
 
 The whole point of marking folios as "DMA-pinned" or "gup-pinned" is to be able
 to query, "is this folio DMA-pinned?" That allows code such as page_mkclean()
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-add-folio_alloc_mpol.patch
mm-mempolicy-use-folio_alloc_mpol_noprof-in-vma_alloc_folio_noprof.patch
mm-mempolicy-use-folio_alloc_mpol-in-alloc_migration_target_by_mpol.patch
mm-shmem-use-folio_alloc_mpol-in-shmem_alloc_folio.patch
mm-refactor-folio_undo_large_rmappable.patch
mm-memcontrol-remove-page_memcg.patch
rmap-remove-define_page_vma_walk.patch
mm-migrate-simplify-__buffer_migrate_folio.patch
mm-migrate_device-use-a-newfolio-in-__migrate_device_pages.patch
mm-migrate_device-unify-migrate-folio-for-migrate_sync_no_copy.patch
mm-migrate-remove-migrate_folio_extra.patch
mm-remove-migrate_sync_no_copy-mode.patch
fs-proc-task_mmu-use-folio-api-in-pte_is_pinned.patch
mm-remove-page_maybe_dma_pinned.patch
mm-remove-page_maybe_dma_pinned-fix.patch
fb_defio-use-a-folio-in-fb_deferred_io_work.patch
mm-remove-page_mkclean.patch
mm-remove-page_mkclean-fix.patch
mm-move-memory_failure_queue-into-copy_mc__highpage.patch
mm-add-folio_mc_copy.patch
mm-migrate-split-folio_migrate_mapping.patch
mm-migrate-support-poisoned-recover-from-migrate-folio.patch
fs-hugetlbfs-support-poison-recover-from-hugetlbfs_migrate_folio.patch
mm-migrate-remove-folio_migrate_copy.patch

