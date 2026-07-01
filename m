Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18FAA31F9A3
	for <mm-commits@vger.kernel.org>; Wed,  1 Jul 2026 03:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782876979; cv=none; b=OJUQKCIHj7l3vt52FxSzKFLoNedyNJkjJtNcERpZ/q5Ca1hfHrYx35cGiqFUKtIa9f2wpUEPVN8On0wVoFfMtSthZRwBtwVPj8Kj3F9h15yXAXk7kqoSil3WRY6hYnYSM727pvMvuQ+vfrd6NFEKPgzucndP7UQMvIU3itoVP/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782876979; c=relaxed/simple;
	bh=v6jnyp17+lsHjGEtDMxPxfS+uMb8zWp0YHAXlAkFoq8=;
	h=Date:To:From:Subject:Message-Id; b=e+f59G5mL7O8zsQMLTETmiOKlBU2kCk4JRB92z9ARp2qYQFxNhzeRzSKHscz6Kq9mM7P2TQahbZsN+z7TzR3liw1oZmV8zrvQVPA5t9eJlo3x7FAbJqi02I0kpWsLi9fO2J5P8f+fZlsSyFSvxRFCHVqLtSRtV4hKmeIbKoh/so=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EEUWm043; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EEUWm043"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A35AF1F000E9;
	Wed,  1 Jul 2026 03:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782876977;
	bh=pVQidCBuwsbwFhzE59MkfV+u7A8YApgLk4BnnNXMVMc=;
	h=Date:To:From:Subject;
	b=EEUWm043vyjjPX7MVHZsPNnZXDjkMO7kLYPpqYJr31dUXswKsBN+w2LLcnJSK1RrI
	 qumv5PVV4aRWVTTb6F1sPuVu1TiOkC5hMktSXEmFBqG+KZ5vXwyY1AX1F2Ho34Djug
	 VA6yTB76qcB31mVVVVvh3YMR+bpNsIEzrf39QhxA=
Date: Tue, 30 Jun 2026 20:36:17 -0700
To: mm-commits@vger.kernel.org,ye.liu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-page_owner-clamp-skip_buddy_pages-pfn-advance-at-max_order_nr_pages-boundary.patch removed from -mm tree
Message-Id: <20260701033617.A35AF1F000E9@smtp.kernel.org>
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
Date: Thu, 25 Jun 2026 09:47:04 +0800

Patch series "mm/page_owner: fix TOCTOU races in lockless page state
reading".

Fix two TOCTOU races found during review of [1].

page_owner reads page state locklessly by design.  In two places the code
reads the same metadata twice once as a guard, then again as a use and the
page can be concurrently reallocated between the two:

Patch 1: buddy_order_unsafe() in skip_buddy_pages() can return garbage if
the page is allocated between PageBuddy() and the private read, causing
the PFN to skip past a pfn_valid() boundary.  Clamp the advance at
MAX_ORDER_NR_PAGES.

Patch 2: PageMemcgKmem() in print_page_owner_memcg() re-reads
folio->memcg_data and triggers VM_BUG_ON assertions if the page became a
tail page or slab page.  Use the snapshot taken at entry.


This patch (of 2):

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

Link: https://lore.kernel.org/20260625014708.87386-1-ye.liu@linux.dev
Link: https://lore.kernel.org/20260625014708.87386-2-ye.liu@linux.dev
Link: https://lore.kernel.org/all/20260623065234.31866-2-ye.liu@linux.dev/ [1]
Link: https://sashiko.dev/#/patchset/20260623065234.31866-2-ye.liu@linux.dev
Signed-off-by: Ye Liu <ye.liu@linux.dev>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
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

a.patch
mm-page_owner-use-memcg_data-snapshot-instead-of-pagememcgkmem-to-avoid-toctou-vm_bug_on.patch

