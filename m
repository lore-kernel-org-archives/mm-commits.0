From: akpm@osdl.org
Subject: - kvm-load-i386-segment-bases.patch removed from -mm tree
Date: Sat, 09 Dec 2006 23:56:10 -0800
Message-ID: <200612100756.kBA7uAnA017929@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59909 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760591AbWLJH4M (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 02:56:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: reload kernel-mode host fs and gs segment bases on i386
has been removed from the -mm tree.  Its filename was
     kvm-load-i386-segment-bases.patch

This patch was dropped because it was folded into kvm-userspace-interface.patch

------------------------------------------------------
Subject: KVM: reload kernel-mode host fs and gs segment bases on i386
From: Avi Kivity <avi@qumranet.com>

The segment reload code missed the case where either fs and gs were a 
kernel segment with a nonzero base address.  This caused an oops with 
the pda patches, where per-cpu data is accessed through such segments

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm_main.c |    3 +++
 drivers/kvm/vmx.c      |    3 +++
 2 files changed, 6 insertions(+)

diff -puN drivers/kvm/kvm_main.c~kvm-load-i386-segment-bases drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-load-i386-segment-bases
+++ a/drivers/kvm/kvm_main.c
@@ -101,6 +101,9 @@ unsigned long segment_base(u16 selector)
 	typedef unsigned long ul;
 	unsigned long v;
 
+	if (selector == 0)
+		return 0;
+
 	asm ("sgdt %0" : "=m"(gdt));
 	table_base = gdt.base;
 
diff -puN drivers/kvm/vmx.c~kvm-load-i386-segment-bases drivers/kvm/vmx.c
--- a/drivers/kvm/vmx.c~kvm-load-i386-segment-bases
+++ a/drivers/kvm/vmx.c
@@ -1692,6 +1692,9 @@ again:
 #ifdef __x86_64__
 	vmcs_writel(HOST_FS_BASE, read_msr(MSR_FS_BASE));
 	vmcs_writel(HOST_GS_BASE, read_msr(MSR_GS_BASE));
+#else
+	vmcs_writel(HOST_FS_BASE, segment_base(fs_sel));
+	vmcs_writel(HOST_GS_BASE, segment_base(gs_sel));
 #endif
 
 	if (vcpu->irq_summary &&
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch
kvm-userspace-interface.patch
kvm-load-i386-segment-bases.patch

