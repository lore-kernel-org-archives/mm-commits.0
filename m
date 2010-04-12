From: akpm@linux-foundation.org
Subject: [obsolete] drivers-scsi-qla2xxx-qla_attrc-add-missing-unlock.patch removed from -mm tree
Date: Mon, 12 Apr 2010 12:13:02 -0400
Message-ID: <201004121914.o3CJEetQ021806@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53586 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753616Ab0DLTOu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Apr 2010 15:14:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, James.Bottomley@HansenPartnership.com, andrew.vasquez@qlogic.com, giridhar.malavali@qlogic.com, mm-commits@vger.kernel.org


The patch titled
     drivers/scsi/qla2xxx/qla_attr.c: add missing unlock
has been removed from the -mm tree.  Its filename was
     drivers-scsi-qla2xxx-qla_attrc-add-missing-unlock.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/scsi/qla2xxx/qla_attr.c: add missing unlock
From: Julia Lawall <julia@diku.dk>

This code represents error handling code.  Add an unlock as done in the
normal exit path from the function.

A simplified version of the semantic patch that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
expression E1;
identifier f;
@@

f (...) { <+...
* spin_lock_irqsave (E1,...);
... when != E1
* return ...;
...+> }
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/qla2xxx/qla_attr.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/scsi/qla2xxx/qla_attr.c~drivers-scsi-qla2xxx-qla_attrc-add-missing-unlock drivers/scsi/qla2xxx/qla_attr.c
--- a/drivers/scsi/qla2xxx/qla_attr.c~drivers-scsi-qla2xxx-qla_attrc-add-missing-unlock
+++ a/drivers/scsi/qla2xxx/qla_attr.c
@@ -2398,6 +2398,7 @@ done:
 		kfree(sp->fcport);
 	kfree(sp->ctx);
 	mempool_free(sp, ha->srb_mempool);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	return 0;
 }
 
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
linux-next.patch
drivers-scsi-qla2xxx-qla_attrc-add-missing-unlock.patch
drivers-serial-pmac_zilogc-add-missing-unlock.patch
drivers-usb-gadget-s3c-hsotgc-add-missing-unlock.patch
drivers-acpi-use-kasprintf.patch
drivers-acpi-use-kasprintf-fix.patch
arch-x86-pci-use-kasprintf.patch
arch-arm-plat-pxa-dmac-correct-null-test.patch
drivers-media-video-avoid-null-dereference.patch
drivers-scsi-libsas-use-sam_good.patch
drivers-scsi-remove-unnecessary-null-test.patch
drivers-message-move-dereference-after-null-test.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-char-ppdevc-use-kasprintf.patch
drivers-edac-introduce-missing-kfree.patch

