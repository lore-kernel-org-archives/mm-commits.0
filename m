From: akpm@osdl.org
Subject: - kvm-more-msr-misery.patch removed from -mm tree
Date: Mon, 01 Jan 2007 23:25:18 -0800
Message-ID: <200701020725.l027PIa2013025@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:37423 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932888AbXABHZV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 02:25:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: More msr misery
has been removed from the -mm tree.  Its filename was
     kvm-more-msr-misery.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: KVM: More msr misery
From: Avi Kivity <avi@qumranet.com>

These msrs are referenced by benchmarking software when pretending to be an
Intel cpu.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm_main.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/kvm/kvm_main.c~kvm-more-msr-misery drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-more-msr-misery
+++ a/drivers/kvm/kvm_main.c
@@ -1122,11 +1122,15 @@ int kvm_get_msr_common(struct kvm_vcpu *
 	case MSR_IA32_MC0_MISC+12:
 	case MSR_IA32_MC0_MISC+16:
 	case MSR_IA32_UCODE_REV:
+	case MSR_IA32_PERF_STATUS:
 		/* MTRR registers */
 	case 0xfe:
 	case 0x200 ... 0x2ff:
 		data = 0;
 		break;
+	case 0xcd: /* fsb frequency */
+		data = 3;
+		break;
 	case MSR_IA32_APICBASE:
 		data = vcpu->apic_base;
 		break;
_

Patches currently in -mm which might be from avi@qumranet.com are
