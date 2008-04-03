From: akpm@linux-foundation.org
Subject: - r8169-fix-irqx-nobody-cared-for-shared-irq-with-intx.patch removed from -mm tree
Date: Thu, 03 Apr 2008 10:14:57 -0700
Message-ID: <200804031714.m33HEwPZ013165@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51424 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759042AbYDCRPb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Apr 2008 13:15:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yhlu.kernel.send@gmail.com, romieu@fr.zoreil.com, yhlu.kernel@gmail.com, mm-commits@vger.kernel.org


The patch titled
     r8169: fix IRQx nobody cared for shared irq with INTx
has been removed from the -mm tree.  Its filename was
     r8169-fix-irqx-nobody-cared-for-shared-irq-with-intx.patch

This patch was dropped because it was withdrawn

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: r8169: fix IRQx nobody cared for shared irq with INTx
From: Yinghai Lu <yhlu.kernel.send@gmail.com>

try to solve
	troubles with r8169
	http://lkml.org/lkml/2007/8/12/225

same to
	[PATCH] e1000: fix IRQx nobody cared for shared irq with INTx
	http://lkml.org/lkml/2008/3/29/103

[akpm@linux-foundation.org: cleanups]
Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Francois Romieu <romieu@fr.zoreil.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/r8169.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN drivers/net/r8169.c~r8169-fix-irqx-nobody-cared-for-shared-irq-with-intx drivers/net/r8169.c
--- a/drivers/net/r8169.c~r8169-fix-irqx-nobody-cared-for-shared-irq-with-intx
+++ a/drivers/net/r8169.c
@@ -1619,6 +1619,8 @@ rtl8169_init_one(struct pci_dev *pdev, c
 	tp->dev = dev;
 	tp->msg_enable = netif_msg_init(debug.msg_enable, R8169_MSG_DEFAULT);
 
+	/* disable INTx at first */
+	pci_intx(pdev, 0);
 	/* enable device (incl. PCI PM wakeup and hotplug setup) */
 	rc = pci_enable_device(pdev);
 	if (rc < 0) {
@@ -1887,6 +1889,11 @@ static int rtl8169_open(struct net_devic
 	if (retval < 0)
 		goto err_release_ring_2;
 
+	if (!(tp->features & RTL_FEATURE_MSI)) {
+		/* enable INTx if not using MSI */
+		pci_intx(pdev, 1);
+	}
+
 #ifdef CONFIG_R8169_NAPI
 	napi_enable(&tp->napi);
 #endif
_

Patches currently in -mm which might be from yhlu.kernel.send@gmail.com are

r8169-fix-irqx-nobody-cared-for-shared-irq-with-intx.patch
mm-allocate-section_map-for-sparse_init-update.patch
mm-allocate-section_map-for-sparse_init-update-fix.patch
mm-allocate-section_map-for-sparse_init-powerpc-fix.patch
mm-offset-align-in-alloc_bootmem.patch
mm-make-reserve_bootmem-can-crossed-the-nodes.patch

