From: akpm@linux-foundation.org
Subject: + block-scsi_ioctlc-quiet-sparse-noise.patch added to -mm tree
Date: Mon, 02 Nov 2009 22:08:48 -0800
Message-ID: <200911030608.nA368mss025663@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54384 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750998AbZKCGIu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Nov 2009 01:08:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hartleys@visionengravers.com, James.Bottomley@HansenPartnership.com, hsweeten@visionengravers.com, jens.axboe@oracle.com


The patch titled
     block/scsi_ioctl.c: quiet sparse noise
has been added to the -mm tree.  Its filename is
     block-scsi_ioctlc-quiet-sparse-noise.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
linux-next.patch
clockeventsc-fix-symbol-was-not-declared-noise.patch
block-scsi_ioctlc-quiet-sparse-noise.patch
drivers-usb-core-hcdc-quiet-null-pointer-sparse-noise.patch
security-min_addrc-make-init_mmap_min_addr-static.patch
drivers-misc-add-driver-for-texas-instruments-dac7512.patch
drivers-misc-add-driver-for-texas-instruments-dac7512-update.patch
init-mainc-fix-symbol-shadows-noise.patch
kernel-sysc-fix-warning-do-while-statement-is-not-a-compound-statement-noise.patch

