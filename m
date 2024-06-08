Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A233428FA
	for <mm-commits@vger.kernel.org>; Sat,  8 Jun 2024 02:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717812939; cv=none; b=XqvM11l3idyhwCu2bdC1wx9XxDwpBTJNirffk5P9lJ/TBSKoQ4F1xBGdGzG+CRqZI0z2xJFF8Hl0eib3XKViNKCVKR65S5MnANIZBkUO6/h44gQUTavN/9MLMRDiwRJk5FQa1t2cSIopGUKCdCpmRsSMO8cQzhx0nr5uKS2yGKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717812939; c=relaxed/simple;
	bh=DsL/6bfIU4xzBouAp+3waTZuMRMn/q1Yto+zvksptro=;
	h=Date:To:From:Subject:Message-Id; b=Rpmyv+3HdJXZDPmyiRtB2yRVIeKJR3YfQvTBoWTVcY8ZzOB8FJX2NVkjNJwoEN1ekl58xBsstnJGgPDfeWfsBlDded9ud83ifwOVZH4l+9REu67lwe9aowurEEisDIaoJufC78Yw+2dKteGCWOFkmy0WfJ2yB/vCqK4p5OYvT3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ez9Ty8Q8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ez9Ty8Q8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2448BC2BBFC;
	Sat,  8 Jun 2024 02:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717812939;
	bh=DsL/6bfIU4xzBouAp+3waTZuMRMn/q1Yto+zvksptro=;
	h=Date:To:From:Subject:From;
	b=Ez9Ty8Q81+NTpAlNLFTSmlCt5ZyNf8IUz02YU5qFRaZ6LvCCkN/75QjO24NPNBXvq
	 GnVMu5uWkO5ZKdQE/ZStEXg4Bylw8zMnNSg/qDDVbggnh9B+r2XVSWwa3oZJvPmBfD
	 sz/+W48IfY74lingIryEyCVLpIosXZSWmfdRlhOQ=
Date: Fri, 07 Jun 2024 19:15:38 -0700
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-page_mkclean-fix.patch added to mm-unstable branch
Message-Id: <20240608021539.2448BC2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: pin_user_pages: fix underline length
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-page_mkclean-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-page_mkclean-fix.patch

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
Subject: pin_user_pages: fix underline length
Date: Fri, 7 Jun 2024 14:46:57 +0800

Documentation/core-api/pin_user_pages.rst:200: WARNING: Title underline too short.
folio_maybe_dma_pinned(): the whole point of pinning
===================================================

Link: https://lkml.kernel.org/r/20240607064657.681997-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/core-api/pin_user_pages.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/core-api/pin_user_pages.rst~mm-remove-page_mkclean-fix
+++ a/Documentation/core-api/pin_user_pages.rst
@@ -197,7 +197,7 @@ INCORRECT (uses FOLL_GET calls):
     put_page()
 
 folio_maybe_dma_pinned(): the whole point of pinning
-===================================================
+====================================================
 
 The whole point of marking folios as "DMA-pinned" or "gup-pinned" is to be able
 to query, "is this folio DMA-pinned?" That allows code such as folio_mkclean()
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-fix-possible-oob-in-numa_rebuild_large_mapping.patch
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
fb_defio-use-a-folio-in-fb_deferred_io_work.patch
mm-remove-page_mkclean.patch
mm-remove-page_mkclean-fix.patch
mm-move-memory_failure_queue-into-copy_mc__highpage.patch
mm-add-folio_mc_copy.patch
mm-migrate-split-folio_migrate_mapping.patch
mm-migrate-support-poisoned-recover-from-migrate-folio.patch
fs-hugetlbfs-support-poison-recover-from-hugetlbfs_migrate_folio.patch
mm-migrate-remove-folio_migrate_copy.patch

