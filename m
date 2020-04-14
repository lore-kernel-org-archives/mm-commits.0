From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged]
 mm-clarify-__gfp_memalloc-usage-update.patch removed from -mm tree
Date: Mon, 13 Apr 2020 19:13:35 -0700
Message-ID: <20200414021335.6khgugFy0%akpm@linux-foundation.org>
References: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403967AbgDNCNh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 13 Apr 2020 22:13:37 -0400
In-Reply-To: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jhubbard@nvidia.com, joel@joelfernandes.org, mhocko@kernel.org, mhocko@suse.com, mm-commits@vger.kernel.org, neilb@suse.de, paulmck@kernel.org, rientjes@google.com


The patch titled
     Subject: mm-clarify-__gfp_memalloc-usage-update
has been removed from the -mm tree.  Its filename was
     mm-clarify-__gfp_memalloc-usage-update.patch

This patch was dropped because it was folded into mm-clarify-__gfp_memalloc-usage.patch

------------------------------------------------------
From: Michal Hocko <mhocko@kernel.org>
Subject: mm-clarify-__gfp_memalloc-usage-update

Link: http://lkml.kernel.org/r/20200406070137.GC19426@dhcp22.suse.cz
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Neil Brown <neilb@suse.de>
Cc: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/gfp.h~mm-clarify-__gfp_memalloc-usage-update
+++ a/include/linux/gfp.h
@@ -113,6 +113,8 @@ struct vm_area_struct;
  * Users of this flag have to be extremely careful to not deplete the reserve
  * completely and implement a throttling mechanism which controls the consumption
  * of the reserve based on the amount of freed memory.
+ * Usage of a pre-allocated pool (e.g. mempool) should be always considered before
+ * using this flag.
  *
  * %__GFP_NOMEMALLOC is used to explicitly forbid access to emergency reserves.
  * This takes precedence over the %__GFP_MEMALLOC flag if both are set.
_

Patches currently in -mm which might be from mhocko@kernel.org are

mm-clarify-__gfp_memalloc-usage.patch
