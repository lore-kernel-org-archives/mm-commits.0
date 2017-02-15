From: akpm@linux-foundation.org
Subject: + mm-cleanups-for-printing-phys_addr_t-and-dma_addr_t.patch added to -mm tree
Date: Wed, 15 Feb 2017 13:26:46 -0800
Message-ID: <58a4c796.58AuRKxrILE/LWmK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46650 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752371AbdBOV0r (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Feb 2017 16:26:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: miles.chen@mediatek.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: cleanups for printing phys_addr_t and dma_addr_t
has been added to the -mm tree.  Its filename is
     mm-cleanups-for-printing-phys_addr_t-and-dma_addr_t.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-cleanups-for-printing-phys_addr_t-and-dma_addr_t.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-cleanups-for-printing-phys_addr_t-and-dma_addr_t.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Miles Chen <miles.chen@mediatek.com>
Subject: mm: cleanups for printing phys_addr_t and dma_addr_t

cleanup rest of dma_addr_t and phys_addr_t type casting in mm
use %pad for dma_addr_t
use %pa for phys_addr_t

Link: http://lkml.kernel.org/r/1486618489-13912-1-git-send-email-miles.chen@mediatek.com
Signed-off-by: Miles Chen <miles.chen@mediatek.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/dmapool.c |   16 ++++++++--------
 mm/vmalloc.c |    2 +-
 2 files changed, 9 insertions(+), 9 deletions(-)

diff -puN mm/dmapool.c~mm-cleanups-for-printing-phys_addr_t-and-dma_addr_t mm/dmapool.c
--- a/mm/dmapool.c~mm-cleanups-for-printing-phys_addr_t-and-dma_addr_t
+++ a/mm/dmapool.c
@@ -434,11 +434,11 @@ void dma_pool_free(struct dma_pool *pool
 		spin_unlock_irqrestore(&pool->lock, flags);
 		if (pool->dev)
 			dev_err(pool->dev,
-				"dma_pool_free %s, %p (bad vaddr)/%Lx\n",
-				pool->name, vaddr, (unsigned long long)dma);
+				"dma_pool_free %s, %p (bad vaddr)/%pad\n",
+				pool->name, vaddr, &dma);
 		else
-			pr_err("dma_pool_free %s, %p (bad vaddr)/%Lx\n",
-			       pool->name, vaddr, (unsigned long long)dma);
+			pr_err("dma_pool_free %s, %p (bad vaddr)/%pad\n",
+			       pool->name, vaddr, &dma);
 		return;
 	}
 	{
@@ -450,11 +450,11 @@ void dma_pool_free(struct dma_pool *pool
 			}
 			spin_unlock_irqrestore(&pool->lock, flags);
 			if (pool->dev)
-				dev_err(pool->dev, "dma_pool_free %s, dma %Lx already free\n",
-					pool->name, (unsigned long long)dma);
+				dev_err(pool->dev, "dma_pool_free %s, dma %pad already free\n",
+					pool->name, &dma);
 			else
-				pr_err("dma_pool_free %s, dma %Lx already free\n",
-				       pool->name, (unsigned long long)dma);
+				pr_err("dma_pool_free %s, dma %pad already free\n",
+				       pool->name, &dma);
 			return;
 		}
 	}
diff -puN mm/vmalloc.c~mm-cleanups-for-printing-phys_addr_t-and-dma_addr_t mm/vmalloc.c
--- a/mm/vmalloc.c~mm-cleanups-for-printing-phys_addr_t-and-dma_addr_t
+++ a/mm/vmalloc.c
@@ -2659,7 +2659,7 @@ static int s_show(struct seq_file *m, vo
 		seq_printf(m, " pages=%d", v->nr_pages);
 
 	if (v->phys_addr)
-		seq_printf(m, " phys=%llx", (unsigned long long)v->phys_addr);
+		seq_printf(m, " phys=%pa", &v->phys_addr);
 
 	if (v->flags & VM_IOREMAP)
 		seq_puts(m, " ioremap");
_

Patches currently in -mm which might be from miles.chen@mediatek.com are

dma-debug-add-comment-for-failed-to-check-map-error.patch
mm-memblockc-remove-unnecessary-log-and-clean-up.patch
mm-cleanups-for-printing-phys_addr_t-and-dma_addr_t.patch
checkpatch-update-logfunctions.patch

