From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-consolidate-gfp_nofail-checks-in-the-allocator-slowpath-fix.patch
 removed from -mm tree
Date: Wed, 22 Feb 2017 15:29:29 -0800
Message-ID: <58ae1ed9.g5+AMLMdNOW8GWhr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47438 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934208AbdBVX3f (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Feb 2017 18:29:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, mhocko@suse.com, penguin-kernel@I-love.SAKURA.ne.jp, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-consolidate-gfp_nofail-checks-in-the-allocator-slowpath-fix
has been removed from the -mm tree.  Its filename was
     mm-consolidate-gfp_nofail-checks-in-the-allocator-slowpath-fix.patch

This patch was dropped because it was folded into mm-consolidate-gfp_nofail-checks-in-the-allocator-slowpath.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-consolidate-gfp_nofail-checks-in-the-allocator-slowpath-fix

fix alloc_flags may-be-used-uninitalized

Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN mm/page_alloc.c~mm-consolidate-gfp_nofail-checks-in-the-allocator-slowpath-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-consolidate-gfp_nofail-checks-in-the-allocator-slowpath-fix
+++ a/mm/page_alloc.c
@@ -3577,6 +3577,14 @@ retry_cpuset:
 	no_progress_loops = 0;
 	compact_priority = DEF_COMPACT_PRIORITY;
 	cpuset_mems_cookie = read_mems_allowed_begin();
+
+	/*
+	 * The fast path uses conservative alloc_flags to succeed only until
+	 * kswapd needs to be woken up, and to avoid the cost of setting up
+	 * alloc_flags precisely. So we do that now.
+	 */
+	alloc_flags = gfp_to_alloc_flags(gfp_mask);
+
 	/*
 	 * We need to recalculate the starting point for the zonelist iterator
 	 * because we might have used different nodemask in the fast path, or
@@ -3588,14 +3596,6 @@ retry_cpuset:
 	if (!ac->preferred_zoneref->zone)
 		goto nopage;
 
-
-	/*
-	 * The fast path uses conservative alloc_flags to succeed only until
-	 * kswapd needs to be woken up, and to avoid the cost of setting up
-	 * alloc_flags precisely. So we do that now.
-	 */
-	alloc_flags = gfp_to_alloc_flags(gfp_mask);
