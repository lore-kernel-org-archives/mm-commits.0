From: akpm@linux-foundation.org
Subject: - iop-admac-replace-remaining-__function__-occurrences.patch removed from -mm tree
Date: Fri, 07 Mar 2008 15:01:06 -0800
Message-ID: <200803072301.m27N16PO021746@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41366 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751137AbYCGXKh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Mar 2008 18:10:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, dan.j.williams@intel.com, shannon.nelson@intel.com, mm-commits@vger.kernel.org


The patch titled
     iop-adma.c: replace remaining __FUNCTION__ occurrences
has been removed from the -mm tree.  Its filename was
     iop-admac-replace-remaining-__function__-occurrences.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: iop-adma.c: replace remaining __FUNCTION__ occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: "Nelson, Shannon" <shannon.nelson@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/iop-adma.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff -puN drivers/dma/iop-adma.c~iop-admac-replace-remaining-__function__-occurrences drivers/dma/iop-adma.c
--- a/drivers/dma/iop-adma.c~iop-admac-replace-remaining-__function__-occurrences
+++ a/drivers/dma/iop-adma.c
@@ -138,7 +138,7 @@ static void __iop_adma_slot_cleanup(stru
 	int busy = iop_chan_is_busy(iop_chan);
 	int seen_current = 0, slot_cnt = 0, slots_per_op = 0;
 
-	dev_dbg(iop_chan->device->common.dev, "%s\n", __FUNCTION__);
+	dev_dbg(iop_chan->device->common.dev, "%s\n", __func__);
 	/* free completed slots from the chain starting with
 	 * the oldest descriptor
 	 */
@@ -437,7 +437,7 @@ iop_adma_tx_submit(struct dma_async_tx_d
 	spin_unlock_bh(&iop_chan->lock);
 
 	dev_dbg(iop_chan->device->common.dev, "%s cookie: %d slot: %d\n",
-		__FUNCTION__, sw_desc->async_tx.cookie, sw_desc->idx);
+		__func__, sw_desc->async_tx.cookie, sw_desc->idx);
 
 	return cookie;
 }
@@ -519,7 +519,7 @@ iop_adma_prep_dma_interrupt(struct dma_c
 	struct iop_adma_desc_slot *sw_desc, *grp_start;
 	int slot_cnt, slots_per_op;
 
-	dev_dbg(iop_chan->device->common.dev, "%s\n", __FUNCTION__);
+	dev_dbg(iop_chan->device->common.dev, "%s\n", __func__);
 
 	spin_lock_bh(&iop_chan->lock);
 	slot_cnt = iop_chan_interrupt_slot_count(&slots_per_op, iop_chan);
@@ -547,7 +547,7 @@ iop_adma_prep_dma_memcpy(struct dma_chan
 	BUG_ON(unlikely(len > IOP_ADMA_MAX_BYTE_COUNT));
 
 	dev_dbg(iop_chan->device->common.dev, "%s len: %u\n",
-		__FUNCTION__, len);
+		__func__, len);
 
 	spin_lock_bh(&iop_chan->lock);
 	slot_cnt = iop_chan_memcpy_slot_count(len, &slots_per_op);
@@ -579,7 +579,7 @@ iop_adma_prep_dma_memset(struct dma_chan
 	BUG_ON(unlikely(len > IOP_ADMA_MAX_BYTE_COUNT));
 
 	dev_dbg(iop_chan->device->common.dev, "%s len: %u\n",
-		__FUNCTION__, len);
+		__func__, len);
 
 	spin_lock_bh(&iop_chan->lock);
 	slot_cnt = iop_chan_memset_slot_count(len, &slots_per_op);
@@ -613,7 +613,7 @@ iop_adma_prep_dma_xor(struct dma_chan *c
 
 	dev_dbg(iop_chan->device->common.dev,
 		"%s src_cnt: %d len: %u flags: %lx\n",
-		__FUNCTION__, src_cnt, len, flags);
+		__func__, src_cnt, len, flags);
 
 	spin_lock_bh(&iop_chan->lock);
 	slot_cnt = iop_chan_xor_slot_count(len, src_cnt, &slots_per_op);
@@ -647,7 +647,7 @@ iop_adma_prep_dma_zero_sum(struct dma_ch
 		return NULL;
 
 	dev_dbg(iop_chan->device->common.dev, "%s src_cnt: %d len: %u\n",
-		__FUNCTION__, src_cnt, len);
+		__func__, src_cnt, len);
 
 	spin_lock_bh(&iop_chan->lock);
 	slot_cnt = iop_chan_zero_sum_slot_count(len, src_cnt, &slots_per_op);
@@ -658,7 +658,7 @@ iop_adma_prep_dma_zero_sum(struct dma_ch
 		iop_desc_set_zero_sum_byte_count(grp_start, len);
 		grp_start->xor_check_result = result;
 		pr_debug("\t%s: grp_start->xor_check_result: %p\n",
-			__FUNCTION__, grp_start->xor_check_result);
+			__func__, grp_start->xor_check_result);
 		sw_desc->unmap_src_cnt = src_cnt;
 		sw_desc->unmap_len = len;
 		while (src_cnt--)
@@ -693,7 +693,7 @@ static void iop_adma_free_chan_resources
 	iop_chan->last_used = NULL;
 
 	dev_dbg(iop_chan->device->common.dev, "%s slots_allocated %d\n",
-		__FUNCTION__, iop_chan->slots_allocated);
+		__func__, iop_chan->slots_allocated);
 	spin_unlock_bh(&iop_chan->lock);
 
 	/* one is ok since we left it on there on purpose */
@@ -746,7 +746,7 @@ static irqreturn_t iop_adma_eot_handler(
 {
 	struct iop_adma_chan *chan = data;
 
-	dev_dbg(chan->device->common.dev, "%s\n", __FUNCTION__);
+	dev_dbg(chan->device->common.dev, "%s\n", __func__);
 
 	tasklet_schedule(&chan->irq_tasklet);
 
@@ -759,7 +759,7 @@ static irqreturn_t iop_adma_eoc_handler(
 {
 	struct iop_adma_chan *chan = data;
 
-	dev_dbg(chan->device->common.dev, "%s\n", __FUNCTION__);
+	dev_dbg(chan->device->common.dev, "%s\n", __func__);
 
 	tasklet_schedule(&chan->irq_tasklet);
 
@@ -816,7 +816,7 @@ static int __devinit iop_adma_memcpy_sel
 	int err = 0;
 	struct iop_adma_chan *iop_chan;
 
-	dev_dbg(device->common.dev, "%s\n", __FUNCTION__);
+	dev_dbg(device->common.dev, "%s\n", __func__);
 
 	src = kzalloc(sizeof(u8) * IOP_ADMA_TEST_SIZE, GFP_KERNEL);
 	if (!src)
@@ -899,7 +899,7 @@ iop_adma_xor_zero_sum_self_test(struct i
 	int err = 0;
 	struct iop_adma_chan *iop_chan;
 
-	dev_dbg(device->common.dev, "%s\n", __FUNCTION__);
+	dev_dbg(device->common.dev, "%s\n", __func__);
 
 	for (src_idx = 0; src_idx < IOP_ADMA_NUM_SRC_TEST; src_idx++) {
 		xor_srcs[src_idx] = alloc_page(GFP_KERNEL);
@@ -1152,7 +1152,7 @@ static int __devinit iop_adma_probe(stru
 	}
 
 	dev_dbg(&pdev->dev, "%s: allocted descriptor pool virt %p phys %p\n",
-		__FUNCTION__, adev->dma_desc_pool_virt,
+		__func__, adev->dma_desc_pool_virt,
 		(void *) adev->dma_desc_pool);
 
 	adev->id = plat_data->hw_id;
@@ -1278,7 +1278,7 @@ static void iop_chan_start_null_memcpy(s
 	dma_cookie_t cookie;
 	int slot_cnt, slots_per_op;
 
-	dev_dbg(iop_chan->device->common.dev, "%s\n", __FUNCTION__);
+	dev_dbg(iop_chan->device->common.dev, "%s\n", __func__);
 
 	spin_lock_bh(&iop_chan->lock);
 	slot_cnt = iop_chan_memcpy_slot_count(0, &slots_per_op);
@@ -1335,7 +1335,7 @@ static void iop_chan_start_null_xor(stru
 	dma_cookie_t cookie;
 	int slot_cnt, slots_per_op;
 
-	dev_dbg(iop_chan->device->common.dev, "%s\n", __FUNCTION__);
+	dev_dbg(iop_chan->device->common.dev, "%s\n", __func__);
 
 	spin_lock_bh(&iop_chan->lock);
 	slot_cnt = iop_chan_xor_slot_count(0, 2, &slots_per_op);
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
git-x86.patch
acpi-replace-remaining-__function__-occurrences.patch
git-alsa.patch
sound-replace-remaining-__function__-occurences.patch
agp-fix-shadowed-variable-warning-in-amd-k7-agpc.patch
git-arm-master.patch
cifs-remove-global_extern-macro.patch
cifs-replace-remaining-__function__-occurrences.patch
powerpc-replace-remaining-__function__-occurences.patch
ppc-replace-remaining-__function__-occurences.patch
radeon-fix-integer-as-null-pointer-warnings-in-radeon_memc.patch
git-dvb.patch
git-dlm.patch
git-ieee1394.patch
infiniband-replace-remaining-__function__-occurrences.patch
input-replace-remaining-__function__-occurrences.patch
git-jfs.patch
git-kvm.patch
ata-replace-remaining-__function__-occurrences.patch
pata_amd-fix-sparse-warning.patch
git-md-accel.patch
git-mips.patch
mips-replace-remaining-__function__-occurences.patch
jffs2-include-function-prototype-for-jffs2_ioctl.patch
jffs2-fix-sparse-warning-in-nodemgmtc.patch
jffs2-fix-sparse-warning-in-writec.patch
jffs2-fix-sparse-warnings-in-gcc.patch
mtd-replace-remaining-__function__-occurrences.patch
git-net.patch
blackfin-replace-remaining-__function__-occurences.patch
nfs-replace-remaining-__function__-occurrences.patch
git-nfsd.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
pcmcia-replace-remaining-__function__-occurrences.patch
git-selinux.patch
drivers-s390-replace-remaining-__function__-occurrences.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
scsi-stc-make-class-attributes-static.patch
scsi-osstc-make-class-attributes-static.patch
scsi-chc-fix-shadowed-variable-warnings.patch
scsi-chc-fix-shadowed-variable-warnings-checkpatch-fixes.patch
block-replace-remaining-__function__-occurrences.patch
git-watchdog.patch
xfs-replace-remaining-__function__-occurrences.patch
xfs-replace-__inline-with-inline.patch
xtensa-replace-remaining-__function__-occurences.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
smack-fix-integer-as-null-pointer-warning-in-smack_lsmc.patch
alpha-remove-remaining-__function__-occurences.patch
alpha-replace-__inline-with-inline.patch
power-replace-remaining-__function__-occurrences.patch
m68k-replace-remaining-__function__-occurences.patch
uml-replace-remaining-__function__-occurences.patch
adfs-work-around-bogus-sparse-warning.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
autofs4-fix-sparse-warning-in-rootc.patch
kernel-add-clamp-and-clamp_t-macros.patch
kernel-add-clamp-and-clamp_t-macros-checkpatch-fixes.patch
kernel-add-clamp-and-clamp_t-macros-fix.patch
firmware-replace-remaining-__function__-occurrences.patch
drivers-misc-replace-remaining-__function__-occurrences.patch
ioc3c-replace-remaining-__function__-occurrences.patch
ncpfs-add-prototypes-to-ncp_fsh.patch
ncpfs-fix-sparse-warnings-in-ioctlc.patch
ncpfs-fix-sparse-warning-in-ncpsign_kernelc.patch
serial-remove-double-initializer.patch
char-make-functions-static-in-synclinkmpc.patch
spi-replace-remaining-__function__-occurrences.patch
capi-fix-sparse-warnings-using-integer-as-null-pointer.patch
avm-fix-sparse-warning-using-integer-as-null-pointer.patch
eicon-fix-sparse-integer-as-null-pointer-warnings.patch
isdn-replace-remaining-__function__-occurrences.patch
xen-make-blkif_getgeo-static.patch
ecryptfs-replace-remaining-__function__-occurrences.patch
rtc-replace-remaining-__function__-occurrences.patch
fbcon-replace-mono_col-macro-with-static-inline.patch
fbcon-replace-mono_col-macro-with-static-inline-fix.patch
video-replace-remaining-__function__-occurrences.patch
md-fix-integer-as-null-pointer-warnings-in-mdc.patch
md-replace-remaining-__function__-occurrences.patch
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
drivers-replace-remaining-__function__-occurrences.patch
mm-remove-remaining-__function__-occurances.patch
block-remove-remaining-__function__-occurances.patch
kernel-replace-remaining-__function__-occurances.patch
lib-replace-remaining-__function__-occurances.patch
afs-replace-remaining-__function__-occurrences.patch
fs-replace-remaining-__function__-occurrences.patch
drivers-char-replace-remaining-__function__-occurrences.patch
serial-replace-remaining-__function__-occurrences.patch

