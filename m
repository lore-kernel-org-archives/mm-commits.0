From: akpm@linux-foundation.org
Subject: [folded-merged] sched-proc-sched_stat-fails-on-very-very-large-machines-v2-fix-fix.patch removed from -mm tree
Date: Thu, 21 Feb 2013 15:13:17 -0800
Message-ID: <20130221231317.E58D231C016@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:38955 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004Ab3BUXNT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Feb 2013 18:13:19 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so9826vcd.5
        for <mm-commits@vger.kernel.org>; Thu, 21 Feb 2013 15:13:18 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, davej@redhat.com, fengguang.wu@intel.com, mingo@redhat.com, nzimmer@sgi.com, peterz@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: sched-proc-sched_stat-fails-on-very-very-large-machines-v2-fix-fix
has been removed from the -mm tree.  Its filename was
     sched-proc-sched_stat-fails-on-very-very-large-machines-v2-fix-fix.patch

This patch was dropped because it was folded into sched-proc-sched_stat-fails-on-very-very-large-machines.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: sched-proc-sched_stat-fails-on-very-very-large-machines-v2-fix-fix

fix warnings

Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Nathan Zimmer <nzimmer@sgi.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched/stats.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN kernel/sched/stats.c~sched-proc-sched_stat-fails-on-very-very-large-machines-v2-fix-fix kernel/sched/stats.c
--- a/kernel/sched/stats.c~sched-proc-sched_stat-fails-on-very-very-large-machines-v2-fix-fix
+++ a/kernel/sched/stats.c
@@ -25,14 +25,13 @@ static int show_schedstat(struct seq_fil
 		seq_printf(seq, "version %d\n", SCHEDSTAT_VERSION);
 		seq_printf(seq, "timestamp %lu\n", jiffies);
 	} else {
-
-		cpu = (unsigned long)(v - 2);
