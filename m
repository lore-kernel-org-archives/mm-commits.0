From: akpm@linux-foundation.org
Subject: + drivers-scsi-iprh-fix-buffer-overflow.patch added to -mm tree
Date: Wed, 29 Jul 2009 14:08:12 -0700
Message-ID: <200907292108.n6TL8CIX025212@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44369 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752357AbZG2VIr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Jul 2009 17:08:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, James.Bottomley@HansenPartnership.com, brking@us.ibm.com


The patch titled
     drivers/scsi/ipr.h: fix buffer overflow
has been added to the -mm tree.  Its filename is
     drivers-scsi-iprh-fix-buffer-overflow.patch

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
Subject: drivers/scsi/ipr.h: fix buffer overflow
From: Roel Kluin <roel.kluin@gmail.com>

ioa_cfg->ipr_cmd_label is 8 bytes, IPR_CMD_LABEL is the string "ipr_cmnd",
ie 9 bytes including terminating null.

This patch also corrects the sizes of the other strings.

Found with Parfait, http://research.sun.com/projects/parfait/

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Brian King <brking@us.ibm.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/ipr.h |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN drivers/scsi/ipr.h~drivers-scsi-iprh-fix-buffer-overflow drivers/scsi/ipr.h
--- a/drivers/scsi/ipr.h~drivers-scsi-iprh-fix-buffer-overflow
+++ a/drivers/scsi/ipr.h
@@ -1081,7 +1081,7 @@ enum ipr_cache_state {
 
 /* Per-controller data */
 struct ipr_ioa_cfg {
-	char eye_catcher[8];
+	char eye_catcher[7];
 #define IPR_EYECATCHER			"iprcfg"
 
 	struct list_head queue;
@@ -1111,7 +1111,7 @@ struct ipr_ioa_cfg {
 #define IPR_NUM_TRACE_INDEX_BITS	8
 #define IPR_NUM_TRACE_ENTRIES		(1 << IPR_NUM_TRACE_INDEX_BITS)
 #define IPR_TRACE_SIZE	(sizeof(struct ipr_trace_entry) * IPR_NUM_TRACE_ENTRIES)
-	char trace_start[8];
+	char trace_start[6];
 #define IPR_TRACE_START_LABEL			"trace"
 	struct ipr_trace_entry *trace;
 	u32 trace_index:IPR_NUM_TRACE_INDEX_BITS;
@@ -1119,18 +1119,18 @@ struct ipr_ioa_cfg {
 	/*
 	 * Queue for free command blocks
 	 */
-	char ipr_free_label[8];
+	char ipr_free_label[7];
 #define IPR_FREEQ_LABEL			"free-q"
 	struct list_head free_q;
 
 	/*
 	 * Queue for command blocks outstanding to the adapter
 	 */
-	char ipr_pending_label[8];
+	char ipr_pending_label[7];
 #define IPR_PENDQ_LABEL			"pend-q"
 	struct list_head pending_q;
 
-	char cfg_table_start[8];
+	char cfg_table_start[4];
 #define IPR_CFG_TBL_START		"cfg"
 	struct ipr_config_table *cfg_table;
 	dma_addr_t cfg_table_dma;
@@ -1141,7 +1141,7 @@ struct ipr_ioa_cfg {
 	struct list_head free_res_q;
 	struct list_head used_res_q;
 
-	char ipr_hcam_label[8];
+	char ipr_hcam_label[6];
 #define IPR_HCAM_LABEL			"hcams"
 	struct ipr_hostrcb *hostrcb[IPR_NUM_HCAMS];
 	dma_addr_t hostrcb_dma[IPR_NUM_HCAMS];
@@ -1198,7 +1198,7 @@ struct ipr_ioa_cfg {
 	int (*reset) (struct ipr_cmnd *);
 
 	struct ata_host ata_host;
-	char ipr_cmd_label[8];
+	char ipr_cmd_label[9];
 #define IPR_CMD_LABEL		"ipr_cmnd"
 	struct ipr_cmnd *ipr_cmnd_list[IPR_NUM_CMD_BLKS];
 	u32 ipr_cmnd_list_dma[IPR_NUM_CMD_BLKS];
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
stmp3xxx-deallocation-with-negative-index-of-descriptors.patch
dm-strncpy-does-not-null-terminate-string.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
i915-fix-read-outside-array-bounds.patch
media-strncpy-does-not-null-terminate-string.patch
ivtv-read-buffer-overflow.patch
siano-read-buffer-overflow.patch
drivers-media-video-bw-qcamc-fix-read-buffer-overflow.patch
stk-webcam-read-buffer-overflow.patch
ipath-strncpy-does-not-null-terminate-string.patch
mips-decrease-size-of-au1xxx_dbdma_pm_regs.patch
irda-fix-read-buffer-overflow.patch
atlx-strncpy-does-not-null-terminate-string.patch
ext4-remove-redundant-test-on-unsigned.patch
ocfs2-keep-index-within-status_map.patch
cyclades-read-buffer-overflow.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
ibmmca-buffer-overflow.patch
scsi-eata-fix-buffer-overflow.patch
drivers-scsi-gdthc-fix-buffer-overflow.patch
drivers-scsi-iprh-fix-buffer-overflow.patch
libertas-fix-read-outside-array-bounds.patch
libertas-read-buffer-overflow.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m32r-remove-redundant-tests-on-unsigned.patch
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
dme1737-keep-index-within-pwm_config.patch
ncpfs-read-buffer-overflow.patch
smbfs-read-buffer-overflow.patch
platinumfb-misplaced-parenthesis.patch
sisfb-read-buffer-overflow.patch
documentation-strncpy-does-not-null-terminate-string.patch
adfs-remove-redundant-test-on-unsigned.patch

