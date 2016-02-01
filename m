From: akpm@linux-foundation.org
Subject: + m32r-mm-fix-build-warning.patch added to -mm tree
Date: Mon, 01 Feb 2016 15:41:44 -0800
Message-ID: <56afed38.AUbDu14Ggyz/WY5v%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52724 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbcBAXlp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Feb 2016 18:41:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sudipm.mukherjee@gmail.com, sudip@vectorindia.org, mm-commits@vger.kernel.org


The patch titled
     Subject: m32r: mm: fix build warning
has been added to the -mm tree.  Its filename is
     m32r-mm-fix-build-warning.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/m32r-mm-fix-build-warning.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/m32r-mm-fix-build-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: m32r: mm: fix build warning

While building we are getting warnings:
arch/m32r/mm/init.c:63:17: warning: unused variable 'low'
arch/m32r/mm/init.c:62:17: warning: unused variable 'max_dma'

max_dma and low are only used if CONFIG_MMU is defined. Lets declare the
variables inside the #ifdef.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m32r/mm/init.c |   25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff -puN arch/m32r/mm/init.c~m32r-mm-fix-build-warning arch/m32r/mm/init.c
--- a/arch/m32r/mm/init.c~m32r-mm-fix-build-warning
+++ a/arch/m32r/mm/init.c
@@ -59,21 +59,24 @@ void free_initrd_mem(unsigned long, unsi
 void __init zone_sizes_init(void)
 {
 	unsigned long  zones_size[MAX_NR_ZONES] = {0, };
-	unsigned long  max_dma;
-	unsigned long  low;
 	unsigned long  start_pfn;
 
 #ifdef CONFIG_MMU
-	start_pfn = START_PFN(0);
-	max_dma = virt_to_phys((char *)MAX_DMA_ADDRESS) >> PAGE_SHIFT;
-	low = MAX_LOW_PFN(0);
+	{
+		unsigned long  low;
+		unsigned long  max_dma;
 
-	if (low < max_dma){
-		zones_size[ZONE_DMA] = low - start_pfn;
-		zones_size[ZONE_NORMAL] = 0;
-	} else {
-		zones_size[ZONE_DMA] = low - start_pfn;
-		zones_size[ZONE_NORMAL] = low - max_dma;
+		start_pfn = START_PFN(0);
+		max_dma = virt_to_phys((char *)MAX_DMA_ADDRESS) >> PAGE_SHIFT;
+		low = MAX_LOW_PFN(0);
+
+		if (low < max_dma) {
+			zones_size[ZONE_DMA] = low - start_pfn;
+			zones_size[ZONE_NORMAL] = 0;
+		} else {
+			zones_size[ZONE_DMA] = low - start_pfn;
+			zones_size[ZONE_NORMAL] = low - max_dma;
+		}
 	}
 #else
 	zones_size[ZONE_DMA] = 0 >> PAGE_SHIFT;
_

Patches currently in -mm which might be from sudipm.mukherjee@gmail.com are

proc-fix-missing-reference-of-mm.patch
m32r-mm-fix-build-warning.patch

