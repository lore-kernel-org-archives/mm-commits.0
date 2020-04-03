From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-clarify-__gfp_memalloc-usage.patch added to -mm tree
Date: Fri, 03 Apr 2020 16:40:43 -0700
Message-ID: <20200403234043.lB0jbOUMQ%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725268AbgDCXkp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 19:40:45 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joel@joelfernandes.org, mhocko@suse.com, mm-commits@vger.kernel.org, neilb@suse.de, paulmck@kernel.org, rientjes@google.com


The patch titled
     Subject: mm: clarify __GFP_MEMALLOC usage
has been added to the -mm tree.  Its filename is
     mm-clarify-__gfp_memalloc-usage.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-clarify-__gfp_memalloc-usage.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-clarify-__gfp_memalloc-usage.patch

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
Subject: mm: clarify __GFP_MEMALLOC usage

It seems that the existing documentation is not explicit about the
expected usage and potential risks enough.  While it is calls out that
users have to free memory when using this flag it is not really apparent
that users have to careful to not deplete memory reserves and that they
should implement some sort of throttling wrt.  freeing process.

This is partly based on Neil's explanation [1].

[1] http://lkml.kernel.org/r/877dz0yxoa.fsf@notabene.neil.brown.name
Link: http://lkml.kernel.org/r/20200403083543.11552-2-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Neil Brown <neilb@suse.de>
Cc: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/include/linux/gfp.h~mm-clarify-__gfp_memalloc-usage
+++ a/include/linux/gfp.h
@@ -110,6 +110,9 @@ struct vm_area_struct;
  * the caller guarantees the allocation will allow more memory to be freed
  * very shortly e.g. process exiting or swapping. Users either should
  * be the MM or co-ordinating closely with the VM (e.g. swap over NFS).
+ * Users of this flag have to be extremely careful to not deplete the reserve
+ * completely and implement a throttling mechanism which controls the consumption
+ * of the reserve based on the amount of freed memory.
  *
  * %__GFP_NOMEMALLOC is used to explicitly forbid access to emergency reserves.
  * This takes precedence over the %__GFP_MEMALLOC flag if both are set.
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-clarify-__gfp_memalloc-usage.patch
mm-make-it-clear-that-gfp-reclaim-modifiers-are-valid-only-for-sleepable-allocations.patch
