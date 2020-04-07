From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 011/166] mm: make it clear that gfp reclaim
 modifiers are valid only for sleepable allocations
Date: Mon, 06 Apr 2020 20:04:06 -0700
Message-ID: <20200407030406.SXeYc0WBG%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726287AbgDGDEH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:04:07 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, joel@joelfernandes.org, linux-mm@kvack.org, mhocko@suse.com, mm-commits@vger.kernel.org, neilb@suse.de, paulmck@kernel.org, rientjes@google.com, torvalds@linux-foundation.org

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
