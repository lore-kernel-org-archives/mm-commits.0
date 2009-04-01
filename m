From: akpm@linux-foundation.org
Subject: [merged] oom_kill-dont-call-for-int_sqrt0.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:34:13 -0700
Message-ID: <200904011834.n31IYDrI007098@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60695 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933345AbZDASiJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 14:38:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@gmail.com, cl@linux-foundation.org, gorcunov@openvz.org, penberg@cs.helsinki.fi, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     oom_kill: don't call for int_sqrt(0)
has been removed from the -mm tree.  Its filename was
     oom_kill-dont-call-for-int_sqrt0.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: oom_kill: don't call for int_sqrt(0)
From: Cyrill Gorcunov <gorcunov@gmail.com>

There is no need to call for int_sqrt if argument is 0.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <cl@linux-foundation.org>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff -puN mm/oom_kill.c~oom_kill-dont-call-for-int_sqrt0 mm/oom_kill.c
--- a/mm/oom_kill.c~oom_kill-dont-call-for-int_sqrt0
+++ a/mm/oom_kill.c
@@ -55,7 +55,7 @@ static DEFINE_SPINLOCK(zone_scan_lock);
 
 unsigned long badness(struct task_struct *p, unsigned long uptime)
 {
-	unsigned long points, cpu_time, run_time, s;
+	unsigned long points, cpu_time, run_time;
 	struct mm_struct *mm;
 	struct task_struct *child;
 
@@ -110,12 +110,10 @@ unsigned long badness(struct task_struct
 	else
 		run_time = 0;
 
-	s = int_sqrt(cpu_time);
-	if (s)
-		points /= s;
-	s = int_sqrt(int_sqrt(run_time));
-	if (s)
-		points /= s;
+	if (cpu_time)
+		points /= int_sqrt(cpu_time);
+	if (run_time)
+		points /= int_sqrt(int_sqrt(run_time));
 
 	/*
 	 * Niced processes are most likely less important, so double
_

Patches currently in -mm which might be from gorcunov@gmail.com are

origin.patch
linux-next.patch

