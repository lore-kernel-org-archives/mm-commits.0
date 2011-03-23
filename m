From: akpm@linux-foundation.org
Subject: [folded] memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages-update.patch removed from -mm tree
Date: Wed, 23 Mar 2011 16:18:50 -0700
Message-ID: <201103232318.p2NNIoRq004226@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48467 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933183Ab1CWXTC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 19:19:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nishimura@mxp.nes.nec.co.jp, balbir@linux.vnet.ibm.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, mm-commits@vger.kernel.org


The patch titled
     memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages-update
has been removed from the -mm tree.  Its filename was
     memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages-update.patch

This patch was dropped because it was folded into memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages-update
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

try to show the path name of the cgroup too

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff -puN mm/memcontrol.c~memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages-update mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages-update
+++ a/mm/memcontrol.c
@@ -3070,9 +3070,25 @@ void mem_cgroup_print_bad_page(struct pa
 	struct page_cgroup *pc;
 
 	pc = lookup_page_cgroup_used(page);
-	if (pc)
-		printk(KERN_ALERT "pc:%p pc->flags:%ld pc->mem_cgroup:%p\n",
+	if (pc) {
+		int ret = -1;
+		char *path;
+
+		printk(KERN_ALERT "pc:%p pc->flags:%ld pc->mem_cgroup:%p",
 		       pc, pc->flags, pc->mem_cgroup);
+
+		path = kmalloc(PATH_MAX, GFP_KERNEL);
+		if (path) {
+			rcu_read_lock();
+			ret = cgroup_path(pc->mem_cgroup->css.cgroup,
+							path, PATH_MAX);
+			rcu_read_unlock();
+		}
+
+		printk(KERN_ALERT "(%s)\n",
+				(ret < 0) ? "cannot get the path" : path);
+		kfree(path);
+	}
 }
 #endif
 
_

Patches currently in -mm which might be from nishimura@mxp.nes.nec.co.jp are

memcg-fix-ugly-initialization-of-return-value-is-in-caller.patch
memcg-soft-limit-reclaim-should-end-at-limit-not-below.patch
memcg-simplify-the-way-memory-limits-are-checked.patch
memcg-remove-unused-page-flag-bitfield-defines.patch
memcg-remove-impossible-conditional-when-committing.patch
memcg-remove-null-check-from-lookup_page_cgroup-result.patch
memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages.patch
memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages-update-fix.patch
memcg-no-uncharged-pages-reach-page_cgroup_zoneinfo.patch
memcg-change-page_cgroup_zoneinfo-signature.patch
memcg-change-page_cgroup_zoneinfo-signature-fix.patch
memcg-fold-__mem_cgroup_move_account-into-caller.patch
memcg-condense-page_cgroup-to-page-lookup-points.patch
memcg-remove-direct-page_cgroup-to-page-pointer.patch
memcg-remove-direct-page_cgroup-to-page-pointer-fix.patch
memcg-charged-pages-always-have-valid-per-memcg-zone-info.patch
memcg-remove-memcg-reclaim_param_lock.patch
memcg-keep-only-one-charge-cancelling-function.patch
memcg-keep-only-one-charge-cancelling-function-fix.patch
memcg-convert-per-cpu-stock-from-bytes-to-page-granularity.patch
memcg-convert-uncharge-batching-from-bytes-to-page-granularity.patch
memcg-unify-charge-uncharge-quantities-to-units-of-pages.patch
memcg-break-out-event-counters-from-other-stats.patch
memcg-use-native-word-page-statistics-counters.patch
memcg-use-native-word-page-statistics-counters-fix-event-counter-breakage-with-thp.patch
mm-memcontrolc-suppress-uninitializer-var-warning-with-older-gccs.patch
memcg-fix-leak-on-wrong-lru-with-fuse.patch
memcg-give-current-access-to-memory-reserves-if-its-trying-to-die.patch

