From: akpm@linux-foundation.org
Subject: +
 memcg-drop-unnecessary-cold-path-tests-from-__memcg_kmem_bypass.patch added to -mm tree
Date: Mon, 14 Sep 2015 14:14:27 -0700
Message-ID: <55f738b3.obCYWzjztJwlRjUn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45803 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbbINVO2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Sep 2015 17:14:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, mhocko@suse.com, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: drop unnecessary cold-path tests from __memcg_kmem_bypass()
has been added to the -mm tree.  Its filename is
     memcg-drop-unnecessary-cold-path-tests-from-__memcg_kmem_bypass.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-drop-unnecessary-cold-path-tests-from-__memcg_kmem_bypass.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-drop-unnecessary-cold-path-tests-from-__memcg_kmem_bypass.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   14 --------------
 1 file changed, 14 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-drop-unnecessary-cold-path-tests-from-__memcg_kmem_bypass include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-drop-unnecessary-cold-path-tests-from-__memcg_kmem_bypass
+++ a/include/linux/memcontrol.h
@@ -780,24 +780,10 @@ static inline bool __memcg_kmem_bypass(g
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
