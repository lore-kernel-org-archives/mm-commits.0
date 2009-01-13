From: akpm@linux-foundation.org
Subject: + oom_kill-dont-call-for-int_sqrt0.patch added to -mm tree
Date: Tue, 13 Jan 2009 15:31:17 -0800
Message-ID: <200901132331.n0DNVHfg020799@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41399 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752835AbZAMXcC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Jan 2009 18:32:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@gmail.com, cl@linux-foundation.org, gorcunov@openvz.org, penberg@cs.helsinki.fi, rientjes@google.com


The patch titled
     oom_kill: don't call for int_sqrt(0)
has been added to the -mm tree.  Its filename is
     oom_kill-dont-call-for-int_sqrt0.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: oom_kill: don't call for int_sqrt(0)
From: Cyrill Gorcunov <gorcunov@gmail.com>

There is no need to call for int_sqrt if argument is 0.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>
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

mm-mminit_validate_memmodel_limits-get-rid-of-redundant-test.patch
oom_kill-dont-call-for-int_sqrt0.patch

