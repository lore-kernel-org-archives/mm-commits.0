From: akpm@linux-foundation.org
Subject: [wrecked] arch-arm-plat-omap-iovmmc-fix-end-address-of-vm-area-comparation-in-alloc_iovm_area.patch removed from -mm tree
Date: Mon, 20 Dec 2010 18:33:35 -0800
Message-ID: <201012210236.oBL2axPd014221@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44040 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933446Ab0LUChS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Dec 2010 21:37:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: x0095840@ti.com, Hiroshi.DOYU@nokia.com, linux@arm.linux.org.uk, stable@kernel.org, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     arch/arm/plat-omap/iovmm.c: fix end address of vm area comparation in alloc_iovm_area
has been removed from the -mm tree.  Its filename was
     arch-arm-plat-omap-iovmmc-fix-end-address-of-vm-area-comparation-in-alloc_iovm_area.patch

This patch was dropped because other changes were merged, which wrecked this patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arch/arm/plat-omap/iovmm.c: fix end address of vm area comparation in alloc_iovm_area
From: Fernando Guzman Lugo <x0095840@ti.com>

End address of the vm area is .start + bytes -1., not start + byte.  This
patch fixes that issue by doing an inclusive comparison with
tmp->da_start.  This issue was preventing allocate an area of size exactly
the same than the free area.  I did no change the value of da_end of each
vm area because it is used to get area size in several places.

Signed-off-by: Fernando Guzman Lugo <x0095840@ti.com>
Acked-by: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/plat-omap/iovmm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/arm/plat-omap/iovmm.c~arch-arm-plat-omap-iovmmc-fix-end-address-of-vm-area-comparation-in-alloc_iovm_area arch/arm/plat-omap/iovmm.c
--- a/arch/arm/plat-omap/iovmm.c~arch-arm-plat-omap-iovmmc-fix-end-address-of-vm-area-comparation-in-alloc_iovm_area
+++ a/arch/arm/plat-omap/iovmm.c
@@ -292,7 +292,7 @@ static struct iovm_struct *alloc_iovm_ar
 		if (prev_end >= start)
 			break;
 
-		if (start + bytes < tmp->da_start)
+		if (start + bytes <= tmp->da_start)
 			goto found;
 
 		if (flags & IOVMF_DA_ANON)
_

Patches currently in -mm which might be from x0095840@ti.com are

linux-next.patch

