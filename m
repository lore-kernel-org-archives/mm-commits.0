Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A67133E2757
	for <mm-commits@vger.kernel.org>; Wed, 25 Mar 2026 14:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774450040; cv=none; b=gSWlq3ESLZi2Do+xZG5pqtLlqZ71QsRNRdvNrK/KOqvz4OZ2W+bVvhJ6gPgmkmSzAPeEef0za+f+yo7zzzyYkwnIyj2006HB4hoslxoGX7CGrGqHNmROjYjnzThSdm/GTe33jKrq9x8EbfpO9oOExZUZli4qyk+6IztV+yKDTrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774450040; c=relaxed/simple;
	bh=jJxD/1/IwFUWTghhzBCxHYMjzDQOYv2/AOD1FDPebYk=;
	h=Date:To:From:Subject:Message-Id; b=j70XoGB+FmJpOlae85J85dk1bC0n9QhaT9GcYefG3XsRNOrXC0S7dXV/IFLQrk8tu8KJGgKJYjTZ8jtR5p49xeG2HDq3byF3Mxdeo03cVVscuGhRutHHYMBt87IhHjgYCu//GjTLNOoGCmlekjNKucFwpXQabgKdl492wJmClxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fxf7vPFT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fxf7vPFT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53608C4CEF7;
	Wed, 25 Mar 2026 14:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774450040;
	bh=jJxD/1/IwFUWTghhzBCxHYMjzDQOYv2/AOD1FDPebYk=;
	h=Date:To:From:Subject:From;
	b=fxf7vPFTv+3Y5vHtqAyJC9h8qdi57xhAeiQ09soeyJreAq3EigH+YX5BG2KXu/IlT
	 9lOikH25W+UMuW2fFs7C/YjHlGFY8m/rTGJHoAWTwAzc1Yv91gtISk25eEg7LeeJdQ
	 YhqTkdTLWsREQqdLbdvBpLkVR46ed0SIUpAp5u+8=
Date: Wed, 25 Mar 2026 07:47:19 -0700
To: mm-commits@vger.kernel.org,d@ilvokhin.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-rename-zone-lock-to-zone-_lock-fix-2.patch removed from -mm tree
Message-Id: <20260325144720.53608C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fix remaining zone->lock references
has been removed from the -mm tree.  Its filename was
     mm-rename-zone-lock-to-zone-_lock-fix-2.patch

This patch was dropped because it was folded into mm-rename-zone-lock-to-zone-_lock.patch

------------------------------------------------------
From: Dmitry Ilvokhin <d@ilvokhin.com>
Subject: mm: fix remaining zone->lock references
Date: Tue, 3 Mar 2026 06:13:13 -0800

Link: https://lkml.kernel.org/r/aabvc4Xhc9qBfaG7@shell.ilvokhin.com
Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/physical_memory.rst |    4 ++--
 Documentation/trace/events-kmem.rst  |    8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/Documentation/mm/physical_memory.rst~mm-rename-zone-lock-to-zone-_lock-fix-2
+++ a/Documentation/mm/physical_memory.rst
@@ -500,11 +500,11 @@ General
 ``nr_isolate_pageblock``
   Number of isolated pageblocks. It is used to solve incorrect freepage counting
   problem due to racy retrieving migratetype of pageblock. Protected by
-  ``zone->lock``. Defined only when ``CONFIG_MEMORY_ISOLATION`` is enabled.
+  ``zone_lock``. Defined only when ``CONFIG_MEMORY_ISOLATION`` is enabled.
 
 ``span_seqlock``
   The seqlock to protect ``zone_start_pfn`` and ``spanned_pages``. It is a
-  seqlock because it has to be read outside of ``zone->lock``, and it is done in
+  seqlock because it has to be read outside of ``zone_lock``, and it is done in
   the main allocator path. However, the seqlock is written quite infrequently.
   Defined only when ``CONFIG_MEMORY_HOTPLUG`` is enabled.
 
--- a/Documentation/trace/events-kmem.rst~mm-rename-zone-lock-to-zone-_lock-fix-2
+++ a/Documentation/trace/events-kmem.rst
@@ -57,7 +57,7 @@ the per-CPU allocator (high performance)
 
 If pages are allocated directly from the buddy allocator, the
 mm_page_alloc_zone_locked event is triggered. This event is important as high
-amounts of activity imply high activity on the zone->lock. Taking this lock
+amounts of activity imply high activity on the zone_lock. Taking this lock
 impairs performance by disabling interrupts, dirtying cache lines between
 CPUs and serialising many CPUs.
 
@@ -79,11 +79,11 @@ contention on the lruvec->lru_lock.
   mm_page_pcpu_drain		page=%p pfn=%lu order=%d cpu=%d migratetype=%d
 
 In front of the page allocator is a per-cpu page allocator. It exists only
-for order-0 pages, reduces contention on the zone->lock and reduces the
+for order-0 pages, reduces contention on the zone_lock and reduces the
 amount of writing on struct page.
 
 When a per-CPU list is empty or pages of the wrong type are allocated,
-the zone->lock will be taken once and the per-CPU list refilled. The event
+the zone_lock will be taken once and the per-CPU list refilled. The event
 triggered is mm_page_alloc_zone_locked for each page allocated with the
 event indicating whether it is for a percpu_refill or not.
 
@@ -92,7 +92,7 @@ which triggers a mm_page_pcpu_drain even
 
 The individual nature of the events is so that pages can be tracked
 between allocation and freeing. A number of drain or refill pages that occur
-consecutively imply the zone->lock being taken once. Large amounts of per-CPU
+consecutively imply the zone_lock being taken once. Large amounts of per-CPU
 refills and drains could imply an imbalance between CPUs where too much work
 is being concentrated in one place. It could also indicate that the per-CPU
 lists should be a larger size. Finally, large amounts of refills on one CPU
_

Patches currently in -mm which might be from d@ilvokhin.com are

mm-introduce-zone-lock-wrappers.patch
mm-convert-zone-lock-users-to-wrappers.patch
mm-convert-compaction-to-zone-lock-wrappers.patch
mm-rename-zone-lock-to-zone-_lock.patch
mm-rename-zone-lock-to-zone-_lock-fix-3.patch
mm-add-tracepoints-for-zone-lock.patch

