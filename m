Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F61615E5BB
	for <mm-commits@vger.kernel.org>; Tue, 18 Jun 2024 19:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718740652; cv=none; b=NQAaicrTiAI9/hNr227RqFJ4VmmYWTYzjULkhcU/lAP2Cz/UXmaSa7WJoDBSE5X30LRbbdwJHMYgEU5n/FK09BQS8BaLEPy/m+hKTTY656A5kTkJ6orgLdzV3ZUhfaHK/tG5TZAxvCwZF6jmzeVnAIquVdcisqBZNJHEbSqApek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718740652; c=relaxed/simple;
	bh=pqfXqtJ6TzBUNfwEJhcmLtDAie0+5L2zAY+nHbiikww=;
	h=Date:To:From:Subject:Message-Id; b=Ny6uE1Ca+K43Qm6LKu4FdaA/Bpof8x8zrkYtDMqm/XrOtvlphmitZIWkxJaTdVK71Bncn2EmmhMljAGAST2q3IG0hVHp2boHBo1fsw8pGa941FPt/3JMpbHg+OllolW4uI0fxEkGo7bIlwlaN5TgCn8L8nL6W/30lRMEtl4VIUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LmgcbZDj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LmgcbZDj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75EB3C3277B;
	Tue, 18 Jun 2024 19:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718740651;
	bh=pqfXqtJ6TzBUNfwEJhcmLtDAie0+5L2zAY+nHbiikww=;
	h=Date:To:From:Subject:From;
	b=LmgcbZDjdP7u1ubDwIB4mz4eYLAevrClVK9SAnybWEqZyZfvBSYDoIMfBjSn62a9Z
	 7anzGYicFKoPcujlisrf99tPIPRWJWR1CdM7VjGLY90zSfzssfW5bB4l0C4QtW7dfn
	 /sypR/Y5VoNld8W0OEcq5q3ERDEFFobe0Op7b/nY=
Date: Tue, 18 Jun 2024 12:57:30 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-ksm-drop-ksm_kmem_cache.patch added to mm-unstable branch
Message-Id: <20240618195731.75EB3C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: ksm: drop KSM_KMEM_CACHE()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-ksm-drop-ksm_kmem_cache.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-ksm-drop-ksm_kmem_cache.patch

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
Subject: mm: ksm: drop KSM_KMEM_CACHE()
Date: Tue, 18 Jun 2024 16:12:01 +0800

After commit 21fbd59136e0 ("ksm: add the ksm prefix to the names of the
ksm private structures"), we could directly use KMEM_CACHE().

Link: https://lkml.kernel.org/r/20240618081201.134985-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- a/mm/ksm.c~mm-ksm-drop-ksm_kmem_cache
+++ a/mm/ksm.c
@@ -488,21 +488,17 @@ static DECLARE_WAIT_QUEUE_HEAD(ksm_iter_
 static DEFINE_MUTEX(ksm_thread_mutex);
 static DEFINE_SPINLOCK(ksm_mmlist_lock);
 
-#define KSM_KMEM_CACHE(__struct, __flags) kmem_cache_create(#__struct,\
-		sizeof(struct __struct), __alignof__(struct __struct),\
-		(__flags), NULL)
-
 static int __init ksm_slab_init(void)
 {
-	rmap_item_cache = KSM_KMEM_CACHE(ksm_rmap_item, 0);
+	rmap_item_cache = KMEM_CACHE(ksm_rmap_item, 0);
 	if (!rmap_item_cache)
 		goto out;
 
-	stable_node_cache = KSM_KMEM_CACHE(ksm_stable_node, 0);
+	stable_node_cache = KMEM_CACHE(ksm_stable_node, 0);
 	if (!stable_node_cache)
 		goto out_free1;
 
-	mm_slot_cache = KSM_KMEM_CACHE(ksm_mm_slot, 0);
+	mm_slot_cache = KMEM_CACHE(ksm_mm_slot, 0);
 	if (!mm_slot_cache)
 		goto out_free2;
 
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
mm-move-memory_failure_queue-into-copy_mc__highpage.patch
mm-add-folio_mc_copy.patch
mm-migrate-split-folio_migrate_mapping.patch
mm-migrate-support-poisoned-recover-from-migrate-folio.patch
fs-hugetlbfs-support-poison-recover-from-hugetlbfs_migrate_folio.patch
mm-migrate-remove-folio_migrate_copy.patch
mm-memory-convert-clear_huge_page-to-folio_zero_user.patch
mm-memory-use-folio-in-struct-copy_subpage_arg.patch
mm-memory-improve-copy_user_large_folio.patch
mm-memory-rename-pages_per_huge_page-to-nr_pages.patch
mm-ksm-drop-ksm_kmem_cache.patch

