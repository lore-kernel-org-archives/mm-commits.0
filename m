From: akpm@linux-foundation.org
Subject: [merged] sisfb-read-buffer-overflow.patch removed from -mm tree
Date: Wed, 23 Sep 2009 13:01:17 -0700
Message-ID: <200909232001.n8NK1Hkd014875@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51852 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751988AbZIWUBv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 16:01:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, krzysztof.h1@poczta.fm, thomas@winischhofer.net, mm-commits@vger.kernel.org


The patch titled
     sisfb: read buffer overflow
has been removed from the -mm tree.  Its filename was
     sisfb-read-buffer-overflow.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sisfb: read buffer overflow
From: Roel Kluin <roel.kluin@gmail.com>

If called with mode_idx = 1, rate = 68, a read occurs from
sisfb_vrate[-1].refresh.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: Thomas Winischhofer <thomas@winischhofer.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/sis/sis_main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/sis/sis_main.c~sisfb-read-buffer-overflow drivers/video/sis/sis_main.c
--- a/drivers/video/sis/sis_main.c~sisfb-read-buffer-overflow
+++ a/drivers/video/sis/sis_main.c
@@ -698,8 +698,8 @@ sisfb_search_refresh_rate(struct sis_vid
 						rate, sisfb_vrate[i].refresh);
 					ivideo->rate_idx = sisfb_vrate[i].idx;
 					ivideo->refresh_rate = sisfb_vrate[i].refresh;
-				} else if(((rate - sisfb_vrate[i-1].refresh) <= 2)
-						&& (sisfb_vrate[i].idx != 1)) {
+				} else if((sisfb_vrate[i].idx != 1) &&
+						((rate - sisfb_vrate[i-1].refresh) <= 2)) {
 					DPRINTK("sisfb: Adjusting rate from %d down to %d\n",
 						rate, sisfb_vrate[i-1].refresh);
 					ivideo->rate_idx = sisfb_vrate[i-1].idx;
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

