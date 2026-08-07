Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 726A33B5F59
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068095; cv=none; b=LfRqwNkFWvPlxDzyvp+9VX6vlcoN7T7dGoL/CepO42y3nuVV+i3Kb1ahm9R69LEKtatsfp8rfalzjEvbp4+XkJYJFH97+89RzEaJLQ2epfItDpir9ZjBGId29cpyDr51QeCpcE4FM3ZlVRSV+US78vd//bU/sh862VMNzk8b2dY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068095; c=relaxed/simple;
	bh=I2KKdvoaXYkBAGov9ue2d0MpqSBXkRBR0cJ5Q4oMBP0=;
	h=Date:To:From:Subject:Message-Id; b=YC5awJrb62C4xUItb1muUVBc7uwkLQ0QNkC9rf0Ph+U1UKIGO4RgVHmHpFNpwpDvcNTi48aqB/H9lGxFCHocylhZx11xPHSAyRRqPIvsaSgebb4XZs4Df2Ai74Uy0JefVy0csHb4TeT8chIxB4/WsQ5SCUPfGaM4jz3KEST658g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DmyGnpRT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DmyGnpRT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 159781F00A3A;
	Fri,  7 Aug 2026 02:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068088;
	bh=+GuvSu6dah38m8sMDH5HcYF7fK8Nqn/LYlLCD9nv4Q4=;
	h=Date:To:From:Subject;
	b=DmyGnpRTffa587rVvcLX37f8kBnbVSZBh3LogU6qbxoDeqxlrOvMa8BQqoOEM2JfS
	 VUyyt47Kr0u0mCIMBupTJnoe6aSSWejD+LWWcJ2/Cl4ddh+0Si2/8Fuf9zqw23HRpR
	 n7s3tF4i2KNwi8y7YYD7Mo5hYnI2qTs03Ri3FEmQ=
Date: Thu, 06 Aug 2026 19:01:27 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,tj@kernel.org,surenb@google.com,rppt@kernel.org,rostedt@goodmis.org,mkoutny@suse.com,mhocko@suse.com,longman@redhat.com,ljs@kernel.org,liam@infradead.org,hannes@cmpxchg.org,david@kernel.org,brendan.jackman@linux.dev,bigeasy@linutronix.de,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-rename-fpi_trylock-fpi_nolock.patch removed from -mm tree
Message-Id: <20260807020128.159781F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: rename FPI_TRYLOCK -> FPI_NOLOCK
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-rename-fpi_trylock-fpi_nolock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Brendan Jackman <jackmanb@google.com>
Subject: mm/page_alloc: rename FPI_TRYLOCK -> FPI_NOLOCK
Date: Wed, 15 Jul 2026 11:03:18 +0000

Patch series "mm/page_alloc: couple of followups for recent cleanups", v3.


This patch (of 4):

As discussed in the linked patch, the there is some inconsistency between
"trylock" and "nolock" nomenclature, let's align it.  Since "nolock" is
used in the public API it seems to have more mindshare so do that.

The linked patch did this for the ALLOC_ flag but forgot about FPI_.

Link: https://lore.kernel.org/20260715-spin-trylock-followup-v3-0-fc4d246f705d@google.com
Link: https://lore.kernel.org/all/20260703-alloc-trylock-v5-1-c87b714e19d3@google.com/
Link: https://lore.kernel.org/20260715-spin-trylock-followup-v3-1-fc4d246f705d@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Waiman Long <longman@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-rename-fpi_trylock-fpi_nolock
+++ a/mm/page_alloc.c
@@ -90,7 +90,7 @@ typedef int __bitwise fpi_t;
 #define FPI_TO_TAIL		((__force fpi_t)BIT(1))
 
 /* Free the page without taking locks. Rely on trylock only. */
-#define FPI_TRYLOCK		((__force fpi_t)BIT(2))
+#define FPI_NOLOCK		((__force fpi_t)BIT(2))
 
 /* free_pages_prepare() has already been called for page(s) being freed. */
 #define FPI_PREPARED		((__force fpi_t)BIT(3))
@@ -1419,7 +1419,7 @@ static __always_inline bool __free_pages
 	page_table_check_free(page, order);
 	pgalloc_tag_sub(page, 1 << order);
 
-	if (!PageHighMem(page) && !(fpi_flags & FPI_TRYLOCK)) {
+	if (!PageHighMem(page) && !(fpi_flags & FPI_NOLOCK)) {
 		debug_check_no_locks_freed(page_address(page),
 					   PAGE_SIZE << order);
 		debug_check_no_obj_freed(page_address(page),
@@ -1558,7 +1558,7 @@ static void free_one_page(struct zone *z
 	struct llist_head *llhead;
 	unsigned long flags;
 
-	if (unlikely(fpi_flags & FPI_TRYLOCK)) {
+	if (unlikely(fpi_flags & FPI_NOLOCK)) {
 		if (!can_spin_trylock() || !spin_trylock_irqsave(&zone->lock, flags)) {
 			add_page_to_zone_llist(zone, page, order);
 			return;
@@ -1569,7 +1569,7 @@ static void free_one_page(struct zone *z
 
 	/* The lock succeeded. Process deferred pages. */
 	llhead = &zone->trylock_free_pages;
-	if (unlikely(!llist_empty(llhead) && !(fpi_flags & FPI_TRYLOCK))) {
+	if (unlikely(!llist_empty(llhead) && !(fpi_flags & FPI_NOLOCK))) {
 		struct llist_node *llnode;
 		struct page *p, *tmp;
 
@@ -2882,7 +2882,7 @@ static bool free_frozen_page_commit(stru
 	if (pcp->free_count < (batch << CONFIG_PCP_BATCH_SCALE_MAX))
 		pcp->free_count += (1 << order);
 
-	if (unlikely(fpi_flags & FPI_TRYLOCK)) {
+	if (unlikely(fpi_flags & FPI_NOLOCK)) {
 		/*
 		 * Do not attempt to take a zone lock. Let pcp->count get
 		 * over high mark temporarily.
@@ -2979,7 +2979,7 @@ static void __free_frozen_pages(struct p
 		migratetype = MIGRATE_MOVABLE;
 	}
 
-	if (unlikely((fpi_flags & FPI_TRYLOCK) && !can_spin_trylock())) {
+	if (unlikely((fpi_flags & FPI_NOLOCK) && !can_spin_trylock())) {
 		add_page_to_zone_llist(zone, page, order);
 		return;
 	}
@@ -3001,7 +3001,7 @@ void free_frozen_pages(struct page *page
 
 void free_frozen_pages_nolock(struct page *page, unsigned int order)
 {
-	__free_frozen_pages(page, order, FPI_TRYLOCK);
+	__free_frozen_pages(page, order, FPI_NOLOCK);
 }
 
 /*
@@ -5398,7 +5398,7 @@ out:
 	if (memcg_kmem_online() && (gfp & __GFP_ACCOUNT) && page &&
 	    unlikely(__memcg_kmem_charge_page(page, gfp, order) != 0)) {
 		__free_frozen_pages(page, order,
-				    alloc_flags & ALLOC_NOLOCK ? FPI_TRYLOCK : 0);
+				    alloc_flags & ALLOC_NOLOCK ? FPI_NOLOCK : 0);
 		page = NULL;
 	}
 
@@ -5521,7 +5521,7 @@ EXPORT_SYMBOL(__free_pages);
  */
 void free_pages_nolock(struct page *page, unsigned int order)
 {
-	___free_pages(page, order, FPI_TRYLOCK);
+	___free_pages(page, order, FPI_NOLOCK);
 }
 
 /**
_

Patches currently in -mm which might be from jackmanb@google.com are


