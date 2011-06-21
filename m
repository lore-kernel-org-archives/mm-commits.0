From: akpm@linux-foundation.org
Subject: + devres-fix-possible-use-after-free.patch added to -mm tree
Date: Tue, 21 Jun 2011 15:14:49 -0700
Message-ID: <201106212214.p5LMEnM3027731@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58101 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753187Ab1FUWO6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Jun 2011 18:14:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: maxin.john@gmail.com, eike-kernel@sf-tec.de, tj@kernel.org


The patch titled
     devres: fix possible use after free
has been added to the -mm tree.  Its filename is
     devres-fix-possible-use-after-free.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
devres-fix-possible-use-after-free.patch

