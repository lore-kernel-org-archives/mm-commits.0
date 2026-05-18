Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E27B3845DC
	for <mm-commits@vger.kernel.org>; Mon, 18 May 2026 18:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779128082; cv=none; b=oWxuoCvPgQkWGOo9GsRHRnVEdaR8FoUW1I27SZdwa8ud5vkNC5waXPMPvUzEii/4hXVC9V242LDvaQ+iNUE0SEHKZ4RPdRg6OfggEi6OIQYd7V80iYCMnGg6dpVhfztq2kTxjho/ro9LqrXOedaZ8lx5CpIQ/HR3V3oujWiXjdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779128082; c=relaxed/simple;
	bh=x7a1QHq0/seypwBBnX7IHfw4yWyJoIpr3eyw4/ZHGes=;
	h=Date:To:From:Subject:Message-Id; b=FeFPfskVaTROWkXHwvlu1pLqJfRx97qOV+f4vpGHx4i1cuJW8j8mT+rCt7Dg5yXxMyOEo2az9xUM5nBTQGgVGkalzt+QLH/1KlUUwPts83Gk39EVhO4M9+EPzOAe3DQOIg5Nqdwy/jo8WzHFjK1OVg1wIfNZdiUSRWgThUUtGwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PPhV8qmL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PPhV8qmL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DB4FC2BCB7;
	Mon, 18 May 2026 18:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779128081;
	bh=x7a1QHq0/seypwBBnX7IHfw4yWyJoIpr3eyw4/ZHGes=;
	h=Date:To:From:Subject:From;
	b=PPhV8qmLazOAsqxYwgmRIMbmRbQxyFAu2BISv51U1thG4inr1qXpTHld4ho8m+2sP
	 mhkpPGXWOyev5IR2U6hCnETlqLsQrMq1PtOH05Y/gUrN+DkMhJbnK0uGBp2pCi8dxj
	 XN62Hj2fId2HDY80KCIMqRWZHcbLRjbVq8daabAg=
Date: Mon, 18 May 2026 11:14:41 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuanchu@google.com,weixugc@google.com,vbabka@kernel.org,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,rafael@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lenb@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,baohua@kernel.org,axelrasmussen@google.com,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-introduce-for_each_free_list.patch added to mm-new branch
Message-Id: <20260518181441.8DB4FC2BCB7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: introduce for_each_free_list()
has been added to the -mm mm-new branch.  Its filename is
     mm-introduce-for_each_free_list.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-introduce-for_each_free_list.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

mm-page_alloc-cleanup-flag-vars-in-alloc_pages_bulk_noprof.patch
drm-managed-use-special-gfp_t-format-specifier.patch
mm-kfence-use-special-gfp_t-format-specifier.patch
net-rds-use-special-gfp_t-format-specifier.patch
mm-introduce-for_each_free_list.patch
mm-page_alloc-dont-overload-migratetype-in-find_suitable_fallback.patch
mm-rejig-pageblock-mask-definitions.patch
mm-page_alloc-remove-ifdefs-from-pindex-helpers.patch

