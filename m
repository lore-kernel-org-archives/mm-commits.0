From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-cma-silence-warnings-due-to-max-usage-checkpatch-fixes.patch removed
 from -mm tree
Date: Fri, 27 May 2016 14:24:34 -0700
Message-ID: <5748bb12.RbVhQSSpx7g1PI86%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45038 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756647AbcE0VYf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2016 17:24:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-cma-silence-warnings-due-to-max-usage-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-cma-silence-warnings-due-to-max-usage-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-cma-silence-warnings-due-to-max-usage.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-cma-silence-warnings-due-to-max-usage-checkpatch-fixes

WARNING: line over 80 characters
#128: FILE: mm/cma.c:186:
+	alignment = PAGE_SIZE << max_t(unsigned long, MAX_ORDER - 1, pageblock_order);

WARNING: line over 80 characters
#137: FILE: mm/cma.c:270:
+		(phys_addr_t)PAGE_SIZE << max_t(unsigned long, MAX_ORDER - 1, pageblock_order));

total: 0 errors, 2 warnings, 16 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/mm-cma-silence-warnings-due-to-max-usage.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN mm/cma.c~mm-cma-silence-warnings-due-to-max-usage-checkpatch-fixes mm/cma.c
--- a/mm/cma.c~mm-cma-silence-warnings-due-to-max-usage-checkpatch-fixes
+++ a/mm/cma.c
@@ -183,7 +183,8 @@ int __init cma_init_reserved_mem(phys_ad
 		return -EINVAL;
 
 	/* ensure minimal alignment required by mm core */
-	alignment = PAGE_SIZE << max_t(unsigned long, MAX_ORDER - 1, pageblock_order);
+	alignment = PAGE_SIZE <<
+			max_t(unsigned long, MAX_ORDER - 1, pageblock_order);
 
 	/* alignment should be aligned with order_per_bit */
 	if (!IS_ALIGNED(alignment >> PAGE_SHIFT, 1 << order_per_bit))
@@ -266,8 +267,8 @@ int __init cma_declare_contiguous(phys_a
 	 * migratetype page by page allocator's buddy algorithm. In the case,
 	 * you couldn't get a contiguous memory, which is not what we want.
 	 */
-	alignment = max(alignment,
-		(phys_addr_t)PAGE_SIZE << max_t(unsigned long, MAX_ORDER - 1, pageblock_order));
+	alignment = max(alignment,  (phys_addr_t)PAGE_SIZE <<
+			  max_t(unsigned long, MAX_ORDER - 1, pageblock_order));
 	base = ALIGN(base, alignment);
 	size = ALIGN(size, alignment);
 	limit &= ~(alignment - 1);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-cma-silence-warnings-due-to-max-usage.patch
mm-fix-overflow-in-vm_map_ram-fix.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-thp-avoid-unnecessary-swapin-in-khugepaged-fix.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
fs-nfs-nfs4statec-work-around-gcc-44-union-initialization-bug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

