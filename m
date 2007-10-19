From: akpm@linux-foundation.org
Subject: - libata-sff-correct-use-of-check_status.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:46:44 -0700
Message-ID: <200710190346.l9J3kivn013359@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56033 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934445AbXJSDzh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:55:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     libata-sff: correct use of check_status()
has been removed from the -mm tree.  Its filename was
     libata-sff-correct-use-of-check_status.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: libata-sff: correct use of check_status()
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

ata_check_status() does an SFF compliant check
ata_chk_status() does a generic call to ap->ops->check_status (usually
ata_check_status)

libata-sff uses the wrong one. Hardly suprising given the naming here,
which ought to get fixed to ata_sff_check_status() perhaps ?

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-sff.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/ata/libata-sff.c~libata-sff-correct-use-of-check_status drivers/ata/libata-sff.c
--- a/drivers/ata/libata-sff.c~libata-sff-correct-use-of-check_status
+++ a/drivers/ata/libata-sff.c
@@ -156,7 +156,7 @@ void ata_tf_read(struct ata_port *ap, st
 {
 	struct ata_ioports *ioaddr = &ap->ioaddr;
 
-	tf->command = ata_check_status(ap);
+	tf->command = ata_chk_status(ap);
 	tf->feature = ioread8(ioaddr->error_addr);
 	tf->nsect = ioread8(ioaddr->nsect_addr);
 	tf->lbal = ioread8(ioaddr->lbal_addr);
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
git-libata-all.patch
pata_cs5536-mwdma-fix.patch
serial-keep-the-dtr-setting-for-serial-console.patch
git-scsi-misc.patch
initio-fix-conflict-when-loading-driver.patch
isd200-sort-out-usb-ide-dependancy-mess.patch
usb_serial-stop-passing-null-to-functions-that-expect-data.patch
ark3116-update-termios-handling.patch
usb-serial-kill-another-case-we-pass-null-and-shouldnt.patch
ch341-fix-termios-handling.patch
digi_acceleport-fix-termios-and-also-readability-a-bit.patch
empeg-clean-up-and-handle-speeds.patch
ir_usb-termios-handling.patch
keyspan-termios-tidy.patch
kobil_sct-termios-encoding-fixups.patch
option-termios-handling.patch
sierra-termios.patch
usb-serial-handle-null-termios-methods-as-no-hardware-changing-support.patch
whiteheat-clean-up-cant-happen-checks-and-encode-baud.patch
cp2101-convert-to-new-termios.patch
ftd_sio-clean-ups-and-updates-for-new-termios-work.patch
ftd_sio-clean-ups-and-updates-for-new-termios-work-checkpatch-fixes.patch
io_edgeport-cleanups-and-tty-speed-reporting.patch
tty-kill-tty_flipbuf_size.patch
