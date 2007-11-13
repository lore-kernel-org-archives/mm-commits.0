From: akpm@linux-foundation.org
Subject: + x86-dont-call-mce_create_device-on-cpu_up_prepare.patch added to -mm tree
Date: Mon, 12 Nov 2007 18:13:27 -0800
Message-ID: <200711130213.lAD2DRf0021467@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46193 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758367AbXKMCN4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Nov 2007 21:13:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andreas.herrmann3@amd.com, akinobu.mita@gmail.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86: don't call mce_create_device on CPU_UP_PREPARE
has been added to the -mm tree.  Its filename is
     x86-dont-call-mce_create_device-on-cpu_up_prepare.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86: don't call mce_create_device on CPU_UP_PREPARE
From: "Andreas Herrmann" <andreas.herrmann3@amd.com>

Fix regression introduced with d435d862baca3e25e5eec236762a43251b1e7ffc
("cpu hotplug: mce: fix cpu hotplug error handling").

A CPU which was not brought up during boot (using maxcpus and
additional_cpus parameters) couldn't be onlined anymore.  For such a CPU it
seemed that MCE was not supported during CPU_UP_PREPARE-time which caused
mce_cpu_callback to return NOTIFY_BAD to notifier_call_chain.  To fix this
we:

 - call mce_create_device for CPU_ONLINE event (instead of CPU_UP_PREPARE),
 - avoid mce_remove_device() for the CPU that is not correctly initialized
   by mce_create_device() failure,
 - make mce_cpu_callback always return NOTIFY_OK for CPU_ONLINE event.
   Because CPU_ONLINE callback return value is always ignored.

[akinobu.mita@gmail.com: avoid mce_remove_device() for not initialized device]
[akinobu.mita@gmail.com: make mce_cpu_callback always return NOTIFY_OK]
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/mcheck/mce_64.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff -puN arch/x86/kernel/cpu/mcheck/mce_64.c~x86-dont-call-mce_create_device-on-cpu_up_prepare arch/x86/kernel/cpu/mcheck/mce_64.c
--- a/arch/x86/kernel/cpu/mcheck/mce_64.c~x86-dont-call-mce_create_device-on-cpu_up_prepare
+++ a/arch/x86/kernel/cpu/mcheck/mce_64.c
@@ -802,6 +802,8 @@ static struct sysdev_attribute *mce_attr
 	NULL
 };
 
+static cpumask_t mce_device_initialized = CPU_MASK_NONE;
+
 /* Per cpu sysdev init.  All of the cpus still share the same ctl bank */
 static __cpuinit int mce_create_device(unsigned int cpu)
 {
@@ -825,6 +827,7 @@ static __cpuinit int mce_create_device(u
 		if (err)
 			goto error;
 	}
+	cpu_set(cpu, mce_device_initialized);
 
 	return 0;
 error:
@@ -841,10 +844,14 @@ static void mce_remove_device(unsigned i
 {
 	int i;
 
+	if (!cpu_isset(cpu, mce_device_initialized))
+		return;
+
 	for (i = 0; mce_attributes[i]; i++)
 		sysdev_remove_file(&per_cpu(device_mce,cpu),
 			mce_attributes[i]);
 	sysdev_unregister(&per_cpu(device_mce,cpu));
+	cpu_clear(cpu, mce_device_initialized);
 }
 
 /* Get notified when a cpu comes on/off. Be hotplug friendly. */
@@ -852,21 +859,18 @@ static int
 mce_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 {
 	unsigned int cpu = (unsigned long)hcpu;
-	int err = 0;
 
 	switch (action) {
-	case CPU_UP_PREPARE:
-	case CPU_UP_PREPARE_FROZEN:
-		err = mce_create_device(cpu);
+	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
+		mce_create_device(cpu);
 		break;
-	case CPU_UP_CANCELED:
-	case CPU_UP_CANCELED_FROZEN:
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
 		mce_remove_device(cpu);
 		break;
 	}
-	return err ? NOTIFY_BAD : NOTIFY_OK;
+	return NOTIFY_OK;
 }
 
 static struct notifier_block mce_cpu_notifier = {
_

Patches currently in -mm which might be from andreas.herrmann3@amd.com are

git-cpufreq.patch
x86-show-cpuinfo-only-for-online-cpus.patch
x86-dont-call-mce_create_device-on-cpu_up_prepare.patch
