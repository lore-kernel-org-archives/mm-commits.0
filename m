From: akpm@linux-foundation.org
Subject: + cpu-hotplug-msr-fix-cpu-hotplug-error-handling.patch added to -mm tree
Date: Thu, 26 Jul 2007 13:51:30 -0700
Message-ID: <200707262051.l6QKpUXU020288@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60649 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935048AbXGZUvv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jul 2007 16:51:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, ego@in.ibm.com, hpa@zytor.com, oleg@tv-sign.ru


The patch titled
     cpu hotplug: msr: fix cpu hotplug error handling
has been added to the -mm tree.  Its filename is
     cpu-hotplug-msr-fix-cpu-hotplug-error-handling.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cpu hotplug: msr: fix cpu hotplug error handling
From: Akinobu Mita <akinobu.mita@gmail.com>

Do msr_device_create() in CPU_UP_PREPARE instead of CPU_ONLINE.

Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/msr.c |   32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff -puN arch/i386/kernel/msr.c~cpu-hotplug-msr-fix-cpu-hotplug-error-handling arch/i386/kernel/msr.c
--- a/arch/i386/kernel/msr.c~cpu-hotplug-msr-fix-cpu-hotplug-error-handling
+++ a/arch/i386/kernel/msr.c
@@ -135,33 +135,39 @@ static const struct file_operations msr_
 	.open = msr_open,
 };
 
-static int msr_device_create(int i)
+static int msr_device_create(int cpu)
 {
-	int err = 0;
 	struct device *dev;
 
-	dev = device_create(msr_class, NULL, MKDEV(MSR_MAJOR, i), "msr%d",i);
-	if (IS_ERR(dev))
-		err = PTR_ERR(dev);
-	return err;
+	dev = device_create(msr_class, NULL, MKDEV(MSR_MAJOR, cpu),
+			    "msr%d", cpu);
+	return IS_ERR(dev) ? PTR_ERR(dev) : 0;
+}
+
+static void msr_device_destroy(int cpu)
+{
+	device_destroy(msr_class, MKDEV(MSR_MAJOR, cpu));
 }
 
 static int msr_class_cpu_callback(struct notifier_block *nfb,
 				unsigned long action, void *hcpu)
 {
 	unsigned int cpu = (unsigned long)hcpu;
+	int err = 0;
 
 	switch (action) {
-	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
-		msr_device_create(cpu);
+	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
+		err = msr_device_create(cpu);
 		break;
+	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
-		device_destroy(msr_class, MKDEV(MSR_MAJOR, cpu));
+		msr_device_destroy(cpu);
 		break;
 	}
-	return NOTIFY_OK;
+	return err ? NOTIFY_BAD : NOTIFY_OK;
 }
 
 static struct notifier_block __cpuinitdata msr_class_cpu_notifier =
@@ -198,7 +204,7 @@ static int __init msr_init(void)
 out_class:
 	i = 0;
 	for_each_online_cpu(i)
-		device_destroy(msr_class, MKDEV(MSR_MAJOR, i));
+		msr_device_destroy(i);
 	class_destroy(msr_class);
 out_chrdev:
 	unregister_chrdev(MSR_MAJOR, "cpu/msr");
@@ -210,7 +216,7 @@ static void __exit msr_exit(void)
 {
 	int cpu = 0;
 	for_each_online_cpu(cpu)
-		device_destroy(msr_class, MKDEV(MSR_MAJOR, cpu));
+		msr_device_destroy(cpu);
 	class_destroy(msr_class);
 	unregister_chrdev(MSR_MAJOR, "cpu/msr");
 	unregister_hotcpu_notifier(&msr_class_cpu_notifier);
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
