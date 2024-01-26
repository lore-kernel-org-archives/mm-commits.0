Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4DC1BE49
	for <mm-commits@vger.kernel.org>; Fri, 26 Jan 2024 05:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706247874; cv=none; b=jYMJI5pxa+POCS81OaQ0gAQEmydyYSeGapyJEqHo+ZSNI9OUOTedIfcJn/wQt/epGQVLdVF5iJrXZKuEk/Y+naVlAdgye0oAh0hIBwF20dV9OTqZsNkRqM/yIkZsKw+UCH69SqMBvR4kI/QTFc2huZ/DfAS+LiDWCyr5JgzNxYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706247874; c=relaxed/simple;
	bh=OP9kVfdgHIMj/OiPJr0LPMqQjq/7A5ZjFcsME8c+Y98=;
	h=Date:To:From:Subject:Message-Id; b=M4lgNrPYmh/zzy9iT8xq2TbwQ2wgfW8KwOocm7pvQdlX9RjJ4pqcA0+zuLzgnJs4ubKSghPhmh5coeSy8AiRni8KgWtg2HXH7qGCb2AUjuUbPAOaCaI2BI2AHS23UhUxf1d97GTD1zO5Rst2Xu3YbrwI+kHhxrUnY3gzBYFX5M0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Pzcnu6K6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Pzcnu6K6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76B32C433F1;
	Fri, 26 Jan 2024 05:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706247874;
	bh=OP9kVfdgHIMj/OiPJr0LPMqQjq/7A5ZjFcsME8c+Y98=;
	h=Date:To:From:Subject:From;
	b=Pzcnu6K6izjOsoTqc7tRJSHbZJ9ui8ahDxTlTOyYcTat2p6YwUKzrZ78b4KJKCstP
	 0ol+LV2NgxbTN/2bxO7FrAVoNyWlws+qdDl2GY614fvlmA7M1kN8DWraRvmANpxsb2
	 Kq/V+J+TlEjjdFsV9TIrdyNE0U+vxXsG3uyUye9M=
Date: Thu, 25 Jan 2024 21:44:30 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,ying.huang@intel.com,willy@infradead.org,vishal.moola@gmail.com,vbabka@suse.cz,shikemeng@huaweicloud.com,ryan.roberts@arm.com,mgorman@techsingularity.net,mcgrof@kernel.org,kirill.shutemov@linux.intel.com,hannes@cmpxchg.org,fengwei.yin@intel.com,david@redhat.com,baolin.wang@linux.alibaba.com,a.manzanares@samsung.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-enable-compacting-0-order-folios.patch added to mm-unstable branch
Message-Id: <20240126054433.76B32C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/compaction: enable compacting >0 order folios.
has been added to the -mm mm-unstable branch.  Its filename is
     mm-compaction-enable-compacting-0-order-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-enable-compacting-0-order-folios.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm/compaction: enable compacting >0 order folios.
Date: Mon, 22 Jan 2024 22:46:33 -0500

Patch series "Enable >0 order folio memory compaction", v2.

This patchset enables >0 order folio memory compaction, which is one of
the prerequisitions for large folio support[1].

I am aware that split free pages is necessary for folio migration in
compaction, since if >0 order free pages are never split and no order-0
free page is scanned, compaction will end prematurely due to migration
returns -ENOMEM.  Free page split becomes a must instead of an
optimization.

Some applications from vm-scalability show different performance trends on
default LRU and CONFIG_LRU_GEN from patch 1 (split folio during
compaction), to patch 2 (folio migration during compaction), to patch 3
(folio migration during compaction with free page split).  I am looking
into it.

lkp ncompare results (with >5% delta) for default LRU and CONFIG_LRU_GEN
are shown at the bottom (on a 8-CPU (Intel Xeon E5-2650 v4 @ 2.20GHz) 16G
VM).

Overview
========

To support >0 order folio compaction, the patchset changes how free pages
used for migration are kept during compaction.  Free pages used to be
split into order-0 pages that are post allocation processed (i.e.,
PageBuddy flag cleared, page order stored in page->private is zeroed, and
page reference is set to 1).  Now all free pages are kept in a MAX_ORDER+1
array of page lists based on their order without post allocation process. 
When migrate_pages() asks for a new page, one of the free pages, based on
the requested page order, is then processed and given out.


[1] https://lore.kernel.org/linux-mm/20230912162815.440749-1-zi.yan@sent.com/
[2] https://lore.kernel.org/linux-mm/20231113170157.280181-1-zi.yan@sent.com/

vm-scalability results on CONFIG_LRU_GEN
===

=========================================================================================
compiler/kconfig/rootfs/runtime/tbox_group/test/testcase:
  gcc-13/defconfig/debian/300s/qemu-vm/small-allocs/vm-scalability

commit: 
  6.7.0-rc4+
  6.7.0-rc4-split-folio-in-compaction+
  6.7.0-rc4-folio-migration-in-compaction+
  6.7.0-rc4-folio-migration-free-page-split+

      6.7.0-rc4+ 6.7.0-rc4-split-folio-in-co 6.7.0-rc4-folio-migration-i 6.7.0-rc4-folio-migration-f 
---------------- --------------------------- --------------------------- --------------------------- 
         %stddev     %change         %stddev     %change         %stddev     %change         %stddev
             \          |                \          |                \          |                \  
   2024326           +35.5%    2743772 ± 41%    +364.0%    9392198 ± 35%     +31.0%    2651634        vm-scalability.throughput

=========================================================================================
compiler/kconfig/rootfs/runtime/tbox_group/test/testcase:
  gcc-13/defconfig/debian/300s/qemu-vm/small-allocs-mt/vm-scalability

commit: 
  6.7.0-rc4+
  6.7.0-rc4-split-folio-in-compaction+
  6.7.0-rc4-folio-migration-in-compaction+
  6.7.0-rc4-folio-migration-free-page-split+

      6.7.0-rc4+ 6.7.0-rc4-split-folio-in-co 6.7.0-rc4-folio-migration-i 6.7.0-rc4-folio-migration-f 
---------------- --------------------------- --------------------------- --------------------------- 
         %stddev     %change         %stddev     %change         %stddev     %change         %stddev
             \          |                \          |                \          |                \  
   1450189            +0.9%    1463418           +30.4%    1891610 ± 22%      +0.3%    1454100        vm-scalability.throughput

=========================================================================================
compiler/kconfig/rootfs/runtime/tbox_group/test/testcase:
  gcc-13/defconfig/debian/300s/qemu-vm/mmap-xread-seq-mt/vm-scalability

commit: 
  6.7.0-rc4+
  6.7.0-rc4-split-folio-in-compaction+
  6.7.0-rc4-folio-migration-in-compaction+
  6.7.0-rc4-folio-migration-free-page-split+

      6.7.0-rc4+ 6.7.0-rc4-split-folio-in-co 6.7.0-rc4-folio-migration-i 6.7.0-rc4-folio-migration-f 
---------------- --------------------------- --------------------------- --------------------------- 
         %stddev     %change         %stddev     %change         %stddev     %change         %stddev
             \          |                \          |                \          |                \  
  14428848 ± 27%     -51.7%    6963308 ± 73%     +13.5%   16372621           +11.2%   16046511        vm-scalability.throughput

=========================================================================================
compiler/kconfig/rootfs/runtime/tbox_group/test/testcase:
  gcc-13/defconfig/debian/300s/qemu-vm/mmap-pread-seq/vm-scalability

commit: 
  6.7.0-rc4+
  6.7.0-rc4-split-folio-in-compaction+
  6.7.0-rc4-folio-migration-in-compaction+
  6.7.0-rc4-folio-migration-free-page-split+

      6.7.0-rc4+ 6.7.0-rc4-split-folio-in-co 6.7.0-rc4-folio-migration-i 6.7.0-rc4-folio-migration-f 
---------------- --------------------------- --------------------------- --------------------------- 
         %stddev     %change         %stddev     %change         %stddev     %change         %stddev
             \          |                \          |                \          |                \  
  13569502 ± 24%     -45.9%    7340064 ± 59%     +12.3%   15240531           +10.4%   14983705        vm-scalability.throughput

=========================================================================================
compiler/kconfig/rootfs/runtime/tbox_group/test/testcase:
  gcc-13/defconfig/debian/300s/qemu-vm/mmap-pread-seq-mt/vm-scalability

commit: 
  6.7.0-rc4+
  6.7.0-rc4-split-folio-in-compaction+
  6.7.0-rc4-folio-migration-in-compaction+
  6.7.0-rc4-folio-migration-free-page-split+

      6.7.0-rc4+ 6.7.0-rc4-split-folio-in-co 6.7.0-rc4-folio-migration-i 6.7.0-rc4-folio-migration-f 
---------------- --------------------------- --------------------------- --------------------------- 
         %stddev     %change         %stddev     %change         %stddev     %change         %stddev
             \          |                \          |                \          |                \  
  13305823 ± 24%     -45.1%    7299664 ± 56%     +12.5%   14974725           +10.4%   14695963        vm-scalability.throughput

=========================================================================================
compiler/kconfig/rootfs/runtime/tbox_group/test/testcase:
  gcc-13/defconfig/debian/300s/qemu-vm/lru-file-readtwice/vm-scalability

commit: 
  6.7.0-rc4+
  6.7.0-rc4-split-folio-in-compaction+
  6.7.0-rc4-folio-migration-in-compaction+
  6.7.0-rc4-folio-migration-free-page-split+

      6.7.0-rc4+ 6.7.0-rc4-split-folio-in-co 6.7.0-rc4-folio-migration-i 6.7.0-rc4-folio-migration-f 
---------------- --------------------------- --------------------------- --------------------------- 
         %stddev     %change         %stddev     %change         %stddev     %change         %stddev
             \          |                \          |                \          |                \  
  13244376 ± 28%     +54.2%   20425838 ± 23%      -4.4%   12660113 ±  3%      -9.0%   12045809 ±  3%  vm-scalability.throughput

=========================================================================================
compiler/kconfig/rootfs/runtime/tbox_group/test/testcase:
  gcc-13/defconfig/debian/300s/qemu-vm/lru-file-mmap-read/vm-scalability

commit: 
  6.7.0-rc4+
  6.7.0-rc4-split-folio-in-compaction+
  6.7.0-rc4-folio-migration-in-compaction+
  6.7.0-rc4-folio-migration-free-page-split+

      6.7.0-rc4+ 6.7.0-rc4-split-folio-in-co 6.7.0-rc4-folio-migration-i 6.7.0-rc4-folio-migration-f 
---------------- --------------------------- --------------------------- --------------------------- 
         %stddev     %change         %stddev     %change         %stddev     %change         %stddev
             \          |                \          |                \          |                \  
   7021425 ± 11%     -20.9%    5556751 ± 19%     +14.8%    8057811 ±  3%      +9.4%    7678613 ±  4%  vm-scalability.throughput

=========================================================================================
compiler/kconfig/rootfs/runtime/size/tbox_group/test/testcase:
  gcc-13/defconfig/debian/300s/256G/qemu-vm/msync/vm-scalability

commit: 
  6.7.0-rc4+
  6.7.0-rc4-split-folio-in-compaction+
  6.7.0-rc4-folio-migration-in-compaction+
  6.7.0-rc4-folio-migration-free-page-split+

      6.7.0-rc4+ 6.7.0-rc4-split-folio-in-co 6.7.0-rc4-folio-migration-i 6.7.0-rc4-folio-migration-f 
---------------- --------------------------- --------------------------- --------------------------- 
         %stddev     %change         %stddev     %change         %stddev     %change         %stddev
             \          |                \          |                \          |                \  
   1208994 ±137%    +263.5%    4394683 ± 49%     -49.4%     611204 ±  6%     -48.1%     627937 ± 13%  vm-scalability.throughput



vm-scalability results on default LRU (with -no-mglru suffix)
===

=========================================================================================
compiler/kconfig/rootfs/runtime/tbox_group/test/testcase:
  gcc-13/defconfig/debian/300s/qemu-vm/lru-file-readtwice/vm-scalability

commit: 
  6.7.0-rc4-no-mglru+
  6.7.0-rc4-split-folio-in-compaction-no-mglru+
  6.7.0-rc4-folio-migration-in-compaction-no-mglru+
  6.7.0-rc4-folio-migration-free-page-split-no-mglru+

6.7.0-rc4-no-mgl 6.7.0-rc4-split-folio-in-co 6.7.0-rc4-folio-migration-i 6.7.0-rc4-folio-migration-f 
---------------- --------------------------- --------------------------- --------------------------- 
         %stddev     %change         %stddev     %change         %stddev     %change         %stddev
             \          |                \          |                \          |                \  
   8412072 ±  3%     +32.1%   11114537 ± 41%      +3.5%    8703491 ±  3%      +1.5%    8536343 ±  3%  vm-scalability.throughput

=========================================================================================
compiler/kconfig/rootfs/runtime/tbox_group/test/testcase:
  gcc-13/defconfig/debian/300s/qemu-vm/lru-file-mmap-read/vm-scalability

commit: 
  6.7.0-rc4-no-mglru+
  6.7.0-rc4-split-folio-in-compaction-no-mglru+
  6.7.0-rc4-folio-migration-in-compaction-no-mglru+
  6.7.0-rc4-folio-migration-free-page-split-no-mglru+

6.7.0-rc4-no-mgl 6.7.0-rc4-split-folio-in-co 6.7.0-rc4-folio-migration-i 6.7.0-rc4-folio-migration-f 
---------------- --------------------------- --------------------------- --------------------------- 
         %stddev     %change         %stddev     %change         %stddev     %change         %stddev
             \          |                \          |                \          |                \  
   7095358           +10.8%    7863635 ± 16%      +5.5%    7484110            +1.5%    7200666 ±  4%  vm-scalability.throughput


This patch (of 3):

migrate_pages() supports >0 order folio migration and during compaction,
even if compaction_alloc() cannot provide >0 order free pages,
migrate_pages() can split the source page and try to migrate the base
pages from the split.  It can be a baseline and start point for adding
support for compacting >0 order folios.

Link: https://lkml.kernel.org/r/20240123034636.1095672-1-zi.yan@sent.com
Link: https://lkml.kernel.org/r/20240123034636.1095672-2-zi.yan@sent.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Suggested-by: Huang Ying <ying.huang@intel.com>
Cc: Adam Manzanares <a.manzanares@samsung.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   43 +++++++++++++++++++++++++++++++++++--------
 1 file changed, 35 insertions(+), 8 deletions(-)

--- a/mm/compaction.c~mm-compaction-enable-compacting-0-order-folios
+++ a/mm/compaction.c
@@ -816,6 +816,21 @@ static bool too_many_isolated(struct com
 	return too_many;
 }
 
+/*
+ * 1. if the page order is larger than or equal to target_order (i.e.,
+ * cc->order and when it is not -1 for global compaction), skip it since
+ * target_order already indicates no free page with larger than target_order
+ * exists and later migrating it will most likely fail;
+ *
+ * 2. compacting > pageblock_order pages does not improve memory fragmentation,
+ * skip them;
+ */
+static bool skip_isolation_on_order(int order, int target_order)
+{
+	return (target_order != -1 && order >= target_order) ||
+		order >= pageblock_order;
+}
+
 /**
  * isolate_migratepages_block() - isolate all migrate-able pages within
  *				  a single pageblock
@@ -1010,7 +1025,7 @@ isolate_migratepages_block(struct compac
 		/*
 		 * Regardless of being on LRU, compound pages such as THP and
 		 * hugetlbfs are not to be compacted unless we are attempting
-		 * an allocation much larger than the huge page size (eg CMA).
+		 * an allocation larger than the compound page size.
 		 * We can potentially save a lot of iterations if we skip them
 		 * at once. The check is racy, but we can consider only valid
 		 * values and the only danger is skipping too much.
@@ -1018,11 +1033,18 @@ isolate_migratepages_block(struct compac
 		if (PageCompound(page) && !cc->alloc_contig) {
 			const unsigned int order = compound_order(page);
 
-			if (likely(order <= MAX_PAGE_ORDER)) {
-				low_pfn += (1UL << order) - 1;
-				nr_scanned += (1UL << order) - 1;
+			/*
+			 * Skip based on page order and compaction target order
+			 * and skip hugetlbfs pages.
+			 */
+			if (skip_isolation_on_order(order, cc->order) ||
+			    PageHuge(page)) {
+				if (order <= MAX_PAGE_ORDER) {
+					low_pfn += (1UL << order) - 1;
+					nr_scanned += (1UL << order) - 1;
+				}
+				goto isolate_fail;
 			}
-			goto isolate_fail;
 		}
 
 		/*
@@ -1165,10 +1187,11 @@ isolate_migratepages_block(struct compac
 			}
 
 			/*
-			 * folio become large since the non-locked check,
-			 * and it's on LRU.
+			 * Check LRU folio order under the lock
 			 */
-			if (unlikely(folio_test_large(folio) && !cc->alloc_contig)) {
+			if (unlikely(skip_isolation_on_order(folio_order(folio),
+							     cc->order) &&
+				     !cc->alloc_contig)) {
 				low_pfn += folio_nr_pages(folio) - 1;
 				nr_scanned += folio_nr_pages(folio) - 1;
 				folio_set_lru(folio);
@@ -1786,6 +1809,10 @@ static struct folio *compaction_alloc(st
 	struct compact_control *cc = (struct compact_control *)data;
 	struct folio *dst;
 
+	/* this makes migrate_pages() split the source page and retry */
+	if (folio_test_large(src) > 0)
+		return NULL;
+
 	if (list_empty(&cc->freepages)) {
 		isolate_freepages(cc);
 
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-compaction-enable-compacting-0-order-folios.patch
mm-compaction-add-support-for-0-order-folio-memory-compaction.patch
mm-compaction-optimize-0-order-folio-compaction-with-free-page-split.patch

