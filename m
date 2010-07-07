From: akpm@linux-foundation.org
Subject: + drivers-usb-serial-io_tic-dont-return-0-if-writing-the-download-record-failed.patch added to -mm tree
Date: Wed, 07 Jul 2010 13:52:43 -0700
Message-ID: <201007072052.o67KqhvQ026049@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51730 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754607Ab0GGUxQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jul 2010 16:53:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, greg@kroah.com


The patch titled
     drivers/usb/serial/io_ti.c: don't return 0 if writing the download record failed
has been added to the -mm tree.  Its filename is
     drivers-usb-serial-io_tic-dont-return-0-if-writing-the-download-record-failed.patch

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
Subject: drivers/usb/serial/io_ti.c: don't return 0 if writing the download record failed
From: Roel Kluin <roel.kluin@gmail.com>

If the write download record failed we shouldn't return 0.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/io_ti.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/usb/serial/io_ti.c~drivers-usb-serial-io_tic-dont-return-0-if-writing-the-download-record-failed drivers/usb/serial/io_ti.c
--- a/drivers/usb/serial/io_ti.c~drivers-usb-serial-io_tic-dont-return-0-if-writing-the-download-record-failed
+++ a/drivers/usb/serial/io_ti.c
@@ -1321,7 +1321,7 @@ static int download_fw(struct edgeport_s
 				kfree(header);
 				kfree(rom_desc);
 				kfree(ti_manuf_desc);
-				return status;
+				return -EINVAL;
 			}
 
 			kfree(vheader);
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
mtd-return-1-if-verify-failed.patch
score-fix-dereference-of-null-pointer-in-local_flush_tlb_page.patch
osst-fix-read-buffer-overflow.patch
gdth-unmap-ccb_phys-when-scsi_add_host-fails-in-gdth_eisa_probe_one.patch
ncr5380-bit-mr_dma_mode-set-twice-in-ncr5380_transfer_dma.patch
dc395x-decrease-iteration-for-tag_number-of-max_command-in-start_scsi.patch
scsi-bfa-correct-onstack-wait_queue_head-declaration.patch
bfa-wrong-fcport-h2i-message-tested-in-bfa_fcport_isr.patch
drivers-usb-serial-io_tic-dont-return-0-if-writing-the-download-record-failed.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch

