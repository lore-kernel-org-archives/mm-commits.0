Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793131531;
	b=flDmtCcVmu5u/r5rSie2Cbrq6AQGIRRIjIsb7mmYEKe43LoHqtYQYvkzk+BRnLfCdtZU
	 x4mFkfJAcgF40ceIx3R0pff5SyeTTKavGO42Z5HA33AU9DA0RMXfFE+35h5p9h4tz5Gx+
	 hyNgQ8q15XudjG7+7k4scegUBMt1/z+MAP8yVuTqX+NMmjxY6BtAV+qP4jaMmEY4l4bf7
	 iS9YO0bCGUZYmAvKMqszbKAxvLdIsxGf9sxpGGEYii3s78J8+lJXR+0NGhUpI1Zi0tz9v
	 qebZDAdz6S6mcv70ouNCmJ92GI6DzKmdDFD1zybjoPWPrFGNs9oQYyUd8zqs79IdlWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793131531;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=fUz4b6QdP7dTUELIouxOFIGIJMCUt4wDA++rQwb+PSs=;
	b=4z1o1GaLHkEECXGk1XiHgJKd2YwMrIyixyfNO8RbDNl4y0hWwQsz7qNRpop4jN9oKaKR
	 F0WAx6qG8/1Rfcf0zicVR7jkwdVt9AfLjtIY46xettZoMuXoyvHCoCkd78Iwk67D6l4bY
	 iALxvduVS2xXRA2AD58PpUTEeSx5YjjeY+nMdRHl+iZV3I2wTw5t+nunrR7Z3lMSqpYOn
	 on5RjskSECskokArDhUw0HONAbT5zOn9K//gSF4OUaaDfUyIlqxnMH8qdEfwksTG9Q5nZ
	 JTphX2rx+lsLaAxDfvuguqhxFMobikRpe6UysY0Ap6nfQ/+dZSmJmlKkJ/d/RyLGcdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=1MYlm62U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8900606A322;
	Tue, 27 Oct 2026 20:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=1MYlm62U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C1D71F031E2;
	Tue, 27 Oct 2026 20:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793131530;
	bh=fUz4b6QdP7dTUELIouxOFIGIJMCUt4wDA++rQwb+PSs=;
	h=Date:To:From:Subject;
	b=1MYlm62U+jDMbk2HVeeDbc92+8tkzLnLPPynB2hSuvfgyEqnBc3G9t8fNwcqcUTu4
	 cHTny/6o1F3+QbVk+YzbJedVcR4Z9sG0cp0kj5kBLqkcub9NOQHQhlM1pV0/A1YmiA
	 toMzLMuug/MIo4uhj3dp5ER2Li2bHZE0U4mGezLs=
Date: Tue, 27 Oct 2026 13:05:29 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,
	vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,
	shakeel.butt@linux.dev,rppt@kernel.org,osalvador@suse.de,mhocko@suse.com,
	hannes@cmpxchg.org,gourry@gourry.net,david@kernel.org,
	brendan.jackman@linux.dev,josef@toxicpanda.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-clear-private-of-deferred-free-pages.patch added to mm-unstable branch
Message-Id: <20261027200530.5C1D71F031E2@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/page_alloc: clear ->private of deferred free pages
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-clear-private-of-deferred-free-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-clear-private-of-deferred-free-pages.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Josef Bacik <josef@toxicpanda.com>
Subject: mm/page_alloc: clear ->private of deferred free pages
Date: Tue, 27 Oct 2026 16:46:28 +0100

free_pages_nolock() and free_frozen_pages_nolock() put the page on
zone->trylock_free_pages if they get neither the pcp lock nor zone->lock.
add_page_to_zone_llist() keeps the order of the page in page->private.
The next free_one_page() which does get zone->lock passes these pages to
split_large_buddy() with ->private still set.

__free_one_page() writes ->private of the head of the resulting free page
only. If the deferred page is merged with its lower buddy, it becomes a
tail of that free page and keeps the order in ->private.

All other free pages which are not the head of a buddy have a ->private
of zero, and since commit 819bfbd47e49 ("mm/page_alloc: remove
set_page_private() in prep_compound_tail()") the allocator relies on it.
When the stale page is allocated again as a tail of a larger page:

 - prep_compound_tail() hits VM_WARN_ON_ONCE(tail->private);
 - with the page checks enabled, __free_pages_prepare() reports
   "BUG: Bad page state", "nonzero private", and leaks the whole page;
 - without them the value is seen by whoever uses that page next, e.g. as
   folio->private of a folio which is split off a large folio.

Only pages of an order above zero are affected. Those can be freed
through _nolock() by the stack depot (order 2) and by SLUB (a new slab
which cannot be added to the partial list by kmalloc_nolock()).

Clear ->private when the page is taken off the list.

Link: https://lore.kernel.org/20261027-pgalloc-ai-hotfixes-v1-2-9c7d1aca801e@kernel.org
Fixes: 8c57b687e833 ("mm, bpf: Introduce free_pages_nolock()")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Assisted-by: LLM
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Gregory Price (Meta)" <gourry@gourry.net>
Cc: <stable@vger.kernel.org>
---

 mm/page_alloc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/page_alloc.c~mm-page_alloc-clear-private-of-deferred-free-pages
+++ a/mm/page_alloc.c
@@ -1562,6 +1562,8 @@ static void free_one_page(struct zone *z
 		llist_for_each_entry_safe(p, tmp, llnode, pcp_llist) {
 			unsigned int p_order = p->private;
 
+			/* It may end up as a tail of the merged free page. */
+			p->private = 0;
 			split_large_buddy(zone, p, page_to_pfn(p), p_order, fpi_flags);
 			__count_vm_events(PGFREE, 1 << p_order);
 		}
_

Patches currently in -mm which might be from josef@toxicpanda.com are

mm-page_alloc-dont-undo-a-racing-start_isolate_page_range.patch
mm-page_alloc-clear-private-of-deferred-free-pages.patch
mm-page_frag-refill-the-cache-for-large-fragments.patch
mm-page_alloc-keep-the-pagesets-of-an-empty-zone.patch
mm-page_alloc-pass-zone-pointer-to-trace_reclaim_retry_zone.patch
mm-compaction-trust-zone-contiguous-only-in-the-span.patch
mm-page_isolation-do-not-take-slab-pages-for-free.patch
mm-memory_hotplug-resize-zones-under-their-seqlock.patch
mm-page_alloc-check-pageblock-pfns-under-span-seqlock.patch

