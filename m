From: akpm@linux-foundation.org
Subject: [merged] jffs2-fix-min-max-confusion.patch removed from -mm tree
Date: Tue, 01 Dec 2009 12:18:00 -0800
Message-ID: <200912012018.nB1KI01h019935@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55554 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753398AbZLAUSC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Dec 2009 15:18:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     jffs2: fix min/max confusion
has been removed from the -mm tree.  Its filename was
     jffs2-fix-min-max-confusion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: jffs2: fix min/max confusion
From: Roel Kluin <roel.kluin@gmail.com>

MAX_SUMMARY_SIZE was meant as a limit, not as a minimum.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jffs2/summary.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/jffs2/summary.c~jffs2-fix-min-max-confusion fs/jffs2/summary.c
--- a/fs/jffs2/summary.c~jffs2-fix-min-max-confusion
+++ a/fs/jffs2/summary.c
@@ -23,7 +23,7 @@
 
 int jffs2_sum_init(struct jffs2_sb_info *c)
 {
-	uint32_t sum_size = max_t(uint32_t, c->sector_size, MAX_SUMMARY_SIZE);
+	uint32_t sum_size = min_t(uint32_t, c->sector_size, MAX_SUMMARY_SIZE);
 
 	c->summary = kzalloc(sizeof(struct jffs2_summary), GFP_KERNEL);
 
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
fujitsu-laptop-fix-tests-of-acpi_evaluate_integer-return.patch
omap-return-ptr_err-rather-than-is_err.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
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
r8192u_core-test-for-negative-error-in-rtl8192_rx_isr.patch
wusb-use-sizeof-struct-rather-than-pointer.patch
page-types-unsigned-cannot-be-less-than-0-in-add_page.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
cryptocop-fix-assertion-in-create_output_descriptors.patch
gpio-fix-test-on-unsigned-in-lnw_irq_type.patch
fbdev-tv_paln-bit-set-twice-in-sisfb_detect_vb_connect.patch
hvc_console-fix-test-on-unsigned-in-hvc_console_print.patch
zlib-optimize-inffast-when-copying-direct-from-output.patch

