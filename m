Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC79242A92
	for <mm-commits@vger.kernel.org>; Wed, 29 Jan 2025 23:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738193130; cv=none; b=KZABw9FILL48R316la+CLkt5FAmS6P48QUqnB3EQjeAiM1h/6+mHIDa7u+CqHAFHQsMTVXWD8VmT6dEQLKFM1QhoUBTqKvGWRbC7wPvOqFEryiVqu71uTEkrtHUTfq0F534EK7pjq57MP7bFqbAUbVQM5TjWbFVhWZPJHE40Dxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738193130; c=relaxed/simple;
	bh=Cp+ZeIQgDtqIf+D+QtGmYeyUhqJPQdUbkpYi5Y72IFk=;
	h=Date:To:From:Subject:Message-Id; b=VCzmMSmOZk/gDa6sXyqxGwZal1psuMfJl+O8ZMzn/gpv/iLknt81/0ZP4sa6Qfe1fvDO2IHl8+3bAi19d1Cevd6MmE/JplsIlAX3rdVK3Up6D6x5EyM+rq2eZqWGRF66WqK9y/Drs1u7mqdkEIbNtNCuJEYt+49W1U4MsczJTkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=c9juvosC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="c9juvosC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F3FFC4CED1;
	Wed, 29 Jan 2025 23:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738193129;
	bh=Cp+ZeIQgDtqIf+D+QtGmYeyUhqJPQdUbkpYi5Y72IFk=;
	h=Date:To:From:Subject:From;
	b=c9juvosCeVryoiIJ2p6SxLbEXhSfxYJoE1HbpjwEU7ZnxI5PnTMM0adYAE+dJbiGY
	 MP+0OuM966McBQjIq/6avy5Ka37lYiwc7xFLzwzNRYi+EDVttMxpPAj/P5NCoAOMua
	 tP/qyHVx+k3yQC7GDXeYMqLUivVULMLdIQ7dOfyo=
Date: Wed, 29 Jan 2025 15:25:28 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,yaozhenguo1@gmail.com,usamaarif642@gmail.com,roman.gushchin@linux.dev,peterz@infradead.org,muchun.song@linux.dev,mpe@ellerman.id.au,maddy@linux.ibm.com,luto@kernel.org,joao.m.martins@oracle.com,hca@linux.ibm.com,gor@linux.ibm.com,dave.hansen@linux.intel.com,agordeev@linux.ibm.com,fvdl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-cma-export-total-and-free-number-of-pages-for-cma-areas.patch added to mm-unstable branch
Message-Id: <20250129232529.2F3FFC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/cma: export total and free number of pages for CMA areas
has been added to the -mm mm-unstable branch.  Its filename is
     mm-cma-export-total-and-free-number-of-pages-for-cma-areas.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-cma-export-total-and-free-number-of-pages-for-cma-areas.patch

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
From: Frank van der Linden <fvdl@google.com>
Subject: mm/cma: export total and free number of pages for CMA areas
Date: Wed, 29 Jan 2025 22:41:30 +0000

Patch series "hugetlb/CMA improvements for large systems", v2.

On large systems, we observed some issues with hugetlb and CMA:

1) When specifying a large number of hugetlb boot pages (hugepages= on
   the commandline), the kernel may run out of memory before it even gets
   to HVO.  For example, if you have a 3072G system, and want to use 3024
   1G hugetlb pages for VMs, that should leave you plenty of space for the
   hypervisor, provided you have the hugetlb vmemmap optimization (HVO)
   enabled.  However, since the vmemmap pages are always allocated first,
   and then later in boot freed, you will actually run yourself out of
   memory before you can do HVO.  This means not getting all the hugetlb
   pages you want, and worse, failure to boot if there is an allocation
   failure in the system from which it can't recover.

2) There is a system setup where you might want to use hugetlb_cma with
   a large value (say, again, 3024 out of 3072G like above), and then
   lower that if system usage allows it, to make room for non-hugetlb
   processes.  For this, a variation of the problem above applies: the
   kernel runs out of unmovable space to allocate from before you finish
   boot, since your CMA area takes up all the space.

3) CMA wants to use one big contiguous area for allocations.  Which
   fails if you have the aforementioned 3T system with a gap in the middle
   of physical memory (like the < 40bits BIOS DMA area seen on some AMD
   systems).  You then won't be able to set up a CMA area for one of the
   NUMA nodes, leading to loss of half of your hugetlb CMA area.

4) Under the scenario mentioned in 2), when trying to grow the number
   of hugetlb pages after dropping it for a while, new CMA allocations may
   fail occasionally.  This is not unexpected, some transient references
   on pages may prevent cma_alloc from succeeding under memory pressure. 
   However, the hugetlb code then falls back to a normal contiguous alloc,
   which may end up succeeding.  This is not always desired behavior.  If
   you have a large CMA area, then the kernel has a restricted amount of
   memory it can do unmovable allocations from (a well known issue).  A
   normal contiguous alloc may eat further in to this space.


To resolve these issues, do the following:

* Add hooks to the section init code to do custom initialization of
  memmap pages.  Hugetlb bootmem (memblock) allocated pages can then be
  pre-HVOed.  This avoids allocating a large number of vmemmap pages early
  in boot, only to have them be freed again later, and also avoids running
  out of memory as described under 1).  Using these hooks for hugetlb is
  optional.  It requires moving hugetlb bootmem allocation to an earlier
  spot by the architecture.  This has been enabled on x86.
* hugetlb_cma doesn't care about the CMA area it uses being one large
  contiguous range.  Multiple smaller ranges are fine.  The only
  requirements are that the areas should be on one NUMA node, and
  individual gigantic pages should be allocatable from them.  So,
  implement multi-range support for CMA, avoiding issue 3).
* Introduce a hugetlb_cma_only option on the commandline.  This only
  allows allocations from CMA for gigantic pages, if hugetlb_cma= is also
  specified.
* With hugetlb_cma_only active, it also makes sense to be able to
  pre-allocate gigantic hugetlb pages at boot time from the CMA area(s). 
  Add a rudimentary early CMA allocation interface, that just grabs a
  piece of memblock-allocated space from the CMA area, which gets marked
  as allocated in the CMA bitmap when the CMA area is initialized.  With
  this, hugepages= can be supported with hugetlb_cma=, making scenario 2)
  work.

Additionally, fix some minor bugs, with one worth mentioning: since
hugetlb gigantic bootmem pages are allocated by memblock, they may span
multiple zones, as memblock doesn't (and mostly can't) know about zones. 
This can cause problems.  A hugetlb page spanning multiple zones is bad,
and it's worse with HVO, when the de-HVO step effectively sneakily
re-assigns pages to a different zone than originally configured, since the
tail pages all inherit the zone from the first 60 tail pages.  This
condition is not common, but can be easily reproduced using ZONE_MOVABLE. 
To fix this, add checks to see if gigantic bootmem pages intersect with
multiple zones, and do not use them if they do, giving them back to the
page allocator instead.

The first patch is kind of along for the ride, except that maintaining an
available_count for a CMA area is convenient for the multiple range
support.


This patch (of 28):

In addition to the number of allocations and releases, system management
software may like to be aware of the size of CMA areas, and how many pages
are available in it.  This information is currently not available, so
export it in total_page and available_pages, respectively.

The name 'available_pages' was picked over 'free_pages' because 'free'
implies that the pages are unused.  But they might not be, they just
haven't been used by cma_alloc

The number of available pages is tracked regardless of CONFIG_CMA_SYSFS,
allowing for a few minor shortcuts in the code, avoiding bitmap
operations.

Link: https://lkml.kernel.org/r/20250129224157.2046079-1-fvdl@google.com
Link: https://lkml.kernel.org/r/20250129224157.2046079-2-fvdl@google.com
Signed-off-by: Frank van der Linden <fvdl@google.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin (Cruise) <roman.gushchin@linux.dev>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Zhenguo Yao <yaozhenguo1@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-mm-cma |   13 +++++++++
 mm/cma.c                                      |   22 +++++++++++-----
 mm/cma.h                                      |    1 
 mm/cma_debug.c                                |    5 ---
 mm/cma_sysfs.c                                |   20 ++++++++++++++
 5 files changed, 51 insertions(+), 10 deletions(-)

--- a/Documentation/ABI/testing/sysfs-kernel-mm-cma~mm-cma-export-total-and-free-number-of-pages-for-cma-areas
+++ a/Documentation/ABI/testing/sysfs-kernel-mm-cma
@@ -29,3 +29,16 @@ Date:		Feb 2024
 Contact:	Anshuman Khandual <anshuman.khandual@arm.com>
 Description:
 		the number of pages CMA API succeeded to release
+
+What:		/sys/kernel/mm/cma/<cma-heap-name>/total_pages
+Date:		Jun 2024
+Contact:	Frank van der Linden <fvdl@google.com>
+Description:
+		The size of the CMA area in pages.
+
+What:		/sys/kernel/mm/cma/<cma-heap-name>/available_pages
+Date:		Jun 2024
+Contact:	Frank van der Linden <fvdl@google.com>
+Description:
+		The number of pages in the CMA area that are still
+		available for CMA allocation.
--- a/mm/cma.c~mm-cma-export-total-and-free-number-of-pages-for-cma-areas
+++ a/mm/cma.c
@@ -86,6 +86,7 @@ static void cma_clear_bitmap(struct cma
 
 	spin_lock_irqsave(&cma->lock, flags);
 	bitmap_clear(cma->bitmap, bitmap_no, bitmap_count);
+	cma->available_count += count;
 	spin_unlock_irqrestore(&cma->lock, flags);
 }
 
@@ -133,7 +134,7 @@ out_error:
 			free_reserved_page(pfn_to_page(pfn));
 	}
 	totalcma_pages -= cma->count;
-	cma->count = 0;
+	cma->available_count = cma->count = 0;
 	pr_err("CMA area %s could not be activated\n", cma->name);
 }
 
@@ -206,7 +207,7 @@ int __init cma_init_reserved_mem(phys_ad
 		snprintf(cma->name, CMA_MAX_NAME,  "cma%d\n", cma_area_count);
 
 	cma->base_pfn = PFN_DOWN(base);
-	cma->count = size >> PAGE_SHIFT;
+	cma->available_count = cma->count = size >> PAGE_SHIFT;
 	cma->order_per_bit = order_per_bit;
 	*res_cma = cma;
 	cma_area_count++;
@@ -390,7 +391,7 @@ static void cma_debug_show_areas(struct
 {
 	unsigned long next_zero_bit, next_set_bit, nr_zero;
 	unsigned long start = 0;
-	unsigned long nr_part, nr_total = 0;
+	unsigned long nr_part;
 	unsigned long nbits = cma_bitmap_maxno(cma);
 
 	spin_lock_irq(&cma->lock);
@@ -402,12 +403,12 @@ static void cma_debug_show_areas(struct
 		next_set_bit = find_next_bit(cma->bitmap, nbits, next_zero_bit);
 		nr_zero = next_set_bit - next_zero_bit;
 		nr_part = nr_zero << cma->order_per_bit;
-		pr_cont("%s%lu@%lu", nr_total ? "+" : "", nr_part,
+		pr_cont("%s%lu@%lu", start ? "+" : "", nr_part,
 			next_zero_bit);
-		nr_total += nr_part;
 		start = next_zero_bit + nr_zero;
 	}
-	pr_cont("=> %lu free of %lu total pages\n", nr_total, cma->count);
+	pr_cont("=> %lu free of %lu total pages\n", cma->available_count,
+			cma->count);
 	spin_unlock_irq(&cma->lock);
 }
 
@@ -444,6 +445,14 @@ static struct page *__cma_alloc(struct c
 
 	for (;;) {
 		spin_lock_irq(&cma->lock);
+		/*
+		 * If the request is larger than the available number
+		 * of pages, stop right away.
+		 */
+		if (count > cma->available_count) {
+			spin_unlock_irq(&cma->lock);
+			break;
+		}
 		bitmap_no = bitmap_find_next_zero_area_off(cma->bitmap,
 				bitmap_maxno, start, bitmap_count, mask,
 				offset);
@@ -452,6 +461,7 @@ static struct page *__cma_alloc(struct c
 			break;
 		}
 		bitmap_set(cma->bitmap, bitmap_no, bitmap_count);
+		cma->available_count -= count;
 		/*
 		 * It's safe to drop the lock here. We've marked this region for
 		 * our exclusive use. If the migration fails we will take the
--- a/mm/cma_debug.c~mm-cma-export-total-and-free-number-of-pages-for-cma-areas
+++ a/mm/cma_debug.c
@@ -34,13 +34,10 @@ DEFINE_DEBUGFS_ATTRIBUTE(cma_debugfs_fop
 static int cma_used_get(void *data, u64 *val)
 {
 	struct cma *cma = data;
-	unsigned long used;
 
 	spin_lock_irq(&cma->lock);
-	/* pages counter is smaller than sizeof(int) */
-	used = bitmap_weight(cma->bitmap, (int)cma_bitmap_maxno(cma));
+	*val = cma->count - cma->available_count;
 	spin_unlock_irq(&cma->lock);
-	*val = (u64)used << cma->order_per_bit;
 
 	return 0;
 }
--- a/mm/cma.h~mm-cma-export-total-and-free-number-of-pages-for-cma-areas
+++ a/mm/cma.h
@@ -13,6 +13,7 @@ struct cma_kobject {
 struct cma {
 	unsigned long   base_pfn;
 	unsigned long   count;
+	unsigned long	available_count;
 	unsigned long   *bitmap;
 	unsigned int order_per_bit; /* Order of pages represented by one bit */
 	spinlock_t	lock;
--- a/mm/cma_sysfs.c~mm-cma-export-total-and-free-number-of-pages-for-cma-areas
+++ a/mm/cma_sysfs.c
@@ -62,6 +62,24 @@ static ssize_t release_pages_success_sho
 }
 CMA_ATTR_RO(release_pages_success);
 
+static ssize_t total_pages_show(struct kobject *kobj,
+					  struct kobj_attribute *attr, char *buf)
+{
+	struct cma *cma = cma_from_kobj(kobj);
+
+	return sysfs_emit(buf, "%lu\n", cma->count);
+}
+CMA_ATTR_RO(total_pages);
+
+static ssize_t available_pages_show(struct kobject *kobj,
+					  struct kobj_attribute *attr, char *buf)
+{
+	struct cma *cma = cma_from_kobj(kobj);
+
+	return sysfs_emit(buf, "%lu\n", cma->available_count);
+}
+CMA_ATTR_RO(available_pages);
+
 static void cma_kobj_release(struct kobject *kobj)
 {
 	struct cma *cma = cma_from_kobj(kobj);
@@ -75,6 +93,8 @@ static struct attribute *cma_attrs[] = {
 	&alloc_pages_success_attr.attr,
 	&alloc_pages_fail_attr.attr,
 	&release_pages_success_attr.attr,
+	&total_pages_attr.attr,
+	&available_pages_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(cma);
_

Patches currently in -mm which might be from fvdl@google.com are

mm-cma-export-total-and-free-number-of-pages-for-cma-areas.patch
mm-cma-support-multiple-contiguous-ranges-if-requested.patch
mm-cma-introduce-cma_intersects-function.patch
mm-hugetlb-use-cma_declare_contiguous_multi.patch
mm-hugetlb-fix-round-robin-bootmem-allocation.patch
mm-hugetlb-remove-redundant-__clearpagereserved.patch
mm-hugetlb-use-online-nodes-for-bootmem-allocation.patch
mm-hugetlb-convert-cmdline-parameters-from-setup-to-early.patch
x86-mm-make-register_page_bootmem_memmap-handle-pte-mappings.patch
mm-bootmem_info-export-register_page_bootmem_memmap.patch
mm-sparse-allow-for-alternate-vmemmap-section-init-at-boot.patch
mm-hugetlb-set-migratetype-for-bootmem-folios.patch
mm-define-__init_reserved_page_zone-function.patch
mm-hugetlb-check-bootmem-pages-for-zone-intersections.patch
mm-sparse-add-vmemmap__hvo-functions.patch
mm-hugetlb-deal-with-multiple-calls-to-hugetlb_bootmem_alloc.patch
mm-hugetlb-move-huge_boot_pages-list-init-to-hugetlb_bootmem_alloc.patch
mm-hugetlb-add-pre-hvo-framework.patch
mm-hugetlb_vmemmap-fix-hugetlb_vmemmap_restore_folios-definition.patch
mm-hugetlb-do-pre-hvo-for-bootmem-allocated-pages.patch
x86-setup-call-hugetlb_bootmem_alloc-early.patch
x86-mm-set-arch_want_sparsemem_vmemmap_preinit.patch
mm-cma-simplify-zone-intersection-check.patch
mm-cma-introduce-a-cma-validate-function.patch
mm-cma-introduce-interface-for-early-reservations.patch
mm-hugetlb-add-hugetlb_cma_only-cmdline-option.patch
mm-hugetlb-enable-bootmem-allocation-from-cma-areas.patch
mm-hugetlb-move-hugetlb-cma-code-in-to-its-own-file.patch

