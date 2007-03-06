From: akpm@linux-foundation.org
Subject: + sched-fix-idle-load-balancing-in-softirqd-context-fix.patch added to -mm tree
Date: Mon, 05 Mar 2007 23:02:57 -0800
Message-ID: <200703060702.l2672v4Q015025@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:53294 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965824AbXCFHDM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 02:03:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kernel@kolivas.org, suresh.b.siddha@intel.com


The patch titled
     sched: fix idle at tick
has been added to the -mm tree.  Its filename is
     sched-fix-idle-load-balancing-in-softirqd-context-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sched: fix idle at tick
From: Con Kolivas <kernel@kolivas.org>

Fix reverse idle at tick logic.

Signed-off-by: Con Kolivas <kernel@kolivas.org>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/sched.c~sched-fix-idle-load-balancing-in-softirqd-context-fix kernel/sched.c
--- a/kernel/sched.c~sched-fix-idle-load-balancing-in-softirqd-context-fix
+++ a/kernel/sched.c
@@ -3220,7 +3220,7 @@ void scheduler_tick(void)
 
 	update_cpu_clock(p, rq, now);
 
-	if (idle_at_tick)
+	if (!idle_at_tick)
 		task_running_tick(rq, p);
 #ifdef CONFIG_SMP
 	update_load(rq);
_

Patches currently in -mm which might be from kernel@kolivas.org are

origin.patch
sched-fix-idle-load-balancing-in-softirqd-context-fix.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
