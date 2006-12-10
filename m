From: akpm@osdl.org
Subject: + libata-fix-oops-with-sparsemem.patch added to -mm tree
Date: Sun, 10 Dec 2006 12:12:55 -0800
Message-ID: <200612102012.kBAKCtpp001939@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57774 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762472AbWLJUNR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 15:13:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arnd.bergmann@de.ibm.com, htejun@gmail.com, jeff@garzik.org


The patch titled
     libata: fix oops with sparsemem
has been added to the -mm tree.  Its filename is
     libata-fix-oops-with-sparsemem.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: libata: fix oops with sparsemem
From: Arnd Bergmann <arnd.bergmann@de.ibm.com>

libata incorrectly passes NULL arguments to sg_set_buf, which crashes on
powerpc64 when looking for the corresponding mem_section.

This introduces a new ata_exec_nodma() wrapper that takes no buffer
arguments and does not call sg_set_buf either.  In order to make it easier
to detect this sort of problem, it also adds a WARN_ON(!buf) to
sg_set_buf() so we get a log message even platforms without sparsemem.

Signed-off-by: Arnd Bergmann <arnd.bergmann@de.ibm.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/ata/libata-core.c   |   27 +++++++++++++++++++++++----
 include/linux/scatterlist.h |    2 ++
 2 files changed, 25 insertions(+), 4 deletions(-)

diff -puN drivers/ata/libata-core.c~libata-fix-oops-with-sparsemem drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~libata-fix-oops-with-sparsemem
+++ a/drivers/ata/libata-core.c
@@ -1336,7 +1336,7 @@ unsigned ata_exec_internal_sg(struct ata
 }
 
 /**
- *	ata_exec_internal_sg - execute libata internal command
+ *	ata_exec_internal - execute libata internal command
  *	@dev: Device to which the command is sent
  *	@tf: Taskfile registers for the command and the result
  *	@cdb: CDB for packet command
@@ -1365,6 +1365,25 @@ unsigned ata_exec_internal(struct ata_de
 }
 
 /**
+ *	ata_exec_nodma - execute libata internal command
+ *	@dev: Device to which the command is sent
+ *	@tf: Taskfile registers for the command and the result
+ *
+ *	Wrapper around ata_exec_internal_sg() which takes no
+ *	data buffer.
+ *
+ *	LOCKING:
+ *	None.  Should be called with kernel context, might sleep.
+ *
+ *	RETURNS:
+ *	Zero on success, AC_ERR_* mask on failure
+ */
+static unsigned ata_exec_nodma(struct ata_device *dev, struct ata_taskfile *tf)
+{
+	return ata_exec_internal_sg(dev, tf, NULL, DMA_NONE, NULL, 0);
+}
+
+/**
  *	ata_do_simple_cmd - execute simple internal command
  *	@dev: Device to which the command is sent
  *	@cmd: Opcode to execute
@@ -1388,7 +1407,7 @@ unsigned int ata_do_simple_cmd(struct at
 	tf.flags |= ATA_TFLAG_DEVICE;
 	tf.protocol = ATA_PROT_NODATA;
 
-	return ata_exec_internal(dev, &tf, NULL, DMA_NONE, NULL, 0);
+	return ata_exec_nodma(dev, &tf);
 }
 
 /**
@@ -3489,7 +3508,7 @@ static unsigned int ata_dev_set_xfermode
 	tf.protocol = ATA_PROT_NODATA;
 	tf.nsect = dev->xfer_mode;
 
-	err_mask = ata_exec_internal(dev, &tf, NULL, DMA_NONE, NULL, 0);
+	err_mask = ata_exec_nodma(dev, &tf);
 
 	DPRINTK("EXIT, err_mask=%x\n", err_mask);
 	return err_mask;
@@ -3527,7 +3546,7 @@ static unsigned int ata_dev_init_params(
 	tf.nsect = sectors;
 	tf.device |= (heads - 1) & 0x0f; /* max head = num. of heads - 1 */
 
-	err_mask = ata_exec_internal(dev, &tf, NULL, DMA_NONE, NULL, 0);
+	err_mask = ata_exec_nodma(dev, &tf);
 
 	DPRINTK("EXIT, err_mask=%x\n", err_mask);
 	return err_mask;
diff -puN include/linux/scatterlist.h~libata-fix-oops-with-sparsemem include/linux/scatterlist.h
--- a/include/linux/scatterlist.h~libata-fix-oops-with-sparsemem
+++ a/include/linux/scatterlist.h
@@ -8,6 +8,8 @@
 static inline void sg_set_buf(struct scatterlist *sg, const void *buf,
 			      unsigned int buflen)
 {
+	WARN_ON(!buf); /* virt_to_page(NULL) crashes with sparsemem */
+
 	sg->page = virt_to_page(buf);
 	sg->offset = offset_in_page(buf);
 	sg->length = buflen;
_

Patches currently in -mm which might be from arnd.bergmann@de.ibm.com are

origin.patch
libata-fix-oops-with-sparsemem.patch

