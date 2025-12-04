Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E9742F361F;
	Thu,  4 Dec 2025 05:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764826160; cv=none; b=k2b617ZaqeR9fWaBif5m5TFi+KdI6BlhEyCl7IXeWgG3H+Iiw6zJicsKMqD1PzsF4plaOUQ0IfsAcJo6ZM1UoLACupTtPQ7j84wYtotjSGGOzBTb2C0mgXK1Ka0s1+XJykd7zghreZAysL2kTirDFnF5sOp3U4VH/0CniI87V3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764826160; c=relaxed/simple;
	bh=dqVhcMBaP8vWx2Ac3Qa7So6jeQcWp+6p3/+ZxhpzGgU=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=HdfzGqK4a0pZiabw6U5cY0q3J43Ul7yWs0gKEb+bI6dPwNZzbq5ANuiQbfFb6FjD252DDPWKKIrmBKnkT/l0B4jCH2nMxRnKo0nkruMjEpRQT/cvQgxJjKAcAUymAvgfuMGFwgVjlMSdgZpvYn1NsylsT0Aac5WVHIGxes8NpVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=b1xpIVxA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b1xpIVxA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F4DEC113D0;
	Thu,  4 Dec 2025 05:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764826159;
	bh=dqVhcMBaP8vWx2Ac3Qa7So6jeQcWp+6p3/+ZxhpzGgU=;
	h=Date:From:To:Cc:Subject:From;
	b=b1xpIVxA0GK4CgA4SuFtN0ZrAG3bAgWuRk9/FYTWpraGxfWBWKhOH7FgX+LmN3PJj
	 2fZKW4HQo6rwvyC70tehGr3otalyvVSRH37Kd9u9Mu9ZxvBAODQVWfkl6bo+xO7joP
	 SSaGADbMIO1waMZT+CdHOs5jahElmbtVqG1t8CsM=
Date: Wed, 3 Dec 2025 21:29:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 mm-commits@vger.kernel.org
Subject: [GIT PULL] MM updates for 6.19-rc1
Message-Id: <20251203212918.82f1c9d3947940aeae263878@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Linus, please merge this main batch of MM updates for the 6.19-rc
cycle.  There will be another much smaller MM batch next week.

Thanks.


Merge failures which I am seeing and their linux-next resolutions are
as follows:

arch/arm64/mm/mmu.c, vs arm64 tree:
https://lkml.kernel.org/r/20251114112144.366698c7@canb.auug.org.au

include/linux/memory.h, vs s390 tree:
https://lkml.kernel.org/r/20251103100750.4522060e@canb.auug.org.au

mm/memory.c, vs arm64 tree:
https://lkml.kernel.org/r/20251120102532.670ba5b6@canb.auug.org.au

mm/secretmem.c, vs vfs-brauner tree:
https://lkml.kernel.org/r/20251125122934.36f75838@canb.auug.org.au


Forthcoming merge failures and their linux-next resolutions are as follows:

arch/riscv/include/asm/hwcap.h, vs risc-v tree:
https://lkml.kernel.org/r/20251124120543.7dee3c33@canb.auug.org.au

arch/riscv/include/asm/hwcap.h, vs risc-v tree:
https://lkml.kernel.org/r/20251126094830.3b3ed57c@canb.auug.org.au
https://lkml.kernel.org/r/20251128101000.151a81f7@canb.auug.org.au

include/linux/mm.h, vs risc-v tree:
https://lkml.kernel.org/r/20251128102707.15b3f283@canb.auug.org.au


Forthcoming build failures and their linux-next resolutions are as follows:

drivers/vfio/pci/nvgrace-gpu/main.c, vs vfio tree:
https://lkml.kernel.org/r/20251201114439.4fab07f6@canb.auug.org.au



The following changes since commit 7c9580f44f90f7a4c11fc7831efe323ebe446091:

  mm/filemap: fix logic around SIGBUS in filemap_map_pages() (2025-11-24 14:25:18 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2025-12-03-21-26

for you to fetch changes up to faf3c923523e5c8fc3baaa413d62e913774ae52f:

  mm: fix vma_start_write_killable() signal handling (2025-11-29 10:41:11 -0800)

----------------------------------------------------------------
Significant patch series in this merge are as follows:

- The 10 patch series "__vmalloc()/kvmalloc() and no-block support" from
  Uladzislau Rezki reworks the vmalloc() code to support non-blocking
  allocations (GFP_ATOIC, GFP_NOWAIT).

- The 2 patch series "ksm: fix exec/fork inheritance" from xu xin fixes
  a rare case where the KSM MMF_VM_MERGE_ANY prctl state is not inherited
  across fork/exec.

- The 4 patch series "mm/zswap: misc cleanup of code and documentations"
  from SeongJae Park does some light maintenance work on the zswap code.

- The 5 patch series "mm/page_owner: add debugfs files 'show_handles'
  and 'show_stacks_handles'" from Mauricio Faria de Oliveira enhances the
  /sys/kernel/debug/page_owner debug feature.  It adds unique identifiers
  to differentiate the various stack traces so that userspace monitoring
  tools can better match stack traces over time.

- The 2 patch series "mm/page_alloc: pcp->batch cleanups" from Joshua
  Hahn makes some minor alterations to the page allocator's per-cpu-pages
  feature.

- The 2 patch series "Improve UFFDIO_MOVE scalability by removing
  anon_vma lock" from Lokesh Gidra addresses a scalability issue in
  userfaultfd's UFFDIO_MOVE operation.

- The 2 patch series "kasan: cleanups for kasan_enabled() checks" from
  Sabyrzhan Tasbolatov performs some cleanup in the KASAN code.

- The 2 patch series "drivers/base/node: fold node register and
  unregister functions" from Donet Tom cleans up the NUMA node handling
  code a little.

- The 4 patch series "mm: some optimizations for prot numa" from Kefeng
  Wang provides some cleanups and small optimizations to the NUMA
  allocation hinting code.

- The 5 patch series "mm/page_alloc: Batch callers of
  free_pcppages_bulk" from Joshua Hahn addresses long lock hold times at
  boot on large machines.  These were causing (harmless) softlockup
  warnings.

- The 2 patch series "optimize the logic for handling dirty file folios
  during reclaim" from Baolin Wang removes some now-unnecessary work from
  page reclaim.

- The 10 patch series "mm/damon: allow DAMOS auto-tuned for per-memcg
  per-node memory usage" from SeongJae Park enhances the DAMOS auto-tuning
  feature.

- The 2 patch series "mm/damon: fixes for address alignment issues in
  DAMON_LRU_SORT and DAMON_RECLAIM" from Quanmin Yan fixes DAMON_LRU_SORT
  and DAMON_RECLAIM with certain userspace configuration.

- The 15 patch series "expand mmap_prepare functionality, port more
  users" from Lorenzo Stoakes enhances the new(ish)
  file_operations.mmap_prepare() method and ports additional callsites
  from the old ->mmap() over to ->mmap_prepare().

- The 8 patch series "Fix stale IOTLB entries for kernel address space"
  from Lu Baolu fixes a bug (and possible security issue on non-x86) in
  the IOMMU code.  In some situations the IOMMU could be left hanging onto
  a stale kernel pagetable entry.

- The 4 patch series "mm/huge_memory: cleanup __split_unmapped_folio()"
  from Wei Yang cleans up and optimizes the folio splitting code.

- The 5 patch series "mm, swap: misc cleanup and bugfix" from Kairui
  Song implements some cleanups and a minor fix in the swap discard code.

- The 8 patch series "mm/damon: misc documentation fixups" from SeongJae
  Park does as advertised.

- The 9 patch series "mm/damon: support pin-point targets removal" from
  SeongJae Park permits userspace to remove a specific monitoring target
  in the middle of the current targets list.

- The 2 patch series "mm: MISC follow-up patches for linux/pgalloc.h"
  from Harry Yoo implements a couple of cleanups related to mm header file
  inclusion.

- The 2 patch series "mm/swapfile.c: select swap devices of default
  priority round robin" from Baoquan He improves the selection of swap
  devices for NUMA machines.

- The 3 patch series "mm: Convert memory block states (MEM_*) macros to
  enums" from Israel Batista changes the memory block labels from macros
  to enums so they will appear in kernel debug info.

- The 3 patch series "ksm: perform a range-walk to jump over holes in
  break_ksm" from Pedro Demarchi Gomes addresses an inefficiency when KSM
  unmerges an address range.

- The 22 patch series "mm/damon/tests: fix memory bugs in kunit tests"
  from SeongJae Park fixes leaks and unhandled malloc() failures in DAMON
  userspace unit tests.

- The 2 patch series "some cleanups for pageout()" from Baolin Wang
  cleans up a couple of minor things in the page scanner's
  writeback-for-eviction code.

- The 2 patch series "mm/hugetlb: refactor sysfs/sysctl interfaces" from
  Hui Zhu moves hugetlb's sysfs/sysctl handling code into a new file.

- The 9 patch series "introduce VM_MAYBE_GUARD and make it sticky" from
  Lorenzo Stoakes makes the VMA guard regions available in /proc/pid/smaps
  and improves the mergeability of guarded VMAs.

- The 2 patch series "mm: perform guard region install/remove under VMA
  lock" from Lorenzo Stoakes reduces mmap lock contention for callers
  performing VMA guard region operations.

- The 2 patch series "vma_start_write_killable" from Matthew Wilcox
  starts work in permitting applications to be killed when they are
  waiting on a read_lock on the VMA lock.

- The 11 patch series "mm/damon/tests: add more tests for online
  parameters commit" from SeongJae Park adds additional userspace testing
  of DAMON's "commit" feature.

- The 9 patch series "mm/damon: misc cleanups" from SeongJae Park does
  that.

- The 2 patch series "make VM_SOFTDIRTY a sticky VMA flag" from Lorenzo
  Stoakes addresses the possible loss of a VMA's VM_SOFTDIRTY flag when
  that VMA is merged with another.

- The 16 patch series "mm: support device-private THP" from Balbir Singh
  introduces support for Transparent Huge Page (THP) migration in zone
  device-private memory.

- The 3 patch series "Optimize folio split in memory failure" from Zi
  Yan optimizes folio split operations in the memory failure code.

- The 2 patch series "mm/huge_memory: Define split_type and consolidate
  split support checks" from Wei Yang provides some more cleanups in the
  folio splitting code.

- The 16 patch series "mm: remove is_swap_[pte, pmd]() + non-swap
  entries, introduce leaf entries" from Lorenzo Stoakes cleans up our
  handling of pagetable leaf entries by introducing the concept of
  'software leaf entries', of type softleaf_t.

- The 4 patch series "reparent the THP split queue" from Muchun Song
  reparents the THP split queue to its parent memcg.  This is in
  preparation for addressing the long-standing "dying memcg" problem,
  wherein dead memcg's linger for too long, consuming memory resources.

- The 3 patch series "unify PMD scan results and remove redundant
  cleanup" from Wei Yang does a little cleanup in the hugepage collapse
  code.

- The 6 patch series "zram: introduce writeback bio batching" from
  Sergey Senozhatsky improves zram writeback efficiency by introducing
  batched bio writeback support.

- The 4 patch series "memcg: cleanup the memcg stats interfaces" from
  Shakeel Butt cleans up our handling of the interrupt safety of some
  memcg stats.

- The 4 patch series "make vmalloc gfp flags usage more apparent" from
  Vishal Moola cleans up vmalloc's handling of incoming GFP flags.

- The 6 patch series "mm: Add soft-dirty and uffd-wp support for RISC-V"
  from Chunyan Zhang teches soft dirty and userfaultfd write protect
  tracking to use RISC-V's Svrsw60t59b extension.

- The 5 patch series "mm: swap: small fixes and comment cleanups" from
  Youngjun Park fixes a small bug and cleans up some of the swap code.

- The 4 patch series "initial work on making VMA flags a bitmap" from
  Lorenzo Stoakes starts work on converting the vma struct's flags to a
  bitmap, so we stop running out of them, especially on 32-bit.

- The 2 patch series "mm/swapfile: fix and cleanup swap list iterations"
  from Youngjun Park addresses a possible bug in the swap discard code and
  cleans things up a little.

----------------------------------------------------------------
Andrew Morton (2):
      Merge branch 'mm-hotfixes-stable' into mm-stable to be able to merge "mm: introduce deferred freeing for kernel page tables" into mm-stable.
      Merge branch 'mm-hotfixes-stable' into mm-stable in order to merge "mm/huge_memory: only get folio_order() once during __folio_split()" into mm-stable.

Ankit Agrawal (3):
      mm: change ghes code to allow poison of non-struct pfn
      mm: handle poisoning of pfn without struct pages
      vfio/nvgrace-gpu: register device memory for poison handling

Ankit Khushwaha (2):
      selftest/mm: fix pointer comparison in mremap_test
      selftests/mm/uffd: initialize char variable to Null

Anshuman Khandual (6):
      mm/thp: drop follow_devmap_pmd() default stub
      mm/ptdump: replace READ_ONCE() with standard page table accessors
      mm: replace READ_ONCE() with standard page table accessors
      mm/dirty: replace READ_ONCE() with pudp_get()
      mm/debug_vm_pgtable: add [pte|pmd]_mkwrite_novma() tests
      mm: make INVALID_PHYS_ADDR a generic macro

Bagas Sanjaya (1):
      vmalloc: separate gfp_mask adjunctive parentheses in __vmalloc_node_noprof() kernel-doc comment

Balbir Singh (16):
      mm/zone_device: support large zone device private folios
      mm/zone_device: rename page_free callback to folio_free
      mm/huge_memory: add device-private THP support to PMD operations
      mm/rmap: extend rmap and migration support device-private entries
      mm/huge_memory: implement device-private THP splitting
      mm/migrate_device: handle partially mapped folios during collection
      mm/migrate_device: implement THP migration of zone device pages
      mm/memory/fault: add THP fault handling for zone device private pages
      lib/test_hmm: add zone device private THP test infrastructure
      mm/memremap: add driver callback support for folio splitting
      mm/migrate_device: add THP splitting during migration
      lib/test_hmm: add large page allocation failure testing
      selftests/mm/hmm-tests: new tests for zone device THP migration
      selftests/mm/hmm-tests: new throughput tests including THP
      gpu/drm/nouveau: enable THP support for GPU memory migration
      mm/huge_memory.c: introduce folio_split_unmapped

Baokun Li (1):
      mm/page_alloc: don't warn about large allocations with __GFP_NOFAIL

Baolin Wang (5):
      mm: vmscan: filter out the dirty file folios for node_reclaim()
      mm: vmscan: simplify the logic for activating dirty file folios
      mm: vmscan: remove folio_test_private() check in pageout()
      mm: vmscan: simplify the folio refcount check in pageout()
      mm: shmem: allow fallback to smaller large orders for tmpfs mmap() access

Baoquan He (2):
      mm/swap: do not choose swap device according to numa node
      mm/swap: select swap device with default priority round robin

Breno Leitao (1):
      mm/kfence: add reboot notifier to disable KFENCE on shutdown

Chen Ridong (1):
      memcg: remove inc/dec_lruvec_kmem_state helpers

Chu Guangqing (1):
      zram: fix a spelling mistake

Chunyan Zhang (6):
      mm: softdirty: add pgtable_supports_soft_dirty()
      mm: userfaultfd: add pgtable_supports_uffd_wp()
      riscv: add RISC-V Svrsw60t59b extension support
      riscv: mm: add soft-dirty page tracking support
      riscv: mm: add userfaultfd write-protect support
      dt-bindings: riscv: Add Svrsw60t59b extension description

Claudio Imbrenda (1):
      KVM: s390: fix missing present bit for gmap puds

Dan Carpenter (1):
      mm/damon/tests/sysfs-kunit: fix use after free on error path

Dave Hansen (5):
      mm: add a ptdesc flag to mark kernel page tables
      mm: actually mark kernel page table pages
      x86/mm: use 'ptdesc' when freeing PMD pages
      mm: introduce pure page table freeing function
      mm: introduce deferred freeing for kernel page tables

Dmitry Ilvokhin (1):
      mm: shmem/tmpfs hugepage defaults config choice

Donet Tom (2):
      drivers/base/node: fold register_node() into register_one_node()
      drivers/base/node: fold unregister_node() into unregister_one_node()

Fushuai Wang (1):
      mm/vmscan: remove redundant __GFP_NOWARN

Geert Uytterhoeven (1):
      mm: fix DEBUG_RODATA_TEST indentation in Kconfig

Gregory Price (1):
      hugetlb: add __read_mostly to sysctl_hugetlb_shm_group

Harry Yoo (2):
      MAINTAINERS: add include/linux/pgalloc.h to MM CORE section
      treewide: include linux/pgalloc.h instead of asm/pgalloc.h

Huacai Chen (2):
      mm: remove the BOUNCE config option
      mm: remove unnecessary __GFP_HIGHMEM in __p*d_alloc_one_*()

Hui Zhu (2):
      mm/hugetlb: extract sysfs into hugetlb_sysfs.c
      mm/hugetlb: extract sysctl into hugetlb_sysctl.c

Israel Batista (3):
      mm: convert memory block states (MEM_*) macros to enum
      mm: change type of state in struct memory_block
      mm: change type of parameter for memory_notify

Jiayuan Chen (2):
      mm: vmstat: output reserved_highatomic and free_highatomic in zoneinfo
      mm/vmscan: skip increasing kswapd_failures when reclaim was boosted

Jing Su (1):
      mm/vmstat: fix indentation in fold_diff function

Joshua Hahn (5):
      mm/page_alloc: clarify batch tuning in zone_batchsize
      mm/page_alloc: prevent reporting pcp->batch = 0
      mm/page_alloc/vmstat: simplify refresh_cpu_vm_stats change detection
      mm/page_alloc: batch page freeing in decay_pcp_high
      mm/page_alloc: batch page freeing in free_frozen_page_commit

Kairui Song (5):
      mm, swap: do not perform synchronous discard during allocation
      mm, swap: rename helper for setup bad slots
      mm, swap: cleanup swap entry allocation parameter
      mm/migrate, swap: drop usage of folio_index
      mm, swap: remove redundant argument for isolating a cluster

Kefeng Wang (5):
      mm: mprotect: always skip dma pinned folio in prot_numa_skip()
      mm: mprotect: avoid unnecessary struct page accessing if pte_protnone()
      mm: mprotect: convert to folio_can_map_prot_numa()
      mm: huge_memory: use folio_can_map_prot_numa() for pmd folio
      mm: kill mm_wr_locked from unmap_vmas() and unmap_single_vma()

Lance Yang (1):
      mm/khugepaged: guard is_zero_pfn() calls with pte_present()

Leon Hwang (1):
      mm/khugepaged: factor out common logic in [scan,alloc]_sleep_millisecs_store()

Lokesh Gidra (2):
      mm: always call rmap_walk() on locked folios
      mm/userfaultfd: don't lock anon_vma when performing UFFDIO_MOVE

Lorenzo Stoakes (51):
      mm/shmem: update shmem to use mmap_prepare
      device/dax: update devdax to use mmap_prepare
      mm/vma: remove unused function, make internal functions static
      mm: add vma_desc_size(), vma_desc_pages() helpers
      relay: update relay to use mmap_prepare
      mm/vma: rename __mmap_prepare() function to avoid confusion
      mm: add remap_pfn_range_prepare(), remap_pfn_range_complete()
      mm: abstract io_remap_pfn_range() based on PFN
      mm: introduce io_remap_pfn_range_[prepare, complete]()
      mm: add ability to take further action in vm_area_desc
      doc: update porting, vfs documentation for mmap_prepare actions
      mm/hugetlbfs: update hugetlbfs to use mmap_prepare
      mm: add shmem_zero_setup_desc()
      mm: update mem char driver to use mmap_prepare
      mm: update resctl to use mmap_prepare
      mm/vma: small VMA lock cleanups
      mm: introduce VM_MAYBE_GUARD and make visible in /proc/$pid/smaps
      mm: add atomic VMA flags and set VM_MAYBE_GUARD as such
      mm: update vma_modify_flags() to handle residual flags, document
      mm: implement sticky VMA flags
      mm: introduce copy-on-fork VMAs and make VM_MAYBE_GUARD one
      mm: set the VM_MAYBE_GUARD flag on guard region install
      tools/testing/vma: add VMA sticky userland tests
      tools/testing/selftests/mm: add MADV_COLLAPSE test case
      tools/testing/selftests/mm: add smaps visibility guard region test
      mm: rename walk_page_range_mm()
      mm/madvise: allow guard page install/remove under VMA lock
      mm: propagate VM_SOFTDIRTY on merge
      testing/selftests/mm: add soft-dirty merge self-test
      mm: correctly handle UFFD PTE markers
      mm: introduce leaf entry type and use to simplify leaf entry logic
      mm: avoid unnecessary uses of is_swap_pte()
      mm: eliminate is_swap_pte() when softleaf_from_pte() suffices
      mm: use leaf entries in debug pgtable + remove is_swap_pte()
      fs/proc/task_mmu: refactor pagemap_pmd_range()
      mm: avoid unnecessary use of is_swap_pmd()
      mm/huge_memory: refactor copy_huge_pmd() non-present logic
      mm/huge_memory: refactor change_huge_pmd() non-present logic
      mm: replace pmd_to_swp_entry() with softleaf_from_pmd()
      mm: introduce pmd_is_huge() and use where appropriate
      mm: remove remaining is_swap_pmd() users and is_swap_pmd()
      mm: remove non_swap_entry() and use softleaf helpers instead
      mm: remove is_hugetlb_entry_[migration, hwpoisoned]()
      mm: eliminate further swapops predicates
      mm: replace remaining pte_to_swp_entry() with softleaf_from_pte()
      tools/testing/vma: add missing stub
      mm: declare VMA flags by bit
      mm: simplify and rename mm flags function for clarity
      tools/testing/vma: eliminate dependency on vma->__vm_flags
      mm: introduce VMA flags bitmap type
      fs/proc/task_mmu.c: fix make_uffd_wp_huge_pte() huge pte handling

Lu Baolu (3):
      iommu: disable SVA when CONFIG_X86 is set
      x86/mm: use pagetable_free()
      iommu/sva: invalidate stale IOTLB entries for kernel address space

Ma Ke (1):
      mm/hmm/test: fix error handling in dmirror_device_init

Matthew Brost (1):
      selftests/mm/hmm-tests: partial unmap, mremap and anon_write tests

Matthew Wilcox (Oracle) (8):
      hugetlb: optimise hugetlb_folio_init_tail_vmemmap()
      migrate: optimise alloc_migration_target()
      memory_hotplug: optimise try_offline_memory_block()
      mm: constify __dump_folio() arguments
      mm: add vma_start_write_killable()
      mm: use vma_start_write_killable() in dup_mmap()
      mm: tweak __vma_enter_locked()
      mm: fix vma_start_write_killable() signal handling

Mauricio Faria de Oliveira (5):
      mm/page_owner: introduce struct stack_print_ctx
      mm/page_owner: add struct stack_print_ctx.flags
      mm/page_owner: add debugfs file 'show_handles'
      mm/page_owner: add debugfs file 'show_stacks_handles'
      mm/page_owner: update Documentation with 'show_handles' and 'show_stacks_handles'

Mehdi Ben Hadj Khelifa (2):
      mm/vmalloc: use kmalloc_array() instead of kmalloc()
      selftests/mm/uffd: remove static address usage in shmem_allocate_area()

Muchun Song (3):
      mm: thp: replace folio_memcg() with folio_memcg_charged()
      mm: thp: introduce folio_split_queue_lock and its variants
      mm: thp: use folio_batch to handle THP splitting in deferred_split_scan()

Pedro Demarchi Gomes (3):
      Revert "mm/ksm: convert break_ksm() from walk_page_range_vma() to folio_walk"
      ksm: perform a range-walk in break_ksm
      ksm: replace function unmerge_ksm_pages with break_ksm

Peng Li (2):
      selftests/mm: gup_test: stop testing FOLL_TOUCH
      selftests/mm: gup_test: fix comment regarding origin of FOLL_WRITE

Qi Zheng (2):
      mm: vmstat: correct the comment above preempt_disable_nested()
      mm: thp: reparent the split queue during memcg offline

Quanmin Yan (2):
      mm/damon: add a min_sz_region parameter to damon_set_region_biggest_system_ram_default()
      mm/damon/reclaim: use min_sz_region for core address alignment when setting regions

Richard Weinberger (1):
      pagemap: update BUDDY flag documentation

Roman Gushchin (1):
      mm: readahead: make thp readahead conditional to mmap_miss logic

Ryan Roberts (1):
      mm: consistently use current->mm in mm_get_unmapped_area()

Sabyrzhan Tasbolatov (2):
      kasan: remove __kasan_save_free_info wrapper
      kasan: cleanup of kasan_enabled() checks

SeongJae Park (73):
      mm/zswap: remove unnecessary dlen writes for incompressible pages
      mm/zswap: fix typos: s/zwap/zswap/
      mm/zswap: s/red-black tree/xarray/
      Docs/admin-guide/mm/zswap: s/red-black tree/xarray/
      mm/damon: document damos_quota_goal->nid use case
      mm/damon: add DAMOS quota goal type for per-memcg per-node memory usage
      mm/damon/core: implement DAMOS_QUOTA_NODE_MEMCG_USED_BP
      mm/damon/sysfs-schemes: implement path file under quota goal directory
      mm/damon/sysfs-schemes: support DAMOS_QUOTA_NODE_MEMCG_USED_BP
      mm/damon/core: add DAMOS quota gaol metric for per-memcg per-numa free memory
      mm/damon/sysfs-schemes: support DAMOS_QUOTA_NODE_MEMCG_FREE_BP
      Docs/mm/damon/design: document DAMOS_QUOTA_NODE_MEMCG_{USED,FREE}_BP
      Docs/admin-guide/mm/damon/usage: document DAMOS quota goal path file
      Docs/ABI/damon: document DAMOS quota goal path file
      mm/damon/core: fix wrong comment of damon_call() return timing
      Docs/mm/damon/design: fix wrong link to intervals goal section
      Docs/admin-guide/mm/damon/stat: fix a typo: s/sampling events/sampling interval/
      Docs/admin-guide/mm/damon/usage: document empty target regions commit behavior
      Docs/admin-guide/mm/damon/reclaim: document addr_unit parameter
      Docs/admin-guide/mm/damon/lru_sort: document addr_unit parameter
      Docs/admin-guide/mm/damon/stat: document aggr_interval_us parameter
      Docs/admin-guide/mm/damon/stat: document negative idle time
      mm/damon/core: add damon_target->obsolete for pin-point removal
      mm/damon/sysfs: test commit input against realistic destination
      mm/damon/sysfs: implement obsolete_target file
      Docs/admin-guide/mm/damon/usage: document obsolete_target file
      Docs/ABI/damon: document obsolete_target sysfs file
      selftests/damon/_damon_sysfs: support obsolete_target file
      drgn_dump_damon_status: dump damon_target->obsolete
      sysfs.py: extend assert_ctx_committed() for monitoring targets
      selftests/damon/sysfs: add obsolete_target test
      mm/damon/tests/core-kunit: fix memory leak in damon_test_set_filters_default_reject()
      mm/damon/tests/core-kunit: handle allocation failures in damon_test_regions()
      mm/damon/tests/core-kunit: handle memory failure from damon_test_target()
      mm/damon/tests/core-kunit: handle memory alloc failure from damon_test_aggregate()
      mm/damon/tests/core-kunit: handle alloc failures on damon_test_split_at()
      mm/damon/tests/core-kunit: handle alloc failures on damon_test_merge_two()
      mm/damon/tests/core-kunit: handle alloc failures on dasmon_test_merge_regions_of()
      mm/damon/tests/core-kunit: handle alloc failures on damon_test_split_regions_of()
      mm/damon/tests/core-kunit: handle alloc failures in damon_test_ops_registration()
      mm/damon/tests/core-kunit: handle alloc failures in damon_test_set_regions()
      mm/damon/tests/core-kunit: handle alloc failures in damon_test_update_monitoring_result()
      mm/damon/tests/core-kunit: handle alloc failure on damon_test_set_attrs()
      mm/damon/tests/core-kunit: handle alloc failres in damon_test_new_filter()
      mm/damon/tests/core-kunit: handle alloc failure on damos_test_commit_filter()
      mm/damon/tests/core-kunit: handle alloc failures on damos_test_filter_out()
      mm/damon/tests/core-kunit: handle alloc failures on damon_test_set_filters_default_reject()
      mm/damon/tests/vaddr-kunit: handle alloc failures on damon_do_test_apply_three_regions()
      mm/damon/tests/vaddr-kunit: handle alloc failures in damon_test_split_evenly_fail()
      mm/damon/tests/vaddr-kunit: handle alloc failures on damon_test_split_evenly_succ()
      mm/damon/tests/sysfs-kunit: handle alloc failures on damon_sysfs_test_add_targets()
      mm/damon/tests/core-kunit: remove unnecessary damon_ctx variable on damon_test_split_at()
      mm/damon/tests/core-kunit: remove unused ctx in damon_test_split_regions_of()
      mm/damon/tests/core-kunit: remove dynamic allocs on damos_test_commit_filter()
      mm/damon/tests/core-kunit: split out damos_test_commit_filter() core logic
      mm/damon/tests/core-kunit: extend damos_test_commit_filter_for() for union fields
      mm/damon/tests/core-kunit: add test cases to damos_test_commit_filter()
      mm/damon/tests/core-kunit: add damos_commit_quota_goal() test
      mm/damon/tests/core-kunit: add damos_commit_quota_goals() test
      mm/damon/tests/core-kunit: add damos_commit_quota() test
      mm/damon/core: pass migrate_dests to damos_commit_dests()
      mm/damon/tests/core-kunit: add damos_commit_dests() test
      mm/damon/tests/core-kunit: add damos_commit() test
      mm/damon/tests/core-kunit: add damon_commit_target_regions() test
      mm/damon: rename damos core filter helpers to have word core
      mm/damon: rename damos->filters to damos->core_filters
      mm/damon/vaddr: cleanup using pmd_trans_huge_lock()
      mm/damon/vaddr: use vm_normal_folio{,_pmd}() instead of damon_get_folio()
      mm/damon/vaddr: consistently use only pmd_entry for damos_migrate
      mm/damon/tests/core-kunit: remove DAMON_MIN_REGION redefinition
      selftests/damon/sysfs.py: merge DAMON status dumping into commitment assertion
      Docs/mm/damon/maintainer-profile: fix a typo on mm-untable link
      Docs/mm/damon/maintainer-profile: fix grammatical errors

Sergey Senozhatsky (6):
      zram: introduce writeback bio batching
      zram: add writeback batch size device attr
      zram: take write lock in wb limit store handlers
      zram: drop wb_limit_lock
      zram: rework bdev block allocation
      zram: read slot block idx under slot lock

Shakeel Butt (7):
      memcg: net: track network throttling due to memcg memory pressure
      memcg: manually uninline __memcg_memory_event
      mm: memcg: dump memcg protection info on oom or alloc failures
      memcg: use mod_node_page_state to update stats
      memcg: remove __mod_lruvec_kmem_state
      memcg: remove __mod_lruvec_state
      memcg: remove __lruvec_stat_mod_folio

Song Hu (2):
      mm/page_owner: rename proc-prefixed variables for clarity
      mm/page_owner: simplify zone iteration logic in init_early_allocated_pages()

Swaraj Gaikwad (1):
      mm/damon/sysfs: remove misleading todo comment in nid_show()

Uladzislau Rezki (Sony) (11):
      lib/test_vmalloc: add no_block_alloc_test case
      lib/test_vmalloc: remove xfail condition check
      mm/vmalloc: support non-blocking GFP flags in alloc_vmap_area()
      mm/vmalloc: defer freeing partly initialized vm_struct
      mm/vmalloc: handle non-blocking GFP in __vmalloc_area_node()
      mm/kasan: support non-blocking GFP in kasan_populate_vmalloc()
      kmsan: remove hard-coded GFP_KERNEL flags
      mm: skip might_alloc() warnings when PF_MEMALLOC is set
      mm/vmalloc: update __vmalloc_node_range() documentation
      mm: kvmalloc: add non-blocking support for vmalloc
      vmalloc: update __vmalloc_node_noprof() documentation

Usama Arif (2):
      mm/hugetlb: create hstate_is_gigantic_no_runtime helper
      mm/hugetlb: allow overcommitting gigantic hugepages

Vishal Moola (Oracle) (5):
      mm/vmalloc: request large order pages from buddy allocator
      mm/vmalloc: warn on invalid vmalloc gfp flags
      mm/vmalloc: add a helper to optimize vmalloc allocation gfps
      mm/vmalloc: cleanup large_gfp in vm_area_alloc_pages()
      mm/vmalloc: cleanup gfp flag use in new_vmap_block()

Vlastimil Babka (1):
      mm/page_alloc: simplify and cleanup pcp locking

Wei Yang (12):
      mm/huge_memory: avoid reinvoking folio_test_anon()
      mm/huge_memory: update folio stat after successful split
      mm/huge_memory: optimize and simplify folio stat update after split
      mm/huge_memory: optimize old_order derivation during folio splitting
      mm/huge_memory: add pmd folio to ds_queue in do_huge_zero_wp_pmd()
      mm/khugepaged: unify pmd folio installation with map_anon_folio_pmd()
      mm/huge_memory: only get folio_order() once during __folio_split()
      mm/huge_memory: introduce enum split_type for clarity
      mm/huge_memory: merge uniform_split_supported() and non_uniform_split_supported()
      mm/khugepaged: remove redundant clearing of struct collapse_control
      mm/khugepaged: continue to collapse on SCAN_PMD_NONE
      mm/khugepaged: unify SCAN_PMD_NONE and SCAN_PMD_NULL into SCAN_NO_PTE_TABLE

William Kucharski (1):
      mm: remove reference to destructor in comment in calculate_sizes()

Xie Yuanbin (1):
      mm/memory-failure: remove the selection of RAS

Yadong Qi (1):
      mm: vmalloc: WARN_ON if mapping size is not PAGE_SIZE aligned

Ye Liu (2):
      tools/mm: use <stdbool.h> in page_owner_sort.c
      tools/mm/page_owner_sort: add help option support

Youngjun Park (8):
      mm/swap: fix wrong plist empty check in swap_alloc_slow()
      mm, swap: fix memory leak in setup_clusters() error path
      mm, swap: use SWP_SOLIDSTATE to determine if swap is rotational
      mm, swap: remove redundant comment for read_swap_cache_async
      mm: swap: change swap_alloc_slow() to void
      mm: swap: remove scan_swap_map_slots() references from comments
      mm/swapfile: fix list iteration when next node is removed during discard
      mm/swapfile: use plist_for_each_entry in __folio_throttle_swaprate

Yuwen Chen (1):
      zram: fix the issue that the write - back limits might overflow

Zeng Chi (1):
      lib/alloc_tag: use %pe format specifier

Zhang Chujun (1):
      mm/debug: fix missing space in case statement

Zi Yan (3):
      mm/huge_memory: add split_huge_page_to_order()
      mm/memory-failure: improve large block size folio handling
      mm/huge_memory: fix kernel-doc comments for folio_split() and related

fujunjie (1):
      mm/page_alloc: optimize lowmem_reserve max lookup using its semantic monotonicity

jianyun.gao (1):
      mm: fix some typos in mm module

wang lian (1):
      mm/khugepaged: fix comment for default scan sleep duration

xu xin (2):
      mm/ksm: fix exec/fork inheritance support for prctl
      selftests: update ksm inheritance tests for prctl fork/exec

 .clang-format                                      |    4 +-
 Documentation/ABI/testing/sysfs-kernel-mm-damon    |   13 +
 Documentation/admin-guide/cgroup-v2.rst            |    4 +
 Documentation/admin-guide/mm/damon/lru_sort.rst    |   22 +
 Documentation/admin-guide/mm/damon/reclaim.rst     |   22 +
 Documentation/admin-guide/mm/damon/stat.rst        |   35 +-
 Documentation/admin-guide/mm/damon/usage.rst       |   29 +-
 Documentation/admin-guide/mm/index.rst             |    1 -
 Documentation/admin-guide/mm/pagemap.rst           |    3 +-
 Documentation/admin-guide/mm/swap_numa.rst         |   78 --
 Documentation/admin-guide/mm/transhuge.rst         |    5 +
 Documentation/admin-guide/mm/zswap.rst             |   10 +-
 .../devicetree/bindings/riscv/extensions.yaml      |    6 +
 Documentation/filesystems/porting.rst              |    5 +
 Documentation/filesystems/proc.rst                 |    5 +-
 Documentation/filesystems/vfs.rst                  |    4 +
 Documentation/mm/damon/design.rst                  |   25 +-
 Documentation/mm/damon/maintainer-profile.rst      |   10 +-
 Documentation/mm/memory-model.rst                  |    2 +-
 Documentation/mm/page_owner.rst                    |   32 +-
 Documentation/mm/process_addrs.rst                 |    9 +-
 MAINTAINERS                                        |    6 +
 arch/arm64/mm/mmu.c                                |    2 -
 arch/csky/include/asm/pgtable.h                    |    3 -
 arch/mips/alchemy/common/setup.c                   |    9 +-
 arch/mips/include/asm/pgtable.h                    |    5 +-
 arch/powerpc/kvm/book3s_hv_uvmem.c                 |    7 +-
 arch/powerpc/platforms/pseries/pci_dlpar.c         |    2 +-
 arch/riscv/Kconfig                                 |   16 +
 arch/riscv/include/asm/hwcap.h                     |    1 +
 arch/riscv/include/asm/pgtable-bits.h              |   37 +
 arch/riscv/include/asm/pgtable.h                   |  143 ++-
 arch/riscv/kernel/cpufeature.c                     |    1 +
 arch/s390/boot/vmem.c                              |    1 -
 arch/s390/mm/gmap.c                                |    5 +-
 arch/s390/mm/gmap_helpers.c                        |   20 +-
 arch/s390/mm/pgtable.c                             |   12 +-
 arch/sparc/include/asm/pgtable_32.h                |   12 +-
 arch/sparc/include/asm/pgtable_64.h                |   12 +-
 arch/sparc/kernel/sys_sparc_64.c                   |    6 +-
 arch/x86/Kconfig                                   |    1 +
 arch/x86/kernel/cpu/sgx/driver.c                   |    2 +-
 arch/x86/mm/init_64.c                              |    2 +-
 arch/x86/mm/numa.c                                 |    4 +-
 arch/x86/mm/pat/set_memory.c                       |    2 +-
 arch/x86/mm/pgtable.c                              |   12 +-
 drivers/acpi/apei/ghes.c                           |    6 -
 drivers/base/memory.c                              |    6 +-
 drivers/base/node.c                                |   90 +-
 drivers/block/zram/zram_drv.c                      |  483 ++++++--
 drivers/block/zram/zram_drv.h                      |    2 +-
 drivers/char/mem.c                                 |   86 +-
 drivers/dax/device.c                               |   37 +-
 drivers/firmware/efi/arm-runtime.c                 |    4 +-
 drivers/firmware/efi/riscv-runtime.c               |    4 +-
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c           |    7 +-
 drivers/gpu/drm/drm_pagemap.c                      |   12 +-
 drivers/gpu/drm/nouveau/nouveau_dmem.c             |  311 +++--
 drivers/gpu/drm/nouveau/nouveau_svm.c              |    6 +-
 drivers/gpu/drm/nouveau/nouveau_svm.h              |    3 +-
 drivers/iommu/iommu-sva.c                          |   29 +-
 drivers/pci/p2pdma.c                               |    5 +-
 drivers/s390/char/sclp_sd.c                        |    3 +-
 drivers/vdpa/vdpa_user/iova_domain.h               |    2 -
 drivers/vfio/pci/nvgrace-gpu/main.c                |   45 +-
 fs/dax.c                                           |    2 +-
 fs/hugetlbfs/inode.c                               |   49 +-
 fs/ntfs3/file.c                                    |    2 +-
 fs/proc/inode.c                                    |    2 +-
 fs/proc/task_mmu.c                                 |  314 ++---
 fs/ramfs/file-mmu.c                                |    2 +-
 fs/resctrl/pseudo_lock.c                           |   20 +-
 fs/userfaultfd.c                                   |  117 +-
 include/asm-generic/hugetlb.h                      |    8 -
 include/asm-generic/pgalloc.h                      |   24 +-
 include/asm-generic/pgtable_uffd.h                 |   17 +
 include/linux/damon.h                              |   39 +-
 include/linux/fs.h                                 |    6 +-
 include/linux/gfp.h                                |    2 +-
 include/linux/huge_mm.h                            |  112 +-
 include/linux/hugetlb.h                            |   13 +-
 include/linux/hugetlb_inline.h                     |   15 +-
 include/linux/iommu.h                              |    4 +
 include/linux/kasan.h                              |   20 +-
 include/linux/kmsan.h                              |    6 +-
 include/linux/ksm.h                                |    4 +-
 include/linux/leafops.h                            |  619 ++++++++++
 include/linux/memcontrol.h                         |   89 +-
 include/linux/memory-failure.h                     |   17 +
 include/linux/memory.h                             |   28 +-
 include/linux/memremap.h                           |   57 +-
 include/linux/migrate.h                            |    4 +-
 include/linux/mm.h                                 |  681 ++++++++---
 include/linux/mm_inline.h                          |   16 +-
 include/linux/mm_types.h                           |  156 ++-
 include/linux/mmap_lock.h                          |   37 +-
 include/linux/mmzone.h                             |    4 -
 include/linux/node.h                               |   10 +-
 include/linux/pgtable.h                            |   12 +
 include/linux/sched/mm.h                           |   12 +-
 include/linux/shmem_fs.h                           |    9 +-
 include/linux/swap.h                               |   15 +-
 include/linux/swapops.h                            |  241 +---
 include/linux/userfaultfd_k.h                      |   96 +-
 include/linux/vmalloc.h                            |    8 +-
 include/linux/vmstat.h                             |   48 +-
 include/net/sock.h                                 |    6 +-
 include/ras/ras_event.h                            |   86 --
 include/trace/events/huge_memory.h                 |    3 +-
 include/trace/events/memory-failure.h              |   98 ++
 include/trace/events/mmflags.h                     |    1 +
 io_uring/memmap.c                                  |    2 +-
 kernel/bpf/arena.c                                 |    2 +-
 kernel/bpf/syscall.c                               |    2 +-
 kernel/cgroup/cgroup.c                             |    1 +
 kernel/dma/swiotlb.c                               |    2 -
 kernel/fork.c                                      |    8 +-
 kernel/relay.c                                     |   33 +-
 lib/alloc_tag.c                                    |    2 +-
 lib/test_hmm.c                                     |  457 ++++++--
 lib/test_hmm_uapi.h                                |    3 +
 lib/test_vmalloc.c                                 |   28 +-
 mm/Kconfig                                         |  105 +-
 mm/Kconfig.debug                                   |    6 +-
 mm/Makefile                                        |    2 +-
 mm/damon/core.c                                    |  129 ++-
 mm/damon/lru_sort.c                                |    3 +-
 mm/damon/ops-common.c                              |   40 +-
 mm/damon/reclaim.c                                 |    3 +-
 mm/damon/stat.c                                    |    3 +-
 mm/damon/sysfs-schemes.c                           |   59 +-
 mm/damon/sysfs.c                                   |   53 +-
 mm/damon/tests/core-kunit.h                        |  708 +++++++++++-
 mm/damon/tests/sysfs-kunit.h                       |   25 +
 mm/damon/tests/vaddr-kunit.h                       |   26 +-
 mm/damon/vaddr.c                                   |  143 +--
 mm/debug.c                                         |    4 +-
 mm/debug_vm_pgtable.c                              |  111 +-
 mm/filemap.c                                       |   99 +-
 mm/gup.c                                           |   12 +-
 mm/hmm.c                                           |   43 +-
 mm/huge_memory.c                                   | 1214 ++++++++++++--------
 mm/hugetlb.c                                       |  983 +++-------------
 mm/hugetlb_internal.h                              |  117 ++
 mm/hugetlb_sysctl.c                                |  134 +++
 mm/hugetlb_sysfs.c                                 |  502 ++++++++
 mm/hugetlb_vmemmap.c                               |    9 +-
 mm/internal.h                                      |   73 +-
 mm/kasan/common.c                                  |    3 -
 mm/kasan/generic.c                                 |    5 +-
 mm/kasan/kasan.h                                   |    7 +-
 mm/kasan/shadow.c                                  |   32 +-
 mm/kasan/tags.c                                    |    2 +-
 mm/kfence/core.c                                   |   24 +
 mm/khugepaged.c                                    |  209 ++--
 mm/kmsan/core.c                                    |    2 +-
 mm/kmsan/shadow.c                                  |    6 +-
 mm/ksm.c                                           |  159 ++-
 mm/madvise.c                                       |  160 ++-
 mm/mapping_dirty_helpers.c                         |    2 +-
 mm/memcontrol.c                                    |   70 +-
 mm/memory-failure.c                                |  192 +++-
 mm/memory-tiers.c                                  |    2 +-
 mm/memory.c                                        |  327 +++---
 mm/memory_hotplug.c                                |   10 +-
 mm/mempolicy.c                                     |   86 +-
 mm/memremap.c                                      |   40 +-
 mm/migrate.c                                       |   74 +-
 mm/migrate_device.c                                |  629 ++++++++--
 mm/mincore.c                                       |   25 +-
 mm/mlock.c                                         |    2 +-
 mm/mm_init.c                                       |    2 +-
 mm/mmap.c                                          |   37 +-
 mm/mmap_lock.c                                     |   49 +-
 mm/mmu_gather.c                                    |    2 +-
 mm/mprotect.c                                      |  150 +--
 mm/mremap.c                                        |   26 +-
 mm/mseal.c                                         |    9 +-
 mm/oom_kill.c                                      |    1 +
 mm/page-writeback.c                                |    2 +-
 mm/page_alloc.c                                    |  219 ++--
 mm/page_idle.c                                     |   15 +-
 mm/page_owner.c                                    |   98 +-
 mm/page_table_check.c                              |   33 +-
 mm/page_vma_mapped.c                               |   68 +-
 mm/pagewalk.c                                      |   52 +-
 mm/percpu-vm.c                                     |    2 +-
 mm/pgtable-generic.c                               |   44 +-
 mm/pt_reclaim.c                                    |    3 +-
 mm/ptdump.c                                        |   10 +-
 mm/rmap.c                                          |   91 +-
 mm/secretmem.c                                     |    4 +-
 mm/shmem.c                                         |  123 +-
 mm/slab_common.c                                   |    2 +-
 mm/slub.c                                          |   31 +-
 mm/sparse-vmemmap.c                                |    2 +-
 mm/swap.h                                          |   21 -
 mm/swap_state.c                                    |   15 +-
 mm/swapfile.c                                      |  234 ++--
 mm/userfaultfd.c                                   |  127 +-
 mm/util.c                                          |  146 ++-
 mm/vma.c                                           |  229 ++--
 mm/vma.h                                           |  140 ++-
 mm/vma_exec.c                                      |    5 +-
 mm/vmalloc.c                                       |  271 ++++-
 mm/vmscan.c                                        |   83 +-
 mm/vmstat.c                                        |   53 +-
 mm/workingset.c                                    |    2 +-
 mm/zswap.c                                         |    7 +-
 rust/bindgen_parameters                            |   25 +
 rust/bindings/bindings_helper.h                    |   25 +
 rust/kernel/mm/virt.rs                             |    2 +-
 tools/mm/page_owner_sort.c                         |   14 +-
 tools/testing/selftests/damon/_damon_sysfs.py      |   11 +-
 .../selftests/damon/drgn_dump_damon_status.py      |    9 +-
 tools/testing/selftests/damon/sysfs.py             |   71 +-
 tools/testing/selftests/mm/guard-regions.c         |  185 +++
 tools/testing/selftests/mm/gup_test.c              |   24 +-
 tools/testing/selftests/mm/hmm-tests.c             |  919 ++++++++++++++-
 tools/testing/selftests/mm/ksm_functional_tests.c  |   57 +
 tools/testing/selftests/mm/mremap_test.c           |    5 +-
 tools/testing/selftests/mm/soft-dirty.c            |  127 +-
 tools/testing/selftests/mm/uffd-common.c           |   24 +-
 tools/testing/selftests/mm/uffd-stress.c           |    2 +-
 tools/testing/selftests/mm/uffd-unit-tests.c       |    8 +-
 tools/testing/selftests/mm/vm_util.c               |    5 +
 tools/testing/selftests/mm/vm_util.h               |    1 +
 tools/testing/vma/vma.c                            |  112 +-
 tools/testing/vma/vma_internal.h                   |  603 ++++++++--
 229 files changed, 11657 insertions(+), 5113 deletions(-)
 delete mode 100644 Documentation/admin-guide/mm/swap_numa.rst
 create mode 100644 include/linux/leafops.h
 create mode 100644 include/linux/memory-failure.h
 create mode 100644 include/trace/events/memory-failure.h
 create mode 100644 mm/hugetlb_internal.h
 create mode 100644 mm/hugetlb_sysctl.c
 create mode 100644 mm/hugetlb_sysfs.c

