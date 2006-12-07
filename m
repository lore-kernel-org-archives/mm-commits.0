From: akpm@osdl.org
Subject: - oom-can-panic-due-to-processes-stuck-in-__alloc_pages.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:57:00 -0800
Message-ID: <200612072257.kB7Mv0nF029254@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50648 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163593AbWLGW5p (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 17:57:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dev@openvz.org, den@sw.ru, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     OOM can panic due to processes stuck in __alloc_pages()
has been removed from the -mm tree.  Its filename was
     oom-can-panic-due-to-processes-stuck-in-__alloc_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: OOM can panic due to processes stuck in __alloc_pages()
From: Kirill Korotaev <dev@openvz.org>

OOM can panic due to the processes stuck in __alloc_pages() doing infinite
rebalance loop while no memory can be reclaimed.  OOM killer tries to kill
some processes, but unfortunetaly, rebalance label was moved by someone
below the TIF_MEMDIE check, so buddy allocator doesn't see that process is
OOM-killed and it can simply fail the allocation :/

Observed in reality on RHEL4(2.6.9)+OpenVZ kernel when a user doing some
memory allocation tricks triggered OOM panic.

Signed-off-by: Denis Lunev <den@sw.ru>
Signed-off-by: Kirill Korotaev <dev@openvz.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~oom-can-panic-due-to-processes-stuck-in-__alloc_pages mm/page_alloc.c
--- a/mm/page_alloc.c~oom-can-panic-due-to-processes-stuck-in-__alloc_pages
+++ a/mm/page_alloc.c
@@ -1180,6 +1180,7 @@ restart:
 
 	/* This allocation should allow future memory freeing. */
 
+rebalance:
 	if (((p->flags & PF_MEMALLOC) || unlikely(test_thread_flag(TIF_MEMDIE)))
 			&& !in_interrupt()) {
 		if (!(gfp_mask & __GFP_NOMEMALLOC)) {
@@ -1201,7 +1202,6 @@ nofail_alloc:
 	if (!wait)
 		goto nopage;
 
-rebalance:
 	cond_resched();
 
 	/* We now go into synchronous reclaim */
_

Patches currently in -mm which might be from dev@openvz.org are

origin.patch
add-process_session-helper-routine.patch
add-an-identifier-to-nsproxy.patch
rename-struct-pspace-to-struct-pid_namespace.patch
add-pid_namespace-to-nsproxy.patch
use-current-nsproxy-pid_ns.patch
add-child-reaper-to-pid_namespace.patch
move_task_off_dead_cpu-should-be-called-with-disabled-ints.patch

