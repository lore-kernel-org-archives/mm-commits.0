From: akpm@linux-foundation.org
Subject: + mm-memblock-add-memblock-memory-allocation-apis-fix-4.patch
 added to -mm tree
Date: Mon, 06 Jan 2014 14:19:35 -0800
Message-ID: <52cb2bf7.WfClNfOmlA1itNfc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47114 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755289AbaAFWTg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jan 2014 17:19:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sfr@canb.auug.org.au, santosh.shilimkar@ti.com, rmk+kernel@arm.linux.org.uk

Subject: + mm-memblock-add-memblock-memory-allocation-apis-fix-4.patch added to -mm tree
To: rmk+kernel@arm.linux.org.uk,santosh.shilimkar@ti.com,sfr@canb.auug.org.au
From: akpm@linux-foundation.org
Date: Mon, 06 Jan 2014 14:19:35 -0800


The patch titled
     Subject: ARM: mm: change further appearance of arm_dma_zone_size to phys_addr_t
has been added to the -mm tree.  Its filename is
     mm-memblock-add-memblock-memory-allocation-apis-fix-4.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memblock-add-memblock-memory-allocation-apis-fix-4.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memblock-add-memblock-memory-allocation-apis-fix-4.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: ARM: mm: change further appearance of arm_dma_zone_size to phys_addr_t

The definition was chagned in commit 364230b995214 ("ARM: use phys_addr_t
for DMA zone sizes").

Fixes this build error:

arch/arm/mm/init.c:199:13: error: conflicting types for 'arm_dma_zone_size'
include/linux/bootmem.h:259:11: note: previous declaration of 'arm_dma_zone_size' was here

While changing the type, we also need to limit MAX_DMA_ADDRESS if
PAGE_OFFSET + arm_dma_zone_size is greater than 4GB.  The MAX_DMA_ADDRESS
is a virtual address and we really don't want the 32-bit value of this
wrapping.

Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/dma.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/arm/include/asm/dma.h~mm-memblock-add-memblock-memory-allocation-apis-fix-4 arch/arm/include/asm/dma.h
--- a/arch/arm/include/asm/dma.h~mm-memblock-add-memblock-memory-allocation-apis-fix-4
+++ a/arch/arm/include/asm/dma.h
@@ -8,8 +8,8 @@
 #define MAX_DMA_ADDRESS	0xffffffffUL
 #else
 #define MAX_DMA_ADDRESS	({ \
-	extern unsigned long arm_dma_zone_size; \
-	arm_dma_zone_size ? \
+	extern phys_addr_t arm_dma_zone_size; \
+	arm_dma_zone_size && arm_dma_zone_size < (0x10000000 - PAGE_OFFSET) ? \
 		(PAGE_OFFSET + arm_dma_zone_size) : 0xffffffffUL; })
 #endif
 
_

Patches currently in -mm which might be from rmk+kernel@arm.linux.org.uk are

origin.patch
mm-memblock-add-memblock-memory-allocation-apis-fix-4.patch
mm-arm-fix-arms-__ffs-to-conform-to-avoid-warning-with-no_bootmem.patch
linux-next.patch

