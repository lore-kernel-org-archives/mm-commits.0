From: akpm@linux-foundation.org
Subject: [merged] atlx-strncpy-does-not-null-terminate-string.patch removed from -mm tree
Date: Tue, 11 Aug 2009 12:58:06 -0700
Message-ID: <200908111958.n7BJw6Iw022391@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35870 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752740AbZHKT6l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Aug 2009 15:58:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, csnook@redhat.com, jcliburn@gmail.com, jie.yang@atheros.com, mm-commits@vger.kernel.org


The patch titled
     atlx: strncpy does not null terminate string
has been removed from the -mm tree.  Its filename was
     atlx-strncpy-does-not-null-terminate-string.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atlx: strncpy does not null terminate string
From: Roel Kluin <roel.kluin@gmail.com>

strlcpy() will always null terminate the string.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Jay Cliburn <jcliburn@gmail.com>
Cc: Chris Snook <csnook@redhat.com>
Cc: Jie Yang <jie.yang@atheros.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/atl1c/atl1c_ethtool.c |    8 ++++----
 drivers/net/atlx/atl1.c           |    8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff -puN drivers/net/atl1c/atl1c_ethtool.c~atlx-strncpy-does-not-null-terminate-string drivers/net/atl1c/atl1c_ethtool.c
--- a/drivers/net/atl1c/atl1c_ethtool.c~atlx-strncpy-does-not-null-terminate-string
+++ a/drivers/net/atl1c/atl1c_ethtool.c
@@ -232,11 +232,11 @@ static void atl1c_get_drvinfo(struct net
 {
 	struct atl1c_adapter *adapter = netdev_priv(netdev);
 
-	strncpy(drvinfo->driver,  atl1c_driver_name, sizeof(drvinfo->driver));
-	strncpy(drvinfo->version, atl1c_driver_version,
+	strlcpy(drvinfo->driver,  atl1c_driver_name, sizeof(drvinfo->driver));
+	strlcpy(drvinfo->version, atl1c_driver_version,
 		sizeof(drvinfo->version));
-	strncpy(drvinfo->fw_version, "N/A", sizeof(drvinfo->fw_version));
-	strncpy(drvinfo->bus_info, pci_name(adapter->pdev),
+	strlcpy(drvinfo->fw_version, "N/A", sizeof(drvinfo->fw_version));
+	strlcpy(drvinfo->bus_info, pci_name(adapter->pdev),
 		sizeof(drvinfo->bus_info));
 	drvinfo->n_stats = 0;
 	drvinfo->testinfo_len = 0;
diff -puN drivers/net/atlx/atl1.c~atlx-strncpy-does-not-null-terminate-string drivers/net/atlx/atl1.c
--- a/drivers/net/atlx/atl1.c~atlx-strncpy-does-not-null-terminate-string
+++ a/drivers/net/atlx/atl1.c
@@ -3378,11 +3378,11 @@ static void atl1_get_drvinfo(struct net_
 {
 	struct atl1_adapter *adapter = netdev_priv(netdev);
 
-	strncpy(drvinfo->driver, ATLX_DRIVER_NAME, sizeof(drvinfo->driver));
-	strncpy(drvinfo->version, ATLX_DRIVER_VERSION,
+	strlcpy(drvinfo->driver, ATLX_DRIVER_NAME, sizeof(drvinfo->driver));
+	strlcpy(drvinfo->version, ATLX_DRIVER_VERSION,
 		sizeof(drvinfo->version));
-	strncpy(drvinfo->fw_version, "N/A", sizeof(drvinfo->fw_version));
-	strncpy(drvinfo->bus_info, pci_name(adapter->pdev),
+	strlcpy(drvinfo->fw_version, "N/A", sizeof(drvinfo->fw_version));
+	strlcpy(drvinfo->bus_info, pci_name(adapter->pdev),
 		sizeof(drvinfo->bus_info));
 	drvinfo->eedump_len = ATL1_EEDUMP_LEN;
 }
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
stmp3xxx-deallocation-with-negative-index-of-descriptors.patch
dm-strncpy-does-not-null-terminate-string.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
powerpc-avoid-calculating-possibly-invalid-address.patch
drm-i915-intel_sdvo_multifunc_encoder-sdvo_output_svid0-tested-twice.patch
media-strncpy-does-not-null-terminate-string.patch
siano-read-buffer-overflow.patch
drivers-media-video-bw-qcamc-fix-read-buffer-overflow.patch
stk-webcam-read-buffer-overflow.patch
mips-decrease-size-of-au1xxx_dbdma_pm_regs.patch
slram-read-buffer-overflow.patch
mtd-fix-read-buffer-overflow.patch
hfc_usb-fix-read-buffer-overflow.patch
zorro8390-fix-read-buffer-overflow-in-zorro8390_init_one-checkpatch-fixes.patch
ext4-remove-redundant-test-on-unsigned.patch
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
ncpfs-read-buffer-overflow.patch
smbfs-read-buffer-overflow.patch
platinumfb-misplaced-parenthesis.patch
sisfb-read-buffer-overflow.patch
drivers-video-console-newport_conc-fix-read-outside-array-bounds.patch
mwave-fix-read-buffer-overflow.patch
adfs-remove-redundant-test-on-unsigned.patch

