From: akpm@linux-foundation.org
Subject: [merged] hisax-fix-test-in-waitforxfw.patch removed from -mm tree
Date: Mon, 09 Nov 2009 11:55:21 -0800
Message-ID: <200911091955.nA9JtL0a023671@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56240 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753909AbZKITzU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2009 14:55:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, isdn@linux-pingi.de, mm-commits@vger.kernel.org


The patch titled
     hisax: fix test in waitforXFW()
has been removed from the -mm tree.  Its filename was
     hisax-fix-test-in-waitforxfw.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hisax: fix test in waitforXFW()
From: Roel Kluin <roel.kluin@gmail.com>

The negation makes it a bool before the comparison and hence it
will never be 0x40.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Karsten Keil <isdn@linux-pingi.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/hisax/diva.c     |    2 +-
 drivers/isdn/hisax/hscx_irq.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/isdn/hisax/diva.c~hisax-fix-test-in-waitforxfw drivers/isdn/hisax/diva.c
--- a/drivers/isdn/hisax/diva.c~hisax-fix-test-in-waitforxfw
+++ a/drivers/isdn/hisax/diva.c
@@ -382,7 +382,7 @@ MemwaitforXFW(struct IsdnCardState *cs, 
 {
 	int to = 50;
 
-	while ((!(MemReadHSCX(cs, hscx, HSCX_STAR) & 0x44) == 0x40) && to) {
+	while (((MemReadHSCX(cs, hscx, HSCX_STAR) & 0x44) != 0x40) && to) {
 		udelay(1);
 		to--;
 	}
diff -puN drivers/isdn/hisax/hscx_irq.c~hisax-fix-test-in-waitforxfw drivers/isdn/hisax/hscx_irq.c
--- a/drivers/isdn/hisax/hscx_irq.c~hisax-fix-test-in-waitforxfw
+++ a/drivers/isdn/hisax/hscx_irq.c
@@ -32,7 +32,7 @@ waitforXFW(struct IsdnCardState *cs, int
 {
 	int to = 50;
 
-	while ((!(READHSCX(cs, hscx, HSCX_STAR) & 0x44) == 0x40) && to) {
+	while (((READHSCX(cs, hscx, HSCX_STAR) & 0x44) != 0x40) && to) {
 		udelay(1);
 		to--;
 	}
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

