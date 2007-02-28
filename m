From: akpm@linux-foundation.org
Subject: - kvm-svm-intercept-smi-to-handle-it-at-host-level.patch removed from -mm tree
Date: Wed, 28 Feb 2007 15:54:53 -0800
Message-ID: <200702282354.l1SNsrIV031231@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48545 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932725AbXB1Xy7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Feb 2007 18:54:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joerg.roedel@amd.com, avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: SVM: intercept SMI to handle it at host level
has been removed from the -mm tree.  Its filename was
     kvm-svm-intercept-smi-to-handle-it-at-host-level.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: KVM: SVM: intercept SMI to handle it at host level
From: Joerg Roedel <joerg.roedel@amd.com>

Change the SVM code to intercept SMIs and handle it outside the guest.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/kvm/svm.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN drivers/kvm/svm.c~kvm-svm-intercept-smi-to-handle-it-at-host-level drivers/kvm/svm.c
--- a/drivers/kvm/svm.c~kvm-svm-intercept-smi-to-handle-it-at-host-level
+++ a/drivers/kvm/svm.c
@@ -486,6 +486,7 @@ static void init_vmcb(struct vmcb *vmcb)
 
 	control->intercept = 	(1ULL << INTERCEPT_INTR) |
 				(1ULL << INTERCEPT_NMI) |
+				(1ULL << INTERCEPT_SMI) |
 		/*
 		 * selective cr0 intercept bug?
 		 *    	0:   0f 22 d8                mov    %eax,%cr3
_

Patches currently in -mm which might be from joerg.roedel@amd.com are

git-kvm.patch
