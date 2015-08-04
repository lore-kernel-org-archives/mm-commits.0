From: akpm@linux-foundation.org
Subject: + pci-mm-add-pci_pool_zalloc-call.patch added to -mm tree
Date: Tue, 04 Aug 2015 16:03:49 -0700
Message-ID: <55c144d5.aBjOsvweOaQBwq9u%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58862 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654AbbHDXDu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Aug 2015 19:03:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sean.stalley@intel.com, Gilles.Muller@lip6.fr, bhelgaas@google.com, bigeasy@linutronix.de, corbet@lwn.net, mmarek@suse.cz, nicolas.palix@imag.fr, vinod.koul@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: pci: mm: add pci_pool_zalloc() call
has been added to the -mm tree.  Its filename is
     pci-mm-add-pci_pool_zalloc-call.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/pci-mm-add-pci_pool_zalloc-call.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/pci-mm-add-pci_pool_zalloc-call.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1195,6 +1195,8 @@ int pci_set_vga_state(struct pci_dev *pd
 		dma_pool_create(name, &pdev->dev, size, align, allocation)
 #define	pci_pool_destroy(pool) dma_pool_destroy(pool)
 #define	pci_pool_alloc(pool, flags, handle) dma_pool_alloc(pool, flags, handle)
+#define	pci_pool_zalloc(pool, flags, handle) \
+		dma_pool_zalloc(pool, flags, handle)
 #define	pci_pool_free(pool, vaddr, addr) dma_pool_free(pool, vaddr, addr)
 
 struct msix_entry {
_

Patches currently in -mm which might be from sean.stalley@intel.com are

mm-add-support-for-__gfp_zero-flag-to-dma_pool_alloc.patch
mm-add-dma_pool_zalloc-call-to-dma-api.patch
pci-mm-add-pci_pool_zalloc-call.patch
coccinelle-mm-scripts-coccinelle-api-alloc-pool_zalloc-simplecocci.patch

