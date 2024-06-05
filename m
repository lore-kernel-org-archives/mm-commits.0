Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76DA661FC0
	for <mm-commits@vger.kernel.org>; Wed,  5 Jun 2024 03:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717558307; cv=none; b=SFXxWNCeLi/t241D4rbfD8CACN2PcwEwcnBUjv/nAW/hmjLOBoog7l3vAK06MYX6GFMjIaZ1ZsIKR8CZ1LxJPDIsEH6FAw8ueFm7HeLLxv+6yhytEHkfhWT+AG8E5NHLrdKHawdnmeIWydAlxzXg+qrh4A6NJmwu0IlAV3Vq2pI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717558307; c=relaxed/simple;
	bh=pQn+sbzS1SAuQYZGu9BwflFLGAKifQxad1Z0CT74hQI=;
	h=Date:To:From:Subject:Message-Id; b=SB9XSF+eS5XLbD2DGSz+oMrdqLAq7kk9kUJ91r9Fv1fpEXe8CCdDc6TtJAhuarqFy7i1NfIiM+iN80T/3RCi7ESD/IjOKR00nrOxdEjVsHQj8pkfWb5yMtD2lRAeufWha2VGDOa/V9io9iHr89WwBrTaM0Kj2jFCdXhCglHkeKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RLggxW/u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RLggxW/u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CC8AC32781;
	Wed,  5 Jun 2024 03:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717558307;
	bh=pQn+sbzS1SAuQYZGu9BwflFLGAKifQxad1Z0CT74hQI=;
	h=Date:To:From:Subject:From;
	b=RLggxW/uOwB8kYsZJlvd92t/WWF+S9or+d20Z87Y3HVKZJyqi8X7bOZKDNby4Ym4L
	 N7mWm7acR+SC1iIr66pLyNBY9FuaJKvTFJSyw9QyrGCdcvFIHoog2dxPayqA2BCZAW
	 VabtzgQCAoxO9+zlK+oqoVTSYXKgquLfcaGnjR70=
Date: Tue, 04 Jun 2024 20:31:46 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,tony.luck@intel.com,osalvador@suse.de,nao.horiguchi@gmail.com,muchun.song@linux.dev,linmiaohe@huawei.com,jiaqiyan@google.com,jglisse@redhat.com,jane.chu@oracle.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,bcrl@kvack.org,apopple@nvidia.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-remove-folio_migrate_copy.patch added to mm-unstable branch
Message-Id: <20240605033147.3CC8AC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: migrate: remove folio_migrate_copy()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate-remove-folio_migrate_copy.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-remove-folio_migrate_copy.patch

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
Subject: mm: migrate: remove folio_migrate_copy()
Date: Mon, 3 Jun 2024 17:24:39 +0800

The folio_migrate_copy() is just a wrapper of folio_copy() and
folio_migrate_flags(), it is simple and only aio use it for now, unfold it
and remove folio_migrate_copy().

Link: https://lkml.kernel.org/r/20240603092439.3360652-7-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: Jiaqi Yan <jiaqiyan@google.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c                |    3 ++-
 include/linux/migrate.h |    1 -
 mm/migrate.c            |    7 -------
 3 files changed, 2 insertions(+), 9 deletions(-)

--- a/fs/aio.c~mm-migrate-remove-folio_migrate_copy
+++ a/fs/aio.c
@@ -455,7 +455,8 @@ static int aio_migrate_folio(struct addr
 	 * events from being lost.
 	 */
 	spin_lock_irqsave(&ctx->completion_lock, flags);
-	folio_migrate_copy(dst, src);
+	folio_copy(dst, src);
+	folio_migrate_flags(dst, src);
 	BUG_ON(ctx->ring_folios[idx] != src);
 	ctx->ring_folios[idx] = dst;
 	spin_unlock_irqrestore(&ctx->completion_lock, flags);
--- a/include/linux/migrate.h~mm-migrate-remove-folio_migrate_copy
+++ a/include/linux/migrate.h
@@ -76,7 +76,6 @@ int migrate_huge_page_move_mapping(struc
 void migration_entry_wait_on_locked(swp_entry_t entry, spinlock_t *ptl)
 		__releases(ptl);
 void folio_migrate_flags(struct folio *newfolio, struct folio *folio);
-void folio_migrate_copy(struct folio *newfolio, struct folio *folio);
 int folio_migrate_mapping(struct address_space *mapping,
 		struct folio *newfolio, struct folio *folio, int extra_count);
 
--- a/mm/migrate.c~mm-migrate-remove-folio_migrate_copy
+++ a/mm/migrate.c
@@ -652,13 +652,6 @@ void folio_migrate_flags(struct folio *n
 }
 EXPORT_SYMBOL(folio_migrate_flags);
 
-void folio_migrate_copy(struct folio *newfolio, struct folio *folio)
-{
-	folio_copy(newfolio, folio);
-	folio_migrate_flags(newfolio, folio);
-}
-EXPORT_SYMBOL(folio_migrate_copy);
-
 /************************************************************
  *                    Migration functions
  ***********************************************************/
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
fb_defio-use-a-folio-in-fb_deferred_io_work.patch
mm-remove-page_mkclean.patch
mm-move-memory_failure_queue-into-copy_mc__highpage.patch
mm-add-folio_mc_copy.patch
mm-migrate-split-folio_migrate_mapping.patch
mm-migrate-support-poisoned-recover-from-migrate-folio.patch
fs-hugetlbfs-support-poison-recover-from-hugetlbfs_migrate_folio.patch
mm-migrate-remove-folio_migrate_copy.patch

