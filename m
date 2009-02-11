From: akpm@linux-foundation.org
Subject: [merged] arch-powerpc-eliminate-double-sizeof.patch removed from -mm tree
Date: Wed, 11 Feb 2009 11:22:00 -0800
Message-ID: <200902111922.n1BJM0Au018960@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45626 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755016AbZBKTWi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Feb 2009 14:22:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, benh@kernel.crashing.org, scottwood@freescale.com, mm-commits@vger.kernel.org


The patch titled
     arch/powerpc: eliminate double sizeof
has been removed from the -mm tree.  Its filename was
     arch-powerpc-eliminate-double-sizeof.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arch/powerpc: eliminate double sizeof
From: Julia Lawall <julia@diku.dk>

Taking sizeof the result of sizeof is quite strange and does not seem to be
what is wanted here.

This was fixed using the following semantic patch.
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
expression E;
@@

- sizeof (
  sizeof (E)
- )

@@
type T;
@@

- sizeof (
  sizeof (T)
- )
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Acked-by: Scott Wood <scottwood@freescale.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/82xx/pq2ads-pci-pic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/powerpc/platforms/82xx/pq2ads-pci-pic.c~arch-powerpc-eliminate-double-sizeof arch/powerpc/platforms/82xx/pq2ads-pci-pic.c
--- a/arch/powerpc/platforms/82xx/pq2ads-pci-pic.c~arch-powerpc-eliminate-double-sizeof
+++ a/arch/powerpc/platforms/82xx/pq2ads-pci-pic.c
@@ -186,7 +186,7 @@ out_unmap_regs:
 	iounmap(priv->regs);
 out_free_bootmem:
 	free_bootmem((unsigned long)priv,
-	             sizeof(sizeof(struct pq2ads_pci_pic)));
+	             sizeof(struct pq2ads_pci_pic));
 	of_node_put(np);
 out_unmap_irq:
 	irq_dispose_mapping(irq);
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
linux-next.patch
arch-powerpc-eliminate-double-sizeof-checkpatch-fixes.patch
drivers-scsi-correct-use-of-and.patch

