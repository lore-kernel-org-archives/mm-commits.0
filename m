From: akpm@linux-foundation.org
Subject: - mark-sysrq_sched_debug_show-static.patch removed from -mm tree
Date: Sat, 28 Jul 2007 23:13:33 -0700
Message-ID: <200707290613.l6T6DXZu011208@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58912 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759312AbXG2GXv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jul 2007 02:23:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: josh@kernel.org, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     Mark sysrq_sched_debug_show static
has been removed from the -mm tree.  Its filename was
     mark-sysrq_sched_debug_show-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Mark sysrq_sched_debug_show static
From: Josh Triplett <josh@kernel.org>

Only sched.c uses sysrq_sched_debug_show, and sched.c includes sched_debug.c,
so all uses of sysrq_sched_debug_show occur in the same source file.

Eliminates a sparse warning:
warning: symbol 'sysrq_sched_debug_show' was not declared. Should it be static?

Signed-off-by: Josh Triplett <josh@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched_debug.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/sched_debug.c~mark-sysrq_sched_debug_show-static kernel/sched_debug.c
--- a/kernel/sched_debug.c~mark-sysrq_sched_debug_show-static
+++ a/kernel/sched_debug.c
@@ -186,7 +186,7 @@ static int sched_debug_show(struct seq_f
 	return 0;
 }
 
-void sysrq_sched_debug_show(void)
+static void sysrq_sched_debug_show(void)
 {
 	sched_debug_show(NULL, NULL);
 }
_

Patches currently in -mm which might be from josh@kernel.org are

origin.patch
immunize-rcu_dereference-against-crazy-compiler-writers.patch
i386-include-asm-bugsh-in-bugsc-for-check_bugs-prototype.patch
x86_64-include-asm-bugsh-in-bugsc-for-check_bugs.patch
i386-mark-pit_clockevent-static.patch
cfs-mark-print_cfs_stats-static.patch
