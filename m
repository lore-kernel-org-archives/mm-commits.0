From: akpm@linux-foundation.org
Subject: + memcg-use-zalloc-rather-than-mallocmemset.patch added to -mm tree
Date: Mon, 08 Nov 2010 16:21:41 -0800
Message-ID: <201011090021.oA90Lfqh018385@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39221 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754686Ab0KIAWl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Nov 2010 19:22:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jj@chaosbits.net, balbir@linux.vnet.ibm.com, fengguang.wu@intel.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, minchan.kim@gmail.com


The patch titled
     memcg: use [kv]zalloc[_node] rather than [kv]malloc+memset
has been added to the -mm tree.  Its filename is
     memcg-use-zalloc-rather-than-mallocmemset.patch

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
Subject: memcg: use [kv]zalloc[_node] rather than [kv]malloc+memset
From: Jesper Juhl <jj@chaosbits.net>

In mem_cgroup_alloc() we currently do either kmalloc() or vmalloc() then
followed by memset() to zero the memory.  This can be more efficiently
achieved by using kzalloc() and vzalloc().  There's also one situation
where we can use kzalloc_node() - this is what's new in this version of
the patch.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff -puN mm/memcontrol.c~memcg-use-zalloc-rather-than-mallocmemset mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-use-zalloc-rather-than-mallocmemset
+++ a/mm/memcontrol.c
@@ -4622,13 +4622,11 @@ static int alloc_mem_cgroup_per_zone_inf
 	 */
 	if (!node_state(node, N_NORMAL_MEMORY))
 		tmp = -1;
-	pn = kmalloc_node(sizeof(*pn), GFP_KERNEL, tmp);
+	pn = kzalloc_node(sizeof(*pn), GFP_KERNEL, tmp);
 	if (!pn)
 		return 1;
 
 	mem->info.nodeinfo[node] = pn;
-	memset(pn, 0, sizeof(*pn));
-
 	for (zone = 0; zone < MAX_NR_ZONES; zone++) {
 		mz = &pn->zoneinfo[zone];
 		for_each_lru(l)
@@ -4652,14 +4650,13 @@ static struct mem_cgroup *mem_cgroup_all
 
 	/* Can be very big if MAX_NUMNODES is very big */
 	if (size < PAGE_SIZE)
-		mem = kmalloc(size, GFP_KERNEL);
+		mem = kzalloc(size, GFP_KERNEL);
 	else
-		mem = vmalloc(size);
+		mem = vzalloc(size);
 
 	if (!mem)
 		return NULL;
 
-	memset(mem, 0, size);
 	mem->stat = alloc_percpu(struct mem_cgroup_stat_cpu);
 	if (!mem->stat)
 		goto out_free;
_

Patches currently in -mm which might be from jj@chaosbits.net are

origin.patch
memcg-use-zalloc-rather-than-mallocmemset.patch
kernel-profilec-use-vzalloc.patch

