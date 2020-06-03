From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 010/131] mm: clarify __GFP_MEMALLOC usage
Date: Wed, 03 Jun 2020 15:56:49 -0700
Message-ID: <20200603225649.lZMovsIIu%akpm@linux-foundation.org>
References: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725863AbgFCW4v (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Jun 2020 18:56:51 -0400
In-Reply-To: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jhubbard@nvidia.com, joel@joelfernandes.org, linux-mm@kvack.org, mhocko@suse.com, mm-commits@vger.kernel.org, neilb@suse.de, paulmck@kernel.org, rientjes@google.com, torvalds@linux-foundation.org

From: Michal Hocko <mhocko@suse.com>
Subject: mm: clarify __GFP_MEMALLOC usage

It seems that the existing documentation is not explicit about the
expected usage and potential risks enough.  While it is calls out that
users have to free memory when using this flag it is not really apparent
that users have to careful to not deplete memory reserves and that they
should implement some sort of throttling wrt.  freeing process.

This is partly based on Neil's explanation [1].

Let's also call out that a pre allocated pool allocator should be
considered.

[1] http://lkml.kernel.org/r/877dz0yxoa.fsf@notabene.neil.brown.name

[akpm@linux-foundation.org: coding style fixes]
[mhocko@kernel.org: update]
  Link: http://lkml.kernel.org/r/20200406070137.GC19426@dhcp22.suse.cz
Link: http://lkml.kernel.org/r/20200403083543.11552-2-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Neil Brown <neilb@suse.de>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    5 +++++
 1 file changed, 5 insertions(+)

--- a/include/linux/gfp.h~mm-clarify-__gfp_memalloc-usage
+++ a/include/linux/gfp.h
@@ -110,6 +110,11 @@ struct vm_area_struct;
  * the caller guarantees the allocation will allow more memory to be freed
  * very shortly e.g. process exiting or swapping. Users either should
  * be the MM or co-ordinating closely with the VM (e.g. swap over NFS).
+ * Users of this flag have to be extremely careful to not deplete the reserve
+ * completely and implement a throttling mechanism which controls the
+ * consumption of the reserve based on the amount of freed memory.
+ * Usage of a pre-allocated pool (e.g. mempool) should be always considered
+ * before using this flag.
  *
  * %__GFP_NOMEMALLOC is used to explicitly forbid access to emergency reserves.
  * This takes precedence over the %__GFP_MEMALLOC flag if both are set.
_
