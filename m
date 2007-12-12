From: akpm@linux-foundation.org
Subject: + arch-cris-added-a-missing-iounmap.patch added to -mm tree
Date: Wed, 12 Dec 2007 02:48:45 -0800
Message-ID: <200712121048.lBCAmjtt005992@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34480 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756250AbXLLKt2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Dec 2007 05:49:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, starvik@axis.com


The patch titled
     arch/cris: add a missing iounmap
has been added to the -mm tree.  Its filename is
     arch-cris-added-a-missing-iounmap.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: arch/cris: add a missing iounmap
From: Julia Lawall <julia@diku.dk>

An extra error handling label is needed for the case where the ioremap has
succeeded.

The problem was detected using the following semantic match
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
type T,T1,T2;
identifier E;
statement S;
expression x1,x2;
constant C;
int ret;
@@

  T E;
  ...
* E = ioremap(...);
  if (E == NULL) S
  ... when != iounmap(E)
      when != if (E != NULL) { ... iounmap(E); ...}
      when != x1 = (T1)E
  if (...) {
    ... when != iounmap(E)
        when != if (E != NULL) { ... iounmap(E); ...}
        when != x2 = (T2)E
(
*   return;
|
*   return C;
|
*   return ret;
)
  }
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Mikael Starvik <starvik@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/arch-v32/drivers/pci/dma.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN arch/cris/arch-v32/drivers/pci/dma.c~arch-cris-added-a-missing-iounmap arch/cris/arch-v32/drivers/pci/dma.c
--- a/arch/cris/arch-v32/drivers/pci/dma.c~arch-cris-added-a-missing-iounmap
+++ a/arch/cris/arch-v32/drivers/pci/dma.c
@@ -93,7 +93,7 @@ int dma_declare_coherent_memory(struct d
 
 	dev->dma_mem = kzalloc(sizeof(struct dma_coherent_mem), GFP_KERNEL);
 	if (!dev->dma_mem)
-		goto out;
+		goto iounmap_out;
 	dev->dma_mem->bitmap = kzalloc(bitmap_size, GFP_KERNEL);
 	if (!dev->dma_mem->bitmap)
 		goto free1_out;
@@ -110,6 +110,8 @@ int dma_declare_coherent_memory(struct d
 
  free1_out:
 	kfree(dev->dma_mem);
+ iounmap_out:
+	iounmap(mem_base);
  out:
 	return 0;
 }
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
git-alsa.patch
drivers-char-remove-unnecessary-pci_dev_put.patch
arch-ppc-remove-an-unnecessary-pci_dev_put.patch
arch-powerpc-add-missing-of_node_put.patch
arch-powerpc-platforms-cell-cbe_regsc-add-missing-of_node_put.patch
git-input.patch
arch-cris-added-a-missing-iounmap.patch
drivers-video-remove-unnecessary-pci_dev_put.patch
