Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793131541;
	b=RVBaIcDvLg0wNRp39Ek5sWu6JkjlhIlHDmVpdXCQ+95i7pCzh9GrM4hHrG6ddhAbM+xv
	 gblDJWoIVzaouucBY+3zkIc5m7IIpbmVIzq+qEldDoMCcTf1iJougwaNqalg7YOSpuDGJ
	 qy2wof8/DtVeTtKT9ZMo7/kjZoeaUKH3QSxtpo3TxNl8OW461CjB2fmggEONYDyALWpxO
	 0+79Z7+lACs824Qxt7Yl2UR3Flt2mfcH4zqWKMLTd4nCbsJrQSRRkTup9rtEiN995W1mq
	 tNJRP+XJzGQpJbIgutdcU0OY/dYO074cpoF1hA3KHMXNwxOwbXgf82aHiDcCnE8Ccrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793131541;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=Ni6rZXDKUU/HVbAcRThSmr5VLY6OruNGAORYRyf55LA=;
	b=1Q0tk4F/fTiRJujXA3usTt9o3saKOJlCmRp2uM6W5jiDVg47UXaSl0akGLiYx47Rgp6Z
	 8YUu7kTl6WgCg45Vr/5QFmkLNHR1F7W2jzYqbk8CcH82OmTKtf1lF4GxkeQBEzf+2I+MC
	 tELmYtixdt6R9rKS0oOLHrjn8NvWQcDtu0qKw7L/KOUfSyq05CTDOD2lh2x4zc1AkbyMJ
	 hhrR3QelTxj/BLgvv2XD4lTXjOgH98+js9SnDUWr5MeNVY8+G/49icyJUGf5pG5B/LDnl
	 6N0wxinWOkYIJVvqlP7kItRi1uUgQHEE6VG6k7BkDr7tga1fKPzWQngj9MPfOlWzu0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=fePsXDbH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59B12606A31A
	for <mm-commits@vger.kernel.org>; Tue, 27 Oct 2026 20:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=fePsXDbH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBD4E1F01825;
	Tue, 27 Oct 2026 20:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793131541;
	bh=Ni6rZXDKUU/HVbAcRThSmr5VLY6OruNGAORYRyf55LA=;
	h=Date:To:From:Subject;
	b=fePsXDbHsxLETceThFTt2hLTk3rTZqDhIqUhp+nH1sW/k/xr0QYg8R3v+DVhHOIRp
	 RCiiRiyTAVqJejMRW22ialkTScjf1eXfGlVeeVPnM4e+Ofov4my7eFq9/8uuO3ymZO
	 cvzz7VJHD+ZDvFZ10/tZA+rIHIdc+e1XXGhL+sCs=
Date: Tue, 27 Oct 2026 13:05:40 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,
	vbabka@kernel.org,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,
	osalvador@suse.de,mhocko@suse.com,hannes@cmpxchg.org,gourry@gourry.net,
	david@kernel.org,brendan.jackman@linux.dev,josef@toxicpanda.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_isolation-do-not-take-slab-pages-for-free.patch added to mm-unstable branch
Message-Id: <20261027200540.DBD4E1F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm: page_isolation: do not take slab pages for free
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_isolation-do-not-take-slab-pages-for-free.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_isolation-do-not-take-slab-pages-for-free.patch

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
Subject: mm: page_isolation: do not take slab pages for free
Date: Tue, 27 Oct 2026 16:46:33 +0100

page_is_unmovable() regards a page with a reference count of zero as free
or about to be freed. Since slab allocates frozen pages, they will
be wrongly considered to be freed if order 0 (higher-order compound
pages are caught earlier).

If such slabs are the only unmovable pages of a memory block, memory
offlining now isolates the block, this can lead to offline_pages()
looping without progress.

Thus detect the slab pages as removable to return -EBUSY, as would
happen before commit 9aec2fb0fd5e ("slab: allocate frozen pages").

Link: https://lore.kernel.org/20261027-pgalloc-ai-hotfixes-v1-7-9c7d1aca801e@kernel.org
Fixes: 9aec2fb0fd5e ("slab: allocate frozen pages")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: LLM
Cc: Zi Yan <ziy@nvidia.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Gregory Price (Meta)" <gourry@gourry.net>
---

 mm/memory_hotplug.c |    7 +++++++
 mm/page_isolation.c |    7 +++++++
 2 files changed, 14 insertions(+)

--- a/mm/memory_hotplug.c~mm-page_isolation-do-not-take-slab-pages-for-free
+++ a/mm/memory_hotplug.c
@@ -1847,6 +1847,13 @@ static int scan_movable_pages(unsigned l
 		if (PageOffline(page) && page_count(page))
 			return -EBUSY;
 
+		/*
+		 * A page that was allocated, but was not a slab page yet, when
+		 * its pageblock was isolated.
+		 */
+		if (PageSlab(page))
+			return -EBUSY;
+
 		folio = page_folio(page);
 		if (!folio_test_hugetlb(folio))
 			continue;
--- a/mm/page_isolation.c~mm-page_isolation-do-not-take-slab-pages-for-free
+++ a/mm/page_isolation.c
@@ -75,6 +75,13 @@ bool page_is_unmovable(struct zone *zone
 	}
 
 	/*
+	 * Slab pages are frozen: do not take their reference count of zero
+	 * for that of a free page.
+	 */
+	if (PageSlab(page))
+		return true;
+
+	/*
 	 * We can't use page_count without pin a page
 	 * because another CPU can free compound page.
 	 * This check already skips compound tails of THP
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

