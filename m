From: akpm@linux-foundation.org
Subject: - fix-scsi_send_eh_cmnd-scatterlist-handling.patch removed from -mm tree
Date: Wed, 04 Apr 2007 19:00:41 -0700
Message-ID: <200704050200.l3520fmd004843@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38062 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932470AbXDECAt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 4 Apr 2007 22:00:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davem@davemloft.net, James.Bottomley@steeleye.com, hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     Fix scsi_send_eh_cmnd scatterlist handling
has been removed from the -mm tree.  Its filename was
     fix-scsi_send_eh_cmnd-scatterlist-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix scsi_send_eh_cmnd scatterlist handling
From: David Miller <davem@davemloft.net>

This fixes a regression caused by commit:

2dc611de5a3fd955cd0298c50691d4c05046db97

The sense buffer code in scsi_send_eh_cmnd was changed to use alloc_page()
and a scatter list, but the sense data copy was not updated to match so
what we actually get in the sense buffer is total grabage starting with the
kernel address of the struct page we got.  Basically the stack frame of
scsi_send_eh_cmd() is what ends up in the sense buffer.

Depending upon how pointers look on a given platform, you can end up
getting sr_ioctl.c errors when you mount a cdrom.  If the CDROM gives a
check condition for GPCMD_GET_CONFIGURATION issued by
drivers/cdrom/cdrom.c:cdrom_mmc_profile(), sr_ioctl will spit out this
error message in sr_do_ioctl() with the way pointers are on sparc64:

		default:
			printk(KERN_ERR "%s: CDROM (ioctl) error, command: ", cd->cdi.name);
			__scsi_print_command(cgc->cmd);
			scsi_print_sense_hdr("sr", &sshdr);
			err = -EIO;

This is the error Tom Callaway reported in:

http://marc.info/?l=linux-sparc&m=117407453208101&w=2

Anyways, fix this by using page_address(sgl.page) which is OK because we
know this is low-mem due to GFP_ATOMIC.

Signed-off-by: David S. Miller <davem@davemloft.net>
Acked-by: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/scsi_error.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/scsi_error.c~fix-scsi_send_eh_cmnd-scatterlist-handling drivers/scsi/scsi_error.c
--- a/drivers/scsi/scsi_error.c~fix-scsi_send_eh_cmnd-scatterlist-handling
+++ a/drivers/scsi/scsi_error.c
@@ -726,7 +726,7 @@ static int scsi_send_eh_cmnd(struct scsi
 	 */
 	if (copy_sense) {
 		if (!SCSI_SENSE_VALID(scmd)) {
-			memcpy(scmd->sense_buffer, scmd->request_buffer,
+			memcpy(scmd->sense_buffer, page_address(sgl.page),
 			       sizeof(scmd->sense_buffer));
 		}
 		__free_page(sgl.page);
_

Patches currently in -mm which might be from davem@davemloft.net are

origin.patch
git-net.patch
git-net-vs-git-netdev-all.patch
fix-irq-problem-with-napi-netpoll.patch
remove-pci_dac_dma_-apis.patch
git-wireless-vs-git-net.patch
git-wireless-vs-git-net-2.patch
simplify-the-stacktrace-code.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
ipvs-flush-defense_work-before-module-unload.patch
unify-flush_work-flush_work_keventd-and-rename-it-to-cancel_work_sync.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-sparc64.patch
local_t-sparc64-cleanup.patch
