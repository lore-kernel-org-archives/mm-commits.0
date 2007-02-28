From: akpm@linux-foundation.org
Subject: - kvm-svm-init-cr0-with-the-wp-bit-set.patch removed from -mm tree
Date: Wed, 28 Feb 2007 15:54:51 -0800
Message-ID: <200702282354.l1SNspL6031228@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48534 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932715AbXB1Xyz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Feb 2007 18:54:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: svm: init cr0 with the wp bit set
has been removed from the -mm tree.  Its filename was
     kvm-svm-init-cr0-with-the-wp-bit-set.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

git-kvm.patch
kvm-add-internal-filesystem-for-generating-inodes-tweak.patch
