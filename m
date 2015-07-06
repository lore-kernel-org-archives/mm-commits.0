From: akpm@linux-foundation.org
Subject: [merged] scsi-resolve-sg-buffer-const-ness-issue.patch removed
 from -mm tree
Date: Mon, 06 Jul 2015 12:47:35 -0700
Message-ID: <559adb57./yZRYVnl4Izr+3hX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59609 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755700AbbGFTrf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jul 2015 15:47:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david.s.gordon@intel.com, James.Bottomley@HansenPartnership.com, arnd@arndb.de, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/scsi/scsi_debug.c: resolve sg buffer const-ness issue
has been removed from the -mm tree.  Its filename was
     scsi-resolve-sg-buffer-const-ness-issue.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dave Gordon <david.s.gordon@intel.com>
Subject: drivers/scsi/scsi_debug.c: resolve sg buffer const-ness issue

do_device_access() takes a separate parameter to indicate the direction of
data transfer, which it used to use to select the appropriate function out
of sg_pcopy_{to,from}_buffer().  However these two functions now have

So this patch makes it bypass these wrappers and call the underlying
function sg_copy_buffer() directly; this has the same calling style as
do_device_access() i.e.  a separate direction-of-transfer parameter and no
pointers-to-const, so skipping the wrappers not only eliminates the
warning, it also make the code simpler :)

[akpm@linux-foundation.org: fix very broken build]
Signed-off-by: Dave Gordon <david.s.gordon@intel.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/scsi_debug.c   |   12 ++++--------
 include/linux/scatterlist.h |    3 +++
 lib/scatterlist.c           |    6 +++---
 3 files changed, 10 insertions(+), 11 deletions(-)

diff -puN drivers/scsi/scsi_debug.c~scsi-resolve-sg-buffer-const-ness-issue drivers/scsi/scsi_debug.c
--- a/drivers/scsi/scsi_debug.c~scsi-resolve-sg-buffer-const-ness-issue
+++ a/drivers/scsi/scsi_debug.c
@@ -2363,17 +2363,13 @@ do_device_access(struct scsi_cmnd *scmd,
 	u64 block, rest = 0;
 	struct scsi_data_buffer *sdb;
 	enum dma_data_direction dir;
-	size_t (*func)(struct scatterlist *, unsigned int, void *, size_t,
-		       off_t);
 
 	if (do_write) {
 		sdb = scsi_out(scmd);
 		dir = DMA_TO_DEVICE;
-		func = sg_pcopy_to_buffer;
 	} else {
 		sdb = scsi_in(scmd);
 		dir = DMA_FROM_DEVICE;
-		func = sg_pcopy_from_buffer;
 	}
 
 	if (!sdb->length)
@@ -2385,16 +2381,16 @@ do_device_access(struct scsi_cmnd *scmd,
 	if (block + num > sdebug_store_sectors)
 		rest = block + num - sdebug_store_sectors;
 
-	ret = func(sdb->table.sgl, sdb->table.nents,
+	ret = sg_copy_buffer(sdb->table.sgl, sdb->table.nents,
 		   fake_storep + (block * scsi_debug_sector_size),
-		   (num - rest) * scsi_debug_sector_size, 0);
+		   (num - rest) * scsi_debug_sector_size, 0, do_write);
 	if (ret != (num - rest) * scsi_debug_sector_size)
 		return ret;
 
 	if (rest) {
-		ret += func(sdb->table.sgl, sdb->table.nents,
+		ret += sg_copy_buffer(sdb->table.sgl, sdb->table.nents,
 			    fake_storep, rest * scsi_debug_sector_size,
-			    (num - rest) * scsi_debug_sector_size);
+			    (num - rest) * scsi_debug_sector_size, do_write);
 	}
 
 	return ret;
diff -puN include/linux/scatterlist.h~scsi-resolve-sg-buffer-const-ness-issue include/linux/scatterlist.h
--- a/include/linux/scatterlist.h~scsi-resolve-sg-buffer-const-ness-issue
+++ a/include/linux/scatterlist.h
@@ -265,6 +265,9 @@ int sg_alloc_table_from_pages(struct sg_
 	unsigned long offset, unsigned long size,
 	gfp_t gfp_mask);
 
+size_t sg_copy_buffer(struct scatterlist *sgl, unsigned int nents, void *buf,
+		      size_t buflen, off_t skip, bool to_buffer);
+
 size_t sg_copy_from_buffer(struct scatterlist *sgl, unsigned int nents,
 			   const void *buf, size_t buflen);
 size_t sg_copy_to_buffer(struct scatterlist *sgl, unsigned int nents,
diff -puN lib/scatterlist.c~scsi-resolve-sg-buffer-const-ness-issue lib/scatterlist.c
--- a/lib/scatterlist.c~scsi-resolve-sg-buffer-const-ness-issue
+++ a/lib/scatterlist.c
@@ -650,9 +650,8 @@ EXPORT_SYMBOL(sg_miter_stop);
  * Returns the number of copied bytes.
  *
  **/
-static size_t sg_copy_buffer(struct scatterlist *sgl, unsigned int nents,
-			     void *buf, size_t buflen, off_t skip,
-			     bool to_buffer)
+size_t sg_copy_buffer(struct scatterlist *sgl, unsigned int nents, void *buf,
+		      size_t buflen, off_t skip, bool to_buffer)
 {
 	unsigned int offset = 0;
 	struct sg_mapping_iter miter;
@@ -689,6 +688,7 @@ static size_t sg_copy_buffer(struct scat
 	local_irq_restore(flags);
 	return offset;
 }
+EXPORT_SYMBOL(sg_copy_buffer);
 
 /**
  * sg_copy_from_buffer - Copy from a linear buffer to an SG list
_

Patches currently in -mm which might be from david.s.gordon@intel.com are


