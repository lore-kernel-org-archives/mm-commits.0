Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F4EF339375
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 02:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785465797; cv=none; b=jFH0iVEulyvShf7ILpCOios0/AZ3XErsOOtYwefBS4NeOLoGQvzXee4wtc7dH3r+WLNliaufyfXR+L4CuiT/psFBIftZEu7sGwKub0GFPo0TKOWzMuqcdHUPa+KNnDFKpMF/2AFja7iHbv3TGyr19x/inaMBeCrDO4nWsc8bXec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785465797; c=relaxed/simple;
	bh=RYbVKsPUL0hZ46CR7oHS9wjxvwU1R838CWLU2jBDBj4=;
	h=Date:To:From:Subject:Message-Id; b=IJFKW/ep0hvgq4INX0BccW6f/Ff8zoFkMSokR5cYZyPRsQSyjbOxi+h6S+xW1kOzrQotO4tKBtD59c6M/D0/uoyGrGTS0iDxLkmWd9sQNeBBLWwKfNw29Hs0evWsth32Nmvp2916EzIbhMAwzliA0n0OnO356yxN3lkkZii15R4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=fail (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zXW2GacB reason="signature verification failed"; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zXW2GacB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 068C61F000E9;
	Fri, 31 Jul 2026 02:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785465796;
	bh=bh5zp/BSlCrjJpZYMn5qm/TE7uyhDsXCsmKpntcoHJk=;
	h=Date:To:From:Subject;
	b=zXW2GacBeFkKle2be0zD9xS8pTZTahxbjoG5BT6e6xwKgkGQnCF7PArLHfaIUP4Tg
	 6kbo4PIjLqU/rdcA60M/FW4MSVtGS75Uz4aHanzIr7JbSoPnkhdPt6MRjpo/Ma7Dgo
	 D7a4XC8uIkXOx4zjc1wuGfYBW1o99KZw0QDaioX0=
Date: Thu, 30 Jul 2026 19:43:15 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,willy@infradead.org,vbabka@kernel.org,surenb@google.com,steve.wahl@hpe.com,seanjc@google.com,rppt@kernel.org,rostedt@goodmis.org,roman.gushchin@linux.dev,robinmholt@gmail.com,rientjes@google.com,reijiw@google.com,rakie.kim@sk.com,peterz@infradead.org,pbonzini@redhat.com,pabeni@redhat.com,osalvador@suse.de,namhyung@kernel.org,muchun.song@linux.dev,mingo@redhat.com,mhocko@suse.com,matthew.brost@intel.com,mark.rutland@arm.com,ljs@kernel.org,liam@infradead.org,kuba@kernel.org,joshua.hahnjy@gmail.com,jolsa@kernel.org,james.clark@linaro.org,irogers@google.com,hpa@zytor.com,harry@kernel.org,hannes@cmpxchg.org,gregkh@linuxfoundation.org,gourry@gourry.net,edumazet@google.com,dmichail@fungible.com,david@kernel.org,davem@davemloft.net,byungchul@sk.com,bp@alien8.de,bigeasy@linutronix.de,ast@kernel.org,arnd@arndb.de,apopple@nvidia.com,alexander.shishkin@linux.intel.com,adrian.hunter@intel.com,acme@kernel.org,jackmanb@googl
 e.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-rename-alloc_trylock-alloc_nolock.patch removed from -mm tree
Message-Id: <20260731024316.068C61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: rename ALLOC_TRYLOCK -> ALLOC_NOLOCK
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-rename-alloc_trylock-alloc_nolock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Brendan Jackman <jackmanb@google.com>
Subject: mm/page_alloc: rename ALLOC_TRYLOCK -> ALLOC_NOLOCK
Date: Fri, 03 Jul 2026 12:31:41 +0000

Patch series "mm: Some cleanups for page allocator APIs", v5.

Some tweaks and cleanups for page allocator entrypoint and flags.  This is
motivated by preparation for __GFP_UNMAPPED [1] (which will probably
become ALLOC_UNMAPPED in its next iteration), but all this is supposed to
be an improvement to the codebase in its own right: unifying code paths,
reducing API surface, and removing GFP flags.

This started with unifying __alloc_frozen_pages[_nolock]_noprof() and
expanded from there.

Unifying the nolock allocator entrypoint with the normal allocator
entrypoint means adding an alloc_flags argument to the later (only exposed
within mm/).  This presents an opportunity to take advantage of that arg
to remove some GFP flags, if we add that alloc_flags arg a bit more
broadly to allocator entrypoints.

To distinguish between mm-internal and "public" allocator entrypoints, it
makes sense to use the __ prefix.  There are already some public APIs with
that prefix.  For *alloc_pages*, just removing those variants seems like a
nice cleanup anyway, so do that.  For get_free_pages, the "__" variant is
the _only_ variant and it's very widely used, so it doesn't seem
worthwhile to modify that.  Therefore, scope this "__" change specifically
to the *alloc_pages* API, which means we leave the *folio_alloc* API
untouched too, even though that could probably be cleaned up if so
desired.


This patch (of 18):

It's confusing that the function is called "nolock" but the flag is called
"trylock", align them.

The function's terminology is more visible and has more mindshare so use that.

Link: https://lore.kernel.org/20260703-alloc-trylock-v5-0-c87b714e19d3@google.com
Link: https://lore.kernel.org/20260703-alloc-trylock-v5-1-c87b714e19d3@google.com
Link: https://lore.kernel.org/linux-mm/2399b3ad-4eac-4a14-94c3-27e9f07972a1@kernel.org/
Link: https://lore.kernel.org/all/20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com/ [1]
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Suggested-by: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Byungchul Park <byungchul@sk.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Dimitris Michailidis <dmichail@fungible.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Gregory Price <gourry@gourry.net>
Cc: Harry Yoo <harry@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jakub Kacinski <kuba@kernel.org>
Cc: James Clark <james.clark@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Namhyung kim <namhyung@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Reiji Watanabe <reijiw@google.com>
Cc: Robin Holt <robinmholt@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Steve Wahl <steve.wahl@hpe.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h   |    2 +-
 mm/page_alloc.c |   10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/mm/internal.h~mm-page_alloc-rename-alloc_trylock-alloc_nolock
+++ a/mm/internal.h
@@ -1480,7 +1480,7 @@ unsigned int reclaim_clean_pages_from_li
 #define ALLOC_NOFRAGMENT	  0x0
 #endif
 #define ALLOC_HIGHATOMIC	0x200 /* Allows access to MIGRATE_HIGHATOMIC */
-#define ALLOC_TRYLOCK		0x400 /* Only use spin_trylock in allocation path */
+#define ALLOC_NOLOCK		0x400 /* Only use spin_trylock in allocation path */
 #define ALLOC_KSWAPD		0x800 /* allow waking of kswapd, __GFP_KSWAPD_RECLAIM set */
 
 /* Flags that allow allocations below the min watermark. */
--- a/mm/page_alloc.c~mm-page_alloc-rename-alloc_trylock-alloc_nolock
+++ a/mm/page_alloc.c
@@ -2530,7 +2530,7 @@ static int rmqueue_bulk(struct zone *zon
 	unsigned long flags;
 	int i;
 
-	if (unlikely(alloc_flags & ALLOC_TRYLOCK)) {
+	if (unlikely(alloc_flags & ALLOC_NOLOCK)) {
 		if (!spin_trylock_irqsave(&zone->lock, flags))
 			return 0;
 	} else {
@@ -3218,7 +3218,7 @@ struct page *rmqueue_buddy(struct zone *
 
 	do {
 		page = NULL;
-		if (unlikely(alloc_flags & ALLOC_TRYLOCK)) {
+		if (unlikely(alloc_flags & ALLOC_NOLOCK)) {
 			if (!spin_trylock_irqsave(&zone->lock, flags))
 				return NULL;
 		} else {
@@ -5059,7 +5059,7 @@ static inline bool prepare_alloc_pages(g
 	 * Don't invoke should_fail logic, since it may call
 	 * get_random_u32() and printk() which need to spin_lock.
 	 */
-	if (!(*alloc_flags & ALLOC_TRYLOCK) &&
+	if (!(*alloc_flags & ALLOC_NOLOCK) &&
 	    should_fail_alloc_page(gfp_mask, order))
 		return false;
 
@@ -7804,7 +7804,7 @@ static bool cond_accept_memory(struct zo
 		return false;
 
 	/* Bailout, since try_to_accept_memory_one() needs to take a lock */
-	if (alloc_flags & ALLOC_TRYLOCK)
+	if (alloc_flags & ALLOC_NOLOCK)
 		return false;
 
 	wmark = promo_wmark_pages(zone);
@@ -7896,7 +7896,7 @@ struct page *alloc_frozen_pages_nolock_n
 	 */
 	gfp_t alloc_gfp = __GFP_NOWARN | __GFP_ZERO | __GFP_NOMEMALLOC | __GFP_COMP
 			| gfp_flags;
-	unsigned int alloc_flags = ALLOC_TRYLOCK;
+	unsigned int alloc_flags = ALLOC_NOLOCK;
 	struct alloc_context ac = { };
 	struct page *page;
 
_

Patches currently in -mm which might be from jackmanb@google.com are

mm-secretmem-dont-allow-highmem-folios.patch
mm-page_alloc-dont-spin_trylock-in-nmi-on-up.patch
mm-page_alloc-dont-spin_trylock-when-disallowed-in-free_one_page.patch
mm-page_alloc-rename-fpi_trylock-fpi_nolock.patch
cgroup-cpuset-update-some-comments-about-the-page-allocator.patch
mm-page_alloc-fixup-alloc_pages_nolock_noprof-comment.patch
mm-page_alloc-remove-a-couple-of-vm_bug_onst.patch

