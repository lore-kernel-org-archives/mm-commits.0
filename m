Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30539CD37B0
	for <mm-commits@archiver.kernel.org>; Fri, 15 Sep 2023 23:28:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233245AbjIOX2N (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 15 Sep 2023 19:28:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235142AbjIOX1k (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 15 Sep 2023 19:27:40 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E74C42102
        for <mm-commits@vger.kernel.org>; Fri, 15 Sep 2023 16:27:34 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82097C433C7;
        Fri, 15 Sep 2023 23:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694820454;
        bh=YpsxqFnDNfcA1GDqExXEMo3sWb6The9ti134hQfdhQE=;
        h=Date:To:From:Subject:From;
        b=Uvrzf6ay83RL0afLOCG5GL/Hku1a3vH0dVYP1G/5wev3l+66fnW/4OVfBXNHAv31D
         IGUFiQCFpallHgUhFPGD1S9U6yShgq93F+wZ50jgDJyZu7W137W/KU5YsY/56NB+sQ
         cHi4nCser0mHKm+dsPeEak0RGGRkWUtjtXJrDBM0=
Date:   Fri, 15 Sep 2023 16:27:33 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, sidhartha.kumar@oracle.com,
        rientjes@google.com, osalvador@suse.de, naoya.horiguchi@linux.dev,
        mhocko@suse.com, linmiaohe@huawei.com, jthoughton@google.com,
        joao.m.martins@oracle.com, duanxiongchun@bytedance.com,
        david@redhat.com, anshuman.khandual@arm.com,
        mike.kravetz@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-perform-vmemmap-restoration-on-a-list-of-pages.patch added to mm-unstable branch
Message-Id: <20230915232734.82097C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: perform vmemmap restoration on a list of pages
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlb-perform-vmemmap-restoration-on-a-list-of-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-perform-vmemmap-restoration-on-a-list-of-pages.patch

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
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb: perform vmemmap restoration on a list of pages
Date: Fri, 15 Sep 2023 15:15:41 -0700

The routine update_and_free_pages_bulk already performs vmemmap
restoration on the list of hugetlb pages in a separate step.  In
preparation for more functionality to be added in this step, create a new
routine hugetlb_vmemmap_restore_folios() that will restore vmemmap for a
list of folios.

This new routine must provide sufficient feedback about errors and actual
restoration performed so that update_and_free_pages_bulk can perform
optimally.

Link: https://lkml.kernel.org/r/20230915221548.552084-9-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c         |   36 ++++++++++++++++++------------------
 mm/hugetlb_vmemmap.c |   37 +++++++++++++++++++++++++++++++++++++
 mm/hugetlb_vmemmap.h |   11 +++++++++++
 3 files changed, 66 insertions(+), 18 deletions(-)

--- a/mm/hugetlb.c~hugetlb-perform-vmemmap-restoration-on-a-list-of-pages
+++ a/mm/hugetlb.c
@@ -1829,36 +1829,36 @@ static void update_and_free_hugetlb_foli
 
 static void update_and_free_pages_bulk(struct hstate *h, struct list_head *list)
 {
+	int ret;
+	unsigned long restored;
 	struct folio *folio, *t_folio;
-	bool clear_dtor = false;
 
 	/*
-	 * First allocate required vmemmmap (if necessary) for all folios on
-	 * list.  If vmemmap can not be allocated, we can not free folio to
-	 * lower level allocator, so add back as hugetlb surplus page.
-	 * add_hugetlb_folio() removes the page from THIS list.
-	 * Use clear_dtor to note if vmemmap was successfully allocated for
-	 * ANY page on the list.
+	 * First allocate required vmemmmap (if necessary) for all folios.
 	 */
-	list_for_each_entry_safe(folio, t_folio, list, lru) {
-		if (folio_test_hugetlb_vmemmap_optimized(folio)) {
-			if (hugetlb_vmemmap_restore(h, &folio->page)) {
-				spin_lock_irq(&hugetlb_lock);
+	ret = hugetlb_vmemmap_restore_folios(h, list, &restored);
+
+	/*
+	 * If there was an error restoring vmemmap for ANY folios on the list,
+	 * add them back as surplus hugetlb pages.  add_hugetlb_folio() removes
+	 * the folio from THIS list.
+	 */
+	if (ret < 0) {
+		spin_lock_irq(&hugetlb_lock);
+		list_for_each_entry_safe(folio, t_folio, list, lru)
+			if (folio_test_hugetlb_vmemmap_optimized(folio))
 				add_hugetlb_folio(h, folio, true);
-				spin_unlock_irq(&hugetlb_lock);
-			} else
-				clear_dtor = true;
-		}
+		spin_unlock_irq(&hugetlb_lock);
 	}
 
 	/*
-	 * If vmemmmap allocation was performed on any folio above, take lock
-	 * to clear destructor of all folios on list.  This avoids the need to
+	 * If vmemmmap allocation was performed on ANY folio , take lock to
+	 * clear destructor of all folios on list.  This avoids the need to
 	 * lock/unlock for each individual folio.
 	 * The assumption is vmemmap allocation was performed on all or none
 	 * of the folios on the list.  This is true expect in VERY rare cases.
 	 */
-	if (clear_dtor) {
+	if (restored) {
 		spin_lock_irq(&hugetlb_lock);
 		list_for_each_entry(folio, list, lru)
 			__clear_hugetlb_destructor(h, folio);
--- a/mm/hugetlb_vmemmap.c~hugetlb-perform-vmemmap-restoration-on-a-list-of-pages
+++ a/mm/hugetlb_vmemmap.c
@@ -480,6 +480,43 @@ int hugetlb_vmemmap_restore(const struct
 	return ret;
 }
 
+/**
+ * hugetlb_vmemmap_restore_folios - restore vmemmap for every folio on the list.
+ * @h:		struct hstate.
+ * @folio_list:	list of folios.
+ * @restored:	Set to number of folios for which vmemmap was restored
+ *		successfully if caller passes a non-NULL pointer.
+ *
+ * Return: %0 if vmemmap exists for all folios on the list.  If an error is
+ *		encountered restoring vmemmap for ANY folio, an error code
+ *		will be returned to the caller.  It is then the responsibility
+ *		of the caller to check the hugetlb vmemmap optimized flag of
+ *		each folio to determine if vmemmap was actually restored.
+ */
+int hugetlb_vmemmap_restore_folios(const struct hstate *h,
+					struct list_head *folio_list,
+					unsigned long *restored)
+{
+	unsigned long num_restored;
+	struct folio *folio;
+	int ret = 0, t_ret;
+
+	num_restored = 0;
+	list_for_each_entry(folio, folio_list, lru) {
+		if (folio_test_hugetlb_vmemmap_optimized(folio)) {
+			t_ret = hugetlb_vmemmap_restore(h, &folio->page);
+			if (t_ret)
+				ret = t_ret;
+			else
+				num_restored++;
+		}
+	}
+
+	if (*restored)
+		*restored = num_restored;
+	return ret;
+}
+
 /* Return true iff a HugeTLB whose vmemmap should and can be optimized. */
 static bool vmemmap_should_optimize(const struct hstate *h, const struct page *head)
 {
--- a/mm/hugetlb_vmemmap.h~hugetlb-perform-vmemmap-restoration-on-a-list-of-pages
+++ a/mm/hugetlb_vmemmap.h
@@ -19,6 +19,8 @@
 
 #ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
 int hugetlb_vmemmap_restore(const struct hstate *h, struct page *head);
+int hugetlb_vmemmap_restore_folios(const struct hstate *h,
+			struct list_head *folio_list, unsigned long *restored);
 void hugetlb_vmemmap_optimize(const struct hstate *h, struct page *head);
 void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head *folio_list);
 
@@ -45,6 +47,15 @@ static inline int hugetlb_vmemmap_restor
 	return 0;
 }
 
+static inline int hugetlb_vmemmap_restore_folios(const struct hstate *h,
+					struct list_head *folio_list,
+					unsigned long *restored)
+{
+	if (restored)
+		*restored = 0;
+	return 0;
+}
+
 static inline void hugetlb_vmemmap_optimize(const struct hstate *h, struct page *head)
 {
 }
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlb-set-hugetlb-page-flag-before-optimizing-vmemmap.patch
hugetlb-optimize-update_and_free_pages_bulk-to-avoid-lock-cycles.patch
hugetlb-restructure-pool-allocations.patch
hugetlb-perform-vmemmap-optimization-on-a-list-of-pages.patch
hugetlb-perform-vmemmap-restoration-on-a-list-of-pages.patch
hugetlb-batch-freeing-of-vmemmap-pages.patch
hugetlb-batch-tlb-flushes-when-restoring-vmemmap.patch

