From: akpm@osdl.org
Subject: + kvm-make-the-get_sregs-and-set_sregs-ioctls-symmetric.patch added to -mm tree
Date: Mon, 11 Dec 2006 12:20:26 -0800
Message-ID: <200612112020.kBBKKQgt006077@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:33110 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937643AbWLKUUr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Dec 2006 15:20:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: uril@qumranet.com, avi@qumranet.com


The patch titled
     KVM: Make the GET_SREGS and SET_SREGS ioctls symmetric
has been added to the -mm tree.  Its filename is
     kvm-make-the-get_sregs-and-set_sregs-ioctls-symmetric.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 2 insertions(+)

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

origin.patch
kvm-make-the-get_sregs-and-set_sregs-ioctls-symmetric.patch

