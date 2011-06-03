From: akpm@linux-foundation.org
Subject: + mm-swap-token-makes-global-variables-to-function-local.patch added to -mm tree
Date: Fri, 03 Jun 2011 14:09:16 -0700
Message-ID: <201106032109.p53L9GlA007758@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38796 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756454Ab1FCVJy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Jun 2011 17:09:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, riel@redhat.com


The patch titled
     mm: swap-token: makes global variables to function local
has been added to the -mm tree.  Its filename is
     mm-swap-token-makes-global-variables-to-function-local.patch

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

vmscanmemcg-memcg-aware-swap-token.patch
vmscanmemcg-memcg-aware-swap-token-fix.patch
vmscanmemcg-memcg-aware-swap-token-fix-checkpatch-fixes.patch
vmscan-implement-swap-token-trace.patch
vmscan-implement-swap-token-priority-aging.patch
memcg-add-documentation-for-the-memorynumastat-api.patch
memcg-add-documentation-for-the-memorynumastat-api-fix.patch
mm-increase-reclaim_distance-to-30.patch
slab-use-numa_no_node.patch
mm-swap-token-fix-dead-link.patch
mm-swap-token-makes-global-variables-to-function-local.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-2.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily.patch
cpumask-convert-for_each_cpumask-with-for_each_cpu.patch
cpumask-alloc_cpumask_var-use-numa_no_node.patch
cpumask-add-cpumask_var_t-documentation.patch
kexec-remove-kmsg_dump_kexec.patch
kexec-remove-kmsg_dump_kexec-fix.patch

