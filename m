From: akpm@linux-foundation.org
Subject: + r8192u_core-test-for-negative-error-in-rtl8192_rx_isr.patch added to -mm tree
Date: Mon, 23 Nov 2009 15:21:36 -0800
Message-ID: <200911232321.nANNLa1o009318@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55730 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757299AbZKWXVc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Nov 2009 18:21:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, greg@kroah.com


The patch titled
     r8192U_core: test for negative error in rtl8192_rx_isr()?
has been added to the -mm tree.  Its filename is
     r8192u_core-test-for-negative-error-in-rtl8192_rx_isr.patch

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
Subject: r8192U_core: test for negative error in rtl8192_rx_isr()?
From: Roel Kluin <roel.kluin@gmail.com>

The error tested for is negative

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/rtl8192su/r8192U_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/staging/rtl8192su/r8192U_core.c~r8192u_core-test-for-negative-error-in-rtl8192_rx_isr drivers/staging/rtl8192su/r8192U_core.c
--- a/drivers/staging/rtl8192su/r8192U_core.c~r8192u_core-test-for-negative-error-in-rtl8192_rx_isr
+++ a/drivers/staging/rtl8192su/r8192U_core.c
@@ -1501,7 +1501,7 @@ static void rtl8192_rx_isr(struct urb *u
         urb->context = skb;
         skb_queue_tail(&priv->rx_queue, skb);
         err = usb_submit_urb(urb, GFP_ATOMIC);
-	if(err && err != EPERM)
+	if(err && err != -EPERM)
 		printk("can not submit rxurb, err is %x,URB status is %x\n",err,urb->status);
 }
 
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

thinkpad-acpi-fix-sign-of-erestartsys-return.patch
linux-next.patch
v4l-dvb-mxl5007tc-fix-test-in-copy_reg_bits.patch
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
r8192u_core-test-for-negative-error-in-rtl8192_rx_isr.patch
page-types-unsigned-cannot-be-less-than-0-in-add_page.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
cryptocop-fix-assertion-in-create_output_descriptors.patch
gpio-fix-test-on-unsigned-in-lnw_irq_type.patch
fbdev-tv_paln-bit-set-twice-in-sisfb_detect_vb_connect.patch
hvc_console-fix-test-on-unsigned-in-hvc_console_print.patch
irq-fix-test-in-__exit-parport_mfc3_exit.patch
zlib-optimize-inffast-when-copying-direct-from-output.patch

