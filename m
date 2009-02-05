From: akpm@linux-foundation.org
Subject: + arch-powerpc-eliminate-double-sizeof.patch added to -mm tree
Date: Thu, 05 Feb 2009 13:11:00 -0800
Message-ID: <200902052111.n15LB0qo006875@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53346 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751065AbZBEVLT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Feb 2009 16:11:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, benh@kernel.crashing.org, scottwood@freescale.com


The patch titled
     arch/powerpc: eliminate double sizeof
has been added to the -mm tree.  Its filename is
     arch-powerpc-eliminate-double-sizeof.patch

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

linux-next.patch
arch-powerpc-eliminate-double-sizeof.patch
drivers-scsi-correct-use-of-and.patch

