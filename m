Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1CA51624C5;
	Thu, 18 Dec 2025 22:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766098691; cv=none; b=Oa7K1PeYNu+rvxv0F4YXPxjlmbCSd3KegpEmcdpZJFSdGE4l0F2XPABzav0SEFbNIFS8yNoiGuMLr4ib51BLClJl0QB/cd0EnN/1fGnM/bGYlu/rwUNPm0H0TjwVsRpRh4nP8+eZPd6cSV4xbxx5+U1KyKYddZjdHQRXgRJSZUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766098691; c=relaxed/simple;
	bh=5mxwHHZbP/0IZE32ztbgvoVhrrrRm+e+KVUx2uSkzwQ=;
	h=Date:To:From:Subject:Message-Id; b=qNagBvuuDQPRPvT8wVCLa00W1pKpcjiorojdLBnR3CFFSyDXcDXOsKTS9biNrJiVYi9N1LEPBz5NmF9gjWH5XRDAqo6bFvA43Nc4R5sA7shQLyoN2d1KDuObVI0XHYSM4ulHfF4s5ozKeLo3HEd49hgtRxblZqGC1IJpZNXvxzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=K6FP1bH4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="K6FP1bH4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32F87C4CEFB;
	Thu, 18 Dec 2025 22:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766098690;
	bh=5mxwHHZbP/0IZE32ztbgvoVhrrrRm+e+KVUx2uSkzwQ=;
	h=Date:To:From:Subject:From;
	b=K6FP1bH4O6GAA53yHYPi4SJq9jfYc7LlOvdm1MKHBhkQOx9lvxgQ/XN+WkcNPImI5
	 4J6Xyvg3k5rJOWQKtx6anta19C6PvzK5ahWIsLnbdFTYnRzgkPV0zMuq1GQTgvDcC/
	 g/lcWaHO5Kp0467+GMibXJz4sc62jhiWHaOKHx44=
Date: Thu, 18 Dec 2025 14:58:09 -0800
To: mm-commits@vger.kernel.org,william.roche@oracle.com,surenb@google.com,stable@vger.kernel.org,rppt@kernel.org,rientjes@google.com,osalvador@suse.de,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,linmiaohe@huawei.com,liam.howlett@oracle.com,jiaqiyan@google.com,david@kernel.org,jane.chu@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-memory-failure-fix-missing-mf_stats-count-in-hugetlb-poison.patch removed from -mm tree
Message-Id: <20251218225810.32F87C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory-failure: fix missing ->mf_stats count in hugetlb poison
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-fix-missing-mf_stats-count-in-hugetlb-poison.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Jane Chu <jane.chu@oracle.com>
Subject: mm/memory-failure: fix missing ->mf_stats count in hugetlb poison
Date: Tue, 16 Dec 2025 14:56:21 -0700

When a newly poisoned subpage ends up in an already poisoned hugetlb
folio, 'num_poisoned_pages' is incremented, but the per node ->mf_stats is
not.  Fix the inconsistency by designating action_result() to update them
both.

Link: https://lkml.kernel.org/r/20251216215621.920093-1-jane.chu@oracle.com
Fixes: 18f41fa616ee ("mm: memory-failure: bump memory failure stats to pglist_data")
Signed-off-by: Jane Chu <jane.chu@oracle.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Jiaqi Yan <jiaqiyan@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: William Roche <william.roche@oracle.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    4 ++--
 include/linux/mm.h      |    4 ++--
 mm/hugetlb.c            |    4 ++--
 mm/memory-failure.c     |   22 +++++++++++++---------
 4 files changed, 19 insertions(+), 15 deletions(-)

--- a/include/linux/hugetlb.h~mm-memory-failure-fix-missing-mf_stats-count-in-hugetlb-poison
+++ a/include/linux/hugetlb.h
@@ -156,7 +156,7 @@ long hugetlb_unreserve_pages(struct inod
 bool folio_isolate_hugetlb(struct folio *folio, struct list_head *list);
 int get_hwpoison_hugetlb_folio(struct folio *folio, bool *hugetlb, bool unpoison);
 int get_huge_page_for_hwpoison(unsigned long pfn, int flags,
-				bool *migratable_cleared);
+				bool *migratable_cleared, bool *samepg);
 void folio_putback_hugetlb(struct folio *folio);
 void move_hugetlb_state(struct folio *old_folio, struct folio *new_folio, int reason);
 void hugetlb_fix_reserve_counts(struct inode *inode);
@@ -418,7 +418,7 @@ static inline int get_hwpoison_hugetlb_f
 }
 
 static inline int get_huge_page_for_hwpoison(unsigned long pfn, int flags,
-					bool *migratable_cleared)
+					bool *migratable_cleared, bool *samepg)
 {
 	return 0;
 }
--- a/include/linux/mm.h~mm-memory-failure-fix-missing-mf_stats-count-in-hugetlb-poison
+++ a/include/linux/mm.h
@@ -4351,7 +4351,7 @@ extern int soft_offline_page(unsigned lo
 extern const struct attribute_group memory_failure_attr_group;
 extern void memory_failure_queue(unsigned long pfn, int flags);
 extern int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
-					bool *migratable_cleared);
+					bool *migratable_cleared, bool *samepg);
 void num_poisoned_pages_inc(unsigned long pfn);
 void num_poisoned_pages_sub(unsigned long pfn, long i);
 #else
@@ -4360,7 +4360,7 @@ static inline void memory_failure_queue(
 }
 
 static inline int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
-					bool *migratable_cleared)
+					bool *migratable_cleared, bool *samepg)
 {
 	return 0;
 }
--- a/mm/hugetlb.c~mm-memory-failure-fix-missing-mf_stats-count-in-hugetlb-poison
+++ a/mm/hugetlb.c
@@ -7132,12 +7132,12 @@ int get_hwpoison_hugetlb_folio(struct fo
 }
 
 int get_huge_page_for_hwpoison(unsigned long pfn, int flags,
-				bool *migratable_cleared)
+				bool *migratable_cleared, bool *samepg)
 {
 	int ret;
 
 	spin_lock_irq(&hugetlb_lock);
-	ret = __get_huge_page_for_hwpoison(pfn, flags, migratable_cleared);
+	ret = __get_huge_page_for_hwpoison(pfn, flags, migratable_cleared, samepg);
 	spin_unlock_irq(&hugetlb_lock);
 	return ret;
 }
--- a/mm/memory-failure.c~mm-memory-failure-fix-missing-mf_stats-count-in-hugetlb-poison
+++ a/mm/memory-failure.c
@@ -1883,7 +1883,8 @@ static unsigned long __folio_free_raw_hw
 	return count;
 }
 
-static int folio_set_hugetlb_hwpoison(struct folio *folio, struct page *page)
+static int folio_set_hugetlb_hwpoison(struct folio *folio, struct page *page,
+					bool *samepg)
 {
 	struct llist_head *head;
 	struct raw_hwp_page *raw_hwp;
@@ -1899,17 +1900,16 @@ static int folio_set_hugetlb_hwpoison(st
 		return -EHWPOISON;
 	head = raw_hwp_list_head(folio);
 	llist_for_each_entry(p, head->first, node) {
-		if (p->page == page)
+		if (p->page == page) {
+			*samepg = true;
 			return -EHWPOISON;
+		}
 	}
 
 	raw_hwp = kmalloc(sizeof(struct raw_hwp_page), GFP_ATOMIC);
 	if (raw_hwp) {
 		raw_hwp->page = page;
 		llist_add(&raw_hwp->node, head);
-		/* the first error event will be counted in action_result(). */
-		if (ret)
-			num_poisoned_pages_inc(page_to_pfn(page));
 	} else {
 		/*
 		 * Failed to save raw error info.  We no longer trace all
@@ -1966,7 +1966,7 @@ void folio_clear_hugetlb_hwpoison(struct
  *   -EHWPOISON    - the hugepage is already hwpoisoned
  */
 int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
-				 bool *migratable_cleared)
+				 bool *migratable_cleared, bool *samepg)
 {
 	struct page *page = pfn_to_page(pfn);
 	struct folio *folio = page_folio(page);
@@ -1991,7 +1991,7 @@ int __get_huge_page_for_hwpoison(unsigne
 			goto out;
 	}
 
-	if (folio_set_hugetlb_hwpoison(folio, page)) {
+	if (folio_set_hugetlb_hwpoison(folio, page, samepg)) {
 		ret = -EHWPOISON;
 		goto out;
 	}
@@ -2024,11 +2024,12 @@ static int try_memory_failure_hugetlb(un
 	struct page *p = pfn_to_page(pfn);
 	struct folio *folio;
 	unsigned long page_flags;
+	bool samepg = false;
 	bool migratable_cleared = false;
 
 	*hugetlb = 1;
 retry:
-	res = get_huge_page_for_hwpoison(pfn, flags, &migratable_cleared);
+	res = get_huge_page_for_hwpoison(pfn, flags, &migratable_cleared, &samepg);
 	if (res == 2) { /* fallback to normal page handling */
 		*hugetlb = 0;
 		return 0;
@@ -2037,7 +2038,10 @@ retry:
 			folio = page_folio(p);
 			res = kill_accessing_process(current, folio_pfn(folio), flags);
 		}
-		action_result(pfn, MF_MSG_ALREADY_POISONED, MF_FAILED);
+		if (samepg)
+			action_result(pfn, MF_MSG_ALREADY_POISONED, MF_FAILED);
+		else
+			action_result(pfn, MF_MSG_HUGE, MF_FAILED);
 		return res;
 	} else if (res == -EBUSY) {
 		if (!(flags & MF_NO_RETRY)) {
_

Patches currently in -mm which might be from jane.chu@oracle.com are


