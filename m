Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCDBE1E51E1
	for <mm-commits@vger.kernel.org>; Wed, 15 Oct 2025 21:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760562356; cv=none; b=d6QnHadpjRD/YkB8qfxSM+cBx8fkx1fWkgqclpHKIAA//gFpVVECnCYKyrIptmdPytPz6+NU5oLkon/wqReVBL5HbXNpCwd1jcMqEmaak+Kzjjs3dKrOnR3fPuvr/VCv44RJS1Um+P6fHWIDwwB9SC1bIxo3lCHTRw+jIvsTHJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760562356; c=relaxed/simple;
	bh=qkGzaJ9g1sYrQ+C33eWSyp6upqAhyktUuZ1h8jq3C0I=;
	h=Date:To:From:Subject:Message-Id; b=o8mO8A+jzepOD92KryCR0sxanC/yLvwqB5uPY8yNEclb2k7+K4uhrGLKwg9oIL7BJ9tTbd2osLOKqSgfGL5F8oQXEEuZbrMxRAdzGyhlzzEsMUM05NUeYZQVOYfp3RfrZsj/kYTAqUgi8stYTa+3Blzxng4tLXWqffZJbxaCsII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bXaxlSjF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bXaxlSjF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C0ABC4CEF8;
	Wed, 15 Oct 2025 21:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760562356;
	bh=qkGzaJ9g1sYrQ+C33eWSyp6upqAhyktUuZ1h8jq3C0I=;
	h=Date:To:From:Subject:From;
	b=bXaxlSjFEeYgJHPi+HA+oXzEJFyI/ObZ7pOUY6uS1aoq7YSTNeG99Hn90I5Kzw5FZ
	 bpQVhIDW5FqL0w3d/eLwaVnmIoasNMHNAy1KRqlQz7aULfjg7ls2bgkrXpRfpMWHOh
	 HnTYdgoT8HEVmOvcSrpWkS0nyh5ltIctOoouS28c=
Date: Wed, 15 Oct 2025 14:05:55 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,surenb@google.com,mhocko@suse.com,mgorman@techsingularity.net,joshua.hahnjy@gmail.com,jackmanb@google.com,hannes@cmpxchg.org,vbabka@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-simplify-and-cleanup-pcp-locking.patch added to mm-new branch
Message-Id: <20251015210556.4C0ABC4CEF8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: simplify and cleanup pcp locking
has been added to the -mm mm-new branch.  Its filename is
     mm-page_alloc-simplify-and-cleanup-pcp-locking.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-simplify-and-cleanup-pcp-locking.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm/page_alloc: simplify and cleanup pcp locking
Date: Wed, 15 Oct 2025 19:50:38 +0200

The pcp locking relies on pcp_spin_trylock() which has to be used together
with pcp_trylock_prepare()/pcp_trylock_finish() to work properly on !SMP
!RT configs.  This is tedious and error-prone.

We can remove pcp_spin_lock() and underlying pcpu_spin_lock() because we
don't use it.  Afterwards pcp_spin_unlock() is only used together with
pcp_spin_trylock().  Therefore we can add the UP_flags parameter to them
both and handle pcp_trylock_prepare()/finish() within.

Additionally for the configs where pcp_trylock_prepare()/finish() are
no-op (SMP || RT) make them pass &UP_flags to a no-op inline function. 
This ensures typechecking and makes the local variable "used" so we can
remove the __maybe_unused attributes.

In my compile testing, bloat-o-meter reported no change on SMP config, so
the compiler is capable of optimizing away the no-ops same as before, and
we have simplified the code using pcp_spin_trylock().

Link: https://lkml.kernel.org/r/20251015-b4-pcp-lock-cleanup-v2-1-740d999595d5@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   99 ++++++++++++++++++----------------------------
 1 file changed, 40 insertions(+), 59 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-simplify-and-cleanup-pcp-locking
+++ a/mm/page_alloc.c
@@ -99,9 +99,12 @@ static DEFINE_MUTEX(pcp_batch_high_lock)
 /*
  * On SMP, spin_trylock is sufficient protection.
  * On PREEMPT_RT, spin_trylock is equivalent on both SMP and UP.
+ * Pass flags to a no-op inline function to typecheck and silence the unused
+ * variable warning.
  */
-#define pcp_trylock_prepare(flags)	do { } while (0)
-#define pcp_trylock_finish(flag)	do { } while (0)
+static inline void __pcp_trylock_noop(unsigned long *flags) { }
+#define pcp_trylock_prepare(flags)	__pcp_trylock_noop(&(flags))
+#define pcp_trylock_finish(flags)	__pcp_trylock_noop(&(flags))
 #else
 
 /* UP spin_trylock always succeeds so disable IRQs to prevent re-entrancy. */
@@ -129,15 +132,6 @@ static DEFINE_MUTEX(pcp_batch_high_lock)
  * Generic helper to lookup and a per-cpu variable with an embedded spinlock.
  * Return value should be used with equivalent unlock helper.
  */
-#define pcpu_spin_lock(type, member, ptr)				\
-({									\
-	type *_ret;							\
-	pcpu_task_pin();						\
-	_ret = this_cpu_ptr(ptr);					\
-	spin_lock(&_ret->member);					\
-	_ret;								\
-})
-
 #define pcpu_spin_trylock(type, member, ptr)				\
 ({									\
 	type *_ret;							\
@@ -157,14 +151,21 @@ static DEFINE_MUTEX(pcp_batch_high_lock)
 })
 
 /* struct per_cpu_pages specific helpers. */
-#define pcp_spin_lock(ptr)						\
-	pcpu_spin_lock(struct per_cpu_pages, lock, ptr)
-
-#define pcp_spin_trylock(ptr)						\
-	pcpu_spin_trylock(struct per_cpu_pages, lock, ptr)
+#define pcp_spin_trylock(ptr, UP_flags)					\
+({									\
+	struct per_cpu_pages *__ret;					\
+	pcp_trylock_prepare(UP_flags);					\
+	__ret = pcpu_spin_trylock(struct per_cpu_pages, lock, ptr);	\
+	if (!__ret)							\
+		pcp_trylock_finish(UP_flags);				\
+	__ret;								\
+})
 
-#define pcp_spin_unlock(ptr)						\
-	pcpu_spin_unlock(lock, ptr)
+#define pcp_spin_unlock(ptr, UP_flags)					\
+({									\
+	pcpu_spin_unlock(lock, ptr);					\
+	pcp_trylock_finish(UP_flags);					\
+})
 
 #ifdef CONFIG_USE_PERCPU_NUMA_NODE_ID
 DEFINE_PER_CPU(int, numa_node);
@@ -2887,13 +2888,10 @@ static bool free_frozen_page_commit(stru
 		if (to_free == 0 || pcp->count == 0)
 			break;
 
-		pcp_spin_unlock(pcp);
-		pcp_trylock_finish(*UP_flags);
+		pcp_spin_unlock(pcp, *UP_flags);
 
-		pcp_trylock_prepare(*UP_flags);
-		pcp = pcp_spin_trylock(zone->per_cpu_pageset);
+		pcp = pcp_spin_trylock(zone->per_cpu_pageset, *UP_flags);
 		if (!pcp) {
-			pcp_trylock_finish(*UP_flags);
 			ret = false;
 			break;
 		}
@@ -2904,8 +2902,7 @@ static bool free_frozen_page_commit(stru
 		 * returned in an unlocked state.
 		 */
 		if (smp_processor_id() != cpu) {
-			pcp_spin_unlock(pcp);
-			pcp_trylock_finish(*UP_flags);
+			pcp_spin_unlock(pcp, *UP_flags);
 			ret = false;
 			break;
 		}
@@ -2937,7 +2934,7 @@ static bool free_frozen_page_commit(stru
 static void __free_frozen_pages(struct page *page, unsigned int order,
 				fpi_t fpi_flags)
 {
-	unsigned long __maybe_unused UP_flags;
+	unsigned long UP_flags;
 	struct per_cpu_pages *pcp;
 	struct zone *zone;
 	unsigned long pfn = page_to_pfn(page);
@@ -2973,17 +2970,15 @@ static void __free_frozen_pages(struct p
 		add_page_to_zone_llist(zone, page, order);
 		return;
 	}
-	pcp_trylock_prepare(UP_flags);
-	pcp = pcp_spin_trylock(zone->per_cpu_pageset);
+	pcp = pcp_spin_trylock(zone->per_cpu_pageset, UP_flags);
 	if (pcp) {
 		if (!free_frozen_page_commit(zone, pcp, page, migratetype,
 						order, fpi_flags, &UP_flags))
 			return;
-		pcp_spin_unlock(pcp);
+		pcp_spin_unlock(pcp, UP_flags);
 	} else {
 		free_one_page(zone, page, pfn, order, fpi_flags);
 	}
-	pcp_trylock_finish(UP_flags);
 }
 
 void free_frozen_pages(struct page *page, unsigned int order)
@@ -2996,7 +2991,7 @@ void free_frozen_pages(struct page *page
  */
 void free_unref_folios(struct folio_batch *folios)
 {
-	unsigned long __maybe_unused UP_flags;
+	unsigned long UP_flags;
 	struct per_cpu_pages *pcp = NULL;
 	struct zone *locked_zone = NULL;
 	int i, j;
@@ -3039,8 +3034,7 @@ void free_unref_folios(struct folio_batc
 		if (zone != locked_zone ||
 		    is_migrate_isolate(migratetype)) {
 			if (pcp) {
-				pcp_spin_unlock(pcp);
-				pcp_trylock_finish(UP_flags);
+				pcp_spin_unlock(pcp, UP_flags);
 				locked_zone = NULL;
 				pcp = NULL;
 			}
@@ -3059,10 +3053,8 @@ void free_unref_folios(struct folio_batc
 			 * trylock is necessary as folios may be getting freed
 			 * from IRQ or SoftIRQ context after an IO completion.
 			 */
-			pcp_trylock_prepare(UP_flags);
-			pcp = pcp_spin_trylock(zone->per_cpu_pageset);
+			pcp = pcp_spin_trylock(zone->per_cpu_pageset, UP_flags);
 			if (unlikely(!pcp)) {
-				pcp_trylock_finish(UP_flags);
 				free_one_page(zone, &folio->page, pfn,
 					      order, FPI_NONE);
 				continue;
@@ -3085,10 +3077,8 @@ void free_unref_folios(struct folio_batc
 		}
 	}
 
-	if (pcp) {
-		pcp_spin_unlock(pcp);
-		pcp_trylock_finish(UP_flags);
-	}
+	if (pcp)
+		pcp_spin_unlock(pcp, UP_flags);
 	folio_batch_reinit(folios);
 }
 
@@ -3339,15 +3329,12 @@ static struct page *rmqueue_pcplist(stru
 	struct per_cpu_pages *pcp;
 	struct list_head *list;
 	struct page *page;
-	unsigned long __maybe_unused UP_flags;
+	unsigned long UP_flags;
 
 	/* spin_trylock may fail due to a parallel drain or IRQ reentrancy. */
-	pcp_trylock_prepare(UP_flags);
-	pcp = pcp_spin_trylock(zone->per_cpu_pageset);
-	if (!pcp) {
-		pcp_trylock_finish(UP_flags);
+	pcp = pcp_spin_trylock(zone->per_cpu_pageset, UP_flags);
+	if (!pcp)
 		return NULL;
-	}
 
 	/*
 	 * On allocation, reduce the number of pages that are batch freed.
@@ -3357,8 +3344,7 @@ static struct page *rmqueue_pcplist(stru
 	pcp->free_count >>= 1;
 	list = &pcp->lists[order_to_pindex(migratetype, order)];
 	page = __rmqueue_pcplist(zone, order, migratetype, alloc_flags, pcp, list);
-	pcp_spin_unlock(pcp);
-	pcp_trylock_finish(UP_flags);
+	pcp_spin_unlock(pcp, UP_flags);
 	if (page) {
 		__count_zid_vm_events(PGALLOC, page_zonenum(page), 1 << order);
 		zone_statistics(preferred_zone, zone, 1);
@@ -5045,7 +5031,7 @@ unsigned long alloc_pages_bulk_noprof(gf
 			struct page **page_array)
 {
 	struct page *page;
-	unsigned long __maybe_unused UP_flags;
+	unsigned long UP_flags;
 	struct zone *zone;
 	struct zoneref *z;
 	struct per_cpu_pages *pcp;
@@ -5139,10 +5125,9 @@ retry_this_zone:
 		goto failed;
 
 	/* spin_trylock may fail due to a parallel drain or IRQ reentrancy. */
-	pcp_trylock_prepare(UP_flags);
-	pcp = pcp_spin_trylock(zone->per_cpu_pageset);
+	pcp = pcp_spin_trylock(zone->per_cpu_pageset, UP_flags);
 	if (!pcp)
-		goto failed_irq;
+		goto failed;
 
 	/* Attempt the batch allocation */
 	pcp_list = &pcp->lists[order_to_pindex(ac.migratetype, 0)];
@@ -5159,8 +5144,8 @@ retry_this_zone:
 		if (unlikely(!page)) {
 			/* Try and allocate at least one page */
 			if (!nr_account) {
-				pcp_spin_unlock(pcp);
-				goto failed_irq;
+				pcp_spin_unlock(pcp, UP_flags);
+				goto failed;
 			}
 			break;
 		}
@@ -5171,8 +5156,7 @@ retry_this_zone:
 		page_array[nr_populated++] = page;
 	}
 
-	pcp_spin_unlock(pcp);
-	pcp_trylock_finish(UP_flags);
+	pcp_spin_unlock(pcp, UP_flags);
 
 	__count_zid_vm_events(PGALLOC, zone_idx(zone), nr_account);
 	zone_statistics(zonelist_zone(ac.preferred_zoneref), zone, nr_account);
@@ -5180,9 +5164,6 @@ retry_this_zone:
 out:
 	return nr_populated;
 
-failed_irq:
-	pcp_trylock_finish(UP_flags);
-
 failed:
 	page = __alloc_pages_noprof(gfp, 0, preferred_nid, nodemask);
 	if (page)
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-page_alloc-simplify-and-cleanup-pcp-locking.patch

