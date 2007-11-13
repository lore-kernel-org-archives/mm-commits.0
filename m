From: akpm@linux-foundation.org
Subject: - libata-dont-fail-ata-device-revalidation-for-bad-_gtf-methods.patch removed from -mm tree
Date: Mon, 12 Nov 2007 20:07:16 -0800
Message-ID: <200711130407.lAD47FCA025222@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45331 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757855AbXKMEHh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Nov 2007 23:07:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mjg59@srcf.ucam.org, roppedisano@infracomspa.it, mm-commits@vger.kernel.org


The patch titled
     libata: don't fail ata device revalidation for bad _GTF methods
has been removed from the -mm tree.  Its filename was
     libata-dont-fail-ata-device-revalidation-for-bad-_gtf-methods.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: libata: don't fail ata device revalidation for bad _GTF methods
From: Matthew Garrett <mjg59@srcf.ucam.org>

Experience suggests that the _GTF method may be bad.  We currently fail
device revalidation in that case, which seems excessive.

Signed-off-by: Matthew Garrett <mjg59@srcf.ucam.org>
Tested-by: Roberto Oppedisano <roppedisano@infracomspa.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-acpi.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff -puN drivers/ata/libata-acpi.c~libata-dont-fail-ata-device-revalidation-for-bad-_gtf-methods drivers/ata/libata-acpi.c
--- a/drivers/ata/libata-acpi.c~libata-dont-fail-ata-device-revalidation-for-bad-_gtf-methods
+++ a/drivers/ata/libata-acpi.c
@@ -312,7 +312,7 @@ EXPORT_SYMBOL_GPL(ata_acpi_stm);
  *
  * RETURNS:
  * Number of taskfiles on success, 0 if _GTF doesn't exist or doesn't
- * contain valid data.  -errno on other errors.
+ * contain valid data.
  */
 static int ata_dev_get_GTF(struct ata_device *dev, struct ata_acpi_gtf **gtf,
 			   void **ptr_to_free)
@@ -339,7 +339,6 @@ static int ata_dev_get_GTF(struct ata_de
 			ata_dev_printk(dev, KERN_WARNING,
 				       "_GTF evaluation failed (AE 0x%x)\n",
 				       status);
-			rc = -EIO;
 		}
 		goto out_free;
 	}
@@ -359,7 +358,6 @@ static int ata_dev_get_GTF(struct ata_de
 		ata_dev_printk(dev, KERN_WARNING,
 			       "_GTF unexpected object type 0x%x\n",
 			       out_obj->type);
-		rc = -EINVAL;
 		goto out_free;
 	}
 
@@ -367,7 +365,6 @@ static int ata_dev_get_GTF(struct ata_de
 		ata_dev_printk(dev, KERN_WARNING,
 			       "unexpected _GTF length (%d)\n",
 			       out_obj->buffer.length);
-		rc = -EINVAL;
 		goto out_free;
 	}
 
@@ -511,10 +508,7 @@ static int ata_acpi_exec_tfs(struct ata_
 	int gtf_count, i, rc;
 
 	/* get taskfiles */
-	rc = ata_dev_get_GTF(dev, &gtf, &ptr_to_free);
-	if (rc < 0)
-		return rc;
-	gtf_count = rc;
+	gtf_count = ata_dev_get_GTF(dev, &gtf, &ptr_to_free);
 
 	/* execute them */
 	for (i = 0, rc = 0; i < gtf_count; i++) {
_

Patches currently in -mm which might be from mjg59@srcf.ucam.org are

origin.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
