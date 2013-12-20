From: akpm@linux-foundation.org
Subject: +
 mm-arm-fix-arms-__ffs-to-conform-to-avoid-warning-with-no_bootmem.patch
 added to -mm tree
Date: Fri, 20 Dec 2013 15:22:56 -0800
Message-ID: <52b4d150.SeyRXj5EZKRkC7xG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55325 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386Ab3LTXW5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Dec 2013 18:22:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rmk+kernel@arm.linux.org.uk, santosh.shilimkar@ti.com

Subject: + mm-arm-fix-arms-__ffs-to-conform-to-avoid-warning-with-no_bootmem.patch added to -mm tree
To: santosh.shilimkar@ti.com,rmk+kernel@arm.linux.org.uk
From: akpm@linux-foundation.org
Date: Fri, 20 Dec 2013 15:22:56 -0800


The patch titled
     Subject: mm/ARM: fix ARMs __ffs() to conform to avoid warning with NO_BOOTMEM
has been added to the -mm tree.  Its filename is
     mm-arm-fix-arms-__ffs-to-conform-to-avoid-warning-with-no_bootmem.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-arm-fix-arms-__ffs-to-conform-to-avoid-warning-with-no_bootmem.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-arm-fix-arms-__ffs-to-conform-to-avoid-warning-with-no_bootmem.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: mm/ARM: fix ARMs __ffs() to conform to avoid warning with NO_BOOTMEM

Building ARM with NO_BOOTMEM generates below warning.

mm/nobootmem.c: In function _____free_pages_memory___:
mm/nobootmem.c:88:11: warning: comparison of distinct pointer types lacks a cast

	order = min(MAX_ORDER - 1UL, __ffs(start));

ARM's __ffs() differs from other architectures in that it ends up being
an int, whereas almost everyone else is unsigned long.

So fix ARMs __ffs() to conform to other architectures.  Suggested by
Russell King.

Some more details in below thread -
	https://lkml.org/lkml/2013/12/9/807

Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/bitops.h |   23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff -puN arch/arm/include/asm/bitops.h~mm-arm-fix-arms-__ffs-to-conform-to-avoid-warning-with-no_bootmem arch/arm/include/asm/bitops.h
--- a/arch/arm/include/asm/bitops.h~mm-arm-fix-arms-__ffs-to-conform-to-avoid-warning-with-no_bootmem
+++ a/arch/arm/include/asm/bitops.h
@@ -270,10 +270,25 @@ static inline int fls(int x)
 	return ret;
 }
 
-#define __fls(x) (fls(x) - 1)
-#define ffs(x) ({ unsigned long __t = (x); fls(__t & -__t); })
-#define __ffs(x) (ffs(x) - 1)
-#define ffz(x) __ffs( ~(x) )
+static inline unsigned long __fls(unsigned long x)
+{
+	return fls(x) - 1;
+}
+
+static inline int ffs(int x)
+{
+	return fls(x & -x);
+}
+
+static inline unsigned long __ffs(unsigned long x)
+{
+	return ffs(x) - 1;
+}
+
+static inline unsigned long ffz(unsigned long x)
+{
+	return __ffs(~x);
+}
 
 #endif
 
_

Patches currently in -mm which might be from santosh.shilimkar@ti.com are

mm-memblock-debug-correct-displaying-of-upper-memory-boundary.patch
x86-memblock-set-current-limit-to-max-low-memory-address.patch
mm-memblock-debug-dont-free-reserved-array-if-arch_discard_memblock.patch
mm-bootmem-remove-duplicated-declaration-of-__free_pages_bootmem.patch
mm-memblock-remove-unnecessary-inclusions-of-bootmemh.patch
mm-memblock-drop-warn-and-use-smp_cache_bytes-as-a-default-alignment.patch
mm-memblock-reorder-parameters-of-memblock_find_in_range_node.patch
mm-memblock-switch-to-use-numa_no_node-instead-of-max_numnodes.patch
mm-memblock-add-memblock-memory-allocation-apis.patch
mm-memblock-add-memblock-memory-allocation-apis-fix.patch
mm-memblock-add-memblock-memory-allocation-apis-fix-2.patch
mm-init-use-memblock-apis-for-early-memory-allocations.patch
mm-printk-use-memblock-apis-for-early-memory-allocations.patch
mm-page_alloc-use-memblock-apis-for-early-memory-allocations.patch
mm-power-use-memblock-apis-for-early-memory-allocations.patch
lib-swiotlbc-use-memblock-apis-for-early-memory-allocations.patch
lib-cpumaskc-use-memblock-apis-for-early-memory-allocations.patch
mm-sparse-use-memblock-apis-for-early-memory-allocations.patch
mm-hugetlb-use-memblock-apis-for-early-memory-allocations.patch
mm-page_cgroup-use-memblock-apis-for-early-memory-allocations.patch
mm-percpu-use-memblock-apis-for-early-memory-allocations.patch
mm-memory_hotplug-use-memblock-apis-for-early-memory-allocations.patch
drivers-firmware-memmapc-use-memblock-apis-for-early-memory-allocations.patch
arch-arm-kernel-use-memblock-apis-for-early-memory-allocations.patch
arch-arm-mm-initc-use-memblock-apis-for-early-memory-allocations.patch
arch-arm-mach-omap2-omap_hwmodc-use-memblock-apis-for-early-memory-allocations.patch
mm-memblock-use-warn_once-when-max_numnodes-passed-as-input-parameter.patch
mm-arm-fix-arms-__ffs-to-conform-to-avoid-warning-with-no_bootmem.patch
linux-next.patch

