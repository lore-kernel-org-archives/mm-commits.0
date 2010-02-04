From: akpm@linux-foundation.org
Subject: + alpha-remove-dma_sync_single_range.patch added to -mm tree
Date: Thu, 04 Feb 2010 10:28:43 -0800
Message-ID: <201002041828.o14ISikZ014033@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53789 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757313Ab0BDS3S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Feb 2010 13:29:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, davem@davemloft.net, ink@jurassic.park.msu.ru, mattst88@gmail.com, rth@twiddle.net


The patch titled
     alpha: remove dma_sync_single_range
has been added to the -mm tree.  Its filename is
     alpha-remove-dma_sync_single_range.patch

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
Subject: alpha: remove dma_sync_single_range
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

dma_sync_single_for_cpu/for_device supports a partial sync so there is no
point to have dma_sync_single_range (also dma_sync_single was obsoleted
long ago, replaced with dma_sync_single_for_cpu/for_device).

There is no user of dma_sync_single_range() in mainline and only Alpha
architecture supports dma_sync_single_range().  So it's unlikely that
someone out of the tree uses it.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Acked-by: Matt Turner <mattst88@gmail.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/dma-mapping.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/alpha/include/asm/dma-mapping.h~alpha-remove-dma_sync_single_range arch/alpha/include/asm/dma-mapping.h
--- a/arch/alpha/include/asm/dma-mapping.h~alpha-remove-dma_sync_single_range
+++ a/arch/alpha/include/asm/dma-mapping.h
@@ -59,7 +59,6 @@ int dma_set_mask(struct device *dev, u64
 
 #define dma_sync_single_for_cpu(dev, addr, size, dir)	  ((void)0)
 #define dma_sync_single_for_device(dev, addr, size, dir)  ((void)0)
-#define dma_sync_single_range(dev, addr, off, size, dir)  ((void)0)
 #define dma_sync_sg_for_cpu(dev, sg, nents, dir)	  ((void)0)
 #define dma_sync_sg_for_device(dev, sg, nents, dir)	  ((void)0)
 #define dma_cache_sync(dev, va, size, dir)		  ((void)0)
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

origin.patch
linux-next.patch
x86-agp-fix-agp_amd64_init-module-initialization-regression.patch
scsi-add-__init-__exit-macros-to-ibmvstgtc.patch
frv-remove-pci_dma_sync_single-and-pci_dma_sync_sg.patch
documentation-dma-apitxt-remove-deprecated-function-descriptions.patch
dma-apitxt-add-dma_sync_single-sg-api-description.patch
dma-apitxt-remove-dma_sync_single_range-description.patch
alpha-remove-dma_sync_single_range.patch
um-remove-dma_sync_single_range.patch

