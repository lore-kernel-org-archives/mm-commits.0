From: akpm@linux-foundation.org
Subject: + mwl8k-use-pci_zalloc_consistent.patch added to -mm tree
Date: Wed, 25 Jun 2014 12:30:20 -0700
Message-ID: <53ab234c./Dw6T4O5oSt0J2Ct%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46915 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755269AbaFYTaV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jun 2014 15:30:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, buytenh@wantstofly.org, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mwl8k: use pci_zalloc_consistent
has been added to the -mm tree.  Its filename is
     mwl8k-use-pci_zalloc_consistent.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mwl8k-use-pci_zalloc_consistent.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mwl8k-use-pci_zalloc_consistent.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: mwl8k: use pci_zalloc_consistent

Remove the now unnecessary memset too.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/mwl8k.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/net/wireless/mwl8k.c~mwl8k-use-pci_zalloc_consistent drivers/net/wireless/mwl8k.c
--- a/drivers/net/wireless/mwl8k.c~mwl8k-use-pci_zalloc_consistent
+++ a/drivers/net/wireless/mwl8k.c
@@ -1159,12 +1159,11 @@ static int mwl8k_rxq_init(struct ieee802
 
 	size = MWL8K_RX_DESCS * priv->rxd_ops->rxd_size;
 
-	rxq->rxd = pci_alloc_consistent(priv->pdev, size, &rxq->rxd_dma);
+	rxq->rxd = pci_zalloc_consistent(priv->pdev, size, &rxq->rxd_dma);
 	if (rxq->rxd == NULL) {
 		wiphy_err(hw->wiphy, "failed to alloc RX descriptors\n");
 		return -ENOMEM;
 	}
-	memset(rxq->rxd, 0, size);
 
 	rxq->buf = kcalloc(MWL8K_RX_DESCS, sizeof(*rxq->buf), GFP_KERNEL);
 	if (rxq->buf == NULL) {
@@ -1451,12 +1450,11 @@ static int mwl8k_txq_init(struct ieee802
 
 	size = MWL8K_TX_DESCS * sizeof(struct mwl8k_tx_desc);
 
-	txq->txd = pci_alloc_consistent(priv->pdev, size, &txq->txd_dma);
+	txq->txd = pci_zalloc_consistent(priv->pdev, size, &txq->txd_dma);
 	if (txq->txd == NULL) {
 		wiphy_err(hw->wiphy, "failed to alloc TX descriptors\n");
 		return -ENOMEM;
 	}
-	memset(txq->txd, 0, size);
 
 	txq->skb = kcalloc(MWL8K_TX_DESCS, sizeof(*txq->skb), GFP_KERNEL);
 	if (txq->skb == NULL) {
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
checkpatch-check-git-commit-descriptions.patch
fs-squashfs-file_directc-replace-countsize-kmalloc-by-kmalloc_array.patch
printk-make-dynamic-kernel-ring-buffer-alignment-explicit.patch
printk-move-power-of-2-practice-of-ring-buffer-size-to-a-helper.patch
printk-make-dynamic-units-clear-for-the-kernel-ring-buffer.patch
printk-allow-increasing-the-ring-buffer-depending-on-the-number-of-cpus.patch
mm-utilc-add-kstrimdup.patch
kernelh-remove-deprecated-pack_hex_byte.patch
checkpatch-attempt-to-find-unnecessary-out-of-memory-messages.patch
checkpatch-warn-on-unnecessary-else-after-return-or-break.patch
checkpatch-fix-complex-macro-false-positive-for-escaped-constant-char.patch
checkpatch-fix-function-pointers-in-blank-line-needed-after-declarations-test.patch
checkpatch-ignore-email-headers-better.patch
checkpatchpl-also-suggest-else-if-when-if-follows-brace.patch
checkpatch-add-test-for-blank-lines-after-function-struct-union-enum.patch
checkpatch-add-a-multiple-blank-lines-test.patch
checkpatch-change-blank-line-after-declaration-type-to-line_spacing.patch
checkpatch-quiet-kconfig-help-message-checking.patch
fs-isofs-logging-clean-up.patch
sysctl-remove-now-unused-typedef-ctl_table.patch
sysctl-remove-now-unused-typedef-ctl_table-fix.patch
fs-qnx6-convert-printk-to-pr_foo.patch
fs-qnx6-use-pr_fmt-and-__func__-in-logging.patch
fs-qnx6-update-debugging-to-current-functions.patch
linux-next.patch
pci-dma-compat-add-pci_zalloc_consistent-helper.patch
atm-use-pci_zalloc_consistent.patch
block-use-pci_zalloc_consistent.patch
crypto-use-pci_zalloc_consistent.patch
infiniband-use-pci_zalloc_consistent.patch
i810-use-pci_zalloc_consistent.patch
media-use-pci_zalloc_consistent.patch
amd-use-pci_zalloc_consistent.patch
atl1e-use-pci_zalloc_consistent.patch
enic-use-pci_zalloc_consistent.patch
sky2-use-pci_zalloc_consistent.patch
micrel-use-pci_zalloc_consistent.patch
qlogic-use-pci_zalloc_consistent.patch
irda-use-pci_zalloc_consistent.patch
ipw2100-use-pci_zalloc_consistent.patch
mwl8k-use-pci_zalloc_consistent.patch
rtl818x-use-pci_zalloc_consistent.patch
rtlwifi-use-pci_zalloc_consistent.patch
scsi-use-pci_zalloc_consistent.patch
staging-use-pci_zalloc_consistent.patch
synclink_gt-use-pci_zalloc_consistent.patch
vme-bridges-use-pci_zalloc_consistent.patch
amd-neaten-and-remove-unnecessary-oom-messages.patch

