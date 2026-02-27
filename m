Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C241546AF14
	for <mm-commits@vger.kernel.org>; Fri, 27 Feb 2026 20:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772222968; cv=none; b=ZR+YySyqQyNefCp8sg9LUP7ahwIvCAZpvpL6gNEzvzCmaP2JVeM089CoNFHR4zoZ/IOF1C0EUcTfvhAMPgakZ7rECAuatg8kfTOgmqePqxvxxujDsmSBkHrXei0zYf9CVr19o9F35pY3qj62m7Cxvihlk6DikECmSB/z0jRWH5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772222968; c=relaxed/simple;
	bh=HxLdoBT9iq+Iz53Q5pvSZmGv5ED8mWgBMoWi2F+ZpfE=;
	h=Date:To:From:Subject:Message-Id; b=sxF/wvBWPKlwOENaMcNcR02s2mZjvtnTTxNA5F00XpNnF7I2wtoV9mZpwHsS14CGAtDrSyCeaNQIHwcDDDskA2N898Dk5t57+1f1frseuEM1N1Jkj4otoN1z6CA68+aaBRUFRNjbUuf1JOrlodvgwLmVcZQrZC33nIZxc0GBSY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h5dsBVn8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h5dsBVn8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BCDEC19421;
	Fri, 27 Feb 2026 20:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772222968;
	bh=HxLdoBT9iq+Iz53Q5pvSZmGv5ED8mWgBMoWi2F+ZpfE=;
	h=Date:To:From:Subject:From;
	b=h5dsBVn8VHgf6lIQJ7+Qa7ouXQ4dC/tEJrMNrKd92nGkZefNRBOqzx7WKcHEB6X6/
	 F5VLxx19CybOZhnyoe4Hr28+seBQQJUL6uBJx1vsVLQx6mzFGSjmoIpuRWPc7C6Q22
	 +JgZGSr8JOZgBXzxHE5vjet3HWybC4w8x+tnrYDU=
Date: Fri, 27 Feb 2026 12:09:27 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vbabka@suse.cz,usamaarif642@gmail.com,rppt@kernel.org,roman.gushchin@linux.dev,rientjes@google.com,paul.walmsley@sifive.com,palmer@dabbelt.com,osalvador@suse.de,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,kernel@xen0n.name,harry.yoo@oracle.com,hannes@cmpxchg.org,fvdl@google.com,david@kernel.org,corbet@lwn.net,cl@gentwo.org,chenhuacai@kernel.org,bhe@redhat.com,aou@eecs.berkeley.edu,alex@ghiti.fr,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-move-max_folio_order-definition-to-mmzoneh.patch added to mm-new branch
Message-Id: <20260227200928.4BCDEC19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: move MAX_FOLIO_ORDER definition to mmzone.h
has been added to the -mm mm-new branch.  Its filename is
     mm-move-max_folio_order-definition-to-mmzoneh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-move-max_folio_order-definition-to-mmzoneh.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Kiryl Shutsemau <kas@kernel.org>
Subject: mm: move MAX_FOLIO_ORDER definition to mmzone.h
Date: Fri, 27 Feb 2026 19:42:39 +0000

Patch series "mm: Eliminate fake head pages from vmemmap optimization",
v7.

This series removes "fake head pages" from the HugeTLB vmemmap
optimization (HVO) by changing how tail pages encode their relationship to
the head page.

It simplifies compound_head() and page_ref_add_unless().  Both are in the
hot path.

Background
==========

HVO reduces memory overhead by freeing vmemmap pages for HugeTLB pages and
remapping the freed virtual addresses to a single physical page. 
Previously, all tail page vmemmap entries were remapped to the first
vmemmap page (containing the head struct page), creating "fake heads" -
tail pages that appear to have PG_head set when accessed through the
deduplicated vmemmap.

This required special handling in compound_head() to detect and work
around fake heads, adding complexity and overhead to a very hot path.

New Approach
============

For architectures/configs where sizeof(struct page) is a power of 2 (the
common case), this series changes how position of the head page is encoded
in the tail pages.

Instead of storing a pointer to the head page, the ->compound_info
(renamed from ->compound_head) now stores a mask.

The mask can be applied to any tail page's virtual address to compute the
head page address.  Critically, all tail pages of the same order now have
identical compound_info values, regardless of which compound page they
belong to.

The key insight is that all tail pages of the same order now have
identical compound_info values, regardless of which compound page they
belong to.

In v7, these shared tail pages are allocated per-zone.  This ensures that
zone information (stored in page->flags) is correct even for shared tail
pages, removing the need for the special-casing in page_zonenum() proposed
in earlier versions.

To support per-zone shared pages for boot-allocated gigantic pages, the
vmemmap population is deferred until zones are initialized.  This
simplifies the logic significantly and allows the removal of
vmemmap_undo_hvo().

Benefits
========

1. Simplified compound_head(): No fake head detection needed, can be
   implemented in a branchless manner.

2. Simplified page_ref_add_unless(): RCU protection removed since there's
   no race with fake head remapping.

3. Cleaner architecture: The shared tail pages are truly read-only and
   contain valid tail page metadata.

If sizeof(struct page) is not power-of-2, there are no functional changes.
HVO is not supported in this configuration.

I had hoped to see performance improvement, but my testing thus far has
shown either no change or only a slight improvement within the noise.

Series Organization
===================

Patch 1: Move MAX_FOLIO_ORDER definition to mmzone.h.
Patches 2-4: Refactoring of field names and interfaces.
Patches 5-6: Architecture alignment for LoongArch and RISC-V.
Patch 7: Mask-based compound_head() implementation.
Patch 8: Add memmap alignment checks.
Patch 9: Branchless compound_head() optimization.
Patch 10: Defer vmemmap population for bootmem hugepages.
Patch 11: Refactor vmemmap_walk.
Patch 12: x86 vDSO build fix.
Patch 13: Eliminate fake heads with per-zone shared tail pages.
Patches 14-16: Cleanup of fake head infrastructure.
Patch 17: Documentation update.
Patch 18: Use compound_head() in page_slab().


This patch (of 17):

Move MAX_FOLIO_ORDER definition from mm.h to mmzone.h.

This is preparation for adding the vmemmap_tails array to struct zone,
which requires MAX_FOLIO_ORDER to be available in mmzone.h.

Link: https://lkml.kernel.org/r/20260227194302.274384-1-kas@kernel.org
Link: https://lkml.kernel.org/r/20260227194302.274384-2-kas@kernel.org
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: Muchun Song <muchun.song@linux.dev>
Acked-by: Usama Arif <usamaarif642@gmail.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Baoquan He <bhe@redhat.com>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: WANG Xuerui <kernel@xen0n.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h     |   31 -------------------------------
 include/linux/mmzone.h |   31 +++++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+), 31 deletions(-)

--- a/include/linux/mm.h~mm-move-max_folio_order-definition-to-mmzoneh
+++ a/include/linux/mm.h
@@ -27,7 +27,6 @@
 #include <linux/page-flags.h>
 #include <linux/page_ref.h>
 #include <linux/overflow.h>
-#include <linux/sizes.h>
 #include <linux/sched.h>
 #include <linux/pgtable.h>
 #include <linux/kasan.h>
@@ -2479,36 +2478,6 @@ static inline unsigned long folio_nr_pag
 	return folio_large_nr_pages(folio);
 }
 
-#if !defined(CONFIG_HAVE_GIGANTIC_FOLIOS)
-/*
- * We don't expect any folios that exceed buddy sizes (and consequently
- * memory sections).
- */
-#define MAX_FOLIO_ORDER		MAX_PAGE_ORDER
-#elif defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
-/*
- * Only pages within a single memory section are guaranteed to be
- * contiguous. By limiting folios to a single memory section, all folio
- * pages are guaranteed to be contiguous.
- */
-#define MAX_FOLIO_ORDER		PFN_SECTION_SHIFT
-#elif defined(CONFIG_HUGETLB_PAGE)
-/*
- * There is no real limit on the folio size. We limit them to the maximum we
- * currently expect (see CONFIG_HAVE_GIGANTIC_FOLIOS): with hugetlb, we expect
- * no folios larger than 16 GiB on 64bit and 1 GiB on 32bit.
- */
-#define MAX_FOLIO_ORDER		get_order(IS_ENABLED(CONFIG_64BIT) ? SZ_16G : SZ_1G)
-#else
-/*
- * Without hugetlb, gigantic folios that are bigger than a single PUD are
- * currently impossible.
- */
-#define MAX_FOLIO_ORDER		PUD_ORDER
-#endif
-
-#define MAX_FOLIO_NR_PAGES	(1UL << MAX_FOLIO_ORDER)
-
 /*
  * compound_nr() returns the number of pages in this potentially compound
  * page.  compound_nr() can be called on a tail page, and is defined to
--- a/include/linux/mmzone.h~mm-move-max_folio_order-definition-to-mmzoneh
+++ a/include/linux/mmzone.h
@@ -23,6 +23,7 @@
 #include <linux/page-flags.h>
 #include <linux/local_lock.h>
 #include <linux/zswap.h>
+#include <linux/sizes.h>
 #include <asm/page.h>
 
 /* Free memory management - zoned buddy allocator.  */
@@ -61,6 +62,36 @@
  */
 #define PAGE_ALLOC_COSTLY_ORDER 3
 
+#if !defined(CONFIG_HAVE_GIGANTIC_FOLIOS)
+/*
+ * We don't expect any folios that exceed buddy sizes (and consequently
+ * memory sections).
+ */
+#define MAX_FOLIO_ORDER		MAX_PAGE_ORDER
+#elif defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
+/*
+ * Only pages within a single memory section are guaranteed to be
+ * contiguous. By limiting folios to a single memory section, all folio
+ * pages are guaranteed to be contiguous.
+ */
+#define MAX_FOLIO_ORDER		PFN_SECTION_SHIFT
+#elif defined(CONFIG_HUGETLB_PAGE)
+/*
+ * There is no real limit on the folio size. We limit them to the maximum we
+ * currently expect (see CONFIG_HAVE_GIGANTIC_FOLIOS): with hugetlb, we expect
+ * no folios larger than 16 GiB on 64bit and 1 GiB on 32bit.
+ */
+#define MAX_FOLIO_ORDER		get_order(IS_ENABLED(CONFIG_64BIT) ? SZ_16G : SZ_1G)
+#else
+/*
+ * Without hugetlb, gigantic folios that are bigger than a single PUD are
+ * currently impossible.
+ */
+#define MAX_FOLIO_ORDER		PUD_ORDER
+#endif
+
+#define MAX_FOLIO_NR_PAGES	(1UL << MAX_FOLIO_ORDER)
+
 enum migratetype {
 	MIGRATE_UNMOVABLE,
 	MIGRATE_MOVABLE,
_

Patches currently in -mm which might be from kas@kernel.org are

mm-move-max_folio_order-definition-to-mmzoneh.patch
mm-change-the-interface-of-prep_compound_tail.patch
mm-rename-the-compound_head-field-in-the-struct-page-to-compound_info.patch
mm-move-set-clear_compound_head-next-to-compound_head.patch
riscv-mm-align-vmemmap-to-maximal-folio-size.patch
loongarch-mm-align-vmemmap-to-maximal-folio-size.patch
mm-rework-compound_head-for-power-of-2-sizeofstruct-page.patch
mm-sparse-check-memmap-alignment-for-compound_info_has_mask.patch
mm-hugetlb-defer-vmemmap-population-for-bootmem-hugepages.patch
mm-hugetlb-refactor-code-around-vmemmap_walk.patch
x86-vdso-undefine-config_hugetlb_page_optimize_vmemmap-for-vdso32.patch
mm-hugetlb-remove-fake-head-pages.patch
mm-drop-fake-head-checks.patch
hugetlb-remove-vmemmap_synchronize_rcu.patch
mm-hugetlb-remove-hugetlb_optimize_vmemmap_key-static-key.patch
mm-remove-the-branch-from-compound_head.patch
hugetlb-update-vmemmap_deduprst.patch
mm-slab-use-compound_head-in-page_slab.patch

