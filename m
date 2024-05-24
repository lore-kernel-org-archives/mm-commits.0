Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91214745D6
	for <mm-commits@vger.kernel.org>; Fri, 24 May 2024 20:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716581923; cv=none; b=KBEsWIlqs1xCvPtAEqqdDJVeBiAAsRt9Z1sXFht+JQSdGAHsywJOZduVcTpQtJDX8qDNdEIRbgWEkq0cujb3XVxhiMhaiJiG0XLqtHBLUORvxayvQ7+FhElMVTmwzjzar2Mge0cmfquaOiudbyZ6xuQ74bFp0EgqA8MvOlf9XbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716581923; c=relaxed/simple;
	bh=L43wcXxyxBcy9Y78Cmeyqs9DdMIgl98MVab7E3KwC4Y=;
	h=Date:To:From:Subject:Message-Id; b=pE0/V1cQXEn6nEJHhMn0P4y6d7HmBT72U0TDS8l66HD0cr0TCuOmSUH4WRnLILld09/LxI+v/SxWw0ue2akHHiFtAUvlrd79cCzq+qUhKtu+7Pium/fRVXAteJl5ENLakhIZZpniQqJYmXOHHDjCiUnWIABBRAYUCYDBrZ0Rahk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=O3yP7J9y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="O3yP7J9y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29FE0C2BBFC;
	Fri, 24 May 2024 20:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716581923;
	bh=L43wcXxyxBcy9Y78Cmeyqs9DdMIgl98MVab7E3KwC4Y=;
	h=Date:To:From:Subject:From;
	b=O3yP7J9ytKWerdZhTEMMDUHfRMtMuWHhrB770XJxCFhgBF+9xPx7Jtb+9MGZTbTPF
	 PHc2ZXHd/K0OKHMZ0BGXDQYHrqmUxic4MVtOOIlL72KmoLIJrTXgrCzkf0wHNaYx1b
	 KgpvovCSYFxs4cqpdh14wKtZpgzbR73DPnHG8dJA=
Date: Fri, 24 May 2024 13:18:42 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vishal.moola@gmail.com,tony.luck@intel.com,nao.horiguchi@gmail.com,muchun.song@linux.dev,linmiaohe@huawei.com,jiaqiyan@google.com,jglisse@redhat.com,hughd@google.com,david@redhat.com,bcrl@kvack.org,apopple@nvidia.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-remove-migrate_folio_extra.patch added to mm-unstable branch
Message-Id: <20240524201843.29FE0C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: migrate: remove migrate_folio_extra()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate-remove-migrate_folio_extra.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-remove-migrate_folio_extra.patch

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
Subject: mm: migrate: remove migrate_folio_extra()
Date: Fri, 24 May 2024 13:28:42 +0800

migrate_folio_extra() is only called in migrate.c now, convert it a static
function and take a new src_private argument which could be shared by
migrate_folio() and filemap_migrate_folio() to simplify code a bit.

Link: https://lkml.kernel.org/r/20240524052843.182275-5-wangkefeng.wang@huawei.com
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

 include/linux/migrate.h |    2 --
 mm/migrate.c            |   33 +++++++++++----------------------
 2 files changed, 11 insertions(+), 24 deletions(-)

--- a/include/linux/migrate.h~mm-migrate-remove-migrate_folio_extra
+++ a/include/linux/migrate.h
@@ -63,8 +63,6 @@ extern const char *migrate_reason_names[
 #ifdef CONFIG_MIGRATION
 
 void putback_movable_pages(struct list_head *l);
-int migrate_folio_extra(struct address_space *mapping, struct folio *dst,
-		struct folio *src, enum migrate_mode mode, int extra_count);
 int migrate_folio(struct address_space *mapping, struct folio *dst,
 		struct folio *src, enum migrate_mode mode);
 int migrate_pages(struct list_head *l, new_folio_t new, free_folio_t free,
--- a/mm/migrate.c~mm-migrate-remove-migrate_folio_extra
+++ a/mm/migrate.c
@@ -658,18 +658,19 @@ EXPORT_SYMBOL(folio_migrate_copy);
  *                    Migration functions
  ***********************************************************/
 
-int migrate_folio_extra(struct address_space *mapping, struct folio *dst,
-		struct folio *src, enum migrate_mode mode, int extra_count)
+static int __migrate_folio(struct address_space *mapping, struct folio *dst,
+			   struct folio *src, void *src_private,
+			   enum migrate_mode mode)
 {
 	int rc;
 
-	BUG_ON(folio_test_writeback(src));	/* Writeback must be complete */
-
-	rc = folio_migrate_mapping(mapping, dst, src, extra_count);
-
+	rc = folio_migrate_mapping(mapping, dst, src, 0);
 	if (rc != MIGRATEPAGE_SUCCESS)
 		return rc;
 
+	if (src_private)
+		folio_attach_private(dst, folio_detach_private(src));
+
 	if (mode != MIGRATE_SYNC_NO_COPY)
 		folio_migrate_copy(dst, src);
 	else
@@ -690,9 +691,10 @@ int migrate_folio_extra(struct address_s
  * Folios are locked upon entry and exit.
  */
 int migrate_folio(struct address_space *mapping, struct folio *dst,
-		struct folio *src, enum migrate_mode mode)
+		  struct folio *src, enum migrate_mode mode)
 {
-	return migrate_folio_extra(mapping, dst, src, mode, 0);
+	BUG_ON(folio_test_writeback(src));	/* Writeback must be complete */
+	return __migrate_folio(mapping, dst, src, NULL, mode);
 }
 EXPORT_SYMBOL(migrate_folio);
 
@@ -846,20 +848,7 @@ EXPORT_SYMBOL_GPL(buffer_migrate_folio_n
 int filemap_migrate_folio(struct address_space *mapping,
 		struct folio *dst, struct folio *src, enum migrate_mode mode)
 {
-	int ret;
-
-	ret = folio_migrate_mapping(mapping, dst, src, 0);
-	if (ret != MIGRATEPAGE_SUCCESS)
-		return ret;
-
-	if (folio_get_private(src))
-		folio_attach_private(dst, folio_detach_private(src));
-
-	if (mode != MIGRATE_SYNC_NO_COPY)
-		folio_migrate_copy(dst, src);
-	else
-		folio_migrate_flags(dst, src);
-	return MIGRATEPAGE_SUCCESS;
+	return __migrate_folio(mapping, dst, src, folio_get_private(src), mode);
 }
 EXPORT_SYMBOL_GPL(filemap_migrate_folio);
 
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

