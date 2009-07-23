From: akpm@linux-foundation.org
Subject: + cpuidle-menu-governor-reduce-latency-on-exit.patch added to -mm tree
Date: Thu, 23 Jul 2009 15:05:22 -0700
Message-ID: <200907232205.n6NM5Mn7021128@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57433 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754577AbZGWWFz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Jul 2009 18:05:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: czoccolo@gmail.com, abelay@novell.com, len.brown@intel.com, venkatesh.pallipadi@intel.com


The patch titled
     cpuidle: menu governor: reduce latency on exit
has been added to the -mm tree.  Its filename is
     cpuidle-menu-governor-reduce-latency-on-exit.patch

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
Subject: cpuidle: menu governor: reduce latency on exit
From: Corrado Zoccolo <czoccolo@gmail.com>

Move the state residency accounting and statistics computation off the hot
exit path.

On exit, the need to recompute statistics is recorded, and new statistics
will be computed when menu_select is called again.

Signed-off-by: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Adam Belay <abelay@novell.com
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpuidle/governors/menu.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff -puN drivers/cpuidle/governors/menu.c~cpuidle-menu-governor-reduce-latency-on-exit drivers/cpuidle/governors/menu.c
--- a/drivers/cpuidle/governors/menu.c~cpuidle-menu-governor-reduce-latency-on-exit
+++ a/drivers/cpuidle/governors/menu.c
@@ -19,6 +19,7 @@
 
 struct menu_device {
 	int		last_state_idx;
+	int             needs_update;
 
 	unsigned int	expected_us;
 	unsigned int	predicted_us;
@@ -29,6 +30,8 @@ struct menu_device {
 
 static DEFINE_PER_CPU(struct menu_device, menu_devices);
 
+static void menu_update(struct cpuidle_device *dev);
+
 /**
  * menu_select - selects the next idle state to enter
  * @dev: the CPU
@@ -39,6 +42,11 @@ static int menu_select(struct cpuidle_de
 	int latency_req = pm_qos_requirement(PM_QOS_CPU_DMA_LATENCY);
 	int i;
 
+	if (data->needs_update) {
+		menu_update(dev);
+		data->needs_update = 0;
+	}
+
 	/* Special case when user has set very strict latency requirement */
 	if (unlikely(latency_req == 0)) {
 		data->last_state_idx = 0;
@@ -72,7 +80,7 @@ static int menu_select(struct cpuidle_de
 }
 
 /**
- * menu_reflect - attempts to guess what happened after entry
+ * menu_reflect - records that data structures need update
  * @dev: the CPU
  *
  * NOTE: it's important to be fast here because this operation will add to
@@ -81,6 +89,16 @@ static int menu_select(struct cpuidle_de
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

cpuidle-menu-governor-reduce-latency-on-exit.patch

