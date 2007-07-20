From: akpm@linux-foundation.org
Subject: + mark-sysrq_sched_debug_show-static.patch added to -mm tree
Date: Fri, 20 Jul 2007 13:42:45 -0700
Message-ID: <200707202042.l6KKgj3h015506@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48389 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756145AbXGTUn2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 16:43:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: josh@kernel.org, mingo@elte.hu


The patch titled
     Mark sysrq_sched_debug_show static
has been added to the -mm tree.  Its filename is
     mark-sysrq_sched_debug_show-static.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
mark-sysrq_sched_debug_show-static.patch
i386-mark-pit_clockevent-static.patch
cfs-mark-print_cfs_stats-static.patch
