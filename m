From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-memblock-add-memblock-memory-allocation-apis-fix-4.patch removed from
 -mm tree
Date: Tue, 21 Jan 2014 15:33:47 -0800
Message-ID: <52df03db.qEXZwz24uV9AWvNT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45629 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbaAUXds (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jan 2014 18:33:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sfr@canb.auug.org.au, santosh.shilimkar@ti.com, rmk+kernel@arm.linux.org.uk

Subject: [folded-merged] mm-memblock-add-memblock-memory-allocation-apis-fix-4.patch removed from -mm tree
To: rmk+kernel@arm.linux.org.uk,santosh.shilimkar@ti.com,sfr@canb.auug.org.au,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 21 Jan 2014 15:33:47 -0800


The patch titled
     Subject: ARM: mm: change further appearance of arm_dma_zone_size to phys_addr_t
has been removed from the -mm tree.  Its filename was
     mm-memblock-add-memblock-memory-allocation-apis-fix-4.patch

This patch was dropped because it was folded into mm-memblock-add-memblock-memory-allocation-apis.patch

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
dma-debug-introduce-debug_dma_assert_idle.patch
mm-memblock-add-memblock-memory-allocation-apis.patch

