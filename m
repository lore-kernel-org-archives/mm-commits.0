From: akpm@linux-foundation.org
Subject: + mm-compaction-avoid-isolating-pinned-pages.patch added to -mm
 tree
Date: Mon, 03 Feb 2014 12:54:15 -0800
Message-ID: <52f001f7.TpLJpjkNfO1kh+bR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46624 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbaBCUyQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Feb 2014 15:54:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, mgorman@suse.de, rientjes@google.com

Subject: + mm-compaction-avoid-isolating-pinned-pages.patch added to -mm tree
To: rientjes@google.com,mgorman@suse.de,riel@redhat.com
From: akpm@linux-foundation.org
Date: Mon, 03 Feb 2014 12:54:15 -0800


The patch titled
     Subject: mm, compaction: avoid isolating pinned pages
has been added to the -mm tree.  Its filename is
     mm-compaction-avoid-isolating-pinned-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-avoid-isolating-pinned-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-avoid-isolating-pinned-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, compaction: avoid isolating pinned pages

Page migration will fail for memory that is pinned in memory with, for
example, get_user_pages().  In this case, it is unnecessary to take
zone->lru_lock or isolating the page and passing it to page migration
which will ultimately fail.

This is a racy check, the page can still change from under us, but in that
case we'll just fail later when attempting to move the page.

This avoids very expensive memory compaction when faulting transparent
hugepages after pinning a lot of memory with a Mellanox driver.

On a 128GB machine and pinning ~120GB of memory, before this patch we
see the enormous disparity in the number of page migration failures
because of the pinning (from /proc/vmstat):

compact_blocks_moved 7609
compact_pages_moved 3431
compact_pagemigrate_failed 133219
compact_stall 13

After the patch, it is much more efficient:

compact_blocks_moved 7998
compact_pages_moved 6403
compact_pagemigrate_failed 3
compact_stall 15

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN mm/compaction.c~mm-compaction-avoid-isolating-pinned-pages mm/compaction.c
--- a/mm/compaction.c~mm-compaction-avoid-isolating-pinned-pages
+++ a/mm/compaction.c
@@ -578,6 +578,14 @@ isolate_migratepages_range(struct zone *
 			continue;
 		}
 
+		/*
+		 * Migration will fail if an anonymous page is pinned in memory,
+		 * so avoid taking zone->lru_lock and isolating it unnecessarily
+		 * in an admittedly racy check.
+		 */
+		if (!page_mapping(page) && page_count(page))
+			continue;
+
 		/* Check if it is ok to still hold the lock */
 		locked = compact_checklock_irqsave(&zone->lru_lock, &flags,
 								locked, cc);
_

Patches currently in -mm which might be from rientjes@google.com are

documentation-kernel-parameterstxt-fix-memmap=-language.patch
numa-mem-hotplug-initialize-numa_kernel_nodes-in-numa_clear_kernel_node_hotplug.patch
numa-mem-hotplug-initialize-numa_kernel_nodes-in-numa_clear_kernel_node_hotplug-fix.patch
numa-mem-hotplug-fix-array-index-overflow-when-synchronizing-nid-to-memblockreserved.patch
kthread-ensure-locality-of-task_struct-allocations.patch
mm-compaction-ignore-pageblock-skip-when-manually-invoking-compaction.patch
mm-compaction-avoid-isolating-pinned-pages.patch
mm-utilc-add-kstrimdup.patch
cpusets-allocate-heap-only-when-required.patch
linux-next.patch

