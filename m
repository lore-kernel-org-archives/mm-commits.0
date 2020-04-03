From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 =?US-ASCII?Q?mm-make-it-clear-that-gfp-reclaim-modifiers-are-valid-only?=
 =?US-ASCII?Q?-for-sleepable-allocations.patch?= added to -mm tree
Date: Fri, 03 Apr 2020 16:40:46 -0700
Message-ID: <20200403234046.uIymO0xPK%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725268AbgDCXkr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 19:40:47 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joel@joelfernandes.org, mhocko@suse.com, mm-commits@vger.kernel.org, neilb@suse.de, paulmck@kernel.org, rientjes@google.com


The patch titled
     Subject: mm: make it clear that gfp reclaim modifiers are valid only for sleepable allocations
has been added to the -mm tree.  Its filename is
     mm-make-it-clear-that-gfp-reclaim-modifiers-are-valid-only-for-sleepable-allocations.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-make-it-clear-that-gfp-reclaim-modifiers-are-valid-only-for-sleepable-allocations.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-make-it-clear-that-gfp-reclaim-modifiers-are-valid-only-for-sleepable-allocations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/gfp.h~mm-make-it-clear-that-gfp-reclaim-modifiers-are-valid-only-for-sleepable-allocations
+++ a/include/linux/gfp.h
@@ -127,6 +127,8 @@ struct vm_area_struct;
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
mm-make-it-clear-that-gfp-reclaim-modifiers-are-valid-only-for-sleepable-allocations.patch
