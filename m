From: akpm@linux-foundation.org
Subject: + libata-dont-fail-ata-device-revalidation-for-bad-_gtf-methods.patch added to -mm tree
Date: Thu, 08 Nov 2007 11:04:40 -0800
Message-ID: <200711081904.lA8J4ew6009781@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44301 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761481AbXKHTEr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Nov 2007 14:04:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mjg59@srcf.ucam.org


The patch titled
     libata: don't fail ata device revalidation for bad _GTF methods
has been added to the -mm tree.  Its filename is
     libata-dont-fail-ata-device-revalidation-for-bad-_gtf-methods.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: libata: don't fail ata device revalidation for bad _GTF methods
From: Matthew Garrett <mjg59@srcf.ucam.org>

Experience suggests that the _GTF method may be bad.  We currently fail
device revalidation in that case, which seems excessive.

Signed-off-by: Matthew Garrett <mjg59@srcf.ucam.org>
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

working-3d-dri-intel-agpko-resume-for-i815-chip.patch
libata-dont-fail-ata-device-revalidation-for-bad-_gtf-methods.patch
