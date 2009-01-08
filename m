From: akpm@linux-foundation.org
Subject: - memcg-swapout-refcnt-fix.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:48:58 -0800
Message-ID: <200901082248.n08MmwT5028265@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59764 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761197AbZAHW65 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:58:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, hugh@veritas.com, kosaki.motohiro@jp.fujitsu.com, lizf@cn.fujitsu.com, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcg: swapout refcnt fix
has been removed from the -mm tree.  Its filename was
     memcg-swapout-refcnt-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: swapout refcnt fix
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

css's refcnt is dropped before end of following access.
Hold it until end of access.

Reported-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-swapout-refcnt-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-swapout-refcnt-fix
+++ a/mm/memcontrol.c
@@ -1171,7 +1171,9 @@ __mem_cgroup_uncharge_common(struct page
 	mz = page_cgroup_zoneinfo(pc);
 	unlock_page_cgroup(pc);
 
-	css_put(&mem->css);
+	/* at swapout, this memcg will be accessed to record to swap */
+	if (ctype != MEM_CGROUP_CHARGE_TYPE_SWAPOUT)
+		css_put(&mem->css);
 
 	return mem;
 
@@ -1212,6 +1214,8 @@ void mem_cgroup_uncharge_swapcache(struc
 		swap_cgroup_record(ent, memcg);
 		mem_cgroup_get(memcg);
 	}
+	if (memcg)
+		css_put(&memcg->css);
 }
 
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch

