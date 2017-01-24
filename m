From: akpm@linux-foundation.org
Subject: [patch 10/26] mm, memcg: do not retry precharge charges
Date: Tue, 24 Jan 2017 15:18:10 -0800
Message-ID: <5887e0b2.8IAwtXRu20j9oxHe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41410 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751018AbdAXXSL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jan 2017 18:18:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, rientjes@google.com, hannes@cmpxchg.org, mhocko@suse.com, vdavydov.dev@gmail.com

From: David Rientjes <rientjes@google.com>
Subject: mm, memcg: do not retry precharge charges

When memory.move_charge_at_immigrate is enabled and precharges are
depleted during move, mem_cgroup_move_charge_pte_range() will attempt to
increase the size of the precharge.

Prevent precharges from ever looping by setting __GFP_NORETRY.  This was
probably the intention of the GFP_KERNEL & ~__GFP_NORETRY, which is
pointless as written.

Fixes: 0029e19ebf84 ("mm: memcontrol: remove explicit OOM parameter in charge path")
Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1701130208510.69402@chino.kir.corp.google.com
Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/memcontrol.c~mm-memcg-do-not-retry-precharge-charges mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-do-not-retry-precharge-charges
+++ a/mm/memcontrol.c
@@ -4353,9 +4353,9 @@ static int mem_cgroup_do_precharge(unsig
 		return ret;
 	}
 
-	/* Try charges one by one with reclaim */
+	/* Try charges one by one with reclaim, but do not retry */
 	while (count--) {
-		ret = try_charge(mc.to, GFP_KERNEL & ~__GFP_NORETRY, 1);
+		ret = try_charge(mc.to, GFP_KERNEL | __GFP_NORETRY, 1);
 		if (ret)
 			return ret;
 		mc.precharge++;
_
