From: akpm@linux-foundation.org
Subject: [merged] x86-revert-wrong-memblock-current-limit-setting.patch
 removed from -mm tree
Date: Tue, 28 Jan 2014 11:09:03 -0800
Message-ID: <52e8004f.UjU85SvfmbmZGO1j%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45453 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754779AbaA1TJE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Jan 2014 14:09:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, santosh.shilimkar@ti.com, mingo@elte.hu, linux@arm.linux.org.uk, konrad.wilk@oracle.com, hpa@zytor.com, dave.hansen@intel.com, yinghai@kernel.org

Subject: [merged] x86-revert-wrong-memblock-current-limit-setting.patch removed from -mm tree
To: yinghai@kernel.org,dave.hansen@intel.com,hpa@zytor.com,konrad.wilk@oracle.com,linux@arm.linux.org.uk,mingo@elte.hu,santosh.shilimkar@ti.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 28 Jan 2014 11:09:03 -0800


The patch titled
     Subject: x86: revert wrong memblock current limit setting
has been removed from the -mm tree.  Its filename was
     x86-revert-wrong-memblock-current-limit-setting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yinghai Lu <yinghai@kernel.org>
Subject: x86: revert wrong memblock current limit setting

Dave reported big numa system booting is broken.

It turns out
| commit 5b6e529521d35e1bcaa0fe43456d1bbb335cae5d
| Author: Santosh Shilimkar <santosh.shilimkar@ti.com>
| Date:   Tue Jan 21 15:50:03 2014 -0800
|
|    x86: memblock: set current limit to max low memory address

set limit to low wrongly.

max_low_pfn_mapped is different from max_pfn_mapped.
max_low_pfn_mapped is always under 4G.

That will memblock_alloc_nid all go under 4G.

Revert 5b6e529521d35e1bca to fix a no-boot regression which was triggered
by 457ff1de2d247d ("lib/swiotlb.c: use memblock apis for early memory
allocations").

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Reported-by: Dave Hansen <dave.hansen@intel.com>
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/page_types.h |    4 ++--
 arch/x86/kernel/setup.c           |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/x86/include/asm/page_types.h~x86-revert-wrong-memblock-current-limit-setting arch/x86/include/asm/page_types.h
--- a/arch/x86/include/asm/page_types.h~x86-revert-wrong-memblock-current-limit-setting
+++ a/arch/x86/include/asm/page_types.h
@@ -51,9 +51,9 @@ extern int devmem_is_allowed(unsigned lo
 extern unsigned long max_low_pfn_mapped;
 extern unsigned long max_pfn_mapped;
 
-static inline phys_addr_t get_max_low_mapped(void)
+static inline phys_addr_t get_max_mapped(void)
 {
-	return (phys_addr_t)max_low_pfn_mapped << PAGE_SHIFT;
+	return (phys_addr_t)max_pfn_mapped << PAGE_SHIFT;
 }
 
 bool pfn_range_is_mapped(unsigned long start_pfn, unsigned long end_pfn);
diff -puN arch/x86/kernel/setup.c~x86-revert-wrong-memblock-current-limit-setting arch/x86/kernel/setup.c
--- a/arch/x86/kernel/setup.c~x86-revert-wrong-memblock-current-limit-setting
+++ a/arch/x86/kernel/setup.c
@@ -1119,7 +1119,7 @@ void __init setup_arch(char **cmdline_p)
 
 	setup_real_mode();
 
-	memblock_set_current_limit(get_max_low_mapped());
+	memblock_set_current_limit(get_max_mapped());
 	dma_contiguous_reserve(0);
 
 	/*
_

Patches currently in -mm which might be from yinghai@kernel.org are

origin.patch
linux-next.patch

