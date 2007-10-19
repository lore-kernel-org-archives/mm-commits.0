From: akpm@linux-foundation.org
Subject: - cpu-hotplug-thermal_throttle-fix-cpu-hotplug-error-handling.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:42:02 -0700
Message-ID: <200710190342.l9J3g2LH012870@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43601 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751004AbXJSEDH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 00:03:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, ak@suse.de, dmitriyz@google.com, ego@in.ibm.com, jbeulich@novell.com, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     cpu hotplug: thermal_throttle: fix cpu hotplug error handling
has been removed from the -mm tree.  Its filename was
     cpu-hotplug-thermal_throttle-fix-cpu-hotplug-error-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cpu hotplug: thermal_throttle: fix cpu hotplug error handling
From: Akinobu Mita <akinobu.mita@gmail.com>

Do thermal_throttle_add_dev() in CPU_UP_PREPARE instead of CPU_ONLINE.

Cc: Dmitriy Zavin <dmitriyz@google.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andi Kleen <ak@suse.de>
Cc: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/mcheck/therm_throt.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN arch/x86/kernel/cpu/mcheck/therm_throt.c~cpu-hotplug-thermal_throttle-fix-cpu-hotplug-error-handling arch/x86/kernel/cpu/mcheck/therm_throt.c
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c~cpu-hotplug-thermal_throttle-fix-cpu-hotplug-error-handling
+++ a/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -131,17 +131,19 @@ static __cpuinit int thermal_throttle_cp
 {
 	unsigned int cpu = (unsigned long)hcpu;
 	struct sys_device *sys_dev;
-	int err;
+	int err = 0;
 
 	sys_dev = get_cpu_sysdev(cpu);
 	switch (action) {
-	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
+	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
 		mutex_lock(&therm_cpu_lock);
 		err = thermal_throttle_add_dev(sys_dev);
 		mutex_unlock(&therm_cpu_lock);
 		WARN_ON(err);
 		break;
+	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
 		mutex_lock(&therm_cpu_lock);
@@ -149,7 +151,7 @@ static __cpuinit int thermal_throttle_cp
 		mutex_unlock(&therm_cpu_lock);
 		break;
 	}
-	return NOTIFY_OK;
+	return err ? NOTIFY_BAD : NOTIFY_OK;
 }
 
 static struct notifier_block thermal_throttle_cpu_notifier __cpuinitdata =
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
git-x86.patch
