From: akpm@linux-foundation.org
Subject: + cfs-mark-print_cfs_stats-static.patch added to -mm tree
Date: Fri, 20 Jul 2007 13:42:49 -0700
Message-ID: <200707202042.l6KKgnLS015519@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58294 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755893AbXGTUn2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 16:43:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: josh@kernel.org, mingo@elte.hu


The patch titled
     CFS: mark print_cfs_stats static
has been added to the -mm tree.  Its filename is
     cfs-mark-print_cfs_stats-static.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: CFS: mark print_cfs_stats static
From: Josh Triplett <josh@kernel.org>

sched_fair.c defines print_cfs_stats, and sched_debug.c uses it, but sched.c
includes both sched_fair.c and sched_debug.c, so all the references to
print_cfs_stats occur in the same compilation unit.  Thus, mark
print_cfs_stats static.

Eliminates a sparse warning:
warning: symbol 'print_cfs_stats' was not declared. Should it be static?

Signed-off-by: Josh Triplett <josh@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched_fair.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/sched_fair.c~cfs-mark-print_cfs_stats-static kernel/sched_fair.c
--- a/kernel/sched_fair.c~cfs-mark-print_cfs_stats-static
+++ a/kernel/sched_fair.c
@@ -1120,7 +1120,7 @@ struct sched_class fair_sched_class __re
 };
 
 #ifdef CONFIG_SCHED_DEBUG
-void print_cfs_stats(struct seq_file *m, int cpu, u64 now)
+static void print_cfs_stats(struct seq_file *m, int cpu, u64 now)
 {
 	struct rq *rq = cpu_rq(cpu);
 	struct cfs_rq *cfs_rq;
_

Patches currently in -mm which might be from josh@kernel.org are

origin.patch
immunize-rcu_dereference-against-crazy-compiler-writers.patch
i386-include-asm-bugsh-in-bugsc-for-check_bugs-prototype.patch
x86_64-include-asm-bugsh-in-bugsc-for-check_bugs.patch
mark-sysrq_sched_debug_show-static.patch
i386-mark-pit_clockevent-static.patch
cfs-mark-print_cfs_stats-static.patch
