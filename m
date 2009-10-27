From: akpm@linux-foundation.org
Subject: [merged] drivers-staging-octeon-ethernet-rgmiic-dont-ignore-request_irq-return-code.patch removed from -mm tree
Date: Tue, 27 Oct 2009 11:40:48 -0700
Message-ID: <200910271840.n9RIemSR013329@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53221 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755860AbZJ0SlQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Oct 2009 14:41:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, ddaney@caviumnetworks.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     drivers/staging/octeon/ethernet-rgmii.c: don't ignore request_irq() return code
has been removed from the -mm tree.  Its filename was
     drivers-staging-octeon-ethernet-rgmiic-dont-ignore-request_irq-return-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/staging/octeon/ethernet-rgmii.c: don't ignore request_irq() return code
From: Roel Kluin <roel.kluin@gmail.com>

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: David Daney <ddaney@caviumnetworks.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/octeon/ethernet-rgmii.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/staging/octeon/ethernet-rgmii.c~drivers-staging-octeon-ethernet-rgmiic-dont-ignore-request_irq-return-code drivers/staging/octeon/ethernet-rgmii.c
--- a/drivers/staging/octeon/ethernet-rgmii.c~drivers-staging-octeon-ethernet-rgmiic-dont-ignore-request_irq-return-code
+++ a/drivers/staging/octeon/ethernet-rgmii.c
@@ -308,7 +308,7 @@ int cvm_oct_rgmii_init(struct net_device
 
 	/*
 	 * Due to GMX errata in CN3XXX series chips, it is necessary
-	 * to take the link down immediately whne the PHY changes
+	 * to take the link down immediately when the PHY changes
 	 * state. In order to do this we call the poll function every
 	 * time the RGMII inband status changes.  This may cause
 	 * problems if the PHY doesn't implement inband status
@@ -317,6 +317,8 @@ int cvm_oct_rgmii_init(struct net_device
 	if (number_rgmii_ports == 0) {
 		r = request_irq(OCTEON_IRQ_RML, cvm_oct_rgmii_rml_interrupt,
 				IRQF_SHARED, "RGMII", &number_rgmii_ports);
+		if (r != 0)
+			return r;
 	}
 	number_rgmii_ports++;
 
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
frv-fix-check-on-unsigned-in-do_signal.patch
linux-next.patch
fujitsu-laptop-fix-tests-of-acpi_evaluate_integer-return.patch
omap-fix-unlikelyx-y.patch
powernow-k8-fix-test-in-get_transition_latency.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
hfc_usb-fix-read-buffer-overflow.patch
hisax-fix-test-in-waitforxfw.patch
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
bfa-fix-test-in-bfad_os_fc_host_init.patch
page-types-unsigned-cannot-be-less-than-0-in-add_page.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
cryptocop-fix-assertion-in-create_output_descriptors.patch
gpio-fix-test-on-unsigned-in-lnw_irq_type.patch
fbdev-tv_paln-bit-set-twice-in-sisfb_detect_vb_connect.patch
hvc_console-fix-test-on-unsigned-in-hvc_console_print.patch
irq-fix-test-in-__exit-parport_mfc3_exit.patch
cachefiles-cleanup-redundant-tests-on-unsigned.patch

