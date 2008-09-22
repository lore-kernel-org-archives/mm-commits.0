From: akpm@linux-foundation.org
Subject: - bnx2-promote-vector-field-in-bnx2_irq-structure-from-u16-to-unsigned-int.patch removed from -mm tree
Date: Mon, 22 Sep 2008 00:12:06 -0700
Message-ID: <200809220712.m8M7C6a2028710@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56658 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751393AbYIVHNd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Sep 2008 03:13:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: benli@broadcom.com, jeff@garzik.org, mchan@broadcom.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     bnx2: promote vector field in bnx2_irq structure from u16 to unsigned int
has been removed from the -mm tree.  Its filename was
     bnx2-promote-vector-field-in-bnx2_irq-structure-from-u16-to-unsigned-int.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bnx2: promote vector field in bnx2_irq structure from u16 to unsigned int
From: Benjamin Li <benli@broadcom.com>

The bnx2 driver stores/uses the irq value from the pci_dev internally. 
But when it stores the irq value, it has been performing an integer
demotion.  Because of the recent changes made to
arch/x86/kernel/io_apic.c, the new method in creating the irq value (using
build_irq_for_pci_dev()) has exposed this bug on x86 systems.

Because of this demotion when calling request_irq() from
bnx2_request_irq(), the driver would get a return code of -EINVAL.  This
is because the kernel could not find the requested irq descriptor.  By
storing the irq value properly, the kernel can find the correct irq
descriptor and the bnx2 driver can operate normally.

Signed-off-by: Benjamin Li <benli@broadcom.com>
Signed-off-by: Michael Chan <mchan@broadcom.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/bnx2.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/bnx2.h~bnx2-promote-vector-field-in-bnx2_irq-structure-from-u16-to-unsigned-int drivers/net/bnx2.h
--- a/drivers/net/bnx2.h~bnx2-promote-vector-field-in-bnx2_irq-structure-from-u16-to-unsigned-int
+++ a/drivers/net/bnx2.h
@@ -6597,7 +6597,7 @@ struct flash_spec {
 
 struct bnx2_irq {
 	irq_handler_t	handler;
-	u16		vector;
+	unsigned int	vector;
 	u8		requested;
 	char		name[16];
 };
_

Patches currently in -mm which might be from benli@broadcom.com are


