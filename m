From: akpm@linux-foundation.org
Subject: + cpuidle-make-cpuidle_enable_device-call-poll_idle_init.patch added to -mm tree
Date: Mon, 10 Jan 2011 15:38:59 -0800
Message-ID: <201101102338.p0ANcxX7018188@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34829 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753426Ab1AJXjO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Jan 2011 18:39:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, len.brown@intel.com, trenn@suse.de


The patch titled
     cpuidle: make cpuidle_enable_device() call poll_idle_init()
has been added to the -mm tree.  Its filename is
     cpuidle-make-cpuidle_enable_device-call-poll_idle_init.patch

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
Subject: cpuidle: make cpuidle_enable_device() call poll_idle_init()
From: Rafael J. Wysocki <rjw@sisk.pl>

The following scenario is possible with the current cpuidle code and
the ACPI cpuidle driver:
(1) acpi_processor_cst_has_changed() is called,
(2) cpuidle_disable_device() is called,
(3) cpuidle_remove_state_sysfs() is called to remove the (presumably
    outdated) states info from sysfs,
(3) acpi_processor_get_power_info() is called, the first entry in the
    pr->power.states[] table is filled with zeros,
(4) acpi_processor_setup_cpuidle() is called and it doesn't fill the
    first entry in pr->power.states[],
(5) cpuidle_enable_device() is called,
(6) __cpuidle_register_device() is _not_ called, since the device has
    already been registered,
(7) Consequently, poll_idle_init() is _not_ called either,
(8) cpuidle_add_state_sysfs() is called to create the sysfs attributes
    for the new states and it uses the bogus first table entry from
    acpi_processor_get_power_info() for creating state0.

This problem will be avoided if cpuidle_enable_device() calls
poll_idle_init() for dev->registered different from zero.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Reported-by: Len Brown <len.brown@intel.com>
Cc: Thomas Renninger <trenn@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpuidle/cpuidle.c |   80 ++++++++++++++++++------------------
 1 file changed, 41 insertions(+), 39 deletions(-)

diff -puN drivers/cpuidle/cpuidle.c~cpuidle-make-cpuidle_enable_device-call-poll_idle_init drivers/cpuidle/cpuidle.c
--- a/drivers/cpuidle/cpuidle.c~cpuidle-make-cpuidle_enable_device-call-poll_idle_init
+++ a/drivers/cpuidle/cpuidle.c
@@ -155,6 +155,45 @@ void cpuidle_resume_and_unlock(void)
 
 EXPORT_SYMBOL_GPL(cpuidle_resume_and_unlock);
 
+#ifdef CONFIG_ARCH_HAS_CPU_RELAX
+static int poll_idle(struct cpuidle_device *dev, struct cpuidle_state *st)
+{
+	ktime_t	t1, t2;
+	s64 diff;
+	int ret;
+
+	t1 = ktime_get();
+	local_irq_enable();
+	while (!need_resched())
+		cpu_relax();
+
+	t2 = ktime_get();
+	diff = ktime_to_us(ktime_sub(t2, t1));
+	if (diff > INT_MAX)
+		diff = INT_MAX;
+
+	ret = (int) diff;
+	return ret;
+}
+
+static void poll_idle_init(struct cpuidle_device *dev)
+{
+	struct cpuidle_state *state = &dev->states[0];
+
+	cpuidle_set_statedata(state, NULL);
+
+	snprintf(state->name, CPUIDLE_NAME_LEN, "C0");
+	snprintf(state->desc, CPUIDLE_DESC_LEN, "CPUIDLE CORE POLL IDLE");
+	state->exit_latency = 0;
+	state->target_residency = 0;
+	state->power_usage = -1;
+	state->flags = CPUIDLE_FLAG_POLL;
+	state->enter = poll_idle;
+}
+#else
+static void poll_idle_init(struct cpuidle_device *dev) {}
+#endif /* CONFIG_ARCH_HAS_CPU_RELAX */
+
 /**
  * cpuidle_enable_device - enables idle PM for a CPU
  * @dev: the CPU
@@ -177,6 +216,8 @@ int cpuidle_enable_device(struct cpuidle
 		ret = __cpuidle_register_device(dev);
 		if (ret)
 			return ret;
+	} else {
+		poll_idle_init(dev);
 	}
 
 	if ((ret = cpuidle_add_state_sysfs(dev)))
@@ -233,45 +274,6 @@ void cpuidle_disable_device(struct cpuid
 
 EXPORT_SYMBOL_GPL(cpuidle_disable_device);
 
-#ifdef CONFIG_ARCH_HAS_CPU_RELAX
-static int poll_idle(struct cpuidle_device *dev, struct cpuidle_state *st)
-{
-	ktime_t	t1, t2;
-	s64 diff;
-	int ret;
-
-	t1 = ktime_get();
-	local_irq_enable();
-	while (!need_resched())
-		cpu_relax();
-
-	t2 = ktime_get();
-	diff = ktime_to_us(ktime_sub(t2, t1));
-	if (diff > INT_MAX)
-		diff = INT_MAX;
-
-	ret = (int) diff;
-	return ret;
-}
-
-static void poll_idle_init(struct cpuidle_device *dev)
-{
-	struct cpuidle_state *state = &dev->states[0];
-
-	cpuidle_set_statedata(state, NULL);
-
-	snprintf(state->name, CPUIDLE_NAME_LEN, "C0");
-	snprintf(state->desc, CPUIDLE_DESC_LEN, "CPUIDLE CORE POLL IDLE");
-	state->exit_latency = 0;
-	state->target_residency = 0;
-	state->power_usage = -1;
-	state->flags = CPUIDLE_FLAG_POLL;
-	state->enter = poll_idle;
-}
-#else
-static void poll_idle_init(struct cpuidle_device *dev) {}
-#endif /* CONFIG_ARCH_HAS_CPU_RELAX */
