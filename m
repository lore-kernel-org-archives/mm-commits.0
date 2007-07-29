From: akpm@linux-foundation.org
Subject: - sched-add-above-background-load-function.patch removed from -mm tree
Date: Sat, 28 Jul 2007 23:13:43 -0700
Message-ID: <200707290613.l6T6Dhvl011251@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44126 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759555AbXG2GYW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jul 2007 02:24:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kernel@kolivas.org, mingo@elte.hu, pwil3058@bigpond.net.au, mm-commits@vger.kernel.org


The patch titled
     sched: add above background load function
has been removed from the -mm tree.  Its filename was
     sched-add-above-background-load-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sched: add above background load function
From: Con Kolivas <kernel@kolivas.org>

Add an above_background_load() function which can be used by other
subsystems to detect if there is anything besides niced tasks running. 
Place it in sched.h to allow it to be compiled out if not used.

Signed-off-by: Con Kolivas <kernel@kolivas.org>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: Peter Williams <pwil3058@bigpond.net.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff -puN include/linux/sched.h~sched-add-above-background-load-function include/linux/sched.h
--- a/include/linux/sched.h~sched-add-above-background-load-function
+++ a/include/linux/sched.h
@@ -784,6 +784,22 @@ struct sched_domain {
 
 #endif	/* CONFIG_SMP */
 
+/*
+ * A runqueue laden with a single nice 0 task scores a weighted_cpuload of
+ * SCHED_LOAD_SCALE. This function returns 1 if any cpu is laden with a
+ * task of nice 0 or enough lower priority tasks to bring up the
+ * weighted_cpuload
+ */
+static inline int above_background_load(void)
+{
+	unsigned long cpu;
+
+	for_each_online_cpu(cpu) {
+		if (weighted_cpuload(cpu) >= SCHED_LOAD_SCALE)
+			return 1;
+	}
+	return 0;
+}
 
 struct io_context;			/* See blkdev.h */
 struct cpuset;
_

Patches currently in -mm which might be from kernel@kolivas.org are

origin.patch
mm-implement-swap-prefetching.patch
