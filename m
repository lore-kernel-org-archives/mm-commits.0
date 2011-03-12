From: akpm@linux-foundation.org
Subject: [to-be-updated] memcg-add-dirty-limits-to-mem_cgroup-correct-memcg_hierarchical_free_pages-return-type.patch removed from -mm tree
Date: Fri, 11 Mar 2011 16:50:24 -0800
Message-ID: <201103120050.p2C0oOq3005650@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44740 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753673Ab1CLAvS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Mar 2011 19:51:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gthelen@google.com, arighi@develer.com, balbir@linux.vnet.ibm.com, fengguang.wu@intel.com, hannes@cmpxchg.org, hidave.darkstar@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@g


The patch titled
     memcg: correct memcg_hierarchical_free_pages() return type
has been removed from the -mm tree.  Its filename was
     memcg-add-dirty-limits-to-mem_cgroup-correct-memcg_hierarchical_free_pages-return-type.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: correct memcg_hierarchical_free_pages() return type
From: Greg Thelen <gthelen@google.com>

memcg_hierarchical_free_pages() returns a page count and thus should
return unsigned long to be consistent with the rest of mm code.

Signed-off-by: Greg Thelen <gthelen@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Dave Young <hidave.darkstar@gmail.com>
Cc: Andrea Righi <arighi@develer.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-add-dirty-limits-to-mem_cgroup-correct-memcg_hierarchical_free_pages-return-type mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-add-dirty-limits-to-mem_cgroup-correct-memcg_hierarchical_free_pages-return-type
+++ a/mm/memcontrol.c
@@ -1316,7 +1316,7 @@ static s64 mem_cgroup_local_page_stat(st
  * use_hierarchy is set, then this involves parent mem cgroups to find the
  * cgroup with the smallest free space.
  */
-static unsigned long long
+static unsigned long
 memcg_hierarchical_free_pages(struct mem_cgroup *mem)
 {
 	unsigned long free, min_free;
_

Patches currently in -mm which might be from gthelen@google.com are

linux-next.patch
memcg-res_counter_read_u64-fix-potential-races-on-32-bit-machines.patch
memcg-break-out-event-counters-from-other-stats.patch
memcg-use-native-word-page-statistics-counters.patch
mm-memcontrolc-suppress-uninitializer-var-warning-with-older-gccs.patch
memcg-document-cgroup-dirty-memory-interfaces.patch
memcg-add-page_cgroup-flags-for-dirty-page-tracking.patch

