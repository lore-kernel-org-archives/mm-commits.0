From: akpm@linux-foundation.org
Subject: + cpufreq-fix-null-pointer-dereference-regression-in-conservative-gov.patch added to -mm tree
Date: Thu, 30 Jul 2009 16:50:29 -0700
Message-ID: <200907302350.n6UNoTLk001016@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52781 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751508AbZG3XvB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Jul 2009 19:51:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: venkatesh.pallipadi@intel.com, Christophe.Lermytte@thomson.net, davej@redhat.com, rjw@sisk.pl


The patch titled
     cpufreq: fix NULL pointer dereference regression in conservative gov
has been added to the -mm tree.  Its filename is
     cpufreq-fix-null-pointer-dereference-regression-in-conservative-gov.patch

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
Subject: cpufreq: fix NULL pointer dereference regression in conservative gov
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>

Commit ee88415caf736b89500f16e0a545614541a45005 ("[CPUFREQ] Cleanup
locking in conservative governor") introduced this regression when it
removed enable bit in cpu_dbs_info_s.

That added a possibility of dbs_cpufreq_notifier getting called for a CPU
that is not yet managed by conservative governor.  That will happen as the
transition notifier is set as soon as one CPU switches to conservative
governor and other CPUs can get a NULL pointer dereference without the
enable bit check.  Add the enable bit back again.

Reported-by: Lermytte Christophe <Christophe.Lermytte@thomson.net>
Tested-by: Lermytte Christophe <Christophe.Lermytte@thomson.net>
Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Dave Jones <davej@redhat.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpufreq/cpufreq_conservative.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN drivers/cpufreq/cpufreq_conservative.c~cpufreq-fix-null-pointer-dereference-regression-in-conservative-gov drivers/cpufreq/cpufreq_conservative.c
--- a/drivers/cpufreq/cpufreq_conservative.c~cpufreq-fix-null-pointer-dereference-regression-in-conservative-gov
+++ a/drivers/cpufreq/cpufreq_conservative.c
@@ -63,6 +63,7 @@ struct cpu_dbs_info_s {
 	unsigned int down_skip;
 	unsigned int requested_freq;
 	int cpu;
+	unsigned int enable:1;
 	/*
 	 * percpu mutex that serializes governor limit change with
 	 * do_dbs_timer invocation. We do not want do_dbs_timer to run
@@ -141,6 +142,9 @@ dbs_cpufreq_notifier(struct notifier_blo
 
 	struct cpufreq_policy *policy;
 
+	if (!this_dbs_info->enable)
+		return 0;
+
 	policy = this_dbs_info->cur_policy;
 
 	/*
@@ -497,6 +501,7 @@ static inline void dbs_timer_init(struct
 	int delay = usecs_to_jiffies(dbs_tuners_ins.sampling_rate);
 	delay -= jiffies % delay;
 
+	dbs_info->enable = 1;
 	INIT_DELAYED_WORK_DEFERRABLE(&dbs_info->work, do_dbs_timer);
 	queue_delayed_work_on(dbs_info->cpu, kconservative_wq, &dbs_info->work,
 				delay);
@@ -504,6 +509,7 @@ static inline void dbs_timer_init(struct
 
 static inline void dbs_timer_exit(struct cpu_dbs_info_s *dbs_info)
 {
+	dbs_info->enable = 0;
 	cancel_delayed_work_sync(&dbs_info->work);
 }
 
_

Patches currently in -mm which might be from venkatesh.pallipadi@intel.com are

linux-next.patch
kernel-core-add-smp_call_function_any.patch
kernel-core-add-smp_call_function_any-update.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
cpuidle-menu-governor-reduce-latency-on-exit.patch
cpufreq-fix-null-pointer-dereference-regression-in-conservative-gov.patch

