From: akpm@osdl.org
Subject: - kvm-make-the-get_sregs-and-set_sregs-ioctls-symmetric.patch removed from -mm tree
Date: Wed, 13 Dec 2006 22:01:54 -0800
Message-ID: <200612140601.kBE61sJ7001718@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51496 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751838AbWLNGCI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 01:02:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: uril@qumranet.com, avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: Make the GET_SREGS and SET_SREGS ioctls symmetric
has been removed from the -mm tree.  Its filename was
     kvm-make-the-get_sregs-and-set_sregs-ioctls-symmetric.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: KVM: Make the GET_SREGS and SET_SREGS ioctls symmetric
From: Uri Lublin <uril@qumranet.com>

This makes the SET_SREGS ioctl behave symmetrically to the GET_SREGS ioctl wrt
the segment access rights flag.

Signed-off-by: Uri Lublin <uril@qumranet.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/vmx.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/kvm/vmx.c~kvm-make-the-get_sregs-and-set_sregs-ioctls-symmetric drivers/kvm/vmx.c
--- a/drivers/kvm/vmx.c~kvm-make-the-get_sregs-and-set_sregs-ioctls-symmetric
+++ a/drivers/kvm/vmx.c
@@ -884,6 +884,8 @@ static void vmx_set_segment(struct kvm_v
 		ar |= (var->db & 1) << 14;
 		ar |= (var->g & 1) << 15;
 	}
+	if (ar == 0) /* a 0 value means unusable */
+		ar = AR_UNUSABLE_MASK;
 	vmcs_write32(sf->ar_bytes, ar);
 }
 
_

Patches currently in -mm which might be from uril@qumranet.com are


