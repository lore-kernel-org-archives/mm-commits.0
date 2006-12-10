From: akpm@osdl.org
Subject: + kvm-add-missing-include.patch added to -mm tree
Date: Sun, 10 Dec 2006 11:14:26 -0800
Message-ID: <200612101914.kBAJEQAt000460@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51775 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762512AbWLJTPA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 14:15:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anthony@codemonkey.ws, avi@qumranet.com


The patch titled
     KVM: Add missing include
has been added to the -mm tree.  Its filename is
     kvm-add-missing-include.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: KVM: Add missing include
From: Anthony Liguori <anthony@codemonkey.ws>

load_TR_desc() lives in asm/desc.h, so #include that file.

Signed-off-by: Anthony Liguori <anthony@codemonkey.ws>
Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/vmx.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/kvm/vmx.c~kvm-add-missing-include drivers/kvm/vmx.c
--- a/drivers/kvm/vmx.c~kvm-add-missing-include
+++ a/drivers/kvm/vmx.c
@@ -22,6 +22,7 @@
 #include <linux/mm.h>
 #include <linux/highmem.h>
 #include <asm/io.h>
+#include <asm/desc.h>
 
 #include "segment_descriptor.h"
 
_

Patches currently in -mm which might be from anthony@codemonkey.ws are

kvm-userspace-interface.patch
kvm-add-missing-include.patch

