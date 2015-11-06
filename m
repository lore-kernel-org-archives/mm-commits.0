From: akpm@linux-foundation.org
Subject: [merged]
 memcg-drop-unnecessary-cold-path-tests-from-__memcg_kmem_bypass.patch
 removed from -mm tree
Date: Fri, 06 Nov 2015 12:07:28 -0800
Message-ID: <563d0880.rP1KCYrcrY82F7yI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48662 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965967AbbKFUH3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:07:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, hannes@cmpxchg.org, mhocko@suse.com, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: drop unnecessary cold-path tests from __memcg_kmem_bypass()
has been removed from the -mm tree.  Its filename was
     memcg-drop-unnecessary-cold-path-tests-from-__memcg_kmem_bypass.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: memcg: drop unnecessary cold-path tests from __memcg_kmem_bypass()

__memcg_kmem_bypass() decides whether a kmem allocation should be bypassed
to the root memcg.  Some conditions that it tests are valid criteria
regarding who should be held accountable; however, there are a couple
unnecessary tests for cold paths - __GFP_FAIL and fatal_signal_pending().

The previous patch updated try_charge() to handle both __GFP_FAIL and
dying tasks correctly and the only thing these two tests are doing is
making accounting less accurate and sprinkling tests for cold path
conditions in the hot paths.  There's nothing meaningful gained by these
extra tests.

This patch removes the two unnecessary tests from __memcg_kmem_bypass().

Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Vladimir Davydov <vdavydov@parallels.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   14 --------------
 1 file changed, 14 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-drop-unnecessary-cold-path-tests-from-__memcg_kmem_bypass include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-drop-unnecessary-cold-path-tests-from-__memcg_kmem_bypass
+++ a/include/linux/memcontrol.h
@@ -781,24 +781,10 @@ static inline bool __memcg_kmem_bypass(g
 {
 	if (!memcg_kmem_enabled())
 		return true;
-
 	if (gfp & __GFP_NOACCOUNT)
 		return true;
-	/*
-	 * __GFP_NOFAIL allocations will move on even if charging is not
-	 * possible. Therefore we don't even try, and have this allocation
-	 * unaccounted. We could in theory charge it forcibly, but we hope
-	 * those allocations are rare, and won't be worth the trouble.
-	 */
-	if (gfp & __GFP_NOFAIL)
-		return true;
 	if (in_interrupt() || (!current->mm) || (current->flags & PF_KTHREAD))
 		return true;
-
-	/* If the test is dying, just let it go. */
-	if (unlikely(fatal_signal_pending(current)))
-		return true;
