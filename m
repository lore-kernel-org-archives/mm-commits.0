From: akpm@osdl.org
Subject: - kvm-amd-svm-implementation-printk-log-levels.patch removed from -mm tree
Date: Sat, 09 Dec 2006 23:56:01 -0800
Message-ID: <200612100756.kBA7u1Vl017920@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59903 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760593AbWLJH4I (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 02:56:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, rdreier@cisco.com, mm-commits@vger.kernel.org


The patch titled
     Subject: [PATCH] KVM: printk log levels
has been removed from the -mm tree.  Its filename was
     kvm-amd-svm-implementation-printk-log-levels.patch

This patch was dropped because it was folded into kvm-userspace-interface.patch

------------------------------------------------------
Subject: Subject: [PATCH] KVM: printk log levels
From: Avi Kivity <avi@qumranet.com>


Here's a trivial patch that adds log levels to all printks.  This
avoids ugly things like

Message from syslogd@roland-xeon-2 at Wed Nov 29 14:01:01 2006 ...
roland-xeon-2 kernel: [81842.565619] msrs: 6

popping up in a console on my system when starting a guest.

Signed-off-by: Avi Kivity <avi@qumranet.com>

Index: linux-2.6/drivers/kvm/vmx.c
===================================================================
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/svm.c |    4 ++--
 drivers/kvm/vmx.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/kvm/svm.c~kvm-amd-svm-implementation-printk-log-levels drivers/kvm/svm.c
--- a/drivers/kvm/svm.c~kvm-amd-svm-implementation-printk-log-levels
+++ a/drivers/kvm/svm.c
@@ -990,7 +990,7 @@ static int io_interception(struct kvm_vc
 
 		addr_mask = io_adress(vcpu, _in, &kvm_run->io.address);
 		if (!addr_mask) {
-			printk("%s: get io address failed\n", __FUNCTION__);
+			printk(KERN_DEBUG "%s: get io address failed\n", __FUNCTION__);
 			return 1;
 		}
 
@@ -1030,7 +1030,7 @@ static int invalid_op_interception(struc
 
 static int task_switch_interception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
-	printk("%s: task swiche is unsupported\n", __FUNCTION__);
+	printk(KERN_DEBUG "%s: task swiche is unsupported\n", __FUNCTION__);
 	kvm_run->exit_reason = KVM_EXIT_UNKNOWN;
 	return 0;
 }
diff -puN drivers/kvm/vmx.c~kvm-amd-svm-implementation-printk-log-levels drivers/kvm/vmx.c
--- a/drivers/kvm/vmx.c~kvm-amd-svm-implementation-printk-log-levels
+++ a/drivers/kvm/vmx.c
@@ -1143,7 +1143,7 @@ static int vmx_vcpu_setup(struct kvm_vcp
 		vcpu->guest_msrs[j] = vcpu->host_msrs[j];
 		++vcpu->nmsrs;
 	}
-	printk("msrs: %d\n", vcpu->nmsrs);
+	printk(KERN_DEBUG "kvm: msrs: %d\n", vcpu->nmsrs);
 
 	nr_good_msrs = vcpu->nmsrs - NR_BAD_MSRS;
 	vmcs_writel(VM_ENTRY_MSR_LOAD_ADDR,
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch
kvm-userspace-interface.patch
kvm-amd-svm-implementation-printk-log-levels.patch
kvm-amd-svm-plumbing.patch
kvm-fix-null-and-c99-init-sparse-warnings.patch
kvm-load-i386-segment-bases.patch

