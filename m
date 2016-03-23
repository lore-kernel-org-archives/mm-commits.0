From: akpm@linux-foundation.org
Subject: [merged] rapidio-tsi721-fix-hardcoded-mrrs-setting.patch removed
 from -mm tree
Date: Wed, 23 Mar 2016 10:41:15 -0700
Message-ID: <56f2d53b.MGERJAYcwXihbTAk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59161 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756636AbcCWRlQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2016 13:41:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, a-jacquiot@ti.com, andre.van.herk@prodrive-technologies.com, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio/tsi721: fix hardcoded MRRS setting
has been removed from the -mm tree.  Its filename was
     rapidio-tsi721-fix-hardcoded-mrrs-setting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: rapidio/tsi721: fix hardcoded MRRS setting

Remove use of hardcoded setting for Maximum Read Request Size (MRRS) value
and use one set by PCIe bus driver.

Using hardcoded value can cause PCIe bus errors on platforms that have
tsi721 device on PCIe path that allows only smaller read request sizes.

This fix is applicable to kernel versions starting from v3.2.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
Cc: Andre van Herk <andre.van.herk@prodrive-technologies.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/devices/tsi721.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/rapidio/devices/tsi721.c~rapidio-tsi721-fix-hardcoded-mrrs-setting drivers/rapidio/devices/tsi721.c
--- a/drivers/rapidio/devices/tsi721.c~rapidio-tsi721-fix-hardcoded-mrrs-setting
+++ a/drivers/rapidio/devices/tsi721.c
@@ -2426,11 +2426,9 @@ static int tsi721_probe(struct pci_dev *
 
 	BUG_ON(!pci_is_pcie(pdev));
 
-	/* Clear "no snoop" and "relaxed ordering" bits, use default MRRS. */
+	/* Clear "no snoop" and "relaxed ordering" bits. */
 	pcie_capability_clear_and_set_word(pdev, PCI_EXP_DEVCTL,
-		PCI_EXP_DEVCTL_READRQ | PCI_EXP_DEVCTL_RELAX_EN |
-		PCI_EXP_DEVCTL_NOSNOOP_EN,
-		PCI_EXP_DEVCTL_READRQ_512B);
+		PCI_EXP_DEVCTL_RELAX_EN | PCI_EXP_DEVCTL_NOSNOOP_EN, 0);
 
 	/* Adjust PCIe completion timeout. */
 	pcie_capability_clear_and_set_word(pdev, PCI_EXP_DEVCTL2, 0xf, 0x2);
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are


