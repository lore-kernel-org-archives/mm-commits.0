From: akpm@linux-foundation.org
Subject: [merged] r8192u_core-test-for-negative-error-in-rtl8192_rx_isr.patch removed from -mm tree
Date: Mon, 21 Dec 2009 12:25:09 -0800
Message-ID: <200912212025.nBLKP9up027196@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37816 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752793AbZLUUZi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Dec 2009 15:25:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     r8192U_core: test for negative error in rtl8192_rx_isr()?
has been removed from the -mm tree.  Its filename was
     r8192u_core-test-for-negative-error-in-rtl8192_rx_isr.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
fujitsu-laptop-fix-tests-of-acpi_evaluate_integer-return.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
powerpc-85xx-wrong-variable-returned-on-error.patch
imx-bit-confusion.patch
serial-fix-test-of-unsigned.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
ibmmca-buffer-overflow.patch
scsi-eata-fix-buffer-overflow.patch
drivers-scsi-gdthc-fix-buffer-overflow.patch
drivers-scsi-u14-34fc-fix-uffer-overflow.patch
drivers-scsi-lpfc-lpfc_vportc-fix-read-buffer-overflow.patch
osst-fix-read-buffer-overflow.patch
gdth-unmap-ccb_phys-when-scsi_add_host-fails-in-gdth_eisa_probe_one.patch
zfcp-test-kmalloc-failure-in-scsi_get_vpd_page.patch
ncr5380-bit-mr_dma_mode-set-twice-in-ncr5380_transfer_dma.patch
scsi-pmcraid-redundant-check-in-pmcraid_check_ioctl_buffer.patch
drbd-fix-test-of-unsigned-in-_drbd_fault_random.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
cryptocop-fix-assertion-in-create_output_descriptors.patch
asiliantfb-fix-test-of-unsigned-in-asiliant_calc_dclk2.patch
hvc_console-fix-test-on-unsigned-in-hvc_console_print.patch
zlib-optimize-inffast-when-copying-direct-from-output.patch

