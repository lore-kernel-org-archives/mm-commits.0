From: akpm@linux-foundation.org
Subject: [merged] cpuidle-menu-governor-reduce-latency-on-exit.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:44:43 -0700
Message-ID: <200909222044.n8MKihZ7014187@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59994 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753176AbZIVUoq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:44:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: czoccolo@gmail.com, abelay@novell.com, arjan@linux.intel.com, len.brown@intel.com, venkatesh.pallipadi@intel.com, mm-commits@vger.kernel.org


The patch titled
     cpuidle: menu governor: reduce latency on exit
has been removed from the -mm tree.  Its filename was
     cpuidle-menu-governor-reduce-latency-on-exit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpuidle: menu governor: reduce latency on exit
From: Corrado Zoccolo <czoccolo@gmail.com>

Move the state residency accounting and statistics computation off the hot
exit path.

On exit, the need to recompute statistics is recorded, and new statistics
will be computed when menu_select is called again.

The expected effect is to reduce processor wakeup latency from sleep
(C-states).  We are speaking of few hundreds of cycles reduction out of a
several microseconds latency (determined by the hardware transition), so
it is difficult to measure.

Signed-off-by: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Adam Belay <abelay@novell.com
Acked-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpuidle/governors/menu.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff -puN drivers/cpuidle/governors/menu.c~cpuidle-menu-governor-reduce-latency-on-exit drivers/cpuidle/governors/menu.c
--- a/drivers/cpuidle/governors/menu.c~cpuidle-menu-governor-reduce-latency-on-exit
+++ a/drivers/cpuidle/governors/menu.c
@@ -96,6 +96,7 @@
 
 struct menu_device {
 	int		last_state_idx;
+	int             needs_update;
 
 	unsigned int	expected_us;
 	u64		predicted_us;
@@ -166,6 +167,8 @@ static inline int performance_multiplier
 
 static DEFINE_PER_CPU(struct menu_device, menu_devices);
 
+static void menu_update(struct cpuidle_device *dev);
+
 /**
  * menu_select - selects the next idle state to enter
  * @dev: the CPU
@@ -180,6 +183,11 @@ static int menu_select(struct cpuidle_de
 	data->last_state_idx = 0;
 	data->exit_us = 0;
 
+	if (data->needs_update) {
+		menu_update(dev);
+		data->needs_update = 0;
+	}
+
 	/* Special case when user has set very strict latency requirement */
 	if (unlikely(latency_req == 0))
 		return 0;
@@ -231,7 +239,7 @@ static int menu_select(struct cpuidle_de
 }
 
 /**
- * menu_reflect - attempts to guess what happened after entry
+ * menu_reflect - records that data structures need update
  * @dev: the CPU
  *
  * NOTE: it's important to be fast here because this operation will add to
@@ -240,6 +248,16 @@ static int menu_select(struct cpuidle_de
 static void menu_reflect(struct cpuidle_device *dev)
 {
 	struct menu_device *data = &__get_cpu_var(menu_devices);
+	data->needs_update = 1;
+}
+
+/**
+ * menu_update - attempts to guess what happened after entry
+ * @dev: the CPU
+ */
+static void menu_update(struct cpuidle_device *dev)
+{
+	struct menu_device *data = &__get_cpu_var(menu_devices);
 	int last_idx = data->last_state_idx;
 	unsigned int last_idle_us = cpuidle_get_last_residency(dev);
 	struct cpuidle_state *target = &dev->states[last_idx];
_

Patches currently in -mm which might be from czoccolo@gmail.com are

origin.patch

