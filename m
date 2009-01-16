From: akpm@linux-foundation.org
Subject: [merged] memcg-fix-section-mismatch.patch removed from -mm tree
Date: Fri, 16 Jan 2009 11:17:58 -0800
Message-ID: <200901161917.n0GJHwCK026570@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48471 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935771AbZAPTSW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Jan 2009 14:18:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, rakib.mullick@gmail.com, mm-commits@vger.kernel.org


The patch titled
     memcg: fix section mismatch
has been removed from the -mm tree.  Its filename was
     memcg-fix-section-mismatch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: fix section mismatch
From: Li Zefan <lizf@cn.fujitsu.com>

At system boot when creating the top cgroup, mem_cgroup_create() calls
enable_swap_cgroup() which is marked as __init, so mark
mem_cgroup_create() as __ref to avoid false section mismatch warning.

Reported-by: Rakib Mullick <rakib.mullick@gmail.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by; KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-fix-section-mismatch mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-section-mismatch
+++ a/mm/memcontrol.c
@@ -2202,7 +2202,7 @@ static void __init enable_swap_cgroup(vo
 }
 #endif
 
-static struct cgroup_subsys_state *
+static struct cgroup_subsys_state * __ref
 mem_cgroup_create(struct cgroup_subsys *ss, struct cgroup *cont)
 {
 	struct mem_cgroup *mem, *parent;
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
memcg-get-put-parents-at-create-free.patch
linux-next.patch
relax-ns_can_attach-checks-to-allow-attaching-to-grandchild-cgroups.patch

