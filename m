From: akpm@linux-foundation.org
Subject: [merged] memcg-null-dereference-on-allocation-failure.patch removed from -mm tree
Date: Tue, 16 Nov 2010 11:30:10 -0800
Message-ID: <201011161933.oAGJXMrr003101@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46461 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756309Ab0KPTde (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Nov 2010 14:33:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: error27@gmail.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcg: null dereference on allocation failure
has been removed from the -mm tree.  Its filename was
     memcg-null-dereference-on-allocation-failure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: null dereference on allocation failure
From: Dan Carpenter <error27@gmail.com>

The original code had a null dereference if alloc_percpu() failed.  This
was introduced in 711d3d2c9bc3 "memcg: cpu hotplug aware percpu count
updates"

Signed-off-by: Dan Carpenter <error27@gmail.com>
Reviewed-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff -puN mm/memcontrol.c~memcg-null-dereference-on-allocation-failure mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-null-dereference-on-allocation-failure
+++ a/mm/memcontrol.c
@@ -4208,15 +4208,17 @@ static struct mem_cgroup *mem_cgroup_all
 
 	memset(mem, 0, size);
 	mem->stat = alloc_percpu(struct mem_cgroup_stat_cpu);
-	if (!mem->stat) {
-		if (size < PAGE_SIZE)
-			kfree(mem);
-		else
-			vfree(mem);
-		mem = NULL;
-	}
+	if (!mem->stat)
+		goto out_free;
 	spin_lock_init(&mem->pcp_counter_lock);
 	return mem;
+
+out_free:
+	if (size < PAGE_SIZE)
+		kfree(mem);
+	else
+		vfree(mem);
+	return NULL;
 }
 
 /*
_

Patches currently in -mm which might be from error27@gmail.com are

linux-next.patch

