From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Wed, 3 Jun 2020 15:55:49 -0700
Message-ID: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725863AbgFCWzv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Jun 2020 18:55:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, linux-mm@kvack.org


More mm/ work, plenty more to come.

131 patches, based on d6f9469a03d832dcd17041ed67774ffb5f3e73b3.

Subsystems affected by this patch series:

  mm/slub
  mm/memcg
  mm/gup
  mm/kasan
  mm/pagealloc
  mm/hugetlb
  mm/vmscan
  mm/tools
  mm/mempolicy
  mm/memblock
  mm/hugetlbfs
  mm/thp
  mm/mmap
  mm/kconfig

Subsystem: mm/slub

    Wang Hai <wanghai38@huawei.com>:
      mm/slub: fix a memory leak in sysfs_slab_add()

Subsystem: mm/memcg

    Shakeel Butt <shakeelb@google.com>:
      mm/memcg: optimize memory.numa_stat like memory.stat

Subsystem: mm/gup

    John Hubbard <jhubbard@nvidia.com>:
    Patch series "mm/gup, drm/i915: refactor gup_fast, convert to pin_user_pages()", v2:
      mm/gup: move __get_user_pages_fast() down a few lines in gup.c
      mm/gup: refactor and de-duplicate gup_fast() code
      mm/gup: introduce pin_user_pages_fast_only()
      drm/i915: convert get_user_pages() --> pin_user_pages()
      mm/gup: might_lock_read(mmap_sem) in get_user_pages_fast()

Subsystem: mm/kasan

    Daniel Axtens <dja@axtens.net>:
    Patch series "Fix some incompatibilites between KASAN and FORTIFY_SOURCE", v4:
      kasan: stop tests being eliminated as dead code with FORTIFY_SOURCE
      string.h: fix incompatibility between FORTIFY_SOURCE and KASAN

Subsystem: mm/pagealloc

    Michal Hocko <mhocko@suse.com>:
      mm: clarify __GFP_MEMALLOC usage

    Mike Rapoport <rppt@linux.ibm.com>:
    Patch series "mm: rework free_area_init*() funcitons":
      mm: memblock: replace dereferences of memblock_region.nid with API calls
      mm: make early_pfn_to_nid() and related defintions close to each other
      mm: remove CONFIG_HAVE_MEMBLOCK_NODE_MAP option
      mm: free_area_init: use maximal zone PFNs rather than zone sizes
      mm: use free_area_init() instead of free_area_init_nodes()
      alpha: simplify detection of memory zone boundaries
      arm: simplify detection of memory zone boundaries
      arm64: simplify detection of memory zone boundaries for UMA configs
      csky: simplify detection of memory zone boundaries
      m68k: mm: simplify detection of memory zone boundaries
      parisc: simplify detection of memory zone boundaries
      sparc32: simplify detection of memory zone boundaries
      unicore32: simplify detection of memory zone boundaries
      xtensa: simplify detection of memory zone boundaries

    Baoquan He <bhe@redhat.com>:
      mm: memmap_init: iterate over memblock regions rather that check each PFN

    Mike Rapoport <rppt@linux.ibm.com>:
      mm: remove early_pfn_in_nid() and CONFIG_NODES_SPAN_OTHER_NODES
      mm: free_area_init: allow defining max_zone_pfn in descending order
      mm: rename free_area_init_node() to free_area_init_memoryless_node()
      mm: clean up free_area_init_node() and its helpers
      mm: simplify find_min_pfn_with_active_regions()
      docs/vm: update memory-models documentation

    Wei Yang <richard.weiyang@gmail.com>:
    Patch series "mm/page_alloc.c: cleanup on check page", v3:
      mm/page_alloc.c: bad_[reason|flags] is not necessary when PageHWPoison
      mm/page_alloc.c: bad_flags is not necessary for bad_page()
      mm/page_alloc.c: rename free_pages_check_bad() to check_free_page_bad()
      mm/page_alloc.c: rename free_pages_check() to check_free_page()
      mm/page_alloc.c: extract check_[new|free]_page_bad() common part to page_bad_reason()

    Roman Gushchin <guro@fb.com>:
      mm,page_alloc,cma: conditionally prefer cma pageblocks for movable allocations

    Baoquan He <bhe@redhat.com>:
      mm/page_alloc.c: remove unused free_bootmem_with_active_regions
    Patch series "improvements about lowmem_reserve and /proc/zoneinfo", v2:
      mm/page_alloc.c: only tune sysctl_lowmem_reserve_ratio value once when changing it
      mm/page_alloc.c: clear out zone->lowmem_reserve[] if the zone is empty
      mm/vmstat.c: do not show lowmem reserve protection information of empty zone

    Joonsoo Kim <iamjoonsoo.kim@lge.com>:
    Patch series "integrate classzone_idx and high_zoneidx", v5:
      mm/page_alloc: use ac->high_zoneidx for classzone_idx
      mm/page_alloc: integrate classzone_idx and high_zoneidx

    Wei Yang <richard.weiyang@gmail.com>:
      mm/page_alloc.c: use NODE_MASK_NONE in build_zonelists()
      mm: rename gfpflags_to_migratetype to gfp_migratetype for same convention

    Sandipan Das <sandipan@linux.ibm.com>:
      mm/page_alloc.c: reset numa stats for boot pagesets

    Charan Teja Reddy <charante@codeaurora.org>:
      mm, page_alloc: reset the zone->watermark_boost early

    Anshuman Khandual <anshuman.khandual@arm.com>:
      mm/page_alloc: restrict and formalize compound_page_dtors[]

    Daniel Jordan <daniel.m.jordan@oracle.com>:
    Patch series "initialize deferred pages with interrupts enabled", v4:
      mm/pagealloc.c: call touch_nmi_watchdog() on max order boundaries in deferred init

    Pavel Tatashin <pasha.tatashin@soleen.com>:
      mm: initialize deferred pages with interrupts enabled
      mm: call cond_resched() from deferred_init_memmap()

    Daniel Jordan <daniel.m.jordan@oracle.com>:
    Patch series "padata: parallelize deferred page init", v3:
      padata: remove exit routine
      padata: initialize earlier
      padata: allocate work structures for parallel jobs from a pool
      padata: add basic support for multithreaded jobs
      mm: don't track number of pages during deferred initialization
      mm: parallelize deferred_init_memmap()
      mm: make deferred init's max threads arch-specific
      padata: document multithreaded jobs

    Chen Tao <chentao107@huawei.com>:
      mm/page_alloc.c: add missing newline

Subsystem: mm/hugetlb

    "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>:
    Patch series "thp/khugepaged improvements and CoW semantics", v4:
      khugepaged: add self test
      khugepaged: do not stop collapse if less than half PTEs are referenced
      khugepaged: drain all LRU caches before scanning pages
      khugepaged: drain LRU add pagevec after swapin
      khugepaged: allow to collapse a page shared across fork
      khugepaged: allow to collapse PTE-mapped compound pages
      thp: change CoW semantics for anon-THP
      khugepaged: introduce 'max_ptes_shared' tunable

    Mike Kravetz <mike.kravetz@oracle.com>:
    Patch series "Clean up hugetlb boot command line processing", v4:
      hugetlbfs: add arch_hugetlb_valid_size
      hugetlbfs: move hugepagesz= parsing to arch independent code
      hugetlbfs: remove hugetlb_add_hstate() warning for existing hstate
      hugetlbfs: clean up command line processing
      hugetlbfs: fix changes to command line processing

    Li Xinhai <lixinhai.lxh@gmail.com>:
      mm/hugetlb: avoid unnecessary check on pud and pmd entry in huge_pte_offset

    Anshuman Khandual <anshuman.khandual@arm.com>:
    Patch series "mm/hugetlb: Add some new generic fallbacks", v3:
      arm64/mm: drop __HAVE_ARCH_HUGE_PTEP_GET
      mm/hugetlb: define a generic fallback for is_hugepage_only_range()
      mm/hugetlb: define a generic fallback for arch_clear_hugepage_flags()

    "Matthew Wilcox (Oracle)" <willy@infradead.org>:
      mm: simplify calling a compound page destructor

Subsystem: mm/vmscan

    Wei Yang <richard.weiyang@gmail.com>:
      mm/vmscan.c: use update_lru_size() in update_lru_sizes()

    Jaewon Kim <jaewon31.kim@samsung.com>:
      mm/vmscan: count layzfree pages and fix nr_isolated_* mismatch

    Maninder Singh <maninder1.s@samsung.com>:
      mm/vmscan.c: change prototype for shrink_page_list

    Qiwu Chen <qiwuchen55@gmail.com>:
      mm/vmscan: update the comment of should_continue_reclaim()

    Johannes Weiner <hannes@cmpxchg.org>:
    Patch series "mm: memcontrol: charge swapin pages on instantiation", v2:
      mm: fix NUMA node file count error in replace_page_cache()
      mm: memcontrol: fix stat-corrupting race in charge moving
      mm: memcontrol: drop @compound parameter from memcg charging API
      mm: shmem: remove rare optimization when swapin races with hole punching
      mm: memcontrol: move out cgroup swaprate throttling
      mm: memcontrol: convert page cache to a new mem_cgroup_charge() API
      mm: memcontrol: prepare uncharging for removal of private page type counters
      mm: memcontrol: prepare move_account for removal of private page type counters
      mm: memcontrol: prepare cgroup vmstat infrastructure for native anon counters
      mm: memcontrol: switch to native NR_FILE_PAGES and NR_SHMEM counters
      mm: memcontrol: switch to native NR_ANON_MAPPED counter
      mm: memcontrol: switch to native NR_ANON_THPS counter
      mm: memcontrol: convert anon and file-thp to new mem_cgroup_charge() API
      mm: memcontrol: drop unused try/commit/cancel charge API
      mm: memcontrol: prepare swap controller setup for integration
      mm: memcontrol: make swap tracking an integral part of memory control
      mm: memcontrol: charge swapin pages on instantiation

    Alex Shi <alex.shi@linux.alibaba.com>:
      mm: memcontrol: document the new swap control behavior

    Johannes Weiner <hannes@cmpxchg.org>:
      mm: memcontrol: delete unused lrucare handling
      mm: memcontrol: update page->mem_cgroup stability rules
      mm: fix LRU balancing effect of new transparent huge pages
      mm: keep separate anon and file statistics on page reclaim activity
      mm: allow swappiness that prefers reclaiming anon over the file workingset
      mm: fold and remove lru_cache_add_anon() and lru_cache_add_file()
      mm: workingset: let cache workingset challenge anon
      mm: remove use-once cache bias from LRU balancing
      mm: vmscan: drop unnecessary div0 avoidance rounding in get_scan_count()
      mm: base LRU balancing on an explicit cost model
      mm: deactivations shouldn't bias the LRU balance
      mm: only count actual rotations as LRU reclaim cost
      mm: balance LRU lists based on relative thrashing
      mm: vmscan: determine anon/file pressure balance at the reclaim root
      mm: vmscan: reclaim writepage is IO cost
      mm: vmscan: limit the range of LRU type balancing

    Shakeel Butt <shakeelb@google.com>:
      mm: swap: fix vmstats for huge pages
      mm: swap: memcg: fix memcg stats for huge pages

Subsystem: mm/tools

    Changhee Han <ch0.han@lge.com>:
      tools/vm/page_owner_sort.c: filter out unneeded line

Subsystem: mm/mempolicy

    Michal Hocko <mhocko@suse.com>:
      mm, mempolicy: fix up gup usage in lookup_node

Subsystem: mm/memblock

    chenqiwu <chenqiwu@xiaomi.com>:
      include/linux/memblock.h: fix minor typo and unclear comment

    Mike Rapoport <rppt@linux.ibm.com>:
      sparc32: register memory occupied by kernel as memblock.memory

Subsystem: mm/hugetlbfs

    Shijie Hu <hushijie3@huawei.com>:
      hugetlbfs: get unmapped area below TASK_UNMAPPED_BASE for hugetlbfs

Subsystem: mm/thp

    Yang Shi <yang.shi@linux.alibaba.com>:
      mm: thp: don't need to drain lru cache when splitting and mlocking THP

    Anshuman Khandual <anshuman.khandual@arm.com>:
    Patch series "mm/thp: Rename pmd_mknotpresent() as pmd_mknotvalid()", v2:
      powerpc/mm: drop platform defined pmd_mknotpresent()
      mm/thp: rename pmd_mknotpresent() as pmd_mkinvalid()

Subsystem: mm/mmap

    Scott Cheloha <cheloha@linux.vnet.ibm.com>:
      drivers/base/memory.c: cache memory blocks in xarray to accelerate lookup

Subsystem: mm/kconfig

    Zong Li <zong.li@sifive.com>:
    Patch series "Extract DEBUG_WX to shared use":
      mm: add DEBUG_WX support
      riscv: support DEBUG_WX
      x86: mm: use ARCH_HAS_DEBUG_WX instead of arch defined
      arm64: mm: use ARCH_HAS_DEBUG_WX instead of arch defined

 Documentation/admin-guide/cgroup-v1/memory.rst           |   19 
 Documentation/admin-guide/kernel-parameters.txt          |   40 
 Documentation/admin-guide/mm/hugetlbpage.rst             |   35 
 Documentation/admin-guide/mm/transhuge.rst               |    7 
 Documentation/admin-guide/sysctl/vm.rst                  |   23 
 Documentation/core-api/padata.rst                        |   41 
 Documentation/features/vm/numa-memblock/arch-support.txt |   34 
 Documentation/vm/memory-model.rst                        |    9 
 Documentation/vm/page_owner.rst                          |    3 
 arch/alpha/mm/init.c                                     |   16 
 arch/alpha/mm/numa.c                                     |   22 
 arch/arc/include/asm/hugepage.h                          |    2 
 arch/arc/mm/init.c                                       |   41 
 arch/arm/include/asm/hugetlb.h                           |    7 
 arch/arm/include/asm/pgtable-3level.h                    |    2 
 arch/arm/mm/init.c                                       |   66 
 arch/arm64/Kconfig                                       |    2 
 arch/arm64/Kconfig.debug                                 |   29 
 arch/arm64/include/asm/hugetlb.h                         |   13 
 arch/arm64/include/asm/pgtable.h                         |    2 
 arch/arm64/mm/hugetlbpage.c                              |   48 
 arch/arm64/mm/init.c                                     |   56 
 arch/arm64/mm/numa.c                                     |    9 
 arch/c6x/mm/init.c                                       |    8 
 arch/csky/kernel/setup.c                                 |   26 
 arch/h8300/mm/init.c                                     |    6 
 arch/hexagon/mm/init.c                                   |    6 
 arch/ia64/Kconfig                                        |    1 
 arch/ia64/include/asm/hugetlb.h                          |    5 
 arch/ia64/mm/contig.c                                    |    2 
 arch/ia64/mm/discontig.c                                 |    2 
 arch/m68k/mm/init.c                                      |    6 
 arch/m68k/mm/mcfmmu.c                                    |    9 
 arch/m68k/mm/motorola.c                                  |   15 
 arch/m68k/mm/sun3mmu.c                                   |   10 
 arch/microblaze/Kconfig                                  |    1 
 arch/microblaze/mm/init.c                                |    2 
 arch/mips/Kconfig                                        |    1 
 arch/mips/include/asm/hugetlb.h                          |   11 
 arch/mips/include/asm/pgtable.h                          |    2 
 arch/mips/loongson64/numa.c                              |    2 
 arch/mips/mm/init.c                                      |    2 
 arch/mips/sgi-ip27/ip27-memory.c                         |    2 
 arch/nds32/mm/init.c                                     |   11 
 arch/nios2/mm/init.c                                     |    8 
 arch/openrisc/mm/init.c                                  |    9 
 arch/parisc/include/asm/hugetlb.h                        |   10 
 arch/parisc/mm/init.c                                    |   22 
 arch/powerpc/Kconfig                                     |   10 
 arch/powerpc/include/asm/book3s/64/pgtable.h             |    4 
 arch/powerpc/include/asm/hugetlb.h                       |    5 
 arch/powerpc/mm/hugetlbpage.c                            |   38 
 arch/powerpc/mm/mem.c                                    |    2 
 arch/riscv/Kconfig                                       |    2 
 arch/riscv/include/asm/hugetlb.h                         |   10 
 arch/riscv/include/asm/ptdump.h                          |   11 
 arch/riscv/mm/hugetlbpage.c                              |   44 
 arch/riscv/mm/init.c                                     |    5 
 arch/s390/Kconfig                                        |    1 
 arch/s390/include/asm/hugetlb.h                          |    8 
 arch/s390/mm/hugetlbpage.c                               |   34 
 arch/s390/mm/init.c                                      |    2 
 arch/sh/Kconfig                                          |    1 
 arch/sh/include/asm/hugetlb.h                            |    7 
 arch/sh/mm/init.c                                        |    2 
 arch/sparc/Kconfig                                       |   10 
 arch/sparc/include/asm/hugetlb.h                         |   10 
 arch/sparc/mm/init_32.c                                  |    1 
 arch/sparc/mm/init_64.c                                  |   67 
 arch/sparc/mm/srmmu.c                                    |   21 
 arch/um/kernel/mem.c                                     |   12 
 arch/unicore32/include/asm/memory.h                      |    2 
 arch/unicore32/include/mach/memory.h                     |    6 
 arch/unicore32/kernel/pci.c                              |   14 
 arch/unicore32/mm/init.c                                 |   43 
 arch/x86/Kconfig                                         |   11 
 arch/x86/Kconfig.debug                                   |   27 
 arch/x86/include/asm/hugetlb.h                           |   10 
 arch/x86/include/asm/pgtable.h                           |    2 
 arch/x86/mm/hugetlbpage.c                                |   35 
 arch/x86/mm/init.c                                       |    2 
 arch/x86/mm/init_64.c                                    |   12 
 arch/x86/mm/kmmio.c                                      |    2 
 arch/x86/mm/numa.c                                       |   11 
 arch/xtensa/mm/init.c                                    |    8 
 drivers/base/memory.c                                    |   44 
 drivers/gpu/drm/i915/gem/i915_gem_userptr.c              |   22 
 fs/cifs/file.c                                           |   10 
 fs/fuse/dev.c                                            |    2 
 fs/hugetlbfs/inode.c                                     |   67 
 include/asm-generic/hugetlb.h                            |    2 
 include/linux/compaction.h                               |    9 
 include/linux/gfp.h                                      |    7 
 include/linux/hugetlb.h                                  |   16 
 include/linux/memblock.h                                 |   15 
 include/linux/memcontrol.h                               |  102 -
 include/linux/mm.h                                       |   52 
 include/linux/mmzone.h                                   |   46 
 include/linux/padata.h                                   |   43 
 include/linux/string.h                                   |   60 
 include/linux/swap.h                                     |   17 
 include/linux/vm_event_item.h                            |    4 
 include/linux/vmstat.h                                   |    2 
 include/trace/events/compaction.h                        |   22 
 include/trace/events/huge_memory.h                       |    3 
 include/trace/events/vmscan.h                            |   14 
 init/Kconfig                                             |   17 
 init/main.c                                              |    2 
 kernel/events/uprobes.c                                  |   22 
 kernel/padata.c                                          |  293 +++-
 kernel/sysctl.c                                          |    3 
 lib/test_kasan.c                                         |   29 
 mm/Kconfig                                               |    9 
 mm/Kconfig.debug                                         |   32 
 mm/compaction.c                                          |   70 -
 mm/filemap.c                                             |   55 
 mm/gup.c                                                 |  237 ++-
 mm/huge_memory.c                                         |  282 ----
 mm/hugetlb.c                                             |  260 ++-
 mm/internal.h                                            |   25 
 mm/khugepaged.c                                          |  316 ++--
 mm/memblock.c                                            |   19 
 mm/memcontrol.c                                          |  642 +++------
 mm/memory.c                                              |  103 -
 mm/memory_hotplug.c                                      |   10 
 mm/mempolicy.c                                           |    5 
 mm/migrate.c                                             |   30 
 mm/oom_kill.c                                            |    4 
 mm/page_alloc.c                                          |  735 ++++------
 mm/page_owner.c                                          |    7 
 mm/pgtable-generic.c                                     |    2 
 mm/rmap.c                                                |   53 
 mm/shmem.c                                               |  156 --
 mm/slab.c                                                |    4 
 mm/slub.c                                                |    8 
 mm/swap.c                                                |  199 +-
 mm/swap_cgroup.c                                         |   10 
 mm/swap_state.c                                          |  110 -
 mm/swapfile.c                                            |   39 
 mm/userfaultfd.c                                         |   15 
 mm/vmscan.c                                              |  344 ++--
 mm/vmstat.c                                              |   16 
 mm/workingset.c                                          |   23 
 tools/testing/selftests/vm/.gitignore                    |    1 
 tools/testing/selftests/vm/Makefile                      |    1 
 tools/testing/selftests/vm/khugepaged.c                  | 1035 +++++++++++++++
 tools/vm/page_owner_sort.c                               |    5 
 147 files changed, 3876 insertions(+), 3108 deletions(-)
