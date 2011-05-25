From: akpm@linux-foundation.org
Subject: [merged] memsw-remove-noswapaccount-kernel-parameter.patch removed from -mm tree
Date: Wed, 25 May 2011 13:30:27 -0700
Message-ID: <201105252028.p4PKSojI014784@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45322 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756529Ab1EYUtI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:49:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, balbir@linux.vnet.ibm.com, kamezawa.hiroyuki@gmail.com, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     memsw: remove noswapaccount kernel parameter
has been removed from the -mm tree.  Its filename was
     memsw-remove-noswapaccount-kernel-parameter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memsw: remove noswapaccount kernel parameter
From: Michal Hocko <mhocko@suse.cz>

The noswapaccount parameter has been deprecated since 2.6.38 without any
complaints from users so we can remove it.  swapaccount=0|1 can be used
instead.

As we are removing the parameter we can also clean up swapaccount because
it doesn't have to accept an empty string anymore (to match noswapaccount)
and so we can push = into __setup macro rather than checking "=1" resp. 
"=0" strings

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    3 ---
 mm/memcontrol.c                     |   13 +++----------
 2 files changed, 3 insertions(+), 13 deletions(-)

diff -puN Documentation/kernel-parameters.txt~memsw-remove-noswapaccount-kernel-parameter Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~memsw-remove-noswapaccount-kernel-parameter
+++ a/Documentation/kernel-parameters.txt
@@ -1777,9 +1777,6 @@ bytes respectively. Such letter suffixes
 
 	nosoftlockup	[KNL] Disable the soft-lockup detector.
 
-	noswapaccount	[KNL] Disable accounting of swap in memory resource
-			controller. (See Documentation/cgroups/memory.txt)
-
 	nosync		[HW,M68K] Disables sync negotiation for all devices.
 
 	notsc		[BUGS=X86-32] Disable Time Stamp Counter
diff -puN mm/memcontrol.c~memsw-remove-noswapaccount-kernel-parameter mm/memcontrol.c
--- a/mm/memcontrol.c~memsw-remove-noswapaccount-kernel-parameter
+++ a/mm/memcontrol.c
@@ -5169,19 +5169,12 @@ struct cgroup_subsys mem_cgroup_subsys =
 static int __init enable_swap_account(char *s)
 {
 	/* consider enabled if no parameter or 1 is given */
-	if (!(*s) || !strcmp(s, "=1"))
+	if (!strcmp(s, "1"))
 		really_do_swap_account = 1;
-	else if (!strcmp(s, "=0"))
+	else if (!strcmp(s, "0"))
 		really_do_swap_account = 0;
 	return 1;
 }
-__setup("swapaccount", enable_swap_account);
+__setup("swapaccount=", enable_swap_account);
 
-static int __init disable_swap_account(char *s)
-{
-	printk_once("noswapaccount is deprecated and will be removed in 2.6.40. Use swapaccount=0 instead\n");
-	enable_swap_account("=0");
-	return 1;
-}
-__setup("noswapaccount", disable_swap_account);
 #endif
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
memcg-add-the-soft_limit-reclaim-in-global-direct-reclaim.patch
memcg-remove-pointless-next_mz-nullification-in-mem_cgroup_soft_limit_reclaim.patch
memcg-mark-init_section_page_cgroup-properly.patch
memcg-fix-off-by-one-when-calculating-swap-cgroup-map-length.patch
memcg-move-page-freeing-code-out-of-lock.patch
maintainers-add-mm-page_cgroupc-into-memcg-subsystem.patch
memcg-remove-unused-retry-signal-from-reclaim.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily-fix.patch

