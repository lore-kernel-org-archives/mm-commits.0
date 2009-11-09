From: akpm@linux-foundation.org
Subject: [merged] bfa-fix-test-in-bfad_os_fc_host_init.patch removed from -mm tree
Date: Mon, 09 Nov 2009 11:55:36 -0800
Message-ID: <200911091955.nA9JtaFe024326@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56702 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753355AbZKITzg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2009 14:55:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, James.Bottomley@HansenPartnership.com, huangj@Brocade.COM, mm-commits@vger.kernel.org


The patch titled
     bfa: fix test in bfad_os_fc_host_init()
has been removed from the -mm tree.  Its filename was
     bfa-fix-test-in-bfad_os_fc_host_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bfa: fix test in bfad_os_fc_host_init()
From: Roel Kluin <roel.kluin@gmail.com>

BFA_PORT_ROLE_FCP_IPFC is 0x04 so this always evaluates to true

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Jing Huang <huangj@Brocade.COM>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/scsi/bfa/bfad_im.c~bfa-fix-test-in-bfad_os_fc_host_init drivers/scsi/bfa/bfad_im.c
--- a/drivers/scsi/bfa/bfad_im.c~bfa-fix-test-in-bfad_os_fc_host_init
+++ a/drivers/scsi/bfa/bfad_im.c
@@ -948,7 +948,7 @@ bfad_os_fc_host_init(struct bfad_im_port
 	if (bfad_supported_fc4s & (BFA_PORT_ROLE_FCP_IM | BFA_PORT_ROLE_FCP_TM))
 		/* For FCP type 0x08 */
 		fc_host_supported_fc4s(host)[2] = 1;
-	if (bfad_supported_fc4s | BFA_PORT_ROLE_FCP_IPFC)
+	if (bfad_supported_fc4s & BFA_PORT_ROLE_FCP_IPFC)
 		/* For LLC/SNAP type 0x05 */
 		fc_host_supported_fc4s(host)[3] = 0x20;
 	/* For fibre channel services type 0x20 */
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
get_maintainer-fix-usage-comment.patch
linux-next.patch
fujitsu-laptop-fix-tests-of-acpi_evaluate_integer-return.patch
omap-fix-unlikelyx-y.patch
pxa-add-missing-underscores-in-define.patch
powernow-k8-fix-test-in-get_transition_latency.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
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
page-types-unsigned-cannot-be-less-than-0-in-add_page.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
cryptocop-fix-assertion-in-create_output_descriptors.patch
gpio-fix-test-on-unsigned-in-lnw_irq_type.patch
fbdev-tv_paln-bit-set-twice-in-sisfb_detect_vb_connect.patch
hvc_console-fix-test-on-unsigned-in-hvc_console_print.patch
irq-fix-test-in-__exit-parport_mfc3_exit.patch

