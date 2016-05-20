From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-restore-the-original-nodemask-if-the-fast-path-allocation-failed.patch removed from -mm tree
Date: Fri, 20 May 2016 14:07:11 -0700
Message-ID: <573f7c7f.5KJIM6s1rkSDadUz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47442 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbcETVHM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 17:07:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, brouer@redhat.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: restore the original nodemask if the fast path allocation failed
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-restore-the-original-nodemask-if-the-fast-path-allocation-failed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, page_alloc: restore the original nodemask if the fast path allocation failed

The page allocator fast path uses either the requested nodemask or
cpuset_current_mems_allowed if cpusets are enabled.  If the allocation
context allows watermarks to be ignored then it can also ignore memory
policies.  However, on entering the allocator slowpath the nodemask may
still be cpuset_current_mems_allowed and the policies are enforced.  This
patch resets the nodemask appropriately before entering the slowpath.

Link: http://lkml.kernel.org/r/20160504143628.GU2858@techsingularity.net
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN mm/page_alloc.c~mm-page_alloc-restore-the-original-nodemask-if-the-fast-path-allocation-failed mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-restore-the-original-nodemask-if-the-fast-path-allocation-failed
+++ a/mm/page_alloc.c
@@ -3636,6 +3636,12 @@ retry_cpuset:
 	alloc_mask = memalloc_noio_flags(gfp_mask);
 	ac.spread_dirty_pages = false;
 
+	/*
+	 * Restore the original nodemask if it was potentially replaced with
+	 * &cpuset_current_mems_allowed to optimize the fast-path attempt.
+	 */
+	if (cpusets_enabled())
+		ac.nodemask = nodemask;
 	page = __alloc_pages_slowpath(alloc_mask, order, &ac);
 
 no_zone:
_

Patches currently in -mm which might be from mgorman@techsingularity.net are


