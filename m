From: akpm@linux-foundation.org
Subject: [merged]
 =?US-ASCII?Q?mm-make-it-clear-that-gfp-reclaim-modifiers-are-valid-only?=
 =?US-ASCII?Q?-for-sleepable-allocations.patch?= removed from -mm tree
Date: Tue, 07 Apr 2020 18:56:42 -0700
Message-ID: <20200408015642.7WkAHULti%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726443AbgDHB4n (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 21:56:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joel@joelfernandes.org, mhocko@suse.com, mm-commits@vger.kernel.org, neilb@suse.de, paulmck@kernel.org, rientjes@google.com


The patch titled
     Subject: mm: make it clear that gfp reclaim modifiers are valid only for sleepable allocations
has been removed from the -mm tree.  Its filename was
     mm-make-it-clear-that-gfp-reclaim-modifiers-are-valid-only-for-sleepable-allocations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm: make it clear that gfp reclaim modifiers are valid only for sleepable allocations

While it might be really clear to MM developers that gfp reclaim modifiers
are applicable only to sleepable allocations (those with
__GFP_DIRECT_RECLAIM) it seems that actual users of the API are not always
sure.  Make it explicit that they are not applicable for GFP_NOWAIT or
GFP_ATOMIC allocations which are the most commonly used non-sleepable
allocation masks.

Link: http://lkml.kernel.org/r/20200403083543.11552-3-mhocko@kernel.org
Acked-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: David Rientjes <rientjes@google.com>
Reviewed-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/gfp.h~mm-make-it-clear-that-gfp-reclaim-modifiers-are-valid-only-for-sleepable-allocations
+++ a/include/linux/gfp.h
@@ -124,6 +124,8 @@ struct vm_area_struct;
  *
  * Reclaim modifiers
  * ~~~~~~~~~~~~~~~~~
+ * Please note that all the following flags are only applicable to sleepable
+ * allocations (e.g. %GFP_NOWAIT and %GFP_ATOMIC will ignore them).
  *
  * %__GFP_IO can start physical IO.
  *
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-clarify-__gfp_memalloc-usage.patch
