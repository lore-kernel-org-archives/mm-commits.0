From: akpm@linux-foundation.org
Subject: - dvb-usb-af9005-fec-error-check-fixes.patch removed from -mm tree
Date: Sat, 28 Jul 2007 23:13:20 -0700
Message-ID: <200707290613.l6T6DKqT011193@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39962 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757706AbXG2GXx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jul 2007 02:23:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, greg@kroah.com, luca@ventoso.org, mm-commits@vger.kernel.org


The patch titled
     dvb-usb/af9005-fe.c: error check fixes
has been removed from the -mm tree.  Its filename was
     dvb-usb-af9005-fec-error-check-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: dvb-usb/af9005-fe.c: error check fixes
From: Adrian Bunk <bunk@stusta.de>

This patch:
- adds a missing error check and
- removes an error check that could never be true

Both spotted by the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Luca Olivetti <luca@ventoso.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/dvb-usb/af9005-fe.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -puN drivers/media/dvb/dvb-usb/af9005-fe.c~dvb-usb-af9005-fec-error-check-fixes drivers/media/dvb/dvb-usb/af9005-fe.c
--- a/drivers/media/dvb/dvb-usb/af9005-fe.c~dvb-usb-af9005-fec-error-check-fixes
+++ a/drivers/media/dvb/dvb-usb/af9005-fe.c
@@ -345,8 +345,8 @@ static int af9005_reset_pre_viterbi(stru
 				       1 & 0xff);
 	if (ret)
 		return ret;
-	af9005_write_ofdm_register(state->d, xd_p_fec_super_frm_unit_15_8,
-				   1 >> 8);
+	ret = af9005_write_ofdm_register(state->d, xd_p_fec_super_frm_unit_15_8,
+					 1 >> 8);
 	if (ret)
 		return ret;
 	/* reset pre viterbi error count */
@@ -881,10 +881,8 @@ static int af9005_fe_init(struct dvb_fro
 	     af9005_write_register_bits(state->d, xd_I2C_reg_ofdm_rst,
 					reg_ofdm_rst_pos, reg_ofdm_rst_len, 1)))
 		return ret;
-	if ((ret =
-	     af9005_write_register_bits(state->d, xd_I2C_reg_ofdm_rst,
-					reg_ofdm_rst_pos, reg_ofdm_rst_len, 0)))
-		return ret;
+	ret = af9005_write_register_bits(state->d, xd_I2C_reg_ofdm_rst,
+					 reg_ofdm_rst_pos, reg_ofdm_rst_len, 0);
 
 	if (ret)
 		return ret;
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
git-acpi.patch
drivers-acpi-sbsc-remove-dead-code.patch
git-alsa.patch
kernel-auditscc-fix-an-off-by-one.patch
git-drm.patch
git-dvb.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
git-mtd.patch
fore200e_param_bs_queue-must-be-__devinit.patch
git-ocfs2.patch
cpqphp_ctrlc-remove-dead-code.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
nsp32_restart_autoscsi-remove-error-check.patch
git-unionfs.patch
git-v9fs.patch
git-ipwireless_cs.patch
arch-i386-kernel-smpbootcsetup_trampoline-must-be.patch
serial-sh-sci-fix-build-failure-from-kgdb-fallout.patch
usb_serial_suspend-buggy-code.patch
slubcearly_kmem_cache_node_alloc-shouldnt-be.patch
maps2-add-proc-kpagemap-interface.patch
fs-reiserfs-cleanups.patch
anon_inodes-shouldnt-be-user-visible.patch
remove-unsafe-from-module-struct.patch
introduce-i_sync-fix.patch
ext2-reservations.patch
intel-iommu-intel-iommu-driver.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
pid-namespaces-define-is_global_init-and-is_container_init-m32r-fix.patch
the-next-round-of-scheduled-oss-code-removal.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
