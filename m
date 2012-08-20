From: akpm@linux-foundation.org
Subject: [merged] drivers-cpuidle-coupledc-fix-sleeping-while-atomic-in-cpu-notifier.patch removed from -mm tree
Date: Mon, 20 Aug 2012 12:56:13 -0700
Message-ID: <20120820195614.2E62F200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:60550 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326Ab2HTT4R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Aug 2012 15:56:17 -0400
Received: by wibhr14 with SMTP id hr14so217423wib.1
        for <mm-commits@vger.kernel.org>; Mon, 20 Aug 2012 12:56:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ccross@android.com, len.brown@intel.com, lenb@kernel.org, santosh.shilimkar@ti.com, srivatsa.bhat@linux.vnet.ibm.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/cpuidle/coupled.c: fix sleeping while atomic in cpu notifier
has been removed from the -mm tree.  Its filename was
     drivers-cpuidle-coupledc-fix-sleeping-while-atomic-in-cpu-notifier.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Colin Cross <ccross@android.com>
Subject: drivers/cpuidle/coupled.c: fix sleeping while atomic in cpu notifier

The cpu hotplug notifier gets called in both atomic and non-atomic
contexts, it is not always safe to lock a mutex.  Filter out all events
except the six necessary ones, which are all sleepable, before taking the
mutex.

Signed-off-by: Colin Cross <ccross@android.com>
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Len Brown <lenb@kernel.org>
Cc: "Brown, Len" <len.brown@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpuidle/coupled.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN drivers/cpuidle/coupled.c~drivers-cpuidle-coupledc-fix-sleeping-while-atomic-in-cpu-notifier drivers/cpuidle/coupled.c
--- a/drivers/cpuidle/coupled.c~drivers-cpuidle-coupledc-fix-sleeping-while-atomic-in-cpu-notifier
+++ a/drivers/cpuidle/coupled.c
@@ -678,6 +678,18 @@ static int cpuidle_coupled_cpu_notify(st
 	int cpu = (unsigned long)hcpu;
 	struct cpuidle_device *dev;
 
+	switch (action & ~CPU_TASKS_FROZEN) {
+	case CPU_UP_PREPARE:
+	case CPU_DOWN_PREPARE:
+	case CPU_ONLINE:
+	case CPU_DEAD:
+	case CPU_UP_CANCELED:
+	case CPU_DOWN_FAILED:
+		break;
+	default:
+		return NOTIFY_OK;
+	}
+
 	mutex_lock(&cpuidle_lock);
 
 	dev = per_cpu(cpuidle_devices, cpu);
_

Patches currently in -mm which might be from ccross@android.com are

origin.patch
linux-next.patch

