From: akpm@linux-foundation.org
Subject: + floppy-remove-dead-commented-out-code-from-floppy-driver.patch added to -mm tree
Date: Wed, 18 Jul 2007 22:07:35 -0700
Message-ID: <200707190507.l6J57Z0j014906@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55217 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751551AbXGSFHm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 01:07:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jesper.juhl@gmail.com


The patch titled
     floppy: remove dead/commented out code from floppy driver
has been added to the -mm tree.  Its filename is
     floppy-remove-dead-commented-out-code-from-floppy-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: floppy: remove dead/commented out code from floppy driver
From: Jesper Juhl <jesper.juhl@gmail.com>

A good initial step for a cleanup seems to me to be getting rid of old dead
code.  This stuff is either commented out or inside '#if 0' so it is not
currently in use at all, let's just get rid of it once and for all.  That's a
few lines less to deal with.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/floppy.c |   27 +--------------------------
 1 file changed, 1 insertion(+), 26 deletions(-)

diff -puN drivers/block/floppy.c~floppy-remove-dead-commented-out-code-from-floppy-driver drivers/block/floppy.c
--- a/drivers/block/floppy.c~floppy-remove-dead-commented-out-code-from-floppy-driver
+++ a/drivers/block/floppy.c
@@ -768,7 +768,6 @@ static int disk_change(int drive)
 			floppy_sizes[TOMINOR(drive)] = MAX_DISK_SIZE << 1;
 		}
 
-		/*USETF(FD_DISK_NEWCHANGE); */
 		return 1;
 	} else {
 		UDRS->last_checked = jiffies;
@@ -1324,7 +1323,6 @@ static void fdc_specify(void)
 	if (FDCS->need_configure && FDCS->version >= FDC_82072A) {
 		fdc_configure();
 		FDCS->need_configure = 0;
-		/*DPRINT("FIFO enabled\n"); */
 	}
 
 	switch (raw_cmd->rate & 0x03) {
@@ -1919,8 +1917,6 @@ static void floppy_shutdown(unsigned lon
 	is_alive("floppy shutdown");
 }
 
-/*typedef void (*timeout_fn)(unsigned long);*/
-
 /* start motor, check media-changed condition and write protection */
 static int start_motor(void (*function)(void))
 {
@@ -2578,19 +2574,6 @@ static void copy_buffer(int ssize, int m
 #endif
 }
 
-#if 0
-static inline int check_dma_crossing(char *start,
-				     unsigned long length, char *message)
-{
-	if (CROSS_64KB(start, length)) {
-		printk("DMA xfer crosses 64KB boundary in %s %p-%p\n",
-		       message, start, start + length);
-		return 1;
-	} else
-		return 0;
-}
-#endif
-
 /* work around a bug in pseudo DMA
  * (on some FDCs) pseudo DMA does not stop when the CPU stops
  * sending data.  Hence we need a different way to signal the
@@ -2788,9 +2771,7 @@ static int make_raw_rw_request(void)
 		 */
 		if (!direct ||
 		    (indirect * 2 > direct * 3 &&
-		     *errors < DP->max_errors.read_track &&
-		     /*!TESTF(FD_NEED_TWADDLE) && */
-		     ((!probing
+		     *errors < DP->max_errors.read_track && ((!probing
 		       || (DP->read_track & (1 << DRS->probed_format)))))) {
 			max_size = current_req->nr_sectors;
 		} else {
@@ -2803,10 +2784,6 @@ static int make_raw_rw_request(void)
 				       indirect, direct, fsector_t);
 				return 0;
 			}
-/*			check_dma_crossing(raw_cmd->kernel_data,
-					   raw_cmd->length,
-					   "end of make_raw_request [1]");*/
-
 			virtualdmabug_workaround();
 			return 2;
 		}
@@ -2856,8 +2833,6 @@ static int make_raw_rw_request(void)
 	raw_cmd->length = ((raw_cmd->length - 1) | (ssize - 1)) + 1;
 	raw_cmd->length <<= 9;
 #ifdef FLOPPY_SANITY_CHECK
-	/*check_dma_crossing(raw_cmd->kernel_data, raw_cmd->length, 
-	   "end of make_raw_request"); */
 	if ((raw_cmd->length < current_count_sectors << 9) ||
 	    (raw_cmd->kernel_data != current_req->buffer &&
 	     CT(COMMAND) == FD_WRITE &&
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

origin.patch
fix-acpi_ev_pci_config_region_setup-to-avoid-memory-leak.patch
git-mtd.patch
remove-unneeded-test-of-task-in-dump_trace.patch
git-xfs.patch
floppy-do-a-very-minimal-style-cleanup-of-the-floppy-driver.patch
floppy-remove-dead-commented-out-code-from-floppy-driver.patch
floppy-remove-register-keyword-use-from-floppy-driver.patch
