From: akpm@linux-foundation.org
Subject: + kvm-svm-init-cr0-with-the-wp-bit-set.patch added to -mm tree
Date: Wed, 21 Feb 2007 12:49:49 -0800
Message-ID: <200702212049.l1LKnngO025487@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44150 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161351AbXBUUt4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 15:49:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avi@qumranet.com


The patch titled
     KVM: svm: init cr0 with the wp bit set
has been added to the -mm tree.  Its filename is
     kvm-svm-init-cr0-with-the-wp-bit-set.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: KVM: svm: init cr0 with the wp bit set
From: Avi Kivity <avi@qumranet.com>

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/kvm/svm.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/kvm/svm.c~kvm-svm-init-cr0-with-the-wp-bit-set drivers/kvm/svm.c
--- a/drivers/kvm/svm.c~kvm-svm-init-cr0-with-the-wp-bit-set
+++ a/drivers/kvm/svm.c
@@ -554,7 +554,7 @@ static void init_vmcb(struct vmcb *vmcb)
 	 * cr0 val on cpu init should be 0x60000010, we enable cpu
 	 * cache by default. the orderly way is to enable cache in bios.
 	 */
-	save->cr0 = 0x00000010 | CR0_PG_MASK;
+	save->cr0 = 0x00000010 | CR0_PG_MASK | CR0_WP_MASK;
 	save->cr4 = CR4_PAE_MASK;
 	/* rdx = ?? */
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
