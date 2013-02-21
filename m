From: akpm@linux-foundation.org
Subject: [folded-merged] sched-proc-sched_stat-fails-on-very-very-large-machines-v2.patch removed from -mm tree
Date: Thu, 21 Feb 2013 15:13:11 -0800
Message-ID: <20130221231311.E1C8131C016@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:45310 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890Ab3BUXNN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Feb 2013 18:13:13 -0500
Received: by mail-ye0-f202.google.com with SMTP id q5so10046yen.1
        for <mm-commits@vger.kernel.org>; Thu, 21 Feb 2013 15:13:12 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nzimmer@sgi.com, davej@redhat.com, mingo@redhat.com, peterz@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: sched-proc-sched_stat-fails-on-very-very-large-machines-v2
has been removed from the -mm tree.  Its filename was
     sched-proc-sched_stat-fails-on-very-very-large-machines-v2.patch

This patch was dropped because it was folded into sched-proc-sched_stat-fails-on-very-very-large-machines.patch

------------------------------------------------------
From: Nathan Zimmer <nzimmer@sgi.com>
Subject: sched-proc-sched_stat-fails-on-very-very-large-machines-v2

v2: Took Andrew's suggestion to add comments, fix memleak

Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Jones <davej@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched/stats.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN kernel/sched/stats.c~sched-proc-sched_stat-fails-on-very-very-large-machines-v2 kernel/sched/stats.c
--- a/kernel/sched/stats.c~sched-proc-sched_stat-fails-on-very-very-large-machines-v2
+++ a/kernel/sched/stats.c
@@ -81,6 +81,13 @@ static int show_schedstat(struct seq_fil
 	return 0;
 }
 
+/*
+ * This itererator needs some explination.
+ * It returns 1 for the header position.
+ * This means 2 is cpu 0.
+ * In a hotplugged system some cpus, including cpu 0, may be missing so we have
+ * to use cpumask_* to iterate over the cpus.
+ */
 static void *schedstat_start(struct seq_file *file, loff_t *offset)
 {
 	unsigned long n = *offset;
_

Patches currently in -mm which might be from nzimmer@sgi.com are

sched-proc-sched_stat-fails-on-very-very-large-machines.patch
sched-proc-sched_stat-fails-on-very-very-large-machines-v2-fix.patch
sched-proc-sched_stat-fails-on-very-very-large-machines-v2-fix-fix.patch
sched-proc-sched_debug-fails-on-very-very-large-machines.patch
sched-proc-sched_debug-fails-on-very-very-large-machines-fix.patch
sched-proc-sched_debug-fails-on-very-very-large-machines-v2.patch
sched-proc-sched_debug-fails-on-very-very-large-machines-v2-fix.patch

