Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 427943BB57;
	Wed,  7 Oct 2026 00:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334144; cv=none; b=OF7Q7RWlC21lo07sQ23W4c/AZwQ5NnF3PzJJ7rhZe4Wr1lNqMrZIqUMt3ZnQNbtQHpf7nETEs7V3xf0xzs9T6LGcbkiq9aVK01GSeVlt0VGAdomd062ShW/dN4TRhR/WFybypotY6keViu1ovIFeqwuviZ1oDGZeee6IsuIJ8II=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334144; c=relaxed/simple;
	bh=9hjiFLoLynwQ886H4AQKCIxGnWx6TpqmEN7UX+oqoq8=;
	h=Date:To:From:Subject:Message-Id; b=BkVVzVdCLW6me3SjtpCCMKCX+ZWUJsHnk1BG/2ux0FgkFZkvHHmV9oyQx2Io9XI7SyTrY1rnMl3xQjsULW3fhz7f6iiZzTCy11naTgfLBTrqzVkqNIHhXUI9GtZXJiSgjq36ZLkuZ9UqSUSUzMhSgoyvMMWLVqcNUU4zl9XPbrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WC3YnzpB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WC3YnzpB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 189FC1F0089B;
	Wed,  7 Oct 2026 00:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334143;
	bh=K9ygnlclfbXW9Ic09yMd1o+JTRv1zxbLOyLkRXKK/HU=;
	h=Date:To:From:Subject;
	b=WC3YnzpBBxiAixapsUmZL5O5sQtMdQVkCvea45+FLwNGSbXBq6scmwHTeOzj6aMLC
	 QUY0nx8Rf7GUrMUwwmhTmwHR+KheFTHquXfSTeKjfnbVUrTNzIJqPpKy45ZafGRox8
	 jBF6jiPozMk/Aru5GJiT7tGXIiWDESEZbbGXMEWs=
Date: Tue, 06 Oct 2026 17:49:02 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,wangkefeng.wang@huawei.com,vbabka@kernel.org,surenb@google.com,sunnanyong@huawei.com,stable@vger.kernel.org,mhocko@suse.com,hannes@cmpxchg.org,brendan.jackman@linux.dev,xiqi2@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_isolation-fix-ubsan-shift-out-of-bounds-warning.patch removed from -mm tree
Message-Id: <20261007004903.189FC1F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_isolation: fix UBSAN shift-out-of-bounds warning
has been removed from the -mm tree.  Its filename was
     mm-page_isolation-fix-ubsan-shift-out-of-bounds-warning.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Xi <xiqi2@huawei.com>
Subject: mm/page_isolation: fix UBSAN shift-out-of-bounds warning
Date: Tue, 25 Aug 2026 20:05:48 +0800

Patch series "mm/page_isolation: fix UBSAN shift-out-of-bounds in
isolate_single_pageblock", v3.

Patch 1 fixes a UBSAN shift-out-of-bounds warning in the PageBuddy branch
of isolate_single_pageblock() triggered by concurrent buddy allocation.

Patch 2 addresses the same class of issue in the PageCompound branch,
where racy compound_order() and compound_head() reads could lead to
out-of-range shifts or incorrect page skipping.


This patch (of 2):

A contig-range allocation racing with buddy allocation on the adjacent
pageblock can trigger:

 UBSAN: shift-out-of-bounds in mm/page_isolation.c:393:15
 shift exponent -749042176 is negative
 Call trace:
  isolate_single_pageblock
  start_isolate_page_range
  alloc_contig_frozen_range_noprof
  alloc_contig_range_noprof

isolate_single_pageblock() first calls set_migratetype_isolate() with
zone->lock held, which marks the pageblock MIGRATE_ISOLATE and moves any
free page straddling the boundary out of the way.  Once the lock is
dropped, it scans the MAX_ORDER_NR_PAGES-aligned window [start_pfn,
boundary_pfn) locklessly, only to skip the free pages already handled
above and to detect in-use pages straddling the boundary.  Since this
scan only reads page state to decide how far to skip and returns -EBUSY
on a straddling in-use page, it does not take the lock.

The window also covers the adjacent pageblock, whose free pages stay on
the normal movable/CMA freelist and can be allocated concurrently.  So
after the scan observes PageBuddy(page), another CPU can allocate the
page, leaving a stale value in page->private that makes "1 << order" shift
out of range.

Use buddy_order_unsafe() with READ_ONCE to read the order, and validate
it is within MAX_PAGE_ORDER before shifting to prevent UBSAN warnings.

Since pageblock_isolate_and_move_free_pages() already handles free pages
straddling boundary_pfn under zone->lock, bail out with -EBUSY instead
of VM_WARN_ON_ONCE() when a PageBuddy page appears to cross the boundary
during the lockless scan.

Link: https://lore.kernel.org/20260825120549.966271-2-xiqi2@huawei.com
Fixes: b2c9e2fbba32 ("mm: make alloc_contig_range work at pageblock granularity")
Signed-off-by: Qi Xi <xiqi2@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: <stable@vger.kernel.org>
---

 mm/page_isolation.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

--- a/mm/page_isolation.c~mm-page_isolation-fix-ubsan-shift-out-of-bounds-warning
+++ a/mm/page_isolation.c
@@ -388,13 +388,19 @@ static int isolate_single_pageblock(unsi
 		}
 
 		if (PageBuddy(page)) {
-			int order = buddy_order(page);
+			unsigned int order = buddy_order_unsafe(page);
 
-			/* pageblock_isolate_and_move_free_pages() handled this */
-			VM_WARN_ON_ONCE(pfn + (1 << order) > boundary_pfn);
-
-			pfn += 1UL << order;
-			continue;
+			/* buddy_order_unsafe() is racy. Validate the order before shifting. */
+			if (order <= MAX_PAGE_ORDER &&
+				/*
+				 * pageblock_isolate_and_move_free_pages() splits
+				 * cross-boundary PageBuddy, verify it.
+				 */
+			    pfn + (1UL << order) <= boundary_pfn) {
+				pfn += 1UL << order;
+				continue;
+			}
+			goto failed;
 		}
 
 		/*
_

Patches currently in -mm which might be from xiqi2@huawei.com are


