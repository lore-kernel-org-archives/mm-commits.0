From: akpm@linux-foundation.org
Subject: + kvm-more-0-null-conversions.patch added to -mm tree
Date: Wed, 21 Feb 2007 12:49:53 -0800
Message-ID: <200702212049.l1LKnrpf025493@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44159 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161356AbXBUUuA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 15:50:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avi@qumranet.com


The patch titled
     KVM: More 0 -> NULL conversions
has been added to the -mm tree.  Its filename is
     kvm-more-0-null-conversions.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: KVM: More 0 -> NULL conversions
From: Avi Kivity <avi@qumranet.com>

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/kvm/kvm_main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/kvm/kvm_main.c~kvm-more-0-null-conversions drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-more-0-null-conversions
+++ a/drivers/kvm/kvm_main.c
@@ -2229,13 +2229,13 @@ static void kvm_exit_debug(void)
 static int kvm_suspend(struct sys_device *dev, pm_message_t state)
 {
 	decache_vcpus_on_cpu(raw_smp_processor_id());
-	on_each_cpu(kvm_arch_ops->hardware_disable, 0, 0, 1);
+	on_each_cpu(kvm_arch_ops->hardware_disable, NULL, 0, 1);
 	return 0;
 }
 
 static int kvm_resume(struct sys_device *dev)
 {
-	on_each_cpu(kvm_arch_ops->hardware_enable, 0, 0, 1);
+	on_each_cpu(kvm_arch_ops->hardware_enable, NULL, 0, 1);
 	return 0;
 }
 
_

Patches currently in -mm which might be from avi@qumranet.com are

kvm-mmu-add-missing-dirty-page-tracking-cases.patch
kvm-move-virtualization-deactivation-from-cpu_dead.patch
kvm-cosmetics.patch
kvm-vmx-hack-set_cr0_no_modeswitch-to-actually-do.patch
kvm-use-array_size-macro-instead-of-manual-calculation.patch
kvm-use-page_private-set_page_private-apis.patch
kvm-add-msr-based-hypercall-api.patch
kvm-add-host-hypercall-support-for-vmx.patch
kvm-add-hypercall-host-support-for-svm.patch
kvm-wire-up-hypercall-handlers-to-a-central.patch
kvm-svm-init-cr0-with-the-wp-bit-set.patch
kvm-svm-intercept-smi-to-handle-it-at-host-level.patch
kvm-more-0-null-conversions.patch
