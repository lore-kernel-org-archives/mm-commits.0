From: akpm@linux-foundation.org
Subject: [merged] mm-swap-token-add-a-comment-for-priority-aging.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:52:35 -0700
Message-ID: <201107260751.p6Q7pc1p002968@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49783 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751892Ab1GZHwN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:52:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm: swap-token: add a comment for priority aging
has been removed from the -mm tree.  Its filename was
     mm-swap-token-add-a-comment-for-priority-aging.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: swap-token: add a comment for priority aging
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Docuemnt some swap token aging design decisions.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/thrash.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN mm/thrash.c~mm-swap-token-add-a-comment-for-priority-aging mm/thrash.c
--- a/mm/thrash.c~mm-swap-token-add-a-comment-for-priority-aging
+++ a/mm/thrash.c
@@ -67,6 +67,17 @@ void grab_swap_token(struct mm_struct *m
 	if (!swap_token_mm)
 		goto replace_token;
 
+	/*
+	 * Usually, we don't need priority aging because long interval faults
+	 * makes priority decrease quickly. But there is one exception. If the
+	 * token owner task is sleeping, it never make long interval faults.
+	 * Thus, we need a priority aging mechanism instead. The requirements
+	 * of priority aging are
+	 *  1) An aging interval is reasonable enough long. Too short aging
+	 *     interval makes quick swap token lost and decrease performance.
+	 *  2) The swap token owner task have to get priority aging even if
+	 *     it's under sleep.
+	 */
 	if ((global_faults - last_aging) > TOKEN_AGING_INTERVAL) {
 		swap_token_mm->token_priority /= 2;
 		last_aging = global_faults;
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

