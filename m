From: akpm@linux-foundation.org
Subject: [patch 027/124] mm, page_alloc: don't check cpuset allowed twice
 in fast-path
Date: Fri, 24 Feb 2017 14:56:53 -0800
Message-ID: <58b0ba35.4XASIy2FNX0i4vUw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37892 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751437AbdBXW47 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 17:56:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, vbabka@suse.cz, khandual@linux.vnet.ibm.com, mgorman@techsingularity.net, mhocko@suse.com

From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, page_alloc: don't check cpuset allowed twice in fast-path

Since 682a3385e773 ("mm, page_alloc: inline the fast path of the zonelist
iterator") we replace a NULL nodemask with cpuset_current_mems_allowed in
the fast path, so that get_page_from_freelist() filters nodes allowed by
the cpuset via for_next_zone_zonelist_nodemask().  In that case it's
pointless to additionaly check __cpuset_zone_allowed() in each iteration,
which we can avoid by not adding ALLOC_CPUSET to alloc_flags in that
scenario.

This saves some cycles in the allocator fast path on systems with one or
more non-root cpuset configured.  In the slow path, ALLOC_CPUSET is reset
according to __alloc_pages_slowpath().  Without configured cpusets, this
code is disabled by a static key.

Link: http://lkml.kernel.org/r/20170124150511.5710-2-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-page_alloc-dont-check-cpuset-allowed-twice-in-fast-path mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-dont-check-cpuset-allowed-twice-in-fast-path
+++ a/mm/page_alloc.c
@@ -3903,9 +3903,10 @@ static inline bool prepare_alloc_pages(g
 
 	if (cpusets_enabled()) {
 		*alloc_mask |= __GFP_HARDWALL;
-		*alloc_flags |= ALLOC_CPUSET;
 		if (!ac->nodemask)
 			ac->nodemask = &cpuset_current_mems_allowed;
+		else
+			*alloc_flags |= ALLOC_CPUSET;
 	}
 
 	lockdep_trace_alloc(gfp_mask);
_
