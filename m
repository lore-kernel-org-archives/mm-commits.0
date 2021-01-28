Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A399C433E0
	for <mm-commits@archiver.kernel.org>; Thu, 28 Jan 2021 21:37:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E16B364DEB
	for <mm-commits@archiver.kernel.org>; Thu, 28 Jan 2021 21:37:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbhA1Vhl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 28 Jan 2021 16:37:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:35840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229677AbhA1Vhf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 28 Jan 2021 16:37:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 93F3D64DE8;
        Thu, 28 Jan 2021 21:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611869814;
        bh=yh2+bdjTljRfdW4p/jr15HcEjkl3ak2QnWwu8fTT+MU=;
        h=Date:From:To:Subject:From;
        b=SNsSAMhGp4blLakKiJmBE3djWFLmbLdBLOpYe7tB15z91XRfbeX9gVxqWNrl7FNb8
         FMmAOiutyNOvPpPz0gSVWjlmZk09UTaQU3u9HrFhmt5UTYQNQCKqdgcgIdP+z/jRX/
         MTy2cbbVx3RoZlg9XMe8lqBWyU/dBg5ht9n91FMg=
Date:   Thu, 28 Jan 2021 13:36:52 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, linmiaohe@huawei.com, mhocko@kernel.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        n-horiguchi@ah.jp.nec.com, osalvador@suse.de,
        songmuchun@bytedance.com, willy@infradead.org
Subject:  [withdrawn]
 hugetlb-only-set-hpagemigratable-for-migratable-hstates.patch removed from
 -mm tree
Message-ID: <20210128213652.kCFCSAKrJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: only set HPageMigratable for migratable hstates
has been removed from the -mm tree.  Its filename was
     hugetlb-only-set-hpagemigratable-for-migratable-hstates.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb: only set HPageMigratable for migratable hstates

The HP_Migratable flag indicates a page is a candidate for migration. 
Only set the flag if the page's hstate supports migration.  This allows
the migration paths to detect non-migratable pages earlier.  If migration
is not supported for the hstate, HP_Migratable will not be set, the page
will not be isolated and no attempt will be made to migrate.  We should
never get to unmap_and_move_huge_page for a page where migration is not
supported, so throw a warning if we do.

Link: https://lkml.kernel.org/r/20210122195231.324857-4-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c    |    2 +-
 include/linux/hugetlb.h |    9 +++++++++
 mm/hugetlb.c            |    8 ++++----
 mm/migrate.c            |    9 ++++-----
 4 files changed, 18 insertions(+), 10 deletions(-)

--- a/fs/hugetlbfs/inode.c~hugetlb-only-set-hpagemigratable-for-migratable-hstates
+++ a/fs/hugetlbfs/inode.c
@@ -735,7 +735,7 @@ static long hugetlbfs_fallocate(struct f
 
 		mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 
-		SetHPageMigratable(page);
+		SetHPageMigratableIfSupported(page);
 		/*
 		 * unlock_page because locked by add_to_page_cache()
 		 * put_page() due to reference from alloc_huge_page()
--- a/include/linux/hugetlb.h~hugetlb-only-set-hpagemigratable-for-migratable-hstates
+++ a/include/linux/hugetlb.h
@@ -741,6 +741,15 @@ static inline bool hugepage_migration_su
 }
 
 /*
+ * Only set HPageMigratable if migration supported for page
+ */
+static inline void SetHPageMigratableIfSupported(struct page *page)
+{
+	if (hugepage_migration_supported(page_hstate(page)))
+		SetHPageMigratable(page);
+}
+
+/*
  * Movability check is different as compared to migration check.
  * It determines whether or not a huge page should be placed on
  * movable zone or not. Movability of any huge page should be
--- a/mm/hugetlb.c~hugetlb-only-set-hpagemigratable-for-migratable-hstates
+++ a/mm/hugetlb.c
@@ -4211,7 +4211,7 @@ retry_avoidcopy:
 				make_huge_pte(vma, new_page, 1));
 		page_remove_rmap(old_page, true);
 		hugepage_add_new_anon_rmap(new_page, vma, haddr);
-		SetHPageMigratable(new_page);
+		SetHPageMigratableIfSupported(new_page);
 		/* Make the old page be freed below */
 		new_page = old_page;
 	}
@@ -4453,7 +4453,7 @@ retry:
 	 * been isolated for migration.
 	 */
 	if (new_page)
-		SetHPageMigratable(page);
+		SetHPageMigratableIfSupported(page);
 
 	unlock_page(page);
 out:
@@ -4764,7 +4764,7 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
 	update_mmu_cache(dst_vma, dst_addr, dst_pte);
 
 	spin_unlock(ptl);
-	SetHPageMigratable(page);
+	SetHPageMigratableIfSupported(page);
 	if (vm_shared)
 		unlock_page(page);
 	ret = 0;
@@ -5608,7 +5608,7 @@ void putback_active_hugepage(struct page
 {
 	VM_BUG_ON_PAGE(!PageHead(page), page);
 	spin_lock(&hugetlb_lock);
-	SetHPageMigratable(page);
+	SetHPageMigratableIfSupported(page);
 	list_move_tail(&page->lru, &(page_hstate(page))->hugepage_activelist);
 	spin_unlock(&hugetlb_lock);
 	put_page(page);
--- a/mm/migrate.c~hugetlb-only-set-hpagemigratable-for-migratable-hstates
+++ a/mm/migrate.c
@@ -1275,13 +1275,12 @@ static int unmap_and_move_huge_page(new_
 	struct address_space *mapping = NULL;
 
 	/*
-	 * Migratability of hugepages depends on architectures and their size.
-	 * This check is necessary because some callers of hugepage migration
-	 * like soft offline and memory hotremove don't walk through page
-	 * tables or check whether the hugepage is pmd-based or not before
-	 * kicking migration.
+	 * Support for migration should be checked at isolation time.
+	 * Therefore, we should never get here if migration is not supported
+	 * for the page.
 	 */
 	if (!hugepage_migration_supported(page_hstate(hpage))) {
+		VM_WARN_ON(1);
 		list_move_tail(&hpage->lru, ret);
 		return -ENOSYS;
 	}
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlb-use-pageprivate-for-hugetlb-specific-page-flags.patch
hugetlb-convert-page_huge_active-hpagemigratable-flag.patch
hugetlb-convert-pagehugetemporary-to-hpagetemporary-flag.patch
hugetlb-convert-pagehugefreed-to-hpagefreed-flag.patch
mm-hugetlb-change-hugetlb_reserve_pages-to-type-bool.patch
hugetlbfs-remove-special-hugetlbfs_set_page_dirty.patch

