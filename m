From: akpm@osdl.org
Subject: + kvm-two-way-apic-tpr-synchronization.patch added to -mm tree
Date: Tue, 30 Jan 2007 16:36:47 -0800
Message-ID: <200701310036.l0V0al5e002563@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58810 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932078AbXAaAhD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Jan 2007 19:37:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dor.laor@qumranet.com, avi@qumranet.com, mingo@elte.hu


The patch titled
     kvm: Two-way apic tpr synchronization
has been added to the -mm tree.  Its filename is
     kvm-two-way-apic-tpr-synchronization.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
Signed-off-by: Andrew Morton <akpm@osdl.org>
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

kvm-two-way-apic-tpr-synchronization.patch
