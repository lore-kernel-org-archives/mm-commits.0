From: akpm@linux-foundation.org
Subject: - cfs-mark-print_cfs_stats-static.patch removed from -mm tree
Date: Wed, 08 Aug 2007 12:07:19 -0700
Message-ID: <200708081907.l78J7J9k025786@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46043 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753047AbXHHTIN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Aug 2007 15:08:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: josh@kernel.org, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     CFS: mark print_cfs_stats static
has been removed from the -mm tree.  Its filename was
     cfs-mark-print_cfs_stats-static.patch

This patch was dropped because Changes in Ingo's tree destroyed it

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

allow-rcutorture-to-handle-synchronize_sched.patch
git-sched.patch
immunize-rcu_dereference-against-crazy-compiler-writers.patch
i386-mark-pit_clockevent-static.patch
cfs-mark-print_cfs_stats-static.patch
