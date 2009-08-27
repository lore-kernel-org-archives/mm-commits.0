From: akpm@linux-foundation.org
Subject: + tipc-fix-test-of-bearer_priority-range-in-tipc_register_media.patch added to -mm tree
Date: Thu, 27 Aug 2009 14:32:41 -0700
Message-ID: <200908272132.n7RLWfBn023631@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37688 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752100AbZH0Vco (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Aug 2009 17:32:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, allan.stephens@windriver.com, per.liden@ericsson.com


The patch titled
     tipc: fix test of bearer_priority range in tipc_register_media()
has been added to the -mm tree.  Its filename is
     tipc-fix-test-of-bearer_priority-range-in-tipc_register_media.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tipc: fix test of bearer_priority range in tipc_register_media()
From: Roel Kluin <roel.kluin@gmail.com>

For the bearer_priority to be less than TIPC_MIN_LINK_PRI and greater than
TIPC_MAX_LINK_PRI is logically impossible.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Per Liden <per.liden@ericsson.com>
Cc: "Stephens, Allan" <allan.stephens@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/tipc/bearer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN net/tipc/bearer.c~tipc-fix-test-of-bearer_priority-range-in-tipc_register_media net/tipc/bearer.c
--- a/net/tipc/bearer.c~tipc-fix-test-of-bearer_priority-range-in-tipc_register_media
+++ a/net/tipc/bearer.c
@@ -119,7 +119,7 @@ int  tipc_register_media(u32 media_type,
 		warn("Media <%s> rejected, no broadcast address\n", name);
 		goto exit;
 	}
-	if ((bearer_priority < TIPC_MIN_LINK_PRI) &&
+	if ((bearer_priority < TIPC_MIN_LINK_PRI) ||
 	    (bearer_priority > TIPC_MAX_LINK_PRI)) {
 		warn("Media <%s> rejected, illegal priority (%u)\n", name,
 		     bearer_priority);
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
drm-i915-intel_sdvo_multifunc_encoder-sdvo_output_svid0-tested-twice.patch
v4l-dvb-fix-test-of-bandwidth-range-in-cx22700_set_tps.patch
mips-decrease-size-of-au1xxx_dbdma_pm_regs.patch
octeon-false-positive-timeout.patch
slram-read-buffer-overflow.patch
mtd-fix-read-buffer-overflow.patch
mtd-jffs2-fix-read-buffer-overflow.patch
mtd-prevent-a-read-from-eraseregions.patch
mtd-prevent-a-read-from-regions.patch
tipc-fix-test-of-bearer_priority-range-in-tipc_register_media.patch
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

