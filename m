From: akpm@linux-foundation.org
Subject: + mm-memcontrol-fix-order-calculation-in-try_charge.patch added
 to -mm tree
Date: Thu, 17 Sep 2015 15:20:49 -0700
Message-ID: <55fb3cc1.UZ/m09+JLSIzAmpx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56741 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714AbbIQWUu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Sep 2015 18:20:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jmarchan@redhat.com, hannes@cmpxchg.org, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcontrol.c: fix order calculation in try_charge()
has been added to the -mm tree.  Its filename is
     mm-memcontrol-fix-order-calculation-in-try_charge.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-fix-order-calculation-in-try_charge.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-fix-order-calculation-in-try_charge.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Jerome Marchand" <jmarchan@redhat.com>
Subject: mm/memcontrol.c: fix order calculation in try_charge()

Since 6539cc05386 ("mm: memcontrol: fold mem_cgroup_do_charge()"), the
order to pass to mem_cgroup_oom() is calculated by passing the number of
pages to get_order() instead of the expected size in bytes.  AFAICT, it
only affects the value displayed in the oom warning message.  This patch
fix this.

Michal said:

: We haven't noticed that just because the OOM is enabled only for page
: faults of order-0 (single page) and get_order work just fine.  Thanks for
: noticing this.  If we ever start triggering OOM on different orders this
: would be broken.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/memcontrol.c~mm-memcontrol-fix-order-calculation-in-try_charge mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-fix-order-calculation-in-try_charge
+++ a/mm/memcontrol.c
@@ -2085,7 +2085,8 @@ retry:
 
 	mem_cgroup_events(mem_over_limit, MEMCG_OOM, 1);
 
-	mem_cgroup_oom(mem_over_limit, gfp_mask, get_order(nr_pages));
+	mem_cgroup_oom(mem_over_limit, gfp_mask,
+		       get_order(nr_pages * PAGE_SIZE));
 nomem:
 	if (!(gfp_mask & __GFP_NOFAIL))
 		return -ENOMEM;
_

Patches currently in -mm which might be from jmarchan@redhat.com are

mm-memcontrol-fix-order-calculation-in-try_charge.patch

