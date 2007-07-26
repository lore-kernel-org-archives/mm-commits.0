From: akpm@linux-foundation.org
Subject: + cpu-hotplug-thermal_throttle-fix-cpu-hotplug-error-handling.patch added to -mm tree
Date: Thu, 26 Jul 2007 13:51:29 -0700
Message-ID: <200707262051.l6QKpTFx020285@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60668 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932279AbXGZUvq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jul 2007 16:51:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, dmitriyz@google.com, ego@in.ibm.com, oleg@tv-sign.ru


The patch titled
     cpu hotplug: thermal_throttle: fix cpu hotplug error handling
has been added to the -mm tree.  Its filename is
     cpu-hotplug-thermal_throttle-fix-cpu-hotplug-error-handling.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cpu hotplug: thermal_throttle: fix cpu hotplug error handling
From: Akinobu Mita <akinobu.mita@gmail.com>

Do thermal_throttle_add_dev() in CPU_UP_PREPARE instead of CPU_ONLINE.

Cc: Dmitriy Zavin <dmitriyz@google.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/mcheck/therm_throt.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN arch/i386/kernel/cpu/mcheck/therm_throt.c~cpu-hotplug-thermal_throttle-fix-cpu-hotplug-error-handling arch/i386/kernel/cpu/mcheck/therm_throt.c
--- a/arch/i386/kernel/cpu/mcheck/therm_throt.c~cpu-hotplug-thermal_throttle-fix-cpu-hotplug-error-handling
+++ a/arch/i386/kernel/cpu/mcheck/therm_throt.c
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
 
 static struct notifier_block thermal_throttle_cpu_notifier =
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
cpu-hotplug-slab-cleanup-cpuup_callback.patch
cpu-hotplug-slab-fix-memory-leak-in-cpu-hotplug-error-path.patch
cpu-hotplug-cpu-deliver-cpu_up_canceled-only-to-notify_oked-callbacks-with-cpu_up_prepare.patch
cpu-hotplug-topology-remove-topology_dev_map.patch
cpu-hotplug-thermal_throttle-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-msr-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-cpuid-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-mce-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling.patch
