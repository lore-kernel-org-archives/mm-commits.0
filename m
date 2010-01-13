From: akpm@linux-foundation.org
Subject: + musb-dont-dereference-null-tusb_dma-in-dma_controller_destroy.patch added to -mm tree
Date: Wed, 13 Jan 2010 13:45:52 -0800
Message-ID: <201001132145.o0DLjqds030364@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58582 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754981Ab0AMVqA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Jan 2010 16:46:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, felipe.balbi@nokia.com, greg@kroah.com


The patch titled
     musb: don't dereference NULL tusb_dma in dma_controller_destroy()
has been added to the -mm tree.  Its filename is
     musb-dont-dereference-null-tusb_dma-in-dma_controller_destroy.patch

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
Subject: musb: don't dereference NULL tusb_dma in dma_controller_destroy()
From: Roel Kluin <roel.kluin@gmail.com>

Test whether tusb_dma is not NULL before dereferencing

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

linux-next.patch
acpi-fix-confusion-in-acpi_evaluate_string-in-comment.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
v4l-dvb-wrong-variable-tested.patch
hisax-timeout-off-by-one-in-waitrecmsg.patch
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
dc395x-decrease-iteration-for-tag_number-of-max_command-in-start_scsi.patch
mpt2sas-fix-confusion-in-_scsih_sas_device_status_change_event.patch
paride-fix-off-by-one-test.patch
80211core-fix-confusion.patch
musb-test-always-evaluates-to-false.patch
musb-dont-dereference-null-tusb_dma-in-dma_controller_destroy.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
cryptocop-fix-assertion-in-create_output_descriptors.patch
asiliantfb-fix-test-of-unsigned-in-asiliant_calc_dclk2.patch
w1-fix-test-in-ds2482_wait_1wire_idle.patch

