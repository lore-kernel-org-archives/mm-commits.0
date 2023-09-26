Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D67CBE7F146
	for <mm-commits@archiver.kernel.org>; Tue, 26 Sep 2023 23:18:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231785AbjIZXR7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 26 Sep 2023 19:17:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232555AbjIZXPz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 26 Sep 2023 19:15:55 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BC2A17823
        for <mm-commits@vger.kernel.org>; Tue, 26 Sep 2023 15:17:23 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C22FFC116D4;
        Tue, 26 Sep 2023 21:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695764385;
        bh=M4TR91rmzZf5RcV3v1OwzTnw49tIYOxdOnO6JkAEBUY=;
        h=Date:To:From:Subject:From;
        b=nO5/KZ3CvRjuK1HVphRKgy2YyG136urwaZX0cQ1OxnAqOGVaa4aErENfstmt/Qg39
         cABEHaoTv5Euemzj7m4HPEtBn5FctCheSJ9SEwyuo2Pk9tEy84j2LOC/VMZt9R34tR
         cBilYlJ0/Cv+CQsQf6AthVWFmSH0MhtsbYjKT+dI=
Date:   Tue, 26 Sep 2023 14:39:45 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, rientjes@google.com, osalvador@suse.de,
        naoya.horiguchi@linux.dev, mhocko@suse.com, linmiaohe@huawei.com,
        jthoughton@google.com, joao.m.martins@oracle.com,
        duanxiongchun@bytedance.com, david@redhat.com,
        anshuman.khandual@arm.com, mike.kravetz@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-perform-vmemmap-restoration-on-a-list-of-pages.patch added to mm-unstable branch
Message-Id: <20230926213945.C22FFC116D4@smtp.kernel.org>
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
Date: Mon, 25 Sep 2023 16:48:32 -0700

The routine update_and_free_pages_bulk already performs vmemmap
restoration on the list of hugetlb pages in a separate step.  In
preparation for more functionality to be added in this step, create a new
routine hugetlb_vmemmap_restore_folios() that will restore vmemmap for a
list of folios.

This new routine must provide sufficient feedback about errors and actual
restoration performed so that update_and_free_pages_bulk can perform
optimally.

Special care must be taken when encountering an error from
hugetlb_vmemmap_restore_folios.  We want to continue making as much
forward progress as possible.  A new routine bulk_vmemmap_restore_error
handles this specific situation.

Link: https://lkml.kernel.org/r/20230925234837.86786-5-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c         |   99 +++++++++++++++++++++++++++++------------
 mm/hugetlb_vmemmap.c |   38 +++++++++++++++
 mm/hugetlb_vmemmap.h |   10 ++++
 3 files changed, 119 insertions(+), 28 deletions(-)

--- a/mm/hugetlb.c~hugetlb-perform-vmemmap-restoration-on-a-list-of-pages
+++ a/mm/hugetlb.c
@@ -1716,50 +1716,93 @@ static void update_and_free_hugetlb_foli
 		schedule_work(&free_hpage_work);
 }
 
-static void update_and_free_pages_bulk(struct hstate *h, struct list_head *list)
+static void bulk_vmemmap_restore_error(struct hstate *h,
+					struct list_head *folio_list,
+					struct list_head *non_hvo_folios)
 {
 	struct folio *folio, *t_folio;
-	bool clear_dtor = false;
 
-	/*
-	 * First allocate required vmemmmap (if necessary) for all folios on
-	 * list.  If vmemmap can not be allocated, we can not free folio to
-	 * lower level allocator, so add back as hugetlb surplus page.
-	 * add_hugetlb_folio() removes the page from THIS list.
-	 * Use clear_dtor to note if vmemmap was successfully allocated for
-	 * ANY page on the list.
-	 */
-	list_for_each_entry_safe(folio, t_folio, list, lru) {
-		if (folio_test_hugetlb_vmemmap_optimized(folio)) {
+	if (!list_empty(non_hvo_folios)) {
+		/*
+		 * Free any restored hugetlb pages so that restore of the
+		 * entire list can be retried.
+		 * The idea is that in the common case of ENOMEM errors freeing
+		 * hugetlb pages with vmemmap we will free up memory so that we
+		 * can allocate vmemmap for more hugetlb pages.
+		 */
+		list_for_each_entry_safe(folio, t_folio, non_hvo_folios, lru) {
+			list_del(&folio->lru);
+			spin_lock_irq(&hugetlb_lock);
+			__clear_hugetlb_destructor(h, folio);
+			spin_unlock_irq(&hugetlb_lock);
+			update_and_free_hugetlb_folio(h, folio, false);
+			cond_resched();
+		}
+	} else {
+		/*
+		 * In the case where there are no folios which can be
+		 * immediately freed, we loop through the list trying to restore
+		 * vmemmap individually in the hope that someone elsewhere may
+		 * have done something to cause success (such as freeing some
+		 * memory).  If unable to restore a hugetlb page, the hugetlb
+		 * page is made a surplus page and removed from the list.
+		 * If are able to restore vmemmap and free one hugetlb page, we
+		 * quit processing the list to retry the bulk operation.
+		 */
+		list_for_each_entry_safe(folio, t_folio, folio_list, lru)
 			if (hugetlb_vmemmap_restore(h, &folio->page)) {
+				list_del(&folio->lru);
 				spin_lock_irq(&hugetlb_lock);
 				add_hugetlb_folio(h, folio, true);
 				spin_unlock_irq(&hugetlb_lock);
-			} else
-				clear_dtor = true;
-		}
+			} else {
+				list_del(&folio->lru);
+				spin_lock_irq(&hugetlb_lock);
+				__clear_hugetlb_destructor(h, folio);
+				spin_unlock_irq(&hugetlb_lock);
+				update_and_free_hugetlb_folio(h, folio, false);
+				cond_resched();
+				break;
+			}
+	}
+}
+
+static void update_and_free_pages_bulk(struct hstate *h,
+						struct list_head *folio_list)
+{
+	long ret;
+	struct folio *folio, *t_folio;
+	LIST_HEAD(non_hvo_folios);
+
+	/*
+	 * First allocate required vmemmmap (if necessary) for all folios.
+	 * Carefully handle errors and free up any available hugetlb pages
+	 * in an effort to make forward progress.
+	 */
+retry:
+	ret = hugetlb_vmemmap_restore_folios(h, folio_list, &non_hvo_folios);
+	if (ret < 0) {
+		bulk_vmemmap_restore_error(h, folio_list, &non_hvo_folios);
+		goto retry;
 	}
 
 	/*
-	 * If vmemmmap allocation was performed on any folio above, take lock
-	 * to clear destructor of all folios on list.  This avoids the need to
-	 * lock/unlock for each individual folio.
-	 * The assumption is vmemmap allocation was performed on all or none
-	 * of the folios on the list.  This is true expect in VERY rare cases.
+	 * At this point, list should be empty, ret should be >= 0 and there
+	 * should only be pages on the non_hvo_folios list.
+	 * Do note that the non_hvo_folios list could be empty.
+	 * Without HVO enabled, ret will be 0 and there is no need to call
+	 * __clear_hugetlb_destructor as this was done previously.
 	 */
-	if (clear_dtor) {
+	VM_WARN_ON(!list_empty(folio_list));
+	VM_WARN_ON(ret < 0);
+	if (!list_empty(&non_hvo_folios) && ret) {
 		spin_lock_irq(&hugetlb_lock);
-		list_for_each_entry(folio, list, lru)
+		list_for_each_entry(folio, &non_hvo_folios, lru)
 			__clear_hugetlb_destructor(h, folio);
 		spin_unlock_irq(&hugetlb_lock);
 	}
 
-	/*
-	 * Free folios back to low level allocators.  vmemmap and destructors
-	 * were taken care of above, so update_and_free_hugetlb_folio will
-	 * not need to take hugetlb lock.
-	 */
-	list_for_each_entry_safe(folio, t_folio, list, lru) {
+	list_for_each_entry_safe(folio, t_folio, &non_hvo_folios, lru) {
 		update_and_free_hugetlb_folio(h, folio, false);
 		cond_resched();
 	}
--- a/mm/hugetlb_vmemmap.c~hugetlb-perform-vmemmap-restoration-on-a-list-of-pages
+++ a/mm/hugetlb_vmemmap.c
@@ -480,6 +480,44 @@ int hugetlb_vmemmap_restore(const struct
 	return ret;
 }
 
+/**
+ * hugetlb_vmemmap_restore_folios - restore vmemmap for every folio on the list.
+ * @h:			hstate.
+ * @folio_list:		list of folios.
+ * @non_hvo_folios:	Output list of folios for which vmemmap exists.
+ *
+ * Return: number of folios for which vmemmap was restored, or an error code
+ *		if an error was encountered restoring vmemmap for a folio.
+ *		Folios that have vmemmap are moved to the non_hvo_folios
+ *		list.  Processing of entries stops when the first error is
+ *		encountered. The folio that experienced the error and all
+ *		non-processed folios will remain on folio_list.
+ */
+long hugetlb_vmemmap_restore_folios(const struct hstate *h,
+					struct list_head *folio_list,
+					struct list_head *non_hvo_folios)
+{
+	struct folio *folio, *t_folio;
+	long restored = 0;
+	long ret = 0;
+
+	list_for_each_entry_safe(folio, t_folio, folio_list, lru) {
+		if (folio_test_hugetlb_vmemmap_optimized(folio)) {
+			ret = hugetlb_vmemmap_restore(h, &folio->page);
+			if (ret)
+				break;
+			restored++;
+		}
+
+		/* Add non-optimized folios to output list */
+		list_move(&folio->lru, non_hvo_folios);
+	}
+
+	if (!ret)
+		ret = restored;
+	return ret;
+}
+
 /* Return true iff a HugeTLB whose vmemmap should and can be optimized. */
 static bool vmemmap_should_optimize(const struct hstate *h, const struct page *head)
 {
--- a/mm/hugetlb_vmemmap.h~hugetlb-perform-vmemmap-restoration-on-a-list-of-pages
+++ a/mm/hugetlb_vmemmap.h
@@ -19,6 +19,9 @@
 
 #ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
 int hugetlb_vmemmap_restore(const struct hstate *h, struct page *head);
+long hugetlb_vmemmap_restore_folios(const struct hstate *h,
+					struct list_head *folio_list,
+					struct list_head *non_hvo_folios);
 void hugetlb_vmemmap_optimize(const struct hstate *h, struct page *head);
 void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head *folio_list);
 
@@ -44,6 +47,13 @@ static inline int hugetlb_vmemmap_restor
 {
 	return 0;
 }
+
+static long hugetlb_vmemmap_restore_folios(const struct hstate *h,
+					struct list_head *folio_list,
+					struct list_head *non_hvo_folios)
+{
+	return 0;
+}
 
 static inline void hugetlb_vmemmap_optimize(const struct hstate *h, struct page *head)
 {
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlb-set-hugetlb-page-flag-before-optimizing-vmemmap.patch
hugetlb-optimize-update_and_free_pages_bulk-to-avoid-lock-cycles.patch
hugetlb-restructure-pool-allocations.patch
hugetlb-perform-vmemmap-optimization-on-a-list-of-pages.patch
hugetlb-perform-vmemmap-restoration-on-a-list-of-pages.patch
hugetlb-batch-freeing-of-vmemmap-pages.patch
hugetlb-batch-tlb-flushes-when-restoring-vmemmap.patch

