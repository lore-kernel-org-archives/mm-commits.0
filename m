From: akpm@linux-foundation.org
Subject: [alternative-merged] intel_idle-disable-auto_demotion-for-hotplugged-cpus.patch removed from -mm tree
Date: Tue, 17 Jan 2012 16:22:52 -0800
Message-ID: <20120118002252.E930710004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:59451 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754224Ab2ARAWy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jan 2012 19:22:54 -0500
Received: by yhjj52 with SMTP id j52so535284yhj.1
        for <mm-commits@vger.kernel.org>; Tue, 17 Jan 2012 16:22:53 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shaohua.li@intel.com, lenb@kernel.org, trenn@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: intel_idle: disable auto_demotion for hotplugged CPUs
has been removed from the -mm tree.  Its filename was
     intel_idle-disable-auto_demotion-for-hotplugged-cpus.patch

This patch was dropped because an alternative patch was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Shaohua Li <shaohua.li@intel.com>
Subject: intel_idle: disable auto_demotion for hotplugged CPUs

auto_demotion_disable is called only for online CPUs.  For hotplugged
CPUs, we should disable it too.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Thomas Renninger <trenn@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/idle/intel_idle.c |   53 ++++++++++++++++++++++--------------
 1 file changed, 33 insertions(+), 20 deletions(-)

diff -puN drivers/idle/intel_idle.c~intel_idle-disable-auto_demotion-for-hotplugged-cpus drivers/idle/intel_idle.c
--- a/drivers/idle/intel_idle.c~intel_idle-disable-auto_demotion-for-hotplugged-cpus
+++ a/drivers/idle/intel_idle.c
@@ -297,33 +297,42 @@ static void __setup_broadcast_timer(void
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
@@ -393,10 +402,8 @@ static int intel_idle_probe(void)
 
 	if (boot_cpu_has(X86_FEATURE_ARAT))	/* Always Reliable APIC Timer */
 		lapic_timer_reliable_states = LAPIC_TIMER_ALWAYS_RELIABLE;
-	else {
+	else
 		on_each_cpu(__setup_broadcast_timer, (void *)true, 1);
-		register_cpu_notifier(&setup_broadcast_notifier);
-	}
 
 	pr_debug(PREFIX "v" INTEL_IDLE_VERSION
 		" model 0x%X\n", boot_cpu_data.x86_model);
@@ -559,6 +566,10 @@ static int __init intel_idle_init(void)
 		return retval;
 	}
 
+	if (auto_demotion_disable_flags || lapic_timer_reliable_states !=
+	    LAPIC_TIMER_ALWAYS_RELIABLE)
+		register_cpu_notifier(&setup_intelidle_notifier);
+
 	return 0;
 }
 
@@ -567,10 +578,12 @@ static void __exit intel_idle_exit(void)
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

origin.patch
linux-next.patch
intel_idle-fix-api-misuse.patch
drivers-idle-intel_idlec-remove-redundant-local_irq_disable-call.patch

