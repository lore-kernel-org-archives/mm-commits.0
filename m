From: akpm@linux-foundation.org
Subject: - iwl-basec-bugfixes.patch removed from -mm tree
Date: Thu, 30 Aug 2007 23:34:53 -0700
Message-ID: <200708310634.l7V6YrZL027735@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45940 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758369AbXHaGfx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Aug 2007 02:35:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, linville@tuxdriver.com, tomasw@gmail.com, mm-commits@vger.kernel.org


The patch titled
     iwl-base.c bugfixes
has been removed from the -mm tree.  Its filename was
     iwl-basec-bugfixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: iwl-base.c bugfixes
From: Adrian Bunk <bunk@kernel.org>

This patch fixes two obvious bugs.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: "Tomas Winkler" <tomasw@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/iwl-base.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/net/wireless/iwl-base.c~iwl-basec-bugfixes drivers/net/wireless/iwl-base.c
--- a/drivers/net/wireless/iwl-base.c~iwl-basec-bugfixes
+++ a/drivers/net/wireless/iwl-base.c
@@ -343,7 +343,7 @@ int iwl_tx_queue_init(struct iwl_priv *p
 	 * command is very huge the system will not have two scan at the
 	 * same time */
 	len = sizeof(struct iwl_cmd) * slots_num;
-	if (txq_id == IWL_CMD_QUEUE_NUM);
+	if (txq_id == IWL_CMD_QUEUE_NUM)
 		len +=  IWL_MAX_SCAN_SIZE;
 	txq->cmd = pci_alloc_consistent(dev, len, &txq->dma_addr_cmd);
 	if (!txq->cmd)
@@ -390,7 +390,7 @@ void iwl_tx_queue_free(struct iwl_priv *
 		iwl_hw_txq_free_tfd(priv, txq);
 
 	len = sizeof(struct iwl_cmd) * q->n_window;
-	if (q->id == IWL_CMD_QUEUE_NUM);
+	if (q->id == IWL_CMD_QUEUE_NUM)
 		len += IWL_MAX_SCAN_SIZE;
 
 	pci_free_consistent(dev, len, txq->cmd, txq->dma_addr_cmd);
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
arm-extern-inline-static-inline.patch
ppc-remove-apus-support.patch
git-dvb.patch
ivtv-fbc-bugfix.patch
git-kbuild.patch
pass-g-to-assembler-under-config_debug_info-fix.patch
fix-ide-ide-hook-acpi-psx-method-to-ide-power-on-off.patch
fix-ide-ide-remove-ide-dma-check.patch
drivers-mtd-mtdbdic-is-no-longer-an-own-module.patch
git-nfsd.patch
git-wireless.patch
fix-x86_64-mm-unwinder.patch
i386-visws-extern-inline-static-inline.patch
file-capabilities-clear-fcaps-on-inode-change-fix.patch
security-cleanups.patch
make-kernel-power-maincsuspend_enter-static.patch
uml-fix-inlines.patch
kconfig-syntax-cleanups.patch
kernel-time-timekeepingc-cleanups.patch
make-fs-libfscsimple_commit_write-static.patch
allow-disabling-dnotify-without-embedded.patch
use-erestart_restartblock-if-poll-is-interrupted-by-a-signal-fix.patch
remove-include-asm-ipch.patch
n_hdlcc-fix-check-after-use.patch
kernel-sys_nic-add-dummy-sys_ni_syscall-prototype.patch
make-kernel-profilectime_hook-static.patch
remove-fs-ext2-balloccreserve_blocks.patch
pm3fb-mtrr-support-and-noaccel-option-make-pm3fb_init-static-again.patch
sysctl-parport-remove-binary-paths-fix.patch
sysctl-error-on-bad-sysctl-tables-kernel-sysctl_checkc-must-include-linux-stringh.patch
reiser4-cryptcompress-misc-fixups-make-3-functions-static.patch
