From: akpm@linux-foundation.org
Subject: [merged] pci-mm-add-pci_pool_zalloc-call.patch removed from -mm
 tree
Date: Wed, 09 Sep 2015 12:47:02 -0700
Message-ID: <55f08cb6.VoZJnYQadqIrtJhM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39559 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754622AbbIITrD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:47:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sean.stalley@intel.com, Gilles.Muller@lip6.fr, bhelgaas@google.com, bigeasy@linutronix.de, corbet@lwn.net, mmarek@suse.cz, nicolas.palix@imag.fr, vinod.koul@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: pci: mm: add pci_pool_zalloc() call
has been removed from the -mm tree.  Its filename was
     pci-mm-add-pci_pool_zalloc-call.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Sean O. Stalley" <sean.stalley@intel.com>
Subject: pci: mm: add pci_pool_zalloc() call

Add a wrapper function for pci_pool_alloc() to get zeroed memory.

Signed-off-by: Sean O. Stalley <sean.stalley@intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Gilles Muller <Gilles.Muller@lip6.fr>
Cc: Nicolas Palix <nicolas.palix@imag.fr>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pci.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/pci.h~pci-mm-add-pci_pool_zalloc-call include/linux/pci.h
--- a/include/linux/pci.h~pci-mm-add-pci_pool_zalloc-call
+++ a/include/linux/pci.h
@@ -1227,6 +1227,8 @@ int pci_set_vga_state(struct pci_dev *pd
 		dma_pool_create(name, &pdev->dev, size, align, allocation)
 #define	pci_pool_destroy(pool) dma_pool_destroy(pool)
 #define	pci_pool_alloc(pool, flags, handle) dma_pool_alloc(pool, flags, handle)
+#define	pci_pool_zalloc(pool, flags, handle) \
+		dma_pool_zalloc(pool, flags, handle)
 #define	pci_pool_free(pool, vaddr, addr) dma_pool_free(pool, vaddr, addr)
 
 struct msix_entry {
_

Patches currently in -mm which might be from sean.stalley@intel.com are


