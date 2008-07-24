From: akpm@linux-foundation.org
Subject: - mm-remove-initialization-of-static-per-cpu-variables.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:24:28 -0700
Message-ID: <200807242324.m6ONOSYL010785@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59609 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755305AbYGXXYa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:24:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vegard.nossum@gmail.com, mm-commits@vger.kernel.org


The patch titled
     mm: remove initialization of static per-cpu variables
has been removed from the -mm tree.  Its filename was
     mm-remove-initialization-of-static-per-cpu-variables.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: remove initialization of static per-cpu variables
From: Vegard Nossum <vegard.nossum@gmail.com>

This was required by some old, no-longer-used gcc on sparc.

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/swap.c~mm-remove-initialization-of-static-per-cpu-variables mm/swap.c
--- a/mm/swap.c~mm-remove-initialization-of-static-per-cpu-variables
+++ a/mm/swap.c
@@ -34,9 +34,9 @@
 /* How many pages do we try to swap or page in/out together? */
 int page_cluster;
 
-static DEFINE_PER_CPU(struct pagevec, lru_add_pvecs) = { 0, };
-static DEFINE_PER_CPU(struct pagevec, lru_add_active_pvecs) = { 0, };
-static DEFINE_PER_CPU(struct pagevec, lru_rotate_pvecs) = { 0, };
+static DEFINE_PER_CPU(struct pagevec, lru_add_pvecs);
+static DEFINE_PER_CPU(struct pagevec, lru_add_active_pvecs);
+static DEFINE_PER_CPU(struct pagevec, lru_rotate_pvecs);
 
 /*
  * This path almost never happens for VM activity - pages are normally
@@ -493,7 +493,7 @@ EXPORT_SYMBOL(pagevec_lookup_tag);
  */
 #define ACCT_THRESHOLD	max(16, NR_CPUS * 2)
 
-static DEFINE_PER_CPU(long, committed_space) = 0;
+static DEFINE_PER_CPU(long, committed_space);
 
 void vm_acct_memory(long pages)
 {
_

Patches currently in -mm which might be from vegard.nossum@gmail.com are

origin.patch
linux-next.patch
parisc-fix-incomplete-header-guard.patch
kallsyms-fix-potential-overflow-in-binary-search.patch
kallsyms-unify-32-and-64-bit-code.patch
quota-cleanup-loop-in-sync_dquots.patch
quota-move-function-macros-from-quotah-to-quotaopsh-fix.patch
workqueues-make-get_online_cpus-useable-for-work-func.patch
workqueues-make-get_online_cpus-useable-for-work-func-fix.patch
s390-topology-dont-use-kthread-for-arch_reinit_sched_domains.patch
taskstats-remove-initialization-of-static-per-cpu-variable.patch

