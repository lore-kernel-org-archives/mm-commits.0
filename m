From: akpm@linux-foundation.org
Subject: - cpu-hotplug-mce-fix-cpu-hotplug-error-handling.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:42:06 -0700
Message-ID: <200710190342.l9J3g685012876@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49534 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751081AbXJSECr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 00:02:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, ak@suse.de, andi@firstfloor.org, ego@in.ibm.com, jbeulich@novell.com, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     cpu hotplug: mce: fix cpu hotplug error handling
has been removed from the -mm tree.  Its filename was
     cpu-hotplug-mce-fix-cpu-hotplug-error-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cpu hotplug: mce: fix cpu hotplug error handling
From: Akinobu Mita <akinobu.mita@gmail.com>

- Clear kobject in percpu device_mce before calling sysdev_register() with

  Because mce_create_device() may fail and it leaves kobject filled with
  junk. It will be the problem when mce_create_device() will be called
  next time.

- Fix error handling in mce_create_device()

  Error handling should not do sysdev_remove_file() with not yet added
  attributes.

- Don't register hotcpu notifier when mce_create_device() returns error

- Do mce_create_device() in CPU_UP_PREPARE instead of CPU_ONLINE

Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andi Kleen <ak@suse.de>
Cc: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/mce_64.c |   39 +++++++++++++++++++++++++++----------
 1 file changed, 29 insertions(+), 10 deletions(-)

diff -puN arch/x86/kernel/mce_64.c~cpu-hotplug-mce-fix-cpu-hotplug-error-handling arch/x86/kernel/mce_64.c
--- a/arch/x86/kernel/mce_64.c~cpu-hotplug-mce-fix-cpu-hotplug-error-handling
+++ a/arch/x86/kernel/mce_64.c
@@ -802,16 +802,29 @@ static __cpuinit int mce_create_device(u
 	if (!mce_available(&cpu_data[cpu]))
 		return -EIO;
 
+	memset(&per_cpu(device_mce, cpu).kobj, 0, sizeof(struct kobject));
 	per_cpu(device_mce,cpu).id = cpu;
 	per_cpu(device_mce,cpu).cls = &mce_sysclass;
 
 	err = sysdev_register(&per_cpu(device_mce,cpu));
+	if (err)
+		return err;
+
+	for (i = 0; mce_attributes[i]; i++) {
+		err = sysdev_create_file(&per_cpu(device_mce,cpu),
+					 mce_attributes[i]);
+		if (err)
+			goto error;
+	}
 
-	if (!err) {
-		for (i = 0; mce_attributes[i]; i++)
-			sysdev_create_file(&per_cpu(device_mce,cpu),
-				mce_attributes[i]);
+	return 0;
+error:
+	while (i--) {
+		sysdev_remove_file(&per_cpu(device_mce,cpu),
+				   mce_attributes[i]);
 	}
+	sysdev_unregister(&per_cpu(device_mce,cpu));
+
 	return err;
 }
 
@@ -823,7 +836,6 @@ static void mce_remove_device(unsigned i
 		sysdev_remove_file(&per_cpu(device_mce,cpu),
 			mce_attributes[i]);
 	sysdev_unregister(&per_cpu(device_mce,cpu));
-	memset(&per_cpu(device_mce, cpu).kobj, 0, sizeof(struct kobject));
 }
 
 /* Get notified when a cpu comes on/off. Be hotplug friendly. */
@@ -831,18 +843,21 @@ static int
 mce_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 {
 	unsigned int cpu = (unsigned long)hcpu;
+	int err = 0;
 
 	switch (action) {
-	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
-		mce_create_device(cpu);
+	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
+		err = mce_create_device(cpu);
 		break;
+	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
 		mce_remove_device(cpu);
 		break;
 	}
-	return NOTIFY_OK;
+	return err ? NOTIFY_BAD : NOTIFY_OK;
 }
 
 static struct notifier_block mce_cpu_notifier = {
@@ -857,9 +872,13 @@ static __init int mce_init_device(void)
 	if (!mce_available(&boot_cpu_data))
 		return -EIO;
 	err = sysdev_class_register(&mce_sysclass);
+	if (err)
+		return err;
 
 	for_each_online_cpu(i) {
-		mce_create_device(i);
+		err = mce_create_device(i);
+		if (err)
+			return err;
 	}
 
 	register_hotcpu_notifier(&mce_cpu_notifier);
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
git-x86.patch
