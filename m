Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25E753AA4E4
	for <mm-commits@vger.kernel.org>; Tue, 14 Jul 2026 03:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783998661; cv=none; b=ur6/ALxekJE9dYdNEqNF5EN91eJeSyf00PR0ET6KLmxO/VvbEmBtbN0DMqQ3xVHhkbRlT2+0yvxYMcnZFjwozKBVC23FI0sqfD0IRvUptUbaAJO/LVRhMJ1vzLHADS8OBtLoOa3JkE0hQA5RRqdcdh9tzWEIBfpWMMQ9TU+1+ZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783998661; c=relaxed/simple;
	bh=zxVcoU+C+u8qoRjpMYN1No5lps9vfVipkFE15nKPMSI=;
	h=Date:To:From:Subject:Message-Id; b=uA10WyLeQ65/KEaU8gltd8Zq9xU4UvLydCkBVtiinxEwWi0zCItGWwt34mVy0Qz2tE25z2tiHa3BEuCggj/v7OiBCefIUUsnm02Cw2RBZGH3ZcABPhfpTHhRrVLHFSEqbzeGvwVg7kTBDQojiJ6cvjamnqV39jB43eTDlcmxe8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ENcFsfJF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ENcFsfJF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB1801F00A3A;
	Tue, 14 Jul 2026 03:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783998659;
	bh=ZyguKfomASyshT80deGcJIV5qpIbhtxbcOXoYvQ87wY=;
	h=Date:To:From:Subject;
	b=ENcFsfJFYJK8RkeSYUeSCdN6/l2RUUgpr7RLv0XGHI5Tm6IlNl5s8/KVYcLAoyg6o
	 OWNkXtnGP4wTrGjPKHraR8K0SR4W66I+g5j2cq3FOWPXBNlsX+LsxyTVoO1cxeYGjG
	 LGgKoLtSWJ3mGtSx728zcsHPcUJsmBmA3BPhR14g=
Date: Mon, 13 Jul 2026 20:10:59 -0700
To: mm-commits@vger.kernel.org,ye.liu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-page_owner-clamp-skip_buddy_pages-pfn-advance-at-max_order_nr_pages-boundary.patch removed from -mm tree
Message-Id: <20260714031059.AB1801F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_owner: clamp skip_buddy_pages() PFN advance at MAX_ORDER_NR_PAGES boundary
has been removed from the -mm tree.  Its filename was
     mm-page_owner-clamp-skip_buddy_pages-pfn-advance-at-max_order_nr_pages-boundary.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Ye Liu <ye.liu@linux.dev>
Subject: mm/page_owner: clamp skip_buddy_pages() PFN advance at MAX_ORDER_NR_PAGES boundary
Date: Wed, 1 Jul 2026 14:10:51 +0800

The lockless buddy_order_unsafe() read can return a garbage order value if
the page is concurrently allocated between the PageBuddy check and the
private read.  If this bogus order is <= MAX_PAGE_ORDER,
skip_buddy_pages() would arbitrarily advance the PFN, potentially jumping
past a MAX_ORDER_NR_PAGES boundary whose pfn_valid() check would have
caught an offline memory section.

In read_page_owner(), which relies solely on boundary-aligned pfn_valid()
to guard pfn_to_page(), skipping the boundary could cause pfn_to_page() to
access an unmapped mem_section.

Clamp the advance so it never crosses the next MAX_ORDER_NR_PAGES
boundary.  This is safe for all three callers: the pageblock-iterating
ones already handle boundary transitions in their outer loops, and for
read_page_owner() the worst case is one extra PageBuddy check per 1024
pages for a huge buddy block straddling the boundary.

Link: https://lore.kernel.org/20260701061101.344679-9-ye.liu@linux.dev
Signed-off-by: Ye Liu <ye.liu@linux.dev>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/mm/page_owner.c~mm-page_owner-clamp-skip_buddy_pages-pfn-advance-at-max_order_nr_pages-boundary
+++ a/mm/page_owner.c
@@ -428,6 +428,12 @@ void __folio_copy_owner(struct folio *ne
  * to skip less than the full buddy block, but that is acceptable for page owner
  * iteration purposes.
  *
+ * The lockless read of buddy_order_unsafe() can also return a garbage order if
+ * the page is concurrently allocated and PageBuddy is cleared between the check
+ * and the read. Clamp the advance at the next MAX_ORDER_NR_PAGES boundary so
+ * that a bogus order cannot carry @pfn into an unvalidated memory section,
+ * which would break callers that rely on boundary-aligned pfn_valid() checks.
+ *
  * Return: true if the page was skipped (caller should continue its loop),
  *         false if the page is not a buddy page and should be processed normally.
  */
@@ -439,8 +445,12 @@ static inline bool skip_buddy_pages(unsi
 		return false;
 
 	order = buddy_order_unsafe(page);
-	if (order <= MAX_PAGE_ORDER)
-		*pfn += (1UL << order) - 1;
+	if (order <= MAX_PAGE_ORDER) {
+		unsigned long new_pfn = *pfn + (1UL << order);
+		unsigned long boundary = ALIGN(*pfn + 1, MAX_ORDER_NR_PAGES);
+
+		*pfn = min(new_pfn, boundary) - 1;
+	}
 
 	return true;
 }
_

Patches currently in -mm which might be from ye.liu@linux.dev are

mm-page_owner-use-memcg_data-snapshot-instead-of-pagememcgkmem-to-avoid-toctou-vm_bug_on.patch

