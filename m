From: akpm@linux-foundation.org
Subject: +
 mm-memcontrol-replace-mem_cgroup_lruvec_online-with-mem_cgroup_online.patch added to -mm tree
Date: Thu, 17 Dec 2015 13:59:49 -0800
Message-ID: <56733055.y8XM4SQe0JSKHqcL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36713 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932828AbbLQV7u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Dec 2015 16:59:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: replace mem_cgroup_lruvec_online with mem_cgroup_online
has been added to the -mm tree.  Its filename is
     mm-memcontrol-replace-mem_cgroup_lruvec_online-with-mem_cgroup_online.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-replace-mem_cgroup_lruvec_online-with-mem_cgroup_online.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-replace-mem_cgroup_lruvec_online-with-mem_cgroup_online.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: mm: memcontrol: replace mem_cgroup_lruvec_online with mem_cgroup_online

mem_cgroup_lruvec_online() takes lruvec, but it only needs memcg.  Since
get_scan_count(), which is the only user of this function, now possesses
pointer to memcg, let's pass memcg directly to mem_cgroup_online() instead
of picking it out of lruvec and rename the function accordingly.

Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   27 ++++++++++-----------------
 mm/vmscan.c                |    2 +-
 2 files changed, 11 insertions(+), 18 deletions(-)

diff -puN include/linux/memcontrol.h~mm-memcontrol-replace-mem_cgroup_lruvec_online-with-mem_cgroup_online include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-memcontrol-replace-mem_cgroup_lruvec_online-with-mem_cgroup_online
+++ a/include/linux/memcontrol.h
@@ -355,6 +355,13 @@ static inline bool mem_cgroup_disabled(v
 	return !cgroup_subsys_enabled(memory_cgrp_subsys);
 }
 
+static inline bool mem_cgroup_online(struct mem_cgroup *memcg)
+{
+	if (mem_cgroup_disabled())
+		return true;
+	return !!(memcg->css.flags & CSS_ONLINE);
+}
+
 /*
  * For memory reclaim.
  */
@@ -363,20 +370,6 @@ int mem_cgroup_select_victim_node(struct
 void mem_cgroup_update_lru_size(struct lruvec *lruvec, enum lru_list lru,
 		int nr_pages);
 
-static inline bool mem_cgroup_lruvec_online(struct lruvec *lruvec)
-{
-	struct mem_cgroup_per_zone *mz;
-	struct mem_cgroup *memcg;
-
-	if (mem_cgroup_disabled())
-		return true;
-
-	mz = container_of(lruvec, struct mem_cgroup_per_zone, lruvec);
-	memcg = mz->memcg;
-
-	return !!(memcg->css.flags & CSS_ONLINE);
-}
-
 static inline
 unsigned long mem_cgroup_get_lru_size(struct lruvec *lruvec, enum lru_list lru)
 {
@@ -589,13 +582,13 @@ static inline bool mem_cgroup_disabled(v
 	return true;
 }
 
-static inline bool
-mem_cgroup_inactive_anon_is_low(struct lruvec *lruvec)
+static inline bool mem_cgroup_online(struct mem_cgroup *memcg)
 {
 	return true;
 }
 
-static inline bool mem_cgroup_lruvec_online(struct lruvec *lruvec)
+static inline bool
+mem_cgroup_inactive_anon_is_low(struct lruvec *lruvec)
 {
 	return true;
 }
diff -puN mm/vmscan.c~mm-memcontrol-replace-mem_cgroup_lruvec_online-with-mem_cgroup_online mm/vmscan.c
--- a/mm/vmscan.c~mm-memcontrol-replace-mem_cgroup_lruvec_online-with-mem_cgroup_online
+++ a/mm/vmscan.c
@@ -1997,7 +1997,7 @@ static void get_scan_count(struct lruvec
 	if (current_is_kswapd()) {
 		if (!zone_reclaimable(zone))
 			force_scan = true;
-		if (!mem_cgroup_lruvec_online(lruvec))
+		if (!mem_cgroup_online(memcg))
 			force_scan = true;
 	}
 	if (!global_reclaim(sc))
_

Patches currently in -mm which might be from vdavydov@virtuozzo.com are

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

