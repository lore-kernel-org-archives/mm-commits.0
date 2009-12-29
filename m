From: akpm@linux-foundation.org
Subject: [merged] imx-bit-confusion.patch removed from -mm tree
Date: Tue, 29 Dec 2009 13:32:44 -0800
Message-ID: <200912292132.nBTLWiD3008655@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38629 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752836AbZL2Vdk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Dec 2009 16:33:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, alan@linux.intel.com, dg@emlix.com, fg@emlix.com, os@emlix.com, rmk@arm.linux.org.uk, s.hauer@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     imx: bit &/| confusion
has been removed from the -mm tree.  Its filename was
     imx-bit-confusion.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: imx: bit &/| confusion
=46rom: Roel Kluin <roel.kluin@gmail.com>

Since UCR1_UARTEN is defined 1, the port was always treated as enabled.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Alan Cox <alan@linux.intel.com>
Acked-by: Oskar Schirmer <os@emlix.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Fabian Godehardt <fg@emlix.com>
Cc: Daniel Gl=F6ckner <dg@emlix.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/imx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/serial/imx.c~imx-bit-confusion drivers/serial/imx.c
--- a/drivers/serial/imx.c~imx-bit-confusion
+++ a/drivers/serial/imx.c
@@ -1088,7 +1088,7 @@ imx_console_get_options(struct imx_port=20
 			   int *parity, int *bits)
 {
=20
-	if ( readl(sport->port.membase + UCR1) | UCR1_UARTEN ) {
+	if (readl(sport->port.membase + UCR1) & UCR1_UARTEN) {
 		/* ok, the port was enabled */
 		unsigned int ucr2, ubir,ubmr, uartclk;
 		unsigned int baud_raw;
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

zlib-optimize-inffast-when-copying-direct-from-output.patch
linux-next.patch
omap-confusion-in-iommu_put.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
ibmmca-buffer-overflow.patch
scsi-eata-fix-buffer-overflow.patch
drivers-scsi-gdthc-fix-buffer-overflow.patch
drivers-scsi-u14-34fc-fix-uffer-overflow.patch
drivers-scsi-lpfc-lpfc_vportc-fix-read-buffer-overflow.patch
osst-fix-read-buffer-overflow.patch
gdth-unmap-ccb_phys-when-scsi_add_host-fails-in-gdth_eisa_probe_one.pat=
ch
zfcp-test-kmalloc-failure-in-scsi_get_vpd_page.patch
ncr5380-bit-mr_dma_mode-set-twice-in-ncr5380_transfer_dma.patch
scsi-pmcraid-redundant-check-in-pmcraid_check_ioctl_buffer.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
cryptocop-fix-assertion-in-create_output_descriptors.patch
asiliantfb-fix-test-of-unsigned-in-asiliant_calc_dclk2.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
