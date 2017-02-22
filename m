From: akpm@linux-foundation.org
Subject: [patch 134/142] mm, page_alloc: warn_alloc nodemask is NULL when
 cpusets are disabled
Date: Wed, 22 Feb 2017 15:46:28 -0800
Message-ID: <58ae22d4.Nis9t2jxuZItmAh7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49732 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933793AbdBVXq3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Feb 2017 18:46:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, rientjes@google.com, hannes@cmpxchg.org, mgorman@suse.de, mhocko@kernel.org, vbabka@suse.cz

From: David Rientjes <rientjes@google.com>
Subject: mm, page_alloc: warn_alloc nodemask is NULL when cpusets are disabled

The patch "mm, page_alloc: warn_alloc print nodemask" implicitly sets the
allocation nodemask to cpuset_current_mems_allowed when there is no
effective mempolicy.  cpuset_current_mems_allowed is only effective when
cpusets are enabled, which is also printed by warn_alloc(), so setting the
nodemask to cpuset_current_mems_allowed is redundant and prevents
debugging issues where ac->nodemask is not set properly in the page
allocator.

This provides better debugging output since
cpuset_print_current_mems_allowed() is already provided.

Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1701181347320.142399@chino.kir.corp.google.com
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-warn_alloc-nodemask-is-null-when-cpusets-are-disabled mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-warn_alloc-nodemask-is-null-when-cpusets-are-disabled
+++ a/mm/page_alloc.c
@@ -3034,7 +3034,6 @@ void warn_alloc(gfp_t gfp_mask, nodemask
 	va_list args;
 	static DEFINE_RATELIMIT_STATE(nopage_rs, DEFAULT_RATELIMIT_INTERVAL,
 				      DEFAULT_RATELIMIT_BURST);
-	nodemask_t *nm = (nodemask) ? nodemask : &cpuset_current_mems_allowed;
 
 	if ((gfp_mask & __GFP_NOWARN) || !__ratelimit(&nopage_rs) ||
 	    debug_guardpage_minorder() > 0)
@@ -3048,11 +3047,16 @@ void warn_alloc(gfp_t gfp_mask, nodemask
 	pr_cont("%pV", &vaf);
 	va_end(args);
 
-	pr_cont(", mode:%#x(%pGg), nodemask=%*pbl\n", gfp_mask, &gfp_mask, nodemask_pr_args(nm));
+	pr_cont(", mode:%#x(%pGg), nodemask=", gfp_mask, &gfp_mask);
+	if (nodemask)
+		pr_cont("%*pbl\n", nodemask_pr_args(nodemask));
+	else
+		pr_cont("(null)\n");
+
 	cpuset_print_current_mems_allowed();
 
 	dump_stack();
-	warn_alloc_show_mem(gfp_mask, nm);
+	warn_alloc_show_mem(gfp_mask, nodemask);
 }
 
 static inline struct page *
_
