From: akpm@linux-foundation.org
Subject: + kvm-svm-intercept-smi-to-handle-it-at-host-level.patch added to -mm tree
Date: Wed, 21 Feb 2007 12:49:51 -0800
Message-ID: <200702212049.l1LKnpDr025490@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44166 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161356AbXBUUuF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 15:50:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joerg.roedel@amd.com, avi@qumranet.com


The patch titled
     KVM: SVM: intercept SMI to handle it at host level
has been added to the -mm tree.  Its filename is
     kvm-svm-intercept-smi-to-handle-it-at-host-level.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

kvm-vmx-hack-set_cr0_no_modeswitch-to-actually-do.patch
kvm-svm-intercept-smi-to-handle-it-at-host-level.patch
