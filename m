Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 834E322301;
	Thu, 12 Feb 2026 03:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770866632; cv=none; b=hjKHpMwunldEqr1E2aLNO/zOpJe2gFo/qCU3zs7qdeJVwkT45x287dbCCw1BF3a33S2xLhCxTKIcuEtyrNhty5v27rz0g9YbkTAjeGs0ohpl4RFh2tcS6X97Irwl2u7clcsYkaTpAGlIW5trtd0zVhVEN1QhNWgb8QMcTBP0poY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770866632; c=relaxed/simple;
	bh=5goIe95tZZ6mfmVIFqxKx4rXSWQDIkg4fieqmezcBT4=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=Sc0S5z4ygfodWse2EppQarx7yviq/hWVkt+6EKqNTGpR+AH46dte8IKSQXriCTXsQsoYvmQrfa9rmGk6TQFqGBHluswstZSFbqevLXtsMWK85jHaz7SU8XRz1GMyedp5fWmqLPFnH8zMOQbpo9ET+FhvFHv3WVLri2O+oLAoEDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=G2s5qpIx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="G2s5qpIx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0883C4CEF7;
	Thu, 12 Feb 2026 03:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770866632;
	bh=5goIe95tZZ6mfmVIFqxKx4rXSWQDIkg4fieqmezcBT4=;
	h=Date:From:To:Cc:Subject:From;
	b=G2s5qpIxetINVfg+3SZPCVQyaBXIHqGZVbLGb3CUnIwcl7dyqgk0nS2j0I+0NjV3R
	 yPH4h4JTQvRz6e3FjVTF5L+wn8ZMyfiHDxaR2SiMGFbUgzSSOvRgsPiLqd9O5X5PEX
	 rD3G3XLHRgz2Vr/aAivzOLN5D5Gu7XmnkSYvtorU=
Date: Wed, 11 Feb 2026 19:23:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] MM updates for 7.0-rc1
Message-Id: <20260211192351.6684a77b8c70cc032a3e7a27@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Linus, please merge this main batch of MM updates for the upcoming -rc
cycle, thanks.


I'm seeing a single conflict at this time, in include/linux/cma.h. 
Mark's resolution is at
https://lkml.kernel.org/r/aXtlrOzrFg5XMSkj@sirena.org.uk

Possible upcoming conflicts and their linux-next resolutions are as
follows:

arch/riscv/include/asm/page.h, vs risc-v tree:
	https://lkml.kernel.org/r/aXDNtx7iXjV-hsjm@sirena.org.uk

fs/ntfs3/file.c, vs fs-next tree:
	https://lkml.kernel.org/r/aXeZNSiVv82Gc9HF@sirena.org.uk

drivers/gpu/drm/i915/gem/i915_gem_shmem.c, vs drm tree:
	https://lkml.kernel.org/r/aXerLzIbpMy9d4lx@sirena.org.uk

drivers/gpu/drm/amd/amdkfd/kfd_process.c, vs drm tree:
	https://lkml.kernel.org/r/aXjJCmDiKFYA0-P6@sirena.org.uk

arch/s390/mm/pgtable.c, vs kvms390 tree:
	https://lkml.kernel.org/r/aYSVUnyIHvEkCN4U@sirena.org.uk



The following changes since commit bd58782995a2e6a07fd07255f3cc319f40b131c9:

  vmcoreinfo: make hwerr_data visible for debugging (2026-01-26 19:03:49 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2026-02-11-19-22

for you to fetch changes up to fb4ddf2085115ed28dedc427d9491707b476bbfe:

  mm/memory: handle non-split locks correctly in zap_empty_pte_table() (2026-02-06 15:47:19 -0800)

----------------------------------------------------------------
mm.git review status for linus..mm-stable

Everything:

Total patches:       325
Reviews/patch:       1.39
Reviewed rate:       72%

Excluding DAMON:

Total patches:       262
Reviews/patch:       1.63
Reviewed rate:       82%

Excluding DAMON and zram:

Total patches:       248
Reviews/patch:       1.72
Reviewed rate:       86%

- The 14 patch series "powerpc/64s: do not re-activate batched TLB
  flush" from Alexander Gordeev makes arch_{enter|leave}_lazy_mmu_mode()
  nest properly.

  It adds a generic enter/leave layer and switches architectures to use
  it.  Various hacks were removed in the process.

- The 7 patch series "zram: introduce compressed data writeback" from
  Richard Chang and Sergey Senozhatsky implements data compression for
  zram writeback.

- The 8 patch series "mm: folio_zero_user: clear page ranges" from David
  Hildenbrand adds clearing of contiguous page ranges for hugepages.
  Large improvements during demand faulting are demonstrated.

- The 2 patch series "memcg cleanups" from Chen Ridong tideis up some
  memcg code.

- The 12 patch series "mm/damon: introduce {,max_}nr_snapshots and
  tracepoint for damos stats" from SeongJae Park improves DAMOS stat's
  provided information, deterministic control, and readability.

- The 3 patch series "selftests/mm: hugetlb cgroup charging: robustness
  fixes" from Li Wang fixes a few issues in the hugetlb cgroup charging
  selftests.

- The 5 patch series "Fix va_high_addr_switch.sh test failure - again"
  from Chunyu Hu addresses several issues in the va_high_addr_switch test.

- The 5 patch series "mm/damon/tests/core-kunit: extend existing test
  scenarios" from Shu Anzai improves the KUnit test coverage for DAMON.

- The 2 patch series "mm/khugepaged: fix dirty page handling for
  MADV_COLLAPSE" from Shivank Garg fixes a glitch in khugepaged which was
  causing madvise(MADV_COLLAPSE) to transiently return -EAGAIN.

- The 29 patch series "arch, mm: consolidate hugetlb early reservation"
  from Mike Rapoport reworks and consolidates a pile of straggly code
  related to reservation of hugetlb memory from bootmem and creation of
  CMA areas for hugetlb.

- The 9 patch series "mm: clean up anon_vma implementation" from Lorenzo
  Stoakes cleans up the anon_vma implementation in various ways.

- The 3 patch series "tweaks for __alloc_pages_slowpath()" from
  Vlastimil Babka does a little streamlining of the page allocator's
  slowpath code.

- The 8 patch series "memcg: separate private and public ID namespaces"
  from Shakeel Butt cleans up the memcg ID code and prevents the
  internal-only private IDs from being exposed to userspace.

- The 6 patch series "mm: hugetlb: allocate frozen gigantic folio" from
  Kefeng Wang cleans up the allocation of frozen folios and avoids some
  atomic refcount operations.

- The 11 patch series "mm/damon: advance DAMOS-based LRU sorting" from
  SeongJae Park improves DAMOS's movement of memory betewwn the active and
  inactive LRUs and adds auto-tuning of the ratio-based quotas and of
  monitoring intervals.

- The 18 patch series "Support page table check on PowerPC" from Andrew
  Donnellan makes CONFIG_PAGE_TABLE_CHECK_ENFORCED work on powerpc.

- The 3 patch series "nodemask: align nodes_and{,not} with underlying
  bitmap ops" from Yury Norov makes nodes_and() and nodes_andnot()
  propagate the return values from the underlying bit operations, enabling
  some cleanup in calling code.

- The 5 patch series "mm/damon: hide kdamond and kdamond_lock from API
  callers" from SeongJae Park cleans up some DAMON internal interfaces.

- The 4 patch series "mm/khugepaged: cleanups and scan limit fix" from
  Shivank Garg does some cleanup work in khupaged and fixes a scan limit
  accounting issue.

- The 24 patch series "mm: balloon infrastructure cleanups" from David
  Hildenbrand goes to town on the balloon infrastructure and its page
  migration function.  Mainly cleanups, also some locking simplification.

- The 2 patch series "mm/vmscan: add tracepoint and reason for
  kswapd_failures reset" from Jiayuan Chen adds additional tracepoints to
  the page reclaim code.

- The 3 patch series "Replace wq users and add WQ_PERCPU to
  alloc_workqueue() users" from Marco Crivellari is part of Marco's
  kernel-wide migration from the legacy workqueue APIs over to the
  preferred unbound workqueues.

- The 9 patch series "Various mm kselftests improvements/fixes" from
  Kevin Brodsky provides various unrelated improvements/fixes for the mm
  kselftests.

- The 5 patch series "mm: accelerate gigantic folio allocation" from
  Kefeng Wang greatly speeds up gigantic folio allocation, mainly by
  avoiding unnecessary work in pfn_range_valid_contig().

- The 5 patch series "selftests/damon: improve leak detection and wss
  estimation reliability" from SeongJae Park improves the reliability of
  two of the DAMON selftests.

- The 8 patch series "mm/damon: cleanup kdamond, damon_call(), damos
  filter and DAMON_MIN_REGION" from SeongJae Park does some cleanup work
  in the core DAMON code.

- The 8 patch series "Docs/mm/damon: update intro, modules, maintainer
  profile, and misc" from SeongJae Park performs maintenance work on the
  DAMON documentation.

- The 10 patch series "mm: add and use vma_assert_stabilised() helper"
  from Lorenzo Stoakes refactors and cleans up the core VMA code.  The
  main aim here is to be able to use the mmap write lock's lockdep state
  to perform various assertions regarding the locking which the VMA code
  requires.

- The 19 patch series "mm, swap: swap table phase II: unify swapin use"
  from Kairui Song removes some old swap code (swap cache bypassing and
  swap synchronization) which wasn't working very well.  Various other
  cleanups and simplifications were made.  The end result is a 20% speedup
  in one benchmark.

- The 8 patch series "enable PT_RECLAIM on more 64-bit architectures"
  from Qi Zheng makes PT_RECLAIM available on 64-bit alpha, loongarch,
  mips, parisc, um,  Various cleanups were performed along the way.

----------------------------------------------------------------
Aaron Yang (1):
      mm/damon/paddr: initialize 'folio' variables to NULL for clarity

Alexander Gordeev (1):
      powerpc/64s: do not re-activate batched TLB flush

Alexander Potapenko (2):
      mm: kmsan: add tests for high-order page freeing
      mm: kmsan: add test_uninit_page

Alice Ryhl (1):
      vmalloc: export vrealloc_node_align_noprof

Andrew Donnellan (2):
      arm64/mm: add addr parameter to __set_ptes_anysz()
      arm64/mm: add addr parameter to __ptep_get_and_clear_anysz()

Andrew Morton (2):
      mm/vmscan.c:shrink_folio_list(): save a tabstop
      Merge branch 'mm-hotfixes-stable' into mm-stable to pick up "mm/shmem, swap: fix race of truncate and swap entry split", needed for merging "mm, swap: cleanup swap entry management workflow".

Andrey Ryabinin (1):
      mm/kasan/kunit: extend vmalloc OOB tests to cover vrealloc()

Ankur Arora (7):
      mm: introduce clear_pages() and clear_user_pages()
      highmem: introduce clear_user_highpages()
      x86/mm: simplify clear_page_*
      x86/clear_page: introduce clear_pages()
      mm: folio_zero_user: clear pages sequentially
      mm: folio_zero_user: clear page ranges
      mm: folio_zero_user: cache neighbouring pages

Audra Mitchell (1):
      lib/test_vmalloc.c: minor fixes to test_vmalloc.c

Brendan Jackman (2):
      mm/vmalloc: clarify why vmap_range_noflush() might sleep
      mm: clarify GFP_ATOMIC/GFP_NOWAIT doc-comment

Chen Ridong (2):
      memcg: move mem_cgroup_usage memcontrol-v1.c
      memcg: remove mem_cgroup_size()

Chunyu Hu (5):
      selftests/mm: fix va_high_addr_switch.sh return value
      selftests/mm: allocate 6 hugepages in va_high_addr_switch.sh
      selftests/mm: remove arm64 nr_hugepages setup for va_high_addr_switch test
      selftests/mm: va_high_addr_switch return fail when either test failed
      selftests/mm: fix comment for check_test_requirements

David Hildenbrand (1):
      treewide: provide a generic clear_user_page() variant

David Hildenbrand (Red Hat) (26):
      vmw_balloon: adjust BALLOON_DEFLATE when deflating while migrating
      vmw_balloon: remove vmballoon_compaction_init()
      powerpc/pseries/cmm: remove cmm_balloon_compaction_init()
      mm/balloon_compaction: improve comments for WARN_ON_ONCE(!b_dev_info)
      mm/balloon_compaction: centralize basic page migration handling
      mm/balloon_compaction: centralize adjust_managed_page_count() handling
      vmw_balloon: stop using the balloon_dev_info lock
      mm/balloon_compaction: use a device-independent balloon (list) lock
      mm/balloon_compaction: remove dependency on page lock
      mm/balloon_compaction: make balloon_mops static
      mm/balloon_compaction: drop fs.h include from balloon_compaction.h
      drivers/virtio/virtio_balloon: stop using balloon_page_push/pop()
      mm/balloon_compaction: remove balloon_page_push/pop()
      mm/balloon_compaction: fold balloon_mapping_gfp_mask() into balloon_page_alloc()
      mm/balloon_compaction: move internal helpers to balloon_compaction.c
      mm/balloon_compaction: assert that the balloon_pages_lock is held
      mm/balloon_compaction: mark remaining functions for having proper kerneldoc
      mm/balloon_compaction: remove "extern" from functions
      mm/vmscan: drop inclusion of balloon_compaction.h
      mm: rename balloon_compaction.(c|h) to balloon.(c|h)
      mm/kconfig: make BALLOON_COMPACTION depend on MIGRATION
      mm: rename CONFIG_BALLOON_COMPACTION to CONFIG_BALLOON_MIGRATION
      mm: rename CONFIG_MEMORY_BALLOON -> CONFIG_BALLOON
      MAINTAINERS: move memory balloon infrastructure to "MEMORY MANAGEMENT - BALLOON"
      mm: move pte table reclaim code to memory.c
      mm/memory: handle non-split locks correctly in zap_empty_pte_table()

Deepanshu Kartikey (1):
      mm/vmalloc: prevent RCU stalls in kasan_release_vmalloc_node

Dennis Zhou (1):
      percpu: add double free check to pcpu_free_area()

Dipendra Khadka (1):
      mm/oom_kill: remove unnecessary integer promotion in format string

Enze Li (3):
      mm/damon/core: fix memory leak of repeat mode damon_call_control objects
      mm/damon/core: fix wasteful CPU calls by skipping non-existent targets
      mm/damon: unify address range representation with damon_addr_range

Greg Thelen (1):
      memcg-v1: remove folio_memcg_lock() doc reference

Gregory Price (2):
      mm, hugetlb: implement movable_gigantic_pages sysctl
      page_alloc: allow migration of smaller hugepages during contig_alloc

Heiko Carstens (1):
      zram: remove KMSG_COMPONENT macro

Hou Wenlong (2):
      mm/early_ioremap: print the starting physical address in __early_ioremap()
      mm/early_ioremap: clean up the use of WARN() for debugging

JaeJoon Jung (1):
      mm/damon/stat: deduplicate intervals_goal setup in damon_stat_build_ctx()

Jiayuan Chen (2):
      mm/vmscan: mitigate spurious kswapd_failures reset from direct reclaim
      mm/vmscan: add tracepoint and reason for kswapd_failures reset

Jinjiang Tu (1):
      mm/mempolicy: fix mpol_rebind_nodemask() for MPOL_F_NUMA_BALANCING

Joel Granados (1):
      alloc_tag: move memory_allocation_profiling_sysctls into .rodata

Johannes Weiner (3):
      mm: zswap: delete unused acomp->is_sleepable
      mm: memcontrol: rename mem_cgroup_from_slab_obj()
      mm/block/fs: remove laptop_mode

Joshua Hahn (2):
      mm/hugetlb: remove unnecessary if condition
      mm/hugetlb: enforce brace style

Justin Green (1):
      mm: refactor vma_map_pages to use vm_insert_pages

Kairui Song (19):
      mm/gup: remove no longer used gup_fast_undo_dev_pagemap
      mm, swap: rename __read_swap_cache_async to swap_cache_alloc_folio
      mm, swap: split swap cache preparation loop into a standalone helper
      mm, swap: never bypass the swap cache even for SWP_SYNCHRONOUS_IO
      mm, swap: always try to free swap cache for SWP_SYNCHRONOUS_IO devices
      mm, swap: simplify the code and reduce indention
      mm, swap: free the swap cache after folio is mapped
      mm/shmem: never bypass the swap cache for SWP_SYNCHRONOUS_IO
      mm, swap: swap entry of a bad slot should not be considered as swapped out
      mm, swap: consolidate cluster reclaim and usability check
      mm, swap: split locked entry duplicating into a standalone helper
      mm, swap: use swap cache as the swap in synchronize layer
      mm, swap: remove workaround for unsynchronized swap map cache state
      mm, swap: cleanup swap entry management workflow
      mm, swap: add folio to swap cache directly on allocation
      mm, swap: check swap table directly for checking cache
      mm, swap: clean up and improve swap entries freeing
      mm, swap: drop the SWAP_HAS_CACHE flag
      mm, swap: remove no longer needed _swap_info_get

Kaushlendra Kumar (2):
      tools/mm/thp_swap_allocator_test: fix small folio alignment
      tools/mm/slabinfo: fix --partial long option mapping

Kefeng Wang (11):
      mm: debug_vm_pgtable: add debug_vm_pgtable_free_huge_page()
      mm: page_alloc: add __split_page()
      mm: cma: kill cma_pages_valid()
      mm: page_alloc: add alloc_contig_frozen_{range,pages}()
      mm: cma: add cma_alloc_frozen{_compound}()
      mm: hugetlb: allocate frozen pages for gigantic allocation
      mm: page_isolation: introduce page_is_unmovable()
      mm: page_alloc: optimize pfn_range_valid_contig()
      mm: hugetlb: optimize replace_free_hugepage_folios()
      mm: hugetlb_cma: optimize hugetlb_cma_alloc_frozen_folio()
      mm: hugetlb_cma: mark hugetlb_cma{_only} as __ro_after_init

Kevin Brodsky (23):
      x86/xen: simplify flush_lazy_mmu()
      powerpc/mm: implement arch_flush_lazy_mmu_mode()
      sparc/mm: implement arch_flush_lazy_mmu_mode()
      mm: clarify lazy_mmu sleeping constraints
      mm: introduce CONFIG_ARCH_HAS_LAZY_MMU_MODE
      mm: introduce generic lazy_mmu helpers
      mm: bail out of lazy_mmu_mode_* in interrupt context
      mm: enable lazy_mmu sections to nest
      arm64: mm: replace TIF_LAZY_MMU with is_lazy_mmu_mode_active()
      powerpc/mm: replace batch->active with is_lazy_mmu_mode_active()
      sparc/mm: replace batch->active with is_lazy_mmu_mode_active()
      x86/xen: use lazy_mmu_state when context-switching
      mm: add basic tests for lazy_mmu
      sparc/mm: export symbols for lazy_mmu_mode KUnit tests
      selftests/mm: default KDIR to build directory
      selftests/mm: remove flaky header check
      selftests/mm: pass down full CC and CFLAGS to check_config.sh
      selftests/mm: fix usage of FORCE_READ() in cow tests
      selftests/mm: check that FORCE_READ() succeeded
      selftests/mm: introduce helper to read every page
      selftests/mm: fix faulting-in code in pagemap_ioctl test
      selftests/mm: fix exit code in pagemap_ioctl
      selftests/mm: report SKIP in pfnmap if a check fails

Kevin Lourenco (2):
      mm/damon: fix typos in comments
      mm: fix minor spelling mistakes in comments

Klara Modin (1):
      arm: make initialization of zero page independent of the memory map

Li RongQing (1):
      mm/damon/stat: remove __read_mostly from memory_idle_ms_percentiles

Li Wang (3):
      selftests/mm/write_to_hugetlbfs: parse -s as size_t
      selftests/mm/charge_reserved_hugetlb: drop mount size for hugetlbfs
      selftests/mm/charge_reserved_hugetlb.sh: add waits with timeout helper

Li Zhe (1):
      hugetlb: increase hugepage reservations when using node-specific "hugepages=" cmdline

Lorenzo Stoakes (20):
      mm/rmap: improve anon_vma_clone(), unlink_anon_vmas() comments, add asserts
      mm/rmap: eliminate partial anon_vma tear-down in anon_vma_fork()
      mm/rmap: skip unfaulted VMAs on anon_vma clone, unlink
      mm/rmap: remove unnecessary root lock dance in anon_vma clone, unmap
      mm/rmap: remove anon_vma_merge() function
      mm/rmap: make anon_vma functions internal
      mm/mmap_lock: add vma_is_attached() helper
      mm/rmap: allocate anon_vma_chain objects unlocked when possible
      mm/rmap: separate out fork-only logic on anon_vma_clone()
      selftests/mm: remove virtual_address_range test
      mm/vma: rename VMA_LOCK_OFFSET to VM_REFCNT_EXCLUDE_READERS_FLAG
      mm/vma: document possible vma->vm_refcnt values and reference comment
      mm/vma: rename is_vma_write_only(), separate out shared refcount put
      mm/vma: add+use vma lockdep acquire/release defines
      mm/vma: de-duplicate __vma_enter_locked() error path
      mm/vma: clean up __vma_enter/exit_locked()
      mm/vma: introduce helper struct + thread through exclusive lock fns
      mm/vma: improve and document __is_vma_write_locked()
      mm/vma: update vma_assert_locked() to use lockdep
      mm/vma: add and use vma_assert_stabilised()

Maninder Singh (1):
      kasan: remove unnecessary sync argument from start_report()

Manish Kumar (1):
      mm: drop filename from page_alloc.c header comment

Marco Crivellari (3):
      mm: replace use of system_unbound_wq with system_dfl_wq
      mm: replace use of system_wq with system_percpu_wq
      mm: add WQ_PERCPU to alloc_workqueue users

Mark Brown (1):
      selftests/mm: have the harness run each test category separately

Mathieu Desnoyers (1):
      mm: fix OOM killer inaccuracy on large many-core systems

Matthew Wilcox (Oracle) (1):
      migrate: replace RMP_ flags with TTU_ flags

Mike Rapoport (Microsoft) (28):
      alpha: introduce arch_zone_limits_init()
      arc: introduce arch_zone_limits_init()
      arm: introduce arch_zone_limits_init()
      arm64: introduce arch_zone_limits_init()
      csky: introduce arch_zone_limits_init()
      hexagon: introduce arch_zone_limits_init()
      loongarch: introduce arch_zone_limits_init()
      m68k: introduce arch_zone_limits_init()
      microblaze: introduce arch_zone_limits_init()
      mips: introduce arch_zone_limits_init()
      nios2: introduce arch_zone_limits_init()
      openrisc: introduce arch_zone_limits_init()
      parisc: introduce arch_zone_limits_init()
      powerpc: introduce arch_zone_limits_init()
      riscv: introduce arch_zone_limits_init()
      s390: introduce arch_zone_limits_init()
      sh: introduce arch_zone_limits_init()
      sparc: introduce arch_zone_limits_init()
      um: introduce arch_zone_limits_init()
      x86: introduce arch_zone_limits_init()
      xtensa: introduce arch_zone_limits_init()
      arch, mm: consolidate initialization of nodes, zones and memory map
      arch, mm: consolidate initialization of SPARSE memory model
      mips: drop paging_init()
      x86: don't reserve hugetlb memory in setup_arch()
      mm, arch: consolidate hugetlb CMA reservation
      mm/hugetlb: drop hugetlb_cma_check()
      Revert "mm/hugetlb: deal with multiple calls to hugetlb_bootmem_alloc"

Nhat Pham (1):
      mm/shmem, swap: remove SWAP_MAP_SHMEM

Qi Zheng (8):
      mm: change mm/pt_reclaim.c to use asm/tlb.h instead of asm-generic/tlb.h
      alpha: mm: enable MMU_GATHER_RCU_TABLE_FREE
      LoongArch: mm: enable MMU_GATHER_RCU_TABLE_FREE
      mips: mm: enable MMU_GATHER_RCU_TABLE_FREE
      parisc: mm: enable MMU_GATHER_RCU_TABLE_FREE
      um: mm: enable MMU_GATHER_RCU_TABLE_FREE
      mm: convert __HAVE_ARCH_TLB_REMOVE_TABLE to CONFIG_HAVE_ARCH_TLB_REMOVE_TABLE config
      mm: make PT_RECLAIM depends on MMU_GATHER_RCU_TABLE_FREE

Ran Xiaokai (1):
      alloc_tag: fix rw permission issue when handling boot parameter

Richard Chang (2):
      zram: introduce compressed data writeback
      zram: introduce writeback_compressed device attribute

Rohan McLure (10):
      mm/page_table_check: reinstate address parameter in [__]page_table_check_pud[s]_set()
      mm/page_table_check: reinstate address parameter in [__]page_table_check_pmd[s]_set()
      mm/page_table_check: provide addr parameter to page_table_check_ptes_set()
      mm/page_table_check: reinstate address parameter in [__]page_table_check_pud_clear()
      mm/page_table_check: reinstate address parameter in [__]page_table_check_pmd_clear()
      mm/page_table_check: reinstate address parameter in [__]page_table_check_pte_clear()
      mm: provide address parameter to p{te,md,ud}_user_accessible_page()
      powerpc/mm: implement *_user_accessible_page() for ptes
      powerpc/mm: use set_pte_at_unchecked() for internal usages
      powerpc/mm: support page table check

Sahil Chandna (2):
      mm/vmscan: use %pe to print error pointers
      mm/zswap: use %pe to print error pointers

SeongJae Park (49):
      mm/damon/core: introduce nr_snapshots damos stat
      mm/damon/sysfs-schemes: introduce nr_snapshots damos stat file
      Docs/mm/damon/design: update for nr_snapshots damos stat
      Docs/admin-guide/mm/damon/usage: update for nr_snapshots damos stat
      Docs/ABI/damon: update for nr_snapshots damos stat
      mm/damon: update damos kerneldoc for stat field
      mm/damon/core: implement max_nr_snapshots
      mm/damon/sysfs-schemes: implement max_nr_snapshots file
      Docs/mm/damon/design: update for max_nr_snapshots
      Docs/admin-guide/mm/damon/usage: update for max_nr_snapshots
      Docs/ABI/damon: update for max_nr_snapshots
      mm/damon/core: add trace point for damos stat per apply interval
      mm/damon/core: introduce [in]active memory ratio damos quota goal metric
      mm/damon/sysfs-schemes: support DAMOS_QUOTA_[IN]ACTIVE_MEM_BP
      Docs/mm/damon/design: document DAMOS_QUOTA_[IN]ACTIVE_MEM_BP
      mm/damon/paddr: activate DAMOS_LRU_PRIO targets instead of marking accessed
      mm/damon/lru_sort: consider age for quota prioritization
      mm/damon/lru_sort: support young page filters
      Docs/admin-guide/mm/damon/lru_sort: document filter_young_pages
      mm/damon/lru_sort: support active:inactive memory ratio based auto-tuning
      Docs/admin-guide/mm/damon/lru_sort: document active_mem_bp parameter
      mm/damon/lru_sort: add monitoring intervals auto-tuning parameter
      Docs/admin-guide/mm/damon/lru_sort: document intervals autotuning
      mm/damon/core: implement damon_kdamond_pid()
      mm/damon/sysfs: use damon_kdamond_pid()
      mm/damon/lru_sort: use damon_kdamond_pid()
      mm/damon/reclaim: use damon_kdamond_pid()
      mm/damon: hide kdamond and kdamond_lock of damon_ctx
      selftests/damon/sysfs_memcg_path_leak.sh: use kmemleak
      selftests/damon/wss_estimation: test for up to 160 MiB working set size
      selftests/damon/access_memory: add repeat mode
      selftests/damon/wss_estimation: ensure number of collected wss
      selftests/damon/wss_estimation: deduplicate failed samples output
      mm/damon: remove damon_operations->cleanup()
      mm/damon/core: cleanup targets and regions at once on kdamond termination
      mm/damon/core: cancel damos_walk() before damon_ctx->kdamond reset
      mm/damon/core: process damon_call_control requests on a local list
      mm/damon: document damon_call_control->dealloc_on_cancel repeat behavior
      mm/damon/core: rename damos_filter_out() to damos_core_filter_out()
      mm/damon: rename DAMON_MIN_REGION to DAMON_MIN_REGION_SZ
      mm/damon: rename min_sz_region of damon_ctx to min_region_sz
      Docs/mm/damon/index: simplify the intro
      Docs/mm/damon/design: link repology instead of Fedora package
      Docs/mm/damon/design: document DAMON sample modules
      Docs/mm/damon/design: add reference to DAMON_STAT usage
      Docs/admin-guide/mm/damon/usage: introduce DAMON modules at the beginning
      Docs/admin-guide/mm/damon/usage: update stats update process for refresh_ms
      Docs/mm/damon/maintainer-profile: fix wrong MAITNAINERS section name
      Docs/mm/damon/maintainer-profile: remove damon-tests/perf suggestion

Sergey Senozhatsky (14):
      zram: document writeback_batch_size
      zram: move bd_stat to writeback section
      zram: rename zram_free_page()
      zram: switch to guard() for init_lock
      zram: consolidate device-attr declarations
      zram: use u32 for entry ac_time tracking
      zram: rename internal slot API
      zram: trivial fix of recompress_slot() coding styles
      zram: fixup read_block_state()
      zram: drop pp_in_progress
      zsmalloc: use actual object size to detect spans
      zsmalloc: introduce SG-list based object read API
      zram: rename init_lock to dev_lock
      zsmalloc: make common caches global

Shakeel Butt (9):
      memcg: introduce private id API for in-kernel users
      memcg: expose mem_cgroup_ino() and mem_cgroup_get_from_ino() unconditionally
      memcg: mem_cgroup_get_from_ino() returns NULL on error
      memcg: use cgroup_id() instead of cgroup_ino() for memcg ID
      mm/damon: use cgroup ID instead of private memcg ID
      mm/vmscan: use cgroup ID instead of private memcg ID in lru_gen interface
      memcg: remove unused mem_cgroup_id() and mem_cgroup_from_id()
      memcg: rename mem_cgroup_ino() to mem_cgroup_id()
      mm: khugepaged: fix NR_FILE_PAGES and NR_SHMEM in collapse_file()

Shivank Garg (6):
      mm/khugepaged: map dirty/writeback pages failures to EAGAIN
      mm/khugepaged: retry with sync writeback for MADV_COLLAPSE
      mm/khugepaged: remove unnecessary goto 'skip' label
      mm/khugepaged: change collapse_pte_mapped_thp() to return void
      mm/khugepaged: use enum scan_result for result variables and return types
      mm/khugepaged: make khugepaged_collapse_control static

Shu Anzai (5):
      mm/damon/tests/core-kunit: verify the 'age' field in damon_test_split_at()
      mm/damon/tests/core-kunit: verify the 'age' and 'nr_accesses_bp' fields in damon_test_merge_two()
      mm/damon/tests/core-kunit: add a test case for region merge size limit in damon_test_merge_regions_of()
      mm/damon/tests/core-kunit: add test cases for multiple regions in damon_test_split_regions_of()
      mm/damon/tests/core-kunit: remove a redundant test case and add a new test case in damos_test_commit_quota_goal()

Sidhartha Kumar (1):
      maple_tree: remove struct maple_alloc

Swaraj Gaikwad (1):
      mm/damon/sysfs-schemes: remove outdated TODO in target_nid_store()

Taeyang Kim (1):
      mm: update kernel-doc for __swap_cache_clear_shadow()

Thorsten Blum (2):
      mm/mm_init: replace simple_strtoul with kstrtobool in set_hashdist
      mm/cma: replace snprintf with strscpy in cma_new_area

Tim Bird (1):
      mm: add SPDX id lines to some mm source files

Vlastimil Babka (4):
      mm, page_alloc, thp: prevent reclaim for __GFP_THISNODE THP allocations
      mm/page_alloc: ignore the exact initial compaction result
      mm/page_alloc: refactor the initial compaction handling
      mm/page_alloc: simplify __alloc_pages_slowpath() flow

Wei Yang (2):
      mm/vmstat: remove unused node and zone state helpers
      mm/mmu_gather: remove @delay_remap of __tlb_remove_page_size()

Weilin Tong (1):
      mm/shmem: add mTHP swpout fallback statistics in shmem_writeout()

Wentao Guan (1):
      mm: cleanup vma_iter_bulk_alloc

William Tambe (1):
      mm/highmem: fix __kmap_to_page() build error

Wilson Zeng (1):
      mm/readahead: fix typo in comment

Xiu Jianfeng (1):
      mm/hugetlb_cgroup: fix -Wformat-truncation warning

Yosry Ahmed (2):
      zsmalloc: simplify read begin/end logic
      mm: zswap: use SG list decompression APIs from zsmalloc

Yury Norov (3):
      nodemask: propagate boolean for nodes_and{,not}
      mm: use nodes_and() return value to simplify client code
      cgroup: use nodes_and() output where appropriate

zenghongling (1):
      mm/pagewalk: use min() to simplify the code

 Documentation/ABI/testing/sysfs-block-zram         |  14 +
 Documentation/ABI/testing/sysfs-kernel-mm-damon    |  13 +
 Documentation/admin-guide/blockdev/zram.rst        |  24 +-
 Documentation/admin-guide/cgroup-v1/memory.rst     |   5 +-
 Documentation/admin-guide/laptops/index.rst        |   1 -
 Documentation/admin-guide/laptops/laptop-mode.rst  | 770 ----------------
 Documentation/admin-guide/mm/damon/lru_sort.rst    |  37 +
 Documentation/admin-guide/mm/damon/usage.rst       |  19 +-
 Documentation/admin-guide/mm/memory-hotplug.rst    |  22 +-
 Documentation/admin-guide/sysctl/vm.rst            |  36 +-
 Documentation/core-api/mm-api.rst                  |   2 +-
 Documentation/driver-api/cxl/linux/early-boot.rst  |   2 +-
 Documentation/mm/damon/design.rst                  |  32 +-
 Documentation/mm/damon/index.rst                   |  31 +-
 Documentation/mm/damon/maintainer-profile.rst      |   7 +-
 Documentation/mm/memory-model.rst                  |   3 -
 .../translations/zh_CN/mm/memory-model.rst         |   2 -
 MAINTAINERS                                        |  14 +-
 arch/alpha/Kconfig                                 |   1 +
 arch/alpha/include/asm/page.h                      |   1 -
 arch/alpha/include/asm/tlb.h                       |   6 +-
 arch/alpha/kernel/setup.c                          |   1 -
 arch/alpha/mm/init.c                               |  16 +-
 arch/arc/include/asm/page.h                        |   2 +
 arch/arc/mm/init.c                                 |  37 +-
 arch/arm/include/asm/page-nommu.h                  |   1 -
 arch/arm/include/asm/pgtable.h                     |   4 +-
 arch/arm/mm/init.c                                 |  25 +-
 arch/arm/mm/mmu.c                                  |  10 +-
 arch/arm/mm/nommu.c                                |  10 +-
 arch/arm64/Kconfig                                 |   1 +
 arch/arm64/include/asm/hugetlb.h                   |   2 -
 arch/arm64/include/asm/page.h                      |   1 -
 arch/arm64/include/asm/pgtable.h                   |  87 +-
 arch/arm64/include/asm/thread_info.h               |   3 +-
 arch/arm64/mm/hugetlbpage.c                        |  27 +-
 arch/arm64/mm/init.c                               |  39 +-
 arch/arm64/mm/mmu.c                                |   8 +-
 arch/arm64/mm/pageattr.c                           |   4 +-
 arch/csky/abiv1/inc/abi/page.h                     |   1 +
 arch/csky/abiv2/inc/abi/page.h                     |   7 -
 arch/csky/kernel/setup.c                           |  16 +-
 arch/hexagon/include/asm/page.h                    |   1 -
 arch/hexagon/mm/init.c                             |  19 +-
 arch/loongarch/Kconfig                             |   1 +
 arch/loongarch/include/asm/page.h                  |   1 -
 arch/loongarch/include/asm/pgalloc.h               |   7 +-
 arch/loongarch/include/asm/pgtable.h               |   2 -
 arch/loongarch/kernel/setup.c                      |  10 -
 arch/loongarch/mm/init.c                           |   6 +-
 arch/m68k/include/asm/page_no.h                    |   1 -
 arch/m68k/mm/init.c                                |   8 +-
 arch/m68k/mm/mcfmmu.c                              |   3 -
 arch/m68k/mm/motorola.c                            |   6 +-
 arch/m68k/mm/sun3mmu.c                             |   9 -
 arch/microblaze/include/asm/page.h                 |   1 -
 arch/microblaze/mm/init.c                          |  22 +-
 arch/mips/Kconfig                                  |   1 +
 arch/mips/include/asm/page.h                       |   1 +
 arch/mips/include/asm/pgalloc.h                    |   9 +-
 arch/mips/include/asm/pgtable.h                    |   2 +-
 arch/mips/kernel/setup.c                           |  15 +-
 arch/mips/loongson64/numa.c                        |  10 +-
 arch/mips/mm/init.c                                |   8 +-
 arch/mips/sgi-ip27/ip27-memory.c                   |   8 +-
 arch/nios2/include/asm/page.h                      |   1 +
 arch/nios2/mm/init.c                               |  12 +-
 arch/openrisc/include/asm/page.h                   |   1 -
 arch/openrisc/mm/init.c                            |  10 +-
 arch/parisc/Kconfig                                |   1 +
 arch/parisc/include/asm/page.h                     |   1 -
 arch/parisc/include/asm/tlb.h                      |   4 +-
 arch/parisc/mm/init.c                              |  11 +-
 arch/powerpc/Kconfig                               |   2 +
 arch/powerpc/include/asm/book3s/32/pgtable.h       |  12 +-
 arch/powerpc/include/asm/book3s/64/pgtable.h       |  62 +-
 arch/powerpc/include/asm/book3s/64/tlbflush-hash.h |  20 +-
 arch/powerpc/include/asm/hugetlb.h                 |   5 -
 arch/powerpc/include/asm/nohash/pgtable.h          |  13 +-
 arch/powerpc/include/asm/page.h                    |   1 +
 arch/powerpc/include/asm/pgtable.h                 |  10 +
 arch/powerpc/include/asm/setup.h                   |   4 +
 arch/powerpc/include/asm/thread_info.h             |   2 -
 arch/powerpc/include/asm/tlb.h                     |   1 -
 arch/powerpc/kernel/process.c                      |  25 -
 arch/powerpc/kernel/setup-common.c                 |   1 -
 arch/powerpc/mm/book3s64/hash_pgtable.c            |   4 +
 arch/powerpc/mm/book3s64/hash_tlb.c                |  14 +-
 arch/powerpc/mm/book3s64/pgtable.c                 |  25 +-
 arch/powerpc/mm/book3s64/radix_pgtable.c           |   9 +-
 arch/powerpc/mm/book3s64/subpage_prot.c            |   4 +-
 arch/powerpc/mm/hugetlbpage.c                      |  11 +-
 arch/powerpc/mm/mem.c                              |  27 +-
 arch/powerpc/mm/numa.c                             |   2 -
 arch/powerpc/mm/pgtable.c                          |  12 +
 arch/powerpc/platforms/Kconfig.cputype             |   1 +
 arch/powerpc/platforms/pseries/Kconfig             |   2 +-
 arch/powerpc/platforms/pseries/cmm.c               |  53 +-
 arch/riscv/include/asm/page.h                      |   1 -
 arch/riscv/include/asm/pgtable.h                   |  22 +-
 arch/riscv/mm/hugetlbpage.c                        |   8 +
 arch/riscv/mm/init.c                               |  10 +-
 arch/s390/include/asm/page.h                       |   1 -
 arch/s390/include/asm/tlb.h                        |   6 +-
 arch/s390/kernel/setup.c                           |   2 -
 arch/s390/mm/gmap_helpers.c                        |   2 +-
 arch/s390/mm/hugetlbpage.c                         |   8 +
 arch/s390/mm/init.c                                |  13 +-
 arch/s390/mm/pgtable.c                             |   2 +-
 arch/sh/mm/init.c                                  |  12 +-
 arch/sparc/Kconfig                                 |   2 +
 arch/sparc/include/asm/page_64.h                   |   1 +
 arch/sparc/include/asm/tlb_64.h                    |   1 -
 arch/sparc/include/asm/tlbflush_64.h               |   5 +-
 arch/sparc/mm/init_64.c                            |  17 +-
 arch/sparc/mm/srmmu.c                              |  17 +-
 arch/sparc/mm/tlb.c                                |  20 +-
 arch/um/Kconfig                                    |   1 +
 arch/um/include/asm/page.h                         |   1 -
 arch/um/kernel/mem.c                               |  10 +-
 arch/x86/Kconfig                                   |   2 +-
 arch/x86/boot/compressed/misc.h                    |   1 +
 arch/x86/boot/startup/sme.c                        |   1 +
 arch/x86/include/asm/page.h                        |   6 -
 arch/x86/include/asm/page_32.h                     |   6 +
 arch/x86/include/asm/page_64.h                     |  78 +-
 arch/x86/include/asm/paravirt.h                    |   1 -
 arch/x86/include/asm/pgtable.h                     |  23 +-
 arch/x86/include/asm/thread_info.h                 |   4 +-
 arch/x86/kernel/setup.c                            |   5 -
 arch/x86/lib/clear_page_64.S                       |  39 +-
 arch/x86/mm/hugetlbpage.c                          |   8 +
 arch/x86/mm/init.c                                 |   8 +-
 arch/x86/mm/init_32.c                              |   2 -
 arch/x86/mm/init_64.c                              |   4 -
 arch/x86/mm/mm_internal.h                          |   1 -
 arch/x86/xen/enlighten_pv.c                        |   3 +-
 arch/x86/xen/mmu_pv.c                              |   6 +-
 arch/xtensa/include/asm/page.h                     |   1 -
 arch/xtensa/mm/init.c                              |  14 +-
 block/blk-mq.c                                     |   3 -
 drivers/block/zram/zram_drv.c                      | 999 ++++++++++++---------
 drivers/block/zram/zram_drv.h                      |  15 +-
 drivers/misc/Kconfig                               |   2 +-
 drivers/misc/vmw_balloon.c                         | 105 +--
 drivers/virtio/Kconfig                             |   2 +-
 drivers/virtio/virtio_balloon.c                    |  64 +-
 fs/ext4/inode.c                                    |   3 +-
 fs/proc/task_mmu.c                                 |   4 +-
 fs/sync.c                                          |   2 -
 fs/xfs/xfs_super.c                                 |   9 -
 include/asm-generic/tlb.h                          |   7 +-
 include/linux/backing-dev-defs.h                   |   3 -
 include/linux/balloon.h                            |  77 ++
 include/linux/balloon_compaction.h                 | 160 ----
 include/linux/cma.h                                |  27 +-
 include/linux/damon.h                              |  65 +-
 include/linux/gfp.h                                |  60 +-
 include/linux/gfp_types.h                          |   7 +-
 include/linux/highmem.h                            |  98 +-
 include/linux/hugetlb.h                            |  15 +-
 include/linux/khugepaged.h                         |   9 +-
 include/linux/maple_tree.h                         |   9 -
 include/linux/memblock.h                           |   4 +-
 include/linux/memcontrol.h                         |  48 +-
 include/linux/mm.h                                 |  72 +-
 include/linux/mm_types.h                           |  57 +-
 include/linux/mm_types_task.h                      |   5 +
 include/linux/mmap_lock.h                          | 279 +++++-
 include/linux/mmdebug.h                            |  10 +
 include/linux/mmzone.h                             |  19 +-
 include/linux/nodemask.h                           |   8 +-
 include/linux/page-isolation.h                     |   2 +
 include/linux/page_table_check.h                   |  69 +-
 include/linux/pgtable.h                            | 168 +++-
 include/linux/rmap.h                               |  76 +-
 include/linux/sched.h                              |  45 +
 include/linux/swap.h                               |  71 +-
 include/linux/vm_event_item.h                      |   8 +-
 include/linux/vmstat.h                             |   6 -
 include/linux/writeback.h                          |   4 -
 include/linux/zsmalloc.h                           |   8 +-
 include/trace/events/damon.h                       |  41 +
 include/trace/events/huge_memory.h                 |   3 +-
 include/trace/events/vmscan.h                      |  51 ++
 include/trace/events/writeback.h                   |   1 -
 include/uapi/linux/mempolicy.h                     |   3 +
 include/uapi/linux/sysctl.h                        |   2 +-
 init/main.c                                        |   1 +
 kernel/cgroup/cpuset.c                             |   7 +-
 kernel/power/swap.c                                |  10 +-
 lib/alloc_tag.c                                    |  27 +-
 lib/test_vmalloc.c                                 |  11 +-
 mm/Kconfig                                         |  48 +-
 mm/Makefile                                        |   4 +-
 mm/backing-dev.c                                   |   9 +-
 mm/{balloon_compaction.c => balloon.c}             | 199 ++--
 mm/cma.c                                           | 125 +--
 mm/damon/core.c                                    | 242 ++---
 mm/damon/lru_sort.c                                | 120 ++-
 mm/damon/paddr.c                                   |  27 +-
 mm/damon/reclaim.c                                 |  10 +-
 mm/damon/stat.c                                    |  14 +-
 mm/damon/sysfs-schemes.c                           |  58 +-
 mm/damon/sysfs.c                                   |  18 +-
 mm/damon/tests/core-kunit.h                        |  51 +-
 mm/damon/tests/vaddr-kunit.h                       |   2 +-
 mm/damon/vaddr.c                                   |  25 +-
 mm/debug_vm_pgtable.c                              |  38 +-
 mm/dmapool_test.c                                  |   1 +
 mm/early_ioremap.c                                 |  16 +-
 mm/folio-compat.c                                  |   1 +
 mm/gup.c                                           |  11 -
 mm/gup_test.c                                      |   1 +
 mm/highmem.c                                       |   3 +-
 mm/huge_memory.c                                   |   8 +-
 mm/hugetlb.c                                       | 180 ++--
 mm/hugetlb_cgroup.c                                |  11 +-
 mm/hugetlb_cma.c                                   |  71 +-
 mm/hugetlb_cma.h                                   |  15 +-
 mm/hugetlb_sysctl.c                                |  11 +
 mm/hugetlb_vmemmap.c                               |  11 -
 mm/internal.h                                      | 106 ++-
 mm/kasan/kasan_test_c.c                            |  50 +-
 mm/kasan/report.c                                  |   8 +-
 mm/kasan/shadow.c                                  |   8 +-
 mm/kfence/core.c                                   |   6 +-
 mm/khugepaged.c                                    | 185 ++--
 mm/kmsan/kmsan_test.c                              |  64 +-
 mm/list_lru.c                                      |   6 +-
 mm/madvise.c                                       |  26 +-
 mm/memblock.c                                      |   4 +-
 mm/memcontrol-v1.c                                 |  28 +-
 mm/memcontrol-v1.h                                 |   6 +-
 mm/memcontrol.c                                    |  99 +-
 mm/memfd.c                                         |   3 +-
 mm/memory-failure.c                                |   2 +-
 mm/memory-tiers.c                                  |   7 +-
 mm/memory.c                                        | 451 ++++++----
 mm/memory_hotplug.c                                |   8 +-
 mm/mempolicy.c                                     |   5 +-
 mm/migrate.c                                       |  14 +-
 mm/migrate_device.c                                |  12 +-
 mm/mm_init.c                                       |  35 +-
 mm/mmap_lock.c                                     | 177 ++--
 mm/mmu_gather.c                                    |   6 +-
 mm/mprotect.c                                      |   4 +-
 mm/mremap.c                                        |  10 +-
 mm/mseal.c                                         |   4 +-
 mm/numa_memblks.c                                  |   2 +-
 mm/oom_kill.c                                      |  26 +-
 mm/page-writeback.c                                |  74 +-
 mm/page_alloc.c                                    | 425 +++++----
 mm/page_io.c                                       |   4 +-
 mm/page_isolation.c                                | 189 ++--
 mm/page_reporting.c                                |   2 +-
 mm/page_table_check.c                              |  41 +-
 mm/pagewalk.c                                      |   3 +-
 mm/percpu.c                                        |  15 +-
 mm/pt_reclaim.c                                    |  72 --
 mm/readahead.c                                     |   2 +-
 mm/rmap.c                                          | 324 ++++---
 mm/shmem.c                                         |  90 +-
 mm/show_mem.c                                      |   3 +-
 mm/shrinker_debug.c                                |  13 +-
 mm/slub.c                                          |   3 +-
 mm/swap.c                                          |   2 +-
 mm/swap.h                                          |  72 +-
 mm/swap_state.c                                    | 342 ++++---
 mm/swapfile.c                                      | 862 ++++++++----------
 mm/tests/lazy_mmu_mode_kunit.c                     |  73 ++
 mm/userfaultfd.c                                   |  18 +-
 mm/vma.c                                           |  16 +-
 mm/vma.h                                           |  14 +-
 mm/vmalloc.c                                       |  26 +-
 mm/vmscan.c                                        | 221 ++---
 mm/vmstat.c                                        |  30 +-
 mm/workingset.c                                    |   8 +-
 mm/zsmalloc.c                                      | 192 ++--
 mm/zswap.c                                         |  58 +-
 tools/mm/slabinfo.c                                |   2 +-
 tools/mm/thp_swap_allocator_test.c                 |   2 +-
 tools/testing/selftests/damon/access_memory.c      |  29 +-
 .../selftests/damon/sysfs_memcg_path_leak.sh       |  26 +-
 ..._update_schemes_tried_regions_wss_estimation.py |  41 +-
 tools/testing/selftests/mm/.gitignore              |   1 -
 tools/testing/selftests/mm/Makefile                |  44 +-
 .../selftests/mm/charge_reserved_hugetlb.sh        |  55 +-
 tools/testing/selftests/mm/check_config.sh         |   3 +-
 tools/testing/selftests/mm/cow.c                   |  43 +-
 tools/testing/selftests/mm/hugetlb-madvise.c       |   9 +-
 tools/testing/selftests/mm/ksft_compaction.sh      |   4 +
 tools/testing/selftests/mm/ksft_cow.sh             |   4 +
 tools/testing/selftests/mm/ksft_gup_test.sh        |   4 +
 tools/testing/selftests/mm/ksft_hmm.sh             |   4 +
 tools/testing/selftests/mm/ksft_hugetlb.sh         |   4 +
 tools/testing/selftests/mm/ksft_hugevm.sh          |   4 +
 tools/testing/selftests/mm/ksft_ksm.sh             |   4 +
 tools/testing/selftests/mm/ksft_ksm_numa.sh        |   4 +
 tools/testing/selftests/mm/ksft_madv_guard.sh      |   4 +
 tools/testing/selftests/mm/ksft_madv_populate.sh   |   4 +
 tools/testing/selftests/mm/ksft_mdwe.sh            |   4 +
 tools/testing/selftests/mm/ksft_memfd_secret.sh    |   4 +
 tools/testing/selftests/mm/ksft_migration.sh       |   4 +
 tools/testing/selftests/mm/ksft_mkdirty.sh         |   4 +
 tools/testing/selftests/mm/ksft_mlock.sh           |   4 +
 tools/testing/selftests/mm/ksft_mmap.sh            |   4 +
 tools/testing/selftests/mm/ksft_mremap.sh          |   4 +
 tools/testing/selftests/mm/ksft_page_frag.sh       |   4 +
 tools/testing/selftests/mm/ksft_pagemap.sh         |   4 +
 tools/testing/selftests/mm/ksft_pfnmap.sh          |   4 +
 tools/testing/selftests/mm/ksft_pkey.sh            |   4 +
 tools/testing/selftests/mm/ksft_process_madv.sh    |   4 +
 .../testing/selftests/mm/ksft_process_mrelease.sh  |   4 +
 tools/testing/selftests/mm/ksft_rmap.sh            |   4 +
 tools/testing/selftests/mm/ksft_soft_dirty.sh      |   4 +
 tools/testing/selftests/mm/ksft_thp.sh             |   4 +
 tools/testing/selftests/mm/ksft_userfaultfd.sh     |   4 +
 tools/testing/selftests/mm/ksft_vma_merge.sh       |   4 +
 tools/testing/selftests/mm/ksft_vmalloc.sh         |   4 +
 tools/testing/selftests/mm/page_frag/Makefile      |   2 +-
 tools/testing/selftests/mm/pagemap_ioctl.c         |  15 +-
 tools/testing/selftests/mm/pfnmap.c                |  93 +-
 tools/testing/selftests/mm/run_vmtests.sh          |  24 +-
 tools/testing/selftests/mm/split_huge_page_test.c  |   6 +-
 tools/testing/selftests/mm/test_vmalloc.sh         |  31 +-
 tools/testing/selftests/mm/va_high_addr_switch.c   |  10 +-
 tools/testing/selftests/mm/va_high_addr_switch.sh  |  12 +-
 tools/testing/selftests/mm/virtual_address_range.c | 260 ------
 tools/testing/selftests/mm/vm_util.h               |   7 +
 tools/testing/selftests/mm/write_to_hugetlbfs.c    |   9 +-
 tools/testing/vma/vma_internal.h                   |  16 +-
 332 files changed, 6241 insertions(+), 5595 deletions(-)
 delete mode 100644 Documentation/admin-guide/laptops/laptop-mode.rst
 create mode 100644 include/linux/balloon.h
 delete mode 100644 include/linux/balloon_compaction.h
 rename mm/{balloon_compaction.c => balloon.c} (58%)
 delete mode 100644 mm/pt_reclaim.c
 create mode 100644 mm/tests/lazy_mmu_mode_kunit.c
 create mode 100755 tools/testing/selftests/mm/ksft_compaction.sh
 create mode 100755 tools/testing/selftests/mm/ksft_cow.sh
 create mode 100755 tools/testing/selftests/mm/ksft_gup_test.sh
 create mode 100755 tools/testing/selftests/mm/ksft_hmm.sh
 create mode 100755 tools/testing/selftests/mm/ksft_hugetlb.sh
 create mode 100755 tools/testing/selftests/mm/ksft_hugevm.sh
 create mode 100755 tools/testing/selftests/mm/ksft_ksm.sh
 create mode 100755 tools/testing/selftests/mm/ksft_ksm_numa.sh
 create mode 100755 tools/testing/selftests/mm/ksft_madv_guard.sh
 create mode 100755 tools/testing/selftests/mm/ksft_madv_populate.sh
 create mode 100755 tools/testing/selftests/mm/ksft_mdwe.sh
 create mode 100755 tools/testing/selftests/mm/ksft_memfd_secret.sh
 create mode 100755 tools/testing/selftests/mm/ksft_migration.sh
 create mode 100755 tools/testing/selftests/mm/ksft_mkdirty.sh
 create mode 100755 tools/testing/selftests/mm/ksft_mlock.sh
 create mode 100755 tools/testing/selftests/mm/ksft_mmap.sh
 create mode 100755 tools/testing/selftests/mm/ksft_mremap.sh
 create mode 100755 tools/testing/selftests/mm/ksft_page_frag.sh
 create mode 100755 tools/testing/selftests/mm/ksft_pagemap.sh
 create mode 100755 tools/testing/selftests/mm/ksft_pfnmap.sh
 create mode 100755 tools/testing/selftests/mm/ksft_pkey.sh
 create mode 100755 tools/testing/selftests/mm/ksft_process_madv.sh
 create mode 100755 tools/testing/selftests/mm/ksft_process_mrelease.sh
 create mode 100755 tools/testing/selftests/mm/ksft_rmap.sh
 create mode 100755 tools/testing/selftests/mm/ksft_soft_dirty.sh
 create mode 100755 tools/testing/selftests/mm/ksft_thp.sh
 create mode 100755 tools/testing/selftests/mm/ksft_userfaultfd.sh
 create mode 100755 tools/testing/selftests/mm/ksft_vma_merge.sh
 create mode 100755 tools/testing/selftests/mm/ksft_vmalloc.sh
 delete mode 100644 tools/testing/selftests/mm/virtual_address_range.c

