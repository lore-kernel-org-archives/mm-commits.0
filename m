From: akpm@linux-foundation.org
Subject: + iucv-convert-cpu-notifier-to-return-encapsulate-errno-value.patch added to -mm tree
Date: Mon, 22 Mar 2010 14:49:20 -0700
Message-ID: <201003222149.o2MLnL21029443@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60536 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756554Ab0CVVt1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Mar 2010 17:49:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, ursula.braun@de.ibm.com


The patch titled
     iucv: convert cpu notifier to return encapsulate errno value
has been added to the -mm tree.  Its filename is
     iucv-convert-cpu-notifier-to-return-encapsulate-errno-value.patch

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
Subject: iucv: convert cpu notifier to return encapsulate errno value
From: Akinobu Mita <akinobu.mita@gmail.com>

By the previous modification, the cpu notifier can return encapsulate
errno value.  This converts the cpu notifiers for iucv.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Ursula Braun <ursula.braun@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/iucv/iucv.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN net/iucv/iucv.c~iucv-convert-cpu-notifier-to-return-encapsulate-errno-value net/iucv/iucv.c
--- a/net/iucv/iucv.c~iucv-convert-cpu-notifier-to-return-encapsulate-errno-value
+++ a/net/iucv/iucv.c
@@ -632,13 +632,14 @@ static int __cpuinit iucv_cpu_notify(str
 		iucv_irq_data[cpu] = kmalloc_node(sizeof(struct iucv_irq_data),
 					GFP_KERNEL|GFP_DMA, cpu_to_node(cpu));
 		if (!iucv_irq_data[cpu])
-			return NOTIFY_BAD;
+			return notifier_from_errno(-ENOMEM);
+
 		iucv_param[cpu] = kmalloc_node(sizeof(union iucv_param),
 				     GFP_KERNEL|GFP_DMA, cpu_to_node(cpu));
 		if (!iucv_param[cpu]) {
 			kfree(iucv_irq_data[cpu]);
 			iucv_irq_data[cpu] = NULL;
-			return NOTIFY_BAD;
+			return notifier_from_errno(-ENOMEM);
 		}
 		iucv_param_irq[cpu] = kmalloc_node(sizeof(union iucv_param),
 					GFP_KERNEL|GFP_DMA, cpu_to_node(cpu));
@@ -647,7 +648,7 @@ static int __cpuinit iucv_cpu_notify(str
 			iucv_param[cpu] = NULL;
 			kfree(iucv_irq_data[cpu]);
 			iucv_irq_data[cpu] = NULL;
-			return NOTIFY_BAD;
+			return notifier_from_errno(-ENOMEM);
 		}
 		break;
 	case CPU_UP_CANCELED:
@@ -677,7 +678,7 @@ static int __cpuinit iucv_cpu_notify(str
 		cpu_clear(cpu, cpumask);
 		if (cpus_empty(cpumask))
 			/* Can't offline last IUCV enabled cpu. */
-			return NOTIFY_BAD;
+			return notifier_from_errno(-EINVAL);
 		smp_call_function_single(cpu, iucv_retrieve_cpu, NULL, 1);
 		if (cpus_empty(iucv_irq_cpumask))
 			smp_call_function_single(first_cpu(iucv_buffer_cpumask),
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

intel-iommu-use-for_each_set_bit.patch
bitops-rename-for_each_bit-to-for_each_set_bit-mtd.patch
cpu-hotplug-introduce-cpu_notify-__cpu_notify-cpu_notify_nofail.patch
cpu-hotplug-return-better-errno-on-cpu-hotplug-failure.patch
notifier-change-notifier_from_errno0-to-return-notify_ok.patch
x86-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
topology-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
kernel-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
slab-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
iucv-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
ehca-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
s390-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
md-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
fault-injection-add-cpu-notifier-error-injection-module.patch
bitops-remove-temporary-for_each_bit.patch

