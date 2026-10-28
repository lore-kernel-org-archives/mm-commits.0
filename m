Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793156799;
	b=wWp3BtyS9qy2YXInqv77QlDmGY+UnM/C1Cg9VUnm2l25dfNAxn0bENREmvUex3AqGnbP
	 rjm/XuZVQG3o//QwUzFkE05dk6JOKFGe0oStVYvwdkIDxMxWCS8TXsyPFMTdeqR371MtF
	 UgkLYtRb/I4l0DvpuYGoyMXHxOGm2WeGWD7Qq1vpk3lChf/Q6NSXenln5CwPimBt/1p3y
	 6MVbQQqULOz8sgLZHEbHCOtBdg5oYq3KRjwuNHdEJ8m2Qb7xGKkAjzhnyeEyPuEP7nwtN
	 ZWXnpqfXqwuNcl3c8oOrsmypfZ1Lkyk7NsRsArlFpOF1Bjfh0TChQ6FydVZDPzARFLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793156799;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=kVnaC10tv9ehFowLPicIfzdH7RwM8XZZuteDnD3VJJY=;
	b=vk5JkgDUMippD1SqWSHHqACYjiDAND/gIiB5hoU13Dsp5Nl/C9KCsDbdFNeLuV9Y7cct
	 XhcLoK24VE5WQ0iKGoppQF2h7nbTUZdIEgaBMU6u4ZFKX3S6+JI98vNI0AfmpkP4fw9Mu
	 ZGPRi8EQeeKwoyuysJNrLAhJw2gTeXCbK/P42mdo411MmuJo5MAzPSAq2+f/M2GkRXYaN
	 RLuSqXMgvMSoIrTiRrj/6u56RfT6YTO/5QE0s3brojueEGk+r4iVHduShGyhAM7STnZdW
	 GLI9R8UwDP6emqWMgtXsIp4eK/hZU8y3LB852JhSlxfOSRmnjJJq5P/Gv4ANPfZLHZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=tywmEMBf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24BE0606A31A
	for <mm-commits@vger.kernel.org>; Wed, 28 Oct 2026 03:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=tywmEMBf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AA8B1F01828;
	Wed, 28 Oct 2026 03:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793156798;
	bh=kVnaC10tv9ehFowLPicIfzdH7RwM8XZZuteDnD3VJJY=;
	h=Date:To:From:Subject;
	b=tywmEMBfKKZQvFhhEH/bhC3pL8g86XedSLPpf5UQSf36wpbtTaPWW++pzxinqZ0uf
	 0GitjRG4WMdlmp7tjciVHAKX4HHM47IBaHFOdumhPAe74/7I8FYIcMKEL458Dt+4HH
	 5NYYw2xlXbJ5Jd/EF1eon+LP9iQGMOGkrD1yzXzs=
Date: Tue, 27 Oct 2026 20:06:38 -0700
To: mm-commits@vger.kernel.org,josef@toxicpanda.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-page_alloc-clear-private-of-deferred-free-pages.patch removed from -mm tree
Message-Id: <20261028030638.9AA8B1F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/page_alloc: clear ->private of deferred free pages
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-clear-private-of-deferred-free-pages.patch

This patch was dropped because an updated version will be issued

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

mm-page_frag-refill-the-cache-for-large-fragments.patch
mm-page_alloc-keep-the-pagesets-of-an-empty-zone.patch
mm-page_alloc-pass-zone-pointer-to-trace_reclaim_retry_zone.patch
mm-compaction-trust-zone-contiguous-only-in-the-span.patch
mm-page_isolation-do-not-take-slab-pages-for-free.patch
mm-memory_hotplug-resize-zones-under-their-seqlock.patch
mm-page_alloc-check-pageblock-pfns-under-span-seqlock.patch
mm-filemap-dont-lose-a-folio-lock-wakeup-to-a-signal.patch

