From: akpm@linux-foundation.org
Subject: [merged] drivers-net-wireless-iwlwifi-iwl-txc-fix-gcc-345-warning.patch removed from -mm tree
Date: Mon, 21 Dec 2009 12:25:18 -0800
Message-ID: <200912212025.nBLKPIHJ027215@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48923 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752793AbZLUU0D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Dec 2009 15:26:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, linville@tuxdriver.com, reinette.chatre@intel.com, yi.zhu@intel.com, mm-commits@vger.kernel.org


The patch titled
     drivers/net/wireless/iwlwifi/iwl-tx.c: fix gcc-3.4.5 warning
has been removed from the -mm tree.  Its filename was
     drivers-net-wireless-iwlwifi-iwl-txc-fix-gcc-345-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/net/wireless/iwlwifi/iwl-tx.c: fix gcc-3.4.5 warning
From: Andrew Morton <akpm@linux-foundation.org>

drivers/net/wireless/iwlwifi/iwl-tx.c: In function `iwl_hw_txq_ctx_free':
drivers/net/wireless/iwlwifi/iwl-tx.c:410: warning: suggest explicit braces to avoid ambiguous `else'

Cc: Zhu Yi <yi.zhu@intel.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>
Cc: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/iwlwifi/iwl-tx.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/net/wireless/iwlwifi/iwl-tx.c~drivers-net-wireless-iwlwifi-iwl-txc-fix-gcc-345-warning drivers/net/wireless/iwlwifi/iwl-tx.c
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c~drivers-net-wireless-iwlwifi-iwl-txc-fix-gcc-345-warning
+++ a/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -407,13 +407,14 @@ void iwl_hw_txq_ctx_free(struct iwl_priv
 	int txq_id;
 
 	/* Tx queues */
-	if (priv->txq)
+	if (priv->txq) {
 		for (txq_id = 0; txq_id < priv->hw_params.max_txq_num;
 		     txq_id++)
 			if (txq_id == IWL_CMD_QUEUE_NUM)
 				iwl_cmd_queue_free(priv);
 			else
 				iwl_tx_queue_free(priv, txq_id);
+	}
 	iwl_free_dma_ptr(priv, &priv->kw);
 
 	iwl_free_dma_ptr(priv, &priv->scd_bc_tbls);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
kfifo-move-struct-kfifo-in-place-fix.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
drivers-gpu-drm-i915-i915_dmac-fix-unused-var.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices-checkpatch-fixes.patch
drivers-gpu-drm-radeon-radeon_combiosc-fix-warning.patch
drivers-media-video-pmsc-needs-versionh.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
net-sctp-socketc-fix-warning.patch
proc_fops-convert-drivers-isdn-to-seq_file-fix2.patch
3x59x-fix-pci-resource-management.patch
bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse.patch
fs-ext4-superc-fix-printk-warning.patch
atmel_serial-add-poll_get_char-and-poll_put_char-uart_ops.patch
scsi-aacraid-fix-memory-leak-checkpatch-fixes.patch
aoe-switch-to-the-new-bio_flush_dcache_pages-interface.patch
fs-improve-remountro-vs-buffercache-coherency.patch
percpu-avoid-calling-__pcpu_ptr_to_addrnull.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
char-cyclades-fix-compiler-warning.patch
zlib-optimize-inffast-when-copying-direct-from-output.patch
lib-add-support-for-lzo-compressed-kernels.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
reiser4-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

