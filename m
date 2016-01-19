From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcontrol-hook-up-vmpressure-to-socket-pressure-fix.patch removed from
 -mm tree
Date: Tue, 19 Jan 2016 11:59:53 -0800
Message-ID: <569e95b9.M+VeK+xCbkiQ89tm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42250 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755652AbcAST7y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 14:59:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, davem@davemloft.net, hannes@cmpxchg.org, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: avoid vmpressure oops when memcg disabled
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-hook-up-vmpressure-to-socket-pressure-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: memcg: avoid vmpressure oops when memcg disabled

A CONFIG_MEMCG=y kernel booted with "cgroup_disable=memory" crashes on a
NULL memcg (but non-NULL root_mem_cgroup) when vmpressure kicks in. 
Here's the patch I use to avoid that, but you might prefer a test on
mem_cgroup_disabled() somewhere.

Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmpressure.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmpressure.c~mm-memcontrol-hook-up-vmpressure-to-socket-pressure-fix mm/vmpressure.c
--- a/mm/vmpressure.c~mm-memcontrol-hook-up-vmpressure-to-socket-pressure-fix
+++ a/mm/vmpressure.c
@@ -260,7 +260,7 @@ void vmpressure(gfp_t gfp, struct mem_cg
 		enum vmpressure_levels level;
 
 		/* For now, no users for root-level efficiency */
-		if (memcg == root_mem_cgroup)
+		if (!memcg || memcg == root_mem_cgroup)
 			return;
 
 		spin_lock(&vmpr->sr_lock);
_

Patches currently in -mm which might be from hughd@google.com are

mm-make-swapoff-more-robust-against-soft-dirty.patch

