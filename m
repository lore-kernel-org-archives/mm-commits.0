From: akpm@linux-foundation.org
Subject: - cpu-hotplug-msr-fix-cpu-hotplug-error-handling.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:42:04 -0700
Message-ID: <200710190342.l9J3g40d012873@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37886 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751004AbXJSECr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 00:02:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, ak@suse.de, ego@in.ibm.com, hpa@zytor.com, jbeulich@novell.com, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     cpu hotplug: msr: fix cpu hotplug error handling
has been removed from the -mm tree.  Its filename was
     cpu-hotplug-msr-fix-cpu-hotplug-error-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cpu hotplug: msr: fix cpu hotplug error handling
From: Akinobu Mita <akinobu.mita@gmail.com>

Do msr_device_create() in CPU_UP_PREPARE instead of CPU_ONLINE.

Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andi Kleen <ak@suse.de>
Cc: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/msr.c |   35 ++++++++++++++++++++---------------
 1 file changed, 20 insertions(+), 15 deletions(-)

diff -puN arch/x86/kernel/msr.c~cpu-hotplug-msr-fix-cpu-hotplug-error-handling arch/x86/kernel/msr.c
--- a/arch/x86/kernel/msr.c~cpu-hotplug-msr-fix-cpu-hotplug-error-handling
+++ a/arch/x86/kernel/msr.c
@@ -133,37 +133,42 @@ static const struct file_operations msr_
 	.open = msr_open,
 };
 
-static int __cpuinit msr_device_create(int i)
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
 
 static int __cpuinit msr_class_cpu_callback(struct notifier_block *nfb,
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
 
-static struct notifier_block __cpuinitdata msr_class_cpu_notifier =
-{
+static struct notifier_block __cpuinitdata msr_class_cpu_notifier = {
 	.notifier_call = msr_class_cpu_callback,
 };
 
@@ -196,7 +201,7 @@ static int __init msr_init(void)
 out_class:
 	i = 0;
 	for_each_online_cpu(i)
-		device_destroy(msr_class, MKDEV(MSR_MAJOR, i));
+		msr_device_destroy(i);
 	class_destroy(msr_class);
 out_chrdev:
 	unregister_chrdev(MSR_MAJOR, "cpu/msr");
@@ -208,7 +213,7 @@ static void __exit msr_exit(void)
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
git-x86.patch
