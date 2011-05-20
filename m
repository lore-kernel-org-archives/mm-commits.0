From: akpm@linux-foundation.org
Subject: + memcg-reclaim-memory-from-nodes-in-round-robin-order-fix.patch added to -mm tree
Date: Fri, 20 May 2011 13:12:50 -0700
Message-ID: <201105202012.p4KKCoA4028027@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44398 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757050Ab1ETUNC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 May 2011 16:13:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yinghan@google.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg-reclaim-memory-from-nodes-in-round-robin-order-fix
has been added to the -mm tree.  Its filename is
     memcg-reclaim-memory-from-nodes-in-round-robin-order-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg-reclaim-memory-from-nodes-in-round-robin-order-fix
From: Ying Han <yinghan@google.com>

The value for counter base should be initialized. If not,
this returns wrong value.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-reclaim-memory-from-nodes-in-round-robin-order-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-reclaim-memory-from-nodes-in-round-robin-order-fix
+++ a/mm/memcontrol.c
@@ -633,7 +633,7 @@ static unsigned long
 mem_cgroup_get_zonestat_node(struct mem_cgroup *mem, int nid, enum lru_list idx)
 {
 	struct mem_cgroup_per_zone *mz;
-	u64 total;
+	u64 total = 0;
 	int zid;
 
 	for (zid = 0; zid < MAX_NR_ZONES; zid++) {
_

Patches currently in -mm which might be from yinghan@google.com are

vmscan-change-shrink_slab-interfaces-by-passing-shrink_control.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control-fix.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control-fix-2.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-2.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-3.patch
mm-move-enum-vm_event_item-into-a-standalone-header-file.patch
memcg-count-the-soft_limit-reclaim-in-global-background-reclaim.patch
memcg-add-the-soft_limit-reclaim-in-global-direct-reclaim.patch
memcg-reclaim-memory-from-nodes-in-round-robin-order.patch
memcg-reclaim-memory-from-nodes-in-round-robin-fix.patch
memcg-reclaim-memory-from-nodes-in-round-robin-fix-2.patch
memcg-reclaim-memory-from-nodes-in-round-robin-order-fix.patch
memcg-fix-get_scan_count-for-small-targets.patch
memcg-remove-unused-retry-signal-from-reclaim.patch

