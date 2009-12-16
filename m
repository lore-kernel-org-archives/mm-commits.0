From: akpm@linux-foundation.org
Subject: + thermal-fix-test-of-unsigned-in-thermal_cooling_device_cur_state_store.patch added to -mm tree
Date: Wed, 16 Dec 2009 15:01:22 -0800
Message-ID: <200912162301.nBGN1MKP020414@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59259 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964874AbZLPXCH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 18:02:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, lenb@kernel.org, rui.zhang@intel.com


The patch titled
     thermal: fix test of unsigned in thermal_cooling_device_cur_state_store()
has been added to the -mm tree.  Its filename is
     thermal-fix-test-of-unsigned-in-thermal_cooling_device_cur_state_store.patch

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
Subject: thermal: fix test of unsigned in thermal_cooling_device_cur_state_store()
From: Roel Kluin <roel.kluin@gmail.com>

state is unsigned long so the test did not work.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: Zhang Rui <rui.zhang@intel.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/thermal/thermal_sys.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/thermal/thermal_sys.c~thermal-fix-test-of-unsigned-in-thermal_cooling_device_cur_state_store drivers/thermal/thermal_sys.c
--- a/drivers/thermal/thermal_sys.c~thermal-fix-test-of-unsigned-in-thermal_cooling_device_cur_state_store
+++ a/drivers/thermal/thermal_sys.c
@@ -377,7 +377,7 @@ thermal_cooling_device_cur_state_store(s
 	if (!sscanf(buf, "%ld\n", &state))
 		return -EINVAL;
 
-	if (state < 0)
+	if ((long)state < 0)
 		return -EINVAL;
 
 	result = cdev->ops->set_cur_state(cdev, state);
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
fujitsu-laptop-fix-tests-of-acpi_evaluate_integer-return.patch
thermal-fix-test-of-unsigned-in-thermal_cooling_device_cur_state_store.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
powerpc-85xx-wrong-variable-returned-on-error.patch
hidp-ptr_err-return-of-wrong-pointer-in-hidp_setup_hid.patch
imx-bit-confusion.patch
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
r8192u_core-test-for-negative-error-in-rtl8192_rx_isr.patch
keys-ptr_err-return-of-wrong-pointer-in-keyctl_get_security.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
cryptocop-fix-assertion-in-create_output_descriptors.patch
hvc_console-fix-test-on-unsigned-in-hvc_console_print.patch
zlib-optimize-inffast-when-copying-direct-from-output.patch

