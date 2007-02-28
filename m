From: akpm@linux-foundation.org
Subject: - kvm-move-virtualization-deactivation-from-cpu_dead.patch removed from -mm tree
Date: Wed, 28 Feb 2007 15:54:30 -0800
Message-ID: <200702282354.l1SNsUe8031198@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48501 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932740AbXB1Xyj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Feb 2007 18:54:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: katzj@redhat.com, avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: Move virtualization deactivation from CPU_DEAD state to CPU_DOWN_PREPARE
has been removed from the -mm tree.  Its filename was
     kvm-move-virtualization-deactivation-from-cpu_dead.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: KVM: Move virtualization deactivation from CPU_DEAD state to CPU_DOWN_PREPARE
From: Jeremy Katz <katzj@redhat.com>

This gives it more chances of surviving suspend.

Signed-off-by: Jeremy Katz <katzj@redhat.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/kvm/kvm_main.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff -puN drivers/kvm/kvm_main.c~kvm-move-virtualization-deactivation-from-cpu_dead drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-move-virtualization-deactivation-from-cpu_dead
+++ a/drivers/kvm/kvm_main.c
@@ -2080,13 +2080,17 @@ static int kvm_cpu_hotplug(struct notifi
 	int cpu = (long)v;
 
 	switch (val) {
-	case CPU_DEAD:
+	case CPU_DOWN_PREPARE:
 	case CPU_UP_CANCELED:
+		printk(KERN_INFO "kvm: disabling virtualization on CPU%d\n",
+		       cpu);
 		decache_vcpus_on_cpu(cpu);
 		smp_call_function_single(cpu, kvm_arch_ops->hardware_disable,
 					 NULL, 0, 1);
 		break;
-	case CPU_UP_PREPARE:
+	case CPU_ONLINE:
+		printk(KERN_INFO "kvm: enabling virtualization on CPU%d\n",
+		       cpu);
 		smp_call_function_single(cpu, kvm_arch_ops->hardware_enable,
 					 NULL, 0, 1);
 		break;
_

Patches currently in -mm which might be from katzj@redhat.com are

git-kvm.patch
