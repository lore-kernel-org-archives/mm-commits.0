From: akpm@linux-foundation.org
Subject: + kvm-move-virtualization-deactivation-from-cpu_dead.patch added to -mm tree
Date: Wed, 21 Feb 2007 12:49:31 -0800
Message-ID: <200702212049.l1LKnVb9025447@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44126 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161345AbXBUUtq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 15:49:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: katzj@redhat.com, avi@qumranet.com


The patch titled
     KVM: Move virtualization deactivation from CPU_DEAD state to CPU_DOWN_PREPARE
has been added to the -mm tree.  Its filename is
     kvm-move-virtualization-deactivation-from-cpu_dead.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

kvm-move-virtualization-deactivation-from-cpu_dead.patch
