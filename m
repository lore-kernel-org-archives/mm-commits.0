From: akpm@linux-foundation.org
Subject: + s2io-dont-run-msi-handlers-if-device-is-offline.patch added to -mm tree
Date: Wed, 23 May 2007 11:05:24 -0700
Message-ID: <200705231805.l4NI5NYc028737@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:37902 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755042AbXEWSGA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 May 2007 14:06:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sivakumar.subramani@neterion.com, Ramkrishna.Vepa@neterion.com, jeff@garzik.org, linas@austin.ibm.com, santosh.rastapur@neterion.com, sreenivasa.honnur@neterion.com, wenxiong@us.ibm.com


The patch titled
     s2io: don't run MSI handlers if device is offline.
has been added to the -mm tree.  Its filename is
     s2io-dont-run-msi-handlers-if-device-is-offline.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: s2io: don't run MSI handlers if device is offline.
From: Linas Vepstas [mailto:linas@austin.ibm.com]

Don't run any of the MSI handlers if the channel is off; also don't gather
device statatistics.  Also, netif_wake not needed, per suggestions from
Sivakumar Subramani <sivakumar.subramani@neterion.com>.

Signed-off-by: Linas Vepstas <linas@austin.ibm.com>
Cc: Ramkrishna Vepa <Ramkrishna.Vepa@neterion.com>
Acked-by: Sivakumar Subramani <sivakumar.subramani@neterion.com>
Cc: Sreenivasa Honnur <sreenivasa.honnur@neterion.com>
Cc: Rastapur Santosh <santosh.rastapur@neterion.com>
Cc: Wen Xiong <wenxiong@us.ibm.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/s2io.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff -puN drivers/net/s2io.c~s2io-dont-run-msi-handlers-if-device-is-offline drivers/net/s2io.c
--- a/drivers/net/s2io.c~s2io-dont-run-msi-handlers-if-device-is-offline
+++ a/drivers/net/s2io.c
@@ -4202,6 +4202,9 @@ static irqreturn_t s2io_msi_handle(int i
 	struct mac_info *mac_control;
 	struct config_param *config;
 
+	if (pci_channel_offline(sp->pdev))
+		return IRQ_NONE;
+
 	atomic_inc(&sp->isr_cnt);
 	mac_control = &sp->mac_control;
 	config = &sp->config;
@@ -4232,6 +4235,9 @@ static irqreturn_t s2io_msix_ring_handle
 	struct ring_info *ring = (struct ring_info *)dev_id;
 	struct s2io_nic *sp = ring->nic;
 
+	if (pci_channel_offline(sp->pdev))
+		return IRQ_NONE;
+
 	atomic_inc(&sp->isr_cnt);
 
 	rx_intr_handler(ring);
@@ -4246,6 +4252,9 @@ static irqreturn_t s2io_msix_fifo_handle
 	struct fifo_info *fifo = (struct fifo_info *)dev_id;
 	struct s2io_nic *sp = fifo->nic;
 
+	if (pci_channel_offline(sp->pdev))
+		return IRQ_NONE;
+
 	atomic_inc(&sp->isr_cnt);
 	tx_intr_handler(fifo);
 	atomic_dec(&sp->isr_cnt);
@@ -4428,6 +4437,9 @@ static void s2io_updt_stats(struct s2io_
 	u64 val64;
 	int cnt = 0;
 
+	if (pci_channel_offline(sp->pdev))
+		return;
+
 	if (atomic_read(&sp->card_state) == CARD_UP) {
 		/* Apprx 30us on a 133 MHz bus */
 		val64 = SET_UPDT_CLICKS(10) |
@@ -8122,5 +8134,4 @@ static void s2io_io_resume(struct pci_de
 	}
 
 	netif_device_attach(netdev);
-	netif_wake_queue(netdev);
 }
_

Patches currently in -mm which might be from sivakumar.subramani@neterion.com are

s2io-dont-run-msi-handlers-if-device-is-offline.patch
