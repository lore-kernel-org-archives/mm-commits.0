Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BED44207A;
	Fri, 20 Sep 2024 09:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726824802; cv=none; b=Shc791rXcXF2zcmB21l0+TkWM0ZmtEjPvhouWYN6yc5ZH590n/UxGhAC1Yhi/7KJM+5Wz8DlG7002rsxdzbw/sRE/KXrOqBGf4r6pEWz5FBLzZz0EAcEaUwhjEJsfrXmKha6/RuhZo+sQOprS4TpQfla4+fWJybSq/xMQf87YpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726824802; c=relaxed/simple;
	bh=DW5JfQWbxVk4Ozo0QSOy20nqqs3uVPqUfaAiBqCVjeI=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=CQf/wWeeg9s+43sWQ4++KmVp9qe1mMNcJmDl0BflxeLVzjBNYTMvN5DqHsN3L/pIOviRscsnhzCu2gO98iPnBfYWn+EstNlFCbYUkokuRY2hj4dOvLY5qcqrO8KKRB87TO1DhaAlw7StvlJqOI6+B6zf27NPlA6YWCkkV4jMIbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rtv1xlkQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rtv1xlkQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57A0BC4CEC3;
	Fri, 20 Sep 2024 09:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1726824801;
	bh=DW5JfQWbxVk4Ozo0QSOy20nqqs3uVPqUfaAiBqCVjeI=;
	h=Date:From:To:Cc:Subject:From;
	b=rtv1xlkQDhYpE73OO5UcwsrWmAoutBz6ij0jtFe99ZJoifNOVHw2ta7LS9MOZByRW
	 eqk2YuT8SYX+tWaaDQZLcFFwvxwqd4KPkznqNsuR6zT7KTMzp/34QjK7Gd+Aw4OH1B
	 444khsEnFnxEpxnTXmoyFqAv0MKSxSar+4q0mSao=
Date: Fri, 20 Sep 2024 02:33:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] MM updates for 6.12-rc1
Message-Id: <20240920023317.f20c9ecbb2a2f4bf382d831c@linux-foundation.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable


Linus, please merge this cycle's batch of MM updates, thanks.



Conflicts which I'm seeing, along with their linux-next resolutions are
as follows:

arch/arm64/Kconfig, vs tip tree:
https://lkml.kernel.org/r/20240911151642.7f9d9e02@canb.auug.org.au

include/linux/mm.h, vs execve tree:
https://lkml.kernel.org/r/20240909171843.78c294da@canb.auug.org.au

kernel/events/uprobes.c, vs tip tree:
https://lkml.kernel.org/r/20240905153557.3b0f8db5@canb.auug.org.au

kernel/events/uprobes.c, vs e240b0fde52f ("uprobes: Use kzalloc to
allocate xol area"):
https://lkml.kernel.org/r/20240917092739.46dcf943@canb.auug.org.au

kernel/resource.c, vs ea72ce5da228 ("x86/kaslr: Expose and use the end
of the physical memory address space"):
https://lkml.kernel.org/r/20240909100043.60668995@canb.auug.org.au



Forthcoming conflicts along with their linux-next resolutions include:

tools/testing/shared/linux/init.h, vs memblock tree:
https://lkml.kernel.org/r/20240801141047.07940cd3@canb.auug.org.au

include/linux/rcutree.h, vs slab tree:
https://lkml.kernel.org/r/54d62d5a-16e3-4ea9-83c6-8801ee99855e@suse.cz

drivers/iommu/iommufd/selftest.c, vs iommufd tree:
https://lkml.kernel.org/r/20240816125429.7a55b08c@canb.auug.org.au
https://lkml.kernel.org/r/20240816125429.7a55b08c@canb.auug.org.au

include/linux/huge_mm.h, vs vfs-brauner tree:
https://lkml.kernel.org/r/20240902112101.2728f045@canb.auug.org.au

mm/filemap.c, vs ext3 tree:
https://lkml.kernel.org/r/20240906111900.5fcf345e@canb.auug.org.au

include/linux/lsm_hooks.h
security/security.c, vs security tree:




Forthcoming build issues along with their linux-next resolutions
include:

include/linux/slab.h, vs s390 tree:
https://lkml.kernel.org/r/20240808135836.740effac@canb.auug.org.au

A build fix for m68k is needed, vs ea72ce5da228 ("x86/kaslr: Expose and
use the end of the physical memory address space").  See
https://lkml.kernel.org/r/87ttenvw0i.fsf@yhuang6-desk2.ccr.corp.intel.com



The following changes since commit 431c1646e1f86b949fa3685efc50b660a364c2b6:

  Linux 6.11-rc6 (2024-09-01 19:46:02 +1200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2024=
-09-20-02-31

for you to fetch changes up to 684826f8271ad97580b138b9ffd462005e470b99:

  zram: free secondary algorithms names (2024-09-17 01:07:01 -0700)

----------------------------------------------------------------
ALong with the usual shower of singleton patches, notable patch series in
this pull request are:

"Align kvrealloc() with krealloc()" from Danilo Krummrich.  Adds
consistency to the APIs and behaviour of these two core allocation
functions.  This also simplifies/enables Rustification.

"Some cleanups for shmem" from Baolin Wang.  No functional changes - mode
code reuse, better function naming, logic simplifications.

"mm: some small page fault cleanups" from Josef Bacik.  No functional
changes - code cleanups only.

"Various memory tiering fixes" from Zi Yan.  A small fix and a little
cleanup.

"mm/swap: remove boilerplate" from Yu Zhao.  Code cleanups and
simplifications and .text shrinkage.

"Kernel stack usage histogram" from Pasha Tatashin and Shakeel Butt.  This
is a feature, it adds new feilds to /proc/vmstat such as

    $ grep kstack /proc/vmstat
    kstack_1k 3
    kstack_2k 188
    kstack_4k 11391
    kstack_8k 243
    kstack_16k 0

which tells us that 11391 processes used 4k of stack while none at all
used 16k.  Useful for some system tuning things, but partivularly useful
for "the dynamic kernel stack project".

"kmemleak: support for percpu memory leak detect" from Pavel Tikhomirov.
Teaches kmemleak to detect leaksage of percpu memory.

"mm: memcg: page counters optimizations" from Roman Gushchin.  "3
independent small optimizations of page counters".

"mm: split PTE/PMD PT table Kconfig cleanups+clarifications" from David
Hildenbrand.  Improves PTE/PMD splitlock detection, makes powerpc/8xx work
correctly by design rather than by accident.

"mm: remove arch_make_page_accessible()" from David Hildenbrand.  Some
folio conversions which make arch_make_page_accessible() unneeded.

"mm, memcg: cg2 memory{.swap,}.peak write handlers" fro David Finkel.
Cleans up and fixes our handling of the resetting of the cgroup/process
peak-memory-use detector.

"Make core VMA operations internal and testable" from Lorenzo Stoakes.
Rationalizaion and encapsulation of the VMA manipulation APIs.  With a
view to better enable testing of the VMA functions, even from a
userspace-only harness.

"mm: zswap: fixes for global shrinker" from Takero Funaki.  Fix issues in
the zswap global shrinker, resulting in improved performance.

"mm: print the promo watermark in zoneinfo" from Kaiyang Zhao.  Fill in
some missing info in /proc/zoneinfo.

"mm: replace follow_page() by folio_walk" from David Hildenbrand.  Code
cleanups and rationalizations (conversion to folio_walk()) resulting in
the removal of follow_page().

"improving dynamic zswap shrinker protection scheme" from Nhat Pham.  Some
tuning to improve zswap's dynamic shrinker.  Significant reductions in
swapin and improvements in performance are shown.

"mm: Fix several issues with unaccepted memory" from Kirill Shutemov.
Improvements to the new unaccepted memory feature,

"mm/mprotect: Fix dax puds" from Peter Xu.  Implements mprotect on DAX
PUDs.  This was missing, although nobody seems to have notied yet.

"Introduce a store type enum for the Maple tree" from Sidhartha Kumar.
Cleanups and modest performance improvements for the maple tree library
code.

"memcg: further decouple v1 code from v2" from Shakeel Butt.  Move more
cgroup v1 remnants away from the v2 memcg code.

"memcg: initiate deprecation of v1 features" from Shakeel Butt.  Adds
various warnings telling users that memcg v1 features are deprecated.

"mm: swap: mTHP swap allocator base on swap cluster order" from Chris Li.
Greatly improves the success rate of the mTHP swap allocation.

"mm: introduce numa_memblks" from Mike Rapoport.  Moves various disparate
per-arch implementations of numa_memblk code into generic code.

"mm: batch free swaps for zap_pte_range()" from Barry Song.  Greatly
improves the performance of munmap() of swap-filled ptes.

"support large folio swap-out and swap-in for shmem" from Baolin Wang.
With this series we no longer split shmem large folios into simgle-page
folios when swapping out shmem.

"mm/hugetlb: alloc/free gigantic folios" from Yu Zhao.  Nice performance
improvements and code reductions for gigantic folios.

"support shmem mTHP collapse" from Baolin Wang.  Adds support for
khugepaged's collapsing of shmem mTHP folios.

"mm: Optimize mseal checks" from Pedro Falcato.  Fixes an mprotect()
performance regression due to the addition of mseal().

"Increase the number of bits available in page_type" from Matthew Wilcox.
Increases the number of bits available in page_type!

"Simplify the page flags a little" from Matthew Wilcox.  Many legacy page
flags are now folio flags, so the page-based flags and their
accessors/mutators can be removed.

"mm: store zero pages to be swapped out in a bitmap" from Usama Arif.  An
optimization which permits us to avoid writing/reading zero-filled zswap
pages to backing store.

"Avoid MAP_FIXED gap exposure" from Liam Howlett.  Fixes a race window
which occurs when a MAP_FIXED operqtion is occurring during an unrelated
vma tree walk.

"mm: remove vma_merge()" from Lorenzo Stoakes.  Major rotorooting of the
vma_merge() functionality, making ot cleaner, more testable and better
tested.

"misc fixups for DAMON {self,kunit} tests" from SeongJae Park.  Minor
fixups of DAMON selftests and kunit tests.

"mm: memory_hotplug: improve do_migrate_range()" from Kefeng Wang.  Code
cleanups and folio conversions.

"Shmem mTHP controls and stats improvements" from Ryan Roberts.  Cleanups
for shmem controls and stats.

"mm: count the number of anonymous THPs per size" from Barry Song.  Expose
additional anon THP stats to userspace for improved tuning.

"mm: finish isolate/putback_lru_page()" from Kefeng Wang: more folio
conversions and removal of now-unused page-based APIs.

"replace per-quota region priorities histogram buffer with per-context
one" from SeongJae Park.  DAMON histogram rationalization.

"Docs/damon: update GitHub repo URLs and maintainer-profile" from SeongJae
Park.  DAMON documentation updates.

"mm/vdpa: correct misuse of non-direct-reclaim __GFP_NOFAIL and improve
related doc and warn" from Jason Wang: fixes usage of page allocator
__GFP_NOFAIL and GFP_ATOMIC flags.

"mm: split underused THPs" from Yu Zhao.  Improve THP=3Dalways policy - this
was overprovisioning THPs in sparsely accessed memory areas.

"zram: introduce custom comp backends API" frm Sergey Senozhatsky.  Add
support for zram run-time compression algorithm tuning.

"mm: Care about shadow stack guard gap when getting an unmapped area" from
Mark Brown.  Fix up the various arch_get_unmapped_area() implementations
to better respect guard areas.

"Improve mem_cgroup_iter()" from Kinsey Ho.  Improve the reliability of
mem_cgroup_iter() and various code cleanups.

"mm: Support huge pfnmaps" from Peter Xu.  Extends the usage of huge
pfnmap support.

"resource: Fix region_intersects() vs add_memory_driver_managed()" from
Huang Ying.  Fix a bug in region_intersects() for systems with CXL memory.

"mm: hwpoison: two more poison recovery" from Kefeng Wang.  Teaches a
couple more code paths to correctly recover from the encountering of
poisoned memry.

"mm: enable large folios swap-in support" from Barry Song.  Support the
swapin of mTHP memory into appropriately-sized folios, rather than into
single-page folios.

----------------------------------------------------------------
Alex Williamson (1):
      vfio/pci: implement huge_fault support

Alexander Zhu (1):
      mm: selftest to verify zero-filled pages are mapped to zeropage

Andrew Morton (2):
      include/linux/mmzone.h: clean up watermark accessors
      mm/page_alloc: fix build with CONFIG_UNACCEPTED_MEMORY=3Dn

Andrey Konovalov (1):
      kasan: simplify and clarify Makefile

Anshuman Khandual (1):
      mm/debug_vm_pgtable: Use pxdp_get() for accessing page table entries

Baolin Wang (16):
      mm: shmem: simplify the suitable huge orders validation for tmpfs
      mm: shmem: rename shmem_is_huge() to shmem_huge_global_enabled()
      mm: shmem: move shmem_huge_global_enabled() into shmem_allowable_huge=
_orders()
      mm: swap: extend swap_shmem_alloc() to support batch SWAP_MAP_SHMEM f=
lag setting
      mm: shmem: extend shmem_partial_swap_usage() to support large folio s=
wap
      mm: filemap: use xa_get_order() to get the swap entry order
      mm: shmem: use swap_free_nr() to free shmem swap entries
      mm: shmem: support large folio allocation for shmem_replace_folio()
      mm: shmem: drop folio reference count using 'nr_pages' in shmem_delet=
e_from_page_cache()
      mm: shmem: split large entry if the swapin folio is not large
      mm: shmem: support large folio swap out
      mm: khugepaged: expand the is_refcount_suitable() to support file fol=
ios
      mm: khugepaged: use the number of pages in the folio to check the ref=
erence count
      mm: khugepaged: support shmem mTHP copy
      mm: khugepaged: support shmem mTHP collapse
      selftests: mm: support shmem mTHP collapse testing

Barry Song (10):
      mm: extend 'usage' parameter so that cluster_swap_free_nr() can be re=
used
      mm: swap: add nr argument in swapcache_prepare and swapcache_clear to=
 support large folios
      mm: rename instances of swap_info_struct to meaningful 'si'
      mm: attempt to batch free swap entries for zap_pte_range()
      mm: count the number of anonymous THPs per size
      mm: count the number of partially mapped anonymous THPs per size
      mm: document __GFP_NOFAIL must be blockable
      mm: warn about illegal __GFP_NOFAIL usage in a more appropriate locat=
ion and manner
      mm: fix swap_read_folio_zeromap() for large folios with partial zerom=
ap
      mm: add nr argument in mem_cgroup_swapin_uncharge_swap() helper to su=
pport large folios

Carlos Maiolino (1):
      shmem_quota: build the object file conditionally to the config option

Chris Li (3):
      mm: swap: swap cluster switch to double link list
      mm: swap: mTHP allocate swap entries from nonfull list
      mm: swap: separate SSD allocation from scan_swap_map_slots()

Christophe Leroy (1):
      set_memory: add __must_check to generic stubs

Chuanhua Han (1):
      mm: support large folios swap-in for sync io devices

Daniel Gomez (1):
      mm: shmem: return number of pages beeing freed in shmem_free_swap

Danilo Krummrich (4):
      mm: vmalloc: implement vrealloc()
      mm: kvmalloc: align kvrealloc() with krealloc()
      mm: krealloc: consider spare memory for __GFP_ZERO
      mm: krealloc: clarify valid usage of __GFP_ZERO

David Finkel (2):
      mm, memcg: cg2 memory{.swap,}.peak write handlers
      mm, memcg: cg2 memory{.swap,}.peak write tests

David Gow (1):
      mm: only enforce minimum stack gap size if it's sensible

David Hildenbrand (24):
      mm: turn USE_SPLIT_PTE_PTLOCKS / USE_SPLIT_PTE_PTLOCKS into Kconfig o=
ptions
      mm/hugetlb: enforce that PMD PT sharing has split PMD PT locks
      powerpc/8xx: document and enforce that split PT locks are not used
      mm: simplify arch_make_folio_accessible()
      mm/gup: convert to arch_make_folio_accessible()
      s390/uv: drop arch_make_page_accessible()
      mm/hugetlb: remove hugetlb_follow_page_mask() leftover
      mm/rmap: cleanup partially-mapped handling in __folio_remove_rmap()
      mm: clarify folio_likely_mapped_shared() documentation for KSM folios
      mm: provide vm_normal_(page|folio)_pmd() with CONFIG_PGTABLE_HAS_HUGE=
_LEAVES
      mm/pagewalk: introduce folio_walk_start() + folio_walk_end()
      mm/migrate: convert do_pages_stat_array() from follow_page() to folio=
_walk
      mm/migrate: convert add_page_for_migration() from follow_page() to fo=
lio_walk
      mm/ksm: convert get_mergeable_page() from follow_page() to folio_walk
      mm/ksm: convert scan_get_next_rmap_item() from follow_page() to folio=
_walk
      mm/huge_memory: convert split_huge_pages_pid() from follow_page() to =
folio_walk
      s390/uv: convert gmap_destroy_page() from follow_page() to folio_walk
      s390/mm/fault: convert do_secure_storage_access() from follow_page() =
to folio_walk
      mm: remove follow_page()
      mm/ksm: convert break_ksm() from walk_page_range_vma() to folio_walk
      mm/rmap: minimize folio->_nr_pages_mapped updates when batching PTE (=
un)mapping
      mm/rmap: use folio->_mapcount for small folios
      mm: always inline _compound_head() with CONFIG_HUGETLB_PAGE_OPTIMIZE_=
VMEMMAP=3Dy
      selftests/mm: fix charge_reserved_hugetlb.sh test

Dev Jain (1):
      selftests/mm: relax test to fail after 100 migration failures

Hao Ge (1):
      mm/cma: change the addition of totalcma_pages in the cma_init_reserve=
d_mem

Hongbo Li (1):
      mm/vmalloc.c: make use of the helper macro LIST_HEAD()

Huan Yang (1):
      mm: page_alloc: simpify page del and expand

Huang Ying (2):
      resource: make alloc_free_mem_region() works for iomem_resource
      resource, kunit: add test case for region_intersects()

Hugh Dickins (2):
      mm: shmem: fix minor off-by-one in shrinkable calculation
      mm: shmem: extend shmem_unused_huge_shrink() to all sizes

Jann Horn (1):
      mm: fix (harmless) type confusion in lock_vma_under_rcu()

Jason Wang (1):
      vduse: avoid using __GFP_NOFAIL

Jeff Xu (1):
      selftest mm/mseal: fix test_seal_mremap_move_dontunmap_anyaddr

Jianhui Zhou (1):
      percpu: remove pcpu_alloc_size()

Jinjiang Tu (1):
      selftests/mm: remove unnecessary ia64 code and comment

Johannes Weiner (1):
      mm: swapfile: fix SSD detection with swapfile on btrfs

Josef Bacik (2):
      mm: cleanup flags usage in faultin_page
      mm: remove foll_flags in __get_user_pages

Kairui Song (6):
      mm: swap: clean up initialization helper
      mm: swap: skip slot cache on freeing for mTHP
      mm: swap: allow cache reclaim to skip slot cache
      mm: swap: add a fragment cluster list
      mm: swap: relaim the cached parts that got scanned
      mm: swap: add a adaptive full cluster cache reclaim

Kaiyang Zhao (4):
      mm: consider CMA pages in watermark check for NUMA balancing target n=
ode
      mm: create promo_wmark_pages and clean up open-coded sites
      mm: print the promo watermark in zoneinfo
      mm,memcg: provide per-cgroup counters for NUMA balancing operations

Kefeng Wang (16):
      mm: hugetlb: remove left over comment about follow_huge_foo()
      mm: remove migration for HugePage in isolate_single_pageblock()
      mm: memory_hotplug: remove head variable in do_migrate_range()
      mm: memory-failure: add unmap_poisoned_folio()
      mm: memory_hotplug: check hwpoisoned page firstly in do_migrate_range=
()
      mm: migrate: add isolate_folio_to_list()
      mm: memory_hotplug: unify Huge/LRU/non-LRU movable folio isolation
      mm: migrate_device: convert to migrate_device_coherent_folio()
      mm: migrate_device: use a folio in migrate_device_range()
      mm: migrate_device: use more folio in migrate_device_unmap()
      mm: migrate_device: use more folio in migrate_device_finalize()
      mm: remove isolate_lru_page()
      mm: remove putback_lru_page()
      mm: migrate: remove unused includes
      mm: support poison recovery from do_cow_fault()
      mm: support poison recovery from copy_present_page()

Kent Overstreet (2):
      mm: fix folio_alloc_noprof()
      mm/show_mem.c: report alloc tags in human readable units

Kinsey Ho (5):
      cgroup: clarify css sibling linkage is protected by cgroup_mutex or R=
CU
      mm: don't hold css->refcnt during traversal
      mm: increment gen # before restarting traversal
      mm: restart if multiple traversals raced
      mm: clean up mem_cgroup_iter()

Kirill A. Shutemov (7):
      mm: reduce deferred struct page init ifdeffery
      mm: accept memory in __alloc_pages_bulk()
      mm: introduce PageUnaccepted() page type
      mm: rework accept memory helpers
      mm: add a helper to accept page
      mm: page_isolation: handle unaccepted memory isolation
      mm: accept to promo watermark

Liam R. Howlett (22):
      mm/vma: correctly position vma_iterator in __split_vma()
      mm/vma: introduce abort_munmap_vmas()
      mm/vma: introduce vmi_complete_munmap_vmas()
      mm/vma: extract the gathering of vmas from do_vmi_align_munmap()
      mm/vma: introduce vma_munmap_struct for use in munmap operations
      mm/vma: change munmap to use vma_munmap_struct() for accounting and s=
urrounding vmas
      mm/vma: extract validate_mm() from vma_complete()
      mm/vma: inline munmap operation in mmap_region()
      mm/vma: expand mmap_region() munmap call
      mm/vma: support vma =3D=3D NULL in init_vma_munmap()
      mm/mmap: reposition vma iterator in mmap_region()
      mm/vma: track start and end for munmap in vma_munmap_struct
      mm: clean up unmap_region() argument list
      mm/mmap: avoid zeroing vma tree in mmap_region()
      mm: change failure of MAP_FIXED to restoring the gap on failure
      mm/mmap: use PHYS_PFN in mmap_region()
      mm/mmap: use vms accounted pages in mmap_region()
      ipc/shm, mm: drop do_vma_munmap()
      mm: move may_expand_vm() check in mmap_region()
      mm/vma: drop incorrect comment from vms_gather_munmap_vmas()
      mm/vma.h: optimise vma_munmap_struct
      maple_tree: mark three functions as __maybe_unused

Linus Torvalds (1):
      mm: remove legacy install_special_mapping() code

Lorenzo Stoakes (17):
      userfaultfd: move core VMA manipulation logic to mm/userfaultfd.c
      mm: move vma_modify() and helpers to internal header
      mm: move vma_shrink(), vma_expand() to internal header
      mm: move internal core VMA manipulation functions to own file
      MAINTAINERS: add entry for new VMA files
      tools: separate out shared radix-tree components
      tools: add skeleton code for userland testing of VMA logic
      tools: improve vma test Makefile
      tools: add VMA merge tests
      mm: introduce vma_merge_struct and abstract vma_merge(),vma_modify()
      mm: remove duplicated open-coded VMA policy check
      mm: abstract vma_expand() to use vma_merge_struct
      mm: avoid using vma_merge() for new VMAs
      mm: make vma_prepare() and friends static and internal to vma.c
      mm: introduce commit_merge(), abstracting final commit of merge
      mm: refactor vma_merge() into modify-only vma_merge_existing_range()
      mm: rework vm_ops->close() handling on VMA merge

Marco Elver (1):
      kfence: introduce burst mode

Mark Brown (3):
      mm: make arch_get_unmapped_area() take vm_flags by default
      mm: pass vm_flags to generic_get_unmapped_area()
      mm: care about shadow stack guard gap when getting an unmapped area

Mateusz Guzik (1):
      mm/hugetlb: sort out global lock annotations

Matthew Cassell (1):
      mm: add node_reclaim successes to VM event counters

Matthew Wilcox (Oracle) (18):
      fs: remove calls to set and clear the folio error flag
      mm: remove PG_error
      mm: return the folio from swapin_readahead
      printf: remove %pGt support
      mm: introduce page_mapcount_is_type()
      mm: support only one page_type per page
      zsmalloc: use all available 24 bits of page_type
      mm: remove PageActive
      mm: remove PageSwapBacked
      mm: remove PageReadahead
      mm: remove PageSwapCache
      mm: remove PageUnevictable
      mm: remove PageMlocked
      mm: remove PageOwnerPriv1
      mm: remove page_has_private()
      mm: rename PG_mappedtodisk to PG_owner_2
      x86: remove PG_uncached
      swap: convert swapon() to use a folio

Miao Wang (1):
      mm: vmalloc: add optimization hint on page existence check

Michael Ellerman (4):
      mm: add optional close() to struct vm_special_mapping
      powerpc/mm: handle VDSO unmapping via close() rather than arch_unmap()
      mm: remove arch_unmap()
      powerpc/vdso: refactor error handling

Michal Koutn=FD (1):
      memcg: cleanup with !CONFIG_MEMCG_V1

Mike Rapoport (Microsoft) (26):
      mm: move kernel/numa.c to mm/
      MIPS: sgi-ip27: make NODE_DATA() the same as on all other architectur=
es
      MIPS: sgi-ip27: ensure node_possible_map only contains valid nodes
      MIPS: sgi-ip27: drop HAVE_ARCH_NODEDATA_EXTENSION
      MIPS: loongson64: rename __node_data to node_data
      MIPS: loongson64: drop HAVE_ARCH_NODEDATA_EXTENSION
      arch, mm: move definition of node_data to generic code
      mm: drop CONFIG_HAVE_ARCH_NODEDATA_EXTENSION
      arch, mm: pull out allocation of NODE_DATA to generic code
      x86/numa: simplify numa_distance allocation
      x86/numa: use get_pfn_range_for_nid to verify that node spans memory
      x86/numa: move FAKE_NODE_* defines to numa_emu
      x86/numa_emu: simplify allocation of phys_dist
      x86/numa_emu: split __apicid_to_node update to a helper function
      x86/numa_emu: use a helper function to get MAX_DMA32_PFN
      x86/numa: numa_{add,remove}_cpu: make cpu parameter unsigned
      mm: introduce numa_memblks
      mm: move numa_distance and related code from x86 to numa_memblks
      mm: introduce numa_emulation
      mm: numa_memblks: introduce numa_memblks_init
      mm: numa_memblks: make several functions and variables static
      mm: numa_memblks: use memblock_{start,end}_of_DRAM() when sanitizing =
meminfo
      of, numa: return -EINVAL when no numa-node-id is found
      arch_numa: switch over to numa_memblks
      mm: make range-to-target_node lookup facility a part of numa_memblks
      docs: move numa=3Dfake description to kernel-parameters.txt

Mike Yuan (2):
      selftests: test_zswap: add test for hierarchical zswap.writeback
      Documentation/cgroup-v2: clarify that zswap.writeback is ignored if z=
swap is disabled

Muchun Song (2):
      mm: kmem: remove mem_cgroup_from_obj()
      mm: kmem: add lockdep assertion to obj_cgroup_memcg

Nanyong Sun (2):
      mm: migrate: simplify find_mm_struct()
      mm: thp: simplify split_huge_pages_pid()

Nhat Pham (2):
      zswap: implement a second chance algorithm for dynamic zswap shrinker
      zswap: track swapins from disk more accurately

Oleg Nesterov (3):
      Revert "uprobes: use vm_special_mapping close() functionality"
      uprobes: introduce the global struct vm_special_mapping xol_mapping
      uprobes: turn xol_area->pages[2] into xol_area->page

Pasha Tatashin (2):
      vmstat: kernel stack usage histogram
      task_stack: uninline stack_not_used

Pavel Tikhomirov (2):
      kmemleak: enable tracking for percpu pointers
      kmemleak-test: add percpu leak

Pedro Falcato (8):
      selftests/mm: add mseal test for no-discard madvise
      mm: move can_modify_vma to mm/vma.h
      mm/munmap: replace can_modify_mm with can_modify_vma
      mm/mprotect: replace can_modify_mm with can_modify_vma
      mm/mremap: replace can_modify_mm with can_modify_vma
      mseal: replace can_modify_mm_madv with a vma variant
      mm: remove can_modify_mm()
      selftests/mm: add more mseal traversal tests

Peng Hao (1):
      mm/damon/lru_sort: adjust local variable to dynamic allocation

Peter Xu (25):
      mm/dax: dump start address in fault handler
      mm/mprotect: push mmu notifier to PUDs
      mm/powerpc: add missing pud helpers
      mm/x86: make pud_leaf() only care about PSE bit
      mm/x86: implement arch_check_zapped_pud()
      mm/x86: add missing pud helpers
      mm/mprotect: fix dax pud handlings
      mm: introduce ARCH_SUPPORTS_HUGE_PFNMAP and special bits to pmd/pud
      mm: drop is_huge_zero_pud()
      mm: mark special bits for huge pfn mappings when inject
      mm: allow THP orders for PFNMAPs
      mm/gup: detect huge pfnmap entries in gup-fast
      mm/pagewalk: check pfnmap for folio_walk_start()
      mm/fork: accept huge pfnmap entries
      mm: always define pxx_pgprot()
      mm: new follow_pfnmap API
      KVM: use follow_pfnmap API
      s390/pci_mmio: use follow_pfnmap API
      mm/x86/pat: use the new follow_pfnmap API
      vfio: use the new follow_pfnmap API
      acrn: use the new follow_pfnmap API
      mm/access_process_vm: use the new follow_pfnmap API
      mm: remove follow_pte()
      mm/x86: support large pfn mappings
      mm/arm64: support large pfn mappings

Rik van Riel (1):
      mm,tmpfs: consider end of file write in shmem_is_huge

Roman Gushchin (3):
      mm: memcg: don't call propagate_protected_usage() needlessly
      mm: page_counters: put page_counter_calculate_protection() under CONF=
IG_MEMCG
      mm: page_counters: initialize usage using ATOMIC_LONG_INIT() macro

Ryan Roberts (3):
      mm: override mTHP "enabled" defaults at kernel cmdline
      mm: cleanup count_mthp_stat() definition
      mm: tidy up shmem mTHP controls and stats

SeongJae Park (18):
      selftests/damon: add access_memory_even to .gitignore
      selftests/damon: cleanup __pycache__/ with 'make clean'
      selftests/damon: add execute permissions to test scripts
      mm/damon/core-test: test only vaddr case on ops registration test
      mm/damon/core-test: fix damon_test_ops_registration() for DAMON_VADDR=
 unset case
      mm/damon/dbgfs-test: skip dbgfs_set_targets() test if PADDR is not re=
gistered
      mm/damon/dbgfs-test: skip dbgfs_set_init_regions() test if PADDR is n=
ot registered
      mm/damon: move kunit tests to tests/ subdirectory with _kunit suffix
      mm/damon/tests: add .kunitconfig file for DAMON kunit tests
      mm/damon/core: introduce per-context region priorities histogram buff=
er
      mm/damon/core: replace per-quota regions priority histogram buffer us=
age with per-context one
      mm/damon/core: remove per-scheme region priority histogram buffer
      Revert "mm/damon/lru_sort: adjust local variable to dynamic allocatio=
n"
      Docs/damon: use damonitor GitHub organization instead of awslabs
      Docs/damon/maintainer-profile: add links in place
      Docs/damon/maintainer-profile: document Google calendar for bi-weekly=
 meetups
      mm/damon/tests/vaddr-kunit: init maple tree without MT_FLAGS_LOCK_EXT=
ERN
      mm/damon/tests/core-kunit: skip damon_test_nr_accesses_to_accesses_bp=
() if aggr_interval is zero

Sergey Senozhatsky (26):
      lib: zstd: export API needed for dictionary support
      lib: lz4hc: export LZ4_resetStreamHC symbol
      lib: zstd: fix null-deref in ZSTD_createCDict_advanced2()
      zram: introduce custom comp backends API
      zram: add lzo and lzorle compression backends support
      zram: add lz4 compression backend support
      zram: add lz4hc compression backend support
      zram: add zstd compression backend support
      zram: pass estimated src size hint to zstd
      zram: add zlib compression backend support
      zram: add 842 compression backend support
      zram: check that backends array has at least one backend
      zram: introduce zcomp_params structure
      zram: recalculate zstd compression params once
      zram: introduce algorithm_params device attribute
      zram: add support for dict comp config
      zram: introduce zcomp_req structure
      zram: introduce zcomp_ctx structure
      zram: move immutable comp params away from per-CPU context
      zram: add dictionary support to lz4
      zram: add dictionary support to lz4hc
      zram: add dictionary support to zstd backend
      Documentation/zram: add documentation for algorithm parameters
      zram: support priority parameter in recompression
      mm: Kconfig: fixup zsmalloc configuration
      zram: free secondary algorithms names

Shakeel Butt (15):
      memcg: increase the valid index range for memcg stats
      memcg: replace memcg ID idr with xarray
      memcg: use ratelimited stats flush in the reclaim
      memcg: move v1 only percpu stats in separate struct
      memcg: move mem_cgroup_event_ratelimit to v1 code
      memcg: move mem_cgroup_charge_statistics to v1 code
      memcg: move v1 events and statistics code to v1 file
      memcg: make v1 only functions static
      memcg: allocate v1 event percpu only on v1 deployment
      memcg: make PGPGIN and PGPGOUT v1 only
      memcg: initiate deprecation of v1 tcp accounting
      memcg: initiate deprecation of v1 soft limit
      memcg: initiate deprecation of oom_control
      memcg: initiate deprecation of pressure_level
      mm: replace xa_get_order with xas_get_order where appropriate

Sidhartha Kumar (19):
      maple_tree: reset mas->index and mas->last on write retries
      maple_tree: add test to replicate low memory race conditions
      maple_tree: introduce store_type enum
      maple_tree: introduce mas_wr_prealloc_setup()
      maple_tree: move up mas_wr_store_setup() and mas_wr_prealloc_setup()
      maple_tree: introduce mas_wr_store_type()
      maple_tree: remove mas_destroy() from mas_nomem()
      maple_tree: preallocate nodes in mas_erase()
      maple_tree: use mas_store_gfp() in mtree_store_range()
      maple_tree: print store type in mas_dump()
      maple_tree: use store type in mas_wr_store_entry()
      maple_tree: convert mas_insert() to preallocate nodes
      maple_tree: simplify mas_commit_b_node()
      maple_tree: remove mas_wr_modify()
      maple_tree: have mas_store() allocate nodes if needed
      maple_tree: remove node allocations from various write helper functio=
ns
      maple_tree: remove repeated sanity checks from write helper functions
      maple_tree: remove unneeded mas_wr_walk() in mas_store_prealloc()
      maple_tree: make write helper functions void

Sven Schnelle (1):
      uprobes: use vm_special_mapping close() functionality

Takaya Saeki (2):
      filemap: add trace events for get_pages, map_pages, and fault
      filemap: fix the last_index of mm_filemap_get_pages

Takero Funaki (2):
      mm: zswap: fix global shrinker memcg iteration
      mm: zswap: fix global shrinker error handling logic

Thorsten Blum (2):
      lib: test_hmm: use min() to improve dmirror_exclusive()
      mm: shrinker: use min() to improve shrinker_debugfs_scan_write()

Tianchen Ding (1):
      kfence: save freeing stack trace at calling time instead of freeing t=
ime

Uladzislau Rezki (Sony) (2):
      mm: vmalloc: refactor vm_area_alloc_pages() function
      mm/vmalloc.c: use "high-order" in description non 0-order pages

Uros Bizjak (3):
      mm/z3fold: add __percpu annotation to *unbuddied pointer in struct z3=
fold_pool
      err.h: add ERR_PTR_PCPU(), PTR_ERR_PCPU() and IS_ERR_PCPU() macros
      mm/kmemleak: use IS_ERR_PCPU() for pointer in the percpu address space

Usama Arif (5):
      mm: store zero pages to be swapped out in a bitmap
      mm: remove code to handle same filled pages
      mm: introduce a pageflag for partially mapped folios
      mm: split underused THPs
      mm: add sysfs entry to disable splitting underused THPs

Valdis Kletnieks (1):
      mm: fix typo in Kconfig

Wei Yang (8):
      mm: improve code consistency with zonelist_* helper functions
      mm/memory_hotplug: get rid of __ref
      maple_tree: fix comment typo of ma_root
      maple_tree: fix comment typo with corresponding maple_status
      maple_tree: arange64 node is not a leaf node
      maple_tree: dump error message based on format
      maple_tree: cleanup function descriptions
      maple_tree: fix comment typo on ma_flag of allocation tree

Xiao Yang (1):
      mm/vma: return the exact errno in vms_gather_munmap_vmas()

Yafang Shao (1):
      mm: allow read-ahead with IOCB_NOWAIT set

Yanfei Xu (1):
      memory tier: fix deadlock warning while onlining pages

Yang Li (1):
      mm: remove duplicated include in vma_internal.h

Yosry Ahmed (2):
      mm: page_alloc: fix missed updates of PGFREE in free_unref_{page/foli=
os}
      mm: z3fold: deprecate CONFIG_Z3FOLD

Yu Zhao (14):
      mm/hugetlb_vmemmap: don't synchronize_rcu() without HVO
      mm/swap: reduce indentation level
      mm/swap: rename cpu_fbatches->activate
      mm/swap: fold lru_rotate into cpu_fbatches
      mm/swap: remove remaining _fn suffix
      mm/swap: remove boilerplate
      mm/hugetlb_vmemmap: batch HVO work when demoting
      mm/contig_alloc: support __GFP_COMP
      mm/cma: add cma_{alloc,free}_folio()
      mm/hugetlb: use __GFP_COMP for gigantic folios
      mm: remap unused subpages to shared zeropage when splitting isolated =
thp
      mm/codetag: fix a typo
      mm/codetag: fix pgalloc_tag_split()
      mm/codetag: add pgalloc_tag_copy()

Yuanchu Xie (1):
      mm: multi-gen LRU: ignore non-leaf pmd_young for force_scan=3Dtrue

Yuesong Li (1):
      mm:page-writeback: use folio_next_index() helper in writeback_iter()

Yujie Liu (1):
      sched/numa: Fix the vma scan starving issue

ZhangPeng (1):
      mm/vmalloc.c: use helper function va_size()

Zhaoyu Liu (1):
      mm: swap: allocate folio only first time in __read_swap_cache_async()

Zhiguo Jiang (1):
      mm: shrink skip folio mapped by an exiting process

Zhongkun He (1):
      mm:page_alloc: fix the NULL ac->nodemask in __alloc_pages_slowpath()

Zi Yan (4):
      memory tiering: read last_cpupid correctly in do_huge_pmd_numa_page()
      memory tiering: introduce folio_use_access_time() check
      memory tiering: count PGPROMOTE_SUCCESS when mem tiering is enabled.
      mm/migrate: move common code to numa_migrate_check (was numa_migrate_=
prep)

qiwu.chen (1):
      mm: kfence: print the elapsed time for allocated/freed track

yangge (1):
      mm/swap: take folio refcount after testing the LRU flag

 Documentation/ABI/testing/sysfs-block-zram         |    7 +
 Documentation/admin-guide/blockdev/zram.rst        |   66 +-
 Documentation/admin-guide/cgroup-v1/memory.rst     |   32 +-
 Documentation/admin-guide/cgroup-v2.rst            |   43 +-
 Documentation/admin-guide/kernel-parameters.txt    |   24 +
 Documentation/admin-guide/mm/damon/start.rst       |    4 +-
 Documentation/admin-guide/mm/damon/usage.rst       |    8 +-
 Documentation/admin-guide/mm/transhuge.rst         |   64 +-
 Documentation/arch/x86/x86_64/boot-options.rst     |   12 -
 Documentation/core-api/printk-formats.rst          |    4 +-
 Documentation/dev-tools/kfence.rst                 |    7 +
 .../features/vm/PG_uncached/arch-support.txt       |   30 -
 Documentation/filesystems/vfs.rst                  |    3 +-
 Documentation/mm/damon/design.rst                  |    2 +-
 Documentation/mm/damon/maintainer-profile.rst      |   86 +-
 Documentation/mm/page_migration.rst                |   22 +-
 Documentation/mm/transhuge.rst                     |    6 +-
 Documentation/mm/unevictable-lru.rst               |    8 +-
 .../zh_CN/admin-guide/mm/damon/start.rst           |    4 +-
 .../zh_CN/admin-guide/mm/damon/usage.rst           |    8 +-
 .../translations/zh_CN/mm/page_migration.rst       |    6 +-
 .../zh_TW/admin-guide/mm/damon/start.rst           |    4 +-
 .../zh_TW/admin-guide/mm/damon/usage.rst           |    8 +-
 MAINTAINERS                                        |   14 +
 arch/alpha/kernel/osf_sys.c                        |    2 +-
 arch/arc/mm/mmap.c                                 |    3 +-
 arch/arm/mm/fault-armv.c                           |    6 +-
 arch/arm/mm/mmap.c                                 |    7 +-
 arch/arm64/Kconfig                                 |    4 +-
 arch/arm64/include/asm/Kbuild                      |    1 +
 arch/arm64/include/asm/mmzone.h                    |   13 -
 arch/arm64/include/asm/pgtable.h                   |   30 +
 arch/arm64/include/asm/topology.h                  |    1 +
 arch/arm64/kvm/nested.c                            |    1 -
 arch/csky/abiv1/mmap.c                             |    3 +-
 arch/csky/kernel/vdso.c                            |   28 +-
 arch/hexagon/kernel/vdso.c                         |   14 +-
 arch/loongarch/configs/loongson3_defconfig         |    1 -
 arch/loongarch/include/asm/Kbuild                  |    1 +
 arch/loongarch/include/asm/mmzone.h                |   16 -
 arch/loongarch/include/asm/topology.h              |    1 +
 arch/loongarch/kernel/numa.c                       |   21 -
 arch/loongarch/mm/mmap.c                           |    5 +-
 arch/mips/Kconfig                                  |    5 -
 arch/mips/include/asm/mach-ip27/mmzone.h           |    1 -
 arch/mips/include/asm/mach-loongson64/mmzone.h     |    4 -
 arch/mips/loongson64/numa.c                        |   28 +-
 arch/mips/mm/mmap.c                                |    5 +-
 arch/mips/sgi-ip27/ip27-memory.c                   |   12 +-
 arch/mips/sgi-ip27/ip27-smp.c                      |    2 +
 arch/nios2/mm/init.c                               |   12 +-
 arch/parisc/kernel/sys_parisc.c                    |    5 +-
 arch/parisc/mm/hugetlbpage.c                       |    2 +-
 arch/powerpc/configs/ppc64_defconfig               |    1 -
 arch/powerpc/include/asm/book3s/64/pgtable.h       |    3 +
 arch/powerpc/include/asm/mmu_context.h             |    9 -
 arch/powerpc/include/asm/mmzone.h                  |    6 -
 arch/powerpc/include/asm/pgtable.h                 |    1 +
 arch/powerpc/kernel/vdso.c                         |   35 +-
 arch/powerpc/mm/book3s64/pgtable.c                 |   20 +
 arch/powerpc/mm/book3s64/slice.c                   |   10 +-
 arch/powerpc/mm/numa.c                             |   26 +-
 arch/powerpc/mm/pgtable-frag.c                     |    6 +-
 arch/powerpc/mm/pgtable.c                          |    6 +
 arch/powerpc/platforms/pseries/papr-vpd.c          |    5 +-
 arch/riscv/include/asm/Kbuild                      |    1 +
 arch/riscv/include/asm/mmzone.h                    |   13 -
 arch/riscv/include/asm/topology.h                  |    4 +
 arch/s390/include/asm/Kbuild                       |    1 +
 arch/s390/include/asm/mmzone.h                     |   17 -
 arch/s390/include/asm/page.h                       |    2 -
 arch/s390/include/asm/pgtable.h                    |    1 +
 arch/s390/kernel/numa.c                            |    3 -
 arch/s390/kernel/uv.c                              |   23 +-
 arch/s390/mm/fault.c                               |   16 +-
 arch/s390/mm/mmap.c                                |    4 +-
 arch/s390/pci/pci_mmio.c                           |   22 +-
 arch/sh/include/asm/mmzone.h                       |    3 -
 arch/sh/kernel/vsyscall/vsyscall.c                 |   14 +-
 arch/sh/mm/init.c                                  |    7 +-
 arch/sh/mm/mmap.c                                  |    5 +-
 arch/sh/mm/numa.c                                  |    3 -
 arch/sparc/include/asm/mmzone.h                    |    4 -
 arch/sparc/include/asm/pgtable_64.h                |    1 +
 arch/sparc/kernel/sys_sparc_32.c                   |    2 +-
 arch/sparc/kernel/sys_sparc_64.c                   |    4 +-
 arch/sparc/mm/init_64.c                            |   11 +-
 arch/x86/Kconfig                                   |   15 +-
 arch/x86/boot/compressed/misc.c                    |    2 +-
 arch/x86/boot/compressed/misc.h                    |    2 +-
 arch/x86/include/asm/Kbuild                        |    1 +
 arch/x86/include/asm/mmu_context.h                 |    5 -
 arch/x86/include/asm/mmzone.h                      |    6 -
 arch/x86/include/asm/mmzone_32.h                   |   17 -
 arch/x86/include/asm/mmzone_64.h                   |   18 -
 arch/x86/include/asm/numa.h                        |   26 +-
 arch/x86/include/asm/pgtable.h                     |  150 +-
 arch/x86/include/asm/pgtable_64.h                  |    1 -
 arch/x86/include/asm/sparsemem.h                   |    9 -
 arch/x86/kernel/sys_x86_64.c                       |   21 +-
 arch/x86/mm/Makefile                               |    1 -
 arch/x86/mm/amdtopology.c                          |    1 +
 arch/x86/mm/numa.c                                 |  622 +-----
 arch/x86/mm/numa_internal.h                        |   24 -
 arch/x86/mm/pat/memtype.c                          |   25 +-
 arch/x86/mm/pgtable.c                              |   18 +
 arch/x86/um/vdso/vma.c                             |   12 +-
 arch/x86/xen/mmu_pv.c                              |    7 +-
 arch/xtensa/kernel/syscall.c                       |    3 +-
 drivers/acpi/numa/srat.c                           |    1 +
 drivers/base/Kconfig                               |    1 +
 drivers/base/arch_numa.c                           |  224 +-
 drivers/block/zram/Kconfig                         |   77 +-
 drivers/block/zram/Makefile                        |    8 +
 drivers/block/zram/backend_842.c                   |   61 +
 drivers/block/zram/backend_842.h                   |   10 +
 drivers/block/zram/backend_deflate.c               |  146 ++
 drivers/block/zram/backend_deflate.h               |   10 +
 drivers/block/zram/backend_lz4.c                   |  127 ++
 drivers/block/zram/backend_lz4.h                   |   10 +
 drivers/block/zram/backend_lz4hc.c                 |  128 ++
 drivers/block/zram/backend_lz4hc.h                 |   10 +
 drivers/block/zram/backend_lzo.c                   |   59 +
 drivers/block/zram/backend_lzo.h                   |   10 +
 drivers/block/zram/backend_lzorle.c                |   59 +
 drivers/block/zram/backend_lzorle.h                |   10 +
 drivers/block/zram/backend_zstd.c                  |  226 ++
 drivers/block/zram/backend_zstd.h                  |   10 +
 drivers/block/zram/zcomp.c                         |  194 +-
 drivers/block/zram/zcomp.h                         |   71 +-
 drivers/block/zram/zram_drv.c                      |  141 +-
 drivers/block/zram/zram_drv.h                      |    1 +
 drivers/cxl/Kconfig                                |    2 +-
 drivers/dax/Kconfig                                |    2 +-
 drivers/dax/device.c                               |    6 +-
 drivers/firmware/efi/libstub/efistub.h             |    2 +-
 drivers/firmware/efi/libstub/unaccepted_memory.c   |    3 +-
 drivers/firmware/efi/unaccepted_memory.c           |   18 +-
 drivers/gpu/drm/drm_exec.c                         |    3 +-
 drivers/of/of_numa.c                               |    5 +-
 drivers/vdpa/vdpa_user/iova_domain.c               |   19 +-
 drivers/vdpa/vdpa_user/iova_domain.h               |    1 +
 drivers/vfio/pci/vfio_pci_core.c                   |   60 +-
 drivers/vfio/vfio_iommu_type1.c                    |   16 +-
 drivers/virt/acrn/mm.c                             |   16 +-
 fs/Kconfig                                         |    4 +
 fs/exec.c                                          |   81 +-
 fs/proc/internal.h                                 |    3 +-
 fs/proc/page.c                                     |   11 +-
 fs/userfaultfd.c                                   |  171 +-
 fs/xfs/scrub/xfile.c                               |    6 +-
 fs/xfs/xfs_buf_mem.c                               |    2 +-
 fs/xfs/xfs_log_recover.c                           |    2 +-
 include/asm-generic/mm_hooks.h                     |   11 +-
 include/asm-generic/mmzone.h                       |    5 +
 include/asm-generic/numa.h                         |    8 +-
 include/linux/alloc_tag.h                          |   26 +-
 include/linux/cgroup-defs.h                        |   11 +-
 include/linux/cgroup.h                             |    3 +
 include/linux/cma.h                                |   16 +
 include/linux/damon.h                              |    3 +-
 include/linux/err.h                                |    9 +
 include/linux/fs.h                                 |    1 -
 include/linux/gfp.h                                |   25 +-
 include/linux/gfp_types.h                          |    8 +-
 include/linux/huge_mm.h                            |  130 +-
 include/linux/hugetlb.h                            |   17 +-
 include/linux/kernel-page-flags.h                  |    3 +-
 include/linux/kfence.h                             |    2 +-
 include/linux/khugepaged.h                         |    1 +
 include/linux/maple_tree.h                         |   20 +-
 include/linux/memcontrol.h                         |   67 +-
 include/linux/memory_hotplug.h                     |   48 -
 include/linux/migrate.h                            |    3 +
 include/linux/mm.h                                 |  300 ++-
 include/linux/mm_types.h                           |   22 +-
 include/linux/mm_types_task.h                      |    3 -
 include/linux/mmzone.h                             |   35 +-
 include/linux/numa.h                               |    8 +
 include/linux/numa_memblks.h                       |   58 +
 include/linux/page-flags.h                         |  202 +-
 include/linux/page_counter.h                       |   27 +-
 include/linux/pagewalk.h                           |   58 +
 include/linux/percpu.h                             |    1 -
 include/linux/pgalloc_tag.h                        |   31 -
 include/linux/pgtable.h                            |   18 +
 include/linux/rmap.h                               |   11 +-
 include/linux/sched/mm.h                           |   27 +-
 include/linux/sched/task_stack.h                   |   18 +-
 include/linux/set_memory.h                         |    8 +-
 include/linux/shmem_fs.h                           |   15 +-
 include/linux/slab.h                               |   14 +-
 include/linux/swap.h                               |   44 +-
 include/linux/userfaultfd_k.h                      |   19 +
 include/linux/vm_event_item.h                      |   26 +
 include/linux/vmalloc.h                            |    4 +
 include/linux/vmstat.h                             |    1 +
 include/linux/writeback.h                          |    3 +
 include/linux/zstd.h                               |  167 ++
 include/linux/zswap.h                              |   16 +-
 include/trace/events/filemap.h                     |   84 +
 include/trace/events/mmflags.h                     |   36 +-
 include/trace/events/oom.h                         |    4 +-
 include/uapi/linux/kernel-page-flags.h             |    2 +-
 init/Kconfig                                       |    2 +-
 ipc/shm.c                                          |    8 +-
 kernel/Makefile                                    |    1 -
 kernel/cgroup/cgroup-internal.h                    |    2 +
 kernel/cgroup/cgroup.c                             |   23 +-
 kernel/events/uprobes.c                            |   36 +-
 kernel/exit.c                                      |   57 +
 kernel/fork.c                                      |    4 +-
 kernel/numa.c                                      |   26 -
 kernel/resource.c                                  |   25 +-
 kernel/resource_kunit.c                            |  143 ++
 kernel/sched/core.c                                |    4 +-
 kernel/sched/fair.c                                |   14 +-
 kernel/vmcore_info.c                               |    8 +-
 lib/Kconfig.debug                                  |    1 +
 lib/fortify_kunit.c                                |    3 +-
 lib/lz4/lz4hc_compress.c                           |    1 +
 lib/maple_tree.c                                   |  805 +++----
 lib/test_hmm.c                                     |    5 +-
 lib/test_printf.c                                  |   26 -
 lib/vsprintf.c                                     |   21 -
 lib/zstd/compress/zstd_compress.c                  |    2 +
 lib/zstd/zstd_compress_module.c                    |   49 +
 lib/zstd/zstd_decompress_module.c                  |   36 +
 mm/Kconfig                                         |   86 +-
 mm/Makefile                                        |    8 +-
 mm/cma.c                                           |   57 +-
 mm/compaction.c                                    |   47 +-
 mm/damon/core.c                                    |   24 +-
 mm/damon/dbgfs.c                                   |    2 +-
 mm/damon/sysfs.c                                   |    2 +-
 mm/damon/tests/.kunitconfig                        |   22 +
 mm/damon/{core-test.h =3D> tests/core-kunit.h}       |   35 +-
 mm/damon/{dbgfs-test.h =3D> tests/dbgfs-kunit.h}     |   10 +
 mm/damon/{sysfs-test.h =3D> tests/sysfs-kunit.h}     |    0
 mm/damon/{vaddr-test.h =3D> tests/vaddr-kunit.h}     |    2 +-
 mm/damon/vaddr.c                                   |    2 +-
 mm/debug.c                                         |   31 +-
 mm/debug_vm_pgtable.c                              |   50 +-
 mm/filemap.c                                       |   67 +-
 mm/folio-compat.c                                  |   12 -
 mm/gup.c                                           |   68 +-
 mm/huge_memory.c                                   |  589 ++++-
 mm/hugetlb.c                                       |  442 ++--
 mm/hugetlb_cgroup.c                                |    4 +-
 mm/hugetlb_vmemmap.c                               |   40 +-
 mm/internal.h                                      |  216 +-
 mm/kfence/core.c                                   |   53 +-
 mm/kfence/kfence.h                                 |    1 +
 mm/kfence/report.c                                 |   15 +-
 mm/khugepaged.c                                    |   75 +-
 mm/kmemleak.c                                      |  159 +-
 mm/ksm.c                                           |  146 +-
 mm/madvise.c                                       |   13 +-
 mm/memblock.c                                      |    2 +-
 mm/memcontrol-v1.c                                 |  126 +-
 mm/memcontrol-v1.h                                 |   26 +-
 mm/memcontrol.c                                    |  490 +++--
 mm/memory-failure.c                                |   92 +-
 mm/memory-tiers.c                                  |   22 +-
 mm/memory.c                                        |  562 +++--
 mm/memory_hotplug.c                                |   85 +-
 mm/mempolicy.c                                     |    8 +-
 mm/migrate.c                                       |  270 ++-
 mm/migrate_device.c                                |  108 +-
 mm/mm_init.c                                       |   12 +-
 mm/mmap.c                                          | 2250 +++-------------=
----
 mm/mmu_notifier.c                                  |    2 +
 mm/mmzone.c                                        |    2 +-
 mm/mprotect.c                                      |   86 +-
 mm/mremap.c                                        |   32 +-
 mm/mseal.c                                         |   55 +-
 mm/nommu.c                                         |   11 +-
 mm/numa.c                                          |   69 +
 {arch/x86/mm =3D> mm}/numa_emulation.c               |   42 +-
 mm/numa_memblks.c                                  |  571 +++++
 mm/page-writeback.c                                |    2 +-
 mm/page_alloc.c                                    |  349 +--
 mm/page_counter.c                                  |   48 +-
 mm/page_io.c                                       |  113 +-
 mm/page_isolation.c                                |   36 +-
 mm/pagewalk.c                                      |  202 ++
 mm/percpu.c                                        |   31 -
 mm/rmap.c                                          |   71 +-
 mm/shmem.c                                         |  450 ++--
 mm/shmem_quota.c                                   |    3 -
 mm/show_mem.c                                      |   11 +-
 mm/shrinker_debug.c                                |    2 +-
 mm/slab_common.c                                   |   27 +-
 mm/swap.c                                          |  298 ++-
 mm/swap.h                                          |   44 +-
 mm/swap_cgroup.c                                   |    2 +
 mm/swap_state.c                                    |   78 +-
 mm/swapfile.c                                      | 1482 +++++++------
 mm/userfaultfd.c                                   |  170 +-
 mm/util.c                                          |  102 +-
 mm/vma.c                                           | 2068 ++++++++++++++++=
++
 mm/vma.h                                           |  558 +++++
 mm/vma_internal.h                                  |   49 +
 mm/vmalloc.c                                       |  139 +-
 mm/vmscan.c                                        |   67 +-
 mm/vmstat.c                                        |   28 +
 mm/z3fold.c                                        |    2 +-
 mm/zsmalloc.c                                      |   15 +-
 mm/zswap.c                                         |  307 ++-
 samples/kmemleak/kmemleak-test.c                   |    2 +
 scripts/Makefile.kasan                             |   45 +-
 tools/mm/page-types.c                              |   13 +-
 tools/testing/memblock/internal.h                  |    2 +-
 tools/testing/radix-tree/.gitignore                |    1 +
 tools/testing/radix-tree/Makefile                  |   72 +-
 tools/testing/radix-tree/maple.c                   |  109 +-
 tools/testing/radix-tree/xarray.c                  |   10 +-
 tools/testing/selftests/cgroup/cgroup_util.c       |   22 +
 tools/testing/selftests/cgroup/cgroup_util.h       |    2 +
 tools/testing/selftests/cgroup/test_memcontrol.c   |  264 ++-
 tools/testing/selftests/cgroup/test_zswap.c        |   75 +-
 tools/testing/selftests/damon/.gitignore           |    1 +
 tools/testing/selftests/damon/Makefile             |    2 +
 tools/testing/selftests/damon/damon_nr_regions.py  |    0
 .../selftests/damon/damos_apply_interval.py        |    0
 tools/testing/selftests/damon/damos_quota.py       |    0
 tools/testing/selftests/damon/damos_quota_goal.py  |    0
 .../testing/selftests/damon/damos_tried_regions.py |    0
 .../selftests/damon/debugfs_target_ids_pid_leak.sh |    0
 ...ebugfs_target_ids_read_before_terminate_race.sh |    0
 .../sysfs_update_schemes_tried_regions_hang.py     |    0
 ..._update_schemes_tried_regions_wss_estimation.py |    0
 tools/testing/selftests/mm/Makefile                |    2 +-
 .../selftests/mm/charge_reserved_hugetlb.sh        |    2 +-
 tools/testing/selftests/mm/hugepage-mmap.c         |   18 +-
 tools/testing/selftests/mm/hugepage-shm.c          |   18 +-
 tools/testing/selftests/mm/hugepage-vmemmap.c      |   17 +-
 tools/testing/selftests/mm/khugepaged.c            |    4 +-
 tools/testing/selftests/mm/map_hugetlb.c           |   18 +-
 tools/testing/selftests/mm/migration.c             |   17 +-
 tools/testing/selftests/mm/mseal_test.c            |  197 +-
 tools/testing/selftests/mm/run_vmtests.sh          |    2 +-
 tools/testing/selftests/mm/split_huge_page_test.c  |   71 +
 tools/testing/selftests/mm/thp_settings.c          |   46 +-
 tools/testing/selftests/mm/thp_settings.h          |    9 +-
 tools/testing/selftests/mm/vm_util.c               |   22 +
 tools/testing/selftests/mm/vm_util.h               |    1 +
 tools/testing/selftests/mm/write_to_hugetlbfs.c    |   21 +-
 .../{radix-tree/generated =3D> shared}/autoconf.h    |    0
 tools/testing/{radix-tree =3D> shared}/linux.c       |   26 +-
 tools/testing/{radix-tree =3D> shared}/linux/bug.h   |    0
 tools/testing/{radix-tree =3D> shared}/linux/cpu.h   |    0
 tools/testing/{radix-tree =3D> shared}/linux/idr.h   |    0
 tools/testing/{radix-tree =3D> shared}/linux/init.h  |    0
 .../testing/{radix-tree =3D> shared}/linux/kconfig.h |    0
 .../testing/{radix-tree =3D> shared}/linux/kernel.h  |    0
 .../{radix-tree =3D> shared}/linux/kmemleak.h        |    0
 .../{radix-tree =3D> shared}/linux/local_lock.h      |    0
 .../testing/{radix-tree =3D> shared}/linux/lockdep.h |    0
 .../{radix-tree =3D> shared}/linux/maple_tree.h      |    0
 .../testing/{radix-tree =3D> shared}/linux/percpu.h  |    0
 .../testing/{radix-tree =3D> shared}/linux/preempt.h |    0
 .../{radix-tree =3D> shared}/linux/radix-tree.h      |    0
 .../{radix-tree =3D> shared}/linux/rcupdate.h        |    0
 .../testing/{radix-tree =3D> shared}/linux/xarray.h  |    0
 tools/testing/shared/maple-shared.h                |    9 +
 tools/testing/shared/maple-shim.c                  |    7 +
 tools/testing/shared/shared.h                      |   33 +
 tools/testing/shared/shared.mk                     |   72 +
 .../trace/events/maple_tree.h                      |    0
 tools/testing/shared/xarray-shared.c               |    5 +
 tools/testing/shared/xarray-shared.h               |    4 +
 tools/testing/vma/.gitignore                       |    7 +
 tools/testing/vma/Makefile                         |   18 +
 tools/testing/vma/linux/atomic.h                   |   12 +
 tools/testing/vma/linux/mmzone.h                   |   38 +
 tools/testing/vma/vma.c                            | 1563 ++++++++++++++
 tools/testing/vma/vma_internal.h                   |  923 ++++++++
 virt/kvm/kvm_main.c                                |   19 +-
 379 files changed, 16272 insertions(+), 8493 deletions(-)
 delete mode 100644 Documentation/features/vm/PG_uncached/arch-support.txt
 delete mode 100644 arch/arm64/include/asm/mmzone.h
 delete mode 100644 arch/loongarch/include/asm/mmzone.h
 delete mode 100644 arch/riscv/include/asm/mmzone.h
 delete mode 100644 arch/s390/include/asm/mmzone.h
 delete mode 100644 arch/x86/include/asm/mmzone.h
 delete mode 100644 arch/x86/include/asm/mmzone_32.h
 delete mode 100644 arch/x86/include/asm/mmzone_64.h
 create mode 100644 drivers/block/zram/backend_842.c
 create mode 100644 drivers/block/zram/backend_842.h
 create mode 100644 drivers/block/zram/backend_deflate.c
 create mode 100644 drivers/block/zram/backend_deflate.h
 create mode 100644 drivers/block/zram/backend_lz4.c
 create mode 100644 drivers/block/zram/backend_lz4.h
 create mode 100644 drivers/block/zram/backend_lz4hc.c
 create mode 100644 drivers/block/zram/backend_lz4hc.h
 create mode 100644 drivers/block/zram/backend_lzo.c
 create mode 100644 drivers/block/zram/backend_lzo.h
 create mode 100644 drivers/block/zram/backend_lzorle.c
 create mode 100644 drivers/block/zram/backend_lzorle.h
 create mode 100644 drivers/block/zram/backend_zstd.c
 create mode 100644 drivers/block/zram/backend_zstd.h
 create mode 100644 include/asm-generic/mmzone.h
 create mode 100644 include/linux/numa_memblks.h
 delete mode 100644 kernel/numa.c
 create mode 100644 mm/damon/tests/.kunitconfig
 rename mm/damon/{core-test.h =3D> tests/core-kunit.h} (93%)
 rename mm/damon/{dbgfs-test.h =3D> tests/dbgfs-kunit.h} (94%)
 rename mm/damon/{sysfs-test.h =3D> tests/sysfs-kunit.h} (100%)
 rename mm/damon/{vaddr-test.h =3D> tests/vaddr-kunit.h} (99%)
 create mode 100644 mm/numa.c
 rename {arch/x86/mm =3D> mm}/numa_emulation.c (94%)
 create mode 100644 mm/numa_memblks.c
 create mode 100644 mm/vma.c
 create mode 100644 mm/vma.h
 create mode 100644 mm/vma_internal.h
 mode change 100644 =3D> 100755 tools/testing/selftests/damon/damon_nr_regi=
ons.py
 mode change 100644 =3D> 100755 tools/testing/selftests/damon/damos_apply_i=
nterval.py
 mode change 100644 =3D> 100755 tools/testing/selftests/damon/damos_quota.py
 mode change 100644 =3D> 100755 tools/testing/selftests/damon/damos_quota_g=
oal.py
 mode change 100644 =3D> 100755 tools/testing/selftests/damon/damos_tried_r=
egions.py
 mode change 100644 =3D> 100755 tools/testing/selftests/damon/debugfs_targe=
t_ids_pid_leak.sh
 mode change 100644 =3D> 100755 tools/testing/selftests/damon/debugfs_targe=
t_ids_read_before_terminate_race.sh
 mode change 100644 =3D> 100755 tools/testing/selftests/damon/sysfs_update_=
schemes_tried_regions_hang.py
 mode change 100644 =3D> 100755 tools/testing/selftests/damon/sysfs_update_=
schemes_tried_regions_wss_estimation.py
 rename tools/testing/{radix-tree/generated =3D> shared}/autoconf.h (100%)
 rename tools/testing/{radix-tree =3D> shared}/linux.c (91%)
 rename tools/testing/{radix-tree =3D> shared}/linux/bug.h (100%)
 rename tools/testing/{radix-tree =3D> shared}/linux/cpu.h (100%)
 rename tools/testing/{radix-tree =3D> shared}/linux/idr.h (100%)
 rename tools/testing/{radix-tree =3D> shared}/linux/init.h (100%)
 rename tools/testing/{radix-tree =3D> shared}/linux/kconfig.h (100%)
 rename tools/testing/{radix-tree =3D> shared}/linux/kernel.h (100%)
 rename tools/testing/{radix-tree =3D> shared}/linux/kmemleak.h (100%)
 rename tools/testing/{radix-tree =3D> shared}/linux/local_lock.h (100%)
 rename tools/testing/{radix-tree =3D> shared}/linux/lockdep.h (100%)
 rename tools/testing/{radix-tree =3D> shared}/linux/maple_tree.h (100%)
 rename tools/testing/{radix-tree =3D> shared}/linux/percpu.h (100%)
 rename tools/testing/{radix-tree =3D> shared}/linux/preempt.h (100%)
 rename tools/testing/{radix-tree =3D> shared}/linux/radix-tree.h (100%)
 rename tools/testing/{radix-tree =3D> shared}/linux/rcupdate.h (100%)
 rename tools/testing/{radix-tree =3D> shared}/linux/xarray.h (100%)
 create mode 100644 tools/testing/shared/maple-shared.h
 create mode 100644 tools/testing/shared/maple-shim.c
 create mode 100644 tools/testing/shared/shared.h
 create mode 100644 tools/testing/shared/shared.mk
 rename tools/testing/{radix-tree =3D> shared}/trace/events/maple_tree.h (1=
00%)
 create mode 100644 tools/testing/shared/xarray-shared.c
 create mode 100644 tools/testing/shared/xarray-shared.h
 create mode 100644 tools/testing/vma/.gitignore
 create mode 100644 tools/testing/vma/Makefile
 create mode 100644 tools/testing/vma/linux/atomic.h
 create mode 100644 tools/testing/vma/linux/mmzone.h
 create mode 100644 tools/testing/vma/vma.c
 create mode 100644 tools/testing/vma/vma_internal.h

