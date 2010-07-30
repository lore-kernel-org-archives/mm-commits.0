From: akpm@linux-foundation.org
Subject: + cpuidle-extend-cpuidle-and-menu-governor-to-handle-dynamic-states-update.patch added to -mm tree
Date: Fri, 30 Jul 2010 12:49:48 -0700
Message-ID: <201007301949.o6UJnnL6028250@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56453 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756096Ab0G3Tvg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Jul 2010 15:51:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aili@codeaurora.org, arjan@linux.intel.com, len.brown@intel.com, mingo@elte.hu, venki@google.com


The patch titled
     cpuidle-extend-cpuidle-and-menu-governor-to-handle-dynamic-states-update
has been added to the -mm tree.  Its filename is
     cpuidle-extend-cpuidle-and-menu-governor-to-handle-dynamic-states-update.patch

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
Subject: cpuidle-extend-cpuidle-and-menu-governor-to-handle-dynamic-states-update
From: Ai Li <aili@codeaurora.org>

Signed-off-by: Ai Li <aili@codeaurora.org>
Cc: Len Brown <len.brown@intel.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Venkatesh Pallipadi <venki@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpuidle/cpuidle.c        |   24 +++++++++++++++++++++---
 drivers/cpuidle/governors/menu.c |    7 ++++---
 2 files changed, 25 insertions(+), 6 deletions(-)

diff -puN drivers/cpuidle/cpuidle.c~cpuidle-extend-cpuidle-and-menu-governor-to-handle-dynamic-states-update drivers/cpuidle/cpuidle.c
--- a/drivers/cpuidle/cpuidle.c~cpuidle-extend-cpuidle-and-menu-governor-to-handle-dynamic-states-update
+++ a/drivers/cpuidle/cpuidle.c
@@ -75,6 +75,13 @@ static void cpuidle_idle_call(void)
 	hrtimer_peek_ahead_timers();
 #endif
 
+	/*
+	 * Call the device's prepare function before calling the
+	 * governor's select function.  ->prepare gives the device's
+	 * cpuidle driver a chance to update any dynamic information
+	 * of its cpuidle states for the current idle period, e.g.
+	 * state availability, latencies, residencies, etc.
+	 */
 	if (dev->prepare)
 		dev->prepare(dev);
 
@@ -286,13 +293,24 @@ static int __cpuidle_register_device(str
 
 	poll_idle_init(dev);
 
-	/* fake out the power numbers of the device states if the driver
-	 * does not specify them
+	/*
+	 * cpuidle driver should set the dev->power_specified bit
+	 * before registering the device if the driver provides
+	 * power_usage numbers.
+	 *
+	 * For those devices whose ->power_specified is not set,
+	 * we fill in power_usage with decreasing values as the
+	 * cpuidle code has an implicit assumption that state Cn
+	 * uses less power than C(n-1).
+	 *
+	 * With CONFIG_ARCH_HAS_CPU_RELAX, C0 is already assigned
+	 * an power value of -1.  So we use -2, -3, etc, for other
+	 * c-states.
 	 */
 	if (!dev->power_specified) {
 		int i;
 		for (i = CPUIDLE_DRIVER_STATE_START; i < dev->state_count; i++)
-			dev->states[i].power_usage = ~0U - i;
+			dev->states[i].power_usage = -1 - i;
 	}
 
 	per_cpu(cpuidle_devices, dev->cpu) = dev;
diff -puN drivers/cpuidle/governors/menu.c~cpuidle-extend-cpuidle-and-menu-governor-to-handle-dynamic-states-update drivers/cpuidle/governors/menu.c
--- a/drivers/cpuidle/governors/menu.c~cpuidle-extend-cpuidle-and-menu-governor-to-handle-dynamic-states-update
+++ a/drivers/cpuidle/governors/menu.c
@@ -234,7 +234,7 @@ static int menu_select(struct cpuidle_de
 {
 	struct menu_device *data = &__get_cpu_var(menu_devices);
 	int latency_req = pm_qos_request(PM_QOS_CPU_DMA_LATENCY);
-	unsigned int power_usage = ~0U;
+	unsigned int power_usage = -1;
 	int i;
 	int multiplier;
 
@@ -279,8 +279,9 @@ static int menu_select(struct cpuidle_de
 	if (data->expected_us > 5)
 		data->last_state_idx = CPUIDLE_DRIVER_STATE_START;
 
-	/* find the idle state with the lowest power while satisfying
-	 * our constraints
+	/*
+	 * Find the idle state with the lowest power while satisfying
+	 * our constraints.
 	 */
 	for (i = CPUIDLE_DRIVER_STATE_START; i < dev->state_count; i++) {
 		struct cpuidle_state *s = &dev->states[i];
_

Patches currently in -mm which might be from aili@codeaurora.org are

cpuidle-extend-cpuidle-and-menu-governor-to-handle-dynamic-states.patch
cpuidle-extend-cpuidle-and-menu-governor-to-handle-dynamic-states-update.patch

