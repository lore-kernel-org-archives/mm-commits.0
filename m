Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F0ADC04FDF
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:06:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237038AbjHKXGR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:06:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234142AbjHKXFO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:05:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77E3C3C1F
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:03:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E79367942
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:03:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60E9AC433C8;
        Fri, 11 Aug 2023 23:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794993;
        bh=FH6E3jn8UUeWDwtnACOHYzrGqtUkezVDogdTODvmyRY=;
        h=Date:To:From:Subject:From;
        b=mKPzZWksutm8TO/IsIazUUhoo+RG0VLvcVfYk8F1rpcLw78F2qjxzEu56XO6epv5Q
         7l0lNoYf/4gW+aVrYEC6swaKrN3HHmqtrsO4N8yhWft0uj9d15kDJpBLO3IcmAKEE6
         Gyz0ScAFaSONdAsF9cSze+fTmtABRJwTrCgkrJ6Q=
Date:   Fri, 11 Aug 2023 16:03:12 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org, osalvador@suse.de,
        npiggin@gmail.com, muchun.song@linux.dev, mpe@ellerman.id.au,
        mike.kravetz@oracle.com, joao.m.martins@oracle.com,
        dan.j.williams@intel.com, christophe.leroy@csgroup.eu,
        catalin.marinas@arm.com, aneesh.kumar@linux.ibm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmemmap-improve-vmemmap_can_optimize-and-allow-architectures-to-override.patch removed from -mm tree
Message-Id: <20230811230313.60E9AC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/vmemmap: improve vmemmap_can_optimize and allow architectures to override
has been removed from the -mm tree.  Its filename was
     mm-vmemmap-improve-vmemmap_can_optimize-and-allow-architectures-to-override.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: mm/vmemmap: improve vmemmap_can_optimize and allow architectures to override
Date: Tue, 25 Jul 2023 00:37:49 +0530

dax vmemmap optimization requires a minimum of 2 PAGE_SIZE area within
vmemmap such that tail page mapping can point to the second PAGE_SIZE
area.  Enforce that in vmemmap_can_optimize() function.

Architectures like powerpc also want to enable vmemmap optimization
conditionally (only with radix MMU translation).  Hence allow architecture
override.

Link: https://lkml.kernel.org/r/20230724190759.483013-4-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   27 +++++++++++++++++++++++----
 mm/mm_init.c       |    2 +-
 2 files changed, 24 insertions(+), 5 deletions(-)

--- a/include/linux/mm.h~mm-vmemmap-improve-vmemmap_can_optimize-and-allow-architectures-to-override
+++ a/include/linux/mm.h
@@ -3632,13 +3632,32 @@ void vmemmap_free(unsigned long start, u
 		struct vmem_altmap *altmap);
 #endif
 
+#define VMEMMAP_RESERVE_NR	2
 #ifdef CONFIG_ARCH_WANT_OPTIMIZE_VMEMMAP
-static inline bool vmemmap_can_optimize(struct vmem_altmap *altmap,
-					   struct dev_pagemap *pgmap)
+static inline bool __vmemmap_can_optimize(struct vmem_altmap *altmap,
+					  struct dev_pagemap *pgmap)
 {
-	return is_power_of_2(sizeof(struct page)) &&
-		pgmap && (pgmap_vmemmap_nr(pgmap) > 1) && !altmap;
+	unsigned long nr_pages;
+	unsigned long nr_vmemmap_pages;
+
+	if (!pgmap || !is_power_of_2(sizeof(struct page)))
+		return false;
+
+	nr_pages = pgmap_vmemmap_nr(pgmap);
+	nr_vmemmap_pages = ((nr_pages * sizeof(struct page)) >> PAGE_SHIFT);
+	/*
+	 * For vmemmap optimization with DAX we need minimum 2 vmemmap
+	 * pages. See layout diagram in Documentation/mm/vmemmap_dedup.rst
+	 */
+	return !altmap && (nr_vmemmap_pages > VMEMMAP_RESERVE_NR);
 }
+/*
+ * If we don't have an architecture override, use the generic rule
+ */
+#ifndef vmemmap_can_optimize
+#define vmemmap_can_optimize __vmemmap_can_optimize
+#endif
+
 #else
 static inline bool vmemmap_can_optimize(struct vmem_altmap *altmap,
 					   struct dev_pagemap *pgmap)
--- a/mm/mm_init.c~mm-vmemmap-improve-vmemmap_can_optimize-and-allow-architectures-to-override
+++ a/mm/mm_init.c
@@ -1020,7 +1020,7 @@ static inline unsigned long compound_nr_
 	if (!vmemmap_can_optimize(altmap, pgmap))
 		return pgmap_vmemmap_nr(pgmap);
 
-	return 2 * (PAGE_SIZE / sizeof(struct page));
+	return VMEMMAP_RESERVE_NR * (PAGE_SIZE / sizeof(struct page));
 }
 
 static void __ref memmap_init_compound(struct page *head,
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are

mm-memory_hotplug-simplify-arch_mhp_memmap_on_memory_enable-kconfig.patch
mm-memory_hotplug-allow-memmap-on-memory-hotplug-request-to-fallback.patch
mm-memory_hotplug-allow-architecture-to-override-memmap-on-memory-support-check.patch
mm-memory_hotplug-support-memmap_on_memory-when-memmap-is-not-aligned-to-pageblocks.patch
powerpc-book3s64-memhotplug-enable-memmap-on-memory-for-radix.patch
mm-memory_hotplug-embed-vmem_altmap-details-in-memory-block.patch

