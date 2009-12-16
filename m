From: akpm@linux-foundation.org
Subject: [folded] memcg-coalesce-charging-via-percpu-storage-fix.patch removed from -mm tree
Date: Tue, 15 Dec 2009 16:35:11 -0800
Message-ID: <200912160035.nBG0ZBCa023682@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34774 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761443AbZLPAfz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 19:35:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcg-coalescing-charge-by-percpu-fix
has been removed from the -mm tree.  Its filename was
     memcg-coalesce-charging-via-percpu-storage-fix.patch

This patch was dropped because it was folded into memcg-coalesce-charging-via-percpu-storage.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg-coalescing-charge-by-percpu-fix
From: Andrew Morton <akpm@linux-foundation.org>

tweak comments

Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN mm/memcontrol.c~memcg-coalesce-charging-via-percpu-storage-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-coalesce-charging-via-percpu-storage-fix
+++ a/mm/memcontrol.c
@@ -1301,8 +1301,7 @@ static bool consume_stock(struct mem_cgr
 }
 
 /*
- * Retruens stocks cached in percpu to res_counter and reset
- * cached information.
+ * Returns stocks cached in percpu to res_counter and reset cached information.
  */
 static void drain_stock(struct memcg_stock_pcp *stock)
 {
@@ -1331,7 +1330,6 @@ static void drain_local_stock(struct wor
  * Cache charges(val) which is from res_counter, to local per_cpu area.
  * This will be consumed by consumt_stock() function, later.
  */
-
 static void refill_stock(struct mem_cgroup *mem, int val)
 {
 	struct memcg_stock_pcp *stock = &get_cpu_var(memcg_stock);
@@ -1350,7 +1348,6 @@ static void refill_stock(struct mem_cgro
  * expects some charges will be back to res_counter later but cannot wait for
  * it.
  */
