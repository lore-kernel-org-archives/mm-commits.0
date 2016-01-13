From: akpm@linux-foundation.org
Subject: [merged]
 x86-mm-introduce-vmem_altmap-to-augment-vmemmap_populate-fix.patch removed
 from -mm tree
Date: Wed, 13 Jan 2016 14:50:02 -0800
Message-ID: <5696d49a.SmYCZ/Fzh/KxbD/+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55548 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754373AbcAMWuD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jan 2016 17:50:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sudipm.mukherjee@gmail.com, dan.j.williams@intel.com, geert@linux-m68k.org, linux@roeck-us.net, sudip@vectorindia.org, mm-commits@vger.kernel.org


The patch titled
     Subject: m68k: provide __phys_to_pfn() and __pfn_to_phys()
has been removed from the -mm tree.  Its filename was
     x86-mm-introduce-vmem_altmap-to-augment-vmemmap_populate-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: m68k: provide __phys_to_pfn() and __pfn_to_phys()

The defconfig build of m68k was failing with the error: implicit
declaration of function '__pfn_to_phys'

Other architectures have added <asm/memory.h>, but if we do so here then
we will also get redeclaration of some other functions.  So it is better
to copy these macros into page.h.

[geert: apply to page.h instead of page_mm.h to cover nommu, reword]
Fixes: 0a3c3bf11240 ("x86, mm: introduce vmem_altmap to augment vmemmap_populate()")
Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reported-by: Guenter Roeck <linux@roeck-us.net> (m68knommu)
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/include/asm/page.h |    3 +++
 1 file changed, 3 insertions(+)

diff -puN arch/m68k/include/asm/page.h~x86-mm-introduce-vmem_altmap-to-augment-vmemmap_populate-fix arch/m68k/include/asm/page.h
--- a/arch/m68k/include/asm/page.h~x86-mm-introduce-vmem_altmap-to-augment-vmemmap_populate-fix
+++ a/arch/m68k/include/asm/page.h
@@ -48,6 +48,9 @@ extern unsigned long _ramend;
 #include <asm/page_no.h>
 #endif
 
+#define __phys_to_pfn(paddr)	((unsigned long)((paddr) >> PAGE_SHIFT))
+#define __pfn_to_phys(pfn)	PFN_PHYS(pfn)
+
 #define VM_DATA_DEFAULT_FLAGS	(VM_READ | VM_WRITE | VM_EXEC | \
 				 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
 
_

Patches currently in -mm which might be from sudipm.mukherjee@gmail.com are

m32r-fix-m32104ut_defconfig-build-fail.patch
arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix-fix-2-fix-4.patch

