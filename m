Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BA2CC433E9
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:10:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4737660202
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:10:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235446AbhBXUKW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:10:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:33234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235316AbhBXUJm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:09:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C3A464F25;
        Wed, 24 Feb 2021 20:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197342;
        bh=df+0qV+j7KcQUdsOCl5oTF2mMefbNZbXZqcH02cX53o=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=LVa/atVTsOfFbGudUgrKD2pftzm3OWSReTX0eym68t5EuPPpCeLsQ+NzyE9lnRqke
         HvOTc3by5R4gFmMqhFurO8IApOT3pQLh4v9J/QYxY7SfN4nuFhIDonajGGmRSPByR5
         7GepXAZIBFqWDcm1lQ5hKGnTZSafhdHQ3wqXofBM=
Date:   Wed, 24 Feb 2021 12:09:00 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, linmiaohe@huawei.com,
        linux-mm@kvack.org, mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com,
        osalvador@suse.de, songmuchun@bytedance.com,
        torvalds@linux-foundation.org, willy@infradead.org
Subject:  [patch 148/173] hugetlb: convert PageHugeTemporary() to
 HPageTemporary flag
Message-ID: <20210224200900.91raiWk2W%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
