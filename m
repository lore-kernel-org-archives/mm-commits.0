Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34EF5C43334
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 01:12:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233011AbiGDBMT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 21:12:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233014AbiGDBLH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 21:11:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43BBA63B4
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 18:10:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CDA6E6129E
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 01:10:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31088C341C6;
        Mon,  4 Jul 2022 01:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656897044;
        bh=SBO31ZBzn+pGK+c2DXfJA18GMrga7AC39OY+BtSy4Jg=;
        h=Date:To:From:Subject:From;
        b=lGOwjbGcCxyXR8AbFeg4C5u1lztRtqvVit5Tu4xfFGrYWMtfmammO3gjqCPKhSv2T
         edNWycyfm/txylj7KtoS8u3IxeeMySWZEV0LULeCOVsmSZm9g0Skr2ZPblMoXrMOCx
         BWPiYb7oPv9GUL+Cdp2oEZz/rScStu+F9VyDIA3I=
Date:   Sun, 03 Jul 2022 18:10:43 -0700
To:     mm-commits@vger.kernel.org, paulmck@kernel.org, osalvador@suse.de,
        mike.kravetz@oracle.com, duanxiongchun@bytedance.com,
        david@redhat.com, corbet@lwn.net, songmuchun@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory_hotplug-enumerate-all-supported-section-flags.patch removed from -mm tree
Message-Id: <20220704011044.31088C341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: memory_hotplug: enumerate all supported section flags
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-enumerate-all-supported-section-flags.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: memory_hotplug: enumerate all supported section flags
Date: Fri, 17 Jun 2022 21:56:49 +0800

Patch series "make hugetlb_optimize_vmemmap compatible with
memmap_on_memory", v3.

This series makes hugetlb_optimize_vmemmap compatible with
memmap_on_memory.


This patch (of 2):

We are almost running out of section flags, only one bit is available in
the worst case (powerpc with 256k pages).  However, there are still some
free bits (in ->section_mem_map) on other architectures (e.g.  x86_64 has
10 bits available, arm64 has 8 bits available with worst case of 64K
pages).  We have hard coded those numbers in code, it is inconvenient to
use those bits on other architectures except powerpc.  So transfer those
section flags to enumeration to make it easy to add new section flags in
the future.  Also, move SECTION_TAINT_ZONE_DEVICE into the scope of
CONFIG_ZONE_DEVICE to save a bit on non-zone-device case.

[songmuchun@bytedance.com: replace enum with defines per David]
  Link: https://lkml.kernel.org/r/20220620110616.12056-2-songmuchun@bytedance.com
Link: https://lkml.kernel.org/r/20220617135650.74901-1-songmuchun@bytedance.com
Link: https://lkml.kernel.org/r/20220617135650.74901-2-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |   41 ++++++++++++++++++++++++++++++---------
 mm/memory_hotplug.c    |    6 +++++
 mm/sparse.c            |    2 -
 3 files changed, 39 insertions(+), 10 deletions(-)

--- a/include/linux/mmzone.h~mm-memory_hotplug-enumerate-all-supported-section-flags
+++ a/include/linux/mmzone.h
@@ -1418,16 +1418,32 @@ extern size_t mem_section_usage_size(voi
  *      (equal SECTION_SIZE_BITS - PAGE_SHIFT), and the
  *      worst combination is powerpc with 256k pages,
  *      which results in PFN_SECTION_SHIFT equal 6.
- * To sum it up, at least 6 bits are available.
+ * To sum it up, at least 6 bits are available on all architectures.
+ * However, we can exceed 6 bits on some other architectures except
+ * powerpc (e.g. 15 bits are available on x86_64, 13 bits are available
+ * with the worst case of 64K pages on arm64) if we make sure the
+ * exceeded bit is not applicable to powerpc.
  */
-#define SECTION_MARKED_PRESENT		(1UL<<0)
-#define SECTION_HAS_MEM_MAP		(1UL<<1)
-#define SECTION_IS_ONLINE		(1UL<<2)
-#define SECTION_IS_EARLY		(1UL<<3)
-#define SECTION_TAINT_ZONE_DEVICE	(1UL<<4)
-#define SECTION_MAP_LAST_BIT		(1UL<<5)
-#define SECTION_MAP_MASK		(~(SECTION_MAP_LAST_BIT-1))
-#define SECTION_NID_SHIFT		6
+enum {
+	SECTION_MARKED_PRESENT_BIT,
+	SECTION_HAS_MEM_MAP_BIT,
+	SECTION_IS_ONLINE_BIT,
+	SECTION_IS_EARLY_BIT,
+#ifdef CONFIG_ZONE_DEVICE
+	SECTION_TAINT_ZONE_DEVICE_BIT,
+#endif
+	SECTION_MAP_LAST_BIT,
+};
+
+#define SECTION_MARKED_PRESENT		BIT(SECTION_MARKED_PRESENT_BIT)
+#define SECTION_HAS_MEM_MAP		BIT(SECTION_HAS_MEM_MAP_BIT)
+#define SECTION_IS_ONLINE		BIT(SECTION_IS_ONLINE_BIT)
+#define SECTION_IS_EARLY		BIT(SECTION_IS_EARLY_BIT)
+#ifdef CONFIG_ZONE_DEVICE
+#define SECTION_TAINT_ZONE_DEVICE	BIT(SECTION_TAINT_ZONE_DEVICE_BIT)
+#endif
+#define SECTION_MAP_MASK		(~(BIT(SECTION_MAP_LAST_BIT) - 1))
+#define SECTION_NID_SHIFT		SECTION_MAP_LAST_BIT
 
 static inline struct page *__section_mem_map_addr(struct mem_section *section)
 {
@@ -1466,12 +1482,19 @@ static inline int online_section(struct
 	return (section && (section->section_mem_map & SECTION_IS_ONLINE));
 }
 
+#ifdef CONFIG_ZONE_DEVICE
 static inline int online_device_section(struct mem_section *section)
 {
 	unsigned long flags = SECTION_IS_ONLINE | SECTION_TAINT_ZONE_DEVICE;
 
 	return section && ((section->section_mem_map & flags) == flags);
 }
+#else
+static inline int online_device_section(struct mem_section *section)
+{
+	return 0;
+}
+#endif
 
 static inline int online_section_nr(unsigned long nr)
 {
--- a/mm/memory_hotplug.c~mm-memory_hotplug-enumerate-all-supported-section-flags
+++ a/mm/memory_hotplug.c
@@ -670,12 +670,18 @@ static void __meminit resize_pgdat_range
 
 }
 
+#ifdef CONFIG_ZONE_DEVICE
 static void section_taint_zone_device(unsigned long pfn)
 {
 	struct mem_section *ms = __pfn_to_section(pfn);
 
 	ms->section_mem_map |= SECTION_TAINT_ZONE_DEVICE;
 }
+#else
+static inline void section_taint_zone_device(unsigned long pfn)
+{
+}
+#endif
 
 /*
  * Associate the pfn range with the given zone, initializing the memmaps
--- a/mm/sparse.c~mm-memory_hotplug-enumerate-all-supported-section-flags
+++ a/mm/sparse.c
@@ -281,7 +281,7 @@ static unsigned long sparse_encode_mem_m
 {
 	unsigned long coded_mem_map =
 		(unsigned long)(mem_map - (section_nr_to_pfn(pnum)));
-	BUILD_BUG_ON(SECTION_MAP_LAST_BIT > (1UL<<PFN_SECTION_SHIFT));
+	BUILD_BUG_ON(SECTION_MAP_LAST_BIT > PFN_SECTION_SHIFT);
 	BUG_ON(coded_mem_map & ~SECTION_MAP_MASK);
 	return coded_mem_map;
 }
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-memory_hotplug-make-hugetlb_optimize_vmemmap-compatible-with-memmap_on_memory.patch
mm-hugetlb-remove-minimum_order-variable.patch
mm-hugetlb_vmemmap-delete-hugetlb_optimize_vmemmap_enabled.patch
mm-hugetlb_vmemmap-optimize-vmemmap_optimize_mode-handling.patch
mm-hugetlb_vmemmap-introduce-the-name-hvo.patch
mm-hugetlb_vmemmap-move-vmemmap-code-related-to-hugetlb-to-hugetlb_vmemmapc.patch
mm-hugetlb_vmemmap-replace-early_param-with-core_param.patch
mm-hugetlb_vmemmap-improve-hugetlb_vmemmap-code-readability.patch
mm-hugetlb_vmemmap-move-code-comments-to-vmemmap_deduprst.patch
mm-hugetlb_vmemmap-use-ptrs_per_pte-instead-of-pmd_size-page_size.patch
mm-memcontrol-remove-dead-code-and-comments.patch
mm-rename-unlock_page_lruvec_irq-_irqrestore-to-lruvec_unlock_irq-_irqrestore.patch
mm-memcontrol-prepare-objcg-api-for-non-kmem-usage.patch
mm-memcontrol-make-lruvec-lock-safe-when-lru-pages-are-reparented.patch
mm-vmscan-rework-move_pages_to_lru.patch
mm-thp-make-split-queue-lock-safe-when-lru-pages-are-reparented.patch
mm-memcontrol-make-all-the-callers-of-foliopage_memcg-safe.patch
mm-memcontrol-introduce-memcg_reparent_ops.patch
mm-memcontrol-use-obj_cgroup-apis-to-charge-the-lru-pages.patch
mm-lru-add-vm_warn_on_once_folio-to-lru-maintenance-function.patch

