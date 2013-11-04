From: akpm@linux-foundation.org
Subject: +
 arch-arm-mach-davinci-sramc-use-gen_pool_dma_alloc-to-sramc.patch added to
 -mm tree
Date: Mon, 04 Nov 2013 14:17:10 -0800
Message-ID: <52781ce6.B0URp9YIkqUuU85L%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48772 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631Ab3KDWRL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Nov 2013 17:17:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, nsekhar@ti.com, linux@arm.linux.org.uk, khilman@deeprootsystems.com, b42378@freescale.com

Subject: + arch-arm-mach-davinci-sramc-use-gen_pool_dma_alloc-to-sramc.patch added to -mm tree
To: b42378@freescale.com,khilman@deeprootsystems.com,linux@arm.linux.org.uk,nsekhar@ti.com
From: akpm@linux-foundation.org
Date: Mon, 04 Nov 2013 14:17:10 -0800


The patch titled
     Subject: arch/arm/mach-davinci/sram.c: use gen_pool_dma_alloc() to sram.c
has been added to the -mm tree.  Its filename is
     arch-arm-mach-davinci-sramc-use-gen_pool_dma_alloc-to-sramc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arch-arm-mach-davinci-sramc-use-gen_pool_dma_alloc-to-sramc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arch-arm-mach-davinci-sramc-use-gen_pool_dma_alloc-to-sramc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nicolin Chen <b42378@freescale.com>
Subject: arch/arm/mach-davinci/sram.c: use gen_pool_dma_alloc() to sram.c

Since gen_pool_dma_alloc() is introduced, we implement it to simplify code.

Signed-off-by: Nicolin Chen <b42378@freescale.com>
Cc: Sekhar Nori <nsekhar@ti.com>
Cc: Kevin Hilman <khilman@deeprootsystems.com>
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-davinci/sram.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff -puN arch/arm/mach-davinci/sram.c~arch-arm-mach-davinci-sramc-use-gen_pool_dma_alloc-to-sramc arch/arm/mach-davinci/sram.c
--- a/arch/arm/mach-davinci/sram.c~arch-arm-mach-davinci-sramc-use-gen_pool_dma_alloc-to-sramc
+++ a/arch/arm/mach-davinci/sram.c
@@ -25,7 +25,6 @@ struct gen_pool *sram_get_gen_pool(void)
 
 void *sram_alloc(size_t len, dma_addr_t *dma)
 {
-	unsigned long vaddr;
 	dma_addr_t dma_base = davinci_soc_info.sram_dma;
 
 	if (dma)
@@ -33,13 +32,7 @@ void *sram_alloc(size_t len, dma_addr_t
 	if (!sram_pool || (dma && !dma_base))
 		return NULL;
 
-	vaddr = gen_pool_alloc(sram_pool, len);
-	if (!vaddr)
-		return NULL;
