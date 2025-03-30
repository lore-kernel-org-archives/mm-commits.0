Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EE321876;
	Sun, 30 Mar 2025 23:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743379055; cv=none; b=soafFVP6gjCeeqnLn1ZifAjlti/QZwZQDbC98/M2/ZFnSTvyJczUegEa/3J+zy6jp3P8LUf9mKcI8GGLF6dG+ZeOxMh/BUGNg3QxHc41fvMh6I6uh/KU8hiiicAAq+ABR6qTEAHm6pIrEKhWTHPg4/xTXxLe+je5QLeA/nAXtKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743379055; c=relaxed/simple;
	bh=u0FAlYE9D0XM4EFyDGSOD+wiv+zcqAXlbkZCwWZjOBI=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=chGdUeyeoZGmK0Ao7a7NwnFzECSYWyNv12U+eLF+DQ7jGa9guPYCF9NDb9wcFudoEi6ih0UCTMaMeZlt8QrZx/ZERDUv9PiY/bFPGVMaY8VJTziQfTjvginWjCWu6gCZupO0z9ACb0Dj3mIsRfJF6pVikVvXr4CLPsJ+0VbQrN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZHRYWd1c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZHRYWd1c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A538C4CEDD;
	Sun, 30 Mar 2025 23:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743379053;
	bh=u0FAlYE9D0XM4EFyDGSOD+wiv+zcqAXlbkZCwWZjOBI=;
	h=Date:From:To:Cc:Subject:From;
	b=ZHRYWd1cB64LHpGzZcjERaH8ml8s6BYpqD6GcxpU9/FIaKa4w537aLOkYzx6NX6NH
	 e0F/H+186eKGVHJvvPz9qnl/vS4L4oluOwfdYS5cKg/N64gZsEOzcRiytj7sG+fR1Y
	 4x/KIUtdWQFTdaO0VyW0pgxpGO+qhRzoCD7Hjqy8=
Date: Sun, 30 Mar 2025 16:57:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] MM updates for 6.15-rc1
Message-Id: <20250330165732.f4c1493615375623f67e38eb@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Linus, please merge the MM updates for this development cycle.

I'll be preparing a second batch of updates later in the week - some
tens of patches.  Leftovers and tricky things which awaited a tip tree
merge.

Thanks.

Conflicts which I observed, along with their linux-next resolutions:

arch/riscv/include/asm/io.h, vs tip tree:
https://lkml.kernel.org/r/20250224144240.7b5bca3f@canb.auug.org.au

arch/s390/include/asm/io.h, vs s390 tree:
https://lkml.kernel.org/r/20250312120734.4a1e4f4f@canb.auug.org.au

include/linux/mm.h, vs sysctl tree:
https://lkml.kernel.org/r/20250311202126.1150e018@canb.auug.org.au

mm/memory.c, vs drm-xe tree:
https://lkml.kernel.org/r/20250307122954.1ab65809@canb.auug.org.au

mm/page_owner.c, vs bpf-next tree:
https://lkml.kernel.org/r/20250311120422.1d9a8f80@canb.auug.org.au


Build errors, along with their linux-next resolutions:

drivers/gpu/drm/drm_gpusvm.c, vs drm-xe tree:
https://lkml.kernel.org/r/20250307125803.198cdedb@canb.auug.org.au

drivers/gpu/drm/xe/xe_svm.c, vs drm-xe tree:
https://lkml.kernel.org/r/20250307132112.18b6ce90@canb.auug.org.au

kernel/locking/qspinlock.c, vs bpf-next tree:
https://lkml.kernel.org/r/20250319133309.6fce6404@canb.auug.org.au



Possible upcoming conflicts, along with their linux-next resolutions:

lib/Makefile, vs kspp tree:
https://lkml.kernel.org/r/20250317213953.01ca90e9@canb.auug.org.au

arch/um/kernel/mem.c, vs uml tree:
https://lkml.kernel.org/r/20250319105554.2e2f3aab@canb.auug.org.au

kernel/auditsc.c, vs security tree:
https://lkml.kernel.org/r/20241014144648.1923104a@canb.auug.org.au

security/lsm_audit.c, vs security tree:
https://lkml.kernel.org/r/20241023123139.127ad800@canb.auug.org.au



The following changes since commit 800f1059c99e2b39899bdc67a7593a7bea6375d8:

  mm/page_alloc: fix memory accept before watermarks gets initialized (2025-03-16 17:40:26 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2025-03-30-16-52

for you to fetch changes up to 0a1e082b64ccce165e7307a7b49d22b2504f9d1f:

  mm/page_alloc: remove unnecessary __maybe_unused in order_to_pindex() (2025-03-21 22:03:17 -0700)

----------------------------------------------------------------
- The 6 patch series "Enable strict percpu address space checks" from
  Uros Bizjak uses x86 named address space qualifiers to provide
  compile-time checking of percpu area accesses.

  This has caused a small amount of fallout - two or three issues were
  reported.  In all cases the calling code was founf to be incorrect.

- The 4 patch series "Some cleanup for memcg" from Chen Ridong
  implements some relatively monir cleanups for the memcontrol code.

- The 17 patch series "mm: fixes for device-exclusive entries (hmm)"
  from David Hildenbrand fixes a boatload of issues which David found then
  using device-exclusive PTE entries when THP is enabled.  More work is
  needed, but this makes thins better - our own HMM selftests now succeed.

- The 2 patch series "mm: zswap: remove z3fold and zbud" from Yosry
  Ahmed remove the z3fold and zbud implementations.  They have been
  deprecated for half a year and nobody has complained.

- The 5 patch series "mm: further simplify VMA merge operation" from
  Lorenzo Stoakes implements numerous simplifications in this area.  No
  runtime effects are anticipated.

- The 4 patch series "mm/madvise: remove redundant mmap_lock operations
  from process_madvise()" from SeongJae Park rationalizes the locking in
  the madvise() implementation.  Performance gains of 20-25% were observed
  in one MADV_DONTNEED microbenchmark.

- The 12 patch series "Tiny cleanup and improvements about SWAP code"
  from Baoquan He contains a number of touchups to issues which Baoquan
  noticed when working on the swap code.

- The 2 patch series "mm: kmemleak: Usability improvements" from Catalin
  Marinas implements a couple of improvements to the kmemleak user-visible
  output.

- The 2 patch series "mm/damon/paddr: fix large folios access and
  schemes handling" from Usama Arif provides a couple of fixes for DAMON's
  handling of large folios.

- The 3 patch series "mm/damon/core: fix wrong and/or useless
  damos_walk() behaviors" from SeongJae Park fixes a few issues with the
  accuracy of kdamond's walking of DAMON regions.

- The 3 patch series "expose mapping wrprotect, fix fb_defio use" from
  Lorenzo Stoakes changes the interaction between framebuffer deferred-io
  and core MM.  No functional changes are anticipated - this is
  preparatory work for the future removal of page structure fields.

- The 4 patch series "mm/damon: add support for hugepage_size DAMOS
  filter" from Usama Arif adds a DAMOS filter which permits the filtering
  by huge page sizes.

- The 4 patch series "mm: permit guard regions for file-backed/shmem
  mappings" from Lorenzo Stoakes extends the guard region feature from its
  present "anon mappings only" state.  The feature now covers shmem and
  file-backed mappings.

- The 4 patch series "mm: batched unmap lazyfree large folios during
  reclamation" from Barry Song cleans up and speeds up the unmapping for
  pte-mapped large folios.

- The 18 patch series "reimplement per-vma lock as a refcount" from
  Suren Baghdasaryan puts the vm_lock back into the vma.  Our reasons for
  pulling it out were largely bogus and that change made the code more
  messy.  This patchset provides small (0-10%) improvements on one
  microbenchmark.

- The 5 patch series "Docs/mm/damon: misc DAMOS filters documentation
  fixes and improves" from SeongJae Park does some maintenance work on the
  DAMON docs.

- The 27 patch series "hugetlb/CMA improvements for large systems" from
  Frank van der Linden addresses a pile of issues which have been observed
  when using CMA on large machines.

- The 2 patch series "mm/damon: introduce DAMOS filter type for unmapped
  pages" from SeongJae Park enables users of DMAON/DAMOS to filter my the
  page's mapped/unmapped status.

- The 19 patch series "zsmalloc/zram: there be preemption" from Sergey
  Senozhatsky teaches zram to run its compression and decompression
  operations preemptibly.

- The 12 patch series "selftests/mm: Some cleanups from trying to run
  them" from Brendan Jackman fixes a pile of unrelated issues which
  Brendan encountered while runnimg our selftests.

- The 2 patch series "fs/proc/task_mmu: add guard region bit to pagemap"
  from Lorenzo Stoakes permits userspace to use /proc/pid/pagemap to
  determine whether a particular page is a guard page.

- The 7 patch series "mm, swap: remove swap slot cache" from Kairui Song
  removes the swap slot cache from the allocation path - it simply wasn't
  being effective.

- The 5 patch series "mm: cleanups for device-exclusive entries (hmm)"
  from David Hildenbrand implements a number of unrelated cleanups in this
  code.

- The 5 patch series "mm: Rework generic PTDUMP configs" from Anshuman
  Khandual implements a number of preparatoty cleanups to the
  GENERIC_PTDUMP Kconfig logic.

- The 8 patch series "mm/damon: auto-tune aggregation interval" from
  SeongJae Park implements a feedback-driven automatic tuning feature for
  DAMON's aggregation interval tuning.

- The 5 patch series "Fix lazy mmu mode" from Ryan Roberts fixes some
  issues in powerpc, sparc and x86 lazy MMU implementations.  Ryan did
  this in preparation for implementing lazy mmu mode for arm64 to optimize
  vmalloc.

- The 2 patch series "mm/page_alloc: Some clarifications for migratetype
  fallback" from Brendan Jackman reworks some commentary to make the code
  easier to follow.

- The 3 patch series "page_counter cleanup and size reduction" from
  Shakeel Butt cleans up the page_counter code and fixes a size increase
  which we accidentally added late last year.

- The 3 patch series "Add a command line option that enables control of
  how many threads should be used to allocate huge pages" from Thomas
  Prescher does that.  It allows the careful operator to significantly
  reduce boot time by tuning the parallalization of huge page
  initialization.

- The 3 patch series "Fix calculations in trace_balance_dirty_pages()
  for cgwb" from Tang Yizhou fixes the tracing output from the dirty page
  balancing code.

- The 9 patch series "mm/damon: make allow filters after reject filters
  useful and intuitive" from SeongJae Park improves the handling of allow
  and reject filters.  Behaviour is made more consistent and the
  documention is updated accordingly.

- The 5 patch series "Switch zswap to object read/write APIs" from Yosry
  Ahmed updates zswap to the new object read/write APIs and thus permits
  the removal of some legacy code from zpool and zsmalloc.

- The 6 patch series "Some trivial cleanups for shmem" from Baolin Wang
  does as it claims.

- The 20 patch series "fs/dax: Fix ZONE_DEVICE page reference counts"
  from Alistair Popple regularizes the weird ZONE_DEVICE page refcount
  handling in DAX, permittig the removal of a number of special-case
  checks.

- The 4 patch series "refactor mremap and fix bug" from Lorenzo Stoakes
  is a preparatoty refactoring and cleanup of the mremap() code.

- The 20 patch series "mm: MM owner tracking for large folios (!hugetlb)
  + CONFIG_NO_PAGE_MAPCOUNT" from David Hildenbrand reworks the manner in
  which we determine whether a large folio is known to be mapped
  exclusively into a single MM.

- The 8 patch series "mm/damon: add sysfs dirs for managing DAMOS
  filters based on handling layers" from SeongJae Park adds a couple of
  new sysfs directories to ease the management of DAMON/DAMOS filters.

- The 13 patch series "arch, mm: reduce code duplication in mem_init()"
  from Mike Rapoport consolidates many per-arch implementations of
  mem_init() into code generic code, where that is practical.

- The 13 patch series "mm/damon/sysfs: commit parameters online via
  damon_call()" from SeongJae Park continues the cleaning up of sysfs
  access to DAMON internal data.

- The 3 patch series "mm: page_ext: Introduce new iteration API" from
  Luiz Capitulino reworks the page_ext initialization to fix a boot-time
  crash which was observed with an unusual combination of compile and
  cmdline options.

- The 8 patch series "Buddy allocator like (or non-uniform) folio split"
  from Zi Yan reworks the code to split a folio into smaller folios.  The
  main benefit is lessened memory consumption: fewer post-split folios are
  generated.

- The 2 patch series "Minimize xa_node allocation during xarry split"
  from Zi Yan reduces the number of xarray xa_nodes which are generated
  during an xarray split.

- The 2 patch series "drivers/base/memory: Two cleanups" from Gavin Shan
  performs some maintenance work on the drivers/base/memory code.

- The 3 patch series "Add tracepoints for lowmem reserves, watermarks
  and totalreserve_pages" from Martin Liu adds some more tracepoints to
  the page allocator code.

- The 4 patch series "mm/madvise: cleanup requests validations and
  classifications" from SeongJae Park cleans up some warts which SeongJae
  observed during his earlier madvise work.

- The 3 patch series "mm/hwpoison: Fix regressions in memory failure
  handling" from Shuai Xue addresses two quite serious regressions which
  Shuai has observed in the memory-failure implementation.

- The 5 patch series "mm: reliable huge page allocator" from Johannes
  Weiner makes huge page allocations cheaper and more reliable by reducing
  fragmentation.

- The 5 patch series "Minor memcg cleanups & prep for memdescs" from
  Matthew Wilcox is preparatory work for the future implementation of
  memdescs.

- The 4 patch series "track memory used by balloon drivers" from Nico
  Pache introduces a way to track memory used by our various balloon
  drivers.

- The 2 patch series "mm/damon: introduce DAMOS filter type for active
  pages" from Nhat Pham permits users to filter for active/inactive pages,
  separately for file and anon pages.

- The 2 patch series "Adding Proactive Memory Reclaim Statistics" from
  Hao Jia separates the proactive reclaim statistics from the direct
  reclaim statistics.

- The 2 patch series "mm/vmscan: don't try to reclaim hwpoison folio"
  from Jinjiang Tu fixes our handling of hwpoisoned pages within the
  reclaim code.

----------------------------------------------------------------
Alistair Popple (20):
      fuse: fix dax truncate/punch_hole fault path
      fs/dax: return unmapped busy pages from dax_layout_busy_page_range()
      fs/dax: don't skip locked entries when scanning entries
      fs/dax: refactor wait for dax idle page
      fs/dax: create a common implementation to break DAX layouts
      fs/dax: always remove DAX page-cache entries when breaking layouts
      fs/dax: ensure all pages are idle prior to filesystem unmount
      fs/dax: remove PAGE_MAPPING_DAX_SHARED mapping flag
      mm/gup: remove redundant check for PCI P2PDMA page
      mm/mm_init: move p2pdma page refcount initialisation to p2pdma
      mm: allow compound zone device pages
      mm/memory: enhance insert_page_into_pte_locked() to create writable mappings
      mm/memory: add vmf_insert_page_mkwrite()
      mm/rmap: add support for PUD sized mappings to rmap
      mm/huge_memory: add vmf_insert_folio_pud()
      mm/huge_memory: add vmf_insert_folio_pmd()
      mm/gup: don't allow FOLL_LONGTERM pinning of FS DAX pages
      fs/dax: properly refcount fs dax pages
      device/dax: properly refcount device dax pages when mapping
      fs/dax: don't disassociate zero page entries

Andrew Morton (1):
      Merge branch 'mm-hotfixes-stable' into mm-stable in order to pick up memcg and DAMON changes which are required by mm-stable material.

Anshuman Khandual (5):
      configs: drop GENERIC_PTDUMP from debug.config
      arch/powerpc: drop GENERIC_PTDUMP from mpc885_ads_defconfig
      docs: arm64: drop PTDUMP config options from ptdump.rst
      mm: make DEBUG_WX depdendent on GENERIC_PTDUMP
      mm: rename GENERIC_PTDUMP and PTDUMP_CORE

Baolin Wang (6):
      mm: shmem: drop the unused macro
      mm: shmem: remove 'fadvise()' comments
      mm: shmem: remove duplicate error validation
      mm: shmem: change the return value of shmem_find_swap_entries()
      mm: shmem: factor out the within_size logic into a new helper
      MAINTAINERS: add Baolin as shmem reviewer

Baoquan He (14):
      mm/swap_state.c: fix the obsolete code comment
      mm/swap_state.c: optimize the code in clear_shadow_from_swap_cache()
      mm/swap: remove SWAP_FLAG_PRIO_SHIFT
      mm/swap: skip scanning cluster range if it's empty cluster
      mm/swap: rename swap_is_has_cache() to swap_only_has_cache()
      mm/swapfile.c: update the code comment above swap_count_continued()
      mm/swapfile.c: optimize code in setup_clusters()
      mm/swap_state.c: remove the meaningless code comment
      mm/swapfile.c: remove the unneeded checking
      mm/swap: rename swap_swapcount() to swap_entry_swapped()
      mm/swapfile.c: remove the incorrect code comment
      mm/swapfile.c: open code cluster_alloc_swap()
      mm/mmu_gather: remove unused __tlb_remove_page()
      mm/mmu_gather: clean up the stale code comment

Barry Song (4):
      mm: set folio swapbacked iff folios are dirty in try_to_unmap_one
      mm: support tlbbatch flush for a range of PTEs
      mm: support batched unmap for lazyfree large folios during reclamation
      mm: avoid splitting pmd for lazyfree pmd-mapped THP in try_to_unmap

Bart Van Assche (1):
      mm/vmstat: revert "fix a W=1 clang compiler warning"

Bertrand Wlodarczyk (1):
      vmscan, cleanup: add for_each_managed_zone_pgdat macro

Brendan Jackman (17):
      mm/mmu_gather: update comment on RCU freeing
      selftests/mm: report errno when things fail in gup_longterm
      selftests/mm: skip uffd-stress if userfaultfd not available
      selftests/mm: skip uffd-wp-mremap if userfaultfd not available
      selftests/mm/uffd: rename nr_cpus -> nr_parallel
      selftests/mm: print some details when uffd-stress gets bad params
      selftests/mm: don't fail uffd-stress if too many CPUs
      selftests/mm: skip map_populate on weird filesystems
      selftests/mm: skip gup_longterm tests on weird filesystems
      selftests/mm: drop unnecessary sudo usage
      selftests/mm: ensure uffd-wp-mremap gets pages of each size
      selftests/mm: skip mlock tests if nobody user can't read it
      selftests/mm/mlock: print error on failure
      mm/page_alloc: warn on nr_reserved_highatomic underflow
      mm/page_alloc: clarify terminology in migratetype fallback code
      mm/page_alloc: clarify should_claim_block() commentary
      selftests/mm: add commentary about 9pfs bugs

Carlos Llamas (1):
      mm/oom_kill: fix trivial typo in comment

Catalin Marinas (2):
      mm: kmemleak: add support for dumping physical and __percpu object info
      samples: kmemleak: print the raw pointers for debugging purposes

Chen Ridong (4):
      memcg: use OFP_PEAK_UNSET instead of -1
      memcg: call the free function when allocation of pn fails
      memcg: factor out the replace_stock_objcg function
      memcg: add CONFIG_MEMCG_V1 for 'local' functions

Christoph Hellwig (1):
      vmalloc: drop Christoph from Reviewers

Colin Ian King (1):
      mm/mincore: improve performance by adding an unlikely hint

Cyan Yang (1):
      selftests/mm/cow: fix the incorrect error handling

Dan Williams (1):
      dcssblk: mark DAX broken, remove FS_DAX_LIMITED support

David Hildenbrand (42):
      mm/gup: reject FOLL_SPLIT_PMD with hugetlb VMAs
      mm/rmap: reject hugetlb folios in folio_make_device_exclusive()
      mm/rmap: convert make_device_exclusive_range() to make_device_exclusive()
      mm/rmap: implement make_device_exclusive() using folio_walk instead of rmap walk
      mm/memory: detect writability in restore_exclusive_pte() through can_change_pte_writable()
      mm: use single SWP_DEVICE_EXCLUSIVE entry type
      mm/page_vma_mapped: device-exclusive entries are not migration entries
      kernel/events/uprobes: handle device-exclusive entries correctly in __replace_page()
      mm/ksm: handle device-exclusive entries correctly in write_protect_page()
      mm/rmap: handle device-exclusive entries correctly in try_to_unmap_one()
      mm/rmap: handle device-exclusive entries correctly in try_to_migrate_one()
      mm/rmap: handle device-exclusive entries correctly in page_vma_mkclean_one()
      mm/page_idle: handle device-exclusive entries correctly in page_idle_clear_pte_refs_one()
      mm/damon: handle device-exclusive entries correctly in damon_folio_young_one()
      mm/damon: handle device-exclusive entries correctly in damon_folio_mkold_one()
      mm/rmap: keep mapcount untouched for device-exclusive entries
      mm/rmap: avoid -EBUSY from make_device_exclusive()
      lib/test_hmm: make dmirror_atomic_map() consume a single page
      mm/memory: remove PageAnonExclusive sanity-check in restore_exclusive_pte()
      mm/memory: pass folio and pte to restore_exclusive_pte()
      mm/memory: document restore_exclusive_pte()
      mm/mmu_notifier: use MMU_NOTIFY_CLEAR in remove_device_exclusive_entry()
      mm: factor out large folio handling from folio_order() into folio_large_order()
      mm: factor out large folio handling from folio_nr_pages() into folio_large_nr_pages()
      mm: let _folio_nr_pages overlay memcg_data in first tail page
      mm: move hugetlb specific things in folio to page[3]
      mm: move _pincount in folio to page[2] on 32bit
      mm: move _entire_mapcount in folio to page[2] on 32bit
      mm/rmap: pass dst_vma to folio_dup_file_rmap_pte() and friends
      mm/rmap: pass vma to __folio_add_rmap()
      mm/rmap: abstract large mapcount operations for large folios (!hugetlb)
      bit_spinlock: __always_inline (un)lock functions
      mm/rmap: use folio_large_nr_pages() in add/remove functions
      mm/rmap: basic MM owner tracking for large folios (!hugetlb)
      mm: Copy-on-Write (COW) reuse support for PTE-mapped THP
      mm: convert folio_likely_mapped_shared() to folio_maybe_mapped_shared()
      mm: CONFIG_NO_PAGE_MAPCOUNT to prepare for not maintain per-page mapcounts in large folios
      fs/proc/page: remove per-page mapcount dependency for /proc/kpagecount (CONFIG_NO_PAGE_MAPCOUNT)
      fs/proc/task_mmu: remove per-page mapcount dependency for PM_MMAP_EXCLUSIVE (CONFIG_NO_PAGE_MAPCOUNT)
      fs/proc/task_mmu: remove per-page mapcount dependency for "mapmax" (CONFIG_NO_PAGE_MAPCOUNT)
      fs/proc/task_mmu: remove per-page mapcount dependency for smaps/smaps_rollup (CONFIG_NO_PAGE_MAPCOUNT)
      mm: stop maintaining the per-page mapcount of large folios (CONFIG_NO_PAGE_MAPCOUNT)

David Laight (1):
      mm: remove the access_ok() call from gup_fast_fallback()

Dev Jain (1):
      mm: remove redundant return in set_huge_zero_folio()

Enrico Bravi (1):
      mm/shmem: fix functions documentation

Eric Salem (1):
      selftests: mm: fix typo

Frank van der Linden (27):
      mm/cma: export total and free number of pages for CMA areas
      mm, cma: support multiple contiguous ranges, if requested
      mm/cma: introduce cma_intersects function
      mm, hugetlb: use cma_declare_contiguous_multi
      mm/hugetlb: remove redundant __ClearPageReserved
      mm/hugetlb: use online nodes for bootmem allocation
      mm/hugetlb: convert cmdline parameters from setup to early
      x86/mm: make register_page_bootmem_memmap handle PTE mappings
      mm/bootmem_info: export register_page_bootmem_memmap
      mm/sparse: allow for alternate vmemmap section init at boot
      mm/hugetlb: set migratetype for bootmem folios
      mm: define __init_reserved_page_zone function
      mm/hugetlb: check bootmem pages for zone intersections
      mm/sparse: add vmemmap_*_hvo functions
      mm/hugetlb: deal with multiple calls to hugetlb_bootmem_alloc
      mm/hugetlb: move huge_boot_pages list init to hugetlb_bootmem_alloc
      mm/hugetlb: add pre-HVO framework
      mm/hugetlb_vmemmap: fix hugetlb_vmemmap_restore_folios definition
      mm/hugetlb: do pre-HVO for bootmem allocated pages
      x86/setup: call hugetlb_bootmem_alloc early
      x86/mm: set ARCH_WANT_HUGETLB_VMEMMAP_PREINIT
      mm/cma: simplify zone intersection check
      mm/cma: introduce a cma validate function
      mm/cma: introduce interface for early reservations
      mm/hugetlb: add hugetlb_cma_only cmdline option
      mm/hugetlb: enable bootmem allocation from CMA areas
      mm/hugetlb: move hugetlb CMA code in to its own file

Gavin Shan (2):
      drivers/base/memory: improve add_boot_memory_block()
      drivers/base/memory: correct the field name in the header

Ge Yang (1):
      mm/cma: using per-CMA locks to improve concurrent allocation performance

Guanjun (1):
      filemap: remove redundant folio_test_large check in filemap_free_folio

Hao Jia (2):
      mm: vmscan: split proactive reclaim statistics from direct reclaim statistics
      cgroup: docs: add pswpin and pswpout items in cgroup v2 doc

Hao Zhang (1):
      mm/vmscan: extract calculated pressure balance as a function

I Hsin Cheng (2):
      maple_tree: correct comment for mas_start()
      maple_tree: use ma_dead_node() in mte_dead_node()

Jane Chu (1):
      mm: make page_mapped_in_vma() hugetlb walk aware

Jinjiang Tu (2):
      mm/hwpoison: introduce folio_contain_hwpoisoned_page() helper
      mm/vmscan: don't try to reclaim hwpoison folio

Jiwen Qi (1):
      docs/mm: Physical Memory: Populate the "Zones" section

Johannes Weiner (12):
      mm: memcontrol: unshare v2-only charge API bits again
      mm: memcontrol: move stray ratelimit bits to v1
      mm: memcontrol: move memsw charge callbacks to v1
      mm: page_alloc: don't steal single pages from biggest buddy
      mm: page_alloc: remove remnants of unlocked migratetype updates
      mm: page_alloc: group fallback functions together
      mm: swap_cgroup: remove double initialization of locals
      mm: compaction: push watermark into compaction_suitable() callers
      mm: page_alloc: trace type pollution from compaction capturing
      mm: page_alloc: defrag_mode
      mm: page_alloc: defrag_mode kswapd/kcompactd assistance
      mm: page_alloc: defrag_mode kswapd/kcompactd watermarks

Kairui Song (7):
      mm, swap: avoid reclaiming irrelevant swap cache
      mm, swap: drop the flag TTRS_DIRECT
      mm, swap: avoid redundant swap device pinning
      mm, swap: don't update the counter up-front
      mm, swap: use percpu cluster as allocation fast path
      mm, swap: remove swap slot cache
      mm, swap: simplify folio swap allocation

Kemeng Shi (3):
      mm, swap: remove setting SWAP_MAP_BAD for discard cluster
      mm, swap: correct comment in swap_usage_sub()
      mm: swap: remove stale comment of swap_reclaim_full_clusters()

Liu Shixin (1):
      mm/hugetlb: update nr_huge_pages and surplus_huge_pages together

Liu Ye (6):
      mm/memfd: fix spelling and grammatical issues
      mm/folio_queue: delete __folio_order and use folio_order directly
      mm/shrinker: fix name consistency issue in shrinker_debugfs_rename()
      mm/vmalloc: refactor __vmalloc_node_range_noprof()
      mm/debug: add line breaks
      mm/page_alloc: remove unnecessary __maybe_unused in order_to_pindex()

Lorenzo Stoakes (22):
      mm: simplify vma merge structure and expand comments
      mm: further refactor commit_merge()
      mm: eliminate adj_start parameter from commit_merge()
      mm: make vmg->target consistent and further simplify commit_merge()
      mm: completely abstract unnecessary adj_start calculation
      mm: use READ/WRITE_ONCE() for vma->vm_flags on migrate, mprotect
      mm: refactor rmap_walk_file() to separate out traversal logic
      mm: provide mapping_wrprotect_range() function
      fb_defio: do not use deprecated page->mapping, index fields
      mm: allow guard regions in file-backed and read-only mappings
      selftests/mm: rename guard-pages to guard-regions
      tools/selftests: expand all guard region tests to file-backed
      tools/selftests: add file/shmem-backed mapping guard region tests
      fs/proc/task_mmu: add guard region bit to pagemap
      tools/selftests: add guard region test for /proc/$pid/pagemap
      mm/mremap: correctly handle partial mremap() of VMA starting at 0
      mm/mremap: refactor mremap() system call implementation
      mm/mremap: introduce and use vma_remap_struct threaded state
      mm/mremap: initial refactor of move_vma()
      mm/mremap: complete refactor of move_vma()
      mm/mremap: refactor move_page_tables(), abstracting state
      mm/mremap: thread state through move page table operation

Luiz Capitulino (3):
      mm: page_ext: add an iteration API for page extensions
      mm: page_table_check: use new iteration API
      mm: page_owner: use new iteration API

Lukas Bulwahn (1):
      MAINTAINERS: adjust file entry in MAPLE TREE

Marcelo Moreira (1):
      Docs/mm/damon: fix spelling and grammar in monitoring_intervals_tuning_example.rst

Mark Brown (2):
      selftests/mm: fix thuge-gen test name uniqueness
      selftests/mm: allow tests to run with no huge pages support

Martin Liu (3):
      mm/page_alloc: add trace event for per-zone watermark setup
      mm/page_alloc: add trace event for per-zone lowmem reserve setup
      mm/page_alloc: add trace event for totalreserve_pages calculation

Mathieu Desnoyers (2):
      mm: add missing release barrier on PGDAT_RECLAIM_LOCKED unlock
      mm: lock PGDAT_RECLAIM_LOCKED with acquire memory ordering

Matthew Wilcox (Oracle) (14):
      fs: convert block_commit_write() to take a folio
      fs: remove page_file_mapping()
      fs: remove folio_file_mapping()
      mm: assert the folio is locked in folio_start_writeback()
      dax: remove access to page->index
      dax: use folios more widely within DAX
      hugetlb: convert hugetlb_vma_maps_page() to hugetlb_vma_maps_pfn()
      hugetlb: convert adjust_range_hwpoison() to take a folio
      mm: convert lru_add_page_tail() to lru_add_split_folio()
      mm: separate folio_split_memcg_refs() from split_page_memcg()
      mm: simplify split_page_memcg()
      mm: remove references to folio in split_page_memcg()
      mm: simplify folio_memcg_charged()
      mm: remove references to folio in __memcg_kmem_uncharge_page()

Michal Hocko (1):
      mm, percpu: do not consider sleepable allocations atomic

Mike Rapoport (Microsoft) (16):
      arm: mem_init: use memblock_phys_free() to free DMA memory on SA1111
      csky: move setup_initrd() to setup.c
      hexagon: move initialization of init_mm.context init to paging_init()
      MIPS: consolidate mem_init() for NUMA machines
      MIPS: make setup_zero_pages() use memblock
      nios2: move pr_debug() about memory start and end to setup_arch()
      s390: make setup_zero_pages() use memblock
      xtensa: split out printing of virtual memory layout to a function
      arch, mm: set max_mapnr when allocating memory map for FLATMEM
      arch, mm: set high_memory in free_area_init()
      arch, mm: streamline HIGHMEM freeing
      arch, mm: introduce arch_mm_preinit
      arch, mm: make releasing of memory to page allocator more explicit
      mm/mm_init: rename __init_reserved_page_zone to __init_page_from_nid
      mm/mm_init: rename init_reserved_page to init_deferred_page
      x86/mm: restore early initialization of high_memory for 32-bits

Nhat Pham (3):
      page_io: zswap: do not crash the kernel on decompression failure
      mm/damon: implement a new DAMOS filter type for active pages
      docs/mm/damon/design: document active DAMOS filter type

Nico Pache (5):
      meminfo: add a per node counter for balloon drivers
      balloon_compaction: update the NR_BALLOON_PAGES state
      hv_balloon: update the NR_BALLOON_PAGES state
      xen: balloon: update the NR_BALLOON_PAGES state
      MM documentation: add "Unaccepted" meminfo entry

Petr Tesarik (1):
      maple_tree: remove a BUG_ON() in mas_alloc_nodes()

Ryan Roberts (9):
      mm/ioremap: pass pgprot_t to ioremap_prot() instead of unsigned long
      mm: fix lazy mmu docs and usage
      fs/proc/task_mmu: reduce scope of lazy mmu region
      sparc/mm: disable preemption in lazy mmu mode
      sparc/mm: avoid calling arch_enter/leave_lazy_mmu() in set_ptes
      Revert "x86/xen: allow nesting of same lazy mode"
      mm: use ptep_get() instead of directly dereferencing pte_t*
      selftests/mm: uffd-unit-tests support for hugepages > 2M
      selftests/mm: speed up split_huge_page_test

SeongJae Park (58):
      mm/madvise: split out mmap locking operations for madvise()
      mm/madvise: split out madvise input validity check
      mm/madvise: split out madvise() behavior execution
      mm/madvise: remove redundant mmap_lock operations from process_madvise()
      mm/damon: avoid applying DAMOS action to same entity multiple times
      mm/damon/core: unset damos->walk_completed after confimed set
      mm/damon/core: do not call damos_walk_control->walk() if walk is completed
      mm/damon/core: do damos walking in entire regions granularity
      Docs/mm/damon/design: fix typo on DAMOS filters usage doc link
      Docs/mm/damon/design: document hugepage_size filter
      Docs/damon: move DAMOS filter type names and meaning to design doc
      Docs/mm/damon/design: clarify handling layer based filters evaluation sequence
      Docs/mm/damon/design: categorize DAMOS filter types based on handling layer
      mm/damon: implement a new DAMOS filter type for unmapped pages
      Docs/mm/damon/design: document unmapped DAMOS filter type
      mm/damon: add data structure for monitoring intervals auto-tuning
      mm/damon/core: implement intervals auto-tuning
      mm/damon/sysfs: implement intervals tuning goal directory
      mm/damon/sysfs: commit intervals tuning goal
      mm/damon/sysfs: implement a command to update auto-tuned monitoring intervals
      Docs/mm/damon/design: document for intervals auto-tuning
      Docs/ABI/damon: document intervals auto-tuning ABI
      Docs/admin-guide/mm/damon/usage: add intervals_goal directory on the hierarchy
      mm/damon/core: introduce damos->ops_filters
      mm/damon/paddr: support ops_filters
      mm/damon/core: support committing ops_filters
      mm/damon/core: put ops-handled filters to damos->ops_filters
      mm/damon/paddr: support only damos->ops_filters
      mm/damon: add default allow/reject behavior fields to struct damos
      mm/damon/core: set damos_filter default allowance behavior based on installed filters
      mm/damon/paddr: respect ops_filters_default_reject
      Docs/mm/damon/design: update for changed filter-default behavior
      mm/damon/sysfs-schemes: let damon_sysfs_scheme_set_filters() be used for different named directories
      mm/damon/sysfs-schemes: implement core_filters and ops_filters directories
      mm/damon/sysfs-schemes: commit filters in {core,ops}_filters directories
      mm/damon/core: expose damos_filter_for_ops() to DAMON kernel API callers
      mm/damon/sysfs-schemes: record filters of which layer should be added to the given filters directory
      mm/damon/sysfs-schemes: return error when for attempts to install filters on wrong sysfs directory
      Docs/ABI/damon: document {core,ops}_filters directories
      Docs/admin-guide/mm/damon/usage: update for {core,ops}_filters directories
      mm/damon/sysfs: validate user inputs from damon_sysfs_commit_input()
      mm/damon/core: invoke kdamond_call() after merging is done if possible
      mm/damon/core: make damon_set_attrs() be safe to be called from damon_call()
      mm/damon/sysfs: handle commit command using damon_call()
      mm/damon/sysfs: remove damon_sysfs_cmd_request code from damon_sysfs_handle_cmd()
      mm/damon/sysfs: remove damon_sysfs_cmd_request_callback() and its callers
      mm/damon/sysfs: remove damon_sysfs_cmd_request and its readers
      mm/damon/sysfs-schemes: remove obsolete comment for damon_sysfs_schemes_clear_regions()
      mm/damon: remove damon_callback->private
      mm/damon: remove ->before_start of damon_callback
      mm/damon: remove damon_callback->after_sampling
      mm/damon: remove damon_callback->before_damos_apply
      mm/damon: remove damon_operations->reset_aggregated
      mm/damon/sysfs-schemes: avoid Wformat-security warning on damon_sysfs_access_pattern_add_range_dir()
      mm/madvise: use is_memory_failure() from madvise_do_behavior()
      mm/madvise: split out populate behavior check logic
      mm/madvise: deduplicate madvise_do_behavior() skip case handlings
      mm/madvise: remove len parameter of madvise_do_behavior()

Seongjun Kim (1):
      samples/damon: a typo in the kconfig - sameple

Sergey Senozhatsky (19):
      zram: sleepable entry locking
      zram: permit preemption with active compression stream
      zram: remove unused crypto include
      zram: remove max_comp_streams device attr
      zram: remove second stage of handle allocation
      zram: add GFP_NOWARN to incompressible zsmalloc handle allocation
      zram: remove writestall zram_stats member
      zram: limit max recompress prio to num_active_comps
      zram: filter out recomp targets based on priority
      zram: rework recompression loop
      zram: move post-processing target allocation
      zsmalloc: rename pool lock
      zsmalloc: sleepable zspage reader-lock
      zsmalloc: introduce new object mapping API
      zram: switch to new zsmalloc object mapping API
      zram: permit reclaim in zstd custom allocator
      zram: do not leak page on recompress_store error path
      zram: do not leak page on writeback_store error path
      zram: add might_sleep to zcomp API

Shakeel Butt (6):
      memcg: don't call propagate_protected_usage() for v1
      page_counter: track failcnt only for legacy cgroups
      page_counter: reduce struct page_counter size
      memcg: bypass root memcg check for skmem charging
      memcg: avoid refill_stock for root memcg
      memcg: move do_memsw_account() to CONFIG_MEMCG_V1

Shiyang Ruan (1):
      drivers/base/memory: simplify outputting of valid_zones_show()

Shuai Xue (3):
      x86/mce: use is_copy_from_user() to determine copy-from-user context
      mm/hwpoison: do not send SIGBUS to processes with recovered clean pages
      mm: memory-failure: enhance comments for return value of memory_failure()

Suchit K (1):
      Documentation/mm: fix spelling mistake

Suren Baghdasaryan (21):
      mm: avoid extra mem_alloc_profiling_enabled() checks
      alloc_tag: uninline code gated by mem_alloc_profiling_key in slab allocator
      alloc_tag: uninline code gated by mem_alloc_profiling_key in page allocator
      mm: introduce vma_start_read_locked{_nested} helpers
      mm: move per-vma lock into vm_area_struct
      mm: mark vma as detached until it's added into vma tree
      mm: introduce vma_iter_store_attached() to use with attached vmas
      mm: mark vmas detached upon exit
      types: move struct rcuwait into types.h
      mm: allow vma_start_read_locked/vma_start_read_locked_nested to fail
      mm: move mmap_init_lock() out of the header file
      mm: uninline the main body of vma_start_write()
      refcount: provide ops for cases when object's memory can be reused
      refcount: introduce __refcount_{add|inc}_not_zero_limited_acquire
      mm: replace vm_lock and detached flag with a reference count
      mm: move lesser used vma_area_struct members into the last cacheline
      mm/debug: print vm_refcnt state when dumping the vma
      mm: remove extra vma_numab_state_init() call
      mm: prepare lock_vma_under_rcu() for vma reuse possibility
      mm: make vma cache SLAB_TYPESAFE_BY_RCU
      docs/mm: document latest changes to vm_lock

Tang Yizhou (3):
      writeback: let trace_balance_dirty_pages() take struct dtc as parameter
      writeback: rename variables in trace_balance_dirty_pages()
      writeback: fix calculations in trace_balance_dirty_pages() for cgwb

Thomas Prescher (3):
      mm: hugetlb: improve parallel huge page allocation time
      mm: hugetlb: add hugetlb_alloc_threads cmdline option
      mm: hugetlb: log time needed to allocate hugepages

Thorsten Blum (1):
      arm/pgtable: remove duplicate included header file

Ujwal Kundur (1):
      selftests/mm: fix spelling

Uladzislau Rezki (Sony) (1):
      fork: use __vmalloc_node() for stack allocation

Uros Bizjak (6):
      x86/kgdb: use IS_ERR_PCPU() macro
      compiler.h: introduce TYPEOF_UNQUAL() macro
      percpu: use TYPEOF_UNQUAL() in variable declarations
      percpu: use TYPEOF_UNQUAL() in *_cpu_ptr() accessors
      percpu: repurpose __percpu tag as a named address space qualifier
      percpu/x86: enable strict percpu checks via named AS qualifiers

Usama Arif (5):
      mm/damon/ops: have damon_get_folio return folio even for tail pages
      mm/damon: introduce DAMOS filter type hugepage_size
      mm/damon/sysfs-schemes: add files for setting damos_filter->sz_range
      Docs/ABI/damon: document DAMOS sysfs files to set the min/max folio_size
      Docs/admin-guide/mm/damon/usage: document hugepage_size filter type

Wei Yang (3):
      mm/mm_init.c: use round_up() to align movable range
      mm/mm_init.c: only align start of ZONE_MOVABLE on nodes with memory
      mm/mm_init.c: use round_up() to calculate usermap size

Yosry Ahmed (7):
      mm: z3fold: remove z3fold
      mm: zbud: remove zbud
      mm: zpool: add interfaces for object read/write APIs
      mm: zswap: use object read/write APIs instead of object mapping APIs
      mm: zpool: remove object mapping APIs
      mm: zsmalloc: remove object mapping APIs and per-CPU map areas
      mm: zpool: remove zpool_malloc_support_movable()

Zeng Jingxiang (1):
      mm/list_lru: make the case where mlru is NULL as unlikely

Zi Yan (13):
      selftests/mm: make file-backed THP split work by writing PMD size data
      mm/huge_memory: allow split shmem large folio to any lower order
      selftests/mm: test splitting file-backed THP to any lower order
      xarray: add xas_try_split() to split a multi-index entry
      mm/huge_memory: add two new (not yet used) functions for folio_split()
      mm/huge_memory: move folio split common code to __folio_split()
      mm/huge_memory: add buddy allocator like (non-uniform) folio_split()
      mm/huge_memory: remove the old, unused __split_huge_page()
      mm/huge_memory: add folio_split() to debugfs testing interface
      mm/truncate: use folio_split() in truncate operation
      selftests/mm: add tests for folio_split(), buddy allocator like split
      mm/filemap: use xas_try_split() in __filemap_add_folio()
      mm/shmem: use xas_try_split() in shmem_split_large_entry()

 CREDITS                                            |    3 +
 Documentation/ABI/testing/sysfs-block-zram         |    8 -
 Documentation/ABI/testing/sysfs-kernel-mm-cma      |   13 +
 Documentation/ABI/testing/sysfs-kernel-mm-damon    |   60 +
 Documentation/RCU/whatisRCU.rst                    |   10 +
 Documentation/admin-guide/blockdev/zram.rst        |   36 +-
 Documentation/admin-guide/cgroup-v1/memory.rst     |    4 +
 Documentation/admin-guide/cgroup-v2.rst            |   25 +-
 Documentation/admin-guide/kernel-parameters.txt    |   30 +-
 Documentation/admin-guide/mm/cma_debugfs.rst       |   10 +-
 Documentation/admin-guide/mm/damon/usage.rst       |   87 +-
 Documentation/admin-guide/mm/hugetlbpage.rst       |   10 +
 Documentation/admin-guide/mm/pagemap.rst           |   21 +-
 Documentation/admin-guide/mm/zswap.rst             |   10 +-
 Documentation/admin-guide/sysctl/vm.rst            |    9 +
 Documentation/arch/arm64/ptdump.rst                |    2 -
 Documentation/core-api/refcount-vs-atomic.rst      |   37 +-
 Documentation/core-api/xarray.rst                  |   14 +-
 Documentation/filesystems/dax.rst                  |    1 -
 Documentation/filesystems/proc.rst                 |   43 +-
 Documentation/mm/balance.rst                       |    2 +-
 Documentation/mm/damon/design.rst                  |  123 +-
 .../damon/monitoring_intervals_tuning_example.rst  |    8 +-
 Documentation/mm/hmm.rst                           |    2 +-
 Documentation/mm/index.rst                         |    1 -
 Documentation/mm/physical_memory.rst               |  266 +++-
 Documentation/mm/process_addrs.rst                 |   44 +-
 Documentation/mm/transhuge.rst                     |   39 +-
 Documentation/mm/z3fold.rst                        |   28 -
 Documentation/mm/zsmalloc.rst                      |    5 +-
 Documentation/translations/zh_CN/mm/hmm.rst        |    2 +-
 Documentation/translations/zh_CN/mm/index.rst      |    1 -
 Documentation/translations/zh_CN/mm/z3fold.rst     |   31 -
 MAINTAINERS                                        |   20 +-
 arch/alpha/mm/init.c                               |    8 -
 arch/arc/mm/init.c                                 |   25 +-
 arch/arc/mm/ioremap.c                              |    6 +-
 arch/arm/include/asm/pgtable.h                     |    5 +-
 arch/arm/mm/init.c                                 |   43 +-
 arch/arm64/Kconfig                                 |    2 +-
 arch/arm64/include/asm/io.h                        |    6 +-
 arch/arm64/include/asm/ptdump.h                    |    4 +-
 arch/arm64/include/asm/tlbflush.h                  |   23 +-
 arch/arm64/kernel/acpi.c                           |    2 +-
 arch/arm64/kvm/Kconfig                             |    4 +-
 arch/arm64/mm/Makefile                             |    2 +-
 arch/arm64/mm/contpte.c                            |    2 +-
 arch/arm64/mm/init.c                               |   12 +-
 arch/arm64/mm/ioremap.c                            |    3 +-
 arch/csky/include/asm/io.h                         |    2 +-
 arch/csky/kernel/setup.c                           |   43 +
 arch/csky/mm/init.c                                |   67 -
 arch/hexagon/mm/init.c                             |   32 +-
 arch/loongarch/configs/loongson3_defconfig         |    3 +-
 arch/loongarch/include/asm/io.h                    |   10 +-
 arch/loongarch/kernel/numa.c                       |    6 -
 arch/loongarch/mm/init.c                           |    8 -
 arch/m68k/mm/init.c                                |    2 -
 arch/microblaze/mm/init.c                          |   25 -
 arch/mips/include/asm/io.h                         |    8 +-
 arch/mips/include/asm/mmzone.h                     |    2 -
 arch/mips/loongson64/numa.c                        |    7 -
 arch/mips/mm/init.c                                |   51 +-
 arch/mips/mm/ioremap.c                             |    4 +-
 arch/mips/mm/ioremap64.c                           |    4 +-
 arch/mips/sgi-ip27/ip27-memory.c                   |    9 -
 arch/nios2/kernel/setup.c                          |    3 +-
 arch/nios2/mm/init.c                               |   16 +-
 arch/openrisc/mm/init.c                            |    6 -
 arch/parisc/include/asm/io.h                       |    2 +-
 arch/parisc/mm/init.c                              |    4 -
 arch/parisc/mm/ioremap.c                           |    4 +-
 arch/powerpc/Kconfig                               |    2 +-
 arch/powerpc/configs/mpc885_ads_defconfig          |    2 +-
 arch/powerpc/include/asm/book3s/64/hugetlb.h       |    6 +
 arch/powerpc/include/asm/io.h                      |    2 +-
 arch/powerpc/kernel/setup-common.c                 |    2 -
 arch/powerpc/mm/Makefile                           |    2 +-
 arch/powerpc/mm/hugetlbpage.c                      |    1 +
 arch/powerpc/mm/init_64.c                          |    4 +
 arch/powerpc/mm/ioremap.c                          |    4 +-
 arch/powerpc/mm/mem.c                              |   18 +-
 arch/powerpc/platforms/ps3/spu.c                   |    4 +-
 arch/riscv/Kconfig                                 |    2 +-
 arch/riscv/include/asm/io.h                        |    2 +-
 arch/riscv/include/asm/tlbflush.h                  |    3 +-
 arch/riscv/kernel/acpi.c                           |    2 +-
 arch/riscv/mm/Makefile                             |    2 +-
 arch/riscv/mm/init.c                               |    5 +-
 arch/riscv/mm/tlbflush.c                           |    3 +-
 arch/s390/Kconfig                                  |    2 +-
 arch/s390/configs/debug_defconfig                  |    2 +-
 arch/s390/configs/defconfig                        |    2 +-
 arch/s390/include/asm/io.h                         |    4 +-
 arch/s390/mm/Makefile                              |    2 +-
 arch/s390/mm/init.c                                |   33 +-
 arch/s390/pci/pci.c                                |    4 +-
 arch/sh/boards/mach-landisk/setup.c                |    2 +-
 arch/sh/boards/mach-lboxre2/setup.c                |    2 +-
 arch/sh/boards/mach-sh03/setup.c                   |    2 +-
 arch/sh/include/asm/io.h                           |    2 +-
 arch/sh/mm/init.c                                  |   10 -
 arch/sh/mm/ioremap.c                               |    3 +-
 arch/sparc/include/asm/pgtable_64.h                |    2 -
 arch/sparc/mm/init_32.c                            |   31 +-
 arch/sparc/mm/init_64.c                            |    4 -
 arch/sparc/mm/tlb.c                                |    5 +-
 arch/um/include/shared/mem_user.h                  |    1 -
 arch/um/kernel/mem.c                               |    9 +-
 arch/um/kernel/physmem.c                           |   12 -
 arch/um/kernel/um_arch.c                           |    2 -
 arch/x86/Kconfig                                   |    3 +-
 arch/x86/Kconfig.debug                             |    2 +-
 arch/x86/include/asm/highmem.h                     |    3 -
 arch/x86/include/asm/io.h                          |    2 +-
 arch/x86/include/asm/numa.h                        |    4 -
 arch/x86/include/asm/numa_32.h                     |   13 -
 arch/x86/include/asm/percpu.h                      |   33 +-
 arch/x86/include/asm/tlbflush.h                    |    3 +-
 arch/x86/include/asm/xen/hypervisor.h              |   15 +-
 arch/x86/kernel/cpu/mce/severity.c                 |   11 +-
 arch/x86/kernel/kgdb.c                             |    2 +-
 arch/x86/kernel/setup.c                            |    6 +-
 arch/x86/mm/Makefile                               |    4 +-
 arch/x86/mm/highmem_32.c                           |   34 -
 arch/x86/mm/init_32.c                              |   38 +-
 arch/x86/mm/init_64.c                              |   25 +-
 arch/x86/mm/ioremap.c                              |    4 +-
 arch/x86/xen/enlighten_pv.c                        |    1 -
 arch/xtensa/include/asm/io.h                       |    6 +-
 arch/xtensa/mm/init.c                              |   66 +-
 arch/xtensa/mm/ioremap.c                           |    4 +-
 drivers/base/memory.c                              |   29 +-
 drivers/block/zram/backend_zstd.c                  |   11 +-
 drivers/block/zram/zcomp.c                         |   48 +-
 drivers/block/zram/zcomp.h                         |    8 +-
 drivers/block/zram/zram_drv.c                      |  330 +++--
 drivers/block/zram/zram_drv.h                      |   17 +-
 drivers/dax/device.c                               |   24 +-
 drivers/gpu/drm/nouveau/nouveau_dmem.c             |    3 +-
 drivers/gpu/drm/nouveau/nouveau_svm.c              |    5 +-
 drivers/hv/hv_balloon.c                            |    2 +
 drivers/nvdimm/pmem.c                              |    4 +-
 drivers/pci/p2pdma.c                               |   19 +-
 drivers/s390/block/Kconfig                         |   12 +-
 drivers/s390/block/dcssblk.c                       |   27 +-
 drivers/video/fbdev/core/fb_defio.c                |   43 +-
 drivers/xen/balloon.c                              |    4 +
 fs/Kconfig                                         |    1 +
 fs/bcachefs/util.h                                 |    2 +-
 fs/buffer.c                                        |   14 +-
 fs/dax.c                                           |  369 +++--
 fs/ext4/inline.c                                   |    2 +-
 fs/ext4/inode.c                                    |   18 +-
 fs/ext4/move_extent.c                              |    2 +-
 fs/fuse/dax.c                                      |   30 +-
 fs/fuse/dir.c                                      |    2 +-
 fs/fuse/file.c                                     |    4 +-
 fs/fuse/virtio_fs.c                                |    3 +-
 fs/hugetlbfs/inode.c                               |   28 +-
 fs/iomap/buffered-io.c                             |    2 +-
 fs/ocfs2/aops.c                                    |    4 +-
 fs/ocfs2/file.c                                    |    2 +-
 fs/proc/internal.h                                 |   43 +
 fs/proc/meminfo.c                                  |    2 +
 fs/proc/page.c                                     |   11 +-
 fs/proc/task_mmu.c                                 |   56 +-
 fs/udf/file.c                                      |    2 +-
 fs/xfs/xfs_inode.c                                 |   31 +-
 fs/xfs/xfs_inode.h                                 |    2 +-
 fs/xfs/xfs_super.c                                 |   12 +
 include/asm-generic/io.h                           |    4 +-
 include/asm-generic/memory_model.h                 |    5 +-
 include/asm-generic/percpu.h                       |   39 +-
 include/asm-generic/tlb.h                          |   31 +-
 include/linux/bit_spinlock.h                       |    8 +-
 include/linux/bootmem_info.h                       |    7 +
 include/linux/buffer_head.h                        |    2 +-
 include/linux/cma.h                                |    9 +
 include/linux/compaction.h                         |    5 +-
 include/linux/compiler-clang.h                     |    8 +
 include/linux/compiler-gcc.h                       |    8 +
 include/linux/compiler.h                           |   20 +
 include/linux/compiler_types.h                     |    2 +-
 include/linux/cpuhotplug.h                         |    1 -
 include/linux/damon.h                              |  118 +-
 include/linux/dax.h                                |   28 +
 include/linux/fb.h                                 |    1 +
 include/linux/folio_queue.h                        |   12 +-
 include/linux/huge_mm.h                            |   44 +-
 include/linux/hugetlb.h                            |   35 +
 include/linux/memblock.h                           |    1 -
 include/linux/memcontrol.h                         |   32 +-
 include/linux/memory.h                             |    2 +-
 include/linux/memremap.h                           |   17 +-
 include/linux/migrate.h                            |    4 +-
 include/linux/mm.h                                 |  331 +++--
 include/linux/mm_types.h                           |  203 ++-
 include/linux/mmap_lock.h                          |    6 -
 include/linux/mmu_notifier.h                       |    8 +-
 include/linux/mmzone.h                             |   55 +-
 include/linux/page-flags.h                         |   16 +-
 include/linux/page_counter.h                       |    9 +-
 include/linux/page_ext.h                           |   93 ++
 include/linux/pagemap.h                            |   25 -
 include/linux/part_stat.h                          |    2 +-
 include/linux/percpu-defs.h                        |    6 +-
 include/linux/pgalloc_tag.h                        |   77 +-
 include/linux/pgtable.h                            |   14 +-
 include/linux/rcuwait.h                            |   13 +-
 include/linux/refcount.h                           |  125 ++
 include/linux/rmap.h                               |  293 +++-
 include/linux/slab.h                               |   15 +-
 include/linux/swap.h                               |   41 +-
 include/linux/swap_slots.h                         |   28 -
 include/linux/swapops.h                            |   27 +-
 include/linux/types.h                              |   12 +
 include/linux/vm_event_item.h                      |    2 +
 include/linux/vmstat.h                             |    2 +-
 include/linux/writeback.h                          |   24 +
 include/linux/xarray.h                             |   13 +
 include/linux/zpool.h                              |   47 +-
 include/linux/zsmalloc.h                           |   29 +-
 include/linux/zswap.h                              |    6 +-
 include/net/snmp.h                                 |    5 +-
 include/trace/events/kmem.h                        |   78 ++
 include/trace/events/writeback.h                   |   33 +-
 kernel/configs/debug.config                        |    1 -
 kernel/events/uprobes.c                            |   13 +-
 kernel/fork.c                                      |  171 ++-
 kernel/locking/percpu-rwsem.c                      |    2 +-
 lib/alloc_tag.c                                    |    6 +-
 lib/maple_tree.c                                   |   10 +-
 lib/test_hmm.c                                     |   72 +-
 lib/test_xarray.c                                  |   52 +
 lib/xarray.c                                       |  157 ++-
 mm/Kconfig                                         |   74 +-
 mm/Kconfig.debug                                   |   11 +-
 mm/Makefile                                        |    9 +-
 mm/balloon_compaction.c                            |    2 +
 mm/bootmem_info.c                                  |    4 +-
 mm/cma.c                                           |  746 ++++++++--
 mm/cma.h                                           |   47 +-
 mm/cma_debug.c                                     |   61 +-
 mm/cma_sysfs.c                                     |   20 +
 mm/compaction.c                                    |   95 +-
 mm/damon/core.c                                    |  303 +++-
 mm/damon/ops-common.c                              |   25 +-
 mm/damon/paddr.c                                   |   86 +-
 mm/damon/sysfs-schemes.c                           |  179 ++-
 mm/damon/sysfs.c                                   |  357 +++--
 mm/damon/tests/core-kunit.h                        |    6 +-
 mm/damon/vaddr.c                                   |    1 -
 mm/debug.c                                         |   46 +-
 mm/filemap.c                                       |   50 +-
 mm/gup.c                                           |   29 +-
 mm/hmm.c                                           |    2 +-
 mm/huge_memory.c                                   | 1019 +++++++++-----
 mm/hugetlb.c                                       |  661 +++++----
 mm/hugetlb_cgroup.c                                |   31 +-
 mm/hugetlb_cma.c                                   |  275 ++++
 mm/hugetlb_cma.h                                   |   57 +
 mm/hugetlb_vmemmap.c                               |  199 ++-
 mm/hugetlb_vmemmap.h                               |   23 +-
 mm/init-mm.c                                       |    1 +
 mm/internal.h                                      |   93 +-
 mm/ioremap.c                                       |    4 +-
 mm/khugepaged.c                                    |    8 +-
 mm/kmemleak.c                                      |   52 +-
 mm/ksm.c                                           |    9 +-
 mm/list_lru.c                                      |   15 +-
 mm/madvise.c                                       |  229 +++-
 mm/memblock.c                                      |    3 +-
 mm/memcontrol-v1.c                                 |  102 +-
 mm/memcontrol-v1.h                                 |   52 +-
 mm/memcontrol.c                                    |  294 ++--
 mm/memfd.c                                         |    4 +-
 mm/memory-failure.c                                |   27 +-
 mm/memory.c                                        |  379 +++--
 mm/memory_hotplug.c                                |    3 +-
 mm/mempolicy.c                                     |    8 +-
 mm/memremap.c                                      |   60 +-
 mm/migrate.c                                       |   11 +-
 mm/migrate_device.c                                |   18 +-
 mm/mincore.c                                       |    2 +-
 mm/mlock.c                                         |    2 +
 mm/mm_init.c                                       |  184 ++-
 mm/mmap.c                                          |   10 +-
 mm/mmu_gather.c                                    |   12 +-
 mm/mprotect.c                                      |   16 +-
 mm/mremap.c                                        | 1448 ++++++++++++++------
 mm/nommu.c                                         |   10 +-
 mm/oom_kill.c                                      |    2 +-
 mm/page-writeback.c                                |   38 +-
 mm/page_alloc.c                                    |  748 ++++++----
 mm/page_counter.c                                  |    4 +-
 mm/page_ext.c                                      |   13 +
 mm/page_idle.c                                     |    9 +-
 mm/page_io.c                                       |    6 +-
 mm/page_owner.c                                    |   86 +-
 mm/page_table_check.c                              |   44 +-
 mm/page_vma_mapped.c                               |   16 +-
 mm/percpu.c                                        |    8 +-
 mm/rmap.c                                          |  939 ++++++++-----
 mm/shmem.c                                         |  167 ++-
 mm/show_mem.c                                      |    4 +-
 mm/shrinker_debug.c                                |    8 +-
 mm/slub.c                                          |   51 +-
 mm/sparse-vmemmap.c                                |  168 ++-
 mm/sparse.c                                        |   92 +-
 mm/swap.c                                          |    2 -
 mm/swap.h                                          |    6 -
 mm/swap_cgroup.c                                   |    3 +-
 mm/swap_slots.c                                    |  295 ----
 mm/swap_state.c                                    |   91 +-
 mm/swapfile.c                                      |  432 +++---
 mm/truncate.c                                      |   53 +-
 mm/userfaultfd.c                                   |   38 +-
 mm/vma.c                                           |  352 ++---
 mm/vma.h                                           |  101 +-
 mm/vmalloc.c                                       |   20 +-
 mm/vmscan.c                                        |  252 ++--
 mm/vmstat.c                                        |    5 +
 mm/z3fold.c                                        | 1447 -------------------
 mm/zbud.c                                          |  455 ------
 mm/zpool.c                                         |   97 +-
 mm/zsmalloc.c                                      |  498 +++----
 mm/zswap.c                                         |  164 ++-
 net/mpls/internal.h                                |    4 +-
 samples/damon/Kconfig                              |    4 +-
 samples/kmemleak/kmemleak-test.c                   |   36 +-
 tools/include/linux/refcount.h                     |    5 +
 tools/testing/radix-tree/Makefile                  |    1 +
 tools/testing/selftests/mm/.gitignore              |    2 +-
 tools/testing/selftests/mm/Makefile                |    2 +-
 tools/testing/selftests/mm/cow.c                   |    2 +-
 .../mm/{guard-pages.c => guard-regions.c}          |  968 +++++++++++--
 tools/testing/selftests/mm/gup_longterm.c          |   41 +-
 tools/testing/selftests/mm/map_populate.c          |    5 +
 tools/testing/selftests/mm/mlock-random-test.c     |    4 +-
 tools/testing/selftests/mm/mlock2.h                |    8 +-
 tools/testing/selftests/mm/run_vmtests.sh          |   95 +-
 tools/testing/selftests/mm/split_huge_page_test.c  |  106 +-
 tools/testing/selftests/mm/thuge-gen.c             |    4 +-
 tools/testing/selftests/mm/uffd-common.c           |   12 +-
 tools/testing/selftests/mm/uffd-common.h           |    2 +-
 tools/testing/selftests/mm/uffd-stress.c           |   42 +-
 tools/testing/selftests/mm/uffd-unit-tests.c       |    7 +-
 tools/testing/selftests/mm/uffd-wp-mremap.c        |    5 +-
 tools/testing/selftests/mm/vm_util.h               |   19 +
 tools/testing/vma/linux/atomic.h                   |    5 +
 tools/testing/vma/vma.c                            |  105 +-
 tools/testing/vma/vma_internal.h                   |  131 +-
 353 files changed, 12718 insertions(+), 8829 deletions(-)
 delete mode 100644 Documentation/mm/z3fold.rst
 delete mode 100644 Documentation/translations/zh_CN/mm/z3fold.rst
 delete mode 100644 arch/x86/include/asm/numa_32.h
 delete mode 100644 arch/x86/mm/highmem_32.c
 delete mode 100644 include/linux/swap_slots.h
 create mode 100644 mm/hugetlb_cma.c
 create mode 100644 mm/hugetlb_cma.h
 delete mode 100644 mm/swap_slots.c
 delete mode 100644 mm/z3fold.c
 delete mode 100644 mm/zbud.c
 rename tools/testing/selftests/mm/{guard-pages.c => guard-regions.c} (56%)

