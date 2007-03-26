From: akpm@linux-foundation.org
Subject: - kvm-breaks-cpu-hotplug.patch removed from -mm tree
Date: Mon, 26 Mar 2007 03:01:57 -0800
Message-ID: <200703261101.l2QB1vCV017348@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:53621 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965233AbXCZLCb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Mar 2007 07:02:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shaohua.li@intel.com, avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM breaks CPU hotplug
has been removed from the -mm tree.  Its filename was
     kvm-breaks-cpu-hotplug.patch

This patch was dropped because it was nacked by the maintainer

------------------------------------------------------
Subject: KVM breaks CPU hotplug
From: Shaohua Li <shaohua.li@intel.com>

When testing CPU hotplug, I found cpu can't be onlined with kvm enabled
sometimes.  The reason is smp_call_function_single is a nop if the thread
is running on the target cpu.  I think CPU_ONLINE case doesn't require the
fix as the online CPU isn't plugged into sheduler yet.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Cc: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/kvm/kvm_main.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN drivers/kvm/kvm_main.c~kvm-breaks-cpu-hotplug drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-breaks-cpu-hotplug
+++ a/drivers/kvm/kvm_main.c
@@ -2782,6 +2782,7 @@ static int kvm_cpu_hotplug(struct notifi
 			   void *v)
 {
 	int cpu = (long)v;
+	int this_cpu;
 
 	switch (val) {
 	case CPU_DOWN_PREPARE:
@@ -2789,8 +2790,13 @@ static int kvm_cpu_hotplug(struct notifi
 		printk(KERN_INFO "kvm: disabling virtualization on CPU%d\n",
 		       cpu);
 		decache_vcpus_on_cpu(cpu);
-		smp_call_function_single(cpu, kvm_arch_ops->hardware_disable,
-					 NULL, 0, 1);
+		this_cpu = get_cpu();
+		if (this_cpu == cpu)
+			kvm_arch_ops->hardware_disable(NULL);
+		else
+			smp_call_function_single(cpu,
+				kvm_arch_ops->hardware_disable,  NULL, 0, 1);
+		put_cpu();
 		break;
 	case CPU_ONLINE:
 		printk(KERN_INFO "kvm: enabling virtualization on CPU%d\n",
_

Patches currently in -mm which might be from shaohua.li@intel.com are

git-acpi.patch
kvm-breaks-cpu-hotplug.patch
