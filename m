Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B36AFC433E9
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:35:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70C2D64F2F
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:35:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234869AbhBYTfF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:35:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:41330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235060AbhBYTc7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:32:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 92DB064FAD;
        Thu, 25 Feb 2021 19:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280699;
        bh=I2gGJlXboPzVBkBcQ+cp60cvkRZlxnzkonLI104VOwg=;
        h=Date:From:To:Subject:From;
        b=wkNnCFPBYFF2rIGlEJnZc7FVvGSmZudGZysxEVLu1TVQY33hlt2s2prk7A/o35iqW
         ZZtUMYhV3yveeUyXZxWR4u3O+gzK3c/fCjGDHrHaj0qMYwJTGFEyxCFUN18cQ8p2xG
         v36cFj8ectrc6jUKMgEv5d6WCsIZZlFVOuJtyCRE=
Date:   Thu, 25 Feb 2021 11:18:18 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, linmiaohe@huawei.com, mhocko@suse.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        n-horiguchi@ah.jp.nec.com, osalvador@suse.de,
        songmuchun@bytedance.com, willy@infradead.org
Subject:  [merged]
 hugetlb-convert-pagehugetemporary-to-hpagetemporary-flag.patch removed from
 -mm tree
Message-ID: <20210225191818.ablpZgapt%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: convert PageHugeTemporary() to HPageTemporary flag
has been removed from the -mm tree.  Its filename was
     hugetlb-convert-pagehugetemporary-to-hpagetemporary-flag.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb: convert PageHugeTemporary() to HPageTemporary flag

Use new hugetlb specific HPageTemporary flag to replace the
PageHugeTemporary() interfaces.  PageHugeTemporary does contain a
PageHuge() check.  However, this interface is only used within hugetlb
code where we know we are dealing with a hugetlb page.  Therefore, the
check can be eliminated.

Link: https://lkml.kernel.org/r/20210122195231.324857-5-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    6 ++++++
 mm/hugetlb.c            |   36 +++++++-----------------------------
 2 files changed, 13 insertions(+), 29 deletions(-)

--- a/include/linux/hugetlb.h~hugetlb-convert-pagehugetemporary-to-hpagetemporary-flag
+++ a/include/linux/hugetlb.h
@@ -483,10 +483,15 @@ unsigned long hugetlb_get_unmapped_area(
  * HPG_migratable  - Set after a newly allocated page is added to the page
  *	cache and/or page tables.  Indicates the page is a candidate for
  *	migration.
+ * HPG_temporary - - Set on a page that is temporarily allocated from the buddy
+ *	allocator.  Typically used for migration target pages when no pages
+ *	are available in the pool.  The hugetlb free page path will
+ *	immediately free pages with this flag set to the buddy allocator.
  */
 enum hugetlb_page_flags {
 	HPG_restore_reserve = 0,
 	HPG_migratable,
+	HPG_temporary,
 	__NR_HPAGEFLAGS,
 };
 
@@ -530,6 +535,7 @@ static inline void ClearHPage##uname(str
  */
 HPAGEFLAG(RestoreReserve, restore_reserve)
 HPAGEFLAG(Migratable, migratable)
+HPAGEFLAG(Temporary, temporary)
 
 #ifdef CONFIG_HUGETLB_PAGE
 
--- a/mm/hugetlb.c~hugetlb-convert-pagehugetemporary-to-hpagetemporary-flag
+++ a/mm/hugetlb.c
@@ -1364,28 +1364,6 @@ struct hstate *size_to_hstate(unsigned l
 	return NULL;
 }
 
-/*
- * Internal hugetlb specific page flag. Do not use outside of the hugetlb
- * code
- */
-static inline bool PageHugeTemporary(struct page *page)
-{
-	if (!PageHuge(page))
-		return false;
-
-	return (unsigned long)page[2].mapping == -1U;
-}
-
-static inline void SetPageHugeTemporary(struct page *page)
-{
-	page[2].mapping = (void *)-1U;
-}
-
-static inline void ClearPageHugeTemporary(struct page *page)
-{
-	page[2].mapping = NULL;
-}
-
 static void __free_huge_page(struct page *page)
 {
 	/*
@@ -1433,9 +1411,9 @@ static void __free_huge_page(struct page
 	if (restore_reserve)
 		h->resv_huge_pages++;
 
-	if (PageHugeTemporary(page)) {
+	if (HPageTemporary(page)) {
 		list_del(&page->lru);
-		ClearPageHugeTemporary(page);
+		ClearHPageTemporary(page);
 		update_and_free_page(h, page);
 	} else if (h->surplus_huge_pages_node[nid]) {
 		/* remove the page from active list */
@@ -1869,7 +1847,7 @@ static struct page *alloc_surplus_huge_p
 	 * codeflow
 	 */
 	if (h->surplus_huge_pages >= h->nr_overcommit_huge_pages) {
-		SetPageHugeTemporary(page);
+		SetHPageTemporary(page);
 		spin_unlock(&hugetlb_lock);
 		put_page(page);
 		return NULL;
@@ -1900,7 +1878,7 @@ static struct page *alloc_migrate_huge_p
 	 * We do not account these pages as surplus because they are only
 	 * temporary and will be released properly on the last reference
 	 */
-	SetPageHugeTemporary(page);
+	SetHPageTemporary(page);
 
 	return page;
 }
@@ -5625,12 +5603,12 @@ void move_hugetlb_state(struct page *old
 	 * here as well otherwise the global surplus count will not match
 	 * the per-node's.
 	 */
-	if (PageHugeTemporary(newpage)) {
+	if (HPageTemporary(newpage)) {
 		int old_nid = page_to_nid(oldpage);
 		int new_nid = page_to_nid(newpage);
 
-		SetPageHugeTemporary(oldpage);
-		ClearPageHugeTemporary(newpage);
+		SetHPageTemporary(oldpage);
+		ClearHPageTemporary(newpage);
 
 		spin_lock(&hugetlb_lock);
 		if (h->surplus_huge_pages_node[old_nid]) {
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are


