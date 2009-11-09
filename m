From: akpm@linux-foundation.org
Subject: [merged] block-scsi_ioctlc-quiet-sparse-noise.patch removed from -mm tree
Date: Mon, 09 Nov 2009 11:55:39 -0800
Message-ID: <200911091955.nA9JtdRG024470@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51940 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753854AbZKITzm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2009 14:55:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hartleys@visionengravers.com, James.Bottomley@HansenPartnership.com, hsweeten@visionengravers.com, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     block/scsi_ioctl.c: quiet sparse noise
has been removed from the -mm tree.  Its filename was
     block-scsi_ioctlc-quiet-sparse-noise.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: block/scsi_ioctl.c: quiet sparse noise
From: "H Hartley Sweeten" <hartleys@visionengravers.com>

Quiet sparse noise about symbol's not being declared.

Symbol blk_default_cmd_filter is only used locally and should be static.

The function blk_scsi_ioctl_init() is a fs_initcall and should also be
static.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/scsi_ioctl.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN block/scsi_ioctl.c~block-scsi_ioctlc-quiet-sparse-noise block/scsi_ioctl.c
--- a/block/scsi_ioctl.c~block-scsi_ioctlc-quiet-sparse-noise
+++ a/block/scsi_ioctl.c
@@ -35,7 +35,9 @@
 struct blk_cmd_filter {
 	unsigned long read_ok[BLK_SCSI_CMD_PER_LONG];
 	unsigned long write_ok[BLK_SCSI_CMD_PER_LONG];
-} blk_default_cmd_filter;
+};
+
+static struct blk_cmd_filter blk_default_cmd_filter;
 
 /* Command group 3 is reserved and should never be used.  */
 const unsigned char scsi_command_size_tbl[8] =
@@ -675,7 +677,7 @@ int scsi_cmd_ioctl(struct request_queue 
 }
 EXPORT_SYMBOL(scsi_cmd_ioctl);
 
-int __init blk_scsi_ioctl_init(void)
+static int __init blk_scsi_ioctl_init(void)
 {
 	blk_set_cmd_filter_defaults(&blk_default_cmd_filter);
 	return 0;
_

Patches currently in -mm which might be from hartleys@visionengravers.com are

linux-next.patch
clockeventsc-fix-symbol-was-not-declared-noise.patch
drivers-usb-core-hcdc-quiet-null-pointer-sparse-noise.patch
security-min_addrc-make-init_mmap_min_addr-static.patch
drivers-misc-add-driver-for-texas-instruments-dac7512.patch
drivers-misc-add-driver-for-texas-instruments-dac7512-update.patch
init-mainc-fix-symbol-shadows-noise.patch
kernel-sysc-fix-warning-do-while-statement-is-not-a-compound-statement-noise.patch

