From: akpm@linux-foundation.org
Subject: + cpu-hotplug-adjust-root-domain-online-span-in-response-to-hotplug-event.patch added to -mm tree
Date: Sat, 08 Mar 2008 00:26:36 -0800
Message-ID: <200803080826.m288QaDr008245@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60372 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753321AbYCHI1E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 8 Mar 2008 03:27:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ghaskins@novell.com, mingo@elte.hu, suresh.b.siddha@intel.com


The patch titled
     cpu hotplug: adjust root-domain->online span in response to hotplug event
has been added to the -mm tree.  Its filename is
     cpu-hotplug-adjust-root-domain-online-span-in-response-to-hotplug-event.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpu hotplug: adjust root-domain->online span in response to hotplug event
From: Gregory Haskins <ghaskins@novell.com>

We currently set the root-domain online span automatically when the domain is
added to the cpu if the cpu is already a member of cpu_online_map.  This was
done as a hack/bug-fix for s2ram, but it also causes a problem with hotplug
CPU_DOWN transitioning.  The right way to fix the original problem is to
actually respond to CPU_UP events, instead of CPU_ONLINE, which is already too
late.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |   18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff -puN kernel/sched.c~cpu-hotplug-adjust-root-domain-online-span-in-response-to-hotplug-event kernel/sched.c
--- a/kernel/sched.c~cpu-hotplug-adjust-root-domain-online-span-in-response-to-hotplug-event
+++ a/kernel/sched.c
@@ -5890,6 +5890,13 @@ migration_call(struct notifier_block *nf
 		/* Must be high prio: stop_machine expects to yield to it. */
 		rq = task_rq_lock(p, &flags);
 		__setscheduler(rq, p, SCHED_FIFO, MAX_RT_PRIO-1);
+
+		/* Update our root-domain */
+		if (rq->rd) {
+			BUG_ON(!cpu_isset(cpu, rq->rd->span));
+			cpu_set(cpu, rq->rd->online);
+		}
+
 		task_rq_unlock(rq, &flags);
 		cpu_rq(cpu)->migration_thread = p;
 		break;
@@ -5898,15 +5905,6 @@ migration_call(struct notifier_block *nf
 	case CPU_ONLINE_FROZEN:
 		/* Strictly unnecessary, as first user will wake it. */
 		wake_up_process(cpu_rq(cpu)->migration_thread);
-
-		/* Update our root-domain */
-		rq = cpu_rq(cpu);
-		spin_lock_irqsave(&rq->lock, flags);
-		if (rq->rd) {
-			BUG_ON(!cpu_isset(cpu, rq->rd->span));
-			cpu_set(cpu, rq->rd->online);
-		}
-		spin_unlock_irqrestore(&rq->lock, flags);
 		break;
 
 #ifdef CONFIG_HOTPLUG_CPU
@@ -6182,8 +6180,6 @@ static void rq_attach_root(struct rq *rq
 	rq->rd = rd;
 
 	cpu_set(rq->cpu, rd->span);
-	if (cpu_isset(rq->cpu, cpu_online_map))
-		cpu_set(rq->cpu, rd->online);
 
 	for (class = sched_class_highest; class; class = class->next) {
 		if (class->join_domain)
_

Patches currently in -mm which might be from ghaskins@novell.com are

git-kvm.patch
cpu-hotplug-adjust-root-domain-online-span-in-response-to-hotplug-event.patch

