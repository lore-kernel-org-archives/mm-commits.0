Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBCCE1534E6
	for <mm-commits@vger.kernel.org>; Tue, 17 Sep 2024 08:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726560451; cv=none; b=Xw/T55XL0g14HEPYuhYDJUhAxwODoaPiVCBvdjn8yJPMciB7Ii1t01c/5g/cSPLOmfi5V4v3geZ5Z4v7zzXemYhm05R/dUVL3wx/lQFQvwu0U+Fv/IRnRjTaMJuc/H3Z4Shd9Sts2n6GGk8RgGv5g3EjDEN2i50Dhyw0p73MJl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726560451; c=relaxed/simple;
	bh=NDBTV/32W9cVFYRy4bY2Xh0/KHPwejjPiIzZV5XJ2PI=;
	h=Date:To:From:Subject:Message-Id; b=AoJfMoEMvQhUKQbMfkTQGBe3NrvQ09yCiyDmFJSLxnFBQBzZKL7v0f1IakE/Bzly1NqLyz4DxaYuQuAMRerqnLeqxbpwddEJ7D/wCnHSbEfpGj5ibQD36wyLA6K/3aidHXOL+XNOolOlAEVQXIGXhtv/y5hq+UaBT0dH+Lh317Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ARAQJcEj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ARAQJcEj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB840C4CEC6;
	Tue, 17 Sep 2024 08:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1726560451;
	bh=NDBTV/32W9cVFYRy4bY2Xh0/KHPwejjPiIzZV5XJ2PI=;
	h=Date:To:From:Subject:From;
	b=ARAQJcEj++fU07hlz5nOWeXOlymwV+0aPanYBR3vrttCNqnGiC7pOwFv3pzlw/nLi
	 4FrHUk2JTOcZtmIS3HGoCR6xbnwntGtFsi5jT6O8SsviU6M/xALZ/zhC+K6mMX/8zU
	 n/ZrQu0gGipXXanCHfz89L6kAxTWYY+Nsl3pyfmE=
Date: Tue, 17 Sep 2024 01:07:28 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,will@kernel.org,tglx@linutronix.de,svens@linux.ibm.com,seanjc@google.com,schnelle@linux.ibm.com,ryan.roberts@arm.com,pbonzini@redhat.com,mingo@redhat.com,jgg@nvidia.com,hca@linux.ibm.com,gshan@redhat.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,david@redhat.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,bp@alien8.de,borntraeger@linux.ibm.com,aneesh.kumar@linux.ibm.com,alex.williamson@redhat.com,agordeev@linux.ibm.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-introduce-arch_supports_huge_pfnmap-and-special-bits-to-pmd-pud.patch removed from -mm tree
Message-Id: <20240917080730.CB840C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: introduce ARCH_SUPPORTS_HUGE_PFNMAP and special bits to pmd/pud
has been removed from the -mm tree.  Its filename was
     mm-introduce-arch_supports_huge_pfnmap-and-special-bits-to-pmd-pud.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm: introduce ARCH_SUPPORTS_HUGE_PFNMAP and special bits to pmd/pud
Date: Mon, 26 Aug 2024 16:43:35 -0400

Patch series "mm: Support huge pfnmaps", v2.

Overview
========

This series implements huge pfnmaps support for mm in general.  Huge
pfnmap allows e.g.  VM_PFNMAP vmas to map in either PMD or PUD levels,
similar to what we do with dax / thp / hugetlb so far to benefit from TLB
hits.  Now we extend that idea to PFN mappings, e.g.  PCI MMIO bars where
it can grow as large as 8GB or even bigger.

Currently, only x86_64 (1G+2M) and arm64 (2M) are supported.  The last
patch (from Alex Williamson) will be the first user of huge pfnmap, so as
to enable vfio-pci driver to fault in huge pfn mappings.

Implementation
==============

In reality, it's relatively simple to add such support comparing to many
other types of mappings, because of PFNMAP's specialties when there's no
vmemmap backing it, so that most of the kernel routines on huge mappings
should simply already fail for them, like GUPs or old-school follow_page()
(which is recently rewritten to be folio_walk* APIs by David).

One trick here is that we're still unmature on PUDs in generic paths here
and there, as DAX is so far the only user.  This patchset will add the 2nd
user of it.  Hugetlb can be a 3rd user if the hugetlb unification work can
go on smoothly, but to be discussed later.

The other trick is how to allow gup-fast working for such huge mappings
even if there's no direct sign of knowing whether it's a normal page or
MMIO mapping.  This series chose to keep the pte_special solution, so that
it reuses similar idea on setting a special bit to pfnmap PMDs/PUDs so
that gup-fast will be able to identify them and fail properly.

Along the way, we'll also notice that the major pgtable pfn walker, aka,
follow_pte(), will need to retire soon due to the fact that it only works
with ptes.  A new set of simple API is introduced (follow_pfnmap* API) to
be able to do whatever follow_pte() can already do, plus that it can also
process huge pfnmaps now.  Half of this series is about that and
converting all existing pfnmap walkers to use the new API properly. 
Hopefully the new API also looks better to avoid exposing e.g.  pgtable
lock details into the callers, so that it can be used in an even more
straightforward way.

Here, three more options will be introduced and involved in huge pfnmap:

  - ARCH_SUPPORTS_HUGE_PFNMAP

    Arch developers will need to select this option when huge pfnmap is
    supported in arch's Kconfig.  After this patchset applied, both x86_64
    and arm64 will start to enable it by default.

  - ARCH_SUPPORTS_PMD_PFNMAP / ARCH_SUPPORTS_PUD_PFNMAP

    These options are for driver developers to identify whether current
    arch / config supports huge pfnmaps, making decision on whether it can
    use the huge pfnmap APIs to inject them.  One can refer to the last
    vfio-pci patch from Alex on the use of them properly in a device
    driver.

So after the whole set applied, and if one would enable some dynamic debug
lines in vfio-pci core files, we should observe things like:

  vfio-pci 0000:00:06.0: vfio_pci_mmap_huge_fault(,order = 9) BAR 0 page offset 0x0: 0x100
  vfio-pci 0000:00:06.0: vfio_pci_mmap_huge_fault(,order = 9) BAR 0 page offset 0x200: 0x100
  vfio-pci 0000:00:06.0: vfio_pci_mmap_huge_fault(,order = 9) BAR 0 page offset 0x400: 0x100

In this specific case, it says that vfio-pci faults in PMDs properly for a
few BAR0 offsets.

Patch Layout
============

Patch 1:         Introduce the new options mentioned above for huge PFNMAPs
Patch 2:         A tiny cleanup
Patch 3-8:       Preparation patches for huge pfnmap (include introduce
                 special bit for pmd/pud)
Patch 9-16:      Introduce follow_pfnmap*() API, use it everywhere, and
                 then drop follow_pte() API
Patch 17:        Add huge pfnmap support for x86_64
Patch 18:        Add huge pfnmap support for arm64
Patch 19:        Add vfio-pci support for all kinds of huge pfnmaps (Alex)

TODO
====

More architectures / More page sizes
------------------------------------

Currently only x86_64 (2M+1G) and arm64 (2M) are supported.  There seems
to have plan to support arm64 1G later on top of this series [2].

Any arch will need to first support THP / THP_1G, then provide a special
bit in pmds/puds to support huge pfnmaps.

remap_pfn_range() support
-------------------------

Currently, remap_pfn_range() still only maps PTEs.  With the new option,
remap_pfn_range() can logically start to inject either PMDs or PUDs when
the alignment requirements match on the VAs.

When the support is there, it should be able to silently benefit all
drivers that is using remap_pfn_range() in its mmap() handler on better
TLB hit rate and overall faster MMIO accesses similar to processor on
hugepages.

More driver support
-------------------

VFIO is so far the only consumer for the huge pfnmaps after this series
applied.  Besides above remap_pfn_range() generic optimization, device
driver can also try to optimize its mmap() on a better VA alignment for
either PMD/PUD sizes.  This may, iiuc, normally require userspace changes,
as the driver doesn't normally decide the VA to map a bar.  But I don't
think I know all the drivers to know the full picture.

Credits all go to Alex on help testing the GPU/NIC use cases above.

[0] https://lore.kernel.org/r/73ad9540-3fb8-4154-9a4f-30a0a2b03d41@lucifer.local
[1] https://lore.kernel.org/r/20240807194812.819412-1-peterx@redhat.com
[2] https://lore.kernel.org/r/498e0731-81a4-4f75-95b4-a8ad0bcc7665@huawei.com


This patch (of 19):

This patch introduces the option to introduce special pte bit into
pmd/puds.  Archs can start to define pmd_special / pud_special when
supported by selecting the new option.  Per-arch support will be added
later.

Before that, create fallbacks for these helpers so that they are always
available.

Link: https://lkml.kernel.org/r/20240826204353.2228736-1-peterx@redhat.com
Link: https://lkml.kernel.org/r/20240826204353.2228736-2-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gavin Shan <gshan@redhat.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Niklas Schnelle <schnelle@linux.ibm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   24 ++++++++++++++++++++++++
 mm/Kconfig         |   13 +++++++++++++
 2 files changed, 37 insertions(+)

--- a/include/linux/mm.h~mm-introduce-arch_supports_huge_pfnmap-and-special-bits-to-pmd-pud
+++ a/include/linux/mm.h
@@ -2643,6 +2643,30 @@ static inline pte_t pte_mkspecial(pte_t
 }
 #endif
 
+#ifndef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
+static inline bool pmd_special(pmd_t pmd)
+{
+	return false;
+}
+
+static inline pmd_t pmd_mkspecial(pmd_t pmd)
+{
+	return pmd;
+}
+#endif	/* CONFIG_ARCH_SUPPORTS_PMD_PFNMAP */
+
+#ifndef CONFIG_ARCH_SUPPORTS_PUD_PFNMAP
+static inline bool pud_special(pud_t pud)
+{
+	return false;
+}
+
+static inline pud_t pud_mkspecial(pud_t pud)
+{
+	return pud;
+}
+#endif	/* CONFIG_ARCH_SUPPORTS_PUD_PFNMAP */
+
 #ifndef CONFIG_ARCH_HAS_PTE_DEVMAP
 static inline int pte_devmap(pte_t pte)
 {
--- a/mm/Kconfig~mm-introduce-arch_supports_huge_pfnmap-and-special-bits-to-pmd-pud
+++ a/mm/Kconfig
@@ -875,6 +875,19 @@ endif # TRANSPARENT_HUGEPAGE
 config PGTABLE_HAS_HUGE_LEAVES
 	def_bool TRANSPARENT_HUGEPAGE || HUGETLB_PAGE
 
+# TODO: Allow to be enabled without THP
+config ARCH_SUPPORTS_HUGE_PFNMAP
+	def_bool n
+	depends on TRANSPARENT_HUGEPAGE
+
+config ARCH_SUPPORTS_PMD_PFNMAP
+	def_bool y
+	depends on ARCH_SUPPORTS_HUGE_PFNMAP && HAVE_ARCH_TRANSPARENT_HUGEPAGE
+
+config ARCH_SUPPORTS_PUD_PFNMAP
+	def_bool y
+	depends on ARCH_SUPPORTS_HUGE_PFNMAP && HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
+
 #
 # UP and nommu archs use km based percpu allocator
 #
_

Patches currently in -mm which might be from peterx@redhat.com are


