From: akpm@linux-foundation.org
Subject: [merged] mm-swap-token-makes-global-variables-to-function-local.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:52:33 -0700
Message-ID: <201107260751.p6Q7pa9Y002965@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57274 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751892Ab1GZHwM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:52:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm: swap-token: makes global variables to function local
has been removed from the -mm tree.  Its filename was
     mm-swap-token-makes-global-variables-to-function-local.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: swap-token: makes global variables to function local
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

global_faults and last_aging are only used in grab_swap_token().  Move
them into grab_swap_token().

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/thrash.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/thrash.c~mm-swap-token-makes-global-variables-to-function-local mm/thrash.c
--- a/mm/thrash.c~mm-swap-token-makes-global-variables-to-function-local
+++ a/mm/thrash.c
@@ -30,8 +30,6 @@
 static DEFINE_SPINLOCK(swap_token_lock);
 struct mm_struct *swap_token_mm;
 struct mem_cgroup *swap_token_memcg;
-static unsigned int global_faults;
-static unsigned int last_aging;
 
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR
 static struct mem_cgroup *swap_token_memcg_from_mm(struct mm_struct *mm)
@@ -55,6 +53,8 @@ void grab_swap_token(struct mm_struct *m
 {
 	int current_interval;
 	unsigned int old_prio = mm->token_priority;
+	static unsigned int global_faults;
+	static unsigned int last_aging;
 
 	global_faults++;
 
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
linux-next.patch
slab-use-numa_no_node.patch
memcg-export-memory-cgroups-swappiness-with-mem_cgroup_swappiness.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-2.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily.patch
proc-pid-fdinfo-add-cloexec-information.patch
proc-pid-fdinfo-add-cloexec-information-fix.patch
cpumask-convert-for_each_cpumask-with-for_each_cpu.patch
cpumask-alloc_cpumask_var-use-numa_no_node.patch
cpumask-add-cpumask_var_t-documentation.patch
kexec-remove-kmsg_dump_kexec.patch

