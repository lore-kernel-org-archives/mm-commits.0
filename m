Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8671812E6D
	for <mm-commits@vger.kernel.org>; Thu, 30 May 2024 19:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717098148; cv=none; b=QAsJrVQw2s3n77zFi/A4DqsTyym0v0a7cpn0LoGDmDAaRvdI1x65MuaQjFrclDXWLDrdS8pTBc2yolagOyY4g6vW00bmmCwH1UamSUCj1bHVjUbEropTchS6XuE07XX22DD650FYt4ar32Z1pLHQWgcy3Qa4v5h/pkbF/8wJUwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717098148; c=relaxed/simple;
	bh=YdpLlJD6J0dkRCG/8r+PzliMx/qEVufdRX8evd2MdLI=;
	h=Date:To:From:Subject:Message-Id; b=hWRMw7nQvcapOMGFc/ctWr0Ch1a1NraI7kzf6si4WsFXV2bhtI/3DzgwuVTe5CdFh4dfoFm/OaAiaPoQFOCULLl+ujvKrL6KNV7BESoJGY36wncmoL2f4ZX9EMIN01mgfYBfADrqpULF/AdBMSaZRi8QkWJTD/m1efxsU8A2u0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zd31lm4b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zd31lm4b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36D37C2BBFC;
	Thu, 30 May 2024 19:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717098148;
	bh=YdpLlJD6J0dkRCG/8r+PzliMx/qEVufdRX8evd2MdLI=;
	h=Date:To:From:Subject:From;
	b=zd31lm4bHK6CR9DGe39vjJHIDc9loRbrkZxZSOhXQKky63DbOjjuLPplQxtT1cM9Z
	 xvAL2koXZSncHSkxNakbBLrLaH+EF9p0AqYY565AWaFgNCxxJKxDrD7+5WGZmdx1Gg
	 rBCHwyE5uAddm177j3GxaUkewPzPYVVtlTBuVC+o=
Date: Thu, 30 May 2024 12:42:27 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,mgorman@techsingularity.net,hch@infradead.org,baolin.wang@linux.alibaba.com,andriy.shevchenko@linux.intel.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-fix-highatomic-typing-in-multi-block-buddies.patch added to mm-hotfixes-unstable branch
Message-Id: <20240530194228.36D37C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: page_alloc: fix highatomic typing in multi-block buddies
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-page_alloc-fix-highatomic-typing-in-multi-block-buddies.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-fix-highatomic-typing-in-multi-block-buddies.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: page_alloc: fix highatomic typing in multi-block buddies
Date: Wed, 29 May 2024 18:18:12 -0400

Christoph reports a page allocator splat triggered by xfstests:

generic/176 214s ... [ 1204.507931] run fstests generic/176 at 2024-05-27 12:52:30
XFS (nvme0n1): Mounting V5 Filesystem cd936307-415f-48a3-b99d-a2d52ae1f273
XFS (nvme0n1): Ending clean mount
XFS (nvme1n1): Mounting V5 Filesystem ab3ee1a4-af62-4934-9a6a-6c2fde321850
XFS (nvme1n1): Ending clean mount
XFS (nvme1n1): Unmounting Filesystem ab3ee1a4-af62-4934-9a6a-6c2fde321850
XFS (nvme1n1): Mounting V5 Filesystem 7099b02d-9c58-4d1d-be1d-2cc472d12cd9
XFS (nvme1n1): Ending clean mount
------------[ cut here ]------------
page type is 3, passed migratetype is 1 (nr=512)
WARNING: CPU: 0 PID: 509870 at mm/page_alloc.c:645 expand+0x1c5/0x1f0
Modules linked in: i2c_i801 crc32_pclmul i2c_smbus [last unloaded: scsi_debug]
CPU: 0 PID: 509870 Comm: xfs_io Not tainted 6.10.0-rc1+ #2437
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:expand+0x1c5/0x1f0
Code: 05 16 70 bf 02 01 e8 ca fc ff ff 8b 54 24 34 44 89 e1 48 c7 c7 80 a2 28 83 48 89 c6 b8 01 00 3
RSP: 0018:ffffc90003b2b968 EFLAGS: 00010082
RAX: 0000000000000000 RBX: ffffffff83fa9480 RCX: 0000000000000000
RDX: 0000000000000005 RSI: 0000000000000027 RDI: 00000000ffffffff
RBP: 00000000001f2600 R08: 00000000fffeffff R09: 0000000000000001
R10: 0000000000000000 R11: ffffffff83676200 R12: 0000000000000009
R13: 0000000000000200 R14: 0000000000000001 R15: ffffea0007c98000
FS:  00007f72ca3d5780(0000) GS:ffff8881f9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f72ca1fff38 CR3: 00000001aa0c6002 CR4: 0000000000770ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff07f0 DR7: 0000000000000400
PKRU: 55555554
Call Trace:
 <TASK>
 ? __warn+0x7b/0x120
 ? expand+0x1c5/0x1f0
 ? report_bug+0x191/0x1c0
 ? handle_bug+0x3c/0x80
 ? exc_invalid_op+0x17/0x70
 ? asm_exc_invalid_op+0x1a/0x20
 ? expand+0x1c5/0x1f0
 ? expand+0x1c5/0x1f0
 __rmqueue_pcplist+0x3a9/0x730
 get_page_from_freelist+0x7a0/0xf00
 __alloc_pages_noprof+0x153/0x2e0
 __folio_alloc_noprof+0x10/0xa0
 __filemap_get_folio+0x16b/0x370
 iomap_write_begin+0x496/0x680

While trying to service a movable allocation (page type 1), the page
allocator runs into a two-pageblock buddy on the movable freelist whose
second block is typed as highatomic (page type 3).

This inconsistency is caused by the highatomic reservation system
operating on single pageblocks, while MAX_ORDER can be bigger than that -
in this configuration, pageblock_order is 9 while MAX_PAGE_ORDER is 10. 
The test case is observed to make several adjacent order-3 requests with
__GFP_DIRECT_RECLAIM cleared, which marks the surrounding block as
highatomic.  Upon freeing, the blocks merge into an order-10 buddy.  When
the highatomic pool is drained later on, this order-10 buddy gets moved
back to the movable list, but only the first pageblock is marked movable
again.  A subsequent expand() of this buddy warns about the tail being of
a different type.

This is a long-standing bug that's surfaced by the recent block type
warnings added to the allocator.  The consequences seem mostly benign, it
just results in odd behavior: the highatomic tail blocks are not properly
drained, instead they end up on the movable list first, then go back to
the highatomic list after an alloc-free cycle.

To fix this, make the highatomic reservation code aware that
allocations/buddies can be larger than a pageblock.

While it's an old quirk, the recently added type consistency warnings seem
to be the most prominent consequence of it.  Set the Fixes: tag
accordingly to highlight this backporting dependency.

Link: https://lkml.kernel.org/r/20240530114203.GA1222079@cmpxchg.org
Fixes: e0932b6c1f94 ("mm: page_alloc: consolidate free page accounting")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Christoph Hellwig <hch@infradead.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   50 +++++++++++++++++++++++++++++++---------------
 1 file changed, 34 insertions(+), 16 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-fix-highatomic-typing-in-multi-block-buddies
+++ a/mm/page_alloc.c
@@ -1955,10 +1955,12 @@ int find_suitable_fallback(struct free_a
 }
 
 /*
- * Reserve a pageblock for exclusive use of high-order atomic allocations if
- * there are no empty page blocks that contain a page with a suitable order
+ * Reserve the pageblock(s) surrounding an allocation request for
+ * exclusive use of high-order atomic allocations if there are no
+ * empty page blocks that contain a page with a suitable order
  */
-static void reserve_highatomic_pageblock(struct page *page, struct zone *zone)
+static void reserve_highatomic_pageblock(struct page *page, int order,
+					 struct zone *zone)
 {
 	int mt;
 	unsigned long max_managed, flags;
@@ -1984,10 +1986,17 @@ static void reserve_highatomic_pageblock
 	/* Yoink! */
 	mt = get_pageblock_migratetype(page);
 	/* Only reserve normal pageblocks (i.e., they can merge with others) */
-	if (migratetype_is_mergeable(mt))
-		if (move_freepages_block(zone, page, mt,
-					 MIGRATE_HIGHATOMIC) != -1)
-			zone->nr_reserved_highatomic += pageblock_nr_pages;
+	if (!migratetype_is_mergeable(mt))
+		goto out_unlock;
+
+	if (order < pageblock_order) {
+		if (move_freepages_block(zone, page, mt, MIGRATE_HIGHATOMIC) == -1)
+			goto out_unlock;
+		zone->nr_reserved_highatomic += pageblock_nr_pages;
+	} else {
+		change_pageblock_range(page, order, MIGRATE_HIGHATOMIC);
+		zone->nr_reserved_highatomic += 1 << order;
+	}
 
 out_unlock:
 	spin_unlock_irqrestore(&zone->lock, flags);
@@ -1999,7 +2008,7 @@ out_unlock:
  * intense memory pressure but failed atomic allocations should be easier
  * to recover from than an OOM.
  *
- * If @force is true, try to unreserve a pageblock even though highatomic
+ * If @force is true, try to unreserve pageblocks even though highatomic
  * pageblock is exhausted.
  */
 static bool unreserve_highatomic_pageblock(const struct alloc_context *ac,
@@ -2041,6 +2050,7 @@ static bool unreserve_highatomic_pageblo
 			 * adjust the count once.
 			 */
 			if (is_migrate_highatomic(mt)) {
+				unsigned long size;
 				/*
 				 * It should never happen but changes to
 				 * locking could inadvertently allow a per-cpu
@@ -2048,9 +2058,9 @@ static bool unreserve_highatomic_pageblo
 				 * while unreserving so be safe and watch for
 				 * underflows.
 				 */
-				zone->nr_reserved_highatomic -= min(
-						pageblock_nr_pages,
-						zone->nr_reserved_highatomic);
+				size = max(pageblock_nr_pages, 1UL << order);
+				size = min(size, zone->nr_reserved_highatomic);
+				zone->nr_reserved_highatomic -= size;
 			}
 
 			/*
@@ -2062,11 +2072,19 @@ static bool unreserve_highatomic_pageblo
 			 * of pageblocks that cannot be completely freed
 			 * may increase.
 			 */
-			ret = move_freepages_block(zone, page, mt,
-						   ac->migratetype);
+			if (order < pageblock_order)
+				ret = move_freepages_block(zone, page, mt,
+							   ac->migratetype);
+			else {
+				move_to_free_list(page, zone, order, mt,
+						  ac->migratetype);
+				change_pageblock_range(page, order,
+						       ac->migratetype);
+				ret = 1;
+			}
 			/*
-			 * Reserving this block already succeeded, so this should
-			 * not fail on zone boundaries.
+			 * Reserving the block(s) already succeeded,
+			 * so this should not fail on zone boundaries.
 			 */
 			WARN_ON_ONCE(ret == -1);
 			if (ret > 0) {
@@ -3406,7 +3424,7 @@ try_this_zone:
 			 * if the pageblock should be reserved for the future
 			 */
 			if (unlikely(alloc_flags & ALLOC_HIGHATOMIC))
-				reserve_highatomic_pageblock(page, zone);
+				reserve_highatomic_pageblock(page, order, zone);
 
 			return page;
 		} else {
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-page_alloc-fix-highatomic-typing-in-multi-block-buddies.patch
mm-vmscan-restore-incremental-cgroup-iteration.patch

