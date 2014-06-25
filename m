From: akpm@linux-foundation.org
Subject: + rtlwifi-use-pci_zalloc_consistent.patch added to -mm tree
Date: Wed, 25 Jun 2014 12:30:22 -0700
Message-ID: <53ab234e.Q2LfE8a6jEF/dlRS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46921 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755274AbaFYTaX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jun 2014 15:30:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, Larry.Finger@lwfinger.net, chaoming_li@realsil.com.cn, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtlwifi: use pci_zalloc_consistent
has been added to the -mm tree.  Its filename is
     rtlwifi-use-pci_zalloc_consistent.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtlwifi-use-pci_zalloc_consistent.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtlwifi-use-pci_zalloc_consistent.patch

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
Subject: rtlwifi: use pci_zalloc_consistent

Remove the now unnecessary memset too.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Chaoming Li <chaoming_li@realsil.com.cn>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/rtlwifi/pci.c |   17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff -puN drivers/net/wireless/rtlwifi/pci.c~rtlwifi-use-pci_zalloc_consistent drivers/net/wireless/rtlwifi/pci.c
--- a/drivers/net/wireless/rtlwifi/pci.c~rtlwifi-use-pci_zalloc_consistent
+++ a/drivers/net/wireless/rtlwifi/pci.c
@@ -1092,16 +1092,14 @@ static int _rtl_pci_init_tx_ring(struct
 	u32 nextdescaddress;
 	int i;
 
-	ring = pci_alloc_consistent(rtlpci->pdev,
-				    sizeof(*ring) * entries, &dma);
-
+	ring = pci_zalloc_consistent(rtlpci->pdev, sizeof(*ring) * entries,
+				     &dma);
 	if (!ring || (unsigned long)ring & 0xFF) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
 			 "Cannot allocate TX ring (prio = %d)\n", prio);
 		return -ENOMEM;
 	}
 
-	memset(ring, 0, sizeof(*ring) * entries);
 	rtlpci->tx_ring[prio].desc = ring;
 	rtlpci->tx_ring[prio].dma = dma;
 	rtlpci->tx_ring[prio].idx = 0;
@@ -1139,10 +1137,9 @@ static int _rtl_pci_init_rx_ring(struct
 	for (rx_queue_idx = 0; rx_queue_idx < RTL_PCI_MAX_RX_QUEUE;
 	     rx_queue_idx++) {
 		rtlpci->rx_ring[rx_queue_idx].desc =
-		    pci_alloc_consistent(rtlpci->pdev,
-					 sizeof(*rtlpci->rx_ring[rx_queue_idx].
-						desc) * rtlpci->rxringcount,
-					 &rtlpci->rx_ring[rx_queue_idx].dma);
+			pci_zalloc_consistent(rtlpci->pdev,
+					      sizeof(*rtlpci->rx_ring[rx_queue_idx].desc) * rtlpci->rxringcount,
+					      &rtlpci->rx_ring[rx_queue_idx].dma);
 
 		if (!rtlpci->rx_ring[rx_queue_idx].desc ||
 		    (unsigned long)rtlpci->rx_ring[rx_queue_idx].desc & 0xFF) {
@@ -1151,10 +1148,6 @@ static int _rtl_pci_init_rx_ring(struct
 			return -ENOMEM;
 		}
 
-		memset(rtlpci->rx_ring[rx_queue_idx].desc, 0,
-		       sizeof(*rtlpci->rx_ring[rx_queue_idx].desc) *
-		       rtlpci->rxringcount);
-
 		rtlpci->rx_ring[rx_queue_idx].idx = 0;
 
 		/* If amsdu_8k is disabled, set buffersize to 4096. This
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

