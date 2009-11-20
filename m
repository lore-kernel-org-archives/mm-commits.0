From: akpm@linux-foundation.org
Subject: + usb-fix-bitfield-istl_flip-1-make-it-unsigned.patch added to -mm tree
Date: Fri, 20 Nov 2009 15:55:14 -0800
Message-ID: <200911202355.nAKNtEEM000765@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50209 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752851AbZKTXzL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Nov 2009 18:55:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, greg@kroah.com, vapier@gentoo.org


The patch titled
     usb: fix bitfield istl_flip:1, make it unsigned
has been added to the -mm tree.  Its filename is
     usb-fix-bitfield-istl_flip-1-make-it-unsigned.patch

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
Subject: usb: fix bitfield istl_flip:1, make it unsigned
From: Roel Kluin <roel.kluin@gmail.com>

istl_flip is a signed bitfield of one bit so it can be -1 or 0.  However
in drivers/usb/host/isp1362-hcd.c:1103:

finish_iso_transfers(isp1362_hcd,
	&isp1362_hcd->istl_queue[isp1362_hcd->istl_flip]);

So if isp1362_hcd->istl_flip is set, the 2nd argument becomes
&isp1362_hcd->istl_queue[-1], which is invalid.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: Mike Frysinger <vapier@gentoo.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/host/isp1362.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/usb/host/isp1362.h~usb-fix-bitfield-istl_flip-1-make-it-unsigned drivers/usb/host/isp1362.h
--- a/drivers/usb/host/isp1362.h~usb-fix-bitfield-istl_flip-1-make-it-unsigned
+++ a/drivers/usb/host/isp1362.h
@@ -534,8 +534,8 @@ struct isp1362_hcd {
 
 	/* periodic schedule: isochronous */
 	struct list_head	isoc;
-	int			istl_flip:1;
-	int			irq_active:1;
+	unsigned int		istl_flip:1;
+	unsigned int		irq_active:1;
 
 	/* Schedules for the current frame */
 	struct isp1362_ep_queue atl_queue;
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
fujitsu-laptop-fix-tests-of-acpi_evaluate_integer-return.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
sms-cards-make-id-unsigned-in-sms_get_board.patch
mtd-error-return-eio-instead-of-eio.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
ibmmca-buffer-overflow.patch
scsi-eata-fix-buffer-overflow.patch
drivers-scsi-gdthc-fix-buffer-overflow.patch
drivers-scsi-u14-34fc-fix-uffer-overflow.patch
drivers-scsi-lpfc-lpfc_vportc-fix-read-buffer-overflow.patch
osst-fix-read-buffer-overflow.patch
gdth-unmap-ccb_phys-when-scsi_add_host-fails-in-gdth_eisa_probe_one.patch
zfcp-test-kmalloc-failure-in-scsi_get_vpd_page.patch
st-fix-test-of-value-range-in-st_set_options.patch
ncr5380-bit-mr_dma_mode-set-twice-in-ncr5380_transfer_dma.patch
scsi-pmcraid-redundant-check-in-pmcraid_check_ioctl_buffer.patch
usb-fix-bitfield-istl_flip-1-make-it-unsigned.patch
page-types-unsigned-cannot-be-less-than-0-in-add_page.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
cryptocop-fix-assertion-in-create_output_descriptors.patch
gpio-fix-test-on-unsigned-in-lnw_irq_type.patch
fbdev-tv_paln-bit-set-twice-in-sisfb_detect_vb_connect.patch
hvc_console-fix-test-on-unsigned-in-hvc_console_print.patch
irq-fix-test-in-__exit-parport_mfc3_exit.patch
zlib-optimize-inffast-when-copying-direct-from-output.patch

