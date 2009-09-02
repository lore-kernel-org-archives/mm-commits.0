From: akpm@linux-foundation.org
Subject: [merged] v4l-dvb-fix-test-of-bandwidth-range-in-cx22700_set_tps.patch removed from -mm tree
Date: Wed, 02 Sep 2009 12:08:12 -0700
Message-ID: <200909021908.n82J8Crx010255@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34690 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753209AbZIBTJr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Sep 2009 15:09:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, dougsland@redhat.com, mchehab@infradead.org, obi@linuxtv.org, zzam@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     v4l/dvb: fix test of bandwidth range in cx22700_set_tps()
has been removed from the -mm tree.  Its filename was
     v4l-dvb-fix-test-of-bandwidth-range-in-cx22700_set_tps.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: v4l/dvb: fix test of bandwidth range in cx22700_set_tps()
From: Roel Kluin <roel.kluin@gmail.com>

For the bandwidth to be less than 8 MHZ and greater than 6 MHZ is logically
impossible.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Matthias Schwarzott <zzam@gentoo.org>
Cc: Douglas Schilling Landgraf <dougsland@redhat.com>
Cc: Andreas Oberritter <obi@linuxtv.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/frontends/cx22700.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/dvb/frontends/cx22700.c~v4l-dvb-fix-test-of-bandwidth-range-in-cx22700_set_tps drivers/media/dvb/frontends/cx22700.c
--- a/drivers/media/dvb/frontends/cx22700.c~v4l-dvb-fix-test-of-bandwidth-range-in-cx22700_set_tps
+++ a/drivers/media/dvb/frontends/cx22700.c
@@ -155,7 +155,7 @@ static int cx22700_set_tps (struct cx227
 	    p->hierarchy_information > HIERARCHY_4)
 		return -EINVAL;
 
-	if (p->bandwidth < BANDWIDTH_8_MHZ && p->bandwidth > BANDWIDTH_6_MHZ)
+	if (p->bandwidth < BANDWIDTH_8_MHZ || p->bandwidth > BANDWIDTH_6_MHZ)
 		return -EINVAL;
 
 	if (p->bandwidth == BANDWIDTH_7_MHZ)
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
x86-fix-x86_model-test-in-es7000_apic_is_cluster.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
stmp3xxx-deallocation-with-negative-index-of-descriptors.patch
dm-strncpy-does-not-null-terminate-string.patch
pcmcia-fix-read-buffer-overflow.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
mips-decrease-size-of-au1xxx_dbdma_pm_regs.patch
octeon-false-positive-timeout.patch
slram-read-buffer-overflow.patch
mtd-fix-read-buffer-overflow.patch
mtd-jffs2-fix-read-buffer-overflow.patch
mtd-prevent-a-read-from-eraseregions.patch
mtd-prevent-a-read-from-regions.patch
hfc_usb-fix-read-buffer-overflow.patch
zorro8390-fix-read-buffer-overflow-in-zorro8390_init_one-checkpatch-fixes.patch
cyclades-read-buffer-overflow.patch
serial167-fix-read-buffer-overflow.patch
regulator-fix-calculation-of-voltage-range-in-da9034_set_ldo12_voltage.patch
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
st-fix-test-of-value-range-in-st_set_options-fix.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
blackfin-fix-read-buffer-overflow.patch
arch-alpha-boot-tools-objstripc-wrong-variable-tested-after-open.patch
m32r-remove-redundant-tests-on-unsigned.patch
uml-fix-order-of-pud-and-pmd_free.patch
dme1737-keep-index-within-pwm_config.patch
sdio-fix-read-buffer-overflow.patch
hwmon-fix-freeing-of-gpio_data-and-irq.patch
ncpfs-read-buffer-overflow.patch
smbfs-read-buffer-overflow.patch
platinumfb-misplaced-parenthesis.patch
sisfb-read-buffer-overflow.patch
drivers-video-console-newport_conc-fix-read-outside-array-bounds.patch
mwave-fix-read-buffer-overflow.patch
adfs-remove-redundant-test-on-unsigned.patch

