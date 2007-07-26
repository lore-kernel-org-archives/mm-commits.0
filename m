From: akpm@linux-foundation.org
Subject: + cpu-hotplug-cpu-deliver-cpu_up_canceled-only-to-notify_oked-callbacks-with-cpu_up_prepare.patch added to -mm tree
Date: Thu, 26 Jul 2007 13:51:26 -0700
Message-ID: <200707262051.l6QKpQdo020279@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36467 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934981AbXGZUvu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jul 2007 16:51:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, ego@in.ibm.com, oleg@tv-sign.ru, rusty@rustcorp.com.au


The patch titled
     cpu hotplug: cpu: deliver CPU_UP_CANCELED only to NOTIFY_OKed callbacks with CPU_UP_PREPARE
has been added to the -mm tree.  Its filename is
     cpu-hotplug-cpu-deliver-cpu_up_canceled-only-to-notify_oked-callbacks-with-cpu_up_prepare.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cpu hotplug: cpu: deliver CPU_UP_CANCELED only to NOTIFY_OKed callbacks with CPU_UP_PREPARE
From: Akinobu Mita <akinobu.mita@gmail.com>

The functions in a CPU notifier chain is called with CPU_UP_PREPARE event
before making the CPU online.  If one of the callback returns NOTIFY_BAD, it
stops to deliver CPU_UP_PREPARE event, and CPU online operation is canceled. 
Then CPU_UP_CANCELED event is delivered to the functions in a CPU notifier
chain again.

This CPU_UP_CANCELED event is delivered to the functions which have been
called with CPU_UP_PREPARE, not delivered to the functions which haven't been
called with CPU_UP_PREPARE.

The problem that makes existing cpu hotplug error handlings complex is that
the CPU_UP_CANCELED event is delivered to the function that has returned
NOTIFY_BAD, too.

Usually we don't expect to call destructor function against the object that
has failed to initialize.  It is like:

	err = register_something();
	if (err) {
		unregister_something();
		return err;
	}

So it is natural to deliver CPU_UP_CANCELED event only to the functions that
have returned NOTIFY_OK with CPU_UP_PREPARE event and not to call the function
that have returned NOTIFY_BAD.  This is what this patch is doing.

Otherwise, every cpu hotplug notifiler has to track whether notifiler event is
failed or not for each cpu.  (drivers/base/topology.c is doing this with
topology_dev_map)

Similary this patch makes same thing with CPU_DOWN_PREPARE and CPU_DOWN_FAILED
evnets.

Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpu.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN kernel/cpu.c~cpu-hotplug-cpu-deliver-cpu_up_canceled-only-to-notify_oked-callbacks-with-cpu_up_prepare kernel/cpu.c
--- a/kernel/cpu.c~cpu-hotplug-cpu-deliver-cpu_up_canceled-only-to-notify_oked-callbacks-with-cpu_up_prepare
+++ a/kernel/cpu.c
@@ -150,6 +150,7 @@ static int _cpu_down(unsigned int cpu, i
 	err = __raw_notifier_call_chain(&cpu_chain, CPU_DOWN_PREPARE | mod,
 					hcpu, -1, &nr_calls);
 	if (err == NOTIFY_BAD) {
+		nr_calls--;
 		__raw_notifier_call_chain(&cpu_chain, CPU_DOWN_FAILED | mod,
 					  hcpu, nr_calls, NULL);
 		printk("%s: attempt to take down CPU %u failed\n",
@@ -233,6 +234,7 @@ static int __cpuinit _cpu_up(unsigned in
 	ret = __raw_notifier_call_chain(&cpu_chain, CPU_UP_PREPARE | mod, hcpu,
 							-1, &nr_calls);
 	if (ret == NOTIFY_BAD) {
+		nr_calls--;
 		printk("%s: attempt to bring up CPU %u failed\n",
 				__FUNCTION__, cpu);
 		ret = -EINVAL;
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
