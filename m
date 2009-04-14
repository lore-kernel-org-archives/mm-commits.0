From: akpm@linux-foundation.org
Subject: [merged] memcg-remove-warning-when-config_debug_vm=n.patch removed from -mm tree
Date: Tue, 14 Apr 2009 12:49:50 -0700
Message-ID: <200904141949.n3EJnoqb019826@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36329 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753076AbZDNTwB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Apr 2009 15:52:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     memcg: remove warning when CONFIG_DEBUG_VM=n
has been removed from the -mm tree.  Its filename was
     memcg-remove-warning-when-config_debug_vm=n.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: remove warning when CONFIG_DEBUG_VM=n
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

mm/memcontrol.c:318: warning: `mem_cgroup_is_obsolete' defined but not used

[akpm@linux-foundation.org: simplify as suggested by Balbir]
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-remove-warning-when-config_debug_vm=n mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-remove-warning-when-config_debug_vm=n
+++ a/mm/memcontrol.c
@@ -932,7 +932,7 @@ static int __mem_cgroup_try_charge(struc
 	if (unlikely(!mem))
 		return 0;
 
-	VM_BUG_ON(mem_cgroup_is_obsolete(mem));
+	VM_BUG_ON(!mem || mem_cgroup_is_obsolete(mem));
 
 	while (1) {
 		int ret;
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch

