From: akpm@linux-foundation.org
Subject: + intel_idle-disable-auto_demotion-for-hotplugged-cpus.patch added to -mm tree
Date: Tue, 14 Jun 2011 18:27:25 -0700
Message-ID: <201106150124.p5F1OgA7031990@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35504 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751624Ab1FOBgf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Jun 2011 21:36:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shaohua.li@intel.com, lenb@kernel.org


The patch titled
     intel_idle: disable auto_demotion for hotplugged CPUs
has been added to the -mm tree.  Its filename is
     intel_idle-disable-auto_demotion-for-hotplugged-cpus.patch

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
Subject: intel_idle: disable auto_demotion for hotplugged CPUs
From: Shaohua Li <shaohua.li@intel.com>

auto_demotion_disable is called only for online CPUs.  For hotplugged
CPUs, we should disable it too.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <>
---

 drivers/idle/intel_idle.c |   53 ++++++++++++++++++++++--------------
 1 file changed, 33 insertions(+), 20 deletions(-)

diff -puN drivers/idle/intel_idle.c~intel_idle-disable-auto_demotion-for-hotplugged-cpus drivers/idle/intel_idle.c
--- a/drivers/idle/intel_idle.c~intel_idle-disable-auto_demotion-for-hotplugged-cpus
+++ a/drivers/idle/intel_idle.c
@@ -270,33 +270,42 @@ static void __setup_broadcast_timer(void
 	clockevents_notify(reason, &cpu);
 }
 
-static int setup_broadcast_cpuhp_notify(struct notifier_block *n,
+static void auto_demotion_disable(void *dummy)
+{
+	unsigned long long msr_bits;
+
+	rdmsrl(MSR_NHM_SNB_PKG_CST_CFG_CTL, msr_bits);
+	msr_bits &= ~auto_demotion_disable_flags;
+	wrmsrl(MSR_NHM_SNB_PKG_CST_CFG_CTL, msr_bits);
+}
+
+static void __intel_idle_notify_handler(void *arg)
+{
+	if (auto_demotion_disable_flags)
+		auto_demotion_disable(NULL);
+
+	if (lapic_timer_reliable_states != LAPIC_TIMER_ALWAYS_RELIABLE)
+		__setup_broadcast_timer((void *)true);
+}
+
+static int setup_intelidle_cpuhp_notify(struct notifier_block *n,
 		unsigned long action, void *hcpu)
 {
 	int hotcpu = (unsigned long)hcpu;
 
 	switch (action & 0xf) {
 	case CPU_ONLINE:
-		smp_call_function_single(hotcpu, __setup_broadcast_timer,
-			(void *)true, 1);
+		smp_call_function_single(hotcpu, __intel_idle_notify_handler,
+			NULL, 1);
 		break;
 	}
 	return NOTIFY_OK;
 }
 
-static struct notifier_block setup_broadcast_notifier = {
-	.notifier_call = setup_broadcast_cpuhp_notify,
+static struct notifier_block setup_intelidle_notifier = {
+	.notifier_call = setup_intelidle_cpuhp_notify,
 };
 
-static void auto_demotion_disable(void *dummy)
-{
-	unsigned long long msr_bits;
-
-	rdmsrl(MSR_NHM_SNB_PKG_CST_CFG_CTL, msr_bits);
-	msr_bits &= ~auto_demotion_disable_flags;
-	wrmsrl(MSR_NHM_SNB_PKG_CST_CFG_CTL, msr_bits);
-}
-
 /*
  * intel_idle_probe()
  */
@@ -366,10 +375,8 @@ static int intel_idle_probe(void)
 
 	if (boot_cpu_has(X86_FEATURE_ARAT))	/* Always Reliable APIC Timer */
 		lapic_timer_reliable_states = LAPIC_TIMER_ALWAYS_RELIABLE;
-	else {
+	else
 		on_each_cpu(__setup_broadcast_timer, (void *)true, 1);
-		register_cpu_notifier(&setup_broadcast_notifier);
-	}
 
 	pr_debug(PREFIX "v" INTEL_IDLE_VERSION
 		" model 0x%X\n", boot_cpu_data.x86_model);
@@ -490,6 +497,10 @@ static int __init intel_idle_init(void)
 		return retval;
 	}
 
+	if (auto_demotion_disable_flags || lapic_timer_reliable_states !=
+	    LAPIC_TIMER_ALWAYS_RELIABLE)
+		register_cpu_notifier(&setup_intelidle_notifier);
+
 	return 0;
 }
 
@@ -498,10 +509,12 @@ static void __exit intel_idle_exit(void)
 	intel_idle_cpuidle_devices_uninit();
 	cpuidle_unregister_driver(&intel_idle_driver);
 
-	if (lapic_timer_reliable_states != LAPIC_TIMER_ALWAYS_RELIABLE) {
+	if (lapic_timer_reliable_states != LAPIC_TIMER_ALWAYS_RELIABLE)
 		on_each_cpu(__setup_broadcast_timer, (void *)false, 1);
-		unregister_cpu_notifier(&setup_broadcast_notifier);
-	}
+
+	if (auto_demotion_disable_flags || lapic_timer_reliable_states !=
+	    LAPIC_TIMER_ALWAYS_RELIABLE)
+		unregister_cpu_notifier(&setup_intelidle_notifier);
 
 	return;
 }
_

Patches currently in -mm which might be from shaohua.li@intel.com are

compaction-checks-correct-fragmentation-index.patch
linux-next.patch
intel_idle-fix-api-misuse.patch
intel_idle-disable-auto_demotion-for-hotplugged-cpus.patch

