From: akpm@linux-foundation.org
Subject: + drivers-net-wireless-iwlwifi-iwl-txc-fix-gcc-345-warning.patch added to -mm tree
Date: Mon, 14 Dec 2009 15:56:54 -0800
Message-ID: <200912150021.nBF0LCu7022643@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46545 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758845AbZLOAV3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Dec 2009 19:21:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, linville@tuxdriver.com, reinette.chatre@intel.com, yi.zhu@intel.com


The patch titled
     drivers/net/wireless/iwlwifi/iwl-tx.c: fix gcc-3.4.5 warning
has been added to the -mm tree.  Its filename is
     drivers-net-wireless-iwlwifi-iwl-txc-fix-gcc-345-warning.patch

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
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap-checkpatch-fixes.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix-fix.patch
oom-kill-show-virtual-size-and-rss-information-of-the-killed-process-fix.patch
oom-kill-fix-numa-consraint-check-with-nodemask-v42-checkpatch-fixes.patch
mm-mlocking-in-try_to_unmap_one-fix-fix.patch
mm-memory_hotplug-make-offline_pages-static.patch
mm-hugetlb-fix-hugepage-memory-leak-in-mincore-cleanup.patch
mm-hugetlb-fix-hugepage-memory-leak-in-mincore-build-fix.patch
mm-hugetlb-add-hugepage-support-to-pagemap-build-fix.patch
procfs-allow-threads-to-rename-siblings-via-proc-pid-tasks-tid-comm-cleanup.patch
floppy-add-an-extra-bound-check-on-ioctl-arguments-fix.patch
drivers-misc-add-driver-for-texas-instruments-dac7512-update.patch
rwsem-fix-rwsem_is_locked-bugs-fix.patch
kernelh-add-printk_ratelimited-and-pr_level_rl-checkpatch-fixes.patch
kernelh-add-printk_ratelimited-and-pr_level_rl-rename.patch
errh-add-helper-function-to-simplify-pointer-error-checking-fix.patch
cs5535-add-a-generic-mfgpt-driver-fix.patch
cs5535-add-a-generic-clock-event-mfgpt-driver-fix.patch
drivers-scsi-sym53c8xx_2-sym_gluec-rename-skip_spaces-to-sym_skip_spaces.patch
lib-introduce-strim-checkpatch-fixes.patch
blackfin-sd-host-controller-driver-fix.patch
blackfin-sd-host-controller-driver-fix-fix.patch
blackfin-sd-host-controller-driver-fix-fix-fix.patch
crc32-minor-optimizations-and-cleanup-checkpatch-fixes.patch
hwmon-w83627ehf-updates-checkpatch-fixes.patch
lis3-update-documentation-to-match-latest-changes-fix.patch
drivers-net-wireless-iwlwifi-iwl-txc-fix-gcc-345-warning.patch

