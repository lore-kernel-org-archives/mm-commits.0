From: akpm@linux-foundation.org
Subject: + drivers-cpuidle-coupledc-fix-sleeping-while-atomic-in-cpu-notifier.patch added to -mm tree
Date: Tue, 14 Aug 2012 16:24:41 -0700
Message-ID: <20120814232442.3A07120004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:43430 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633Ab2HNXYo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Aug 2012 19:24:44 -0400
Received: by fadw1 with SMTP id w1so45267fad.1
        for <mm-commits@vger.kernel.org>; Tue, 14 Aug 2012 16:24:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ccross@android.com, len.brown@intel.com, lenb@kernel.org, santosh.shilimkar@ti.com, srivatsa.bhat@linux.vnet.ibm.com, stable@vger.kernel.org


The patch titled
     Subject: drivers/cpuidle/coupled.c: fix sleeping while atomic in cpu notifier
has been added to the -mm tree.  Its filename is
     drivers-cpuidle-coupledc-fix-sleeping-while-atomic-in-cpu-notifier.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
drivers-cpuidle-coupledc-fix-sleeping-while-atomic-in-cpu-notifier.patch

