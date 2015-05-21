From: akpm@linux-foundation.org
Subject: + scsi-resolve-sg-buffer-const-ness-issue.patch added to -mm tree
Date: Thu, 21 May 2015 13:25:59 -0700
Message-ID: <555e3f57.DoqFevLl8aZR3BKr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55818 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756869AbbEUU0A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 May 2015 16:26:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david.s.gordon@intel.com, James.Bottomley@HansenPartnership.com, arnd@arndb.de, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/scsi/scsi_debug.c: resolve sg buffer const-ness issue
has been added to the -mm tree.  Its filename is
     scsi-resolve-sg-buffer-const-ness-issue.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scsi-resolve-sg-buffer-const-ness-issue.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scsi-resolve-sg-buffer-const-ness-issue.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Signed-off-by: Dave Gordon <david.s.gordon@intel.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/scsi_debug.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

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
_

Patches currently in -mm which might be from david.s.gordon@intel.com are

lib-scatterlist-fix-kerneldoc-for-sg_pcopy_tofrom_buffer.patch
lib-scatterlist-mark-input-buffer-parameters-as-const.patch
scsi-resolve-sg-buffer-const-ness-issue.patch
linux-next.patch

