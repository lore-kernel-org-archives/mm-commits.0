From: akpm@linux-foundation.org
Subject: [merged] memcg-null-pointer-dereference-at-rmdir-on-some-numa-systems-v2.patch removed from -mm tree
Date: Fri, 30 Jan 2009 11:14:01 -0800
Message-ID: <200901301914.n0UJE1pc026824@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36719 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753030AbZA3TOh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Jan 2009 14:14:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com, lizf@cn.fujitsu.com, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcg: NULL pointer dereference at rmdir on some NUMA systems
has been removed from the -mm tree.  Its filename was
     memcg-null-pointer-dereference-at-rmdir-on-some-numa-systems-v2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: NULL pointer dereference at rmdir on some NUMA systems
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

N_POSSIBLE doesn't means there is memory...and force_empty can
visit invalid node which have no pgdat.

To visit all valid nodes, N_HIGH_MEMORY should be used.

Reported-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Tested-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-null-pointer-dereference-at-rmdir-on-some-numa-systems-v2 mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-null-pointer-dereference-at-rmdir-on-some-numa-systems-v2
+++ a/mm/memcontrol.c
@@ -1685,7 +1685,7 @@ move_account:
 		/* This is for making all *used* pages to be on LRU. */
 		lru_add_drain_all();
 		ret = 0;
-		for_each_node_state(node, N_POSSIBLE) {
+		for_each_node_state(node, N_HIGH_MEMORY) {
 			for (zid = 0; !ret && zid < MAX_NR_ZONES; zid++) {
 				enum lru_list l;
 				for_each_lru(l) {
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-checkpatch-fixes.patch

