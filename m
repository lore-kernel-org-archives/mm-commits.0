Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2580A1C54A2;
	Wed,  7 May 2025 20:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746651098; cv=none; b=NAwdEfAHYKLbVdFRTTjrPhJVpIQecL5U4oy3HnYCRox5K9o1vVInRjWEjK9DvsiazTIajCVlQpFdYu+KM5XbxOPYDNTIrvVsqTG+/6/rtjJUrwMn5HYGHS1d12WXyBG+y48imAdxg7DUEoG3FKlDfUnkKPjWyy6P5h0oWko6h5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746651098; c=relaxed/simple;
	bh=49uI3NCatv+Pg7zw/gjti7iKg2CycLAoxiN1rFKj6yo=;
	h=Date:To:From:Subject:Message-Id; b=Y7x1cXe1HWZozFjaXY4jdlq3HILHDDHMxE6tGMGVSE7msr9KHAXcwFWMSLlu//d0vpeZlUEWN1V50SY0s0hgz+ZjclHOKP/c4aRJ034lgj2mR3IcTA9zYtsv4TNSYX46/U/pRvuLFI+Cp+c8DXzN01//0+UKEvTXfhnAW7MjAE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=edCtGUZJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="edCtGUZJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 862E1C4CEE2;
	Wed,  7 May 2025 20:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746651097;
	bh=49uI3NCatv+Pg7zw/gjti7iKg2CycLAoxiN1rFKj6yo=;
	h=Date:To:From:Subject:From;
	b=edCtGUZJ32uMPI9sH3CWZtyNJIx3rnrsG9RPdgsOrFffSPdh4vi/cY2taqhqe4EnQ
	 aKeGrpz/kwh22rbhxLV6NN1PcZN9h/BfstCepfLiHxoJVRZMAxDvJl0YCJ40f/H9+4
	 TiqPoxLYFH6BAGR3cO9ppBQB6u22/Y95BUtFyztA=
Date: Wed, 07 May 2025 13:51:36 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,tglx@linutronix.de,surenb@google.com,stable@vger.kernel.org,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,bp@alien8.de,kirill.shutemov@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-fix-race-condition-in-unaccepted-memory-handling.patch added to mm-hotfixes-unstable branch
Message-Id: <20250507205137.862E1C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: fix race condition in unaccepted memory handling
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-page_alloc-fix-race-condition-in-unaccepted-memory-handling.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-fix-race-condition-in-unaccepted-memory-handling.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm/page_alloc: fix race condition in unaccepted memory handling
Date: Tue, 6 May 2025 16:32:07 +0300

The page allocator tracks the number of zones that have unaccepted memory
using static_branch_enc/dec() and uses that static branch in hot paths to
determine if it needs to deal with unaccepted memory.

Borislav and Thomas pointed out that the tracking is racy: operations on
static_branch are not serialized against adding/removing unaccepted pages
to/from the zone.

Sanity checks inside static_branch machinery detects it:

WARNING: CPU: 0 PID: 10 at kernel/jump_label.c:276 __static_key_slow_dec_cpuslocked+0x8e/0xa0

The comment around the WARN() explains the problem:

	/*
	 * Warn about the '-1' case though; since that means a
	 * decrement is concurrent with a first (0->1) increment. IOW
	 * people are trying to disable something that wasn't yet fully
	 * enabled. This suggests an ordering problem on the user side.
	 */

The effect of this static_branch optimization is only visible on
microbenchmark.

Instead of adding more complexity around it, remove it altogether.

Link: https://lkml.kernel.org/r/20250506133207.1009676-1-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Fixes: dcdfdd40fa82 ("mm: Add support for unaccepted memory")
Link: https://lore.kernel.org/all/20250506092445.GBaBnVXXyvnazly6iF@fat_crate.local
Reported-by: Borislav Petkov <bp@alien8.de>
Tested-by: Borislav Petkov (AMD) <bp@alien8.de>
Reported-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: <stable@vger.kernel.org>	[6.5+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h   |    1 
 mm/mm_init.c    |    1 
 mm/page_alloc.c |   47 ----------------------------------------------
 3 files changed, 49 deletions(-)

--- a/mm/internal.h~mm-page_alloc-fix-race-condition-in-unaccepted-memory-handling
+++ a/mm/internal.h
@@ -1590,7 +1590,6 @@ unsigned long move_page_tables(struct pa
 
 #ifdef CONFIG_UNACCEPTED_MEMORY
 void accept_page(struct page *page);
-void unaccepted_cleanup_work(struct work_struct *work);
 #else /* CONFIG_UNACCEPTED_MEMORY */
 static inline void accept_page(struct page *page)
 {
--- a/mm/mm_init.c~mm-page_alloc-fix-race-condition-in-unaccepted-memory-handling
+++ a/mm/mm_init.c
@@ -1441,7 +1441,6 @@ static void __meminit zone_init_free_lis
 
 #ifdef CONFIG_UNACCEPTED_MEMORY
 	INIT_LIST_HEAD(&zone->unaccepted_pages);
-	INIT_WORK(&zone->unaccepted_cleanup, unaccepted_cleanup_work);
 #endif
 }
 
--- a/mm/page_alloc.c~mm-page_alloc-fix-race-condition-in-unaccepted-memory-handling
+++ a/mm/page_alloc.c
@@ -7180,16 +7180,8 @@ bool has_managed_dma(void)
 
 #ifdef CONFIG_UNACCEPTED_MEMORY
 
-/* Counts number of zones with unaccepted pages. */
-static DEFINE_STATIC_KEY_FALSE(zones_with_unaccepted_pages);
-
 static bool lazy_accept = true;
 
-void unaccepted_cleanup_work(struct work_struct *work)
-{
-	static_branch_dec(&zones_with_unaccepted_pages);
-}
-
 static int __init accept_memory_parse(char *p)
 {
 	if (!strcmp(p, "lazy")) {
@@ -7214,11 +7206,7 @@ static bool page_contains_unaccepted(str
 static void __accept_page(struct zone *zone, unsigned long *flags,
 			  struct page *page)
 {
-	bool last;
-
 	list_del(&page->lru);
-	last = list_empty(&zone->unaccepted_pages);
-
 	account_freepages(zone, -MAX_ORDER_NR_PAGES, MIGRATE_MOVABLE);
 	__mod_zone_page_state(zone, NR_UNACCEPTED, -MAX_ORDER_NR_PAGES);
 	__ClearPageUnaccepted(page);
@@ -7227,28 +7215,6 @@ static void __accept_page(struct zone *z
 	accept_memory(page_to_phys(page), PAGE_SIZE << MAX_PAGE_ORDER);
 
 	__free_pages_ok(page, MAX_PAGE_ORDER, FPI_TO_TAIL);
-
-	if (last) {
-		/*
-		 * There are two corner cases:
-		 *
-		 * - If allocation occurs during the CPU bring up,
-		 *   static_branch_dec() cannot be used directly as
-		 *   it causes a deadlock on cpu_hotplug_lock.
-		 *
-		 *   Instead, use schedule_work() to prevent deadlock.
-		 *
-		 * - If allocation occurs before workqueues are initialized,
-		 *   static_branch_dec() should be called directly.
-		 *
-		 *   Workqueues are initialized before CPU bring up, so this
-		 *   will not conflict with the first scenario.
-		 */
-		if (system_wq)
-			schedule_work(&zone->unaccepted_cleanup);
-		else
-			unaccepted_cleanup_work(&zone->unaccepted_cleanup);
-	}
 }
 
 void accept_page(struct page *page)
@@ -7285,20 +7251,12 @@ static bool try_to_accept_memory_one(str
 	return true;
 }
 
-static inline bool has_unaccepted_memory(void)
-{
-	return static_branch_unlikely(&zones_with_unaccepted_pages);
-}
-
 static bool cond_accept_memory(struct zone *zone, unsigned int order,
 			       int alloc_flags)
 {
 	long to_accept, wmark;
 	bool ret = false;
 
-	if (!has_unaccepted_memory())
-		return false;
-
 	if (list_empty(&zone->unaccepted_pages))
 		return false;
 
@@ -7336,22 +7294,17 @@ static bool __free_unaccepted(struct pag
 {
 	struct zone *zone = page_zone(page);
 	unsigned long flags;
-	bool first = false;
 
 	if (!lazy_accept)
 		return false;
 
 	spin_lock_irqsave(&zone->lock, flags);
-	first = list_empty(&zone->unaccepted_pages);
 	list_add_tail(&page->lru, &zone->unaccepted_pages);
 	account_freepages(zone, MAX_ORDER_NR_PAGES, MIGRATE_MOVABLE);
 	__mod_zone_page_state(zone, NR_UNACCEPTED, MAX_ORDER_NR_PAGES);
 	__SetPageUnaccepted(page);
 	spin_unlock_irqrestore(&zone->lock, flags);
 
-	if (first)
-		static_branch_inc(&zones_with_unaccepted_pages);
-
 	return true;
 }
 
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-page_alloc-ensure-try_alloc_pages-plays-well-with-unaccepted-memory.patch
mm-page_alloc-fix-race-condition-in-unaccepted-memory-handling.patch

