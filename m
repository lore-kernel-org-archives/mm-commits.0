From: akpm@linux-foundation.org
Subject: + cpuidle-fix-the-menu-governor-to-boost-io-performance-fix.patch added to -mm tree
Date: Sun, 20 Sep 2009 00:07:19 -0700
Message-ID: <200909200707.n8K77JVJ032242@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48457 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751603AbZITHI5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 20 Sep 2009 03:08:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arjan@linux.intel.com, a.p.zijlstra@chello.nl, lenb@kernel.org, mingo@elte.hu, venkatesh.pallipadi@intel.com, yanmin_zhang@linux.intel.com


The patch titled
     cpuidle-fix-the-menu-governor-to-boost-io-performance-fix
has been added to the -mm tree.  Its filename is
     cpuidle-fix-the-menu-governor-to-boost-io-performance-fix.patch

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
Subject: cpuidle-fix-the-menu-governor-to-boost-io-performance-fix
From: Arjan van de Ven <arjan@linux.intel.com>

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Len Brown <lenb@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -puN kernel/sched.c~cpuidle-fix-the-menu-governor-to-boost-io-performance-fix kernel/sched.c
--- a/kernel/sched.c~cpuidle-fix-the-menu-governor-to-boost-io-performance-fix
+++ a/kernel/sched.c
@@ -2906,16 +2906,14 @@ unsigned long nr_iowait(void)
 
 unsigned long nr_iowait_cpu(void)
 {
-	int this_cpu = smp_processor_id();
-	struct rq *this_rq = cpu_rq(this_cpu);
-	return atomic_read(&this_rq->nr_iowait);
+	struct rq *this = this_rq();
+	return atomic_read(&this->nr_iowait);
 }
 
 unsigned long this_cpu_load(void)
 {
-	int this_cpu = smp_processor_id();
-	struct rq *this_rq = cpu_rq(this_cpu);
-	return this_rq->cpu_load[0];
+	struct rq *this = this_rq();
+	return this->cpu_load[0];
 }
 
 
_

Patches currently in -mm which might be from arjan@linux.intel.com are

origin.patch
linux-next.patch
cpuidle-fix-the-menu-governor-to-boost-io-performance.patch
cpuidle-fix-the-menu-governor-to-boost-io-performance-fix.patch
cpuidle-menu-governor-reduce-latency-on-exit.patch

