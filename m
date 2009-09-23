From: akpm@linux-foundation.org
Subject: [merged] drivers-video-console-newport_conc-fix-read-outside-array-bounds.patch removed from -mm tree
Date: Wed, 23 Sep 2009 13:02:43 -0700
Message-ID: <200909232002.n8NK2hBX017731@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43136 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753889AbZIWUDR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 16:03:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     drivers/video/console/newport_con.c: fix read outside array bounds
has been removed from the -mm tree.  Its filename was
     drivers-video-console-newport_conc-fix-read-outside-array-bounds.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/video/console/newport_con.c: fix read outside array bounds
From: Roel Kluin <roel.kluin@gmail.com>

It reads linetable[] before checking bounds of index, and ARRAY_SIZE is
required because linetable[] are unsigned shorts.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/newport_con.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/console/newport_con.c~drivers-video-console-newport_conc-fix-read-outside-array-bounds drivers/video/console/newport_con.c
--- a/drivers/video/console/newport_con.c~drivers-video-console-newport_conc-fix-read-outside-array-bounds
+++ a/drivers/video/console/newport_con.c
@@ -216,7 +216,7 @@ static void newport_get_screensize(void)
 	}
 
 	newport_xsize = newport_ysize = 0;
-	for (i = 0; linetable[i + 1] && (i < sizeof(linetable)); i += 2) {
+	for (i = 0; i < ARRAY_SIZE(linetable) - 1 && linetable[i + 1]; i += 2) {
 		cols = 0;
 		newport_vc2_set(npregs, VC2_IREG_RADDR, linetable[i]);
 		npregs->set.dcbmode = (NPORT_DMODE_AVC2 | VC2_REGADDR_RAM |
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
dm-strncpy-does-not-null-terminate-string.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
mips-decrease-size-of-au1xxx_dbdma_pm_regs.patch
msp71xx-request_irq-failure-ignored-in-msp_pcibios_config_access.patch
hfc_usb-fix-read-buffer-overflow.patch
cyclades-read-buffer-overflow.patch
serial167-fix-read-buffer-overflow.patch
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
drivers-staging-octeon-ethernet-rgmiic-dont-ignore-request_irq-return-code.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
mwave-fix-read-buffer-overflow.patch
adfs-remove-redundant-test-on-unsigned.patch
gru-allocation-may-fail-in-quicktest1.patch

