From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-do-not-update-zlc-unless-the-zlc-is-active.patch removed from -mm tree
Date: Thu, 05 Jun 2014 12:52:17 -0700
Message-ID: <5390ca71.XWDJkgREB41esqQq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56324 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753133AbaFETwS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:52:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, hannes@cmpxchg.org, mgorman@suse.de

Subject: [merged] mm-page_alloc-do-not-update-zlc-unless-the-zlc-is-active.patch removed from -mm tree
To: mgorman@suse.de,hannes@cmpxchg.org,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:52:17 -0700


The patch titled
     Subject: mm: page_alloc: do not update zlc unless the zlc is active
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-do-not-update-zlc-unless-the-zlc-is-active.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: page_alloc: do not update zlc unless the zlc is active

The zlc is used on NUMA machines to quickly skip over zones that are full.
 However it is always updated, even for the first zone scanned when the
zlc might not even be active.  As it's a write to a bitmap that
potentially bounces cache line it's deceptively expensive and most
machines will not care.  Only update the zlc if it was active.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-page_alloc-do-not-update-zlc-unless-the-zlc-is-active mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-do-not-update-zlc-unless-the-zlc-is-active
+++ a/mm/page_alloc.c
@@ -2035,7 +2035,7 @@ try_this_zone:
 		if (page)
 			break;
 this_zone_full:
-		if (IS_ENABLED(CONFIG_NUMA))
+		if (IS_ENABLED(CONFIG_NUMA) && zlc_active)
 			zlc_mark_zone_full(zonelist, z);
 	}
 
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-fix.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-v5.patch
cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline.patch
linux-next.patch

