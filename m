From: akpm@osdl.org
Subject: - libata-wrong-sizeof-for-buffer.patch removed from -mm tree
Date: Wed, 20 Dec 2006 16:36:59 -0800
Message-ID: <200612210036.kBL0axEB011251@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53398 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161103AbWLUAhI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Dec 2006 19:37:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fiodor.f.suietov@intel.com, htejun@gmail.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     libata: wrong sizeof for BUFFER
has been removed from the -mm tree.  Its filename was
     libata-wrong-sizeof-for-buffer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: libata: wrong sizeof for BUFFER
From: Fiodor Suietov <fiodor.f.suietov@intel.com>

I have reproduced the AE_AML_BUFFER_LIMIT exception mentioned in
<http://bugzilla.kernel.org/show_bug.cgi?id=7689> basing on the SSDT ASL
code and libata ata_acpi_push_id() code.  There is an oversight in
ata_acpi_push_id() causing the exception.  The following update fixes it:

Signed-off-by: Fiodor Suietov <fiodor.f.suietov@intel.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/ata/libata-acpi.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/ata/libata-acpi.c~libata-wrong-sizeof-for-buffer drivers/ata/libata-acpi.c
--- a/drivers/ata/libata-acpi.c~libata-wrong-sizeof-for-buffer
+++ a/drivers/ata/libata-acpi.c
@@ -672,7 +672,7 @@ int ata_acpi_push_id(struct ata_port *ap
 	input.count = 1;
 	input.pointer = in_params;
 	in_params[0].type = ACPI_TYPE_BUFFER;
-	in_params[0].buffer.length = sizeof(atadev->id[0] * ATA_ID_WORDS);
+	in_params[0].buffer.length = sizeof(atadev->id[0]) * ATA_ID_WORDS;
 	in_params[0].buffer.pointer = (u8 *)atadev->id;
 	/* Output buffer: _SDD has no output */
 
_

Patches currently in -mm which might be from fiodor.f.suietov@intel.com are

git-libata-all.patch

