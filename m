Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 135B7C0032E
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 23:47:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbjJYXrw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 19:47:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbjJYXrr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 19:47:47 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0856313D
        for <mm-commits@vger.kernel.org>; Wed, 25 Oct 2023 16:47:45 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8C32C433CA;
        Wed, 25 Oct 2023 23:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698277664;
        bh=XnuQZ8GT5A6/UgNXKkeV1zRt+eJHO+am4CUvomCh4fA=;
        h=Date:To:From:Subject:From;
        b=G8aNKr1UqQhlLhZLdgdbVymFuByOPo4Sdyk370PYO0uENGm4QoEi3jLSX2u3LiR4H
         wbKXeUSXO2jVIPi1QdjqL9mVGwhhGQXjew6OASVH4SCo0jlvHnZVW6cx9GEElszLqo
         fsg+jE9nypMdiur5IenQkQjuE7BLxm/Y+suFRzBc=
Date:   Wed, 25 Oct 2023 16:47:44 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        usama.arif@bytedance.com, songmuchun@bytedance.com,
        senozhatsky@chromium.org, rientjes@google.com, osalvador@suse.de,
        naoya.horiguchi@linux.dev, mhocko@suse.com, linmiaohe@huawei.com,
        konradybcio@kernel.org, jthoughton@google.com,
        joao.m.martins@oracle.com, duanxiongchun@bytedance.com,
        david@redhat.com, anshuman.khandual@arm.com, 21cnbao@gmail.com,
        mike.kravetz@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlb-perform-vmemmap-restoration-on-a-list-of-pages.patch removed from -mm tree
Message-Id: <20231025234744.C8C32C433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hugetlb: perform vmemmap restoration on a list of pages
has been removed from the -mm tree.  Its filename was
     hugetlb-perform-vmemmap-restoration-on-a-list-of-pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb: perform vmemmap restoration on a list of pages
Date: Wed, 18 Oct 2023 19:31:06 -0700

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

Link: https://lkml.kernel.org/r/20231019023113.345257-5-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Konrad Dybcio <konradybcio@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Usama Arif <usama.arif@bytedance.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c         |   99 +++++++++++++++++++++++++++++------------
 mm/hugetlb_vmemmap.c |   38 +++++++++++++++
 mm/hugetlb_vmemmap.h |   11 ++++
 3 files changed, 120 insertions(+), 28 deletions(-)

--- a/mm/hugetlb.c~hugetlb-perform-vmemmap-restoration-on-a-list-of-pages
+++ a/mm/hugetlb.c
@@ -1859,50 +1859,93 @@ static void update_and_free_hugetlb_foli
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
 
@@ -45,6 +48,14 @@ static inline int hugetlb_vmemmap_restor
 	return 0;
 }
 
+static long hugetlb_vmemmap_restore_folios(const struct hstate *h,
+					struct list_head *folio_list,
+					struct list_head *non_hvo_folios)
+{
+	list_splice_init(folio_list, non_hvo_folios);
+	return 0;
+}
+
 static inline void hugetlb_vmemmap_optimize(const struct hstate *h, struct page *head)
 {
 }
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are


