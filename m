From: akpm@linux-foundation.org
Subject: + mm-swap-token-add-a-comment-for-priority-aging.patch added to -mm tree
Date: Fri, 03 Jun 2011 14:15:20 -0700
Message-ID: <201106032115.p53LFKDG008106@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57392 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756473Ab1FCVPY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Jun 2011 17:15:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, riel@redhat.com


The patch titled
     mm: swap-token: add a comment for priority aging
has been added to the -mm tree.  Its filename is
     mm-swap-token-add-a-comment-for-priority-aging.patch

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
mm-swap-token-add-a-comment-for-priority-aging.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-2.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily.patch
cpumask-convert-for_each_cpumask-with-for_each_cpu.patch
cpumask-alloc_cpumask_var-use-numa_no_node.patch
cpumask-add-cpumask_var_t-documentation.patch
kexec-remove-kmsg_dump_kexec.patch
kexec-remove-kmsg_dump_kexec-fix.patch

