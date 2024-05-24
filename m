Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A69C074E37
	for <mm-commits@vger.kernel.org>; Fri, 24 May 2024 20:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716581925; cv=none; b=dLl648Rf9ON8R3p0d5va6YmStdvjihOkvfK+OMNBRjUc5TmD9Oc9byR4e4XhL4mviQhdOvN+tlLHS1bQLar+6okk1iaiphGxGuS0KimJCzez5TyXIZksnRbZB5HHLVM8AfZjOeWqS1ah0gda4kATs0F6AJybnjFerI2BRZW+B/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716581925; c=relaxed/simple;
	bh=HwtvYUxP2zvXf+OsR41mAtN0SLsRr5sWiiz+Twbw8s4=;
	h=Date:To:From:Subject:Message-Id; b=ACCihDxylT2vp50DevQ/9TBjDKKUNTV0BD7OxOrHGa2Nj2mjzUWEzW16hQsE6fo67f0reSSyJCnt6HuL95hadXOYaMxPC+HI0rRItvrSzvPAcDh0TEOuvaGmgNXZh7G0EI6TzapeO57+k1MlfEKQCxayTW5f/okyxo0zqYbdDCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qmKdBySb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qmKdBySb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 793EDC2BBFC;
	Fri, 24 May 2024 20:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716581925;
	bh=HwtvYUxP2zvXf+OsR41mAtN0SLsRr5sWiiz+Twbw8s4=;
	h=Date:To:From:Subject:From;
	b=qmKdBySbVSZ+4u/XQ0qCFiPtaL8FJYfJV5opZQYY9cDlqiITI+EQUz9Eqd879f8wg
	 MLqOIvpTqHGGZxVBxUdf8mOdajApXCOW7KOEbG4sDxiwes0R36Xjpvvt3O7q8k+LSa
	 gGtzj+CQUXUhpcNUurr6uRxQXgk6rBv7u1YnL9O0=
Date: Fri, 24 May 2024 13:18:44 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vishal.moola@gmail.com,tony.luck@intel.com,nao.horiguchi@gmail.com,muchun.song@linux.dev,linmiaohe@huawei.com,jiaqiyan@google.com,jglisse@redhat.com,hughd@google.com,david@redhat.com,bcrl@kvack.org,apopple@nvidia.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-migrate_sync_no_copy-mode.patch added to mm-unstable branch
Message-Id: <20240524201845.793EDC2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove MIGRATE_SYNC_NO_COPY mode
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-migrate_sync_no_copy-mode.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-migrate_sync_no_copy-mode.patch

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
Subject: mm: remove MIGRATE_SYNC_NO_COPY mode
Date: Fri, 24 May 2024 13:28:43 +0800

Commit 2916ecc0f9d4 ("mm/migrate: new migrate mode MIGRATE_SYNC_NO_COPY")
introduce a new MIGRATE_SYNC_NO_COPY mode to allow to offload the copy to
a device DMA engine, which is only used __migrate_device_pages() to decide
whether or not copy the old page, and the MIGRATE_SYNC_NO_COPY mode only
set in hmm, as the MIGRATE_SYNC_NO_COPY set is removed by previous
cleanup, it seems that we could remove the unnecessary
MIGRATE_SYNC_NO_COPY.

Link: https://lkml.kernel.org/r/20240524052843.182275-6-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: Jiaqi Yan <jiaqiyan@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c                     |   12 +-----------
 fs/hugetlbfs/inode.c         |    5 +----
 include/linux/migrate_mode.h |    5 -----
 mm/balloon_compaction.c      |    8 --------
 mm/migrate.c                 |    8 +-------
 mm/zsmalloc.c                |    8 --------
 6 files changed, 3 insertions(+), 43 deletions(-)

--- a/fs/aio.c~mm-remove-migrate_sync_no_copy-mode
+++ a/fs/aio.c
@@ -410,17 +410,7 @@ static int aio_migrate_folio(struct addr
 	struct kioctx *ctx;
 	unsigned long flags;
 	pgoff_t idx;
-	int rc;
-
-	/*
-	 * We cannot support the _NO_COPY case here, because copy needs to
-	 * happen under the ctx->completion_lock. That does not work with the
-	 * migration workflow of MIGRATE_SYNC_NO_COPY.
-	 */
-	if (mode == MIGRATE_SYNC_NO_COPY)
-		return -EINVAL;
-
-	rc = 0;
+	int rc = 0;
 
 	/* mapping->i_private_lock here protects against the kioctx teardown.  */
 	spin_lock(&mapping->i_private_lock);
--- a/fs/hugetlbfs/inode.c~mm-remove-migrate_sync_no_copy-mode
+++ a/fs/hugetlbfs/inode.c
@@ -1128,10 +1128,7 @@ static int hugetlbfs_migrate_folio(struc
 		hugetlb_set_folio_subpool(src, NULL);
 	}
 
-	if (mode != MIGRATE_SYNC_NO_COPY)
-		folio_migrate_copy(dst, src);
-	else
-		folio_migrate_flags(dst, src);
+	folio_migrate_copy(dst, src);
 
 	return MIGRATEPAGE_SUCCESS;
 }
--- a/include/linux/migrate_mode.h~mm-remove-migrate_sync_no_copy-mode
+++ a/include/linux/migrate_mode.h
@@ -7,16 +7,11 @@
  *	on most operations but not ->writepage as the potential stall time
  *	is too significant
  * MIGRATE_SYNC will block when migrating pages
- * MIGRATE_SYNC_NO_COPY will block when migrating pages but will not copy pages
- *	with the CPU. Instead, page copy happens outside the migratepage()
- *	callback and is likely using a DMA engine. See migrate_vma() and HMM
- *	(mm/hmm.c) for users of this mode.
  */
 enum migrate_mode {
 	MIGRATE_ASYNC,
 	MIGRATE_SYNC_LIGHT,
 	MIGRATE_SYNC,
-	MIGRATE_SYNC_NO_COPY,
 };
 
 enum migrate_reason {
--- a/mm/balloon_compaction.c~mm-remove-migrate_sync_no_copy-mode
+++ a/mm/balloon_compaction.c
@@ -234,14 +234,6 @@ static int balloon_page_migrate(struct p
 {
 	struct balloon_dev_info *balloon = balloon_page_device(page);
 
-	/*
-	 * We can not easily support the no copy case here so ignore it as it
-	 * is unlikely to be used with balloon pages. See include/linux/hmm.h
-	 * for a user of the MIGRATE_SYNC_NO_COPY mode.
-	 */
-	if (mode == MIGRATE_SYNC_NO_COPY)
-		return -EINVAL;
-
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 	VM_BUG_ON_PAGE(!PageLocked(newpage), newpage);
 
--- a/mm/migrate.c~mm-remove-migrate_sync_no_copy-mode
+++ a/mm/migrate.c
@@ -671,10 +671,7 @@ static int __migrate_folio(struct addres
 	if (src_private)
 		folio_attach_private(dst, folio_detach_private(src));
 
-	if (mode != MIGRATE_SYNC_NO_COPY)
-		folio_migrate_copy(dst, src);
-	else
-		folio_migrate_flags(dst, src);
+	folio_migrate_copy(dst, src);
 	return MIGRATEPAGE_SUCCESS;
 }
 
@@ -903,7 +900,6 @@ static int fallback_migrate_folio(struct
 		/* Only writeback folios in full synchronous migration */
 		switch (mode) {
 		case MIGRATE_SYNC:
-		case MIGRATE_SYNC_NO_COPY:
 			break;
 		default:
 			return -EBUSY;
@@ -1161,7 +1157,6 @@ static int migrate_folio_unmap(new_folio
 		 */
 		switch (mode) {
 		case MIGRATE_SYNC:
-		case MIGRATE_SYNC_NO_COPY:
 			break;
 		default:
 			rc = -EBUSY;
@@ -1372,7 +1367,6 @@ static int unmap_and_move_huge_page(new_
 			goto out;
 		switch (mode) {
 		case MIGRATE_SYNC:
-		case MIGRATE_SYNC_NO_COPY:
 			break;
 		default:
 			goto out;
--- a/mm/zsmalloc.c~mm-remove-migrate_sync_no_copy-mode
+++ a/mm/zsmalloc.c
@@ -1752,14 +1752,6 @@ static int zs_page_migrate(struct page *
 	unsigned long old_obj, new_obj;
 	unsigned int obj_idx;
 
-	/*
-	 * We cannot support the _NO_COPY case here, because copy needs to
-	 * happen under the zs lock, which does not work with
-	 * MIGRATE_SYNC_NO_COPY workflow.
-	 */
-	if (mode == MIGRATE_SYNC_NO_COPY)
-		return -EINVAL;
-
 	VM_BUG_ON_PAGE(!PageIsolated(page), page);
 
 	/* The page is locked, so this pointer must remain valid */
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

