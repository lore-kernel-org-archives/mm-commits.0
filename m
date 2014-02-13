From: akpm@linux-foundation.org
Subject: [merged]
 arm-mm-fix-the-memblock-allocation-for-lpae-machines.patch removed from -mm tree
Date: Thu, 13 Feb 2014 13:00:06 -0800
Message-ID: <52fd3256.VxQ6oxcFtfVH7EYJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36004 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056AbaBMVAH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Feb 2014 16:00:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yinghai@kernel.org, linux@arm.linux.org.uk, grygorii.strashko@ti.com, santosh.shilimkar@ti.com

Subject: [merged] arm-mm-fix-the-memblock-allocation-for-lpae-machines.patch removed from -mm tree
To: santosh.shilimkar@ti.com,grygorii.strashko@ti.com,linux@arm.linux.org.uk,yinghai@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 13 Feb 2014 13:00:06 -0800


The patch titled
     Subject: ARM: mm: fix the memblock allocation for LPAE machines
has been removed from the -mm tree.  Its filename was
     arm-mm-fix-the-memblock-allocation-for-lpae-machines.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: ARM: mm: fix the memblock allocation for LPAE machines

Commit ad6492b8 added much needed memblock_virt_alloc_low() and further
commit 07bacb3 {memblock, bootmem: restore goal for alloc_low} fixed the
issue with low memory limit thansk to Yinghai.  But even after all these
fixes, there is still one case where the limit check done with
ARCH_LOW_ADDRESS_LIMIT for low memory fails.  Russell pointed out the
issue with 32 bit LPAE machines in https://lkml.org/lkml/2014/1/28/364

Since on some LPAE machines where memory start address is beyond 4GB, the
low memory marker in memblock will be set to default
ARCH_LOW_ADDRESS_LIMIT which is wrong.  We can fix this by letting
architectures set the ARCH_LOW_ADDRESS_LIMIT using another export similar
to memblock_set_current_limit() but am not sure whether its worth the
trouble.  Tell me if you think otherwise.

Rather am just trying to fix that one broken case using
memblock_virt_alloc() in setup code since the memblock.current_limit is
updated appropriately makes it work on all ARM 32 bit machines.

Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Strashko, Grygorii <grygorii.strashko@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/kernel/setup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/arm/kernel/setup.c~arm-mm-fix-the-memblock-allocation-for-lpae-machines arch/arm/kernel/setup.c
--- a/arch/arm/kernel/setup.c~arm-mm-fix-the-memblock-allocation-for-lpae-machines
+++ a/arch/arm/kernel/setup.c
@@ -731,7 +731,7 @@ static void __init request_standard_reso
 	kernel_data.end     = virt_to_phys(_end - 1);
 
 	for_each_memblock(memory, region) {
-		res = memblock_virt_alloc_low(sizeof(*res), 0);
+		res = memblock_virt_alloc(sizeof(*res), 0);
 		res->name  = "System RAM";
 		res->start = __pfn_to_phys(memblock_region_memory_base_pfn(region));
 		res->end = __pfn_to_phys(memblock_region_memory_end_pfn(region)) - 1;
_

Patches currently in -mm which might be from santosh.shilimkar@ti.com are

linux-next.patch

