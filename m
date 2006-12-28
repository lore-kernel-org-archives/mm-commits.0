From: akpm@osdl.org
Subject: + kvm-more-msr-misery.patch added to -mm tree
Date: Thu, 28 Dec 2006 15:15:55 -0800
Message-ID: <200612282315.kBSNFtnW015860@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:40712 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753823AbWL1XP7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Dec 2006 18:15:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avi@qumranet.com


The patch titled
     KVM: More msr misery
has been added to the -mm tree.  Its filename is
     kvm-more-msr-misery.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: KVM: More msr misery
From: Avi Kivity <avi@qumranet.com>

These msrs are referenced by benchmarking software when pretending to be an
Intel cpu.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm_main.c |    4 ++++
 1 files changed, 4 insertions(+)

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

kvm-use-boot_cpu_data-instead-of-current_cpu_data.patch
kvm-simplify-is_long_mode.patch
kvm-initialize-kvm_arch_ops-on-unload.patch
kvm-implement-a-few-system-configuration-msrs.patch
kvm-move-common-msr-handling-to-arch-independent-code.patch
kvm-more-msr-misery.patch
kvm-rename-some-msrs.patch
kvm-fix-oops-on-oom.patch
kvm-fix-gfp_kernel-allocation-in-atomic-section-in-kvm_dev_ioctl_create_vcpu.patch

