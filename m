From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-memcontrol-fix-possible-memcg-leak-due-to-interrupted-reclaim-fix.patch
 removed from -mm tree
Date: Tue, 29 Dec 2015 14:03:32 -0800
Message-ID: <56830334.1xug8TF2C1mayAdN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59691 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980AbbL2WDd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Dec 2015 17:03:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memcontrol-fix-possible-memcg-leak-due-to-interrupted-reclaim-fix
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-fix-possible-memcg-leak-due-to-interrupted-reclaim-fix.patch

This patch was dropped because it was folded into mm-memcontrol-fix-possible-memcg-leak-due-to-interrupted-reclaim.patch

------------------------------------------------------
From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: mm-memcontrol-fix-possible-memcg-leak-due-to-interrupted-reclaim-fix

Cc: Michal Hocko <mhocko@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-fix-possible-memcg-leak-due-to-interrupted-reclaim-fix mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-fix-possible-memcg-leak-due-to-interrupted-reclaim-fix
+++ a/mm/memcontrol.c
@@ -915,7 +915,7 @@ struct mem_cgroup *mem_cgroup_iter(struc
 			 * might block it. So we clear iter->position right
 			 * away.
 			 */
-			cmpxchg(&iter->position, pos, NULL);
+			(void)cmpxchg(&iter->position, pos, NULL);
 		}
 	}
 
@@ -962,7 +962,12 @@ struct mem_cgroup *mem_cgroup_iter(struc
 	}
 
 	if (reclaim) {
-		cmpxchg(&iter->position, pos, memcg);
+		/*
+		 * The position could have already been updated by a competing
+		 * thread, so check that the value hasn't changed since we read
+		 * it to avoid reclaiming from the same cgroup twice.
+		 */
+		(void)cmpxchg(&iter->position, pos, memcg);
 
 		/*
 		 * pairs with css_tryget when dereferencing iter->position
_

Patches currently in -mm which might be from vdavydov@virtuozzo.com are

mm-memcontrol-fix-possible-memcg-leak-due-to-interrupted-reclaim.patch
revert-kernfs-do-not-account-ino_ida-allocations-to-memcg.patch
revert-gfp-add-__gfp_noaccount.patch
memcg-only-account-kmem-allocations-marked-as-__gfp_account.patch
slab-add-slab_account-flag.patch
vmalloc-allow-to-account-vmalloc-to-memcg.patch
account-certain-kmem-allocations-to-memcg.patch
vmscan-do-not-force-scan-file-lru-if-its-absolute-size-is-small.patch
vmscan-do-not-force-scan-file-lru-if-its-absolute-size-is-small-v2.patch
memcg-do-not-allow-to-disable-tcp-accounting-after-limit-is-set.patch
mm-add-page_check_address_transhuge-helper.patch
mm-add-page_check_address_transhuge-helper-fix.patch
mm-memcontrol-allow-to-disable-kmem-accounting-for-cgroup2.patch
net-drop-tcp_memcontrolc.patch
mm-memcontrol-charge-swap-to-cgroup2.patch
mm-vmscan-pass-memcg-to-get_scan_count.patch
mm-memcontrol-replace-mem_cgroup_lruvec_online-with-mem_cgroup_online.patch
swaph-move-memcg-related-stuff-to-the-end-of-the-file.patch
mm-vmscan-do-not-scan-anon-pages-if-memcg-swap-limit-is-hit.patch
mm-free-swap-cache-aggressively-if-memcg-swap-is-full.patch
documentation-cgroup-add-memoryswapcurrentmax-description.patch

