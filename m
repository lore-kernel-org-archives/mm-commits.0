Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BE2F372679
	for <mm-commits@vger.kernel.org>; Tue,  3 Mar 2026 18:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772564286; cv=none; b=g+LGeiIX2BCHrKXE0DkYNGqN1xfEvZ8TbBhg5fMV1QQBQRX8AZFZnJC1iiotEuVxaQ60IttrG6v2DdQhd+m2XIZf7i83Hl+Y3jl8JEM+n/o6SoNxelSUFCZp+Yz58X2xqylmYXB6wf6IwtS5m2G3yM3Qs8OzPBBl/y0CSGLUR9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772564286; c=relaxed/simple;
	bh=JWhUzpA9PVqVIwNMQKTaR4I2R2xMJCahGvi4sZAib9I=;
	h=Date:To:From:Subject:Message-Id; b=DtPHnCma53tJFqu6X8306CoSSMvw9uCbydfdBwAIBCqzUvsof2iI65Ws0Z2Swu4Klku90W6YPEcX3gcJR3b1u9qfEBniNcSGoWb9dmy9wr8Jakn74ybaslDI2yst+oWB2+vzx3VN/WsLXLXDKxxBK08x14IPXQtqkuAp3cjlzfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=keGDEFh/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="keGDEFh/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA1A6C116C6;
	Tue,  3 Mar 2026 18:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772564285;
	bh=JWhUzpA9PVqVIwNMQKTaR4I2R2xMJCahGvi4sZAib9I=;
	h=Date:To:From:Subject:From;
	b=keGDEFh/usw06fRw1AbAcQ2RN/ehaN5EPMqMlwr7Xnb44fsdloZOx4q+SAe5P/u8i
	 0rmLXQ6k9g2IU/Mf/buMxB9Ef1aMDGCXIiAbhG6itii97pocefh/2PEC0dz9Qt6hOc
	 zdsloDCBcLxOb8I5v52yn01qpfmoNWXyo5954ef8=
Date: Tue, 03 Mar 2026 10:58:05 -0800
To: mm-commits@vger.kernel.org,d@ilvokhin.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rename-zone-lock-to-zone-_lock-fix-2.patch added to mm-new branch
Message-Id: <20260303185805.BA1A6C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fix remaining zone->lock references
has been added to the -mm mm-new branch.  Its filename is
     mm-rename-zone-lock-to-zone-_lock-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rename-zone-lock-to-zone-_lock-fix-2.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
mm-rename-zone-lock-to-zone-_lock-fix-2.patch
mm-add-tracepoints-for-zone-lock.patch

