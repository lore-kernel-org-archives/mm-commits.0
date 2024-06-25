Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48DC313D244
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291600; cv=none; b=rl4eJLMFktluo0rVSEaxunCfCtpaSyjFvMv8nu/fJzC3hPQFXz0KKUlw1NIFrA7VGTtQrvlnoBGBH+znsxPMuP7GL8jLQ9VvKbzBP4BB1h8KFbk6FET7eItwbWFFMYXPliGw5mkKqYAZ56Th4TIEcTjeoG+TgCwdS6kfKDTvowA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291600; c=relaxed/simple;
	bh=5k39Mc7gb50GEOQPjLZlzEh92hLj7ogNhLG6kzBsWJw=;
	h=Date:To:From:Subject:Message-Id; b=hhYMSeKH5pvnz7ZlD9GKw/LJORL02qOsigrLjk49dtfOr3krXJPgKIHVKsqQDMlGkZYn7S/xFQULVf1RBLp3jC2PmFOF4QQQB+lEz0Qca2nSl4yI8VuDzIK/RVUNN4eCLS4tWU3FlBZK3T+ZBZE5HOcmMpS3Fgk/qvpuY7sOQ1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TBV95oT9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TBV95oT9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1658CC32782;
	Tue, 25 Jun 2024 05:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291600;
	bh=5k39Mc7gb50GEOQPjLZlzEh92hLj7ogNhLG6kzBsWJw=;
	h=Date:To:From:Subject:From;
	b=TBV95oT9y996Utl0MfNKn+YPfgmqd56/PRvqYL7XsRBjOfj4RZ+qQLvsppKYqQP/Q
	 HtBxU/EKMHsn/OOTqeJ8SjDeE62oZ/v5hJLxW2kHL6u/0MgljVAINV1zDdS6HVcws5
	 xz2A8irs5NFH3Q0a3seij0PA/wu46wH33IoX9u1Y=
Date: Mon, 24 Jun 2024 21:59:59 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vishal.moola@gmail.com,tony.luck@intel.com,nao.horiguchi@gmail.com,muchun.song@linux.dev,linmiaohe@huawei.com,jiaqiyan@google.com,jglisse@redhat.com,jane.chu@oracle.com,hughd@google.com,david@redhat.com,bcrl@kvack.org,apopple@nvidia.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migrate-remove-migrate_folio_extra.patch removed from -mm tree
Message-Id: <20240625050000.1658CC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: migrate: remove migrate_folio_extra()
has been removed from the -mm tree.  Its filename was
     mm-migrate-remove-migrate_folio_extra.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: migrate: remove migrate_folio_extra()
Date: Fri, 24 May 2024 13:28:42 +0800

migrate_folio_extra() is only called in migrate.c now, convert it a static
function and take a new src_private argument which could be shared by
migrate_folio() and filemap_migrate_folio() to simplify code a bit.

Link: https://lkml.kernel.org/r/20240524052843.182275-5-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Jane Chu <jane.chu@oracle.com>
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

