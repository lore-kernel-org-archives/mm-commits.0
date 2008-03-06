From: akpm@linux-foundation.org
Subject: + firmware-replace-remaining-__function__-occurrences.patch added to -mm tree
Date: Wed, 05 Mar 2008 19:50:05 -0800
Message-ID: <200803060350.m263o5XD007326@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37487 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756723AbYCFDup (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 22:50:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, Douglas_Warzecha@dell.com, Matt_Domsch@dell.com


The patch titled
     firmware: replace remaining __FUNCTION__ occurrences
has been added to the -mm tree.  Its filename is
     firmware-replace-remaining-__function__-occurrences.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 	set_cpus_allowed(current, cpumask_of_cpu(0));
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

git-x86.patch
git-alsa.patch
sound-replace-remaining-__function__-occurences.patch
agp-fix-shadowed-variable-warning-in-amd-k7-agpc.patch
arm-replace-remaining-__function__-occurences.patch
cifs-remove-global_extern-macro.patch
cifs-replace-remaining-__function__-occurrences.patch
powerpc-replace-remaining-__function__-occurences.patch
ppc-replace-remaining-__function__-occurences.patch
drivers-base-replace-remaining-__function__-occurrences.patch
radeon-fix-integer-as-null-pointer-warnings-in-radeon_memc.patch
git-dvb.patch
git-dlm.patch
ia64-remove-remaining-__function__-occurences.patch
infiniband-replace-remaining-__function__-occurrences.patch
input-replace-remaining-__function__-occurrences.patch
jfs-replace-__inline-with-inline.patch
git-kvm.patch
pata_amd-fix-sparse-warning.patch
mips-replace-remaining-__function__-occurences.patch
mips-replace-__inline-with-inline.patch
jffs2-include-function-prototype-for-jffs2_ioctl.patch
jffs2-fix-sparse-warning-in-nodemgmtc.patch
jffs2-fix-sparse-warning-in-writec.patch
jffs2-fix-sparse-warnings-in-gcc.patch
git-ubi.patch
net-replace-__inline-with-inline.patch
irda-replace-__inline-with-inline.patch
blackfin-replace-remaining-__function__-occurences.patch
nfs-replace-remaining-__function__-occurrences.patch
git-nfsd.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
drivers-s390-replace-remaining-__function__-occurrences.patch
sh-replace-remaining-__function__-occurences.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
scsi-stc-make-class-attributes-static.patch
scsi-osstc-make-class-attributes-static.patch
scsi-chc-fix-shadowed-variable-warnings.patch
scsi-chc-fix-shadowed-variable-warnings-checkpatch-fixes.patch
xfs-replace-remaining-__function__-occurrences.patch
xfs-replace-__inline-with-inline.patch
xtensa-replace-remaining-__function__-occurences.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
smack-fix-integer-as-null-pointer-warning-in-smack_lsmc.patch
alpha-remove-remaining-__function__-occurences.patch
alpha-replace-__inline-with-inline.patch
m68k-replace-remaining-__function__-occurences.patch
uml-replace-remaining-__function__-occurences.patch
adfs-work-around-bogus-sparse-warning.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
autofs4-fix-sparse-warning-in-rootc.patch
kernel-add-clamp-and-clamp_t-macros.patch
kernel-add-clamp-and-clamp_t-macros-checkpatch-fixes.patch
kernel-add-clamp-and-clamp_t-macros-fix.patch
ncpfs-add-prototypes-to-ncp_fsh.patch
ncpfs-fix-sparse-warnings-in-ioctlc.patch
ncpfs-fix-sparse-warning-in-ncpsign_kernelc.patch
serial-remove-double-initializer.patch
char-make-functions-static-in-synclinkmpc.patch
capi-fix-sparse-warnings-using-integer-as-null-pointer.patch
avm-fix-sparse-warning-using-integer-as-null-pointer.patch
eicon-fix-sparse-integer-as-null-pointer-warnings.patch
isdn-replace-remaining-__function__-occurrences.patch
isdn-replace-__inline-with-inline.patch
xen-make-blkif_getgeo-static.patch
ecryptfs-replace-remaining-__function__-occurrences.patch
rtc-replace-remaining-__function__-occurrences.patch
fbcon-replace-mono_col-macro-with-static-inline.patch
fbcon-replace-mono_col-macro-with-static-inline-fix.patch
video-replace-remaining-__function__-occurrences.patch
md-fix-integer-as-null-pointer-warnings-in-mdc.patch
ext2-replace-remaining-__function__-occurrences.patch
jbd-sparse-warnings-in-revokec-journalc.patch
ext3-replace-remaining-__function__-occurrences.patch
jbd-replace-remaining-__function__-occurrences.patch
ufs-replace-remaining-__function__-occurrences.patch
ufs-replace-__inline-with-inline.patch
udf-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-fix_nodec.patch
reiserfs-fix-sparse-warnings-in-do_balanc.patch
reiserfs-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-lbalancec.patch
reiserfs-fix-sparse-warning-in-journalc.patch
reiserfs-fix-more-sparse-warnings-in-do_balanc.patch
reiserfs-replace-remaining-__function__-occurrences.patch
cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc.patch
ext4-replace-remaining-__function__-occurrences.patch
jdb2-replace-remaining-__function__-occurrences.patch
char-fix-sparse-shadowed-variable-warnings-in-espc.patch
char-espc-fix-possible-double-unlock.patch
char-rocketc-fix-sparse-variable-shadowing-and-int-as-null-pointer.patch
cycladesc-fix-sparse-shadowed-variable-warnings.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
security-replace-remaining-__function__-occurences.patch
security-replace-remaining-__function__-occurences-checkpatch-fixes.patch
mm-remove-remaining-__function__-occurances.patch
block-remove-remaining-__function__-occurances.patch
kernel-replace-remaining-__function__-occurances.patch
lib-replace-remaining-__function__-occurances.patch
afs-replace-remaining-__function__-occurrences.patch
fs-replace-remaining-__function__-occurrences.patch
drivers-char-replace-remaining-__function__-occurrences.patch
serial-replace-remaining-__function__-occurrences.patch
acpi-replace-remaining-__function__-occurrences.patch
ata-replace-remaining-__function__-occurrences.patch
block-replace-remaining-__function__-occurrences.patch
iop-admac-replace-remaining-__function__-occurrences.patch
ieee1394-replace-remaining-__function__-occurrences.patch
firmware-replace-remaining-__function__-occurrences.patch
mtd-replace-remaining-__function__-occurrences.patch
md-replace-remaining-__function__-occurrences.patch
drivers-misc-replace-remaining-__function__-occurrences.patch
pcmcia-replace-remaining-__function__-occurrences.patch
ioc3c-replace-remaining-__function__-occurrences.patch
watchdog-replace-remaining-__function__-occurrences.patch
spi-replace-remaining-__function__-occurrences.patch
power-replace-remaining-__function__-occurrences.patch
drivers-replace-remaining-__function__-occurrences.patch

