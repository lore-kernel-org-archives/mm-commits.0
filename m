From: akpm@linux-foundation.org
Subject: [patch 117/117] mm, page_alloc: restore the original nodemask if
 the fast path allocation failed
Date: Thu, 19 May 2016 17:14:44 -0700
Message-ID: <573e56f4.6PZUN6Pr+ETCinvI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46658 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932311AbcETAOp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2016 20:14:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mgorman@techsingularity.net, brouer@redhat.com, vbabka@suse.cz

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
