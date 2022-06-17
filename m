Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AF12CCA47A
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 02:49:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379809AbiFQCtp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jun 2022 22:49:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379800AbiFQCtk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2022 22:49:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D30665427
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 19:49:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25B16B826EF
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 02:49:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7040C34114;
        Fri, 17 Jun 2022 02:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655434172;
        bh=E3AbRU13RGF4X+ZpiS5AncM8SzRgaW0V2pPb3qneWi4=;
        h=Date:To:From:Subject:From;
        b=ERDLm39PFKCrKNm5+q66PSPIuOZjnv6WIWno2ml5JInyXHJTuCmiCvZZdLgR+FsfU
         v/q+4gdlQAyAiY177QkUo4QOimb427DQNGOT6s5E7SC9uykHHIa2viAhQUsXdCSLOF
         +UkvT9b39RUfZtite4muxiJBitvGrPK0+CTGNPho=
Date:   Thu, 16 Jun 2022 19:49:32 -0700
To:     mm-commits@vger.kernel.org, yee.lee@mediatek.com,
        catalin.marinas@arm.com, patrick.wang.shcn@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kmemleak-remove-kmemleak_not_leak_phys-and-the-min_count-argument-to-kmemleak_alloc_phys.patch removed from -mm tree
Message-Id: <20220617024932.D7040C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: kmemleak: remove kmemleak_not_leak_phys() and the min_count argument to kmemleak_alloc_phys()
has been removed from the -mm tree.  Its filename was
     mm-kmemleak-remove-kmemleak_not_leak_phys-and-the-min_count-argument-to-kmemleak_alloc_phys.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Patrick Wang <patrick.wang.shcn@gmail.com>
Subject: mm: kmemleak: remove kmemleak_not_leak_phys() and the min_count argument to kmemleak_alloc_phys()
Date: Sat, 11 Jun 2022 11:55:48 +0800

Patch series "mm: kmemleak: store objects allocated with physical address
separately and check when scan", v4.

The kmemleak_*_phys() interface uses "min_low_pfn" and "max_low_pfn" to
check address.  But on some architectures, kmemleak_*_phys() is called
before those two variables initialized.  The following steps will be
taken:

1) Add OBJECT_PHYS flag and rbtree for the objects allocated
   with physical address
2) Store physical address in objects if allocated with OBJECT_PHYS
3) Check the boundary when scan instead of in kmemleak_*_phys()

This patch set will solve:
https://lore.kernel.org/r/20220527032504.30341-1-yee.lee@mediatek.com
https://lore.kernel.org/r/9dd08bb5-f39e-53d8-f88d-bec598a08c93@gmail.com

v3: https://lore.kernel.org/r/20220609124950.1694394-1-patrick.wang.shcn@gmail.com
v2: https://lore.kernel.org/r/20220603035415.1243913-1-patrick.wang.shcn@gmail.com
v1: https://lore.kernel.org/r/20220531150823.1004101-1-patrick.wang.shcn@gmail.com


This patch (of 4):

Remove the unused kmemleak_not_leak_phys() function.  And remove the
min_count argument to kmemleak_alloc_phys() function, assume it's 0.

Link: https://lkml.kernel.org/r/20220611035551.1823303-1-patrick.wang.shcn@gmail.com
Link: https://lkml.kernel.org/r/20220611035551.1823303-2-patrick.wang.shcn@gmail.com
Signed-off-by: Patrick Wang <patrick.wang.shcn@gmail.com>
Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Yee Lee <yee.lee@mediatek.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kmemleak.rst    |    1 -
 drivers/of/fdt.c                        |    2 +-
 include/linux/kmemleak.h                |    8 ++------
 mm/kmemleak.c                           |   20 +++-----------------
 mm/memblock.c                           |   14 +++++++-------
 tools/testing/memblock/linux/kmemleak.h |    2 +-
 6 files changed, 14 insertions(+), 33 deletions(-)

--- a/Documentation/dev-tools/kmemleak.rst~mm-kmemleak-remove-kmemleak_not_leak_phys-and-the-min_count-argument-to-kmemleak_alloc_phys
+++ a/Documentation/dev-tools/kmemleak.rst
@@ -174,7 +174,6 @@ mapping:
 
 - ``kmemleak_alloc_phys``
 - ``kmemleak_free_part_phys``
-- ``kmemleak_not_leak_phys``
 - ``kmemleak_ignore_phys``
 
 Dealing with false positives/negatives
--- a/drivers/of/fdt.c~mm-kmemleak-remove-kmemleak_not_leak_phys-and-the-min_count-argument-to-kmemleak_alloc_phys
+++ a/drivers/of/fdt.c
@@ -529,7 +529,7 @@ static int __init __reserved_mem_reserve
 			pr_debug("Reserved memory: reserved region for node '%s': base %pa, size %lu MiB\n",
 				uname, &base, (unsigned long)(size / SZ_1M));
 			if (!nomap)
-				kmemleak_alloc_phys(base, size, 0, 0);
+				kmemleak_alloc_phys(base, size, 0);
 		}
 		else
 			pr_info("Reserved memory: failed to reserve memory for node '%s': base %pa, size %lu MiB\n",
--- a/include/linux/kmemleak.h~mm-kmemleak-remove-kmemleak_not_leak_phys-and-the-min_count-argument-to-kmemleak_alloc_phys
+++ a/include/linux/kmemleak.h
@@ -29,10 +29,9 @@ extern void kmemleak_not_leak(const void
 extern void kmemleak_ignore(const void *ptr) __ref;
 extern void kmemleak_scan_area(const void *ptr, size_t size, gfp_t gfp) __ref;
 extern void kmemleak_no_scan(const void *ptr) __ref;
-extern void kmemleak_alloc_phys(phys_addr_t phys, size_t size, int min_count,
+extern void kmemleak_alloc_phys(phys_addr_t phys, size_t size,
 				gfp_t gfp) __ref;
 extern void kmemleak_free_part_phys(phys_addr_t phys, size_t size) __ref;
-extern void kmemleak_not_leak_phys(phys_addr_t phys) __ref;
 extern void kmemleak_ignore_phys(phys_addr_t phys) __ref;
 
 static inline void kmemleak_alloc_recursive(const void *ptr, size_t size,
@@ -107,15 +106,12 @@ static inline void kmemleak_no_scan(cons
 {
 }
 static inline void kmemleak_alloc_phys(phys_addr_t phys, size_t size,
-				       int min_count, gfp_t gfp)
+				       gfp_t gfp)
 {
 }
 static inline void kmemleak_free_part_phys(phys_addr_t phys, size_t size)
 {
 }
-static inline void kmemleak_not_leak_phys(phys_addr_t phys)
-{
-}
 static inline void kmemleak_ignore_phys(phys_addr_t phys)
 {
 }
--- a/mm/kmemleak.c~mm-kmemleak-remove-kmemleak_not_leak_phys-and-the-min_count-argument-to-kmemleak_alloc_phys
+++ a/mm/kmemleak.c
@@ -1125,15 +1125,13 @@ EXPORT_SYMBOL(kmemleak_no_scan);
  *			 address argument
  * @phys:	physical address of the object
  * @size:	size of the object
- * @min_count:	minimum number of references to this object.
- *              See kmemleak_alloc()
  * @gfp:	kmalloc() flags used for kmemleak internal memory allocations
  */
-void __ref kmemleak_alloc_phys(phys_addr_t phys, size_t size, int min_count,
-			       gfp_t gfp)
+void __ref kmemleak_alloc_phys(phys_addr_t phys, size_t size, gfp_t gfp)
 {
 	if (PHYS_PFN(phys) >= min_low_pfn && PHYS_PFN(phys) < max_low_pfn)
-		kmemleak_alloc(__va(phys), size, min_count, gfp);
+		/* assume min_count 0 */
+		kmemleak_alloc(__va(phys), size, 0, gfp);
 }
 EXPORT_SYMBOL(kmemleak_alloc_phys);
 
@@ -1152,18 +1150,6 @@ void __ref kmemleak_free_part_phys(phys_
 EXPORT_SYMBOL(kmemleak_free_part_phys);
 
 /**
- * kmemleak_not_leak_phys - similar to kmemleak_not_leak but taking a physical
- *			    address argument
- * @phys:	physical address of the object
- */
-void __ref kmemleak_not_leak_phys(phys_addr_t phys)
-{
-	if (PHYS_PFN(phys) >= min_low_pfn && PHYS_PFN(phys) < max_low_pfn)
-		kmemleak_not_leak(__va(phys));
-}
-EXPORT_SYMBOL(kmemleak_not_leak_phys);
-
-/**
  * kmemleak_ignore_phys - similar to kmemleak_ignore but taking a physical
  *			  address argument
  * @phys:	physical address of the object
--- a/mm/memblock.c~mm-kmemleak-remove-kmemleak_not_leak_phys-and-the-min_count-argument-to-kmemleak_alloc_phys
+++ a/mm/memblock.c
@@ -1345,8 +1345,8 @@ __next_mem_pfn_range_in_zone(u64 *idx, s
  * from the regions with mirroring enabled and then retried from any
  * memory region.
  *
- * In addition, function sets the min_count to 0 using kmemleak_alloc_phys for
- * allocated boot memory block, so that it is never reported as leaks.
+ * In addition, function using kmemleak_alloc_phys for allocated boot
+ * memory block, it is never reported as leaks.
  *
  * Return:
  * Physical address of allocated memory block on success, %0 on failure.
@@ -1398,12 +1398,12 @@ done:
 	 */
 	if (end != MEMBLOCK_ALLOC_NOLEAKTRACE)
 		/*
-		 * The min_count is set to 0 so that memblock allocated
-		 * blocks are never reported as leaks. This is because many
-		 * of these blocks are only referred via the physical
-		 * address which is not looked up by kmemleak.
+		 * Memblock allocated blocks are never reported as
+		 * leaks. This is because many of these blocks are
+		 * only referred via the physical address which is
+		 * not looked up by kmemleak.
 		 */
-		kmemleak_alloc_phys(found, size, 0, 0);
+		kmemleak_alloc_phys(found, size, 0);
 
 	return found;
 }
--- a/tools/testing/memblock/linux/kmemleak.h~mm-kmemleak-remove-kmemleak_not_leak_phys-and-the-min_count-argument-to-kmemleak_alloc_phys
+++ a/tools/testing/memblock/linux/kmemleak.h
@@ -7,7 +7,7 @@ static inline void kmemleak_free_part_ph
 }
 
 static inline void kmemleak_alloc_phys(phys_addr_t phys, size_t size,
-				       int min_count, gfp_t gfp)
+				       gfp_t gfp)
 {
 }
 
_

Patches currently in -mm which might be from patrick.wang.shcn@gmail.com are


