Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75FCB21B195
	for <mm-commits@vger.kernel.org>; Mon,  1 Sep 2025 18:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756752130; cv=none; b=b3bWgw2M22Fh34eSFsRrXRPutzTMl3YmaU2YM4Ly6xtoqJmEYTKJo4UQYDRZ9rCL+Y4PSGmbKTjCeYPhgzx72/nZW7JJc/W7/WsTbglGOO6t5cNKZWQIMoUwaEh8d6IwtHbTe4aPFtPnur1hNX5feh5E/qnpBiHDSfjslDAuUXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756752130; c=relaxed/simple;
	bh=h++Ftv8c+L0HtiYAOLqUQw0Xs2lIEsd6cZqKYCLUq3c=;
	h=Date:To:From:Subject:Message-Id; b=f5X9uI86SF0VnDMyB8Lm0xuCahRIK3mMnCKddokhjCy2BU5RL/niU2xQKQf/Vcau5+Iy9Dib3w1Xog/bGM5RFKPv5UvL/FbFXeb6IlIszKEER8NY3wZcm7McbsFWNtRwsEmrVR1wr0kVGqWaljl61KKi/CFCMv002o1E6DlwUgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TFMr29Y7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TFMr29Y7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27E3FC4CEF0;
	Mon,  1 Sep 2025 18:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756752130;
	bh=h++Ftv8c+L0HtiYAOLqUQw0Xs2lIEsd6cZqKYCLUq3c=;
	h=Date:To:From:Subject:From;
	b=TFMr29Y70fZSUVMKFW14jvScvliX8MoRSYmDZGc96HpkZ6mTb7uqJ58DuhVYzHTSM
	 kbfIGSkIFuT2DzqDDspNhBAEizxqWXx/YAfrYDQSH3f1h607a7VxwFouP8vM68QKg0
	 CVSoAvJr2huWe3DbpdLzGWwQnEoKlNjXNRIrTAxs=
Date: Mon, 01 Sep 2025 11:42:09 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yishaih@nvidia.com,will@kernel.org,vbabka@suse.cz,ulf.hansson@linaro.org,tursulin@ursulin.net,tsbogend@alpha.franken.de,torvalds@linux-foundation.org,tj@kernel.org,tglx@linutronix.de,svens@linux.ibm.com,surenb@google.com,sj@kernel.org,shuah@kernel.org,shameerali.kolothum.thodi@huawei.com,rppt@kernel.org,rodrigo.vivi@intel.com,robin.murphy@arm.com,richard.weiyang@gmail.com,peterx@redhat.com,paul.walmsley@sifive.com,palmer@dabbelt.com,osalvador@suse.de,oakad@yahoo.com,npiggin@gmail.com,muchun.song@linux.dev,m.szyprowski@samsung.com,mpe@ellerman.id.au,mingo@redhat.com,mhocko@suse.com,maximlevitsky@gmail.com,martin.petersen@oracle.com,maddy@linux.ibm.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,lars.persson@axis.com,kevin.tian@intel.com,kernel@xen0n.name,joonas.lahtinen@linux.intel.com,jhubbard@nvidia.com,jgg@ziepe.ca,jgg@nvidia.com,jesper.nilsson@axis.com,jason@zx2c4.com,jani.nikula@linux.intel.com,james.bottomley@HansenPartnership.com,jackmanb@google.com,herbert@gondor.apana.org.au,hca@linux.ibm.com,hannes@cmpxchg.org,gor@linux.ibm.com,glider@google.com,elver@google.com,dvyukov@google.com,dlemoal@kernel.org,dgilbert@interlog.com,dennis@kernel.org,davem@davemloft.net,cl@gentwo.org,christophe.leroy@csgroup.eu,chenhuacai@kernel.org,catalin.marinas@arm.com,cassel@kernel.org,bvanassche@acm.org,brett.creeley@amd.com,bp@alien8.de,borntraeger@linux.ibm.com,axboe@kernel.dk,asml.silence@gmail.com,aou@eecs.berkeley.edu,andreas@gaisler.com,alex.williamson@redhat.com,alex@ghiti.fr,alexandru.elisei@arm.com,airlied@gmail.com,agordeev@linux.ibm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-stop-making-sparsemem_vmemmap-user-selectable.patch added to mm-new branch
Message-Id: <20250901184210.27E3FC4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: stop making SPARSEMEM_VMEMMAP user-selectable
has been added to the -mm mm-new branch.  Its filename is
     mm-stop-making-sparsemem_vmemmap-user-selectable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-stop-making-sparsemem_vmemmap-user-selectable.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: David Hildenbrand <david@redhat.com>
Subject: mm: stop making SPARSEMEM_VMEMMAP user-selectable
Date: Mon, 1 Sep 2025 17:03:22 +0200

Patch series "mm: remove nth_page()", v2.

As discussed recently with Linus, nth_page() is just nasty and we would
like to remove it.

To recap, the reason we currently need nth_page() within a folio is
because on some kernel configs (SPARSEMEM without SPARSEMEM_VMEMMAP), the
memmap is allocated per memory section.

While buddy allocations cannot cross memory section boundaries, hugetlb
and dax folios can.

So crossing a memory section means that "page++" could do the wrong thing.
Instead, nth_page() on these problematic configs always goes from
page->pfn, to the go from (++pfn)->page, which is rather nasty.

Likely, many people have no idea when nth_page() is required and when it
might be dropped.

We refer to such problematic PFN ranges and "non-contiguous pages".  If we
only deal with "contiguous pages", there is not need for nth_page().

Besides that "obvious" folio case, we might end up using nth_page() within
CMA allocations (again, could span memory sections), and in one corner
case (kfence) when processing memblock allocations (again, could span
memory sections).

So let's handle all that, add sanity checks, and remove nth_page().

Patch #1 -> #5   : stop making SPARSEMEM_VMEMMAP user-selectable + cleanups
Patch #6 -> #13  : disallow folios to have non-contiguous pages
Patch #14 -> #20 : remove nth_page() usage within folios
Patch #22        : disallow CMA allocations of non-contiguous pages
Patch #23 -> #33 : sanity+check + remove nth_page() usage within SG entry
Patch #34        : sanity-check + remove nth_page() usage in
                   unpin_user_page_range_dirty_lock()
Patch #35        : remove nth_page() in kfence
Patch #36        : adjust stale comment regarding nth_page
Patch #37        : mm: remove nth_page()

A lot of this is inspired from the discussion at [1] between Linus, Jason
and me, so cudos to them.


This patch (of 37):

In an ideal world, we wouldn't have to deal with SPARSEMEM without
SPARSEMEM_VMEMMAP, but in particular for 32bit SPARSEMEM_VMEMMAP is
considered too costly and consequently not supported.

However, if an architecture does support SPARSEMEM with SPARSEMEM_VMEMMAP,
let's forbid the user to disable VMEMMAP: just like we already do for
arm64, s390 and x86.

So if SPARSEMEM_VMEMMAP is supported, don't allow to use SPARSEMEM without
SPARSEMEM_VMEMMAP.

This implies that the option to not use SPARSEMEM_VMEMMAP will now be gone
for loongarch, powerpc, riscv and sparc.  All architectures only enable
SPARSEMEM_VMEMMAP with 64bit support, so there should not really be a big
downside to using the VMEMMAP (quite the contrary).

This is a preparation for not supporting

(1) folio sizes that exceed a single memory section

(2) CMA allocations of non-contiguous page ranges

in SPARSEMEM without SPARSEMEM_VMEMMAP configs, whereby we want to limit
possible impact as much as possible (e.g., gigantic hugetlb page
allocations suddenly fails).

Link: https://lkml.kernel.org/r/20250901150359.867252-1-david@redhat.com
Link: https://lkml.kernel.org/r/20250901150359.867252-2-david@redhat.com
Link: https://lore.kernel.org/all/CAHk-=wiCYfNp4AJLBORU-c7ZyRBUp66W2-Et6cdQ4REx-GyQ_A@mail.gmail.com/T/#u [1]
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Alex Dubov <oakad@yahoo.com>
Cc: Alex Willamson <alex.williamson@redhat.com>
Cc: Bart van Assche <bvanassche@acm.org>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Brett Creeley <brett.creeley@amd.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christoph Lameter (Ampere) <cl@gentwo.org>
Cc: Damien Le Maol <dlemoal@kernel.org>
Cc: Dave Airlie <airlied@gmail.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Inki Dae <m.szyprowski@samsung.com>
Cc: James Bottomley <james.bottomley@HansenPartnership.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Jason A. Donenfeld <jason@zx2c4.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Jonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Lars Persson <lars.persson@axis.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Marco Elver <elver@google.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Maxim Levitky <maximlevitsky@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Niklas Cassel <cassel@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Robin Murohy <robin.murphy@arm.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Tvrtko Ursulin <tursulin@ursulin.net>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Cc: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/Kconfig~mm-stop-making-sparsemem_vmemmap-user-selectable
+++ a/mm/Kconfig
@@ -412,9 +412,8 @@ config SPARSEMEM_VMEMMAP_ENABLE
 	bool
 
 config SPARSEMEM_VMEMMAP
-	bool "Sparse Memory virtual memmap"
+	def_bool y
 	depends on SPARSEMEM && SPARSEMEM_VMEMMAP_ENABLE
-	default y
 	help
 	  SPARSEMEM_VMEMMAP uses a virtually mapped memmap to optimise
 	  pfn_to_page and page_to_pfn operations.  This is the most
_

Patches currently in -mm which might be from david@redhat.com are

mm-migrate-remove-migratepage_unmap.patch
mm-migrate-remove-migratepage_unmap-fix.patch
treewide-remove-migratepage_success.patch
mm-huge_memory-move-more-common-code-into-insert_pmd.patch
mm-huge_memory-move-more-common-code-into-insert_pud.patch
mm-huge_memory-support-huge-zero-folio-in-vmf_insert_folio_pmd.patch
fs-dax-use-vmf_insert_folio_pmd-to-insert-the-huge-zero-folio.patch
mm-huge_memory-mark-pmd-mappings-of-the-huge-zero-folio-special.patch
powerpc-ptdump-rename-struct-pgtable_level-to-struct-ptdump_pglevel.patch
mm-rmap-convert-enum-rmap_level-to-enum-pgtable_level.patch
mm-memory-convert-print_bad_pte-to-print_bad_page_map.patch
mm-memory-convert-print_bad_pte-to-print_bad_page_map-fix.patch
mm-memory-factor-out-common-code-from-vm_normal_page_.patch
mm-introduce-and-use-vm_normal_page_pud.patch
mm-rename-vm_ops-find_special_page-to-vm_ops-find_normal_page.patch
prctl-extend-pr_set_thp_disable-to-optionally-exclude-vm_hugepage.patch
mm-huge_memory-convert-tva_flags-to-enum-tva_type.patch
mm-huge_memory-respect-madv_collapse-with-pr_thp_disable_except_advised.patch
mm-stop-making-sparsemem_vmemmap-user-selectable.patch
arm64-kconfig-drop-superfluous-select-sparsemem_vmemmap.patch
s390-kconfig-drop-superfluous-select-sparsemem_vmemmap.patch
x86-kconfig-drop-superfluous-select-sparsemem_vmemmap.patch
wireguard-selftests-remove-config_sparsemem_vmemmap=y-from-qemu-kernel-config.patch
mm-page_alloc-reject-unreasonable-folio-compound-page-sizes-in-alloc_contig_range_noprof.patch
mm-memremap-reject-unreasonable-folio-compound-page-sizes-in-memremap_pages.patch
mm-hugetlb-check-for-unreasonable-folio-sizes-when-registering-hstate.patch
mm-mm_init-make-memmap_init_compound-look-more-like-prep_compound_page.patch
mm-sanity-check-maximum-folio-size-in-folio_set_order.patch
mm-limit-folio-compound-page-sizes-in-problematic-kernel-configs.patch
mm-simplify-folio_page-and-folio_page_idx.patch
mm-hugetlb-cleanup-hugetlb_folio_init_tail_vmemmap.patch
mm-mm-percpu-km-drop-nth_page-usage-within-single-allocation.patch
fs-hugetlbfs-remove-nth_page-usage-within-folio-in-adjust_range_hwpoison.patch
fs-hugetlbfs-cleanup-folio-in-adjust_range_hwpoison.patch
mm-pagewalk-drop-nth_page-usage-within-folio-in-folio_walk_start.patch
mm-gup-drop-nth_page-usage-within-folio-when-recording-subpages.patch
mm-gup-remove-record_subpages.patch
io_uring-zcrx-remove-nth_page-usage-within-folio.patch
mips-mm-convert-__flush_dcache_pages-to-__flush_dcache_folio_pages.patch
mm-cma-refuse-handing-out-non-contiguous-page-ranges.patch
dma-remap-drop-nth_page-in-dma_common_contiguous_remap.patch
scatterlist-disallow-non-contigous-page-ranges-in-a-single-sg-entry.patch
ata-libata-sff-drop-nth_page-usage-within-sg-entry.patch
drm-i915-gem-drop-nth_page-usage-within-sg-entry.patch
mspro_block-drop-nth_page-usage-within-sg-entry.patch
memstick-drop-nth_page-usage-within-sg-entry.patch
mmc-drop-nth_page-usage-within-sg-entry.patch
scsi-scsi_lib-drop-nth_page-usage-within-sg-entry.patch
scsi-sg-drop-nth_page-usage-within-sg-entry.patch
vfio-pci-drop-nth_page-usage-within-sg-entry.patch
crypto-remove-nth_page-usage-within-sg-entry.patch
mm-gup-drop-nth_page-usage-in-unpin_user_page_range_dirty_lock.patch
kfence-drop-nth_page-usage.patch
block-update-comment-of-struct-bio_vec-regarding-nth_page.patch
mm-remove-nth_page.patch

