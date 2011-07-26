From: akpm@linux-foundation.org
Subject: [merged] devres-fix-possible-use-after-free.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:55:01 -0700
Message-ID: <201107260754.p6Q7s4Ph003313@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51365 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752838Ab1GZHzA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:55:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: maxin.john@gmail.com, eike-kernel@sf-tec.de, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     devres: fix possible use after free
has been removed from the -mm tree.  Its filename was
     devres-fix-possible-use-after-free.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: devres: fix possible use after free
From: Maxin B John <maxin.john@gmail.com>

devres uses the pointer value as key after it's freed, which is safe but
triggers spurious use-after-free warnings on some static analysis tools. 
Rearrange code to avoid such warnings.

Signed-off-by: Maxin B. John <maxin.john@gmail.com>
Reviewed-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/irq/devres.c |    2 +-
 lib/devres.c        |    2 +-
 mm/dmapool.c        |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -puN kernel/irq/devres.c~devres-fix-possible-use-after-free kernel/irq/devres.c
--- a/kernel/irq/devres.c~devres-fix-possible-use-after-free
+++ a/kernel/irq/devres.c
@@ -87,8 +87,8 @@ void devm_free_irq(struct device *dev, u
 {
 	struct irq_devres match_data = { irq, dev_id };
 
-	free_irq(irq, dev_id);
 	WARN_ON(devres_destroy(dev, devm_irq_release, devm_irq_match,
 			       &match_data));
+	free_irq(irq, dev_id);
 }
 EXPORT_SYMBOL(devm_free_irq);
diff -puN lib/devres.c~devres-fix-possible-use-after-free lib/devres.c
--- a/lib/devres.c~devres-fix-possible-use-after-free
+++ a/lib/devres.c
@@ -79,9 +79,9 @@ EXPORT_SYMBOL(devm_ioremap_nocache);
  */
 void devm_iounmap(struct device *dev, void __iomem *addr)
 {
-	iounmap(addr);
 	WARN_ON(devres_destroy(dev, devm_ioremap_release, devm_ioremap_match,
 			       (void *)addr));
+	iounmap(addr);
 }
 EXPORT_SYMBOL(devm_iounmap);
 
diff -puN mm/dmapool.c~devres-fix-possible-use-after-free mm/dmapool.c
--- a/mm/dmapool.c~devres-fix-possible-use-after-free
+++ a/mm/dmapool.c
@@ -500,7 +500,7 @@ void dmam_pool_destroy(struct dma_pool *
 {
 	struct device *dev = pool->dev;
 
-	dma_pool_destroy(pool);
 	WARN_ON(devres_destroy(dev, dmam_pool_release, dmam_pool_match, pool));
+	dma_pool_destroy(pool);
 }
 EXPORT_SYMBOL(dmam_pool_destroy);
_

Patches currently in -mm which might be from maxin.john@gmail.com are

origin.patch
linux-next.patch

