From: akpm@linux-foundation.org
Subject: - kvm-svm-hack-initial-cpu-csbase-to-be-consistent-with-intel.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:48:49 -0800
Message-ID: <200702122248.l1CMmnHB014057@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45572 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030365AbXBLWs4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:48:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     kvm: SVM: Hack initial cpu csbase to be consistent with intel
has been removed from the -mm tree.  Its filename was
     kvm-svm-hack-initial-cpu-csbase-to-be-consistent-with-intel.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kvm: SVM: Hack initial cpu csbase to be consistent with intel
From: Avi Kivity <avi@qumranet.com>

This allows us to run the mmu testsuite on amd.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/kvm/svm.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN drivers/kvm/svm.c~kvm-svm-hack-initial-cpu-csbase-to-be-consistent-with-intel drivers/kvm/svm.c
--- a/drivers/kvm/svm.c~kvm-svm-hack-initial-cpu-csbase-to-be-consistent-with-intel
+++ a/drivers/kvm/svm.c
@@ -528,7 +528,13 @@ static void init_vmcb(struct vmcb *vmcb)
 	save->cs.attrib = SVM_SELECTOR_READ_MASK | SVM_SELECTOR_P_MASK |
 		SVM_SELECTOR_S_MASK | SVM_SELECTOR_CODE_MASK;
 	save->cs.limit = 0xffff;
-	save->cs.base = 0xffff0000;
+	/*
+	 * cs.base should really be 0xffff0000, but vmx can't handle that, so
+	 * be consistent with it.
+	 *
+	 * Replace when we have real mode working for vmx.
+	 */
+	save->cs.base = 0xf0000;
 
 	save->gdtr.limit = 0xffff;
 	save->idtr.limit = 0xffff;
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch
