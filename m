From: akpm@linux-foundation.org
Subject: [merged] musb-dont-dereference-null-tusb_dma-in-dma_controller_destroy.patch removed from -mm tree
Date: Thu, 21 Jan 2010 13:29:15 -0800
Message-ID: <201001212129.o0LLTFs4030794@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52230 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755372Ab0AUV3X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Jan 2010 16:29:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, felipe.balbi@nokia.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     musb: don't dereference NULL tusb_dma in dma_controller_destroy()
has been removed from the -mm tree.  Its filename was
     musb-dont-dereference-null-tusb_dma-in-dma_controller_destroy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: musb: don't dereference NULL tusb_dma in dma_controller_destroy()
From: Roel Kluin <roel.kluin@gmail.com>

Test whether tusb_dma is not NULL before dereferencing.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Felipe Balbi <felipe.balbi@nokia.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/musb/tusb6010_omap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/usb/musb/tusb6010_omap.c~musb-dont-dereference-null-tusb_dma-in-dma_controller_destroy drivers/usb/musb/tusb6010_omap.c
--- a/drivers/usb/musb/tusb6010_omap.c~musb-dont-dereference-null-tusb_dma-in-dma_controller_destroy
+++ a/drivers/usb/musb/tusb6010_omap.c
@@ -648,7 +648,7 @@ void dma_controller_destroy(struct dma_c
 		}
 	}
 
-	if (!tusb_dma->multichannel && tusb_dma && tusb_dma->ch >= 0)
+	if (tusb_dma && !tusb_dma->multichannel && tusb_dma->ch >= 0)
 		omap_free_dma(tusb_dma->ch);
 
 	kfree(tusb_dma);
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
acpi-fix-confusion-in-acpi_evaluate_string-in-comment.patch
asus-acpi-remove-duplicate-comparison-of-asus_model-strings.patch
gemini-wrong-registers-used-to-set-reg_level-in-gpio_set_irq_type.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
ia64-wrong-attribute-of-hub-chip-written-in-uv_setup.patch
hisax-timeout-off-by-one-in-waitrecmsg.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
drivers-scsi-gdthc-fix-buffer-overflow.patch
drivers-scsi-lpfc-lpfc_vportc-fix-read-buffer-overflow.patch
osst-fix-read-buffer-overflow.patch
gdth-unmap-ccb_phys-when-scsi_add_host-fails-in-gdth_eisa_probe_one.patch
ncr5380-bit-mr_dma_mode-set-twice-in-ncr5380_transfer_dma.patch
scsi-pmcraid-redundant-check-in-pmcraid_check_ioctl_buffer.patch
dc395x-decrease-iteration-for-tag_number-of-max_command-in-start_scsi.patch
mpt2sas-fix-confusion-in-_scsih_sas_device_status_change_event.patch
paride-fix-off-by-one-test.patch
musb-test-always-evaluates-to-false.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
cryptocop-fix-assertion-in-create_output_descriptors.patch
asiliantfb-fix-test-of-unsigned-in-asiliant_calc_dclk2.patch
w1-fix-test-in-ds2482_wait_1wire_idle.patch

