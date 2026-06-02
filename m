Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B8AA3B9D84
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439056; cv=none; b=mVoVFRfptu5KAOt8n+GiymeC4VBvoHsFwkBOvRfzoiNepmWfwV9QdipC449QNtGvyV5eTvYC7Zpyq009rQohahpbCA2hK4qzgiJsfBLi/eh7ex2SeNny2upW+ImjG5y9x6/7BtmMSiVoIfI7MMJEu7P7q3nza3sf/VR7Xb48E1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439056; c=relaxed/simple;
	bh=MtEwXs25xQuryZivo+7vobazLSft07XbYFTdU1tGWJg=;
	h=Date:To:From:Subject:Message-Id; b=eCzKlfPoqwGqqrV0vLkL+z9/dBC6c/9RQp+7KV7S1tYTPQT2Wf1+E/Pg1QGrJEVQov98q2+jBfbyscYwq/I+jFZeLg2oKs4WvtPThLvRpW40aDDFIpcFpZ+wXuDRa5H8slBBCRPwwCr6/wE9dyq9PLiHjWIsP78bKRN9As+yHcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TnbZuxhD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TnbZuxhD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E652B1F00898;
	Tue,  2 Jun 2026 22:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439055;
	bh=80sfBOW4rspPUvNzpSyTokZOZGbwSJdIut5Kd1zPKhI=;
	h=Date:To:From:Subject;
	b=TnbZuxhDHxerDcfEZKQJ7J/WsWm1CYcoGhM76Msma8nKr3nk5fs1/ddcy7eZEAFOM
	 U7D1lZmkU9usGfsZlO/fDoZu8GNwQe8kpfTJDuvck4PZQCrlQ6vGiu8+KYNzlSoWC8
	 qjzGs1eHW3fmp+zZJ16ng2vvMYMVBHMNFZu9EL+E=
Date: Tue, 02 Jun 2026 15:24:14 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuanchu@google.com,weixugc@google.com,vbabka@kernel.org,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,rafael@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lenb@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,baohua@kernel.org,axelrasmussen@google.com,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-introduce-for_each_free_list.patch removed from -mm tree
Message-Id: <20260602222414.E652B1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: introduce for_each_free_list()
has been removed from the -mm tree.  Its filename was
     mm-introduce-for_each_free_list.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Brendan Jackman <jackmanb@google.com>
Subject: mm: introduce for_each_free_list()
Date: Wed, 13 May 2026 12:35:13 +0000

Patch series "mm: misc cleanups from __GFP_UNMAPPED series".

In v2 of the __GFP_UNMAPPED series [0], we realised that some of the
patches could potentially be merged as independent cleanups.

These are all independent of one another, if you think some are useful
cleanups and others are pointless churn, it should be fine to just pick
whatever subset you prefer.

No functional change intended.


This patch (of 4):

There are a couple of places that iterate over the freelists with
awareness of the data structures' layout.

It seems ideally, code outside of mm should not be aware of the page
allocator's freelists at all.  But, this patch just doesn't hide them
completely, it's just a meek incremental step in that direction: provide a
macro to iterate over it without needing to be aware of the actual struct
fields.

Link: https://lore.kernel.org/20260513-page_alloc-unmapped-prep-v1-0-dacdf5402be8@google.com
Link: https://lore.kernel.org/20260513-page_alloc-unmapped-prep-v1-1-dacdf5402be8@google.com
Link: https://lore.kernel.org/all/20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com/ [0]
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h  |    9 ++++++---
 kernel/power/snapshot.c |    8 ++++----
 mm/mm_init.c            |   11 +++++++----
 3 files changed, 17 insertions(+), 11 deletions(-)

--- a/include/linux/mmzone.h~mm-introduce-for_each_free_list
+++ a/include/linux/mmzone.h
@@ -177,9 +177,12 @@ static inline bool migratetype_is_mergea
 	return mt < MIGRATE_PCPTYPES;
 }
 
-#define for_each_migratetype_order(order, type) \
-	for (order = 0; order < NR_PAGE_ORDERS; order++) \
-		for (type = 0; type < MIGRATE_TYPES; type++)
+#define for_each_free_list(list, zone, order) 				\
+	for (order = 0; order < NR_PAGE_ORDERS; order++) 		\
+		for (unsigned int __type = 0; 				\
+		     __type < MIGRATE_TYPES &&				\
+			(list = &(zone)->free_area[order].free_list[__type], 1); \
+		     __type++)
 
 extern int page_group_by_mobility_disabled;
 
--- a/kernel/power/snapshot.c~mm-introduce-for_each_free_list
+++ a/kernel/power/snapshot.c
@@ -1244,8 +1244,9 @@ unsigned int snapshot_additional_pages(s
 static void mark_free_pages(struct zone *zone)
 {
 	unsigned long pfn, max_zone_pfn, page_count = WD_PAGE_COUNT;
+	struct list_head *free_list;
 	unsigned long flags;
-	unsigned int order, t;
+	unsigned int order;
 	struct page *page;
 
 	if (zone_is_empty(zone))
@@ -1269,9 +1270,8 @@ static void mark_free_pages(struct zone
 			swsusp_unset_page_free(page);
 	}
 
-	for_each_migratetype_order(order, t) {
-		list_for_each_entry(page,
-				&zone->free_area[order].free_list[t], buddy_list) {
+	for_each_free_list(free_list, zone, order) {
+		list_for_each_entry(page, free_list, buddy_list) {
 			unsigned long i;
 
 			pfn = page_to_pfn(page);
--- a/mm/mm_init.c~mm-introduce-for_each_free_list
+++ a/mm/mm_init.c
@@ -1429,11 +1429,14 @@ static void __meminit zone_init_internal
 
 static void __meminit zone_init_free_lists(struct zone *zone)
 {
-	unsigned int order, t;
-	for_each_migratetype_order(order, t) {
-		INIT_LIST_HEAD(&zone->free_area[order].free_list[t]);
+	struct list_head *list;
+	unsigned int order;
+
+	for_each_free_list(list, zone, order)
+		INIT_LIST_HEAD(list);
+
+	for (order = 0; order < NR_PAGE_ORDERS; order++)
 		zone->free_area[order].nr_free = 0;
-	}
 
 #ifdef CONFIG_UNACCEPTED_MEMORY
 	INIT_LIST_HEAD(&zone->unaccepted_pages);
_

Patches currently in -mm which might be from jackmanb@google.com are

mm-delete-stale-comment-about-cachelines.patch

