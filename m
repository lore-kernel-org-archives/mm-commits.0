From: akpm@linux-foundation.org
Subject: [folded-merged] sched-proc-sched_debug-fails-on-very-very-large-machines-v2.patch removed from -mm tree
Date: Thu, 21 Feb 2013 15:14:12 -0800
Message-ID: <20130221231412.CA1A231C016@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:56775 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754762Ab3BUXOO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Feb 2013 18:14:14 -0500
Received: by mail-vb0-f74.google.com with SMTP id r6so9855vbi.3
        for <mm-commits@vger.kernel.org>; Thu, 21 Feb 2013 15:14:13 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nzimmer@sgi.com, davej@redhat.com, mingo@redhat.com, peterz@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: sched-proc-sched_debug-fails-on-very-very-large-machines-v2
has been removed from the -mm tree.  Its filename was
     sched-proc-sched_debug-fails-on-very-very-large-machines-v2.patch

This patch was dropped because it was folded into sched-proc-sched_debug-fails-on-very-very-large-machines.patch

------------------------------------------------------
From: Nathan Zimmer <nzimmer@sgi.com>
Subject: sched-proc-sched_debug-fails-on-very-very-large-machines-v2

v2: Took suggetion for adding comments

Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Jones <davej@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched/debug.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN kernel/sched/debug.c~sched-proc-sched_debug-fails-on-very-very-large-machines-v2 kernel/sched/debug.c
--- a/kernel/sched/debug.c~sched-proc-sched_debug-fails-on-very-very-large-machines-v2
+++ a/kernel/sched/debug.c
@@ -406,6 +406,13 @@ void sysrq_sched_debug_show(void)
 
 }
 
+/*
+ * This itererator needs some explination.
+ * It returns 1 for the header position.
+ * This means 2 is cpu 0.
+ * In a hotplugged system some cpus, including cpu 0, may be missing so we have
+ * to use cpumask_* to iterate over the cpus.
+ */
 static void *sched_debug_start(struct seq_file *file, loff_t *offset)
 {
 	unsigned long n = *offset;
_

Patches currently in -mm which might be from nzimmer@sgi.com are

sched-proc-sched_stat-fails-on-very-very-large-machines.patch
sched-proc-sched_debug-fails-on-very-very-large-machines.patch
sched-proc-sched_debug-fails-on-very-very-large-machines-v2-fix.patch

