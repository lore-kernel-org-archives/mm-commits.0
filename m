From: akpm@linux-foundation.org
Subject: [merged] mm-memcontrol-fix-order-calculation-in-try_charge.patch
 removed from -mm tree
Date: Fri, 06 Nov 2015 12:08:20 -0800
Message-ID: <563d08b4.iTQ2meWU69QOmKpr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48751 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1033706AbbKFUIV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:08:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jmarchan@redhat.com, hannes@cmpxchg.org, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcontrol.c: fix order calculation in try_charge()
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-fix-order-calculation-in-try_charge.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/memcontrol.c~mm-memcontrol-fix-order-calculation-in-try_charge mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-fix-order-calculation-in-try_charge
+++ a/mm/memcontrol.c
@@ -2094,7 +2094,8 @@ retry:
 
 	mem_cgroup_events(mem_over_limit, MEMCG_OOM, 1);
 
-	mem_cgroup_oom(mem_over_limit, gfp_mask, get_order(nr_pages));
+	mem_cgroup_oom(mem_over_limit, gfp_mask,
+		       get_order(nr_pages * PAGE_SIZE));
 nomem:
 	if (!(gfp_mask & __GFP_NOFAIL))
 		return -ENOMEM;
_

Patches currently in -mm which might be from jmarchan@redhat.com are


