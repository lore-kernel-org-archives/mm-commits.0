Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFECF64D;
	Sat, 18 May 2024 02:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715998961; cv=none; b=F81q+y7OIh1rgcbgoW53ofRK+yYd6FMLE+x5/ROj49ewGgDlCaqgPbM6fLcoRTDYUIb/F0q58QzDfwEPm5pR+mQzzTHNDbJzLEG2qEkYMJn6pRtPQUyaRr5qk9BVUMJzs2yuWwecHOz698yiaWnlJihGGsIVSbkPRFdwLBcjLGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715998961; c=relaxed/simple;
	bh=0fDudgz10RWJgzoSimnR2mjvE92ZUiYxVs58B/Jjlok=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=EbEl5RUs1pznqW/cU5fJDJlPdmO7A2LyAOEKPcex2QMYJq8acww8Bd6kCkt5nzLGd+wj903ie8DY225wHAXlQQaPY0LcY9TZkcA1XH7MdDq7CBDX4t34rKg6ALxvsGfgvO3b691iSm2BgcwXFyOQEW8kns2jXd24l2g5CscL5TU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CG37Pife; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CG37Pife"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68DCBC2BD10;
	Sat, 18 May 2024 02:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1715998960;
	bh=0fDudgz10RWJgzoSimnR2mjvE92ZUiYxVs58B/Jjlok=;
	h=Date:From:To:Cc:Subject:From;
	b=CG37PifeWk0aBKLivbSWQIcgMlSZzkNfmtsc4shLs4KLju1KIkiTedc0bg2O0FDiS
	 GrP4D6f2zvhB4Q9ZeKO6dYx5O3np7pPtloO1IR2i5HjPVfXi3cKRDTyhHqDQk+Gagf
	 ihKGMSiMdaOagPiaSZHamx+eti6Du7HLDpz/H53w=
Date: Fri, 17 May 2024 19:22:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] MM updates for 6.10-rc1
Message-Id: <20240517192239.9285edd85f8ef893bb508a61@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Linus, please merge this cycle's batch of MM updates, thanks.

Conflicts with your current tree and their linux-next resolution are:

tools/testing/selftests/mm/soft-dirty.c
	https://lkml.kernel.org/r/20240426154414.4d408fd7@canb.auug.org.au

	The linux-next dicsussion isn't very helpful here.  The fix is to use
	ksft_finished().

kernel/module/main.c
	https://lkml.kernel.org/r/20240412120421.27d86c34@canb.auug.org.au

io_uring/io_uring.c
	https://lkml.kernel.org/r/20240402112746.3864d8a6@canb.auug.org.au

include/linux/slab.h
	https://lkml.kernel.org/r/20240429114302.7af809e8@canb.auug.org.au

arch/powerpc/mm/mem.c
	https://lkml.kernel.org/r/20240424122034.5b4a1a01@canb.auug.org.au


and forthcoming merge issues which I know of are:

arch/x86/mm/numa_32.c, vs tip tree
	https://lkml.kernel.org/r/20240405115111.132053a5@canb.auug.org.au

drivers/iommu/amd/amd_iommu.h, vs iommu tree:
	https://lkml.kernel.org/r/20240416132223.30cfa738@canb.auug.org.au

drivers/virtio/virtio_mem.c, vs vhost tree:
	https://lkml.kernel.org/r/20240423145947.142171f6@canb.auug.org.au

include/linux/kfifo.c, lib/kfifo.c, vs tty tree:
	https://lkml.kernel.org/r/20240426145540.1593f8f4@canb.auug.org.au

arch/um/include/shared/um_malloc.h, vs uml tree:
	https://lkml.kernel.org/r/20240501091942.1999963d@canb.auug.org.au

init/main.c, vs ftrace tree:
	https://lkml.kernel.org/r/20240515123758.30904383@canb.auug.org.au


The following changes since commit 5d1bc760583f225032f91bd88853f4c26acaf4e0:

  merge mm-hotfixes-stable into mm-nonmm-stable to pick up needed changes (2024-04-25 20:54:12 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2024-05-17-19-19

for you to fetch changes up to 76edc534cc289308130272a2ac28694fc9b72a03:

  memcg, oom: cleanup unused memcg_oom_gfp_mask and memcg_oom_order (2024-05-11 15:41:37 -0700)

----------------------------------------------------------------
The usual shower of singleton fixes and minor series all over MM,
documented (hopefully adequately) in the respective changelogs.  Notable
series include:

- Lucas Stach has provided some page-mapping
  cleanup/consolidation/maintainability work in the series "mm/treewide:
  Remove pXd_huge() API".

- In the series "Allow migrate on protnone reference with
  MPOL_PREFERRED_MANY policy", Donet Tom has optimized mempolicy's
  MPOL_PREFERRED_MANY mode, yielding almost doubled performance in one
  test.

- In their series "Memory allocation profiling" Kent Overstreet and
  Suren Baghdasaryan have contributed a means of determining (via
  /proc/allocinfo) whereabouts in the kernel memory is being allocated:
  number of calls and amount of memory.

- Matthew Wilcox has provided the series "Various significant MM
  patches" which does a number of rather unrelated things, but in largely
  similar code sites.

- In his series "mm: page_alloc: freelist migratetype hygiene" Johannes
  Weiner has fixed the page allocator's handling of migratetype requests,
  with resulting improvements in compaction efficiency.

- In the series "make the hugetlb migration strategy consistent" Baolin
  Wang has fixed a hugetlb migration issue, which should improve hugetlb
  allocation reliability.

- Liu Shixin has hit an I/O meltdown caused by readahead in a
  memory-tight memcg.  Addressed in the series "Fix I/O high when memory
  almost met memcg limit".

- In the series "mm/filemap: optimize folio adding and splitting" Kairui
  Song has optimized pagecache insertion, yielding ~10% performance
  improvement in one test.

- Baoquan He has cleaned up and consolidated the early zone
  initialization code in the series "mm/mm_init.c: refactor
  free_area_init_core()".

- Baoquan has also redone some MM initializatio code in the series
  "mm/init: minor clean up and improvement".

- MM helper cleanups from Christoph Hellwig in his series "remove
  follow_pfn".

- More cleanups from Matthew Wilcox in the series "Various page->flags
  cleanups".

- Vlastimil Babka has contributed maintainability improvements in the
  series "memcg_kmem hooks refactoring".

- More folio conversions and cleanups in Matthew Wilcox's series

	"Convert huge_zero_page to huge_zero_folio"
	"khugepaged folio conversions"
	"Remove page_idle and page_young wrappers"
	"Use folio APIs in procfs"
	"Clean up __folio_put()"
	"Some cleanups for memory-failure"
	"Remove page_mapping()"
	"More folio compat code removal"

- David Hildenbrand chipped in with "fs/proc/task_mmu: convert hugetlb
  functions to work on folis".

- Code consolidation and cleanup work related to GUP's handling of
  hugetlbs in Peter Xu's series "mm/gup: Unify hugetlb, part 2".

- Rick Edgecombe has developed some fixes to stack guard gaps in the
  series "Cover a guard gap corner case".

- Jinjiang Tu has fixed KSM's behaviour after a fork+exec in the series
  "mm/ksm: fix ksm exec support for prctl".

- Baolin Wang has implemented NUMA balancing for multi-size THPs.  This
  is a simple first-cut implementation for now.  The series is "support
  multi-size THP numa balancing".

- Cleanups to vma handling helper functions from Matthew Wilcox in the
  series "Unify vma_address and vma_pgoff_address".

- Some selftests maintenance work from Dev Jain in the series
  "selftests/mm: mremap_test: Optimizations and style fixes".

- Improvements to the swapping of multi-size THPs from Ryan Roberts in
  the series "Swap-out mTHP without splitting".

- Kefeng Wang has significantly optimized the handling of arm64's
  permission page faults in the series

	"arch/mm/fault: accelerate pagefault when badaccess"
	"mm: remove arch's private VM_FAULT_BADMAP/BADACCESS"

- GUP cleanups from David Hildenbrand in "mm/gup: consistently call it
  GUP-fast".

- hugetlb fault code cleanups from Vishal Moola in "Hugetlb fault path to
  use struct vm_fault".

- selftests build fixes from John Hubbard in the series "Fix
  selftests/mm build without requiring "make headers"".

- Memory tiering fixes/improvements from Ho-Ren (Jack) Chuang in the
  series "Improved Memory Tier Creation for CPUless NUMA Nodes".  Fixes
  the initialization code so that migration between different memory types
  works as intended.

- David Hildenbrand has improved follow_pte() and fixed an errant driver
  in the series "mm: follow_pte() improvements and acrn follow_pte()
  fixes".

- David also did some cleanup work on large folio mapcounts in his
  series "mm: mapcount for large folios + page_mapcount() cleanups".

- Folio conversions in KSM in Alex Shi's series "transfer page to folio
  in KSM".

- Barry Song has added some sysfs stats for monitoring multi-size THP's
  in the series "mm: add per-order mTHP alloc and swpout counters".

- Some zswap cleanups from Yosry Ahmed in the series "zswap same-filled
  and limit checking cleanups".

- Matthew Wilcox has been looking at buffer_head code and found the
  documentation to be lacking.  The series is "Improve buffer head
  documentation".

- Multi-size THPs get more work, this time from Lance Yang.  His series
  "mm/madvise: enhance lazyfreeing with mTHP in madvise_free" optimizes
  the freeing of these things.

- Kemeng Shi has added more userspace-visible writeback instrumentation
  in the series "Improve visibility of writeback".

- Kemeng Shi then sent some maintenance work on top in the series "Fix
  and cleanups to page-writeback".

- Matthew Wilcox reduces mmap_lock traffic in the anon vma code in the
  series "Improve anon_vma scalability for anon VMAs".  Intel's test bot
  reported an improbable 3x improvement in one test.

- SeongJae Park adds some DAMON feature work in the series

	"mm/damon: add a DAMOS filter type for page granularity access recheck"
	"selftests/damon: add DAMOS quota goal test"

- Also some maintenance work in the series

	"mm/damon/paddr: simplify page level access re-check for pageout"
	"mm/damon: misc fixes and improvements"

- David Hildenbrand has disabled some known-to-fail selftests ni the
  series "selftests: mm: cow: flag vmsplice() hugetlb tests as XFAIL".

- memcg metadata storage optimizations from Shakeel Butt in "memcg:
  reduce memory consumption by memcg stats".

- DAX fixes and maintenance work from Vishal Verma in the series
  "dax/bus.c: Fixups for dax-bus locking".

----------------------------------------------------------------
Alex Rusuf (1):
      mm/damon/core: fix return value from damos_wmark_metric_value

Alex Shi (tencent) (9):
      mm/ksm: add ksm_get_folio
      mm/ksm: use folio in remove_rmap_item_from_tree
      mm/ksm: add folio_set_stable_node
      mm/ksm: use folio in remove_stable_node
      mm/ksm: use folio in stable_node_dup
      mm/ksm: use ksm_get_folio in scan_get_next_rmap_item
      mm/ksm: use folio in write_protect_page
      mm/ksm: convert chain series funcs and replace get_ksm_page
      mm/ksm: replace set_page_stable_node by folio_set_stable_node

Andy Shevchenko (2):
      xarray: use BITS_PER_LONGS()
      xarray: don't use "proxy" headers

Baolin Wang (9):
      mm: record the migration reason for struct migration_target_control
      mm: hugetlb: make the hugetlb migration strategy consistent
      docs: hugetlbpage.rst: add hugetlb migration description
      mm: factor out the numa mapping rebuilding into a new helper
      mm: support multi-size THP numa balancing
      mm: huge_memory: add the missing folio_test_pmd_mappable() for THP split statistics
      mm: page_alloc: use the correct THP order for THP PCP
      mm: set pageblock_order to HPAGE_PMD_ORDER in case with !CONFIG_HUGETLB_PAGE but THP enabled
      mm: page_alloc: allowing mTHP compaction to capture the freed page directly

Baoquan He (14):
      mm/vmalloc.c: optimize to reduce arguments of alloc_vmap_area()
      x86: remove unneeded memblock_find_dma_reserve()
      mm/mm_init.c: remove the useless dma_reserve
      mm/mm_init.c: add new function calc_nr_all_pages()
      mm/mm_init.c: remove meaningless calculation of zone->managed_pages in free_area_init_core()
      mm/mm_init.c: remove unneeded calc_memmap_size()
      mm/mm_init.c: remove arch_reserved_kernel_pages()
      mm: move array mem_section init code out of memory_present()
      mm/init: remove the unnecessary special treatment for memory-less node
      mm: make __absent_pages_in_range() as static
      mm/page_alloc.c: remove unneeded codes in !NUMA version of build_zonelists()
      mm/mm_init.c: remove the outdated code comment above deferred_grow_zone()
      mm/page_alloc.c: don't show protection in zone's ->lowmem_reserve[] for empty zone
      mm/page_alloc.c: change the array-length to MIGRATE_PCPTYPES

Barry Song (7):
      arm64: mm: swap: support THP_SWAP on hardware with MTE
      mm: hold PTL from the first PTE while reclaiming a large folio
      mm: alloc_anon_folio: avoid doing vma_thp_gfp_mask in fallback cases
      mm: add per-order mTHP anon_fault_alloc and anon_fault_fallback counters
      mm: add per-order mTHP anon_swpout and anon_swpout_fallback counters
      mm: add docs for per-order mTHP counters and transhuge_page ABI
      mm: correct the docs for thp_fault_alloc and thp_fault_fallback

Breno Leitao (2):
      memcg: fix data-race KCSAN bug in rstats
      mm: memcg: use READ_ONCE()/WRITE_ONCE() to access stock->nr_pages

Chris Li (1):
      zswap: replace RB tree with xarray

Christoph Hellwig (3):
      virt: acrn: stop using follow_pfn
      mm: remove follow_pfn
      mm: move follow_phys to arch/x86/mm/pat/memtype.c

Christophe Leroy (1):
      mm: remove guard around pgd_offset_k() macro

David Hildenbrand (39):
      mm/madvise: don't perform madvise VMA walk for MADV_POPULATE_(READ|WRITE)
      mm: convert folio_estimated_sharers() to folio_likely_mapped_shared()
      selftests/memfd_secret: add vmsplice() test
      mm: merge folio_is_secretmem() and folio_fast_pin_allowed() into gup_fast_folio_allowed()
      mm: optimize CONFIG_PER_VMA_LOCK member placement in vm_area_struct
      mm: remove "prot" parameter from move_pte()
      mm/gup: consistently name GUP-fast functions
      mm/treewide: rename CONFIG_HAVE_FAST_GUP to CONFIG_HAVE_GUP_FAST
      mm: use "GUP-fast" instead "fast GUP" in remaining comments
      drivers/virt/acrn: fix PFNMAP PTE checks in acrn_vm_ram_map()
      mm: pass VMA instead of MM to follow_pte()
      mm: follow_pte() improvements
      mm: allow for detecting underflows with page_mapcount() again
      mm/rmap: always inline anon/file rmap duplication of a single PTE
      mm/rmap: add fast-path for small folios when adding/removing/duplicating
      mm: track mapcount of large folios in single value
      mm: improve folio_likely_mapped_shared() using the mapcount of large folios
      mm: make folio_mapcount() return 0 for small typed folios
      mm/memory: use folio_mapcount() in zap_present_folio_ptes()
      mm/huge_memory: use folio_mapcount() in zap_huge_pmd() sanity check
      mm/memory-failure: use folio_mapcount() in hwpoison_user_mappings()
      mm/page_alloc: use folio_mapped() in __alloc_contig_migrate_range()
      mm/migrate: use folio_likely_mapped_shared() in add_page_for_migration()
      sh/mm/cache: use folio_mapped() in copy_from_user_page()
      mm/filemap: use folio_mapcount() in filemap_unaccount_folio()
      mm/migrate_device: use folio_mapcount() in migrate_vma_check_page()
      trace/events/page_ref: trace the raw page mapcount value
      xtensa/mm: convert check_tlb_entry() to sanity check folios
      mm/debug: print only page mapcount (excluding folio entire mapcount) in __dump_folio()
      Documentation/admin-guide/cgroup-v1/memory.rst: don't reference page_mapcount()
      mm/ksm: rename get_ksm_page_flags to ksm_get_folio_flags
      mm/ksm: remove page_mapcount() usage in stable_tree_search()
      fs/proc/task_mmu: convert pagemap_hugetlb_range() to work on folios
      fs/proc/task_mmu: convert smaps_hugetlb_range() to work on folios
      mm/huge_memory: improve split_huge_page_to_list_to_order() return value documentation
      mm/khugepaged: replace page_mapcount() check by folio_likely_mapped_shared()
      selftests: mm: cow: flag vmsplice() hugetlb tests as XFAIL
      mm/hugetlb: document why hugetlb uses folio_mapcount() for COW reuse decisions
      selftests: mm: gup_longterm: test unsharing logic when R/O pinning

Dev Jain (7):
      selftests/mm: virtual_address_range: Switch to ksft_exit_fail_msg
      selftests/mm: confirm VA exhaustion without reliance on correctness of mmap()
      selftests/mm: parse VMA range in one go
      selftests/mm: mremap_test: optimize using pre-filled random array and memcpy
      selftests/mm: mremap_test: optimize execution time from minutes to seconds using chunkwise memcmp
      selftests/mm: mremap_test: use sscanf to parse /proc/self/maps
      selftests/mm: hugetlb_madv_vs_map: avoid test skipping by querying hugepage size at runtime

Donet Tom (2):
      mm/mempolicy: use numa_node_id() instead of cpu_to_node()
      mm/numa_balancing: allow migrate on protnone reference with MPOL_PREFERRED_MANY policy

Duoming Zhou (1):
      lib/test_hmm.c: handle src_pfns and dst_pfns allocation failure

Frank van der Linden (3):
      mm/cma: drop incorrect alignment check in cma_init_reserved_mem
      mm/hugetlb: pass correct order_per_bit to cma_declare_contiguous_nid
      mm/hugetlb: align cma on allocation order, not demotion order

Hao Ge (7):
      mm/page-flags: make __PageMovable return bool
      mm/page-flags: make PageMappingFlags return bool
      mm/mmap: make vma_wants_writenotify return bool
      mm/mmap: make accountable_mapping return bool
      mm/page-flags: make PageUptodate return bool
      mm/pagemap: make trylock_page return bool
      mm/rmap: change the type of we_locked from int to bool

Hariom Panthi (1):
      mm: vmalloc: dump page owner info if page is already mapped

Ho-Ren (Jack) Chuang (2):
      memory tier: dax/kmem: introduce an abstract layer for finding, allocating, and putting memory types
      memory tier: create CPUless memory tiers after obtaining HMAT info

Huang Ying (1):
      mm,swap: add document about RCU read lock and swapoff interaction

Jinjiang Tu (4):
      mm/ksm: fix ksm exec support for prctl
      selftest/mm: ksm_functional_tests: refactor mmap_and_merge_range()
      selftest/mm: ksm_functional_tests: extend test case for ksm fork/exec
      mm/ksm: remove redundant code in ksm_fork

Joel Granados (1):
      memory: remove the now superfluous sentinel element from ctl_table array

Johannes Weiner (12):
      mm: zswap: optimize zswap pool size tracking
      mm: zpool: return pool size in pages
      mm: page_alloc: remove pcppage migratetype caching
      mm: page_alloc: optimize free_unref_folios()
      mm: page_alloc: fix up block types when merging compatible blocks
      mm: page_alloc: move free pages when converting block during isolation
      mm: page_alloc: fix move_freepages_block() range error
      mm: page_alloc: fix freelist movement during block conversion
      mm: page_alloc: close migratetype race between freeing and stealing
      mm: page_isolation: prepare for hygienic freelists
      mm: page_alloc: consolidate free page accounting
      mm: page_alloc: batch vmstat updates in expand()

John Hubbard (3):
      huge_memory.c: document huge page splitting rules more thoroughly
      selftests: break the dependency upon local header files
      selftests/mm: fix additional build errors for selftests

Kairui Song (4):
      mm/filemap: return early if failed to allocate memory for split
      mm/filemap: clean up hugetlb exclusion code
      lib/xarray: introduce a new helper xas_get_order
      mm/filemap: optimize filemap folio adding

Kees Cook (2):
      alloc_tag: Tighten file permissions on /proc/allocinfo
      mm/slub: avoid recursive loop with kmemleak

Kefeng Wang (15):
      mm: backing-dev: use group allocation/free of per-cpu counters API
      mm: remove __set_page_dirty_nobuffers()
      arm64: mm: cleanup __do_page_fault()
      arm64: mm: accelerate pagefault when VM_FAULT_BADACCESS
      arm: mm: accelerate pagefault when VM_FAULT_BADACCESS
      powerpc: mm: accelerate pagefault when badaccess
      riscv: mm: accelerate pagefault when badaccess
      s390: mm: accelerate pagefault when badaccess
      x86: mm: accelerate pagefault when badaccess
      arm64: mm: drop VM_FAULT_BADMAP/VM_FAULT_BADACCESS
      arm: mm: drop VM_FAULT_BADMAP/VM_FAULT_BADACCESS
      mm: move mm counter updating out of set_pte_range()
      mm: filemap: batch mm counter updating in filemap_map_pages()
      mm: swapfile: check usable swap device in __folio_throttle_swaprate()
      mm: memory: check userfaultfd_wp() in vmf_orig_pte_uffd_wp()

Kemeng Shi (8):
      writeback: collect stats of all wb of bdi in bdi_debug_stats_show
      writeback: support retrieving per group debug writeback stats of bdi
      writeback: add wb_monitor.py script to monitor writeback info on bdi
      writeback: rename nr_reclaimable to nr_dirty in balance_dirty_pages
      mm: enable __wb_calc_thresh to calculate dirty background threshold
      mm: correct calculation of wb's bg_thresh in cgroup domain
      mm: call __wb_calc_thresh instead of wb_calc_thresh in wb_over_bg_thresh
      mm: remove stale comment __folio_mark_dirty

Kent Overstreet (13):
      fix missing vmalloc.h includes
      asm-generic/io.h: kill vmalloc.h dependency
      mm/slub: mark slab_free_freelist_hook() __always_inline
      scripts/kallysms: always include __start and __stop symbols
      fs: convert alloc_inode_sb() to a macro
      rust: add a rust helper for krealloc()
      mempool: hook up to memory allocation profiling
      mm: percpu: introduce pcpuobj_ext
      mm: percpu: add codetag reference into pcpuobj_ext
      mm: vmalloc: enable memory allocation profiling
      rhashtable: plumb through alloc tag
      MAINTAINERS: add entries for code tagging and memory allocation profiling
      memprofiling: documentation

Lance Yang (4):
      mm/madvise: introduce clear_young_dirty_ptes() batch helper
      mm/arm64: override clear_young_dirty_ptes() batch helper
      mm/memory: add any_dirty optional pointer to folio_pte_batch()
      mm/madvise: optimize lazyfreeing with mTHP in madvise_free

Liu Shixin (2):
      mm/readahead: break read-ahead loop if filemap_add_folio return -ENOMEM
      mm/filemap: don't decrease mmap_miss when folio has workingset flag

Long Li (1):
      xarray: inline xas_descend to improve performance

Lucas Stach (1):
      mm: page_alloc: control latency caused by zone PCP draining

Matthew Wilcox (1):
      mm: simplify thp_vma_allowable_order

Matthew Wilcox (Oracle) (88):
      mm: always initialise folio->_deferred_list
      mm: remove folio_prep_large_rmappable()
      mm: remove a call to compound_head() from is_page_hwpoison()
      mm: free up PG_slab
      mm: improve dumping of mapcount and page_type
      hugetlb: remove mention of destructors
      sh: remove use of PG_arch_1 on individual pages
      xtensa: remove uses of PG_arch_1 on individual pages
      mm: make page_ext_get() take a const argument
      mm: make folio_test_idle and folio_test_young take a const argument
      mm: make is_free_buddy_page() take a const argument
      mm: make page_mapped() take a const argument
      mm: convert arch_clear_hugepage_flags to take a folio
      slub: remove use of page->flags
      remove references to page->flags in documentation
      proc: rewrite stable_page_flags()
      sparc: use is_huge_zero_pmd()
      mm: add is_huge_zero_folio()
      mm: add pmd_folio()
      mm: convert migrate_vma_collect_pmd to use a folio
      mm: convert huge_zero_page to huge_zero_folio
      mm: convert do_huge_pmd_anonymous_page to huge_zero_folio
      dax: use huge_zero_folio
      mm: rename mm_put_huge_zero_page to mm_put_huge_zero_folio
      mm: use rwsem assertion macros for mmap_lock
      filemap: remove __set_page_dirty()
      mm: correct page_mapped_in_vma() for large folios
      mm: remove vma_address()
      mm: rename vma_pgoff_address back to vma_address
      khugepaged: inline hpage_collapse_alloc_folio()
      khugepaged: convert alloc_charge_hpage to alloc_charge_folio
      khugepaged: remove hpage from collapse_huge_page()
      khugepaged: pass a folio to __collapse_huge_page_copy()
      khugepaged: remove hpage from collapse_file()
      khugepaged: use a folio throughout collapse_file()
      khugepaged: use a folio throughout hpage_collapse_scan_file()
      proc: convert clear_refs_pte_range to use a folio
      proc: convert smaps_account() to use a folio
      mm: remove page_idle and page_young wrappers
      mm: generate PAGE_IDLE_FLAG definitions
      proc: convert gather_stats to use a folio
      proc: convert smaps_page_accumulate to use a folio
      proc: pass a folio to smaps_page_accumulate()
      proc: convert smaps_pmd_entry to use a folio
      mm: remove struct page from get_shadow_from_swap_cache
      hugetlb: convert alloc_buddy_hugetlb_folio to use a folio
      mm: convert pagecache_isize_extended to use a folio
      mm: free non-hugetlb large folios in a batch
      mm: combine free_the_page() and free_unref_page()
      mm: inline destroy_large_folio() into __folio_put_large()
      mm: combine __folio_put_small, __folio_put_large and __folio_put
      mm: convert free_zone_device_page to free_zone_device_folio
      doc: improve the description of __folio_mark_dirty
      buffer: add kernel-doc for block_dirty_folio()
      buffer: add kernel-doc for try_to_free_buffers()
      buffer: fix __bread and __bread_gfp kernel-doc
      buffer: add kernel-doc for brelse() and __brelse()
      buffer: add kernel-doc for bforget() and __bforget()
      buffer: improve bdev_getblk documentation
      doc: split buffer.rst out of api-summary.rst
      mm/memory-failure: remove fsdax_pgoff argument from __add_to_kill
      mm/memory-failure: pass addr to __add_to_kill()
      mm: return the address from page_mapped_in_vma()
      mm: make page_mapped_in_vma conditional on CONFIG_MEMORY_FAILURE
      mm/memory-failure: convert shake_page() to shake_folio()
      mm: convert hugetlb_page_mapping_lock_write to folio
      mm/memory-failure: convert memory_failure() to use a folio
      mm/memory-failure: convert hwpoison_user_mappings to take a folio
      mm/memory-failure: add some folio conversions to unpoison_memory
      mm/memory-failure: use folio functions throughout collect_procs()
      mm/memory-failure: pass the folio to collect_procs_ksm()
      fscrypt: convert bh_get_inode_and_lblk_num to use a folio
      f2fs: convert f2fs_clear_page_cache_dirty_tag to use a folio
      memory-failure: remove calls to page_mapping()
      migrate: expand the use of folio in __migrate_device_pages()
      userfault; expand folio use in mfill_atomic_install_pte()
      mm: remove page_cache_alloc()
      mm: remove put_devmap_managed_page()
      mm: convert put_devmap_managed_page_refs() to put_devmap_managed_folio_refs()
      mm: remove page_ref_sub_return()
      gup: use folios for gup_devmap
      mm: add kernel-doc for folio_mark_accessed()
      mm: remove PageReferenced
      mm: assert the mmap_lock is held in __anon_vma_prepare()
      mm: delay the check for a NULL anon_vma
      mm: fix some minor per-VMA lock issues in userfaultfd
      mm: optimise vmf_anon_prepare() for VMAs without an anon_vma
      thp: remove HPAGE_PMD_ORDER minimum assertion

Oscar Salvador (2):
      mm/hugetlb: add missing VM_FAULT_SET_HINDEX in hugetlb_fault
      mm/hugetlb: add missing VM_FAULT_SET_HINDEX in hugetlb_wp

Peter Xu (32):
      mm/hmm: process pud swap entry without pud_huge()
      mm/gup: cache p4d in follow_p4d_mask()
      mm/gup: check p4d presence before going on
      mm/x86: change pXd_huge() behavior to exclude swap entries
      mm/sparc: change pXd_huge() behavior to exclude swap entries
      mm/arm: use macros to define pmd/pud helpers
      mm/arm: redefine pmd_huge() with pmd_leaf()
      mm/arm64: merge pXd_huge() and pXd_leaf() definitions
      mm/powerpc: redefine pXd_huge() with pXd_leaf()
      mm/gup: merge pXd huge mapping checks
      mm/treewide: replace pXd_huge() with pXd_leaf()
      mm/treewide: remove pXd_huge()
      mm/arm: remove pmd_thp_or_huge()
      mm: document pXd_leaf() API
      selftests/mm: run_vmtests.sh: fix hugetlb mem size calculation
      mm/Kconfig: CONFIG_PGTABLE_HAS_HUGE_LEAVES
      mm/hugetlb: declare hugetlbfs_pagecache_present() non-static
      mm: make HPAGE_PXD_* macros even if !THP
      mm: introduce vma_pgtable_walk_{begin|end}()
      mm/arch: provide pud_pfn() fallback
      mm/gup: drop gup_fast_folio_allowed() in hugepd processing
      mm/gup: refactor record_subpages() to find 1st small page
      mm/gup: handle hugetlb for no_page_table()
      mm/gup: cache *pudp in follow_pud_mask()
      mm/gup: handle huge pud for follow_pud_mask()
      mm/gup: handle huge pmd for follow_pmd_mask()
      mm/gup: handle hugepd for follow_page()
      mm/gup: handle hugetlb in the generic follow_page_mask code
      mm: allow anon exclusive check over hugetlb tail pages
      mm/hugetlb: assert hugetlb_lock in __hugetlb_cgroup_commit_charge
      mm/page_table_check: support userfault wr-protect entries
      mm/gup: fix hugepd handling in hugetlb rework

Randy Dunlap (1):
      scripts/kernel-doc: drop "_noprof" on function prototypes

Rick Edgecombe (14):
      proc: refactor pde_get_unmapped_area as prep
      mm: switch mm->get_unmapped_area() to a flag
      mm: introduce arch_get_unmapped_area_vmflags()
      mm: remove export for get_unmapped_area()
      mm: use get_unmapped_area_vmflags()
      thp: add thp_get_unmapped_area_vmflags()
      csky: use initializer for struct vm_unmapped_area_info
      parisc: use initializer for struct vm_unmapped_area_info
      powerpc: use initializer for struct vm_unmapped_area_info
      treewide: use initializer for struct vm_unmapped_area_info
      mm: take placement mappings gap into account
      x86/mm: implement HAVE_ARCH_UNMAPPED_AREA_VMFLAGS
      x86/mm: care about shadow stack guard gap during placement
      selftests/x86: add placement guard gap test for shstk

Roman Gushchin (1):
      mm: memcg: account memory used for memcg vmstats and lruvec stats

Ryan Roberts (10):
      mm: swap: remove CLUSTER_FLAG_HUGE from swap_cluster_info:flags
      mm: swap: free_swap_and_cache_nr() as batched free_swap_and_cache()
      mm: swap: simplify struct percpu_cluster
      mm: swap: update get_swap_pages() to take folio order
      mm: swap: allow storage of all mTHP orders
      mm: vmscan: avoid split during shrink_folio_list()
      mm: madvise: avoid split during MADV_PAGEOUT and MADV_COLD
      selftests/mm: soft-dirty should fail if a testcase fails
      mm/debug_vm_pgtable: test pmd_leaf() behavior with pmd_mkinvalid()
      mm: fix race between __split_huge_pmd_locked() and GUP-fast

Saurav Shah (1):
      selftests/memfd: fix spelling mistakes

SeongJae Park (23):
      mm/damon/paddr: implement damon_folio_young()
      mm/damon/paddr: implement damon_folio_mkold()
      mm/damon: add DAMOS filter type YOUNG
      mm/damon/paddr: implement DAMOS filter type YOUNG
      Docs/mm/damon/design: document 'young page' type DAMOS filter
      Docs/admin-guide/mm/damon/usage: update for young page type DAMOS filter
      Docs/ABI/damon: update for 'youg page' type DAMOS filter
      mm/damon/paddr: avoid unnecessary page level access check for pageout DAMOS action
      mm/damon/paddr: do page level access check for pageout DAMOS action on its own
      mm/vmscan: remove ignore_references argument of reclaim_pages()
      mm/vmscan: remove ignore_references argument of reclaim_folio_list()
      selftests/damon/_damon_sysfs: support quota goals
      selftests/damon: add a test for DAMOS quota goal
      mm/damon/core: initialize ->esz_bp from damos_quota_init_priv()
      selftests/damon/_damon_sysfs: check errors from nr_schemes file reads
      selftests/damon/_damon_sysfs: find sysfs mount point from /proc/mounts
      selftests/damon/_damon_sysfs: use 'is' instead of '==' for 'None'
      selftests/damon: classify tests for functionalities and regressions
      Docs/admin-guide/mm/damon/usage: fix wrong example of DAMOS filter matching sysfs file
      Docs/admin-guide/mm/damon/usage: fix wrong schemes effective quota update command
      Docs/mm/damon/design: use a list for supported filters
      Docs/mm/damon/maintainer-profile: change the maintainer's timezone from PST to PT
      Docs/mm/damon/maintainer-profile: allow posting patches based on damon/next tree

Sergey Senozhatsky (1):
      zram: add max_pages param to recompression

Shakeel Butt (8):
      memcg: simple cleanup of stats update functions
      memcg: reduce memory size of mem_cgroup_events_index
      memcg: dynamically allocate lruvec_stats
      memcg: reduce memory for the lruvec and memcg stats
      memcg: cleanup __mod_memcg_lruvec_state
      mm: cleanup WORKINGSET_NODES in workingset
      memcg: warn for unexpected events and stats
      memcg: use proper type for mod_memcg_state

Sidhartha Kumar (2):
      mm/hugetlb: convert dissolve_free_huge_pages() to folios
      mm/hugetlb: rename dissolve_free_huge_pages() to dissolve_free_hugetlb_folios()

Suren Baghdasaryan (26):
      mm: introduce slabobj_ext to support slab object extensions
      mm: introduce __GFP_NO_OBJ_EXT flag to selectively prevent slabobj_ext creation
      mm/slab: introduce SLAB_NO_OBJ_EXT to avoid obj_ext creation
      slab: objext: introduce objext_flags as extension to page_memcg_data_flags
      lib: code tagging framework
      lib: code tagging module support
      lib: prevent module unloading if memory is not freed
      lib: add allocation tagging support for memory allocation profiling
      lib: introduce support for page allocation tagging
      lib: introduce early boot parameter to avoid page_ext memory overhead
      mm: percpu: increase PERCPU_MODULE_RESERVE to accommodate allocation tags
      change alloc_pages name in dma_map_ops to avoid name conflicts
      mm: enable page allocation tagging
      mm: create new codetag references during page splitting
      mm: fix non-compound multi-order memory accounting in __free_pages
      mm/page_ext: enable early_page_ext when CONFIG_MEM_ALLOC_PROFILING_DEBUG=y
      lib: add codetag reference into slabobj_ext
      mm/slab: add allocation accounting into slab allocation and free paths
      mm/slab: enable slab allocation tagging for kmalloc and friends
      mm: percpu: enable per-cpu allocation tagging
      lib: add memory allocations report in show_mem()
      codetag: debug: skip objext checking when it's for objext itself
      codetag: debug: mark codetags for reserved pages as empty
      codetag: debug: introduce OBJEXTS_ALLOC_FAIL to mark failed slab_ext allocations
      mm: change inlined allocation helpers to account at the call site
      userfaultfd: remove WRITE_ONCE when setting folio->index during UFFDIO_MOVE

Usama Arif (2):
      selftests: cgroup: remove redundant enabling of memory controller
      selftests: cgroup: add tests to verify the zswap writeback path

Vishal Moola (Oracle) (3):
      hugetlb: convert hugetlb_fault() to use struct vm_fault
      hugetlb: convert hugetlb_no_page() to use struct vm_fault
      hugetlb: convert hugetlb_wp() to use struct vm_fault

Vishal Verma (4):
      dax/bus.c: replace WARN_ON_ONCE() with lockdep asserts
      dax/bus.c: fix locking for unregister_dax_dev / unregister_dax_mapping paths
      dax/bus.c: don't use down_write_killable for non-user processes
      dax/bus.c: use the right locking mode (read vs write) in size_show

Vlastimil Babka (3):
      mm: page_alloc: change move_freepages() to __move_freepages_block()
      mm, slab: move memcg charging to post-alloc hook
      mm, slab: move slab_memcg hooks to mm/memcontrol.c

Waiman Long (2):
      mm/kmemleak: compact kmemleak_object further
      mm/kmemleak: disable KASAN instrumentation in kmemleak

Wei Yang (1):
      mm/sparse: guard the size of mem_section is power of 2

Xiu Jianfeng (2):
      mm: memcg: make alloc_mem_cgroup_per_node_info() return bool
      memcg, oom: cleanup unused memcg_oom_gfp_mask and memcg_oom_order

Yajun Deng (1):
      mm/mmap: convert all mas except mas_detach to vma iterator

York Jasper Niebuhr (1):
      mm: init_mlocked_on_free_v3

Yosry Ahmed (9):
      mm: memcg: add NULL check to obj_cgroup_put()
      mm: zswap: remove unnecessary check in zswap_find_zpool()
      percpu: clean up all mappings when pcpu_map_pages() fails
      mm: zswap: remove nr_zswap_stored atomic
      mm: zswap: always shrink in zswap_store() if zswap_pool_reached_full
      mm: zswap: refactor limit checking from zswap_store()
      mm: zswap: move more same-filled pages checks outside of zswap_store()
      mm: zswap: remove same_filled module params
      mm: do not update memcg stats for NR_{FILE/SHMEM}_PMDMAPPED

ZhangPeng (1):
      userfaultfd: early return in dup_userfaultfd()

Zi Yan (3):
      mm: page_alloc: set migratetype inside move_freepages()
      mm/migrate: split source folio if it is on deferred split list
      mm/rmap: do not add fully unmapped large folio to deferred split list

linke li (1):
      mm/swapfile: mark racy access on si->highest_bit

rulinhuang (1):
      mm/vmalloc: eliminated the lock contention from twice to once

 Documentation/ABI/testing/sysfs-kernel-mm-damon    |   6 +-
 .../testing/sysfs-kernel-mm-transparent-hugepage   |  18 +
 Documentation/admin-guide/blockdev/zram.rst        |   5 +
 Documentation/admin-guide/cgroup-v1/memory.rst     |   8 +-
 Documentation/admin-guide/kernel-parameters.txt    |   6 +
 Documentation/admin-guide/mm/damon/usage.rst       |  32 +-
 Documentation/admin-guide/mm/hugetlbpage.rst       |   7 +
 Documentation/admin-guide/mm/transhuge.rst         |  35 +-
 Documentation/admin-guide/mm/zswap.rst             |  29 -
 Documentation/admin-guide/sysctl/vm.rst            |  16 +
 Documentation/driver-api/crypto/iaa/iaa-crypto.rst |   2 -
 Documentation/filesystems/api-summary.rst          |   3 -
 Documentation/filesystems/buffer.rst               |  12 +
 Documentation/filesystems/index.rst                |   1 +
 Documentation/filesystems/proc.rst                 |  29 +
 Documentation/mm/allocation-profiling.rst          | 100 +++
 Documentation/mm/arch_pgtable_helpers.rst          |   6 +-
 Documentation/mm/damon/design.rst                  |  44 +-
 Documentation/mm/damon/maintainer-profile.rst      |  13 +-
 Documentation/mm/index.rst                         |   1 +
 Documentation/mm/page_table_check.rst              |   9 +-
 Documentation/mm/transhuge.rst                     |  12 +-
 Documentation/mm/vmemmap_dedup.rst                 |  22 +-
 .../translations/zh_CN/core-api/cachetlb.rst       |   2 +-
 MAINTAINERS                                        |  18 +
 arch/alpha/kernel/osf_sys.c                        |   5 +-
 arch/alpha/kernel/pci_iommu.c                      |   2 +-
 arch/alpha/lib/checksum.c                          |   1 +
 arch/alpha/lib/fpreg.c                             |   1 +
 arch/arc/include/asm/mmu-arcv2.h                   |   2 +
 arch/arc/mm/mmap.c                                 |   4 +-
 arch/arm/Kconfig                                   |   2 +-
 arch/arm/include/asm/hugetlb.h                     |   6 +-
 arch/arm/include/asm/pgtable-2level.h              |   5 +-
 arch/arm/include/asm/pgtable-3level-hwdef.h        |   1 +
 arch/arm/include/asm/pgtable-3level.h              |   5 +-
 arch/arm/kernel/irq.c                              |   1 +
 arch/arm/kernel/traps.c                            |   1 +
 arch/arm/lib/uaccess_with_memcpy.c                 |   4 +-
 arch/arm/mm/Makefile                               |   1 -
 arch/arm/mm/fault.c                                |  32 +-
 arch/arm/mm/hugetlbpage.c                          |  34 -
 arch/arm/mm/mmap.c                                 |   5 +-
 arch/arm64/Kconfig                                 |   2 +-
 arch/arm64/include/asm/hugetlb.h                   |   6 +-
 arch/arm64/include/asm/pgtable.h                   |  80 +-
 arch/arm64/kernel/efi.c                            |   1 +
 arch/arm64/mm/contpte.c                            |  29 +
 arch/arm64/mm/fault.c                              |  56 +-
 arch/arm64/mm/hugetlbpage.c                        |  18 +-
 arch/arm64/mm/mteswap.c                            |  45 ++
 arch/csky/abiv1/mmap.c                             |  12 +-
 arch/loongarch/Kconfig                             |   2 +-
 arch/loongarch/include/asm/kfence.h                |   1 +
 arch/loongarch/mm/hugetlbpage.c                    |  12 +-
 arch/loongarch/mm/mmap.c                           |   3 +-
 arch/mips/Kconfig                                  |   2 +-
 arch/mips/include/asm/pgtable-32.h                 |   2 +-
 arch/mips/include/asm/pgtable-64.h                 |   2 +-
 arch/mips/jazz/jazzdma.c                           |   2 +-
 arch/mips/mm/hugetlbpage.c                         |  10 -
 arch/mips/mm/mmap.c                                |   3 +-
 arch/mips/mm/tlb-r4k.c                             |   2 +-
 arch/parisc/kernel/sys_parisc.c                    |   6 +-
 arch/parisc/mm/hugetlbpage.c                       |  11 -
 arch/powerpc/Kconfig                               |   2 +-
 arch/powerpc/include/asm/book3s/64/pgtable-4k.h    |  20 -
 arch/powerpc/include/asm/book3s/64/pgtable-64k.h   |  25 -
 arch/powerpc/include/asm/book3s/64/pgtable.h       |  27 +-
 arch/powerpc/include/asm/mmu.h                     |   4 -
 arch/powerpc/include/asm/nohash/pgtable.h          |  10 -
 arch/powerpc/kernel/dma-iommu.c                    |   2 +-
 arch/powerpc/kernel/fadump.c                       |   5 -
 arch/powerpc/kernel/iommu.c                        |   1 +
 arch/powerpc/mm/book3s64/pgtable.c                 |   1 +
 arch/powerpc/mm/book3s64/slice.c                   |  20 +-
 arch/powerpc/mm/fault.c                            |  33 +-
 arch/powerpc/mm/mem.c                              |   1 +
 arch/powerpc/mm/pgtable_64.c                       |   6 +-
 arch/powerpc/platforms/ps3/system-bus.c            |   4 +-
 arch/powerpc/platforms/pseries/vio.c               |   2 +-
 arch/riscv/Kconfig                                 |   2 +-
 arch/riscv/include/asm/hugetlb.h                   |   6 +-
 arch/riscv/include/asm/pgtable.h                   |   1 +
 arch/riscv/kernel/elf_kexec.c                      |   1 +
 arch/riscv/kernel/probes/kprobes.c                 |   1 +
 arch/riscv/mm/fault.c                              |   5 +-
 arch/riscv/mm/hugetlbpage.c                        |  10 -
 arch/s390/Kconfig                                  |   2 +-
 arch/s390/include/asm/hugetlb.h                    |   6 +-
 arch/s390/include/asm/pgtable.h                    |   5 +-
 arch/s390/kernel/cert_store.c                      |   1 +
 arch/s390/kernel/ipl.c                             |   1 +
 arch/s390/mm/fault.c                               |   3 +-
 arch/s390/mm/hugetlbpage.c                         |  19 +-
 arch/s390/mm/mmap.c                                |   9 +-
 arch/s390/pci/pci_mmio.c                           |   4 +-
 arch/sh/Kconfig                                    |   2 +-
 arch/sh/include/asm/hugetlb.h                      |   6 +-
 arch/sh/mm/cache-sh4.c                             |   5 +-
 arch/sh/mm/cache.c                                 |   2 +-
 arch/sh/mm/hugetlbpage.c                           |  10 -
 arch/sh/mm/mmap.c                                  |   5 +-
 arch/sparc/include/asm/pgtable_64.h                |   3 +-
 arch/sparc/kernel/sys_sparc_32.c                   |   3 +-
 arch/sparc/kernel/sys_sparc_64.c                   |  20 +-
 arch/sparc/mm/hugetlbpage.c                        |  21 +-
 arch/sparc/mm/tlb.c                                |   7 +-
 arch/um/include/shared/um_malloc.h                 |   3 +-
 arch/x86/Kconfig                                   |   2 +-
 arch/x86/include/asm/io.h                          |   1 +
 arch/x86/include/asm/pgtable.h                     |  20 +-
 arch/x86/include/asm/pgtable_64.h                  |   1 +
 arch/x86/kernel/amd_gart_64.c                      |   2 +-
 arch/x86/kernel/cpu/sgx/driver.c                   |   2 +-
 arch/x86/kernel/cpu/sgx/main.c                     |   1 +
 arch/x86/kernel/irq_64.c                           |   1 +
 arch/x86/kernel/setup.c                            |   2 -
 arch/x86/kernel/sys_x86_64.c                       |  42 +-
 arch/x86/mm/fault.c                                |  24 +-
 arch/x86/mm/hugetlbpage.c                          |  35 +-
 arch/x86/mm/init.c                                 |  47 --
 arch/x86/mm/mmap.c                                 |   4 +-
 arch/x86/mm/numa_32.c                              |   1 +
 arch/x86/mm/pat/memtype.c                          |  26 +-
 arch/x86/mm/pgtable.c                              |   6 +-
 arch/xtensa/mm/cache.c                             |   6 +-
 arch/xtensa/mm/tlb.c                               |  11 +-
 drivers/accel/ivpu/ivpu_mmu_context.c              |   1 +
 drivers/block/zram/zram_drv.c                      |  31 +-
 drivers/char/mem.c                                 |   2 +-
 drivers/dax/bus.c                                  |  66 +-
 drivers/dax/device.c                               |   6 +-
 drivers/dax/kmem.c                                 |  30 +-
 drivers/gpu/drm/gma500/mmu.c                       |   1 +
 drivers/gpu/drm/i915/gem/i915_gem_pages.c          |   1 +
 drivers/gpu/drm/i915/gem/selftests/mock_dmabuf.c   |   1 +
 drivers/gpu/drm/i915/gt/shmem_utils.c              |   1 +
 drivers/gpu/drm/i915/gvt/firmware.c                |   1 +
 drivers/gpu/drm/i915/gvt/gtt.c                     |   1 +
 drivers/gpu/drm/i915/gvt/handlers.c                |   1 +
 drivers/gpu/drm/i915/gvt/mmio.c                    |   1 +
 drivers/gpu/drm/i915/gvt/vgpu.c                    |   1 +
 drivers/gpu/drm/i915/intel_gvt.c                   |   1 +
 drivers/gpu/drm/imagination/pvr_vm_mips.c          |   1 +
 drivers/gpu/drm/mediatek/mtk_drm_gem.c             |   1 +
 drivers/gpu/drm/omapdrm/omap_gem.c                 |   1 +
 drivers/gpu/drm/v3d/v3d_bo.c                       |   1 +
 drivers/gpu/drm/vmwgfx/vmwgfx_binding.c            |   1 +
 drivers/gpu/drm/vmwgfx/vmwgfx_cmd.c                |   1 +
 drivers/gpu/drm/vmwgfx/vmwgfx_devcaps.c            |   1 +
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c                |   1 +
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c            |   1 +
 drivers/gpu/drm/vmwgfx/vmwgfx_ioctl.c              |   1 +
 drivers/gpu/drm/xen/xen_drm_front_gem.c            |   1 +
 drivers/hwtracing/coresight/coresight-trbe.c       |   1 +
 drivers/iommu/amd/amd_iommu.h                      |   5 +-
 drivers/iommu/dma-iommu.c                          |   2 +-
 .../ethernet/marvell/octeon_ep/octep_pfvf_mbox.c   |   1 +
 .../ethernet/marvell/octeon_ep_vf/octep_vf_mbox.c  |   1 +
 drivers/net/ethernet/microsoft/mana/hw_channel.c   |   1 +
 drivers/parisc/ccio-dma.c                          |   2 +-
 drivers/parisc/sba_iommu.c                         |   2 +-
 drivers/platform/x86/uv_sysfs.c                    |   1 +
 drivers/scsi/mpi3mr/mpi3mr_transport.c             |   2 +
 drivers/staging/media/atomisp/pci/hmm/hmm.c        |   2 +-
 drivers/vfio/pci/pds/dirty.c                       |   1 +
 drivers/vfio/vfio_iommu_type1.c                    |   4 +-
 drivers/virt/acrn/mm.c                             |  61 +-
 drivers/virtio/virtio_mem.c                        |   1 +
 drivers/xen/grant-dma-ops.c                        |   2 +-
 drivers/xen/swiotlb-xen.c                          |   2 +-
 fs/buffer.c                                        | 165 ++--
 fs/crypto/inline_crypt.c                           |   6 +-
 fs/dax.c                                           |  14 +-
 fs/exec.c                                          |  11 +
 fs/f2fs/data.c                                     |   5 +-
 fs/hugetlbfs/inode.c                               |  11 +-
 fs/nfs/iostat.h                                    |   5 +-
 fs/proc/inode.c                                    |  10 +-
 fs/proc/meminfo.c                                  |   3 +-
 fs/proc/page.c                                     |  69 +-
 fs/proc/task_mmu.c                                 |  93 +--
 fs/ramfs/file-mmu.c                                |   2 +-
 fs/userfaultfd.c                                   |   5 +-
 include/acpi/platform/aclinuxex.h                  |  19 +-
 include/asm-generic/codetag.lds.h                  |  14 +
 include/asm-generic/io.h                           |   2 +-
 include/asm-generic/pgalloc.h                      |  35 +-
 include/asm-generic/vmlinux.lds.h                  |   3 +
 include/crypto/hash.h                              |   7 +-
 include/crypto/internal/acompress.h                |   5 +-
 include/crypto/skcipher.h                          |   7 +-
 include/linux/alloc_tag.h                          | 216 ++++++
 include/linux/bpf.h                                |  33 +-
 include/linux/bpfptr.h                             |   5 +-
 include/linux/buffer_head.h                        |  48 +-
 include/linux/codetag.h                            |  81 ++
 include/linux/damon.h                              |   2 +
 include/linux/dma-fence-chain.h                    |   6 +-
 include/linux/dma-map-ops.h                        |   2 +-
 include/linux/fortify-string.h                     |   5 +-
 include/linux/fs.h                                 |   6 +-
 include/linux/gfp.h                                | 126 +--
 include/linux/gfp_types.h                          |  11 +
 include/linux/hid_bpf.h                            |   6 +-
 include/linux/huge_mm.h                            | 129 ++--
 include/linux/hugetlb.h                            |  95 +--
 include/linux/io.h                                 |   1 +
 include/linux/jbd2.h                               |  12 +-
 include/linux/ksm.h                                |  35 +-
 include/linux/memcontrol.h                         | 151 ++--
 include/linux/memory-tiers.h                       |  13 +
 include/linux/mempolicy.h                          |   5 +-
 include/linux/mempool.h                            |  73 +-
 include/linux/mm.h                                 | 219 ++++--
 include/linux/mm_types.h                           |  35 +-
 include/linux/mmap_lock.h                          |  10 +-
 include/linux/page-flags.h                         |  64 +-
 include/linux/page-isolation.h                     |   5 +-
 include/linux/page_ext.h                           |   5 +-
 include/linux/page_idle.h                          |  68 +-
 include/linux/page_ref.h                           |  11 +-
 include/linux/pageblock-flags.h                    |   8 +-
 include/linux/pagemap.h                            |  22 +-
 include/linux/pds/pds_common.h                     |   2 +
 include/linux/percpu.h                             |  30 +-
 include/linux/pgalloc_tag.h                        | 132 ++++
 include/linux/pgtable.h                            | 119 ++-
 include/linux/ptr_ring.h                           |  28 +-
 include/linux/rhashtable-types.h                   |  11 +-
 include/linux/rmap.h                               |  50 +-
 include/linux/sched.h                              |  26 +-
 include/linux/sched/coredump.h                     |   5 +-
 include/linux/sched/mm.h                           |  22 +
 include/linux/secretmem.h                          |  21 +-
 include/linux/skb_array.h                          |  19 +-
 include/linux/skbuff.h                             |  20 +-
 include/linux/skmsg.h                              |   8 +-
 include/linux/slab.h                               | 184 +++--
 include/linux/sockptr.h                            |  10 +-
 include/linux/string.h                             |   4 +-
 include/linux/swap.h                               |  35 +-
 include/linux/vmalloc.h                            |  60 +-
 include/linux/vmstat.h                             |   8 -
 include/linux/writeback.h                          |   1 +
 include/linux/xarray.h                             |  14 +-
 include/linux/zpool.h                              |   4 +-
 include/linux/zswap.h                              |   2 +-
 include/net/netlabel.h                             |  16 +-
 include/net/netlink.h                              |   5 +-
 include/net/request_sock.h                         |   5 +-
 include/net/tcx.h                                  |   5 +-
 include/rdma/rdmavt_qp.h                           |   1 +
 include/trace/events/fs_dax.h                      |  16 +-
 include/trace/events/huge_memory.h                 |  12 +-
 include/trace/events/mmflags.h                     |   2 +-
 include/trace/events/page_ref.h                    |   4 +-
 init/Kconfig                                       |   4 +
 io_uring/io_uring.c                                |   2 +-
 kernel/bpf/arena.c                                 |   2 +-
 kernel/bpf/memalloc.c                              |   6 +-
 kernel/bpf/syscall.c                               |   2 +-
 kernel/dma/mapping.c                               |   4 +-
 kernel/events/core.c                               |   4 +-
 kernel/fork.c                                      |   2 +-
 kernel/kallsyms_selftest.c                         |   2 +-
 kernel/module/main.c                               |  29 +-
 kernel/vmcore_info.c                               |   3 +-
 lib/Kconfig.debug                                  |  31 +
 lib/Makefile                                       |   3 +
 lib/alloc_tag.c                                    | 246 ++++++
 lib/codetag.c                                      | 283 +++++++
 lib/rhashtable.c                                   |  22 +-
 lib/test_hmm.c                                     |   8 +-
 lib/test_xarray.c                                  |  93 +++
 lib/xarray.c                                       |  52 +-
 mm/Kconfig                                         |   8 +-
 mm/Makefile                                        |   1 +
 mm/backing-dev.c                                   | 200 +++--
 mm/cma.c                                           |   4 -
 mm/compaction.c                                    |   8 +-
 mm/damon/core.c                                    |  10 +-
 mm/damon/paddr.c                                   |  84 +-
 mm/damon/sysfs-schemes.c                           |   1 +
 mm/debug.c                                         |  25 +-
 mm/debug_page_alloc.c                              |  12 +-
 mm/debug_vm_pgtable.c                              |   2 +
 mm/filemap.c                                       | 115 ++-
 mm/folio-compat.c                                  |   6 -
 mm/gup.c                                           | 814 +++++++++++++-------
 mm/hmm.c                                           |   9 +-
 mm/huge_memory.c                                   | 428 +++++------
 mm/hugetlb.c                                       | 418 +++++-----
 mm/hugetlb_cgroup.c                                |   2 +-
 mm/hugetlb_vmemmap.c                               |   1 -
 mm/hwpoison-inject.c                               |  11 +-
 mm/internal.h                                      | 205 +++--
 mm/kasan/hw_tags.c                                 |   1 +
 mm/kfence/core.c                                   |  14 +-
 mm/kfence/kfence.h                                 |   4 +-
 mm/khugepaged.c                                    | 335 ++++----
 mm/kmemleak.c                                      |   6 +-
 mm/ksm.c                                           | 291 +++----
 mm/madvise.c                                       | 228 +++---
 mm/memcontrol.c                                    | 490 ++++++++----
 mm/memory-failure.c                                | 179 +++--
 mm/memory-tiers.c                                  | 123 ++-
 mm/memory.c                                        | 305 ++++----
 mm/memory_hotplug.c                                |   5 +-
 mm/mempolicy.c                                     | 104 +--
 mm/mempool.c                                       |  36 +-
 mm/memremap.c                                      |  40 +-
 mm/migrate.c                                       |  43 +-
 mm/migrate_device.c                                |  41 +-
 mm/mlock.c                                         |   2 +-
 mm/mm_init.c                                       | 216 +++---
 mm/mmap.c                                          | 233 +++---
 mm/mprotect.c                                      |   3 +-
 mm/mremap.c                                        |   2 +-
 mm/nommu.c                                         |  77 +-
 mm/oom_kill.c                                      |   1 -
 mm/page-writeback.c                                |  80 +-
 mm/page_alloc.c                                    | 842 +++++++++++----------
 mm/page_ext.c                                      |  15 +-
 mm/page_io.c                                       |   3 +-
 mm/page_isolation.c                                | 121 ++-
 mm/page_owner.c                                    |   2 +-
 mm/page_table_check.c                              |  30 +
 mm/page_vma_mapped.c                               |  22 +-
 mm/percpu-internal.h                               |  26 +-
 mm/percpu-vm.c                                     |   4 +-
 mm/percpu.c                                        | 118 ++-
 mm/pgtable-generic.c                               |   2 +
 mm/readahead.c                                     |   8 +-
 mm/rmap.c                                          | 111 +--
 mm/shmem.c                                         |  13 +-
 mm/show_mem.c                                      |  26 +
 mm/slab.h                                          |  60 +-
 mm/slab_common.c                                   |   6 +-
 mm/slub.c                                          | 468 +++++++-----
 mm/sparse.c                                        |  28 +-
 mm/swap.c                                          |  64 +-
 mm/swap_slots.c                                    |   8 +-
 mm/swap_state.c                                    |  10 +-
 mm/swapfile.c                                      | 368 +++++----
 mm/truncate.c                                      |  36 +-
 mm/userfaultfd.c                                   |  31 +-
 mm/util.c                                          |  40 +-
 mm/vmalloc.c                                       | 138 ++--
 mm/vmscan.c                                        |  52 +-
 mm/workingset.c                                    |   7 +-
 mm/z3fold.c                                        |  10 +-
 mm/zbud.c                                          |  10 +-
 mm/zpool.c                                         |  10 +-
 mm/zsmalloc.c                                      |   6 +-
 mm/zswap.c                                         | 389 ++++------
 net/sunrpc/auth_gss/auth_gss_internal.h            |   6 +-
 rust/helpers.c                                     |   8 +
 scripts/kallsyms.c                                 |  13 +
 scripts/kernel-doc                                 |   1 +
 scripts/module.lds.S                               |   7 +
 security/Kconfig.hardening                         |  15 +
 sound/pci/hda/cs35l41_hda.c                        |   1 +
 tools/cgroup/memcg_slabinfo.py                     |   5 +-
 tools/include/uapi/linux/memfd.h                   |  39 +
 tools/include/uapi/linux/userfaultfd.h             | 386 ++++++++++
 tools/testing/selftests/cgroup/test_zswap.c        | 132 +++-
 tools/testing/selftests/damon/Makefile             |  13 +-
 tools/testing/selftests/damon/_damon_sysfs.py      | 179 ++++-
 tools/testing/selftests/damon/damos_quota_goal.py  |  77 ++
 tools/testing/selftests/lib.mk                     |   9 +
 tools/testing/selftests/memfd/fuse_test.c          |   2 +-
 tools/testing/selftests/memfd/memfd_test.c         |   2 +-
 tools/testing/selftests/mm/Makefile                |   2 +-
 tools/testing/selftests/mm/cow.c                   | 106 ++-
 tools/testing/selftests/mm/gup_longterm.c          |  16 +-
 tools/testing/selftests/mm/hugetlb_madv_vs_map.c   |  16 +-
 tools/testing/selftests/mm/ksm_functional_tests.c  | 135 +++-
 tools/testing/selftests/mm/memfd_secret.c          |  51 +-
 tools/testing/selftests/mm/mlock2-tests.c          |  15 +-
 tools/testing/selftests/mm/mremap_test.c           | 204 +++--
 tools/testing/selftests/mm/run_vmtests.sh          |  13 +-
 tools/testing/selftests/mm/soft-dirty.c            |   2 +-
 tools/testing/selftests/mm/virtual_address_range.c |  78 +-
 tools/testing/selftests/x86/test_shadow_stack.c    |  67 +-
 tools/writeback/wb_monitor.py                      | 172 +++++
 virt/kvm/kvm_main.c                                |   4 +-
 388 files changed, 9701 insertions(+), 5723 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-kernel-mm-transparent-hugepage
 create mode 100644 Documentation/filesystems/buffer.rst
 create mode 100644 Documentation/mm/allocation-profiling.rst
 delete mode 100644 arch/arm/mm/hugetlbpage.c
 create mode 100644 include/asm-generic/codetag.lds.h
 create mode 100644 include/linux/alloc_tag.h
 create mode 100644 include/linux/codetag.h
 create mode 100644 include/linux/pgalloc_tag.h
 create mode 100644 lib/alloc_tag.c
 create mode 100644 lib/codetag.c
 create mode 100644 tools/include/uapi/linux/memfd.h
 create mode 100644 tools/include/uapi/linux/userfaultfd.h
 create mode 100644 tools/testing/selftests/damon/damos_quota_goal.py
 create mode 100644 tools/writeback/wb_monitor.py

	
