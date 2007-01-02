From: akpm@osdl.org
Subject: - kvm-use-boot_cpu_data-instead-of-current_cpu_data.patch removed from -mm tree
Date: Mon, 01 Jan 2007 23:25:07 -0800
Message-ID: <200701020725.l027P7Y1013010@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:37401 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932872AbXABHZL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 02:25:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: Use boot_cpu_data instead of current_cpu_data
has been removed from the -mm tree.  Its filename was
     kvm-use-boot_cpu_data-instead-of-current_cpu_data.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: KVM: Use boot_cpu_data instead of current_cpu_data
From: Avi Kivity <avi@qumranet.com>

current_cpu_data invokes smp_processor_id(), which is inadvisable when
preemption is enabled.  Switch to boot_cpu_data instead.

Resolves sourceforge bug 1621401.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/svm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/kvm/svm.c~kvm-use-boot_cpu_data-instead-of-current_cpu_data drivers/kvm/svm.c
--- a/drivers/kvm/svm.c~kvm-use-boot_cpu_data-instead-of-current_cpu_data
+++ a/drivers/kvm/svm.c
@@ -246,7 +246,7 @@ static int has_svm(void)
 {
 	uint32_t eax, ebx, ecx, edx;
 
-	if (current_cpu_data.x86_vendor != X86_VENDOR_AMD) {
+	if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD) {
 		printk(KERN_INFO "has_svm: not amd\n");
 		return 0;
 	}
_

Patches currently in -mm which might be from avi@qumranet.com are
