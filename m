From: akpm@linux-foundation.org
Subject: + amd-neaten-and-remove-unnecessary-oom-messages.patch added to
 -mm tree
Date: Wed, 25 Jun 2014 12:31:00 -0700
Message-ID: <53ab2374.W1Z5PLbHXCUPN9gM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46951 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529AbaFYTbA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jun 2014 15:31:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, pcnet32@frontier.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/net/ethernet/amd/pcnet32.c: neaten and remove unnecessary OOM messages
has been added to the -mm tree.  Its filename is
     amd-neaten-and-remove-unnecessary-oom-messages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/amd-neaten-and-remove-unnecessary-oom-messages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/amd-neaten-and-remove-unnecessary-oom-messages.patch

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
Subject: drivers/net/ethernet/amd/pcnet32.c: neaten and remove unnecessary OOM messages

Make the code flow a little better for 80 columns.

Use a consistent style for the RX and TX rings allocation.
Use BIT macro.
Use a temporary unsiged int entries for (1<<size).
Remove the OOM messages as they duplicate the generic
OOM and dump_stack() provided by the memory subsystem.
Reflow allocs to 80 columns.

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Don Fry <pcnet32@frontier.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ethernet/amd/pcnet32.c |   43 +++++++++++----------------
 1 file changed, 18 insertions(+), 25 deletions(-)

diff -puN drivers/net/ethernet/amd/pcnet32.c~amd-neaten-and-remove-unnecessary-oom-messages drivers/net/ethernet/amd/pcnet32.c
--- a/drivers/net/ethernet/amd/pcnet32.c~amd-neaten-and-remove-unnecessary-oom-messages
+++ a/drivers/net/ethernet/amd/pcnet32.c
@@ -481,36 +481,32 @@ static void pcnet32_realloc_tx_ring(stru
 	dma_addr_t *new_dma_addr_list;
 	struct pcnet32_tx_head *new_tx_ring;
 	struct sk_buff **new_skb_list;
+	unsigned int entries = BIT(size);
 
 	pcnet32_purge_tx_ring(dev);
 
-	new_tx_ring = pci_zalloc_consistent(lp->pci_dev,
-					    sizeof(struct pcnet32_tx_head) *
-					    (1 << size),
-					    &new_ring_dma_addr);
-	if (new_tx_ring == NULL) {
-		netif_err(lp, drv, dev, "Consistent memory allocation failed\n");
+	new_tx_ring =
+		pci_zalloc_consistent(lp->pci_dev,
+				      sizeof(struct pcnet32_tx_head) * entries,
+				      &new_ring_dma_addr);
+	if (new_tx_ring == NULL)
 		return;
-	}
 
-	new_dma_addr_list = kcalloc(1 << size, sizeof(dma_addr_t),
-				    GFP_ATOMIC);
+	new_dma_addr_list = kcalloc(entries, sizeof(dma_addr_t), GFP_ATOMIC);
 	if (!new_dma_addr_list)
 		goto free_new_tx_ring;
 
-	new_skb_list = kcalloc(1 << size, sizeof(struct sk_buff *),
-			       GFP_ATOMIC);
+	new_skb_list = kcalloc(entries, sizeof(struct sk_buff *), GFP_ATOMIC);
 	if (!new_skb_list)
 		goto free_new_lists;
 
 	kfree(lp->tx_skbuff);
 	kfree(lp->tx_dma_addr);
 	pci_free_consistent(lp->pci_dev,
-			    sizeof(struct pcnet32_tx_head) *
-			    lp->tx_ring_size, lp->tx_ring,
-			    lp->tx_ring_dma_addr);
+			    sizeof(struct pcnet32_tx_head) * lp->tx_ring_size,
+			    lp->tx_ring, lp->tx_ring_dma_addr);
 
-	lp->tx_ring_size = (1 << size);
+	lp->tx_ring_size = entries;
 	lp->tx_mod_mask = lp->tx_ring_size - 1;
 	lp->tx_len_bits = (size << 12);
 	lp->tx_ring = new_tx_ring;
@@ -523,8 +519,7 @@ free_new_lists:
 	kfree(new_dma_addr_list);
 free_new_tx_ring:
 	pci_free_consistent(lp->pci_dev,
-			    sizeof(struct pcnet32_tx_head) *
-			    (1 << size),
+			    sizeof(struct pcnet32_tx_head) * entries,
 			    new_tx_ring,
 			    new_ring_dma_addr);
 }
@@ -548,16 +543,14 @@ static void pcnet32_realloc_rx_ring(stru
 	struct pcnet32_rx_head *new_rx_ring;
 	struct sk_buff **new_skb_list;
 	int new, overlap;
-	unsigned int entries = 1 << size;
+	unsigned int entries = BIT(size);
 
-	new_rx_ring = pci_zalloc_consistent(lp->pci_dev,
-					    sizeof(struct pcnet32_rx_head) *
-					    entries,
-					    &new_ring_dma_addr);
-	if (new_rx_ring == NULL) {
-		netif_err(lp, drv, dev, "Consistent memory allocation failed\n");
+	new_rx_ring =
+		pci_zalloc_consistent(lp->pci_dev,
+				      sizeof(struct pcnet32_rx_head) * entries,
+				      &new_ring_dma_addr);
+	if (new_rx_ring == NULL)
 		return;
-	}
 
 	new_dma_addr_list = kcalloc(entries, sizeof(dma_addr_t), GFP_ATOMIC);
 	if (!new_dma_addr_list)
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

