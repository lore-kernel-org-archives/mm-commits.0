Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 345EB146018;
	Tue, 19 Nov 2024 03:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731987007; cv=none; b=XtyCgqobFrEf7BzIPVuzJdHoWEXIsGO5BRdHCdtlrLmzilM5vwMrC9MTG8mUJ/DjdZOSuyoACsqj+wzZ5evO312MpoV1PSTAmB1tIN4LLru3vy7GnkfR6roUyZumQweb7p0bc0nlcvY2z/tZvsbXBPq3rjlRFzCF4JsJJv8sPV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731987007; c=relaxed/simple;
	bh=rpjWifyips/opDlK+YGcRclhnkh7tRzs8w2neIkZvSk=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=f61TdHnTBkRXGsoStn5gYYpRVVbpa66Q2Tg9BLcsl+wdHzCgI7uMmvjwDJV7ZSHhFx82A5ww+LmcmTAq8nqxX1A1Q9UP7anQ2kDp5pesYc+P9aRRRpADUnV2Y5zDbxOZezArNCEP/Nfov3XQre0ECBnpmLBM+HDAP+ffgGx2kdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gPQPJH9m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gPQPJH9m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABC0FC4CECF;
	Tue, 19 Nov 2024 03:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731987006;
	bh=rpjWifyips/opDlK+YGcRclhnkh7tRzs8w2neIkZvSk=;
	h=Date:From:To:Cc:Subject:From;
	b=gPQPJH9mEVUzd8MCe/zPM/909UukILgSBfzCl9/XwsK/zEa47n6bVzGNlR5vlqAZU
	 Qu7358GRkZMO42MzwCOwcDif+N/ppr34W3vyd2GH3QyJhB3eZYL4GsbEQFWI/kA87w
	 Y7ee8NguKd5suw5vBPohG2xRSDXGfxnQ2dZ9xFe0=
Date: Mon, 18 Nov 2024 19:30:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] MM updates for 6.13-rc1
Message-Id: <20241118193001.6aefcadd7426feafedf824e1@linux-foundation.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable


Linus, please merge the MM updates for the upcoming dewvelopment cycle,
thanks.


I'm not seeing any conflicts at this time.  Upcoming merge issues along
with their linux-next resolutions are as follows:

kernel/auditsc.c, vs security tree:
https://lkml.kernel.org/r/20241014144648.1923104a@canb.auug.org.au

security/lsm_audit.c, vs security tree:
https://lkml.kernel.org/r/20241023123139.127ad800@canb.auug.org.au

arch/arm64/mm/pageattr.c, vs arm tree:
https://lkml.kernel.org/r/20241024103709.082a6950@canb.auug.org.au

include/linux/mm.h, vs arm tree:
https://lkml.kernel.org/r/20241028111058.4419a9ed@canb.auug.org.au

arch/s390/include/asm/set_memory.h and arch/s390/mm/pageattr.c, vs s390
tree:
https://lkml.kernel.org/r/20241028111606.5c009055@canb.auug.org.au

lib/Makefile, vs asm-generic tree:
https://lkml.kernel.org/r/20241029095525.0fba9d23@canb.auug.org.au

arch/arm64/include/asm/mman.h, vs arm64 tree:
https://lkml.kernel.org/r/20241031104247.65c76c00@canb.auug.org.au

drivers/block/zram/zram_drv.c, vs block tree:
https://lkml.kernel.org/r/20241111135241.1640f547@canb.auug.org.au

arch/s390/mm/pageattr.c, vs s390 tree:
https://lkml.kernel.org/r/20241114101639.282d82a8@canb.auug.org.au



The following changes since commit e7ac4daeed91a25382091e73818ea0cddb1afd5e:

  mm: count zeromap read and set for swapout and swapin (2024-11-11 00:00:3=
7 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2024=
-11-18-19-27

for you to fetch changes up to 2532e6c74a67e65b95f310946e0c0e0a41b3a34b:

  cma: enforce non-zero pageblock_order during cma_init_reserved_mem() (202=
4-11-14 22:49:19 -0800)

----------------------------------------------------------------
- The series "zram: optimal post-processing target selection" from
  Sergey Senozhatsky improves zram's post-processing selection algorithm.
  This leads to improved memory savings.

- Wei Yang has gone to town on the mapletree code, contributing several
  series which clean up the implementation:

	- "refine mas_mab_cp()"
	- "Reduce the space to be cleared for maple_big_node"
	- "maple_tree: simplify mas_push_node()"
	- "Following cleanup after introduce mas_wr_store_type()"
	- "refine storing null"

- The series "selftests/mm: hugetlb_fault_after_madv improvements" from
  David Hildenbrand fixes this selftest for s390.

- The series "introduce pte_offset_map_{ro|rw}_nolock()" from Qi Zheng
  implements some rationaizations and cleanups in the page mapping code.

- The series "mm: optimize shadow entries removal" from Shakeel Butt
  optimizes the file truncation code by speeding up the handling of shadow
  entries.

- The series "Remove PageKsm()" from Matthew Wilcox completes the
  migration of this flag over to being a folio-based flag.

- The series "Unify hugetlb into arch_get_unmapped_area functions" from
  Oscar Salvador implements a bunch of consolidations and cleanups in the
  hugetlb code.

- The series "Do not shatter hugezeropage on wp-fault" from Dev Jain
  takes away the wp-fault time practice of turning a huge zero page into
  small pages.  Instead we replace the whole thing with a THP.  More
  consistent cleaner and potentiall saves a large number of pagefaults.

- The series "percpu: Add a test case and fix for clang" from Andy
  Shevchenko enhances and fixes the kernel's built in percpu test code.

- The series "mm/mremap: Remove extra vma tree walk" from Liam Howlett
  optimizes mremap() by avoiding doing things which we didn't need to do.

- The series "Improve the tmpfs large folio read performance" from
  Baolin Wang teaches tmpfs to copy data into userspace at the folio size
  rather than as individual pages.  A 20% speedup was observed.

- The series "mm/damon/vaddr: Fix issue in
  damon_va_evenly_split_region()" fro Zheng Yejian fixes DAMON splitting.

- The series "memcg-v1: fully deprecate charge moving" from Shakeel Butt
  removes the long-deprecated memcgv2 charge moving feature.

- The series "fix error handling in mmap_region() and refactor" from
  Lorenzo Stoakes cleanup up some of the mmap() error handling and
  addresses some potential performance issues.

- The series "x86/module: use large ROX pages for text allocations" from
  Mike Rapoport teaches x86 to use large pages for read-only-execute
  module text.

- The series "page allocation tag compression" from Suren Baghdasaryan
  is followon maintenance work for the new page allocation profiling
  feature.

- The series "page->index removals in mm" from Matthew Wilcox remove
  most references to page->index in mm/.  A slow march towards shrinking
  struct page.

- The series "damon/{self,kunit}tests: minor fixups for DAMON debugfs
  interface tests" from Andrew Paniakin performs maintenance work for
  DAMON's self testing code.

- The series "mm: zswap swap-out of large folios" from Kanchana Sridhar
  improves zswap's batching of compression and decompression.  It is a
  step along the way towards using Intel IAA hardware acceleration for
  this zswap operation.

- The series "kasan: migrate the last module test to kunit" from
  Sabyrzhan Tasbolatov completes the migration of the KASAN built-in tests
  over to the KUnit framework.

- The series "implement lightweight guard pages" from Lorenzo Stoakes
  permits userapace to place fault-generating guard pages within a single
  VMA, rather than requiring that multiple VMAs be created for this.
  Improved efficiencies for userspace memory allocators are expected.

- The series "memcg: tracepoint for flushing stats" from JP Kobryn uses
  tracepoints to provide increased visibility into memcg stats flushing
  activity.

- The series "zram: IDLE flag handling fixes" from Sergey Senozhatsky
  fixes a zram buglet which potentially affected performance.

- The series "mm: add more kernel parameters to control mTHP" from
  Ma=EDra Canal enhances our ability to control/configuremultisize THP from
  the kernel boot command line.

- The series "kasan: few improvements on kunit tests" from Sabyrzhan
  Tasbolatov has a couple of fixups for the KASAN KUnit tests.

- The series "mm/list_lru: Split list_lru lock into per-cgroup scope"
  from Kairui Song optimizes list_lru memory utilization when lockdep is
  enabled.

----------------------------------------------------------------
Adrian Huang (1):
      mm/vmalloc: combine all TLB flush operations of KASAN shadow virtual =
address into one operation

Alexey Klimov (1):
      MAINTAINERS: mailmap: update Alexey Klimov's email address

Andrew Morton (3):
      Merge branch 'mm-hotfixes-stable' into mm-stable.
      mm/memory.c: remove stray newline at top of file
      Merge branch 'mm-hotfixes-stable' into mm-stable

Andrew Paniakin (1):
      selftests/damon/huge_count_read_write: provide sufficiently large buf=
fer for DEPRECATED file read

Andy Shevchenko (2):
      x86/percpu: fix clang warning when dealing with unsigned types
      percpu: add a test case for the specific 64-bit value addition

Anshuman Khandual (1):
      mm: move set_pxd_safe() helpers from generic to platform

Ba Jing (1):
      selftests/damon/access_memory_even: remove unused variables

Baolin Wang (4):
      mm: shmem: fix khugepaged activation policy for shmem
      mm: shmem: update iocb->ki_pos directly to simplify tmpfs read logic
      mm: shmem: improve the tmpfs large folio read performance
      mm: shmem: fallback to page size splice if large folio has poisoned p=
ages

Barry Song (1):
      mm: add per-order mTHP swpin counters

Bibo Mao (1):
      mm: define general function pXd_init()

Breno Leitao (1):
      mm: remove misleading 'unlikely' hint in vms_gather_munmap_vmas()

Catalin Marinas (1):
      kmemleak: iommu/iova: fix transient kmemleak false positive

Chunyan Zhang (2):
      selftest/mm: fix typo in virtual_address_range
      selftests/mm: skip virtual_address_range tests on riscv

David Hildenbrand (2):
      selftests/mm: hugetlb_fault_after_madv: use default hugetlb page size
      selftests/mm: hugetlb_fault_after_madv: improve test output

Dennis Zhou (1):
      percpu: fix data race with pcpu_nr_empty_pop_pages

Dev Jain (3):
      mm: abstract THP allocation
      mm: allocate THP on hugezeropage wp-fault
      mm: remove redundant condition for THP folio

Geert Uytterhoeven (1):
      zram: ZRAM_DEF_COMP should depend on ZRAM

Hugh Dickins (1):
      mm: delete the unused put_pages_list()

JP Kobryn (2):
      memcg: rename do_flush_stats and add force flag
      memcg: add flush tracepoint

Jaewon Kim (1):
      vmscan: add a vmscan event for reclaim_pages

James Houghton (1):
      mm: add missing mmu_notifier_clear_young for !MMU_NOTIFIER

Jann Horn (1):
      maple_tree: fix outdated flag name in comment

Jiazi Li (2):
      maple_tree: fix alloc node fail issue
      maple_tree: add some alloc node test case

Jim Zhao (1):
      mm/page-writeback: raise wb_thresh to prevent write blocking with str=
ictlimit

Jingxiang Zeng (1):
      mm/memcontrol: add per-memcg pgpgin/pswpin counter

John Hubbard (1):
      kaslr: rename physmem_end and PHYSMEM_END to direct_map_physmem_end

Joshua Hahn (1):
      memcg/hugetlb: add hugeTLB counters to memcg

Kairui Song (7):
      mm/zswap: avoid touching XArray for unnecessary invalidation
      mm/list_lru: don't pass unnecessary key parameters
      mm/list_lru: don't export list_lru_add
      mm/list_lru: code clean up for reparenting
      mm/list_lru: simplify reparenting and initial allocation
      mm/list_lru: split the lock to per-cgroup scope
      mm/list_lru: simplify the list_lru walk callback function

Kanchana P Sridhar (8):
      mm: swap: make some count_mthp_stat() call-sites be THP-agnostic.
      mm: define obj_cgroup_get() if CONFIG_MEMCG is not defined
      mm: zswap: modify zswap_compress() to accept a page instead of a folio
      mm: zswap: rename zswap_pool_get() to zswap_pool_tryget()
      mm: zswap: modify zswap_stored_pages to be atomic_long_t
      mm: zswap: support large folios in zswap_store()
      mm: swap: count successful large folio zswap stores in hugepage zswpo=
ut stats
      mm: zswap: zswap_store_page() will initialize entry after adding to x=
array.

Kefeng Wang (4):
      mm: remove unused hugepage for vma_alloc_folio()
      tmpfs: don't enable large folios if not supported
      mm: huge_memory: move file_thp_enabled() into huge_memory.c
      mm: shmem: remove __shmem_huge_global_enabled()

Leo Stone (1):
      mm/damon: fix sparse warning for zero initializer

Liam R. Howlett (3):
      mm/mremap: cleanup vma_to_resize()
      mm/mremap: remove goto from mremap_to()
      vma: detect infinite loop in vma tree

Liu Jing (1):
      tools/mm: free the allocated memory

Liu Shixin (1):
      zram: fix NULL pointer in comp_algorithm_show()

Lorenzo Stoakes (16):
      selftests/mm: add pkey_sighandler_xx, hugetlb_dio to .gitignore
      mm: refactor mm_access() to not return NULL
      mm/madvise: unrestrict process_madvise() for current process
      maple_tree: do not hash pointers on dump in debug mode
      tools: testing: fix phys_addr_t size on 64-bit systems
      tools: testing: add additional vma_internal.h stubs
      mm: isolate mmap internal logic to mm/vma.c
      mm: refactor __mmap_region()
      mm: remove unnecessary reset state logic on merge new VMA
      mm: defer second attempt at merge on mmap()
      mm: pagewalk: add the ability to install PTEs
      mm: add PTE_MARKER_GUARD PTE marker
      mm: madvise: implement lightweight guard page mechanism
      tools: testing: update tools UAPI header for mman-common.h
      selftests/mm: add self tests for guard page feature
      mm: remove unnecessary page_table_lock on stack expansion

Luoxi Li (1):
      mm: remove unused has_isolate_pageblock

Manas (1):
      mm/memory.c: simplify pfnmap_lockdep_assert

Marc Dionne (1):
      tools/mm: fix slabinfo crash when MAX_SLABS is exceeded

Matthew Wilcox (Oracle) (13):
      ksm: use a folio in try_to_merge_one_page()
      ksm: convert cmp_and_merge_page() to use a folio
      ksm: convert should_skip_rmap_item() to take a folio
      mm: add PageAnonNotKsm()
      mm: remove PageKsm()
      gup: convert FOLL_TOUCH case in follow_page_pte() to folio
      mm: convert page_to_pgoff() to page_pgoff()
      mm: use page_pgoff() in more places
      mm: renovate page_address_in_vma()
      mm: mass constification of folio/page pointers
      bootmem: stop using page->index
      mm: remove references to page->index in huge_memory.c
      mm: use page->private instead of page->index in percpu

Ma=EDra Canal (4):
      mm: shmem: control THP support through the kernel command line
      mm: move ``get_order_from_str()`` to internal.h
      mm: shmem: override mTHP shmem default with a kernel parameter
      mm: huge_memory: use strscpy() instead of strcpy()

MengEn Sun (2):
      mm: add pcp high_min high_max to proc zoneinfo
      vmstat: call fold_vm_zone_numa_events() before show per zone NUMA eve=
nt

Mike Rapoport (Microsoft) (9):
      mm/kmemleak: fix typo in object_no_scan() comment
      mm: vmalloc: group declarations depending on CONFIG_MMU together
      mm: vmalloc: don't account for number of nodes for HUGE_VMAP allocati=
ons
      asm-generic: introduce text-patching.h
      module: prepare to handle ROX allocations for text
      arch: introduce set_direct_map_valid_noflush()
      x86/module: prepare module loading for ROX allocations of text
      execmem: add support for cache of large ROX pages
      x86/module: enable ROX caches for module text on 64 bit

Nanyong Sun (1):
      mm: move mm flags to mm_types.h

Nihar Chaithanya (1):
      kasan: add kunit tests for kmalloc_track_caller, kmalloc_node_track_c=
aller

Nirjhar Roy (1):
      mm/kfence: add a new kunit test test_use_after_free_read_nofault()

Oscar Salvador (9):
      mm/mmap: teach generic_get_unmapped_area{_topdown} to handle hugetlb =
mappings
      arch/s390: teach arch_get_unmapped_area{_topdown} to handle hugetlb m=
appings
      arch/x86: teach arch_get_unmapped_area_vmflags to handle hugetlb mapp=
ings
      arch/sparc: teach arch_get_unmapped_area{_topdown} to handle hugetlb =
mappings
      arch/powerpc: teach book3s64 arch_get_unmapped_area{_topdown} to hand=
le hugetlb mappings
      mm: make hugetlb mappings go through mm_get_unmapped_area_vmflags
      mm: drop hugetlb_get_unmapped_area{_*} functions
      arch/s390: clean up hugetlb definitions
      mm: consolidate common checks in hugetlb_get_unmapped_area

Pankaj Raghav (1):
      mm: don't set readahead flag on a folio when lookahead_size > nr_to_r=
ead

Pintu Kumar (3):
      mm/cma: fix useless return in void function
      zsmalloc: replace kmap_atomic with kmap_local_page
      mm/zsmalloc: use memcpy_from/to_page whereever possible

Qi Zheng (13):
      mm: pgtable: introduce pte_offset_map_{ro|rw}_nolock()
      powerpc: assert_pte_locked() use pte_offset_map_ro_nolock()
      mm: filemap: filemap_fault_recheck_pte_none() use pte_offset_map_ro_n=
olock()
      mm: khugepaged: __collapse_huge_page_swapin() use pte_offset_map_ro_n=
olock()
      arm: adjust_pte() use pte_offset_map_rw_nolock()
      mm: handle_pte_fault() use pte_offset_map_rw_nolock()
      mm: khugepaged: collapse_pte_mapped_thp() use pte_offset_map_rw_noloc=
k()
      mm: copy_pte_range() use pte_offset_map_rw_nolock()
      mm: mremap: move_ptes() use pte_offset_map_rw_nolock()
      mm: page_vma_mapped_walk: map_pte() use pte_offset_map_rw_nolock()
      mm: userfaultfd: move_pages_pte() use pte_offset_map_rw_nolock()
      mm: multi-gen LRU: walk_pte_range() use pte_offset_map_rw_nolock()
      mm: pgtable: remove pte_offset_map_nolock()

Ritesh Harjani (IBM) (1):
      cma: enforce non-zero pageblock_order during cma_init_reserved_mem()

Ryan Roberts (1):
      mm/memcontrol: fix seq_buf size to save memory when PAGE_SIZE is large

Sabyrzhan Tasbolatov (6):
      mm, kasan, kmsan: instrument copy_from/to_kernel_nofault
      kasan: move checks to do_strncpy_from_user
      kasan: migrate copy_user_test to kunit
      kasan: delete CONFIG_KASAN_MODULE_TEST
      kasan: use EXPORT_SYMBOL_IF_KUNIT to export symbols
      kasan: change kasan_atomics kunit test as KUNIT_CASE_SLOW

Saurabh Sengar (1):
      mm/vmstat: defer the refresh_zone_stat_thresholds after all CPUs brin=
gup

SeongJae Park (7):
      selftests/damon/huge_count_read_write: remove unnecessary debugging m=
essage
      selftests/damon/_debugfs_common: hide expected error message from tes=
t_write_result()
      selftests/damon/debugfs_duplicate_context_creation: hide errors from =
expected file write failures
      mm/damon/Kconfig: update DBGFS_KUNIT prompt copy for SYSFS_KUNIT
      mm/damon/tests/dbgfs-kunit: fix the header double inclusion guarding =
ifdef comment
      Docs/mm/damon: recommend academic papers to read and/or cite
      MAINTAINERS/MEMORY MANAGEMENT: add document files for mm

Sergey Senozhatsky (10):
      zram: introduce ZRAM_PP_SLOT flag
      zram: permit only one post-processing operation at a time
      zram: rework recompress target selection strategy
      zram: rework writeback target selection strategy
      zram: do not mark idle slots that cannot be idle
      zram: reshuffle zram_free_page() flags operations
      zram: remove UNDER_WB and simplify writeback
      zram: do not open-code comp priority 0
      zram: clear IDLE flag after recompression
      zram: clear IDLE flag in mark_idle()

Shakeel Butt (11):
      mm: optimize truncation of shadow entries
      mm: optimize invalidation of shadow entries
      mm/truncate: reset xa_has_values flag on each iteration
      memcg: add tracing for memcg stat updates
      memcg-v1: fully deprecate move_charge_at_immigrate
      memcg-v1: remove charge move code
      memcg-v1: no need for memcg locking for dirty tracking
      memcg-v1: no need for memcg locking for writeback tracking
      memcg-v1: no need for memcg locking for MGLRU
      memcg-v1: remove memcg move locking code
      memcg: workingset: remove folio_memcg_rcu usage

Sidhartha Kumar (1):
      maple_tree: refactor mas_wr_store_type()

Sourav Panda (1):
      mm/codetag: fix arg in pgalloc_tag_copy alloc_tag_sub

Suren Baghdasaryan (7):
      maple_tree: add mas_for_each_rev() helper
      alloc_tag: introduce shutdown_mem_profiling helper function
      alloc_tag: load module tags into separate contiguous memory
      alloc_tag: populate memory for module tags as needed
      alloc_tag: introduce pgtag_ref_handle to abstract page tag references
      alloc_tag: support for page allocation tag compression
      mm/codetag: uninline and move pgalloc_tag_copy and pgalloc_tag_split

Tanya Agarwal (1):
      mm/mempolicy: fix comments for better documentation

Thorsten Blum (3):
      mm: swap: use str_true_false() helper function
      mm/page_alloc: use str_off_on() helper in build_all_zonelists()
      mm/show_mem: use str_yes_no() helper in show_free_areas()

Vlastimil Babka (1):
      mm: mmap_lock: check trace_mmap_lock_$type_enabled() instead of regco=
unt

Wei Xu (1):
      mm/mglru: reset page lru tier bits when activating

Wei Yang (16):
      maple_tree: i is always less than or equal to mas_end
      maple_tree: goto complete directly on a pivot of 0
      maple_tree: remove maple_big_node.parent
      maple_tree: memset maple_big_node as a whole
      maple_tree: root node could be handled by !p_slot too
      maple_tree: clear request_count for new allocated one
      maple_tree: total is not changed for nomem_one case
      maple_tree: simplify mas_push_node()
      maple_tree: calculate new_end when needed
      maple_tree: remove sanity check from mas_wr_slot_store()
      mm/vma: the pgoff is correct if can_merge_right
      maple_tree: print empty for an empty tree on mt_dump()
      maple_tree: the return value of mas_root_expand() is not used
      maple_tree: not necessary to check index/last again
      maple_tree: refine mas_store_root() on storing NULL
      maple_tree: add a test checking storing null

Xiu Jianfeng (1):
      memcg: factor out mem_cgroup_stat_aggregate()

Zeng Jingxiang (1):
      mm/vmscan: wake up flushers conditionally to avoid cgroup OOM

Zhaoyang Huang (1):
      mm: migrate LRU_REFS_MASK bits in folio_migrate_flags

Zheng Yejian (2):
      mm/damon/vaddr: fix issue in damon_va_evenly_split_region()
      mm/damon/vaddr: add 'nr_piece =3D=3D 1' check in damon_va_evenly_spli=
t_region()

Zhiguo Jiang (1):
      mm: fix shrink nr.unqueued_dirty counter issue

Zi Yan (1):
      mm: avoid zeroing user movable page twice with init_on_alloc=3D1

suhua (1):
      mm/hugetlb: perform vmemmap optimization batchly for specific node al=
location

zhangguopeng (1):
      mm/memory-failure: replace sprintf() with sysfs_emit()

 .mailmap                                           |    1 +
 Documentation/admin-guide/blockdev/zram.rst        |    2 +
 Documentation/admin-guide/cgroup-v1/memory.rst     |   82 +-
 Documentation/admin-guide/cgroup-v2.rst            |    5 +
 Documentation/admin-guide/kernel-parameters.txt    |   17 +
 Documentation/admin-guide/mm/transhuge.rst         |   35 +-
 Documentation/dev-tools/kasan.rst                  |   23 +-
 Documentation/dev-tools/kmemleak.rst               |    1 +
 Documentation/mm/allocation-profiling.rst          |    7 +-
 Documentation/mm/damon/index.rst                   |    6 +
 Documentation/mm/split_page_table_lock.rst         |    6 +-
 .../translations/zh_CN/dev-tools/kasan.rst         |   20 +-
 .../translations/zh_TW/dev-tools/kasan.rst         |   21 +-
 MAINTAINERS                                        |    8 +-
 arch/Kconfig                                       |    8 +
 arch/alpha/include/asm/Kbuild                      |    1 +
 arch/alpha/include/asm/page.h                      |    2 +-
 arch/alpha/include/uapi/asm/mman.h                 |    3 +
 arch/arc/include/asm/Kbuild                        |    1 +
 arch/arm/include/asm/{patch.h =3D> text-patching.h}  |    0
 arch/arm/kernel/ftrace.c                           |    2 +-
 arch/arm/kernel/jump_label.c                       |    2 +-
 arch/arm/kernel/kgdb.c                             |    2 +-
 arch/arm/kernel/patch.c                            |    2 +-
 arch/arm/mm/fault-armv.c                           |   53 +-
 arch/arm/probes/kprobes/core.c                     |    2 +-
 arch/arm/probes/kprobes/opt-arm.c                  |    2 +-
 arch/arm64/include/asm/memory.h                    |    2 +-
 arch/arm64/include/asm/set_memory.h                |    1 +
 .../include/asm/{patching.h =3D> text-patching.h}    |    0
 arch/arm64/kernel/ftrace.c                         |    2 +-
 arch/arm64/kernel/jump_label.c                     |    2 +-
 arch/arm64/kernel/kgdb.c                           |    2 +-
 arch/arm64/kernel/patching.c                       |    2 +-
 arch/arm64/kernel/probes/kprobes.c                 |    2 +-
 arch/arm64/kernel/traps.c                          |    2 +-
 arch/arm64/mm/fault.c                              |    2 +-
 arch/arm64/mm/pageattr.c                           |   10 +
 arch/arm64/net/bpf_jit_comp.c                      |    2 +-
 arch/csky/include/asm/Kbuild                       |    1 +
 arch/hexagon/include/asm/Kbuild                    |    1 +
 arch/loongarch/include/asm/Kbuild                  |    1 +
 arch/loongarch/include/asm/hugetlb.h               |    5 -
 arch/loongarch/include/asm/pgtable.h               |    3 +
 arch/loongarch/include/asm/set_memory.h            |    1 +
 arch/loongarch/mm/pageattr.c                       |   19 +
 arch/m68k/include/asm/Kbuild                       |    1 +
 arch/m68k/include/asm/page_no.h                    |    2 +-
 arch/microblaze/include/asm/Kbuild                 |    1 +
 arch/mips/include/asm/Kbuild                       |    1 +
 arch/mips/include/asm/hugetlb.h                    |    5 -
 arch/mips/include/asm/pgtable-64.h                 |    2 +
 arch/mips/include/uapi/asm/mman.h                  |    3 +
 arch/nios2/include/asm/Kbuild                      |    1 +
 arch/openrisc/include/asm/Kbuild                   |    1 +
 arch/parisc/include/asm/hugetlb.h                  |   15 -
 .../include/asm/{patch.h =3D> text-patching.h}       |    0
 arch/parisc/include/uapi/asm/mman.h                |    3 +
 arch/parisc/kernel/ftrace.c                        |    2 +-
 arch/parisc/kernel/jump_label.c                    |    2 +-
 arch/parisc/kernel/kgdb.c                          |    2 +-
 arch/parisc/kernel/kprobes.c                       |    2 +-
 arch/parisc/kernel/patch.c                         |    2 +-
 arch/parisc/mm/hugetlbpage.c                       |   21 -
 arch/powerpc/include/asm/kprobes.h                 |    2 +-
 .../asm/{code-patching.h =3D> text-patching.h}       |    0
 arch/powerpc/kernel/crash_dump.c                   |    2 +-
 arch/powerpc/kernel/epapr_paravirt.c               |    2 +-
 arch/powerpc/kernel/jump_label.c                   |    2 +-
 arch/powerpc/kernel/kgdb.c                         |    2 +-
 arch/powerpc/kernel/kprobes.c                      |    2 +-
 arch/powerpc/kernel/module_32.c                    |    2 +-
 arch/powerpc/kernel/module_64.c                    |    2 +-
 arch/powerpc/kernel/optprobes.c                    |    2 +-
 arch/powerpc/kernel/process.c                      |    2 +-
 arch/powerpc/kernel/security.c                     |    2 +-
 arch/powerpc/kernel/setup_32.c                     |    2 +-
 arch/powerpc/kernel/setup_64.c                     |    2 +-
 arch/powerpc/kernel/static_call.c                  |    2 +-
 arch/powerpc/kernel/trace/ftrace.c                 |    2 +-
 arch/powerpc/kernel/trace/ftrace_64_pg.c           |    2 +-
 arch/powerpc/lib/code-patching.c                   |    2 +-
 arch/powerpc/lib/feature-fixups.c                  |    2 +-
 arch/powerpc/lib/test-code-patching.c              |    2 +-
 arch/powerpc/lib/test_emulate_step.c               |    2 +-
 arch/powerpc/mm/book3s32/mmu.c                     |    2 +-
 arch/powerpc/mm/book3s64/hash_utils.c              |    2 +-
 arch/powerpc/mm/book3s64/slb.c                     |    2 +-
 arch/powerpc/mm/book3s64/slice.c                   |   50 +-
 arch/powerpc/mm/kasan/init_32.c                    |    2 +-
 arch/powerpc/mm/mem.c                              |    2 +-
 arch/powerpc/mm/nohash/44x.c                       |    2 +-
 arch/powerpc/mm/nohash/book3e_pgtable.c            |    2 +-
 arch/powerpc/mm/nohash/tlb.c                       |    2 +-
 arch/powerpc/mm/nohash/tlb_64e.c                   |    2 +-
 arch/powerpc/mm/pgtable.c                          |    2 +-
 arch/powerpc/net/bpf_jit_comp.c                    |    2 +-
 arch/powerpc/perf/8xx-pmu.c                        |    2 +-
 arch/powerpc/perf/core-book3s.c                    |    2 +-
 arch/powerpc/platforms/85xx/smp.c                  |    2 +-
 arch/powerpc/platforms/86xx/mpc86xx_smp.c          |    2 +-
 arch/powerpc/platforms/cell/smp.c                  |    2 +-
 arch/powerpc/platforms/powermac/smp.c              |    2 +-
 arch/powerpc/platforms/powernv/idle.c              |    2 +-
 arch/powerpc/platforms/powernv/smp.c               |    2 +-
 arch/powerpc/platforms/pseries/smp.c               |    2 +-
 arch/powerpc/xmon/xmon.c                           |    2 +-
 arch/riscv/errata/andes/errata.c                   |    2 +-
 arch/riscv/errata/sifive/errata.c                  |    2 +-
 arch/riscv/errata/thead/errata.c                   |    2 +-
 arch/riscv/include/asm/pgtable.h                   |   19 +
 arch/riscv/include/asm/set_memory.h                |    1 +
 .../riscv/include/asm/{patch.h =3D> text-patching.h} |    0
 arch/riscv/include/asm/uprobes.h                   |    2 +-
 arch/riscv/kernel/alternative.c                    |    2 +-
 arch/riscv/kernel/cpufeature.c                     |    3 +-
 arch/riscv/kernel/ftrace.c                         |    2 +-
 arch/riscv/kernel/jump_label.c                     |    2 +-
 arch/riscv/kernel/patch.c                          |    2 +-
 arch/riscv/kernel/probes/kprobes.c                 |    2 +-
 arch/riscv/mm/pageattr.c                           |   15 +
 arch/riscv/net/bpf_jit_comp64.c                    |    2 +-
 arch/riscv/net/bpf_jit_core.c                      |    2 +-
 arch/s390/include/asm/hugetlb.h                    |   73 +-
 arch/s390/include/asm/page.h                       |    2 +-
 arch/s390/include/asm/set_memory.h                 |    1 +
 arch/s390/mm/hugetlbpage.c                         |   85 --
 arch/s390/mm/mmap.c                                |    9 +-
 arch/s390/mm/pageattr.c                            |   11 +
 arch/sh/include/asm/Kbuild                         |    1 +
 arch/sh/include/asm/hugetlb.h                      |   15 -
 arch/sparc/include/asm/Kbuild                      |    1 +
 arch/sparc/kernel/sys_sparc_32.c                   |   17 +-
 arch/sparc/kernel/sys_sparc_64.c                   |   37 +-
 arch/sparc/mm/hugetlbpage.c                        |  108 --
 arch/um/kernel/um_arch.c                           |   16 +-
 arch/x86/Kconfig                                   |    1 +
 arch/x86/entry/vdso/vma.c                          |    3 +-
 arch/x86/include/asm/alternative.h                 |   14 +-
 arch/x86/include/asm/page.h                        |    2 +-
 arch/x86/include/asm/page_64.h                     |    2 +-
 arch/x86/include/asm/percpu.h                      |    7 +-
 arch/x86/include/asm/pgtable.h                     |   37 +
 arch/x86/include/asm/pgtable_64_types.h            |    2 +-
 arch/x86/include/asm/set_memory.h                  |    1 +
 arch/x86/include/asm/text-patching.h               |    1 +
 arch/x86/kernel/alternative.c                      |  181 +--
 arch/x86/kernel/ftrace.c                           |   30 +-
 arch/x86/kernel/module.c                           |   45 +-
 arch/x86/kernel/sys_x86_64.c                       |   24 +-
 arch/x86/mm/hugetlbpage.c                          |  101 --
 arch/x86/mm/init.c                                 |   37 +-
 arch/x86/mm/init_64.c                              |   30 +-
 arch/x86/mm/kaslr.c                                |   14 +-
 arch/x86/mm/pat/set_memory.c                       |    8 +
 arch/xtensa/include/asm/Kbuild                     |    1 +
 arch/xtensa/include/uapi/asm/mman.h                |    3 +
 drivers/android/binder_alloc.c                     |    8 +-
 drivers/android/binder_alloc.h                     |    2 +-
 drivers/block/zram/Kconfig                         |    1 +
 drivers/block/zram/zram_drv.c                      |  384 ++++--
 drivers/block/zram/zram_drv.h                      |    3 +-
 drivers/iommu/iova.c                               |    6 +
 fs/buffer.c                                        |    5 -
 fs/dcache.c                                        |    4 +-
 fs/gfs2/quota.c                                    |    2 +-
 fs/hugetlbfs/inode.c                               |   94 +-
 fs/inode.c                                         |    5 +-
 fs/nfs/nfs42xattr.c                                |    4 +-
 fs/nfsd/filecache.c                                |    5 +-
 fs/proc/base.c                                     |   26 +-
 fs/proc/meminfo.c                                  |    2 +-
 fs/xfs/xfs_buf.c                                   |    2 -
 fs/xfs/xfs_qm.c                                    |    6 +-
 include/asm-generic/codetag.lds.h                  |   19 +
 include/asm-generic/hugetlb.h                      |   15 +-
 include/asm-generic/text-patching.h                |    5 +
 include/linux/alloc_tag.h                          |   21 +-
 include/linux/bootmem_info.h                       |   35 +-
 include/linux/codetag.h                            |   40 +-
 include/linux/execmem.h                            |   49 +
 include/linux/gfp.h                                |    6 +-
 include/linux/highmem.h                            |    8 +-
 include/linux/huge_mm.h                            |   16 +-
 include/linux/hugetlb.h                            |   22 +-
 include/linux/kasan.h                              |   12 +-
 include/linux/khugepaged.h                         |    2 -
 include/linux/kmemleak.h                           |    4 +
 include/linux/ksm.h                                |    8 +-
 include/linux/list_lru.h                           |   26 +-
 include/linux/maple_tree.h                         |   16 +-
 include/linux/memcontrol.h                         |   97 +-
 include/linux/mempolicy.h                          |    2 +-
 include/linux/mm.h                                 |   77 +-
 include/linux/mm_inline.h                          |   27 +-
 include/linux/mm_types.h                           |   84 ++
 include/linux/mmu_notifier.h                       |    7 +
 include/linux/mmzone.h                             |    5 +
 include/linux/module.h                             |   16 +
 include/linux/moduleloader.h                       |    4 +
 include/linux/oom.h                                |    1 -
 include/linux/page-flags-layout.h                  |    7 +
 include/linux/page-flags.h                         |   18 +-
 include/linux/page-isolation.h                     |    8 -
 include/linux/pagemap.h                            |   31 +-
 include/linux/pagewalk.h                           |   18 +-
 include/linux/pgalloc_tag.h                        |  202 +++-
 include/linux/pgtable.h                            |   59 +-
 include/linux/rmap.h                               |   17 +-
 include/linux/sched/coredump.h                     |   82 --
 include/linux/set_memory.h                         |    6 +
 include/linux/shmem_fs.h                           |    6 +
 include/linux/swapops.h                            |   24 +-
 include/linux/text-patching.h                      |   15 +
 include/linux/vmalloc.h                            |   63 +-
 include/linux/zswap.h                              |    2 +-
 include/trace/events/memcg.h                       |  106 ++
 include/trace/events/mmap_lock.h                   |   14 +-
 include/trace/events/vmscan.h                      |   45 +
 include/uapi/asm-generic/mman-common.h             |    3 +
 kernel/events/uprobes.c                            |    1 -
 kernel/fork.c                                      |    6 +-
 kernel/futex/core.c                                |    2 +-
 kernel/module/debug_kmemleak.c                     |    3 +-
 kernel/module/main.c                               |  148 ++-
 kernel/module/strict_rwx.c                         |    3 +
 kernel/resource.c                                  |    4 +-
 lib/Kconfig.debug                                  |    1 +
 lib/Kconfig.kasan                                  |    7 -
 lib/alloc_tag.c                                    |  515 +++++++-
 lib/codetag.c                                      |  104 +-
 lib/maple_tree.c                                   |  249 ++--
 lib/percpu_test.c                                  |   11 +-
 lib/strncpy_from_user.c                            |    5 +-
 lib/test_maple_tree.c                              |   90 ++
 mm/bootmem_info.c                                  |   11 +-
 mm/cma.c                                           |   12 +-
 mm/damon/Kconfig                                   |    2 +-
 mm/damon/tests/dbgfs-kunit.h                       |    2 +-
 mm/damon/tests/vaddr-kunit.h                       |    4 +-
 mm/damon/vaddr.c                                   |    9 +-
 mm/execmem.c                                       |  352 +++++-
 mm/filemap.c                                       |    5 +-
 mm/gup.c                                           |    8 +-
 mm/huge_memory.c                                   |  227 ++--
 mm/hugetlb.c                                       |   17 +-
 mm/internal.h                                      |   52 +-
 mm/kasan/Makefile                                  |    2 -
 mm/kasan/hw_tags.c                                 |    7 +-
 mm/kasan/init.c                                    |   12 -
 mm/kasan/kasan.h                                   |    2 +-
 mm/kasan/kasan_test_c.c                            |  118 +-
 mm/kasan/kasan_test_module.c                       |   81 --
 mm/kasan/report.c                                  |   19 +-
 mm/kasan/shadow.c                                  |   14 +-
 mm/kfence/kfence_test.c                            |   17 +
 mm/khugepaged.c                                    |   31 +-
 mm/kmemleak.c                                      |   41 +-
 mm/kmsan/kmsan_test.c                              |   17 +
 mm/ksm.c                                           |  111 +-
 mm/list_lru.c                                      |  383 +++---
 mm/maccess.c                                       |   11 +-
 mm/madvise.c                                       |  298 ++++-
 mm/memcontrol-v1.c                                 |  983 +---------------
 mm/memcontrol-v1.h                                 |    6 -
 mm/memcontrol.c                                    |  210 ++--
 mm/memory-failure.c                                |   32 +-
 mm/memory.c                                        |   67 +-
 mm/memory_hotplug.c                                |    2 +-
 mm/mempolicy.c                                     |    7 +-
 mm/migrate.c                                       |    3 +-
 mm/mm_init.c                                       |    5 +-
 mm/mmap.c                                          |  276 +----
 mm/mmap_lock.c                                     |   39 +-
 mm/mprotect.c                                      |    6 +-
 mm/mremap.c                                        |  104 +-
 mm/mseal.c                                         |    1 +
 mm/oom_kill.c                                      |    1 -
 mm/page-writeback.c                                |   45 +-
 mm/page_alloc.c                                    |    2 +-
 mm/page_io.c                                       |   10 +-
 mm/page_vma_mapped.c                               |   32 +-
 mm/pagewalk.c                                      |  246 ++--
 mm/percpu.c                                        |   11 +-
 mm/pgtable-generic.c                               |   41 +-
 mm/process_vm_access.c                             |    4 +-
 mm/readahead.c                                     |   15 +-
 mm/rmap.c                                          |   45 +-
 mm/shmem.c                                         |  345 ++++--
 mm/show_mem.c                                      |    3 +-
 mm/sparse-vmemmap.c                                |   12 -
 mm/sparse.c                                        |   10 +-
 mm/swap.c                                          |   31 -
 mm/swap_state.c                                    |    3 +-
 mm/truncate.c                                      |  103 +-
 mm/userfaultfd.c                                   |   17 +-
 mm/util.c                                          |    2 +-
 mm/vma.c                                           |  447 ++++++-
 mm/vma.h                                           |   97 +-
 mm/vma_internal.h                                  |    5 +
 mm/vmalloc.c                                       |   52 +-
 mm/vmscan.c                                        |   68 +-
 mm/vmstat.c                                        |   28 +-
 mm/workingset.c                                    |   34 +-
 mm/zsmalloc.c                                      |   86 +-
 mm/zswap.c                                         |  245 ++--
 scripts/module.lds.S                               |    5 +-
 tools/include/uapi/asm-generic/mman-common.h       |    3 +
 tools/mm/page_owner_sort.c                         |    1 +
 tools/mm/slabinfo.c                                |   10 +-
 tools/testing/radix-tree/maple.c                   |   22 +
 tools/testing/selftests/damon/_debugfs_common.sh   |    7 +-
 tools/testing/selftests/damon/access_memory_even.c |    2 -
 .../damon/debugfs_duplicate_context_creation.sh    |    2 +-
 .../selftests/damon/huge_count_read_write.c        |    4 +-
 tools/testing/selftests/mm/.gitignore              |    4 +
 tools/testing/selftests/mm/Makefile                |    3 +
 tools/testing/selftests/mm/guard-pages.c           | 1243 ++++++++++++++++=
++++
 .../selftests/mm/hugetlb_fault_after_madv.c        |   48 +-
 tools/testing/selftests/mm/run_vmtests.sh          |   10 +-
 tools/testing/selftests/mm/virtual_address_range.c |    4 +-
 tools/testing/shared/shared.mk                     |    1 +
 tools/testing/vma/vma.c                            |    2 +
 tools/testing/vma/vma_internal.h                   |  115 +-
 324 files changed, 7348 insertions(+), 4394 deletions(-)
 rename arch/arm/include/asm/{patch.h =3D> text-patching.h} (100%)
 rename arch/arm64/include/asm/{patching.h =3D> text-patching.h} (100%)
 rename arch/parisc/include/asm/{patch.h =3D> text-patching.h} (100%)
 rename arch/powerpc/include/asm/{code-patching.h =3D> text-patching.h} (10=
0%)
 rename arch/riscv/include/asm/{patch.h =3D> text-patching.h} (100%)
 create mode 100644 include/asm-generic/text-patching.h
 create mode 100644 include/linux/text-patching.h
 create mode 100644 include/trace/events/memcg.h
 delete mode 100644 mm/kasan/kasan_test_module.c
 create mode 100644 tools/testing/selftests/mm/guard-pages.c

