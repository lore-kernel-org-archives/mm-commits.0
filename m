From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Thu, 07 Mar 2013 11:07:41 -0800
Message-ID: <20130307190741.834865A424B@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:59675 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932252Ab3CGTHm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Mar 2013 14:07:42 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so74917ghb.5
        for <mm-commits@vger.kernel.org>; Thu, 07 Mar 2013 11:07:41 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/iwlwifi/pcie/internal.h |    8 -
 drivers/net/wireless/iwlwifi/pcie/tx.c       |   76 -----------------
 net/wireless/nl80211.c                       |   15 ---
 3 files changed, 99 deletions(-)

diff -puN drivers/net/wireless/iwlwifi/pcie/internal.h~linux-next-git-rejects drivers/net/wireless/iwlwifi/pcie/internal.h
--- a/drivers/net/wireless/iwlwifi/pcie/internal.h~linux-next-git-rejects
+++ a/drivers/net/wireless/iwlwifi/pcie/internal.h
@@ -181,13 +181,6 @@ struct iwl_queue {
 /*
  * The FH will write back to the first TB only, so we need
  * to copy some data into the buffer regardless of whether
-<<<<<<< HEAD
- * it should be mapped or not. This indicates how much to
- * copy, even for HCMDs it must be big enough to fit the
- * DRAM scratch from the TX cmd, at least 16 bytes.
- */
-#define IWL_HCMD_MIN_COPY_SIZE	16
-=======
  * it should be mapped or not. This indicates how big the
  * first TB must be to include the scratch buffer. Since
  * the scratch is 4 bytes at offset 12, it's 16 now. If we
@@ -195,7 +188,6 @@ struct iwl_queue {
  * slower, so that's probably not useful.
  */
 #define IWL_HCMD_SCRATCHBUF_SIZE	16
->>>>>>> linux-next/akpm-base
 
 struct iwl_pcie_txq_entry {
 	struct iwl_device_cmd *cmd;
diff -puN drivers/net/wireless/iwlwifi/pcie/tx.c~linux-next-git-rejects drivers/net/wireless/iwlwifi/pcie/tx.c
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c~linux-next-git-rejects
+++ a/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -1153,21 +1153,12 @@ static int iwl_pcie_enqueue_hcmd(struct
 	void *dup_buf = NULL;
 	dma_addr_t phys_addr;
 	int idx;
-<<<<<<< HEAD
-	u16 copy_size, cmd_size, dma_size;
-	bool had_nocopy = false;
-	int i;
-	u32 cmd_pos;
-	const u8 *cmddata[IWL_MAX_CMD_TFDS];
-	u16 cmdlen[IWL_MAX_CMD_TFDS];
-=======
 	u16 copy_size, cmd_size, scratch_size;
 	bool had_nocopy = false;
 	int i;
 	u32 cmd_pos;
 	const u8 *cmddata[IWL_MAX_CMD_TBS_PER_TFD];
 	u16 cmdlen[IWL_MAX_CMD_TBS_PER_TFD];
->>>>>>> linux-next/akpm-base
 
 	copy_size = sizeof(out_cmd->hdr);
 	cmd_size = sizeof(out_cmd->hdr);
@@ -1179,25 +1170,12 @@ static int iwl_pcie_enqueue_hcmd(struct
 		cmddata[i] = cmd->data[i];
 		cmdlen[i] = cmd->len[i];
 
-<<<<<<< HEAD
-	for (i = 0; i < IWL_MAX_CMD_TFDS; i++) {
-		cmddata[i] = cmd->data[i];
-		cmdlen[i] = cmd->len[i];
-
-		if (!cmd->len[i])
-			continue;
-
-		/* need at least IWL_HCMD_MIN_COPY_SIZE copied */
-		if (copy_size < IWL_HCMD_MIN_COPY_SIZE) {
-			int copy = IWL_HCMD_MIN_COPY_SIZE - copy_size;
-=======
 		if (!cmd->len[i])
 			continue;
 
 		/* need at least IWL_HCMD_SCRATCHBUF_SIZE copied */
 		if (copy_size < IWL_HCMD_SCRATCHBUF_SIZE) {
 			int copy = IWL_HCMD_SCRATCHBUF_SIZE - copy_size;
->>>>>>> linux-next/akpm-base
 
 			if (copy > cmdlen[i])
 				copy = cmdlen[i];
@@ -1283,38 +1261,11 @@ static int iwl_pcie_enqueue_hcmd(struct
 	/* and copy the data that needs to be copied */
 	cmd_pos = offsetof(struct iwl_device_cmd, payload);
 	copy_size = sizeof(out_cmd->hdr);
-<<<<<<< HEAD
-	for (i = 0; i < IWL_MAX_CMD_TFDS; i++) {
-=======
 	for (i = 0; i < IWL_MAX_CMD_TBS_PER_TFD; i++) {
->>>>>>> linux-next/akpm-base
 		int copy = 0;
 
 		if (!cmd->len)
 			continue;
-<<<<<<< HEAD
-
-		/* need at least IWL_HCMD_MIN_COPY_SIZE copied */
-		if (copy_size < IWL_HCMD_MIN_COPY_SIZE) {
-			copy = IWL_HCMD_MIN_COPY_SIZE - copy_size;
-
-			if (copy > cmd->len[i])
-				copy = cmd->len[i];
-		}
-
-		/* copy everything if not nocopy/dup */
-		if (!(cmd->dataflags[i] & (IWL_HCMD_DFL_NOCOPY |
-					   IWL_HCMD_DFL_DUP)))
-			copy = cmd->len[i];
-
-		if (copy) {
-			memcpy((u8 *)out_cmd + cmd_pos, cmd->data[i], copy);
-			cmd_pos += copy;
-			copy_size += copy;
-		}
-	}
-=======
->>>>>>> linux-next/akpm-base
 
 		/* need at least IWL_HCMD_SCRATCHBUF_SIZE copied */
 		if (copy_size < IWL_HCMD_SCRATCHBUF_SIZE) {
@@ -1342,24 +1293,6 @@ static int iwl_pcie_enqueue_hcmd(struct
 		     out_cmd->hdr.cmd, le16_to_cpu(out_cmd->hdr.sequence),
 		     cmd_size, q->write_ptr, idx, trans_pcie->cmd_queue);
 
-<<<<<<< HEAD
-	/*
-	 * If the entire command is smaller than IWL_HCMD_MIN_COPY_SIZE, we must
-	 * still map at least that many bytes for the hardware to write back to.
-	 * We have enough space, so that's not a problem.
-	 */
-	dma_size = max_t(u16, copy_size, IWL_HCMD_MIN_COPY_SIZE);
-
-	phys_addr = dma_map_single(trans->dev, &out_cmd->hdr, dma_size,
-				   DMA_BIDIRECTIONAL);
-	if (unlikely(dma_mapping_error(trans->dev, phys_addr))) {
-		idx = -ENOMEM;
-		goto out;
-	}
-
-	dma_unmap_addr_set(out_meta, mapping, phys_addr);
-	dma_unmap_len_set(out_meta, len, dma_size);
-=======
 	/* start the TFD with the scratchbuf */
 	scratch_size = min_t(int, copy_size, IWL_HCMD_SCRATCHBUF_SIZE);
 	memcpy(&txq->scratchbufs[q->write_ptr], &out_cmd->hdr, scratch_size);
@@ -1379,18 +1312,13 @@ static int iwl_pcie_enqueue_hcmd(struct
 			idx = -ENOMEM;
 			goto out;
 		}
->>>>>>> linux-next/akpm-base
 
 		iwl_pcie_txq_build_tfd(trans, txq, phys_addr,
 				       copy_size - scratch_size, 0);
 	}
 
 	/* map the remaining (adjusted) nocopy/dup fragments */
-<<<<<<< HEAD
-	for (i = 0; i < IWL_MAX_CMD_TFDS; i++) {
-=======
 	for (i = 0; i < IWL_MAX_CMD_TBS_PER_TFD; i++) {
->>>>>>> linux-next/akpm-base
 		const void *data = cmddata[i];
 
 		if (!cmdlen[i])
@@ -1401,11 +1329,7 @@ static int iwl_pcie_enqueue_hcmd(struct
 		if (cmd->dataflags[i] & IWL_HCMD_DFL_DUP)
 			data = dup_buf;
 		phys_addr = dma_map_single(trans->dev, (void *)data,
-<<<<<<< HEAD
-					   cmdlen[i], DMA_BIDIRECTIONAL);
-=======
 					   cmdlen[i], DMA_TO_DEVICE);
->>>>>>> linux-next/akpm-base
 		if (dma_mapping_error(trans->dev, phys_addr)) {
 			iwl_pcie_tfd_unmap(trans, out_meta,
 					   &txq->tfds[q->write_ptr]);
diff -puN net/wireless/nl80211.c~linux-next-git-rejects net/wireless/nl80211.c
--- a/net/wireless/nl80211.c~linux-next-git-rejects
+++ a/net/wireless/nl80211.c
@@ -556,21 +556,6 @@ static int nl80211_msg_put_channel(struc
 		goto nla_put_failure;
 	if ((chan->flags & IEEE80211_CHAN_RADAR) &&
 	    nla_put_flag(msg, NL80211_FREQUENCY_ATTR_RADAR))
-<<<<<<< HEAD
-		goto nla_put_failure;
-	if ((chan->flags & IEEE80211_CHAN_NO_HT40MINUS) &&
-	    nla_put_flag(msg, NL80211_FREQUENCY_ATTR_NO_HT40_MINUS))
-		goto nla_put_failure;
-	if ((chan->flags & IEEE80211_CHAN_NO_HT40PLUS) &&
-	    nla_put_flag(msg, NL80211_FREQUENCY_ATTR_NO_HT40_PLUS))
-		goto nla_put_failure;
-	if ((chan->flags & IEEE80211_CHAN_NO_80MHZ) &&
-	    nla_put_flag(msg, NL80211_FREQUENCY_ATTR_NO_80MHZ))
-		goto nla_put_failure;
-	if ((chan->flags & IEEE80211_CHAN_NO_160MHZ) &&
-	    nla_put_flag(msg, NL80211_FREQUENCY_ATTR_NO_160MHZ))
-=======
->>>>>>> linux-next/akpm-base
 		goto nla_put_failure;
 
 	if (nla_put_u32(msg, NL80211_FREQUENCY_ATTR_MAX_TX_POWER,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
dmi_scan-fix-missing-check-for-_dmi_-signature-in-smbios_present-fix.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-v3-fix.patch
mm.patch
mm-shmemc-remove-an-ifdef.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
kernel-smpc-cleanups.patch
epoll-trim-epitem-by-one-cache-line-on-x86_64-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-ds1307-long-block-operations-bugfix.patch
kexec-use-min_t-to-simplify-logic-fix.patch
aio-kiocb_cancel-fix.patch
wait-add-wait_event_hrtimeout-fix.patch
aio-use-cancellation-list-lazily-fix-fix.patch
aio-give-shared-kioctx-fields-their-own-cachelines-fix.patch
generic-dynamic-per-cpu-refcounting-fix.patch
generic-dynamic-per-cpu-refcounting-sparse-fixes-fix.patch
generic-dynamic-per-cpu-refcounting-doc-fix.patch
aio-dont-include-aioh-in-schedh-fix.patch
aio-dont-include-aioh-in-schedh-fix-fix.patch
aio-dont-include-aioh-in-schedh-fix-3.patch
aio-dont-include-aioh-in-schedh-fix-3-fix.patch
aio-dont-include-aioh-in-schedh-fix-3-fix-fix.patch
aio-kill-ki_retry-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-fix-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

