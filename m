From: akpm@linux-foundation.org
Subject: + cpu-hotplug-register-update_sched_domains-notifier-with-higher-prio.patch added to -mm tree
Date: Mon, 10 Mar 2008 13:58:44 -0700
Message-ID: <200803102058.m2AKwiTp005168@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54036 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751323AbYCJU74 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Mar 2008 16:59:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ego@in.ibm.com, ghaskins@novell.com, mingo@elte.hu, rjw@sisk.pl, suresh.b.siddha@intel.com


The patch titled
     cpu-hotplug: register update_sched_domains() notifier with higher prio
has been added to the -mm tree.  Its filename is
     cpu-hotplug-register-update_sched_domains-notifier-with-higher-prio.patch

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
Subject: cpu-hotplug: register update_sched_domains() notifier with higher prio
From: Gautham R Shenoy <ego@in.ibm.com>

The current -rt wake_up logic uses the rq->rd->online_map which is updated on
cpu-hotplug events by update_sched_domains().  Currently
update_sched_domains() is registered with a priority 0.  It is preferable that
update_sched_domains() be the first notifier called on a CPU_DEAD or
CPU_ONLINE events inorder to ensure that the rq->rd->online_map is in sync
with the cpu_online_map.

This way on a CPU_DOWN_PREPARE, we would destroy the sched_domains and
reattach all the rq's to the def_root_domain.  This will be followed by a
CPU_DOWN_PREPARE in migration_call() which will clear the bit of the cpu going
offline from the corresponding rq.  This will ensure that no task will be
woken up on the cpu which is going to be offlined between CPU_DOWN_PREPARE and
CPU_DEAD.

Ditto for the CPU_ONLINE path.

Tested on a 4-way Intel Xeon Box with cpu-hotplug tests running in parallel
with kernbench.

(akpm: might fix my poweroff-doesnt-work regression)

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
Cc: Gregory Haskins <ghaskins@novell.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff -puN kernel/sched.c~cpu-hotplug-register-update_sched_domains-notifier-with-higher-prio kernel/sched.c
--- a/kernel/sched.c~cpu-hotplug-register-update_sched_domains-notifier-with-higher-prio
+++ a/kernel/sched.c
@@ -7095,8 +7095,16 @@ void __init sched_init_smp(void)
 	if (cpus_empty(non_isolated_cpus))
 		cpu_set(smp_processor_id(), non_isolated_cpus);
 	put_online_cpus();
-	/* XXX: Theoretical race here - CPU may be hotplugged now */
-	hotcpu_notifier(update_sched_domains, 0);
+	/*
+	 * XXX: Theoretical race here - CPU may be hotplugged now
+	 *
+	 * We register the notifier with priority 11, which means that
+	 * update_sched_domains() will be called just before migration_call().
+	 *
+	 * This is necessary to ensure that the rt wake up logic works fine
+	 * and the rq->rd->online_map remains in sync with the cpu_online_map.
+	 */
+	hotcpu_notifier(update_sched_domains, 11);
 
 	/* Move init over to a non-isolated CPU */
 	if (set_cpus_allowed(current, non_isolated_cpus) < 0)
_

Patches currently in -mm which might be from ego@in.ibm.com are

poweroff-workaround.patch
cpu-fix-section-mismatch-warnings-in-hotcpu_register.patch
cpu-fix-section-mismatch-warning-in-unregister_cpu_notifier.patch
cpu-fix-section-mismatch-warnings-in-cpu_down.patch
cpu-fix-section-mismatch-warning-in-reference-to-register_cpu_notifier.patch
add-rcu_assign_index-if-ever-needed-fix.patch
simplify-cpu_hotplug_begin-put_online_cpus.patch
cpu-hotplug-register-update_sched_domains-notifier-with-higher-prio.patch

