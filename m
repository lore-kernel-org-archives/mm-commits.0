From: akpm@linux-foundation.org
Subject: - kvm-two-way-apic-tpr-synchronization.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:48:51 -0800
Message-ID: <200702122248.l1CMmp8e014060@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45578 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030372AbXBLWs6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:48:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dor.laor@qumranet.com, avi@qumranet.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     kvm: Two-way apic tpr synchronization
has been removed from the -mm tree.  Its filename was
     kvm-two-way-apic-tpr-synchronization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kvm: Two-way apic tpr synchronization
From: Dor Laor <dor.laor@qumranet.com>

We report the value of cr8 to userspace on an exit.  Also let userspace change
cr8 when we re-enter the guest.  The lets 64-bit guest code maintain the tpr
correctly.

Thanks for Yaniv Kamay for the idea.

Signed-off-by: Dor Laor <dor.laor@qumranet.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/kvm/kvm_main.c |    3 +++
 include/linux/kvm.h    |    2 ++
 2 files changed, 5 insertions(+)

diff -puN drivers/kvm/kvm_main.c~kvm-two-way-apic-tpr-synchronization drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-two-way-apic-tpr-synchronization
+++ a/drivers/kvm/kvm_main.c
@@ -1360,6 +1360,9 @@ static int kvm_dev_ioctl_run(struct kvm 
 	if (!vcpu)
 		return -ENOENT;
 
+	/* re-sync apic's tpr */
+	vcpu->cr8 = kvm_run->cr8;
+
 	if (kvm_run->emulated) {
 		kvm_arch_ops->skip_emulated_instruction(vcpu);
 		kvm_run->emulated = 0;
diff -puN include/linux/kvm.h~kvm-two-way-apic-tpr-synchronization include/linux/kvm.h
--- a/include/linux/kvm.h~kvm-two-way-apic-tpr-synchronization
+++ a/include/linux/kvm.h
@@ -65,6 +65,8 @@ struct kvm_run {
 	__u8 ready_for_interrupt_injection;
 	__u8 if_flag;
 	__u16 padding2;
+
+	/* in (pre_kvm_run), out (post_kvm_run) */
 	__u64 cr8;
 	__u64 apic_base;
 
_

Patches currently in -mm which might be from dor.laor@qumranet.com are

origin.patch
