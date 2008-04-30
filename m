From: akpm@linux-foundation.org
Subject: - firmware-replace-remaining-__function__-occurrences.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:40:24 -0700
Message-ID: <200804300540.m3U5eO85028960@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47564 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756036AbYD3FlX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:41:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, Douglas_Warzecha@dell.com, Matt_Domsch@dell.com, mm-commits@vger.kernel.org


The patch titled
     firmware: replace remaining __FUNCTION__ occurrences
has been removed from the -mm tree.  Its filename was
     firmware-replace-remaining-__function__-occurrences.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: firmware: replace remaining __FUNCTION__ occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Doug Warzecha <Douglas_Warzecha@dell.com>
Cc: Matt Domsch <Matt_Domsch@dell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/dcdbas.c   |   16 ++++++++--------
 drivers/firmware/dell_rbu.c |   12 ++++++------
 2 files changed, 14 insertions(+), 14 deletions(-)

diff -puN drivers/firmware/dcdbas.c~firmware-replace-remaining-__function__-occurrences drivers/firmware/dcdbas.c
--- a/drivers/firmware/dcdbas.c~firmware-replace-remaining-__function__-occurrences
+++ a/drivers/firmware/dcdbas.c
@@ -63,7 +63,7 @@ static void smi_data_buf_free(void)
 		return;
 
 	dev_dbg(&dcdbas_pdev->dev, "%s: phys: %x size: %lu\n",
-		__FUNCTION__, smi_data_buf_phys_addr, smi_data_buf_size);
+		__func__, smi_data_buf_phys_addr, smi_data_buf_size);
 
 	dma_free_coherent(&dcdbas_pdev->dev, smi_data_buf_size, smi_data_buf,
 			  smi_data_buf_handle);
@@ -92,7 +92,7 @@ static int smi_data_buf_realloc(unsigned
 	if (!buf) {
 		dev_dbg(&dcdbas_pdev->dev,
 			"%s: failed to allocate memory size %lu\n",
-			__FUNCTION__, size);
+			__func__, size);
 		return -ENOMEM;
 	}
 	/* memory zeroed by dma_alloc_coherent */
@@ -110,7 +110,7 @@ static int smi_data_buf_realloc(unsigned
 	smi_data_buf_size = size;
 
 	dev_dbg(&dcdbas_pdev->dev, "%s: phys: %x size: %lu\n",
-		__FUNCTION__, smi_data_buf_phys_addr, smi_data_buf_size);
+		__func__, smi_data_buf_phys_addr, smi_data_buf_size);
 
 	return 0;
 }
@@ -258,7 +258,7 @@ static int smi_request(struct smi_cmd *s
 
 	if (smi_cmd->magic != SMI_CMD_MAGIC) {
 		dev_info(&dcdbas_pdev->dev, "%s: invalid magic value\n",
-			 __FUNCTION__);
+			 __func__);
 		return -EBADR;
 	}
 
@@ -267,7 +267,7 @@ static int smi_request(struct smi_cmd *s
 	set_cpus_allowed_ptr(current, &cpumask_of_cpu(0));
 	if (smp_processor_id() != 0) {
 		dev_dbg(&dcdbas_pdev->dev, "%s: failed to get CPU 0\n",
-			__FUNCTION__);
+			__func__);
 		ret = -EBUSY;
 		goto out;
 	}
@@ -428,7 +428,7 @@ static int host_control_smi(void)
 
 	default:
 		dev_dbg(&dcdbas_pdev->dev, "%s: invalid SMI type %u\n",
-			__FUNCTION__, host_control_smi_type);
+			__func__, host_control_smi_type);
 		return -ENOSYS;
 	}
 
@@ -456,13 +456,13 @@ static void dcdbas_host_control(void)
 	host_control_action = HC_ACTION_NONE;
 
 	if (!smi_data_buf) {
-		dev_dbg(&dcdbas_pdev->dev, "%s: no SMI buffer\n", __FUNCTION__);
+		dev_dbg(&dcdbas_pdev->dev, "%s: no SMI buffer\n", __func__);
 		return;
 	}
 
 	if (smi_data_buf_size < sizeof(struct apm_cmd)) {
 		dev_dbg(&dcdbas_pdev->dev, "%s: SMI buffer too small\n",
-			__FUNCTION__);
+			__func__);
 		return;
 	}
 
diff -puN drivers/firmware/dell_rbu.c~firmware-replace-remaining-__function__-occurrences drivers/firmware/dell_rbu.c
--- a/drivers/firmware/dell_rbu.c~firmware-replace-remaining-__function__-occurrences
+++ a/drivers/firmware/dell_rbu.c
@@ -123,7 +123,7 @@ static int create_packet(void *data, siz
 	if (!newpacket) {
 		printk(KERN_WARNING
 			"dell_rbu:%s: failed to allocate new "
-			"packet\n", __FUNCTION__);
+			"packet\n", __func__);
 		retval = -ENOMEM;
 		spin_lock(&rbu_data.lock);
 		goto out_noalloc;
@@ -152,7 +152,7 @@ static int create_packet(void *data, siz
 		printk(KERN_WARNING
 			"dell_rbu:%s: failed to allocate "
 			"invalid_addr_packet_array \n",
-			__FUNCTION__);
+			__func__);
 		retval = -ENOMEM;
 		spin_lock(&rbu_data.lock);
 		goto out_alloc_packet;
@@ -164,7 +164,7 @@ static int create_packet(void *data, siz
 		if (!packet_data_temp_buf) {
 			printk(KERN_WARNING
 				"dell_rbu:%s: failed to allocate new "
-				"packet\n", __FUNCTION__);
+				"packet\n", __func__);
 			retval = -ENOMEM;
 			spin_lock(&rbu_data.lock);
 			goto out_alloc_packet_array;
@@ -416,7 +416,7 @@ static int img_update_realloc(unsigned l
 		 */
 		if ((size != 0) && (rbu_data.image_update_buffer == NULL)) {
 			printk(KERN_ERR "dell_rbu:%s: corruption "
-				"check failed\n", __FUNCTION__);
+				"check failed\n", __func__);
 			return -EINVAL;
 		}
 		/*
@@ -642,7 +642,7 @@ static ssize_t write_rbu_image_type(stru
 			if (req_firm_rc) {
 				printk(KERN_ERR
 					"dell_rbu:%s request_firmware_nowait"
-					" failed %d\n", __FUNCTION__, rc);
+					" failed %d\n", __func__, rc);
 				rc = -EIO;
 			} else
 				rbu_data.entry_created = 1;
@@ -718,7 +718,7 @@ static int __init dcdrbu_init(void)
 	if (IS_ERR(rbu_device)) {
 		printk(KERN_ERR
 			"dell_rbu:%s:platform_device_register_simple "
-			"failed\n", __FUNCTION__);
+			"failed\n", __func__);
 		return PTR_ERR(rbu_device);
 	}
 
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
frv-fix-arch-frv-mm-unalignedo-build-error.patch
cifs-remove-global_extern-macro.patch
input-replace-remaining-__function__-occurrences.patch
git-kvm.patch
git-mips.patch
nfs-replace-remaining-__function__-occurrences.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
pcmcia-replace-remaining-__function__-occurrences.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
git-watchdog.patch
git-xfs.patch
xtensa-replace-remaining-__function__-occurences.patch
char-fix-sparse-shadowed-variable-warnings-in-espc.patch
char-espc-fix-possible-double-unlock.patch
char-rocketc-fix-sparse-variable-shadowing-and-int-as-null-pointer.patch
cycladesc-fix-sparse-shadowed-variable-warnings.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
add-macros-similar-to-min-max-min_t-max_t.patch
add-macros-similar-to-min-max-min_t-max_t-doc.patch
ide-eliminate-fit-macro.patch
ata-remove-fit-macro.patch
b43-replace-limit_value-macro-with-clamp_val.patch
b43legacy-replace-limit_value-macro-with-clamp_val.patch
fuse-use-clamp-rather-than-nested-min-max.patch
ide-tape-use-clamp_t-rather-than-nested-min_t-max_t.patch
input-ff-memlessc-use-clamp_val-macro.patch
dccp-ccid2c-ccid3c-use-clamp-clamp_t.patch
drivers-replace-remaining-__function__-occurrences.patch
mm-remove-remaining-__function__-occurances.patch
block-remove-remaining-__function__-occurances.patch
kernel-replace-remaining-__function__-occurances.patch
lib-replace-remaining-__function__-occurances.patch
afs-replace-remaining-__function__-occurrences.patch
fs-replace-remaining-__function__-occurrences.patch
drivers-char-replace-remaining-__function__-occurrences.patch
serial-replace-remaining-__function__-occurrences.patch

