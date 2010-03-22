From: akpm@linux-foundation.org
Subject: + cpu-hotplug-return-better-errno-on-cpu-hotplug-failure.patch added to -mm tree
Date: Mon, 22 Mar 2010 14:49:05 -0700
Message-ID: <201003222149.o2MLn5sY029416@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53140 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756536Ab0CVVtK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Mar 2010 17:49:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, rusty@rustcorp.com.au


The patch titled
     cpu-hotplug: return better errno on cpu hotplug failure
has been added to the -mm tree.  Its filename is
     cpu-hotplug-return-better-errno-on-cpu-hotplug-failure.patch

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
Subject: cpu-hotplug: return better errno on cpu hotplug failure
From: Akinobu Mita <akinobu.mita@gmail.com>

Currently, onlining or offlining a CPU failure by one of the cpu notifiers
error always cause -EINVAL error.  (i.e.  writing 0 or 1 to
/sys/devices/system/cpu/cpuX/online gets EINVAL)

To get better error reporting rather than always getting -EINVAL, This
changes cpu_notify() to return -errno value with notifier_to_errno() and
fix the callers.  Now that cpu notifiers can return encapsulate errno
value.

Currently, all cpu hotplug notifiers return NOTIFY_OK, NOTIFY_BAD, or
NOTIFY_DONE.  So cpu_notify() can returns 0 or -EPERM with this change for
now.

(notifier_to_errno(NOTIFY_OK) == 0, notifier_to_errno(NOTIFY_DONE) == 0,
notifier_to_errno(NOTIFY_BAD) == -EPERM)

Forthcoming patches convert several cpu notifiers to return encapsulate
errno value with notifier_from_errno().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpu.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff -puN kernel/cpu.c~cpu-hotplug-return-better-errno-on-cpu-hotplug-failure kernel/cpu.c
--- a/kernel/cpu.c~cpu-hotplug-return-better-errno-on-cpu-hotplug-failure
+++ a/kernel/cpu.c
@@ -136,8 +136,12 @@ int __ref register_cpu_notifier(struct n
 static int __cpu_notify(unsigned long val, void *v, int nr_to_call,
 			int *nr_calls)
 {
-	return __raw_notifier_call_chain(&cpu_chain, val, v, nr_to_call,
+	int ret;
+
+	ret = __raw_notifier_call_chain(&cpu_chain, val, v, nr_to_call,
 					nr_calls);
+
+	return notifier_to_errno(ret);
 }
 
 static int cpu_notify(unsigned long val, void *v)
@@ -150,7 +154,7 @@ static void cpu_notify_nofail(unsigned l
 	int err;
 
 	err = cpu_notify(val, v);
-	BUG_ON(err == NOTIFY_BAD);
+	BUG_ON(err);
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
@@ -230,14 +234,13 @@ static int __ref _cpu_down(unsigned int 
 	cpu_hotplug_begin();
 	set_cpu_active(cpu, false);
 	err = __cpu_notify(CPU_DOWN_PREPARE | mod, hcpu, -1, &nr_calls);
-	if (err == NOTIFY_BAD) {
+	if (err) {
 		set_cpu_active(cpu, true);
 
 		nr_calls--;
 		__cpu_notify(CPU_DOWN_FAILED | mod, hcpu, nr_calls, NULL);
 		printk("%s: attempt to take down CPU %u failed\n",
 				__func__, cpu);
-		err = -EINVAL;
 		goto out_release;
 	}
 
@@ -314,11 +317,10 @@ static int __cpuinit _cpu_up(unsigned in
 
 	cpu_hotplug_begin();
 	ret = __cpu_notify(CPU_UP_PREPARE | mod, hcpu, -1, &nr_calls);
-	if (ret == NOTIFY_BAD) {
+	if (ret) {
 		nr_calls--;
 		printk("%s: attempt to bring up CPU %u failed\n",
 				__func__, cpu);
-		ret = -EINVAL;
 		goto out_notify;
 	}
 
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

