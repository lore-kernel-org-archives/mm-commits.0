From: akpm@linux-foundation.org
Subject: + scsi_debug-fix-do_device_access-with-wrap-around-range.patch
 added to -mm tree
Date: Tue, 25 Jun 2013 13:52:51 -0700
Message-ID: <51ca0323.9nUnDIjCGMPrve8N%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42814 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586Ab3FYUww (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jun 2013 16:52:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, imre.deak@intel.com, horia.geanta@freescale.com, herbert@gondor.apana.org.au, dgilbert@interlog.com, davem@davemloft.net, JBottomley@parallels.com, akinobu.mita@gmail.com

Subject: + scsi_debug-fix-do_device_access-with-wrap-around-range.patch added to -mm tree
To: akinobu.mita@gmail.com,JBottomley@parallels.com,davem@davemloft.net,dgilbert@interlog.com,herbert@gondor.apana.org.au,horia.geanta@freescale.com,imre.deak@intel.com,tj@kernel.org
From: akpm@linux-foundation.org
Date: Tue, 25 Jun 2013 13:52:51 -0700


The patch titled
     Subject: scsi_debug: fix do_device_access() with wrap around range
has been added to the -mm tree.  Its filename is
     scsi_debug-fix-do_device_access-with-wrap-around-range.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: scsi_debug: fix do_device_access() with wrap around range

do_device_access() is a function that abstracts copying SG list from/to
ramdisk storage (fake_storep).

It must deal with the ranges exceeding actual fake_storep size, because
such ranges are valid if virtual_gb is set greater than zero, and they
should be treated as fake_storep is repeatedly mirrored up to virtual
size.

Unfortunately, it can't deal with the range which wraps around the end of
fake_storep.  A wrap around range is copied by two
sg_copy_{from,to}_buffer() calls, but sg_copy_{from,to}_buffer() can't
copy from/to in the middle of SG list, therefore the second call can't
copy correctly.

This fixes it by using sg_pcopy_{from,to}_buffer() that can copy from/to
the middle of SG list.

This also simplifies the assignment of sdb->resid in
fill_from_dev_buffer().  Because fill_from_dev_buffer() is now only called
once per command execution cycle.  So it is not necessary to take care to
decrease sdb->resid if fill_from_dev_buffer() is called more than once.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Horia Geanta <horia.geanta@freescale.com>
Cc: Imre Deak <imre.deak@intel.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/scsi_debug.c |   48 +++++++++++++++++++++++++++---------
 1 file changed, 37 insertions(+), 11 deletions(-)

diff -puN drivers/scsi/scsi_debug.c~scsi_debug-fix-do_device_access-with-wrap-around-range drivers/scsi/scsi_debug.c
--- a/drivers/scsi/scsi_debug.c~scsi_debug-fix-do_device_access-with-wrap-around-range
+++ a/drivers/scsi/scsi_debug.c
@@ -439,10 +439,7 @@ static int fill_from_dev_buffer(struct s
 
 	act_len = sg_copy_from_buffer(sdb->table.sgl, sdb->table.nents,
 				      arr, arr_len);
-	if (sdb->resid)
-		sdb->resid -= act_len;
-	else
-		sdb->resid = scsi_bufflen(scp) - act_len;
+	sdb->resid = scsi_bufflen(scp) - act_len;
 
 	return 0;
 }
@@ -1693,24 +1690,48 @@ static int check_device_access_params(st
 	return 0;
 }
 
+/* Returns number of bytes copied or -1 if error. */
 static int do_device_access(struct scsi_cmnd *scmd,
 			    struct sdebug_dev_info *devi,
 			    unsigned long long lba, unsigned int num, int write)
 {
 	int ret;
 	unsigned long long block, rest = 0;
-	int (*func)(struct scsi_cmnd *, unsigned char *, int);
+	struct scsi_data_buffer *sdb;
+	enum dma_data_direction dir;
+	size_t (*func)(struct scatterlist *, unsigned int, void *, size_t,
+		       off_t);
+
+	if (write) {
+		sdb = scsi_out(scmd);
+		dir = DMA_TO_DEVICE;
+		func = sg_pcopy_to_buffer;
+	} else {
+		sdb = scsi_in(scmd);
+		dir = DMA_FROM_DEVICE;
+		func = sg_pcopy_from_buffer;
+	}
 
-	func = write ? fetch_to_dev_buffer : fill_from_dev_buffer;
+	if (!sdb->length)
+		return 0;
+	if (!(scsi_bidi_cmnd(scmd) || scmd->sc_data_direction == dir))
+		return -1;
 
 	block = do_div(lba, sdebug_store_sectors);
 	if (block + num > sdebug_store_sectors)
 		rest = block + num - sdebug_store_sectors;
 
-	ret = func(scmd, fake_storep + (block * scsi_debug_sector_size),
-		   (num - rest) * scsi_debug_sector_size);
-	if (!ret && rest)
-		ret = func(scmd, fake_storep, rest * scsi_debug_sector_size);
+	ret = func(sdb->table.sgl, sdb->table.nents,
+		   fake_storep + (block * scsi_debug_sector_size),
+		   (num - rest) * scsi_debug_sector_size, 0);
+	if (ret != (num - rest) * scsi_debug_sector_size)
+		return ret;
+
+	if (rest) {
+		ret += func(sdb->table.sgl, sdb->table.nents,
+			    fake_storep, rest * scsi_debug_sector_size,
+			    (num - rest) * scsi_debug_sector_size);
+	}
 
 	return ret;
 }
@@ -1849,7 +1870,12 @@ static int resp_read(struct scsi_cmnd *S
 	read_lock_irqsave(&atomic_rw, iflags);
 	ret = do_device_access(SCpnt, devip, lba, num, 0);
 	read_unlock_irqrestore(&atomic_rw, iflags);
-	return ret;
+	if (ret == -1)
+		return DID_ERROR << 16;
+
+	scsi_in(SCpnt)->resid = scsi_bufflen(SCpnt) - ret;
+
+	return 0;
 }
 
 void dump_sector(unsigned char *buf, int len)
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

linux-next.patch
lib-scatterlist-factor-out-sg_miter_get_next_page-from-sg_miter_next.patch
lib-scatterlist-introduce-sg_pcopy_from_buffer-and-sg_pcopy_to_buffer.patch
crypto-talitos-use-sg_pcopy_to_buffer.patch
scsi_debug-fix-do_device_access-with-wrap-around-range.patch

