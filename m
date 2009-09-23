From: akpm@linux-foundation.org
Subject: [merged] platinumfb-misplaced-parenthesis.patch removed from -mm tree
Date: Wed, 23 Sep 2009 13:01:08 -0700
Message-ID: <200909232001.n8NK18V4014569@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52172 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753861AbZIWUCA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 16:02:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, benh@kernel.crashing.org, geert@linux-m68k.org, paulus@samba.org, syrjala@sci.fi, mm-commits@vger.kernel.org


The patch titled
     platinumfb: fix misplaced parenthesis
has been removed from the -mm tree.  Its filename was
     platinumfb-misplaced-parenthesis.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: platinumfb: fix misplaced parenthesis
From: Roel Kluin <roel.kluin@gmail.com>

Since `+' has a higher precedence than the trinary operator `?', this
added `hres * (1 << color_mode)' to the boolean testing videomode and
depth.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ville Syrjala <syrjala@sci.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/platinumfb.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN drivers/video/platinumfb.c~platinumfb-misplaced-parenthesis drivers/video/platinumfb.c
--- a/drivers/video/platinumfb.c~platinumfb-misplaced-parenthesis
+++ a/drivers/video/platinumfb.c
@@ -223,10 +223,14 @@ static int platinumfb_setcolreg(u_int re
 
 static inline int platinum_vram_reqd(int video_mode, int color_mode)
 {
-	return vmode_attrs[video_mode-1].vres *
-	       (vmode_attrs[video_mode-1].hres * (1<<color_mode) +
-		((video_mode == VMODE_832_624_75) &&
-		 (color_mode > CMODE_8)) ? 0x10 : 0x20) + 0x1000;
+	int baseval = vmode_attrs[video_mode-1].hres * (1<<color_mode);
+
+	if ((video_mode == VMODE_832_624_75) && (color_mode > CMODE_8))
+		baseval += 0x10;
+	else
+		baseval += 0x20;
+
+	return vmode_attrs[video_mode-1].vres * baseval + 0x1000;
 }
 
 #define STORE_D2(a, d) { \
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

