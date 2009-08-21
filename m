From: akpm@linux-foundation.org
Subject: [merged] powerpc-avoid-calculating-possibly-invalid-address.patch removed from -mm tree
Date: Fri, 21 Aug 2009 14:06:38 -0700
Message-ID: <200908212106.n7LL6cqk007706@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39137 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932683AbZHUVHZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Aug 2009 17:07:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, benh@kernel.crashing.org, bernd@firmix.at, mm-commits@vger.kernel.org


The patch titled
     powerpc: avoid calculating possibly-invalid address
has been removed from the -mm tree.  Its filename was
     powerpc-avoid-calculating-possibly-invalid-address.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: powerpc: avoid calculating possibly-invalid address
From: Roel Kluin <roel.kluin@gmail.com>

Check whether index is within bounds prior to calculating a
possibly-invalid address.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Bernd Petrovitsch <bernd@firmix.at>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/hvsi.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/char/hvsi.c~powerpc-avoid-calculating-possibly-invalid-address drivers/char/hvsi.c
--- a/drivers/char/hvsi.c~powerpc-avoid-calculating-possibly-invalid-address
+++ a/drivers/char/hvsi.c
@@ -1230,11 +1230,12 @@ static struct tty_driver *hvsi_console_d
 
 static int __init hvsi_console_setup(struct console *console, char *options)
 {
-	struct hvsi_struct *hp = &hvsi_ports[console->index];
+	struct hvsi_struct *hp;
 	int ret;
 
 	if (console->index < 0 || console->index >= hvsi_count)
 		return -1;
+	hp = &hvsi_ports[console->index];
 
 	/* give the FSP a chance to change the baud rate when we re-open */
 	hvsi_close_protocol(hp);
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
stmp3xxx-deallocation-with-negative-index-of-descriptors.patch
dm-strncpy-does-not-null-terminate-string.patch
pcmcia-fix-read-buffer-overflow.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
drm-i915-intel_sdvo_multifunc_encoder-sdvo_output_svid0-tested-twice.patch
mips-decrease-size-of-au1xxx_dbdma_pm_regs.patch
slram-read-buffer-overflow.patch
mtd-fix-read-buffer-overflow.patch
mtd-jffs2-fix-read-buffer-overflow.patch
mtd-prevent-a-read-from-eraseregions.patch
mtd-prevent-a-read-from-regions.patch
hfc_usb-fix-read-buffer-overflow.patch
zorro8390-fix-read-buffer-overflow-in-zorro8390_init_one-checkpatch-fixes.patch
cyclades-read-buffer-overflow.patch
serial167-fix-read-buffer-overflow.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
ibmmca-buffer-overflow.patch
scsi-eata-fix-buffer-overflow.patch
drivers-scsi-gdthc-fix-buffer-overflow.patch
drivers-scsi-u14-34fc-fix-uffer-overflow.patch
drivers-scsi-lpfc-lpfc_vportc-fix-read-buffer-overflow.patch
osst-fix-read-buffer-overflow.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
blackfin-fix-read-buffer-overflow.patch
arch-alpha-boot-tools-objstripc-wrong-variable-tested-after-open.patch
m32r-remove-redundant-tests-on-unsigned.patch
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
dme1737-keep-index-within-pwm_config.patch
sdio-fix-read-buffer-overflow.patch
ncpfs-read-buffer-overflow.patch
smbfs-read-buffer-overflow.patch
platinumfb-misplaced-parenthesis.patch
sisfb-read-buffer-overflow.patch
drivers-video-console-newport_conc-fix-read-outside-array-bounds.patch
mwave-fix-read-buffer-overflow.patch
adfs-remove-redundant-test-on-unsigned.patch

