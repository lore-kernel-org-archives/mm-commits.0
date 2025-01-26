Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92B9825A641;
	Sun, 26 Jan 2025 23:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737932733; cv=none; b=CaSbt2/eB3+ODxMg8C8vAP3x4aNRWRPYoRc5ibeeDs08GWbIX1dsWE45NwAjtL4COrbOoIV0/yO2euvqT88umYQHHP8Al4tWjxoEMeq4KdDu5WIJO8hUP3j0tNyLW3/B078CKK7AoSRsY8+3ZS/l4FWupdiqNTdq1ITt1A1VUkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737932733; c=relaxed/simple;
	bh=NFkxNw4/N2Edp7HnB6agrftUMTnVZuw4QLkDlDu7PHE=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=HK/btpPH49LKo2pWQvoWb2W1B5FoFOd3EIyephBLW1Oo3SSCvR6L3LFzYRwiby+gHmykYCWqr/N6+pu5E+69xHSD51z7JtYT6CwgHGFuZKtE1tlfY3vYnYwVlgMB+i8amaHBzvZWMNqZXl/OtZ9y7FAczfufHGbz6bZR8vq9luA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2e48skI7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2e48skI7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD225C4CED3;
	Sun, 26 Jan 2025 23:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737932733;
	bh=NFkxNw4/N2Edp7HnB6agrftUMTnVZuw4QLkDlDu7PHE=;
	h=Date:From:To:Cc:Subject:From;
	b=2e48skI7Ac4bocRsNx/VszLh1hgEXEDwyUl0I3YI9kmioDSyXUa0LPfPrM7HDgIcN
	 fTIC7X3ix0lAPmX7tkleuZDN5EZVL93lV4HVyJk3LIIloG9GpWBxonNT3GG73mfwGd
	 DA/T2UVSgSql9u8aCxtYT6qhwRQrbicZDZuPf0pw=
Date: Sun, 26 Jan 2025 15:05:32 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 mm-commits@vger.kernel.org
Subject: [GIT PULL] MM udpates for 6.14-rc1, take 2
Message-Id: <20250126150532.2b75f7ac330cdde40d13d788@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Linus, please merge the MM updates for the 6.14 development cycle,
thanks.

Conflicts which I am seeing at this time, along with their linux-next
resolutions are:

include/linux/seqlock.h: trivial kerneldoc fixup

kernel/rcu/tree.c, vs slab tree:
https://lkml.kernel.org/r/20241216152721.15c5864d@canb.auug.org.au


Forthcoming build issues and their linux-next resolutions are:

io_uring/memmap.c, vs block tree:
https://lkml.kernel.org/r/20250110124406.17190e3a@canb.auug.org.au


Forthcoming conflicts are:

kernel/rcu/tree.c, vs rcu tree:
https://lkml.kernel.org/r/20241220133738.1beae531@canb.auug.org.au

arch/arm64/mm/pageattr.c vs arm64 tree:
https://lkml.kernel.org/r/20241024103709.082a6950@canb.auug.org.au

include/linux/mm.h vs arm64 tree:
https://lkml.kernel.org/r/20241028111058.4419a9ed@canb.auug.org.au

arch/s390/include/asm/set_memory.h, arch/s390/mm/pageattr.c vs s390 tree:
https://lkml.kernel.org/r/20241028111606.5c009055@canb.auug.org.au

arch/s390/mm/pageattr.c, vs s390 tree:
https://lkml.kernel.org/r/20241114101639.282d82a8@canb.auug.org.au

lib/Makefile, vs asm-generic tree:
https://lkml.kernel.org/r/20241029095525.0fba9d23@canb.auug.org.au

drivers/block/zram/zram_drv.c, vs block tree:
https://lkml.kernel.org/r/20241111135241.1640f547@canb.auug.org.au

include/linux/mm.h
include/linux/mm_types.h
kernel/fork.c
tools/testing/vma/vma_internal.h, vs tip tree:
https://lkml.kernel.org/r/20241209132446.77fcb14b@canb.auug.org.au

(hopefully not an issue - both trees were carrying the same patches)

scripts/checkpatch.pl, vs jc_docs tree:
https://lkml.kernel.org/r/20250106095826.140c01cb@canb.auug.org.au

drivers/gpu/drm/i915/display/intel_display_driver.c, vs drm-intel tree:
https://lkml.kernel.org/r/20250106130348.73a5fae6@canb.auug.org.au

arch/powerpc/Kconfig, vs powerpc tree:
https://lkml.kernel.org/r/20250109104611.2491cc3b@canb.auug.org.au



The following changes since commit cbc5dde0a461240046e8a41c43d7c3b76d5db952:

  fs/proc: fix softlockup in __read_vmcore (part 2) (2025-01-12 19:03:38 -0=
800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2025=
-01-26-14-59

for you to fetch changes up to d1366e74342e75555af2648a2964deb2d5c92200:

  mm/compaction: fix UBSAN shift-out-of-bounds warning (2025-01-25 20:42:30=
 -0800)

----------------------------------------------------------------
The various patchsets are summarized below.  Plus of course many
indivudual patches which are described in their changelogs.

- "Allocate and free frozen pages" from Matthew Wilcox reorganizes the
  page allocator so we end up with the ability to allocate and free
  zero-refcount pages.  So that callers (ie, slab) can avoid a refcount
  inc & dec.

- "Support large folios for tmpfs" from Baolin Wang teaches tmpfs to use
  large folios other than PMD-sized ones.

- "Fix mm/rodata_test" from Petr Tesarik performs some maintenance and
  fixes for this small built-in kernel selftest.

- "mas_anode_descend() related cleanup" from Wei Yang tidies up part of
  the mapletree code.

- "mm: fix format issues and param types" from Keren Sun implements a
  few minor code cleanups.

- "simplify split calculation" from Wei Yang provides a few fixes and a
  test for the mapletree code.

- "mm/vma: make more mmap logic userland testable" from Lorenzo Stoakes
  continues the work of moving vma-related code into the (relatively) new
  mm/vma.c.

- "mm/page_alloc: gfp flags cleanups for alloc_contig_*()" from David
  Hildenbrand cleans up and rationalizes handling of gfp flags in the page
  allocator.

- "readahead: Reintroduce fix for improper RA window sizing" from Jan
  Kara is a second attempt at fixing a readahead window sizing issue.  It
  should reduce the amount of unnecessary reading.

- "synchronously scan and reclaim empty user PTE pages" from Qi Zheng
  addresses an issue where "huge" amounts of pte pagetables are
  accumulated
  (https://lore.kernel.org/lkml/cover.1718267194.git.zhengqi.arch@bytedance=
.com/).
  Qi's series addresses this windup by synchronously freeing PTE memory
  within the context of madvise(MADV_DONTNEED).

- "selftest/mm: Remove warnings found by adding compiler flags" from
  Muhammad Usama Anjum fixes some build warnings in the selftests code
  when optional compiler warnings are enabled.

- "mm: don't use __GFP_HARDWALL when migrating remote pages" from David
  Hildenbrand tightens the allocator's observance of __GFP_HARDWALL.

- "pkeys kselftests improvements" from Kevin Brodsky implements various
  fixes and cleanups in the MM selftests code, mainly pertaining to the
  pkeys tests.

- "mm/damon: add sample modules" from SeongJae Park enhances DAMON to
  estimate application working set size.

- "memcg/hugetlb: Rework memcg hugetlb charging" from Joshua Hahn
  provides some cleanups to memcg's hugetlb charging logic.

- "mm/swap_cgroup: remove global swap cgroup lock" from Kairui Song
  removes the global swap cgroup lock.  A speedup of 10% for a tmpfs-based
  kernel build was demonstrated.

- "zram: split page type read/write handling" from Sergey Senozhatsky
  has several fixes and cleaups for zram in the area of zram_write_page().
  A watchdog softlockup warning was eliminated.

- "move pagetable_*_dtor() to __tlb_remove_table()" from Kevin Brodsky
  cleans up the pagetable destructor implementations.  A rare
  use-after-free race is fixed.

- "mm/debug: introduce and use VM_WARN_ON_VMG()" from Lorenzo Stoakes
  simplifies and cleans up the debugging code in the VMA merging logic.

- "Account page tables at all levels" from Kevin Brodsky cleans up and
  regularizes the pagetable ctor/dtor handling.  This results in
  improvements in accounting accuracy.

- "mm/damon: replace most damon_callback usages in sysfs with new core
  functions" from SeongJae Park cleans up and generalizes DAMON's sysfs
  file interface logic.

- "mm/damon: enable page level properties based monitoring" from
  SeongJae Park increases the amount of information which is presented in
  response to DAMOS actions.

- "mm/damon: remove DAMON debugfs interface" from SeongJae Park removes
  DAMON's long-deprecated debugfs interfaces.  Thus the migration to sysfs
  is completed.

- "mm/hugetlb: Refactor hugetlb allocation resv accounting" from Peter
  Xu cleans up and generalizes the hugetlb reservation accounting.

- "mm: alloc_pages_bulk: small API refactor" from Luiz Capitulino
  removes a never-used feature of the alloc_pages_bulk() interface.

- "mm/damon: extend DAMOS filters for inclusion" from SeongJae Park
  extends DAMOS filters to support not only exclusion (rejecting), but
  also inclusion (allowing) behavior.

- "Add zpdesc memory descriptor for zswap.zpool" from Alex Shi
  "introduces a new memory descriptor for zswap.zpool that currently
  overlaps with struct page for now.  This is part of the effort to reduce
  the size of struct page and to enable dynamic allocation of memory
  descriptors."

- "mm, swap: rework of swap allocator locks" from Kairui Song redoes and
  simplifies the swap allocator locking.  A speedup of 400% was
  demonstrated for one workload.  As was a 35% reduction for kernel build
  time with swap-on-zram.

- "mm: update mips to use do_mmap(), make mmap_region() internal" from
  Lorenzo Stoakes reworks MIPS's use of mmap_region() so that
  mmap_region() can be made MM-internal.

- "mm/mglru: performance optimizations" from Yu Zhao fixes a few MGLRU
  regressions and otherwise improves MGLRU performance.

- "Docs/mm/damon: add tuning guide and misc updates" from SeongJae Park
  updates DAMON documentation.

- "Cleanup for memfd_create()" from Isaac Manjarres does that thing.

- "mm: hugetlb+THP folio and migration cleanups" from David Hildenbrand
  provides various cleanups in the areas of hugetlb folios, THP folios and
  migration.

- "Uncached buffered IO" from Jens Axboe implements the new
  RWF_DONTCACHE flag which provides synchronous dropbehind for pagecache
  reading and writing.  To permite userspace to address issues with
  massive buildup of useless pagecache when reading/writing fast devices.

- "selftests/mm: virtual_address_range: Reduce memory" from Thomas
  Wei=DFschuh fixes and optimizes some of the MM selftests.

----------------------------------------------------------------
Alex Shi (7):
      mm/zsmalloc: add zpdesc memory descriptor for zswap.zpool
      mm/zsmalloc: use zpdesc in trylock_zspage()/lock_zspage()
      mm/zsmalloc: convert create_page_chain() and its users to use zpdesc
      mm/zsmalloc: convert reset_page to reset_zpdesc
      mm/zsmalloc: convert SetZsPageMovable and remove unused funcs
      mm/zsmalloc: convert get/set_first_obj_offset() to take zpdesc
      mm/zsmalloc: introduce __zpdesc_clear/set_zsmalloc()

Alexander Gordeev (1):
      s390/mm: add missing ctor/dtor on page table upgrade

Alice Ryhl (2):
      mm/zswap: add LRU_STOP to comment about dropping the lru lock
      list_lru: expand list_lru_add() docs with info about sublists

Andrew Morton (3):
      mm/damon/tests/vaddr-kunit.h: reduce stack consumption
      mm/huge_memory.c: rename shadowed local
      Documentation/filesystems/proc.rst: fix possessive form of "process"

Baolin Wang (6):
      mm: factor out the order calculation into a new helper
      mm: shmem: change shmem_huge_global_enabled() to return huge order bi=
tmap
      mm: shmem: add large folio support for tmpfs
      mm: shmem: add a kernel command line to change the default huge polic=
y for tmpfs
      docs: tmpfs: drop 'fadvise()' from the documentation
      mm: shmem: skip swapcache for swapin of synchronous swap device

Bruno Faccini (1):
      mm/fake-numa: allow later numa node hotplug

Byungchul Park (1):
      mm: separate move/undo parts from migrate_pages_batch()

Chen Ridong (1):
      memcg: fix soft lockup in the OOM process

Chin Yik Ming (1):
      mm/memory: fix a comment typo in lock_mm_and_find_vma()

Christoph Hellwig (1):
      mm: unexport apply_to_existing_page_range

David Hildenbrand (17):
      docs: tmpfs: update the large folios policy for tmpfs and shmem
      mm/memory_hotplug: move debug_pagealloc_map_pages() into online_pages=
_range()
      mm/page_isolation: don't pass gfp flags to isolate_single_pageblock()
      mm/page_isolation: don't pass gfp flags to start_isolate_page_range()
      mm/page_alloc: make __alloc_contig_migrate_range() static
      mm/page_alloc: sort out the alloc_contig_range() gfp flags mess
      mm/page_alloc: forward the gfp flags from alloc_contig_range() to pos=
t_alloc_hook()
      powernv/memtrace: use __GFP_ZERO with alloc_contig_pages()
      mm/hugetlb: don't map folios writable without VM_WRITE when copying d=
uring fork()
      mm/page_alloc: don't use __GFP_HARDWALL when migrating pages via allo=
c_contig*()
      mm/memory_hotplug: don't use __GFP_HARDWALL when migrating pages via =
memory offlining
      mm/huge_memory: convert has_hwpoisoned into a pure folio flag
      mm/hugetlb: rename isolate_hugetlb() to folio_isolate_hugetlb()
      mm/migrate: don't call folio_putback_active_hugetlb() on dst hugetlb =
folio
      mm/hugetlb: rename folio_putback_active_hugetlb() to folio_putback_hu=
getlb()
      mm/hugetlb-cgroup: convert hugetlb_cgroup_css_offline() to work on fo=
lios
      mm/hugetlb: use folio->lru int demote_free_hugetlb_folios()

Donet Tom (2):
      mm: migrate: remove unused argument vma from migrate_misplaced_folio()
      selftests/mm: add new test cases to the migration test

Dr. David Alan Gilbert (1):
      filemap: remove unused folio_add_wait_queue

Gregory Price (1):
      mm: add build-time option for hotplug memory default online type

Guillaume Morin (1):
      mm/hugetlb: support FOLL_FORCE|FOLL_WRITE

Guo Weikang (4):
      mm/shmem: refactor to reuse vfs_parse_monolithic_sep for option parsi=
ng
      mm/early_ioremap: add null pointer checks to prevent NULL-pointer der=
eference
      mm/memmap: prevent double scanning of memmap by kmemleak
      mm/memblock: add memblock_alloc_or_panic interface

Hao Ge (1):
      selftests/mm/cow: modify the incorrect checking parameters

Honggyu Kim (1):
      mm/damon/core: remove duplicate list_empty quota->goals check

Hyeonggon Yoo (12):
      mm/migrate: remove slab checks in isolate_movable_page()
      mm/zsmalloc: convert __zs_map_object/__zs_unmap_object to use zpdesc
      mm/zsmalloc: add and use pfn/zpdesc seeking funcs
      mm/zsmalloc: convert obj_malloc() to use zpdesc
      mm/zsmalloc: convert obj_allocated() and related helpers to use zpdesc
      mm/zsmalloc: convert init_zspage() to use zpdesc
      mm/zsmalloc: convert obj_to_page() and zs_free() to use zpdesc
      mm/zsmalloc: add two helpers for zs_page_migrate() and make it use zp=
desc
      mm/zsmalloc: convert __free_zspage() to use zpdesc
      mm/zsmalloc: convert location_to_obj() to take zpdesc
      mm/zsmalloc: convert migrate_zspage() to use zpdesc
      mm/zsmalloc: convert get_zspage() to take zpdesc

Isaac J. Manjarres (2):
      mm/memfd: refactor and cleanup the logic in memfd_create()
      mm/memfd: use strncpy_from_user() to read memfd name

Jan Kara (2):
      readahead: don't shorten readahead window in read_pages()
      readahead: properly shorten readahead when falling back to do_page_ca=
che_ra()

Jeff Xu (2):
      selftest/mm: remove seal_elf
      mseal: remove can_do_mseal()

Jens Axboe (12):
      mm/filemap: change filemap_create_folio() to take a struct kiocb
      mm/filemap: use page_cache_sync_ra() to kick off read-ahead
      mm/readahead: add folio allocation helper
      mm: add PG_dropbehind folio flag
      mm/readahead: add readahead_control->dropbehind member
      mm/truncate: add folio_unmap_invalidate() helper
      fs: add RWF_DONTCACHE iocb and FOP_DONTCACHE file_operations flag
      mm/filemap: add read support for RWF_DONTCACHE
      mm/filemap: drop streaming/uncached pages when writeback completes
      mm/filemap: add filemap_fdatawrite_range_kick() helper
      mm: call filemap_fdatawrite_range_kick() after IOCB_DONTCACHE issue
      mm: add FGP_DONTCACHE folio creation flag

Jiale Yang (1):
      mm: change type of cma_area_count to unsigned int

Jim Zhao (1):
      mm/page-writeback: consolidate wb_thresh bumping logic into __wb_calc=
_thresh

Jinliang Zheng (1):
      mm: fix outdated incorrect code comments for handle_mm_fault()

Joshua Hahn (4):
      memcg/hugetlb: introduce memcg_accounts_hugetlb
      memcg/hugetlb: introduce mem_cgroup_charge_hugetlb
      memcg/hugetlb: remove memcg hugetlb try-commit-cancel protocol
      mm/damon/paddr: improve readability of damon_pa_stat

Kairui Song (17):
      mm, memcontrol: avoid duplicated memcg enable check
      mm/swap_cgroup: remove swap_cgroup_cmpxchg
      mm/swap_cgroup: remove global swap cgroup lock
      mm/swap_cgroup: decouple swap cgroup recording and clearing
      mm, swap: minor clean up for swap entry allocation
      mm, swap: fold swap_info_get_cont in the only caller
      mm, swap: remove old allocation path for HDD
      mm, swap: use cluster lock for HDD
      mm, swap: clean up device availability check
      mm, swap: clean up plist removal and adding
      mm, swap: hold a reference during scan and cleanup flag usage
      mm, swap: use an enum to define all cluster flags and wrap flags chan=
ges
      mm, swap: reduce contention on device lock
      mm, swap: simplify percpu cluster updating
      mm, swap: introduce a helper for retrieving cluster from offset
      mm, swap: use a global swap cluster for non-rotation devices
      mm, swap_slots: remove slot cache for freeing path

Keren Sun (3):
      mm: prefer 'unsigned int' to bare use of 'unsigned'
      mm: remove unnecessary whitespace before a quoted newline
      mm: remove the non-useful else after a break in a if statement

Kevin Brodsky (22):
      selftests/mm: fix condition in uffd_move_test_common()
      selftests/mm: fix -Wmaybe-uninitialized warnings
      selftests/mm: fix strncpy() length
      selftests/mm: fix -Warray-bounds warnings in pkey_sighandler_tests
      selftests/mm: build with -O2
      selftests/mm: remove unused pkey helpers
      selftests/mm: define types using typedef in pkey-helpers.h
      selftests/mm: ensure pkey-*.h define inline functions only
      selftests/mm: remove empty pkey helper definition
      selftests/mm: ensure non-global pkey symbols are marked static
      selftests/mm: use sys_pkey helpers consistently
      selftests/mm: rename pkey register macro
      selftests/mm: skip pkey_sighandler_tests if support is missing
      selftests/mm: remove X permission from sigaltstack mapping
      riscv: mm: skip pgtable level check in {pud,p4d}_alloc_one
      asm-generic: pgalloc: provide generic p4d_{alloc_one,free}
      mm: move common part of pagetable_*_ctor to helper
      parisc: mm: ensure pagetable_pmd_[cd]tor are called
      m68k: mm: add calls to pagetable_pmd_[cd]tor
      ARM: mm: rename PGD helpers
      asm-generic: pgalloc: provide generic __pgd_{alloc,free}
      mm: introduce ctor/dtor at PGD level

Koichiro Den (1):
      hugetlb: prioritize surplus allocation from current node

Li Zhijian (1):
      selftests/mm: add a few missing gitignore files

Liam R. Howlett (1):
      test_maple_tree: test exhausted upper limit of mtree_alloc_cyclic()

Liu Shixin (1):
      mm/compaction: fix UBSAN shift-out-of-bounds warning

Lorenzo Stoakes (16):
      mm/vma: move brk() internals to mm/vma.c
      mm/vma: move unmapped_area() internals to mm/vma.c
      mm: abstract get_arg_page() stack expansion and mmap read lock
      mm/vma: move stack expansion logic to mm/vma.c
      mm/vma: move __vm_munmap() to mm/vma.c
      selftests/mm: add fork CoW guard page test
      mm: enforce __must_check on VMA merge and split
      mm: perform all memfd seal checks in a single place
      MAINTAINERS: update MEMORY MAPPING section
      mm: assert mmap write lock held on do_mmap(), mmap_region()
      mm: add comments to do_mmap(), mmap_region() and vm_mmap()
      tools: testing: add simple __mmap_region() userland test
      mm/debug: introduce VM_WARN_ON_VMG() to dump VMA merge state
      mm/debug: prefer VM_WARN_ON_VMG() to report VMG debug warnings
      mips: vdso: prefer do_mmap() to mmap_region()
      mm: make mmap_region() internal

Luiz Capitulino (2):
      mm: alloc_pages_bulk_noprof: drop page_list argument
      mm: alloc_pages_bulk: rename API

Maninder Singh (1):
      lib/list_debug.c: add object information in case of invalid object

Matthew Wilcox (Oracle) (16):
      mm/page_alloc: cache page_zone() result in free_unref_page()
      mm: make alloc_pages_mpol() static
      mm/page_alloc: export free_frozen_pages() instead of free_unref_page()
      mm/page_alloc: move set_page_refcounted() to callers of post_alloc_ho=
ok()
      mm/page_alloc: move set_page_refcounted() to callers of prep_new_page=
()
      mm/page_alloc: move set_page_refcounted() to callers of get_page_from=
_freelist()
      mm/page_alloc: move set_page_refcounted() to callers of __alloc_pages=
_cpuset_fallback()
      mm/page_alloc: move set_page_refcounted() to callers of __alloc_pages=
_may_oom()
      mm/page_alloc: move set_page_refcounted() to callers of __alloc_pages=
_direct_compact()
      mm/page_alloc: move set_page_refcounted() to callers of __alloc_pages=
_direct_reclaim()
      mm/page_alloc: move set_page_refcounted() to callers of __alloc_pages=
_slowpath()
      mm/page_alloc: move set_page_refcounted() to end of __alloc_pages()
      mm/page_alloc: add __alloc_frozen_pages()
      mm/mempolicy: add alloc_frozen_pages()
      slab: allocate frozen pages
      mm: remove PageTransTail()

Muhammad Usama Anjum (4):
      selftests/mm: thp_settings: remove const from return type
      selftests/mm: pagemap_ioctl: Fix types mismatches shown by compiler o=
ptions
      selftests/mm: mseal_test: remove unused variables
      selftests/mm: mremap_test: Remove unused variable and type mismatches

Nicholas Piggin (1):
      lazy tlb: fix hotplug exit race with MMU_LAZY_TLB_SHOOTDOWN

Nihar Chaithanya (1):
      mm:kasan: fix sparse warnings: Should it be static?

Peter Xu (7):
      mm/hugetlb: fix avoid_reserve to allow taking folio from subpool
      mm/hugetlb: stop using avoid_reserve flag in fork()
      mm/hugetlb: rename avoid_reserve to cow_from_owner
      mm/hugetlb: clean up map/global resv accounting when allocate
      mm/hugetlb: simplify vma_has_reserves()
      mm/hugetlb: drop vma_has_reserves()
      mm/hugetlb: unify restore reserve accounting for new allocations

Peter Zijlstra (1):
      kasan: make kasan_record_aux_stack_noalloc() the default behaviour

Petr Tesarik (2):
      mm/rodata_test: use READ_ONCE() to read const variable
      mm/rodata_test: verify test data is unchanged, rather than non-zero

Pintu Kumar (1):
      mm/hugetlb_cgroup: avoid useless return in void function

Qi Zheng (26):
      mm: pgtable: make ptep_clear() non-atomic
      mm: khugepaged: recheck pmd state in retract_page_tables()
      mm: userfaultfd: recheck dst_pmd entry in move_pages_pte()
      mm: introduce zap_nonpresent_ptes()
      mm: introduce do_zap_pte_range()
      mm: skip over all consecutive none ptes in do_zap_pte_range()
      mm: zap_install_uffd_wp_if_needed: return whether uffd-wp pte has bee=
n re-installed
      mm: do_zap_pte_range: return any_skipped information to the caller
      mm: make zap_pte_range() handle full within-PMD range
      mm: pgtable: reclaim empty PTE page in madvise(MADV_DONTNEED)
      x86: mm: free page table pages by RCU instead of semi RCU
      x86: select ARCH_SUPPORTS_PT_RECLAIM if X86_64
      mm: pgtable: add statistics for P4D level page table
      arm64: pgtable: use mmu gather to free p4d level page table
      s390: pgtable: add statistics for PUD and P4D level page table
      mm: pgtable: introduce pagetable_dtor()
      arm: pgtable: move pagetable_dtor() to __tlb_remove_table()
      arm64: pgtable: move pagetable_dtor() to __tlb_remove_table()
      riscv: pgtable: move pagetable_dtor() to __tlb_remove_table()
      x86: pgtable: convert __tlb_remove_table() to use struct ptdesc
      x86: pgtable: move pagetable_dtor() to __tlb_remove_table()
      s390: pgtable: consolidate PxD and PTE TLB free paths
      mm: pgtable: introduce generic __tlb_remove_table()
      mm: pgtable: completely move pagetable_dtor() to generic tlb_remove_t=
able()
      mm: pgtable: move __tlb_remove_table_one() in x86 to generic file
      mm: pgtable: introduce generic pagetable_dtor_free()

Randy Dunlap (1):
      kasan: use correct kernel-doc format

Rik van Riel (1):
      mm: remove unnecessary calls to lru_add_drain

Roman Gushchin (2):
      mm: swap_cgroup: allocate swap_cgroup map using vcalloc()
      mm: swap_cgroup: get rid of __lookup_swap_cgroup()

Ryan Roberts (1):
      selftests/mm: introduce uffd-wp-mremap regression test

SeongJae Park (54):
      samples: add a skeleton of a sample DAMON module for working set size=
 estimation
      samples/damon/wsse: start and stop DAMON as the user requests
      samples/damon/wsse: implement working set size estimation and logging
      samples/damon: introduce a skeleton of a smaple DAMON module for proa=
ctive reclamation
      samples/damon/prcl: implement schemes setup
      mm/damon/sysfs-schemes: remove unnecessary schemes existence check in=
 damon_sysfs_schemes_clear_regions()
      mm/damon/sysfs: handle clear_schemes_tried_regions from DAMON sysfs c=
ontext
      mm/damon/core: introduce damon_call()
      mm/damon/sysfs: use damon_call() for update_schemes_stats
      mm/damon/sysfs: use damon_call() for commit_schemes_quota_goals
      mm/damon/sysfs: use damon_call() for update_schemes_effective_quotas
      mm/damon/core: implement damos_walk()
      Docs/mm/damon/design: document DAMOS regions walking
      mm/damon/sysfs: use damos_walk() for update_schemes_tried_{bytes,regi=
ons}
      mm/damon/sysfs: remove unused code for schemes tried regions update
      mm/damon: clarify trying vs applying on damos_stat kernel-doc comment
      Docs/mm/damon/design: add 'statistics' section
      Docs/admin-guide/mm/damon/usage: link damos stat design doc
      mm/damon: ask apply_scheme() to report filter-passed region-internal =
bytes
      mm/damon/paddr: report filter-passed bytes back for normal actions
      mm/damon/paddr: report filter-passed bytes back for DAMOS_STAT action
      mm/damon/core: implement per-scheme ops-handled filter-passed bytes s=
tat
      mm/damon/syfs-schemes: implement per-scheme filter-passed bytes stat
      Docs/mm/damon/design: document sz_ops_filter_passed
      Docs/admin-guide/mm/damon/usage: document sz_ops_filter_passed
      Docs/ABI/damon: document per-scheme filter-passed bytes stat file
      mm/damon/core: pass per-region filter-passed bytes to damos_walk_cont=
rol->walk_fn()
      mm/damon/sysfs-schemes: expose per-region filter-passed bytes
      Docs/mm/damon/design: document per-region sz_filter_passed stat
      Docs/admin-guide/mm/damon/usage: document sz_filtered_out of scheme t=
ried region directories
      Docs/ABI/damon: document per-region DAMOS filter-passed bytes stat fi=
le
      Docs/translations/*/admin-guide/mm/damon/usage: remove DAMON debugfs =
interface documentation
      Docs/admin-guide/mm/damon/usage: remove DAMON debugfs interface docum=
entation
      Docs/mm/damon/design: update for removal of DAMON debugfs interface
      selftests/damon/config: remove configs for DAMON debugfs interface se=
lftests
      selftests/damon: remove tests for DAMON debugfs interface
      kunit: configs: remove configs for DAMON debugfs interface tests
      mm/damon: remove DAMON debugfs interface kunit tests
      mm/damon: remove DAMON debugfs interface
      mm/damon: fixup damos_filter kernel-doc
      mm/damon/core: add damos_filter->allow field
      mm/damon/core: support damos_filter->allow
      mm/damon/paddr: support damos_filter->allow
      mm/damon: add 'allow' argument to damos_new_filter()
      mm/damon/sysfs-schemes: add a file for setting damos_filter->allow
      Docs/mm/damon/design: document allow/reject DAMOS filter behaviors
      Docs/ABI/damon: document DAMOS filter allow sysfs file
      Docs/admin-guide/mm/damon/usage: omit DAMOS filter details in favor o=
f design doc
      Docs/admin-guide/mm/damon/usage: document DAMOS filter 'allow' sysfs =
file
      Docs/mm/damon/design: add monitoring parameters tuning guide
      Docs/mm/damon: add an example monitoring intervals tuning
      Docs/admin-guide/mm/damon/usage: fix and add missing DAMOS filter sys=
fs files on files hierarchy
      Docs/admin-guide/mm/damon/start: update snapshot example
      mm/damon: explain "effective quota" on kernel-doc comment

Sergey Senozhatsky (8):
      zram: free slot memory early during write
      zram: remove entry element member
      zram: factor out ZRAM_SAME write
      zram: factor out ZRAM_HUGE write
      zram: factor out different page types read
      zram: use zram_read_from_zspool() in writeback
      zram: cond_resched() in writeback loop
      zram: remove zcomp_stream_put() from write_incompressible_page()

Shakeel Butt (1):
      mm: mmap_lock: optimize mmap_lock tracepoints

Suren Baghdasaryan (6):
      seqlock: add raw_seqcount_try_begin
      mm: convert mm_lock_seq to a proper seqcount
      mm: introduce mmap_lock_speculate_{try_begin|retry}
      alloc_tag: avoid current->alloc_tag manipulations when profiling is d=
isabled
      seqlock: add missing parameter documentation for raw_seqcount_try_beg=
in()
      tools: add VM_WARN_ON_VMG definition

Thomas Wei=DFschuh (5):
      mm/page_idle: constify 'struct bin_attribute'
      selftests/mm: virtual_address_range: mmap() without PROT_WRITE
      selftests/mm: virtual_address_range: unmap chunks after validation
      selftests/mm: vm_util: split up /proc/self/smaps parsing
      selftests/mm: virtual_address_range: avoid reading from VM_IO mappings

Thorsten Blum (4):
      kasan: hw_tags: Use str_on_off() helper in kasan_init_hw_tags()
      mm/kfence: use str_write_read() helper in get_access_type()
      mm/damon/core: use str_high_low() helper in damos_wmark_wait_us()
      kasan: sw_tags: use str_on_off() helper in kasan_init_sw_tags()

Usama Arif (1):
      mm/damon/paddr: increment pa_stat damon address range by folio size

Wei Yang (7):
      maple_tree: use mas_next_slot() directly
      maple_tree: index has been checked to be smaller than pivot
      maple_tree: not possible to be a root node after loop
      maple_tree: we don't set offset to MAPLE_NODE_SLOTS on error
      maple_tree: simplify split calculation
      maple_tree: add a test check deficient node
      maple_tree: only root node could be deficient

Wenchao Hao (1):
      mm: add per-order mTHP swap-in fallback/fallback_charge counters

Yu Zhao (7):
      mm/mglru: clean up workingset
      mm/mglru: optimize deactivation
      mm/mglru: rework aging feedback
      mm/mglru: rework type selection
      mm/mglru: rework refault detection
      mm/mglru: rework workingset protection
      mm/mglru: fix PTE-mapped large folios

Yuntao Wang (1):
      mm/page_alloc: remove the incorrect and misleading comment

Zi Yan (2):
      selftests/mm: use selftests framework to print test result
      selftests/mm: add tests for splitting pmd THPs to all lower orders

gaoxiang17 (1):
      mm/page_alloc: add some detailed comments in can_steal_fallback

guanjing (1):
      selftests: mm: fix conversion specifiers in transact_test()

liuye (2):
      selftests/memfd/memfd_test: fix possible NULL pointer dereference
      selftests/mm/mkdirty: fix memory leak in test_uffdio_copy()

xu xin (1):
      ksm: add ksm involvement information for each process

yangge (1):
      mm: replace free hugepage folios after migration

 Documentation/ABI/testing/sysfs-kernel-mm-damon    |   26 +-
 Documentation/admin-guide/kernel-parameters.txt    |   11 +-
 Documentation/admin-guide/mm/damon/start.rst       |   67 +-
 Documentation/admin-guide/mm/damon/usage.rst       |  392 +-----
 Documentation/admin-guide/mm/memory-hotplug.rst    |    4 +-
 Documentation/admin-guide/mm/transhuge.rst         |   82 +-
 Documentation/filesystems/proc.rst                 |   88 +-
 Documentation/mm/damon/design.rst                  |  167 ++-
 .../damon/monitoring_intervals_tuning_example.rst  |  247 ++++
 Documentation/mm/process_addrs.rst                 |    4 +
 Documentation/mm/split_page_table_lock.rst         |    4 +-
 .../zh_CN/admin-guide/mm/damon/usage.rst           |  248 +---
 .../zh_TW/admin-guide/mm/damon/usage.rst           |  248 +---
 MAINTAINERS                                        |   24 +-
 arch/alpha/kernel/core_cia.c                       |    5 +-
 arch/alpha/kernel/core_marvel.c                    |   10 +-
 arch/alpha/kernel/pci.c                            |   13 +-
 arch/alpha/kernel/pci_iommu.c                      |   10 +-
 arch/alpha/mm/init.c                               |    2 +-
 arch/arc/include/asm/pgalloc.h                     |    9 +-
 arch/arm/include/asm/tlb.h                         |   10 -
 arch/arm/kernel/setup.c                            |   10 +-
 arch/arm/mm/mmu.c                                  |   17 +-
 arch/arm/mm/nommu.c                                |    5 +-
 arch/arm/mm/pgd.c                                  |   16 +-
 arch/arm64/include/asm/pgalloc.h                   |   18 -
 arch/arm64/include/asm/tlb.h                       |   21 +-
 arch/arm64/kernel/setup.c                          |    4 +-
 arch/arm64/mm/pgd.c                                |    4 +-
 arch/csky/include/asm/pgalloc.h                    |    4 +-
 arch/hexagon/include/asm/pgalloc.h                 |    4 +-
 arch/loongarch/configs/loongson3_defconfig         |    5 +-
 arch/loongarch/include/asm/pgalloc.h               |    2 +-
 arch/loongarch/kernel/setup.c                      |    2 +-
 arch/loongarch/mm/init.c                           |   13 +-
 arch/loongarch/mm/pgtable.c                        |    7 +-
 arch/m68k/include/asm/mcf_pgalloc.h                |    7 +-
 arch/m68k/include/asm/motorola_pgalloc.h           |    6 +-
 arch/m68k/include/asm/sun3_pgalloc.h               |    4 +-
 arch/m68k/mm/init.c                                |    5 +-
 arch/m68k/mm/mcfmmu.c                              |   10 +-
 arch/m68k/mm/motorola.c                            |   26 +-
 arch/m68k/mm/sun3mmu.c                             |   10 +-
 arch/m68k/sun3/sun3dvma.c                          |    6 +-
 arch/microblaze/include/asm/pgalloc.h              |    7 +-
 arch/mips/include/asm/pgalloc.h                    |    8 +-
 arch/mips/kernel/setup.c                           |    5 +-
 arch/mips/kernel/vdso.c                            |   10 +-
 arch/mips/mm/pgtable.c                             |    8 +-
 arch/nios2/include/asm/pgalloc.h                   |    2 +-
 arch/nios2/mm/pgtable.c                            |    3 +-
 arch/openrisc/include/asm/pgalloc.h                |    8 +-
 arch/openrisc/mm/ioremap.c                         |    5 +-
 arch/parisc/include/asm/pgalloc.h                  |   39 +-
 arch/parisc/mm/init.c                              |   20 +-
 arch/powerpc/include/asm/tlb.h                     |    1 +
 arch/powerpc/kernel/dt_cpu_ftrs.c                  |   10 +-
 arch/powerpc/kernel/pci_32.c                       |    5 +-
 arch/powerpc/kernel/setup-common.c                 |    5 +-
 arch/powerpc/kernel/setup_32.c                     |    8 +-
 arch/powerpc/mm/book3s32/mmu.c                     |    5 +-
 arch/powerpc/mm/book3s64/mmu_context.c             |    2 +-
 arch/powerpc/mm/book3s64/pgtable.c                 |    8 +-
 arch/powerpc/mm/kasan/init_book3e_64.c             |    8 +-
 arch/powerpc/mm/kasan/init_book3s_64.c             |    2 +-
 arch/powerpc/mm/nohash/mmu_context.c               |   16 +-
 arch/powerpc/mm/pgtable-frag.c                     |    4 +-
 arch/powerpc/mm/pgtable_32.c                       |    7 +-
 arch/powerpc/platforms/powermac/nvram.c            |    5 +-
 arch/powerpc/platforms/powernv/memtrace.c          |   31 +-
 arch/powerpc/platforms/powernv/opal.c              |    5 +-
 arch/powerpc/platforms/ps3/setup.c                 |    5 +-
 arch/powerpc/sysdev/msi_bitmap.c                   |    5 +-
 arch/riscv/include/asm/pgalloc.h                   |   72 +-
 arch/riscv/include/asm/tlb.h                       |   18 -
 arch/riscv/kernel/setup.c                          |    4 +-
 arch/riscv/mm/init.c                               |    4 +-
 arch/riscv/mm/kasan_init.c                         |   14 +-
 arch/s390/include/asm/pgalloc.h                    |   40 +-
 arch/s390/include/asm/tlb.h                        |   10 +-
 arch/s390/kernel/crash_dump.c                      |    4 +-
 arch/s390/kernel/numa.c                            |    8 +-
 arch/s390/kernel/setup.c                           |   20 +-
 arch/s390/kernel/smp.c                             |   11 +-
 arch/s390/kernel/topology.c                        |   10 +-
 arch/s390/mm/pgalloc.c                             |   26 +-
 arch/sh/include/asm/pgalloc.h                      |    2 +-
 arch/sh/mm/init.c                                  |   10 +-
 arch/sparc/include/asm/tlb_64.h                    |    1 +
 arch/sparc/kernel/prom_32.c                        |    4 +-
 arch/sparc/mm/init_64.c                            |    2 +-
 arch/sparc/mm/srmmu.c                              |   16 +-
 arch/um/drivers/net_kern.c                         |    5 +-
 arch/um/drivers/vector_kern.c                      |    5 +-
 arch/um/include/asm/pgalloc.h                      |    6 +-
 arch/um/kernel/load_file.c                         |    4 +-
 arch/um/kernel/mem.c                               |    7 +-
 arch/x86/Kconfig                                   |    1 +
 arch/x86/coco/sev/core.c                           |    4 +-
 arch/x86/include/asm/pgalloc.h                     |   18 -
 arch/x86/include/asm/tlb.h                         |   15 +-
 arch/x86/kernel/acpi/boot.c                        |    5 +-
 arch/x86/kernel/apic/io_apic.c                     |    9 +-
 arch/x86/kernel/e820.c                             |    5 +-
 arch/x86/kernel/paravirt.c                         |   12 +-
 arch/x86/kernel/setup.c                            |    5 +-
 arch/x86/mm/pgtable.c                              |   57 +-
 arch/x86/platform/olpc/olpc_dt.c                   |    6 +-
 arch/x86/xen/p2m.c                                 |    8 +-
 arch/xtensa/include/asm/pgalloc.h                  |    2 +-
 arch/xtensa/mm/kasan_init.c                        |    6 +-
 drivers/acpi/acpi_extlog.c                         |   14 +
 drivers/acpi/numa/srat.c                           |   86 ++
 drivers/base/memory.c                              |    4 +-
 drivers/block/zram/zram_drv.c                      |  300 +++--
 drivers/block/zram/zram_drv.h                      |    5 +-
 drivers/clk/ti/clk.c                               |    5 +-
 drivers/macintosh/smu.c                            |    6 +-
 drivers/of/fdt.c                                   |    8 +-
 drivers/of/unittest.c                              |    8 +-
 drivers/staging/media/atomisp/pci/hmm/hmm_bo.c     |    4 +-
 drivers/vfio/pci/mlx5/cmd.c                        |   14 +-
 drivers/vfio/pci/virtio/migrate.c                  |    6 +-
 fs/btrfs/extent_io.c                               |    2 +-
 fs/btrfs/inode.c                                   |    1 -
 fs/erofs/zutil.c                                   |    4 +-
 fs/exec.c                                          |   14 +-
 fs/f2fs/data.c                                     |    1 -
 fs/hugetlbfs/inode.c                               |    7 +-
 fs/iomap/swapfile.c                                |    1 -
 fs/open.c                                          |    2 +-
 fs/proc/base.c                                     |   11 +
 fs/splice.c                                        |    2 +-
 fs/super.c                                         |    2 +-
 fs/xfs/xfs_buf.c                                   |    4 +-
 include/acpi/acpi_numa.h                           |    5 +
 include/asm-generic/early_ioremap.h                |    2 +-
 include/asm-generic/pgalloc.h                      |   83 +-
 include/asm-generic/tlb.h                          |   24 +-
 include/linux/alloc_tag.h                          |   11 +-
 include/linux/bug.h                                |   10 +-
 include/linux/damon.h                              |  112 +-
 include/linux/fs.h                                 |   21 +-
 include/linux/gfp.h                                |   30 +-
 include/linux/huge_mm.h                            |    2 +
 include/linux/hugetlb.h                            |   19 +-
 include/linux/kasan.h                              |    2 -
 include/linux/ksm.h                                |    1 +
 include/linux/list_lru.h                           |   44 +-
 include/linux/memblock.h                           |   10 +
 include/linux/memcontrol.h                         |   43 +-
 include/linux/memfd.h                              |   23 +-
 include/linux/memory_hotplug.h                     |    5 +-
 include/linux/migrate.h                            |    6 +-
 include/linux/mm.h                                 |  141 +--
 include/linux/mm_inline.h                          |   99 +-
 include/linux/mm_types.h                           |   11 +-
 include/linux/mmap_lock.h                          |   84 +-
 include/linux/mmdebug.h                            |   14 +-
 include/linux/mmzone.h                             |   99 +-
 include/linux/numa_memblks.h                       |    3 +
 include/linux/page-flags.h                         |   23 +-
 include/linux/page-isolation.h                     |    2 +-
 include/linux/pagemap.h                            |   24 +-
 include/linux/pgtable.h                            |    9 +-
 include/linux/sched/hotplug.h                      |    4 -
 include/linux/seqlock.h                            |   23 +
 include/linux/swap.h                               |   34 +-
 include/linux/swap_cgroup.h                        |   14 +-
 include/linux/swap_slots.h                         |    3 -
 include/linux/task_work.h                          |    3 -
 include/trace/events/mmap_lock.h                   |   32 +-
 include/trace/events/mmflags.h                     |    3 +-
 include/uapi/linux/fs.h                            |    6 +-
 init/main.c                                        |   18 +-
 kernel/bpf/arena.c                                 |    2 +-
 kernel/cpu.c                                       |    9 +-
 kernel/fork.c                                      |    5 +-
 kernel/irq_work.c                                  |    2 +-
 kernel/power/snapshot.c                            |    5 +-
 kernel/rcu/tiny.c                                  |    2 +-
 kernel/rcu/tree.c                                  |    4 +-
 kernel/sched/core.c                                |   24 +-
 kernel/task_work.c                                 |   14 +-
 kernel/workqueue.c                                 |    2 +-
 lib/alloc_tag.c                                    |    6 +-
 lib/cpumask.c                                      |    5 +-
 lib/kunit_iov_iter.c                               |    2 +-
 lib/list_debug.c                                   |   22 +-
 lib/maple_tree.c                                   |   73 +-
 lib/test_maple_tree.c                              |   56 +
 lib/test_vmalloc.c                                 |    2 +-
 mm/Kconfig                                         |   72 +-
 mm/Makefile                                        |    1 +
 mm/cma.h                                           |    2 +-
 mm/compaction.c                                    |    5 +-
 mm/damon/Kconfig                                   |   30 -
 mm/damon/Makefile                                  |    1 -
 mm/damon/core.c                                    |  254 +++-
 mm/damon/dbgfs.c                                   | 1148 ----------------=
--
 mm/damon/paddr.c                                   |   80 +-
 mm/damon/reclaim.c                                 |    2 +-
 mm/damon/sysfs-common.h                            |   16 +-
 mm/damon/sysfs-schemes.c                           |  271 ++---
 mm/damon/sysfs.c                                   |  188 ++-
 mm/damon/tests/.kunitconfig                        |    7 -
 mm/damon/tests/core-kunit.h                        |   14 +-
 mm/damon/tests/dbgfs-kunit.h                       |  173 ---
 mm/damon/tests/vaddr-kunit.h                       |    2 +-
 mm/damon/vaddr.c                                   |    2 +-
 mm/debug.c                                         |   71 ++
 mm/early_ioremap.c                                 |    8 +-
 mm/filemap.c                                       |  121 +-
 mm/gup.c                                           |   93 +-
 mm/huge_memory.c                                   |   19 +-
 mm/hugetlb.c                                       |  417 ++++---
 mm/hugetlb_cgroup.c                                |   18 +-
 mm/init-mm.c                                       |    2 +-
 mm/internal.h                                      |   62 +-
 mm/kasan/generic.c                                 |   18 +-
 mm/kasan/hw_tags.c                                 |    5 +-
 mm/kasan/kasan.h                                   |   18 +-
 mm/kasan/kasan_test_c.c                            |    4 +-
 mm/kasan/sw_tags.c                                 |    3 +-
 mm/kfence/kfence_test.c                            |    3 +-
 mm/kfence/report.c                                 |    3 +-
 mm/khugepaged.c                                    |   45 +-
 mm/kmsan/shadow.c                                  |    8 +-
 mm/ksm.c                                           |   19 +
 mm/madvise.c                                       |    7 +-
 mm/memblock.c                                      |   20 +
 mm/memcontrol-v1.c                                 |   16 +-
 mm/memcontrol.c                                    |  114 +-
 mm/memfd.c                                         |  139 ++-
 mm/memory.c                                        |  267 +++--
 mm/memory_hotplug.c                                |   48 +-
 mm/mempolicy.c                                     |   83 +-
 mm/migrate.c                                       |  165 +--
 mm/mm_init.c                                       |    8 +-
 mm/mmap.c                                          |  575 ++-------
 mm/mmap_lock.c                                     |   50 +-
 mm/mmu_gather.c                                    |   25 +-
 mm/mseal.c                                         |    6 +-
 mm/numa.c                                          |    8 +-
 mm/numa_emulation.c                                |   45 +-
 mm/numa_memblks.c                                  |    2 +-
 mm/oom_kill.c                                      |    8 +-
 mm/page-writeback.c                                |   53 +-
 mm/page_alloc.c                                    |  179 +--
 mm/page_frag_cache.c                               |    6 +-
 mm/page_idle.c                                     |   10 +-
 mm/page_io.c                                       |    1 -
 mm/page_isolation.c                                |   12 +-
 mm/percpu.c                                        |   70 +-
 mm/pt_reclaim.c                                    |   71 ++
 mm/readahead.c                                     |   49 +-
 mm/rodata_test.c                                   |    7 +-
 mm/shmem.c                                         |  331 +++--
 mm/slub.c                                          |   12 +-
 mm/sparse-vmemmap.c                                |    5 +-
 mm/sparse.c                                        |    5 +-
 mm/swap.c                                          |   74 +-
 mm/swap_cgroup.c                                   |  233 ++--
 mm/swap_slots.c                                    |   78 +-
 mm/swap_state.c                                    |    1 -
 mm/swapfile.c                                      | 1261 +++++++++-------=
----
 mm/truncate.c                                      |   53 +-
 mm/userfaultfd.c                                   |   55 +-
 mm/util.c                                          |   17 +
 mm/vma.c                                           |  582 ++++++++-
 mm/vma.h                                           |   48 +-
 mm/vma_internal.h                                  |    1 +
 mm/vmalloc.c                                       |    4 +-
 mm/vmscan.c                                        |  507 ++++----
 mm/workingset.c                                    |   65 +-
 mm/zpdesc.h                                        |  182 +++
 mm/zsmalloc.c                                      |  440 +++----
 mm/zswap.c                                         |    2 +-
 net/core/page_pool.c                               |    7 +-
 net/sunrpc/svc.c                                   |    4 +-
 net/sunrpc/svc_xprt.c                              |    3 +-
 samples/Kconfig                                    |    2 +
 samples/Makefile                                   |    2 +
 samples/damon/Kconfig                              |   30 +
 samples/damon/Makefile                             |    4 +
 samples/damon/prcl.c                               |  136 +++
 samples/damon/wsse.c                               |  116 ++
 tools/testing/kunit/configs/all_tests.config       |    3 -
 tools/testing/selftests/damon/.gitignore           |    3 -
 tools/testing/selftests/damon/Makefile             |   11 +-
 tools/testing/selftests/damon/config               |    1 -
 tools/testing/selftests/damon/debugfs_attrs.sh     |   17 -
 .../damon/debugfs_duplicate_context_creation.sh    |   27 -
 .../selftests/damon/debugfs_empty_targets.sh       |   21 -
 .../damon/debugfs_huge_count_read_write.sh         |   22 -
 .../selftests/damon/debugfs_rm_non_contexts.sh     |   19 -
 tools/testing/selftests/damon/debugfs_schemes.sh   |   19 -
 .../testing/selftests/damon/debugfs_target_ids.sh  |   19 -
 .../selftests/damon/debugfs_target_ids_pid_leak.c  |   68 --
 .../selftests/damon/debugfs_target_ids_pid_leak.sh |   22 -
 ...debugfs_target_ids_read_before_terminate_race.c |   80 --
 ...ebugfs_target_ids_read_before_terminate_race.sh |   14 -
 .../selftests/damon/huge_count_read_write.c        |   46 -
 tools/testing/selftests/memfd/memfd_test.c         |    2 +-
 tools/testing/selftests/mm/.gitignore              |    5 +-
 tools/testing/selftests/mm/Makefile                |   16 +-
 tools/testing/selftests/mm/config                  |    1 +
 tools/testing/selftests/mm/cow.c                   |   10 +-
 tools/testing/selftests/mm/guard-pages.c           |   83 +-
 tools/testing/selftests/mm/ksm_tests.c             |    2 +-
 tools/testing/selftests/mm/migration.c             |   99 ++
 tools/testing/selftests/mm/mkdirty.c               |    1 +
 tools/testing/selftests/mm/mremap_test.c           |   17 +-
 tools/testing/selftests/mm/mseal_test.c            |    8 +-
 tools/testing/selftests/mm/pagemap_ioctl.c         |  118 +-
 tools/testing/selftests/mm/pkey-arm64.h            |    6 +-
 tools/testing/selftests/mm/pkey-helpers.h          |   61 +-
 tools/testing/selftests/mm/pkey-powerpc.h          |    4 +-
 tools/testing/selftests/mm/pkey-x86.h              |    6 +-
 tools/testing/selftests/mm/pkey_sighandler_tests.c |   32 +-
 tools/testing/selftests/mm/pkey_util.c             |   40 +
 tools/testing/selftests/mm/protection_keys.c       |  212 ++--
 tools/testing/selftests/mm/run_vmtests.sh          |    6 +
 tools/testing/selftests/mm/seal_elf.c              |  137 ---
 tools/testing/selftests/mm/soft-dirty.c            |    2 +-
 tools/testing/selftests/mm/split_huge_page_test.c  |   46 +-
 tools/testing/selftests/mm/thp_settings.c          |    4 +-
 tools/testing/selftests/mm/thp_settings.h          |    4 +-
 tools/testing/selftests/mm/uffd-unit-tests.c       |    4 +-
 tools/testing/selftests/mm/uffd-wp-mremap.c        |  380 ++++++
 tools/testing/selftests/mm/virtual_address_range.c |   41 +-
 tools/testing/selftests/mm/vm_util.c               |   68 +-
 tools/testing/selftests/mm/vm_util.h               |    1 +
 tools/testing/selftests/mm/write_to_hugetlbfs.c    |    2 +-
 tools/testing/vma/vma.c                            |   68 +-
 tools/testing/vma/vma_internal.h                   |  224 +++-
 336 files changed, 8082 insertions(+), 7957 deletions(-)
 create mode 100644 Documentation/mm/damon/monitoring_intervals_tuning_exam=
ple.rst
 delete mode 100644 mm/damon/dbgfs.c
 delete mode 100644 mm/damon/tests/dbgfs-kunit.h
 create mode 100644 mm/pt_reclaim.c
 create mode 100644 mm/zpdesc.h
 create mode 100644 samples/damon/Kconfig
 create mode 100644 samples/damon/Makefile
 create mode 100644 samples/damon/prcl.c
 create mode 100644 samples/damon/wsse.c
 delete mode 100755 tools/testing/selftests/damon/debugfs_attrs.sh
 delete mode 100755 tools/testing/selftests/damon/debugfs_duplicate_context=
_creation.sh
 delete mode 100755 tools/testing/selftests/damon/debugfs_empty_targets.sh
 delete mode 100755 tools/testing/selftests/damon/debugfs_huge_count_read_w=
rite.sh
 delete mode 100755 tools/testing/selftests/damon/debugfs_rm_non_contexts.sh
 delete mode 100755 tools/testing/selftests/damon/debugfs_schemes.sh
 delete mode 100755 tools/testing/selftests/damon/debugfs_target_ids.sh
 delete mode 100644 tools/testing/selftests/damon/debugfs_target_ids_pid_le=
ak.c
 delete mode 100755 tools/testing/selftests/damon/debugfs_target_ids_pid_le=
ak.sh
 delete mode 100644 tools/testing/selftests/damon/debugfs_target_ids_read_b=
efore_terminate_race.c
 delete mode 100755 tools/testing/selftests/damon/debugfs_target_ids_read_b=
efore_terminate_race.sh
 delete mode 100644 tools/testing/selftests/damon/huge_count_read_write.c
 create mode 100644 tools/testing/selftests/mm/pkey_util.c
 delete mode 100644 tools/testing/selftests/mm/seal_elf.c
 create mode 100644 tools/testing/selftests/mm/uffd-wp-mremap.c

