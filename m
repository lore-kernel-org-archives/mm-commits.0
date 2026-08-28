Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0AAC3AE6F7;
	Fri, 28 Aug 2026 03:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787889060; cv=none; b=KWyXbFCpty4t7Xe7QYsNv4RMrpKXqntTwfvYmOWtqTv6KN0YA6bzALA1tGMy5jM1e2j/VyjM0ki/avMc566FZ0X/tUMXOfYeptpF0RY1GTNYRD+sKHJ/NFwF6qSYxel9F60BANa76UObso3Er+3V6fZoqxVioc1O1co9ZohEo9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787889060; c=relaxed/simple;
	bh=1qLgqFxAmCUbe58m9sHkYvmcOCBX8XXyppZFNl0q17c=;
	h=Date:To:From:Subject:Message-Id; b=QvNDerRmyM0vytBOr9+XQkEiXHO3l5Su2Lkub6nMqdkvFIRAgGasJi2q2xqSxelmwR3F+YAVl7EjLBn3XMxIalJZ4oybqVs2J+UKMF1E3ZpbguQ8EmPOR5nlIDNs+uTe+5kypf/ty2gAf5HtC/a3tXc5VWIP3eP2AZPWL7dqxlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=v6o+Dxiv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="v6o+Dxiv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26B0D1F0155E;
	Fri, 28 Aug 2026 03:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787889055;
	bh=8VE821sW4xntuy7PQRLoeETBrKOEKo4J4/TYqGCN+mQ=;
	h=Date:To:From:Subject;
	b=v6o+DxivGc48LRFCRaH8Pp73IFlLX8XSfToEegyHj0OqiiY2LnLRPnlicDEZSUPnC
	 Qzdq1Fa7reI/CGH8a+6J/wSTp5Ubke3LNi4uuYOqTfoB9O3fcabye65gny7HAefw0Y
	 PQUq2fVTP4MLeQQli/ND2TUrUXWwf+Nv8VFQv9os=
Date: Thu, 27 Aug 2026 20:50:54 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,wangkefeng.wang@huawei.com,vbabka@kernel.org,surenb@google.com,sunnanyong@huawei.com,stable@vger.kernel.org,mhocko@suse.com,hannes@cmpxchg.org,brendan.jackman@linux.dev,xiqi2@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_isolation-fix-ubsan-shift-out-of-bounds-warning.patch added to mm-new branch
Message-Id: <20260828035055.26B0D1F0155E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_isolation: fix UBSAN shift-out-of-bounds warning
has been added to the -mm mm-new branch.  Its filename is
     mm-page_isolation-fix-ubsan-shift-out-of-bounds-warning.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_isolation-fix-ubsan-shift-out-of-bounds-warning.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Qi Xi <xiqi2@huawei.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

mm-drop-stale-max_order-references.patch
mm-page_isolation-fix-ubsan-shift-out-of-bounds-warning.patch
mm-page_isolation-guard-compound_order-against-racing.patch

