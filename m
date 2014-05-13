From: akpm@linux-foundation.org
Subject: +
 rapidio-tsi721-use-pci_enable_msix_exact-instead-of-pci_enable_msix.patch
 added to -mm tree
Date: Tue, 13 May 2014 14:46:55 -0700
Message-ID: <537292cf.AVoJJdoblm9iM7bL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55568 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457AbaEMVq4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 May 2014 17:46:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mporter@kernel.crashing.org, alexandre.bounine@idt.com, agordeev@redhat.com

Subject: + rapidio-tsi721-use-pci_enable_msix_exact-instead-of-pci_enable_msix.patch added to -mm tree
To: agordeev@redhat.com,alexandre.bounine@idt.com,mporter@kernel.crashing.org
From: akpm@linux-foundation.org
Date: Tue, 13 May 2014 14:46:55 -0700


The patch titled
     Subject: rapidio/tsi721: use pci_enable_msix_exact() instead of pci_enable_msix()
has been added to the -mm tree.  Its filename is
     rapidio-tsi721-use-pci_enable_msix_exact-instead-of-pci_enable_msix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rapidio-tsi721-use-pci_enable_msix_exact-instead-of-pci_enable_msix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rapidio-tsi721-use-pci_enable_msix_exact-instead-of-pci_enable_msix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexander Gordeev <agordeev@redhat.com>
Subject: rapidio/tsi721: use pci_enable_msix_exact() instead of pci_enable_msix()

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers using these two
interfaces need to be updated to use the new pci_enable_msi_range() or
pci_enable_msi_exact() and pci_enable_msix_range() or
pci_enable_msix_exact() interfaces.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Acked-by: Alexandre Bounine <alexandre.bounine@idt.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/devices/tsi721.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff -puN drivers/rapidio/devices/tsi721.c~rapidio-tsi721-use-pci_enable_msix_exact-instead-of-pci_enable_msix drivers/rapidio/devices/tsi721.c
--- a/drivers/rapidio/devices/tsi721.c~rapidio-tsi721-use-pci_enable_msix_exact-instead-of-pci_enable_msix
+++ a/drivers/rapidio/devices/tsi721.c
@@ -768,15 +768,10 @@ static int tsi721_enable_msix(struct tsi
 	}
 #endif /* CONFIG_RAPIDIO_DMA_ENGINE */
 
-	err = pci_enable_msix(priv->pdev, entries, ARRAY_SIZE(entries));
+	err = pci_enable_msix_exact(priv->pdev, entries, ARRAY_SIZE(entries));
 	if (err) {
-		if (err > 0)
-			dev_info(&priv->pdev->dev,
-				 "Only %d MSI-X vectors available, "
-				 "not using MSI-X\n", err);
-		else
-			dev_err(&priv->pdev->dev,
-				"Failed to enable MSI-X (err=%d)\n", err);
+		dev_err(&priv->pdev->dev,
+			"Failed to enable MSI-X (err=%d)\n", err);
 		return err;
 	}
 
_

Patches currently in -mm which might be from agordeev@redhat.com are

rapidio-tsi721-use-pci_enable_msix_exact-instead-of-pci_enable_msix.patch
linux-next.patch

