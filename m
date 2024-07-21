Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFDD51CF96;
	Sun, 21 Jul 2024 21:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721598857; cv=none; b=ZBOsfYcyFzLF56DsbLiHqtj/zUYodkDaDxmvdpvzSdftCnVasZpzXWPLgvux4QCZilX+aNI81Kl8an3q2dmiX7TfNSfK5zCpemxWzMGH5t6+2p+UGYM7VifWOUlN3s8UIZyOxBiA+xHatlkNZdAm7HZmRdKAwlX4Irds01Gf16w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721598857; c=relaxed/simple;
	bh=4Am31Uz2vbZ6jA0DBPA1RnqMsqCiSA5tlqmjX4pUAPE=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=uNbQMB+nFWaWP/iBQDZuzi/fG1WeXeqgdteSbBpOapBjNel263KVkumht8HQUf41WMOUYOctrg1cJyh+qkxZ0gWfa3dKjBw42o27A72L/4GC+A5Bp7TF6rfvzt/Cx0KoqclffTFKLkhlmHK1kZMTqwvU30Fl039wQjOM11L9FOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OTow8lnd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OTow8lnd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B524C116B1;
	Sun, 21 Jul 2024 21:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721598856;
	bh=4Am31Uz2vbZ6jA0DBPA1RnqMsqCiSA5tlqmjX4pUAPE=;
	h=Date:From:To:Cc:Subject:From;
	b=OTow8lndvRvidyC2j/mf65tXJ4AMlEcl6rkfPTVofGB5X6zz2RK0IGQBBgX8d+ZYZ
	 I7a2F3StJAvrsXSDkjTPUNm4lR4adErIgobAXK50DNKv0NGj1WnfUuu96VwtpoW4NJ
	 n2Ka83+D/FyjzoOPlaXnO+Ukv2oq9QtQbXB5dzS8=
Date: Sun, 21 Jul 2024 14:54:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] MM updates for 6.11-rc1
Message-Id: <20240721145415.fbeb01a853962ef91334f3d1@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable


Linus, please pull this cycle's MM updates, thanks.


Conflicts which I saw during a test merge, along with their linux-next
resolutions are:

arch/powerpc/mm/nohash/Makefile, vs powerpc tree:
https://lkml.kernel.org/r/20240703094857.3f489d4f@canb.auug.org.au

fs/nfs/write.c, fs/nfs/nfstrace.h, vs fs-next tree:
https://lkml.kernel.org/r/20240715105836.6d6e6e50@canb.auug.org.au

include/linux/hid_bpf.h, vs hid tree:
https://lkml.kernel.org/r/20240709112544.190ffda4@canb.auug.org.au


Upcoming conflicts include:

include/linux/interrupt.h, vs input tree:
https://lkml.kernel.org/r/20240612103235.5ef64950@canb.auug.org.au

include/linux/cacheinfo.h, vs tip tree:
https://lkml.kernel.org/r/20240612112746.3130d68b@canb.auug.org.au

drivers/fsi/fsi-occ.c, vs driver-core tree:
https://lkml.kernel.org/r/20240612123640.68ae0310@canb.auug.org.au

This one is a bit vague, but might help:
arch/s390/include/asm/kmsan.h, arch/s390/include/asm/lowcore.h, vs s390
tree:
https://lkml.kernel.org/r/20240627150405.27663-1-iii@linux.ibm.com

mm/rmap.c, vs random tree:
https://lkml.kernel.org/r/20240702164041.60a19dfb@canb.auug.org.au
https://lkml.kernel.org/r/20240709174053.051a46a4@canb.auug.org.au

tools/testing/selftests/mm/Makefile, vs random tree:
https://lkml.kernel.org/r/20240709174340.5c03c2b9@canb.auug.org.au

fs/bcachefs/clock.c, vs bcachefs tree:
https://lkml.kernel.org/r/20240712105711.6dc900a2@canb.auug.org.au


The following changes since commit 1e3d28fe03cdac1f58402e4da1e1e59fb70d145f:

  MAINTAINERS: mailmap: update Lorenzo Stoakes's email address (2024-07-06 =
11:39:51 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2024=
-07-21-14-50

for you to fetch changes up to 30d77b7eef019fa4422980806e8b7cdc8674493e:

  mm/mglru: fix ineffective protection calculation (2024-07-17 21:08:55 -07=
00)

----------------------------------------------------------------
- 875fa64577da ("mm/hugetlb_vmemmap: fix race with speculative PFN
  walkers") is known to cause a performance regression
  (https://lore.kernel.org/all/3acefad9-96e5-4681-8014-827d6be71c7a@linux.i=
bm.com/T/#mfa809800a7862fb5bdf834c6f71a3a5113eb83ff).
  Yu has a fix which I'll send along later via the hotfixes branch.

- In the series "mm: Avoid possible overflows in dirty throttling" Jan
  Kara addresses a couple of issues in the writeback throttling code.
  These fixes are also targetted at -stable kernels.

- Ryusuke Konishi's series "nilfs2: fix potential issues related to
  reserved inodes" does that.  This should actually be in the
  mm-nonmm-stable tree, along with the many other nilfs2 patches.  My bad.

- More folio conversions from Kefeng Wang in the series "mm: convert to
  folio_alloc_mpol()"

- Kemeng Shi has sent some cleanups to the writeback code in the series
  "Add helper functions to remove repeated code and improve readability of
  cgroup writeback"

- Kairui Song has made the swap code a little smaller and a little
  faster in the series "mm/swap: clean up and optimize swap cache index".

- In the series "mm/memory: cleanly support zeropage in
  vm_insert_page*(), vm_map_pages*() and vmf_insert_mixed()" David
  Hildenbrand has reworked the rather sketchy handling of the use of the
  zeropage in MAP_SHARED mappings.  I don't see any runtime effects here -
  more a cleanup/understandability/maintainablity thing.

- Dev Jain has improved selftests/mm/va_high_addr_switch.c's handling of
  higher addresses, for aarch64.  The (poorly named) series is
  "Restructure va_high_addr_switch".

- The core TLB handling code gets some cleanups and possible slight
  optimizations in Bang Li's series "Add update_mmu_tlb_range() to
  simplify code".

- Jane Chu has improved the handling of our
  fake-an-unrecoverable-memory-error testing feature MADV_HWPOISON in the
  series "Enhance soft hwpoison handling and injection".

- Jeff Johnson has sent a billion patches everywhere to add
  MODULE_DESCRIPTION() to everything.  Some landed in this pull.

- In the series "mm: cleanup MIGRATE_SYNC_NO_COPY mode", Kefeng Wang has
  simplified migration's use of hardware-offload memory copying.

- Yosry Ahmed performs more folio API conversions in his series "mm:
  zswap: trivial folio conversions".

- In the series "large folios swap-in: handle refault cases first",
  Chuanhua Han inches us forward in the handling of large pages in the
  swap code.  This is a cleanup and optimization, working toward the end
  objective of full support of large folio swapin/out.

- In the series "mm,swap: cleanup VMA based swap readahead window
  calculation", Huang Ying has contributed some cleanups and a possible
  fixlet to his VMA based swap readahead code.

- In the series "add mTHP support for anonymous shmem" Baolin Wang has
  taught anonymous shmem mappings to use multisize THP.  By default this
  is a no-op - users must opt in vis sysfs controls.  Dramatic
  improvements in pagefault latency are realized.

- David Hildenbrand has some cleanups to our remaining use of
  page_mapcount() in the series "fs/proc: move page_mapcount() to
  fs/proc/internal.h".

- David also has some highmem accounting cleanups in the series
  "mm/highmem: don't track highmem pages manually".

- Build-time fixes and cleanups from John Hubbard in the series
  "cleanups, fixes, and progress towards avoiding "make headers"".

- Cleanups and consolidation of the core pagemap handling from Barry
  Song in the series "mm: introduce pmd|pte_needs_soft_dirty_wp helpers
  and utilize them".

- Lance Yang's series "Reclaim lazyfree THP without splitting" has
  reduced the latency of the reclaim of pmd-mapped THPs under fairly
  common circumstances.  A 10x speedup is seen in a microbenchmark.

  It does this by punting to aother CPU but I guess that's a win unless
  all CPUs are pegged.

- hugetlb_cgroup cleanups from Xiu Jianfeng in the series
  "mm/hugetlb_cgroup: rework on cftypes".

- Miaohe Lin's series "Some cleanups for memory-failure" does just that
  thing.

- Is anyone reading this stuff?  If so, email me!

- Someone other than SeongJae has developed a DAMON feature in Honggyu
  Kim's series "DAMON based tiered memory management for CXL memory".
  This adds DAMON features which may be used to help determine the
  efficiency of our placement of CXL/PCIe attached DRAM.

- DAMON user API centralization and simplificatio work in SeongJae
  Park's series "mm/damon: introduce DAMON parameters online commit
  function".

- In the series "mm: page_type, zsmalloc and page_mapcount_reset()"
  David Hildenbrand does some maintenance work on zsmalloc - partially
  modernizing its use of pageframe fields.

- Kefeng Wang provides more folio conversions in the series "mm: remove
  page_maybe_dma_pinned() and page_mkclean()".

- More cleanup from David Hildenbrand, this time in the series
  "mm/memory_hotplug: use PageOffline() instead of PageReserved() for
  !ZONE_DEVICE".  It "enlightens memory hotplug more about PageOffline()
  pages" and permits the removal of some virtio-mem hacks.

- Barry Song's series "mm: clarify folio_add_new_anon_rmap() and
  __folio_add_anon_rmap()" is a cleanup to the anon folio handling in
  preparation for mTHP (multisize THP) swapin.

- Kefeng Wang's series "mm: improve clear and copy user folio"
  implements more folio conversions, this time in the area of large folio
  userspace copying.

- The series "Docs/mm/damon/maintaier-profile: document a mailing tool
  and community meetup series" tells people how to get better involved
  with other DAMON developers.  From SeongJae Park.

- A large series ("kmsan: Enable on s390") from Ilya Leoshkevich does
  that.

- David Hildenbrand sends along more cleanups, this time against the
  migration code.  The series is "mm/migrate: move NUMA hinting fault
  folio isolation + checks under PTL".

- Jan Kara has found quite a lot of strangenesses and minor errors in
  the readahead code.  He addresses this in the series "mm: Fix various
  readahead quirks".

- SeongJae Park's series "selftests/damon: test DAMOS tried regions and
  {min,max}_nr_regions" adds features and addresses errors in DAMON's self
  testing code.

- Gavin Shan has found a userspace-triggerable WARN in the pagecache
  code.  The series "mm/filemap: Limit page cache size to that supported
  by xarray" addresses this.  The series is marked cc:stable.

- Chengming Zhou's series "mm/ksm: cmp_and_merge_page() optimizations
  and cleanup" cleans up and slightly optimizes KSM.

- Roman Gushchin has separated the memcg-v1 and memcg-v2 code - lots of
  code motion.  The series (which also makes the memcg-v1 code
  Kconfigurable) are

  "mm: memcg: separate legacy cgroup v1 code and put under config
  option" and
  "mm: memcg: put cgroup v1-specific memcg data under CONFIG_MEMCG_V1"

- Dan Schatzberg's series "Add swappiness argument to memory.reclaim"
  adds an additional feature to this cgroup-v2 control file.

- The series "Userspace controls soft-offline pages" from Jiaqi Yan
  permits userspace to stop the kernel's automatic treatment of excessive
  correctable memory errors.  In order to permit userspace to monitor and
  handle this situation.

- Kefeng Wang's series "mm: migrate: support poison recover from migrate
  folio" teaches the kernel to appropriately handle migration from
  poisoned source folios rather than simply panicing.

- SeongJae Park's series "Docs/damon: minor fixups and improvements"
  does those things.

- In the series "mm/zsmalloc: change back to per-size_class lock"
  Chengming Zhou improves zsmalloc's scalability and memory utilization.

- Vivek Kasireddy's series "mm/gup: Introduce memfd_pin_folios() for
  pinning memfd folios" makes the GUP code use FOLL_PIN rather than bare
  refcount increments.  So these paes can first be moved aside if they
  reside in the movable zone or a CMA block.

- Andrii Nakryiko has added a binary ioctl()-based API to /proc/pid/maps
  for much faster reading of vma information.  The series is "query VMAs
  from /proc/<pid>/maps".

- In the series "mm: introduce per-order mTHP split counters" Lance Yang
  improves the kernel's presentation of developer information related to
  multisize THP splitting.

- Michael Ellerman has developed the series "Reimplement huge pages
  without hugepd on powerpc (8xx, e500, book3s/64)".  This permits
  userspace to use all available huge page sizes.

- In the series "revert unconditional slab and page allocator fault
  injection calls" Vlastimil Babka removes a performance-affecting and not
  very useful feature from slab fault injection.

----------------------------------------------------------------
Anastasia Belova (1):
      mm/memory_hotplug: prevent accessing by index=3D-1

Andrew Morton (3):
      mm/huge_memory.c: fix used-uninitialized
      Merge branch 'mm-hotfixes-stable' into mm-stable to pick up "mm: fix =
crashes from deferred split racing folio migration", needed by "mm: migrate=
: split folio_migrate_mapping()".
      mm/hugetlb.c: undo errant change

Andrii Nakryiko (6):
      fs/procfs: extract logic for getting VMA name constituents
      fs/procfs: implement efficient VMA querying API for /proc/<pid>/maps
      fs/procfs: add build ID fetching to PROCMAP_QUERY API
      docs/procfs: call out ioctl()-based PROCMAP_QUERY command existence
      tools: sync uapi/linux/fs.h header into tools subdir
      selftests/proc: add PROCMAP_QUERY ioctl tests

Aristeu Rozanski (1):
      hugetlb: force allocating surplus hugepages on mempolicy allowed nodes

Arnd Bergmann (1):
      udmabuf: add CONFIG_MMU dependency

Audra Mitchell (2):
      mm: update uffd-stress to handle EINVAL for unset config features
      mm: turn off test_uffdio_wp if CONFIG_PTE_MARKER_UFFD_WP is not confi=
gured.

Bang Li (5):
      mm: add update_mmu_tlb_range()
      mm: implement update_mmu_tlb() using update_mmu_tlb_range()
      mm: use update_mmu_tlb_range() to simplify code
      mm/shmem: fix input and output inconsistencies
      mm: thp: support "THPeligible" semantics for mTHP with anonymous shmem

Baolin Wang (7):
      mm: memory: extend finish_fault() to support large folio
      mm: shmem: add THP validation for PMD-mapped THP related statistics
      mm: shmem: add multi-size THP sysfs interface for anonymous shmem
      mm: shmem: add mTHP support for anonymous shmem
      mm: shmem: add mTHP size alignment in shmem_get_unmapped_area
      mm: shmem: add mTHP counters for anonymous shmem
      mm: memcontrol: add VM_BUG_ON_FOLIO() to catch lru folio in mem_cgrou=
p_migrate()

Barry Song (12):
      mm: remove the implementation of swap_free() and always use swap_free=
_nr()
      mm: introduce pte_move_swp_offset() helper which can move offset bidi=
rectionally
      mm: introduce arch_do_swap_page_nr() which allows restore metadata fo=
r nr pages
      mm: swap: reuse exclusive folio directly instead of wp page faults
      mm: introduce pmd|pte_needs_soft_dirty_wp helpers for softdirty write=
-protect
      mm: set pte writable while pte_soft_dirty() is true in do_swap_page()
      mm: extend rmap flags arguments for folio_add_new_anon_rmap
      mm: use folio_add_new_anon_rmap() if folio_test_anon(folio)=3D=3Dfalse
      mm: remove folio_test_anon(folio)=3D=3Dfalse path in __folio_add_anon=
_rmap()
      tools/mm: introduce a tool to assess swap entry allocation for thp_sw=
apout
      mm/vmscan: drop checking if _deferred_list is empty before using TTU_=
SYNC
      mm: zswap: fix zswap_never_enabled() for CONFIG_ZSWAP=3D=3DN

Brian Johannesmeyer (1):
      kmsan: introduce test_unpoison_memory()

Chengming Zhou (7):
      mm/ksm: refactor out try_to_merge_with_zero_page()
      mm/ksm: don't waste time searching stable tree for fast changing page
      mm/ksm: optimize the chain()/chain_prune() interfaces
      mm/zsmalloc: change back to per-size_class lock
      mm/zswap: use only one pool in zswap
      mm/zsmalloc: clarify class per-fullness zspage counts
      mm/zsmalloc: move record_obj() into obj_malloc()

Christoph Hellwig (1):
      mm: unexport vmf_insert_mixed_mkwrite

Christophe Leroy (17):
      mm: define __pte_leaf_size() to also take a PMD entry
      mm: provide mm_struct and address to huge_ptep_get()
      powerpc/mm: remove _PAGE_PSIZE
      powerpc/mm: fix __find_linux_pte() on 32 bits with PMD leaf entries
      powerpc/mm: allow hugepages without hugepd
      powerpc/8xx: fix size given to set_huge_pte_at()
      powerpc/8xx: rework support for 8M pages using contiguous PTE entries
      powerpc/8xx: simplify struct mmu_psize_def
      powerpc/e500: remove enc and ind fields from struct mmu_psize_def
      powerpc/e500: switch to 64 bits PGD on 85xx (32 bits)
      powerpc/e500: encode hugepage size in PTE bits
      powerpc/e500: don't pre-check write access on data TLB error
      powerpc/e500: free r10 for FIND_PTE
      powerpc/e500: use contiguous PMD instead of hugepd
      powerpc/64s: use contiguous PMD/PUD instead of HUGEPD
      powerpc/mm: remove hugepd leftovers
      mm: remove CONFIG_ARCH_HAS_HUGEPD

Chuanhua Han (3):
      mm: swap: introduce swap_free_nr() for batched swap_free()
      mm: swap: make should_try_to_free_swap() support large-folio
      mm: swap: entirely map large folios found in swapcache

Dan Carpenter (1):
      mm/zswap: fix a white space issue

Dan Schatzberg (2):
      mm: add defines for min/max swappiness
      mm: add swappiness=3D arg to memory.reclaim

David Hildenbrand (23):
      mm/memory: move page_count() check into validate_page_before_insert()
      mm/memory: cleanly support zeropage in vm_insert_page*(), vm_map_page=
s*() and vmf_insert_mixed()
      mm/rmap: sanity check that zeropages are not passed to RMAP
      fs/proc/task_mmu: indicate PM_FILE for PMD-mapped file THP
      fs/proc/task_mmu: don't indicate PM_MMAP_EXCLUSIVE without PM_PRESENT
      fs/proc/task_mmu: properly detect PM_MMAP_EXCLUSIVE per page of PMD-m=
apped THPs
      fs/proc/task_mmu: account non-present entries as "maybe shared, but n=
o idea how often"
      fs/proc: move page_mapcount() to fs/proc/internal.h
      Documentation/admin-guide/mm/pagemap.rst: drop "Using pagemap to do s=
omething useful"
      mm/highmem: reimplement totalhigh_pages() by walking zones
      mm/highmem: make nr_free_highpages() return "unsigned long"
      mm: update _mapcount and page_type documentation
      mm: allow reuse of the lower 16 bit of the page type with an actual t=
ype
      mm/zsmalloc: use a proper page type
      mm/page_alloc: clear PageBuddy using __ClearPageBuddy() for bad pages
      mm/filemap: reinitialize folio->_mapcount directly
      mm/mm_init: initialize page->_mapcount directly in __init_single_page=
()
      mm: pass meminit_context to __free_pages_core()
      mm/memory_hotplug: initialize memmap of !ZONE_DEVICE with PageOffline=
() instead of PageReserved()
      mm/memory_hotplug: skip adjust_managed_page_count() for PageOffline()=
 pages when offlining
      mm: read page_type using READ_ONCE
      mm/migrate: make migrate_misplaced_folio() return 0 on success
      mm/migrate: move NUMA hinting fault folio isolation + checks under PTL

Dev Jain (3):
      selftests/mm: va_high_addr_switch: reduce test noise
      selftests/mm: va_high_addr_switch: dynamically initialize testcases t=
o enable LPA2 testing
      mm: sparse: consistently use _nr

Donet Tom (2):
      selftest: mm: Test if hugepage does not get leaked during __bio_relea=
se_pages()
      hugetlbfs: ensure generic_hugetlb_get_unmapped_area() returns higher =
address than mmap_min_addr

Edward Liaw (3):
      selftests/mm: include linux/mman.h
      selftests/mm: guard defines from shm
      selftests: centralize -D_GNU_SOURCE=3D to CFLAGS in lib.mk

Eric Chanudet (1):
      mm/mm_init: use node's number of cpus in deferred_page_init_max_threa=
ds

Ho-Ren (Jack) Chuang (1):
      memory tier: consolidate the initialization of memory tiers

Hongfu Li (1):
      khugepaged: simplify the allocation of slab caches

Honggyu Kim (5):
      mm: make alloc_demote_folio externally invokable for migration
      mm: rename alloc_demote_folio to alloc_migrate_folio
      mm/migrate: add MR_DAMON to migrate_reason
      mm/damon/paddr: introduce DAMOS_MIGRATE_COLD action for demotion
      Docs/damon: document damos_migrate_{hot,cold}

Huang Ying (3):
      mm,swap: fix a theoretical underflow in readahead window calculation
      mm,swap: remove struct vma_swap_readahead
      mm,swap: simplify VMA based swap readahead window calculation

Hugh Dickins (1):
      mm: simplify folio_migrate_mapping()

Hyeongtak Ji (2):
      mm/damon/sysfs-schemes: add target_nid on sysfs-schemes
      mm/damon/paddr: introduce DAMOS_MIGRATE_HOT action for promotion

Illia Ostapyshyn (1):
      mm/vmscan: update stale references to shrink_page_list

Ilya Leoshkevich (40):
      ftrace: unpoison ftrace_regs in ftrace_ops_list_func()
      kmsan: make the tests compatible with kmsan.panic=3D1
      kmsan: disable KMSAN when DEFERRED_STRUCT_PAGE_INIT is enabled
      kmsan: increase the maximum store size to 4096
      kmsan: fix is_bad_asm_addr() on arches with overlapping address spaces
      kmsan: fix kmsan_copy_to_user() on arches with overlapping address sp=
aces
      kmsan: remove a useless assignment from kmsan_vmap_pages_range_noflus=
h()
      kmsan: remove an x86-specific #include from kmsan.h
      kmsan: expose kmsan_get_metadata()
      kmsan: export panic_on_kmsan
      kmsan: allow disabling KMSAN checks for the current task
      kmsan: introduce memset_no_sanitize_memory()
      kmsan: support SLAB_POISON
      kmsan: use ALIGN_DOWN() in kmsan_get_metadata()
      kmsan: do not round up pg_data_t size
      kmsan: expose KMSAN_WARN_ON()
      mm: slub: let KMSAN access metadata
      mm: slub: disable KMSAN when checking the padding bytes
      mm: kfence: disable KMSAN when checking the canary
      lib/zlib: unpoison DFLTCC output buffers
      kmsan: accept ranges starting with 0 on s390
      s390/boot: turn off KMSAN
      s390: use a larger stack for KMSAN
      s390/boot: add the KMSAN runtime stub
      s390/checksum: add a KMSAN check
      s390/cpacf: unpoison the results of cpacf_trng()
      s390/cpumf: unpoison STCCTM output buffer
      s390/diag: unpoison diag224() output buffer
      s390/ftrace: unpoison ftrace_regs in kprobe_ftrace_handler()
      s390/irqflags: do not instrument arch_local_irq_*() with KMSAN
      s390/mm: define KMSAN metadata for vmalloc and modules
      s390/string: add KMSAN support
      s390/traps: unpoison the kernel_stack_overflow()'s pt_regs
      s390/uaccess: add KMSAN support to put_user() and get_user()
      s390/uaccess: add the missing linux/instrumented.h #include
      s390/unwind: disable KMSAN checks
      s390/kmsan: implement the architecture-specific functions
      kmsan: enable on s390
      kmsan: add missing __user tags
      kmsan: do not pass NULL pointers as 0

JaeJoon Jung (1):
      maple_tree: modified return type of mas_wr_store_entry()

Jan Kara (12):
      Revert "mm/writeback: fix possible divide-by-zero in wb_dirty_limits(=
), again"
      mm: avoid overflows in dirty throttling logic
      readahead: make sure sync readahead reads needed page
      filemap: fix page_cache_next_miss() when no hole found
      readahead: properly shorten readahead when falling back to do_page_ca=
che_ra()
      readahead: drop pointless index from force_page_cache_ra()
      readahead: drop index argument of page_cache_async_readahead()
      readahead: drop dead code in page_cache_ra_order()
      readahead: drop dead code in ondemand_readahead()
      readahead: disentangle async and sync readahead
      readahead: fold try_context_readahead() into its single caller
      readahead: simplify gotos in page_cache_sync_ra()

Jane Chu (5):
      mm/memory-failure: try to send SIGBUS even if unmap failed
      mm/madvise: add MF_ACTION_REQUIRED to madvise(MADV_HWPOISON)
      mm/memory-failure: improve memory failure action_result messages
      mm/memory-failure: move hwpoison_filter() higher up
      mm/memory-failure: send SIGBUS in the event of thp split fail

Javier Martinez Canillas (1):
      mm/Kconfig: mention arm64 in DEFAULT_MMAP_MIN_ADDR symbol help text

Jeff Johnson (9):
      mm/hwpoison: add MODULE_DESCRIPTION()
      mm/dmapool: add MODULE_DESCRIPTION()
      mm/kfence: add MODULE_DESCRIPTION()
      mm/zsmalloc: add MODULE_DESCRIPTION()
      kmemleak-test: add missing MODULE_DESCRIPTION() macro
      test_xarray: add missing MODULE_DESCRIPTION() macro
      ubsan: add missing MODULE_DESCRIPTION() macro
      test_maple_tree: add the missing MODULE_DESCRIPTION() macro
      lib: test_hmm: add missing MODULE_DESCRIPTION() macro

Jiapeng Chong (1):
      mm: userfaultfd: use swap() in double_pt_lock()

Jiaqi Yan (5):
      mm/memory-failure: refactor log format in unpoison_memory
      mm/memory-failure: refactor log format in soft offline code
      mm/memory-failure: userspace controls soft-offlining pages
      selftest/mm: test enable_soft_offline behaviors
      docs: mm: add enable_soft_offline sysctl

Jinliang Zheng (1):
      mm: optimize the redundant loop of mm_update_owner_next()

Johannes Weiner (2):
      mm: vmscan: restore incremental cgroup iteration
      mm: remove CONFIG_MEMCG_KMEM

John Hubbard (6):
      selftests/mm: mseal, self_elf: fix missing __NR_mseal
      selftests/mm: mseal, self_elf: factor out test macros and other dupli=
cated items
      selftests/mm: mseal, self_elf: rename TEST_END_CHECK to REPORT_TEST_P=
ASS
      selftests/mm: fix vm_util.c build failures: add snapshot of fs.h
      selftests/mm: kvm, mdwe fixes to avoid requiring "make headers"
      selftests/mm: remove local __NR_* definitions

Jonathan Cameron (1):
      mm/memory_hotplug: drop memblock_phys_free() call in try_remove_memor=
y()

Kairui Song (10):
      nilfs2: drop usage of page_index
      ceph: drop usage of page_index
      NFS: remove nfs_page_lengthg and usage of page_index
      afs: drop usage of folio_file_pos
      netfs: drop usage of folio_file_pos
      nfs: drop usage of folio_file_pos
      mm/swap: get the swap device offset directly
      mm: remove page_file_offset and folio_file_pos
      mm: drop page_index and simplify folio_index
      mm/swap: reduce swap cache search space

Kees Cook (1):
      mm/kmemleak: replace strncpy() with strscpy()

Kefeng Wang (28):
      mm: add folio_alloc_mpol()
      mm: mempolicy: use folio_alloc_mpol_noprof() in vma_alloc_folio_nopro=
f()
      mm: mempolicy: use folio_alloc_mpol() in alloc_migration_target_by_mp=
ol()
      mm: shmem: use folio_alloc_mpol() in shmem_alloc_folio()
      mm: memcontrol: remove page_memcg()
      rmap: remove DEFINE_PAGE_VMA_WALK()
      mm: migrate: simplify __buffer_migrate_folio()
      mm: migrate_device: use a newfolio in __migrate_device_pages()
      mm: migrate_device: unify migrate folio for MIGRATE_SYNC_NO_COPY
      mm: migrate: remove migrate_folio_extra()
      mm: remove MIGRATE_SYNC_NO_COPY mode
      mm: ksm: drop KSM_KMEM_CACHE()
      fs/proc/task_mmu: use folio API in pte_is_pinned()
      mm: remove page_maybe_dma_pinned()
      fb_defio: use a folio in fb_deferred_io_work()
      mm: remove page_mkclean()
      mm: memory: convert clear_huge_page() to folio_zero_user()
      mm: memory: use folio in struct copy_subpage_arg
      mm: memory: improve copy_user_large_folio()
      mm: memory: rename pages_per_huge_page to nr_pages
      mm: refactor folio_undo_large_rmappable()
      mm: move memory_failure_queue() into copy_mc_[user]_highpage()
      mm: add folio_mc_copy()
      mm: migrate: split folio_migrate_mapping()
      mm: migrate: support poisoned recover from migrate folio
      fs: hugetlbfs: support poisoned recover from hugetlbfs_migrate_folio()
      mm: migrate: remove folio_migrate_copy()
      mm: swap_state: use folio_alloc_mpol() in __read_swap_cache_async()

Kemeng Shi (8):
      writeback: factor out wb_bg_dirty_limits to remove repeated code
      writeback: add general function domain_dirty_avail to calculate dirty=
 and avail of domain
      writeback: factor out domain_over_bg_thresh to remove repeated code
      writeback: factor out code of freerun to remove repeated code
      writeback: factor out wb_dirty_freerun to remove more repeated freeru=
n code
      writeback: factor out balance_domain_limits to remove repeated code
      writeback: factor out wb_dirty_exceeded to remove repeated code
      writeback: factor out balance_wb_limits to remove repeated code

Lance Yang (6):
      mm/rmap: remove duplicated exit code in pagewalk loop
      mm/rmap: integrate PMD-mapped folio splitting into pagewalk loop
      mm/vmscan: avoid split lazyfree THP during shrink_folio_list()
      mm/mlock: implement folio_mlock_step() using folio_pte_batch()
      mm: add per-order mTHP split counters
      mm: add docs for per-order mTHP split counters

Leesoo Ahn (1):
      mm/sparse: use MEMBLOCK_ALLOC_ACCESSIBLE enum instead of 0

Maarten Lankhorst (1):
      mm/page_counter: move calculating protection values to page_counter

Mateusz Guzik (1):
      mm: batch unlink_file_vma calls in free_pgd_range

Matthew Wilcox (Oracle) (2):
      mm: remove page_mapping()
      mm/memory-failure: stop setting the folio error flag

Miaohe Lin (16):
      mm/memory-failure: simplify put_ref_page()
      mm/memory-failure: remove MF_MSG_SLAB
      mm/memory-failure: add macro GET_PAGE_MAX_RETRY_NUM
      mm/memory-failure: save some page_folio() calls
      mm/memory-failure: remove unneeded empty string
      mm/memory-failure: remove confusing initialization to count
      mm/memory-failure: don't export hwpoison_filter() when !CONFIG_HWPOIS=
ON_INJECT
      mm/memory-failure: use helper macro task_pid_nr()
      mm/memory-failure: remove obsolete comment in unpoison_memory()
      mm/memory-failure: move some function declarations into internal.h
      mm/memory-failure: fix comment of get_hwpoison_page()
      mm/memory-failure: remove obsolete comment in kill_proc()
      mm/memory-failure: correct comment in me_swapcache_dirty
      mm/memory-failure: remove obsolete MF_MSG_DIFFERENT_COMPOUND
      mm/hugetlb: fix possible recursive locking detected warning
      mm/hugetlb: fix kernel NULL pointer dereference when migrating hugetl=
b folio

Michael Ellerman (6):
      powerpc/64e: remove unused IBM HTW code
      powerpc/64e: split out nohash Book3E 64-bit code
      powerpc/64e: drop E500 ifdefs in 64-bit code
      powerpc/64e: drop MMU_FTR_TYPE_FSL_E checks in 64-bit code
      powerpc/64e: consolidate TLB miss handler patching
      powerpc/64e: drop unused TLB miss handlers

Muhammad Usama Anjum (1):
      selftests: mm: check return values

Oleg Nesterov (3):
      memcg: mm_update_next_owner: kill the "retry" logic
      memcg: mm_update_next_owner: move for_each_thread() into try_to_set_o=
wner()
      get_task_mm: check PF_KTHREAD lockless

Oscar Salvador (3):
      mm/hugetlb: drop node_alloc_noretry from alloc_fresh_hugetlb_folio
      arch/x86: do not explicitly clear Reserved flag in free_pagetable
      mm/hugetlb: guard dequeue_hugetlb_folio_nodemask against NUMA_NO_NODE=
 uses

Pankaj Raghav (1):
      selftests/mm: use asm volatile to not optimize mmap read variable

Pei Li (1):
      mm: ignore data-race in __swap_writepage

Peter Xu (2):
      mm: drop leftover comment references to pxx_huge()
      mm/migrate: putback split folios when numa hint migration fails

Ran Xiaokai (2):
      mm/huge_memory: mark racy access onhuge_anon_orders_always
      kpageflags: detect isolated KPF_THP folios

Roman Gushchin (26):
      mm: memcg: introduce memcontrol-v1.c
      mm: memcg: move soft limit reclaim code to memcontrol-v1.c
      mm: memcg: rename soft limit reclaim-related functions
      mm: memcg: move charge migration code to memcontrol-v1.c
      mm: memcg: rename charge move-related functions
      mm: memcg: move legacy memcg event code into memcontrol-v1.c
      mm: memcg: rename memcg_check_events()
      mm: memcg: move cgroup v1 oom handling code into memcontrol-v1.c
      mm: memcg: rename memcg_oom_recover()
      mm: memcg: move cgroup v1 interface files to memcontrol-v1.c
      mm: memcg: make memcg1_update_tree() static
      mm: memcg: group cgroup v1 memcg related declarations
      mm: memcg: put cgroup v1-specific code under a config option
      MAINTAINERS: add mm/memcontrol-v1.c/h to the list of maintained files
      mm: memcg: move memcg_account_kmem() to memcontrol-v1.c
      mm: memcg: factor out legacy socket memory accounting code
      mm: memcg: guard cgroup v1-specific code in mem_cgroup_print_oom_memi=
nfo()
      mm: memcg: gather memcg1-specific fields initialization in memcg1_mem=
cg_init()
      mm: memcg: guard memcg1-specific fields accesses in mm/memcontrol.c
      mm: memcg: put memcg1-specific struct mem_cgroup's members under CONF=
IG_MEMCG_V1
      mm: memcg: guard memcg1-specific members of struct mem_cgroup_per_node
      mm: memcg: put struct task_struct::memcg_in_oom under CONFIG_MEMCG_V1
      mm: memcg: put struct task_struct::in_user_fault under CONFIG_MEMCG_V1
      mm: memcg: drop obsolete cache line padding in struct mem_cgroup
      mm: memcg: add cache line padding to mem_cgroup_per_node
      mm: memcg1: convert charge move flags to unsigned long long

Ryan Roberts (2):
      mm: fix khugepaged activation policy
      mm: shmem: rename mTHP shmem counters

Ryusuke Konishi (3):
      nilfs2: fix inode number range checks
      nilfs2: add missing check for inode numbers on directory entries
      nilfs2: fix incorrect inode allocation from reserved inodes

SeongJae Park (32):
      mm/damon/core: implement DAMOS quota goals online commit function
      mm/damon/core: implement DAMON context commit function
      mm/damon/sysfs: use damon_commit_ctx()
      mm/damon/sysfs-schemes: use damos_commit_quota_goals()
      mm/damon/sysfs: remove unnecessary online tuning handling code
      mm/damon/sysfs: rename damon_sysfs_set_targets() to ...add_targets()
      mm/damon/sysfs-schemes: remove unnecessary online tuning handling code
      mm/damon/sysfs-schemes: rename *_set_{schemes,scheme_filters,quota_sc=
ore,schemes}()
      mm/damon/reclaim: use damon_commit_ctx()
      mm/damon/reclaim: remove unnecessary code for online tuning
      mm/damon/lru_sort: use damon_commit_ctx()
      mm/damon/lru_sort: remove unnecessary online tuning handling code
      Docs/mm/damon/maintainer-profile: introduce HacKerMaiL
      Docs/mm/damon/maintainer-profile: document DAMON community meetups
      selftests/damon/access_memory: use user-defined region size
      selftests/damon/_damon_sysfs: support schemes_update_tried_regions
      selftests/damon: implement a program for even-numbered memory regions=
 access
      selftests/damon: implement DAMOS tried regions test
      selftests/damon/_damon_sysfs: implement kdamonds stop function
      selftests/damon: implement test for min/max_nr_regions
      _damon_sysfs: implement commit() for online parameters update
      selftests/damon/damon_nr_regions: test online-tuned max_nr_regions
      mm/damon/paddr: initialize nr_succeeded in __damon_pa_migrate_folio_l=
ist()
      Docs/mm/damon/design: fix two typos
      Docs/mm/damon/design: clarify regions merging operation
      Docs/admin-guide/mm/damon/start: add access pattern snapshot example
      Docs/mm/damon/design: add links from overall architecture to sections=
 of details
      Docs/mm/damon/design: move 'Configurable Operations Set' section into=
 'Operations Set Layer' section
      Docs/mm/damon/design: remove 'Programmable Modules' section in favor =
of 'Modules' section
      Docs/mm/damon/design: add links to sections of DAMON sysfs interface =
usage doc
      Docs/mm/damon/index: add links to design
      Docs/mm/damon/index: add links to admin-guide doc

Sergey Senozhatsky (1):
      zsmalloc: rename class stat mutators

Shakeel Butt (2):
      mm: vmscan: reset sc->priority on retry
      memcg: rearrange fields of mem_cgroup_per_node

Shubhang Kaushik OS (1):
      vmalloc: modify the alloc_vmap_area() error message for better diagno=
stics

Sidhartha Kumar (2):
      mm/hugetlb: remove {Set,Clear}Hpage macros
      mm/hugetlb: mm/memory_hotplug: use a folio in scan_movable_pages()

Sourav Panda (1):
      mm: report per-page metadata information

Suren Baghdasaryan (4):
      mm: add comments for allocation helpers explaining why they are macros
      lib: add missing newline character in the warning message
      lib: reuse page_ext_data() to obtain codetag_ref
      alloc_tag: fix page_ext_get/page_ext_put sequence during page splitti=
ng

Tetsuo Handa (1):
      mm: mmap_lock: replace get_memcg_path_buf() with on-stack buffer

Thomas Wei=DFschuh (1):
      mm/hugetlb: constify ctl_table arguments of utility functions

Tvrtko Ursulin (1):
      mm/numa_balancing: teach mpol_to_str about the balancing mode

Uros Bizjak (2):
      percpu: add __this_cpu_try_cmpxchg()
      mm/vmalloc: use __this_cpu_try_cmpxchg() in preload_this_cpu_lock()

Usama Arif (1):
      mm: do not start/end writeback for pages stored in zswap

Vivek Kasireddy (8):
      mm/gup: introduce unpin_folio/unpin_folios helpers
      mm/gup: introduce check_and_migrate_movable_folios()
      mm/gup: introduce memfd_pin_folios() for pinning memfd folios
      udmabuf: use vmf_insert_pfn and VM_PFNMAP for handling mmap
      udmabuf: add back support for mapping hugetlb pages
      udmabuf: convert udmabuf driver to use folios
      udmabuf: pin the pages using memfd_pin_folios() API
      selftests/udmabuf: add tests to verify data after page migration

Vlastimil Babka (2):
      mm, slab: put should_failslab() back behind CONFIG_SHOULD_FAILSLAB
      mm, page_alloc: put should_fail_alloc_page() back behing CONFIG_FAIL_=
PAGE_ALLOC

Wei Yang (10):
      mm/mm_init.c: print mem_init info after defer_init is done
      mm/mm_init.c: simplify logic of deferred_[init|free]_pages
      mm/sparse: nr_pages won't be 0
      mm/mm_init.c: move build check on MAX_ZONELISTS out of ifdef
      mm/page_alloc: fix a typo in comment about GFP flag
      mm/page_alloc: reword the comment of buddy_merge_likely()
      kernel/fork.c: get totalram_pages from memblock to calculate max_thre=
ads
      kernel/fork.c: put set_max_threads()/task_struct_whitelist() in __ini=
t section
      mm/page_alloc: remove prefetchw() on freeing page to buddy system
      mm/page_alloc: put __free_pages_core() in __meminit section

Xiu Jianfeng (5):
      mm/hugetlb_cgroup: identify the legacy using cgroup_subsys_on_dfl()
      mm/hugetlb_cgroup: prepare cftypes based on template
      mm/hugetlb_cgroup: switch to the new cftypes
      mm: memcg: remove redundant seq_buf_has_overflowed()
      mm: memcg: adjust the warning when seq_buf overflows

Yifei Li (1):
      mm/memory-failure: use helper llist_for_each_entry()

Yosry Ahmed (8):
      mm: zswap: use sg_set_folio() in zswap_{compress/decompress}()
      mm :zswap: use kmap_local_folio() in zswap_load()
      mm: zswap: make same_filled functions folio-friendly
      mm: rmap: abstract updating per-node and per-memcg stats
      mm: swap: remove 'synchronous' argument to swap_read_folio()
      mm: zswap: rename is_zswap_enabled() to zswap_is_enabled()
      mm: zswap: add zswap_never_enabled()
      mm: zswap: handle incorrect attempts to load large folios

Yu Zhao (4):
      mm/truncate: batch-clear shadow entries
      mm/mglru: fix div-by-zero in vmpressure_calc_level()
      mm/mglru: fix overshooting shrinker memory
      mm/mglru: fix ineffective protection calculation

yangge (1):
      mm/gup: clear the LRU flag of a page before adding to LRU batch

 Documentation/ABI/testing/sysfs-kernel-mm-damon    |    6 +
 Documentation/admin-guide/cgroup-v2.rst            |   18 +-
 Documentation/admin-guide/kernel-parameters.txt    |    9 +-
 Documentation/admin-guide/mm/damon/start.rst       |   46 +-
 Documentation/admin-guide/mm/damon/usage.rst       |   10 +-
 Documentation/admin-guide/mm/pagemap.rst           |   25 +-
 Documentation/admin-guide/mm/transhuge.rst         |   85 +-
 Documentation/admin-guide/sysctl/vm.rst            |   38 +
 Documentation/core-api/pin_user_pages.rst          |   18 +-
 Documentation/dev-tools/kmsan.rst                  |   11 +-
 Documentation/filesystems/proc.rst                 |    9 +
 Documentation/mm/arch_pgtable_helpers.rst          |    4 -
 Documentation/mm/damon/design.rst                  |  149 +-
 Documentation/mm/damon/index.rst                   |   22 +-
 Documentation/mm/damon/maintainer-profile.rst      |   36 +
 Documentation/mm/unevictable-lru.rst               |   10 +-
 MAINTAINERS                                        |    2 +
 arch/arm/include/asm/cacheflush.h                  |    2 +-
 arch/arm/include/asm/hugetlb-3level.h              |    4 +-
 arch/arm64/include/asm/cacheflush.h                |    2 +-
 arch/arm64/include/asm/hugetlb.h                   |    2 +-
 arch/arm64/mm/hugetlbpage.c                        |    2 +-
 arch/loongarch/include/asm/pgtable.h               |    4 +-
 arch/mips/include/asm/pgtable.h                    |    4 +-
 arch/mips/mm/cache.c                               |    2 +-
 arch/powerpc/Kconfig                               |    1 -
 arch/powerpc/include/asm/book3s/32/pgalloc.h       |    2 -
 arch/powerpc/include/asm/book3s/64/hash-4k.h       |   15 -
 arch/powerpc/include/asm/book3s/64/hash.h          |   40 +-
 arch/powerpc/include/asm/book3s/64/hugetlb.h       |   38 -
 arch/powerpc/include/asm/book3s/64/pgtable-4k.h    |   47 -
 arch/powerpc/include/asm/book3s/64/pgtable-64k.h   |   20 -
 arch/powerpc/include/asm/book3s/64/pgtable.h       |   22 +-
 arch/powerpc/include/asm/hugetlb.h                 |   15 +-
 arch/powerpc/include/asm/nohash/32/hugetlb-8xx.h   |   38 +-
 arch/powerpc/include/asm/nohash/32/mmu-8xx.h       |    9 +-
 arch/powerpc/include/asm/nohash/32/pte-44x.h       |    3 -
 arch/powerpc/include/asm/nohash/32/pte-85xx.h      |    3 -
 arch/powerpc/include/asm/nohash/32/pte-8xx.h       |   58 +-
 arch/powerpc/include/asm/nohash/hugetlb-e500.h     |   39 +-
 arch/powerpc/include/asm/nohash/mmu-e500.h         |    6 +-
 arch/powerpc/include/asm/nohash/pgalloc.h          |    2 -
 arch/powerpc/include/asm/nohash/pgtable.h          |   46 +-
 arch/powerpc/include/asm/nohash/pte-e500.h         |   63 +-
 arch/powerpc/include/asm/page.h                    |   32 -
 arch/powerpc/include/asm/pgtable-be-types.h        |   10 -
 arch/powerpc/include/asm/pgtable-types.h           |   13 +-
 arch/powerpc/include/asm/pgtable.h                 |    3 +
 arch/powerpc/kernel/exceptions-64e.S               |    4 +-
 arch/powerpc/kernel/head_85xx.S                    |   70 +-
 arch/powerpc/kernel/head_8xx.S                     |   10 +-
 arch/powerpc/kernel/setup_64.c                     |    6 +-
 arch/powerpc/mm/book3s64/hash_utils.c              |   11 +-
 arch/powerpc/mm/book3s64/hugetlbpage.c             |   10 +
 arch/powerpc/mm/book3s64/pgtable.c                 |   12 -
 arch/powerpc/mm/hugetlbpage.c                      |  455 +-
 arch/powerpc/mm/init-common.c                      |    8 +-
 arch/powerpc/mm/kasan/8xx.c                        |   21 +-
 arch/powerpc/mm/nohash/8xx.c                       |   43 +-
 arch/powerpc/mm/nohash/Makefile                    |    2 +-
 arch/powerpc/mm/nohash/book3e_pgtable.c            |    4 +-
 arch/powerpc/mm/nohash/tlb.c                       |  407 +-
 arch/powerpc/mm/nohash/tlb_64e.c                   |  314 ++
 arch/powerpc/mm/nohash/tlb_low_64e.S               |  428 +-
 arch/powerpc/mm/pgtable.c                          |   94 +-
 arch/powerpc/mm/pgtable_32.c                       |    2 +-
 arch/riscv/include/asm/hugetlb.h                   |    2 +-
 arch/riscv/include/asm/pgtable.h                   |    4 +-
 arch/riscv/mm/hugetlbpage.c                        |    2 +-
 arch/s390/Kconfig                                  |    1 +
 arch/s390/Makefile                                 |    2 +-
 arch/s390/boot/Makefile                            |    3 +
 arch/s390/boot/kmsan.c                             |    6 +
 arch/s390/boot/startup.c                           |    7 +
 arch/s390/boot/string.c                            |   16 +
 arch/s390/include/asm/checksum.h                   |    2 +
 arch/s390/include/asm/cpacf.h                      |    3 +
 arch/s390/include/asm/cpu_mf.h                     |    6 +
 arch/s390/include/asm/hugetlb.h                    |    4 +-
 arch/s390/include/asm/irqflags.h                   |   17 +-
 arch/s390/include/asm/kmsan.h                      |   59 +
 arch/s390/include/asm/pgtable.h                    |   12 +
 arch/s390/include/asm/string.h                     |   20 +-
 arch/s390/include/asm/thread_info.h                |    2 +-
 arch/s390/include/asm/uaccess.h                    |  112 +-
 arch/s390/kernel/diag.c                            |   10 +-
 arch/s390/kernel/ftrace.c                          |    2 +
 arch/s390/kernel/traps.c                           |    6 +
 arch/s390/kernel/unwind_bc.c                       |    4 +
 arch/s390/mm/hugetlbpage.c                         |    4 +-
 arch/sparc/mm/init_64.c                            |    2 +-
 arch/x86/mm/init_64.c                              |   14 -
 arch/x86/mm/pat/set_memory.c                       |    4 +-
 arch/xtensa/include/asm/pgtable.h                  |    6 +-
 arch/xtensa/mm/tlb.c                               |    6 +-
 drivers/acpi/numa/hmat.c                           |    5 +-
 drivers/block/zram/Kconfig                         |    1 +
 drivers/dma-buf/Kconfig                            |    1 +
 drivers/dma-buf/udmabuf.c                          |  232 +-
 drivers/hv/hv_balloon.c                            |    5 +-
 drivers/s390/char/sclp.c                           |    2 +-
 drivers/video/fbdev/core/fb_defio.c                |   13 +-
 drivers/virtio/virtio_mem.c                        |   29 +-
 drivers/xen/balloon.c                              |    9 +-
 fs/afs/dir.c                                       |    6 +-
 fs/afs/dir_edit.c                                  |    4 +-
 fs/aio.c                                           |   15 +-
 fs/btrfs/relocation.c                              |    3 +-
 fs/btrfs/send.c                                    |    2 +-
 fs/ceph/dir.c                                      |    2 +-
 fs/ceph/inode.c                                    |    2 +-
 fs/hugetlbfs/inode.c                               |   20 +-
 fs/netfs/buffered_read.c                           |    4 +-
 fs/netfs/buffered_write.c                          |    2 +-
 fs/nfs/file.c                                      |    2 +-
 fs/nfs/internal.h                                  |   19 -
 fs/nfs/iostat.h                                    |    4 +
 fs/nfs/nfstrace.h                                  |    4 +-
 fs/nfs/write.c                                     |    6 +-
 fs/nilfs2/bmap.c                                   |   10 +-
 fs/proc/internal.h                                 |   33 +
 fs/proc/page.c                                     |   42 +-
 fs/proc/task_mmu.c                                 |  503 ++-
 fs/userfaultfd.c                                   |    2 +-
 include/acpi/platform/aclinuxex.h                  |    9 +-
 include/asm-generic/hugetlb.h                      |    2 +-
 include/linux/alloc_tag.h                          |    2 +-
 include/linux/bpf.h                                |    8 +-
 include/linux/buffer_head.h                        |    2 +-
 include/linux/cgroup-defs.h                        |    2 -
 include/linux/damon.h                              |   17 +-
 include/linux/dma-fence-chain.h                    |    4 +
 include/linux/fault-inject.h                       |   11 +-
 include/linux/gfp.h                                |    8 +
 include/linux/hid_bpf.h                            |    5 +
 include/linux/highmem-internal.h                   |   17 +-
 include/linux/highmem.h                            |    8 +-
 include/linux/huge_mm.h                            |   53 +-
 include/linux/hugetlb.h                            |   30 +-
 include/linux/jbd2.h                               |   10 +
 include/linux/kmsan.h                              |   76 +
 include/linux/kmsan_types.h                        |    2 +-
 include/linux/list_lru.h                           |    2 +-
 include/linux/memblock.h                           |    2 -
 include/linux/memcontrol.h                         |  363 +-
 include/linux/memfd.h                              |    5 +
 include/linux/memory-tiers.h                       |    2 +
 include/linux/memory_hotplug.h                     |    4 +-
 include/linux/migrate.h                            |   10 +-
 include/linux/migrate_mode.h                       |    6 +-
 include/linux/mm.h                                 |   81 +-
 include/linux/mm_types.h                           |   33 +-
 include/linux/mmzone.h                             |    2 +
 include/linux/page-flags.h                         |   82 +-
 include/linux/page_counter.h                       |    4 +
 include/linux/pagemap.h                            |   33 +-
 include/linux/percpu-defs.h                        |    6 +
 include/linux/pgalloc_tag.h                        |    7 +-
 include/linux/pgtable.h                            |   40 +-
 include/linux/rmap.h                               |   45 +-
 include/linux/sched.h                              |    9 +-
 include/linux/shmem_fs.h                           |    9 +
 include/linux/skbuff.h                             |    8 +
 include/linux/skmsg.h                              |    5 +
 include/linux/slab.h                               |   12 +-
 include/linux/swap.h                               |   14 +-
 include/linux/swapops.h                            |    4 +-
 include/linux/vmstat.h                             |    4 +
 include/linux/zswap.h                              |   10 +-
 include/ras/ras_event.h                            |    4 +-
 include/trace/events/kmem.h                        |    4 +-
 include/trace/events/migrate.h                     |    3 +-
 include/uapi/linux/fs.h                            |  158 +-
 init/Kconfig                                       |   18 +-
 kernel/bpf/memalloc.c                              |    9 +-
 kernel/bpf/syscall.c                               |    6 +-
 kernel/bpf/verifier.c                              |    4 +
 kernel/events/core.c                               |    2 +-
 kernel/events/uprobes.c                            |    2 +-
 kernel/exit.c                                      |   81 +-
 kernel/fork.c                                      |   18 +-
 kernel/power/swap.c                                |    5 +-
 kernel/trace/ftrace.c                              |    1 +
 lib/maple_tree.c                                   |   15 +-
 lib/test_hmm.c                                     |    1 +
 lib/test_maple_tree.c                              |    1 +
 lib/test_ubsan.c                                   |    1 +
 lib/test_xarray.c                                  |    1 +
 lib/zlib_dfltcc/dfltcc.h                           |    1 +
 lib/zlib_dfltcc/dfltcc_util.h                      |   28 +
 mm/Kconfig                                         |   23 +-
 mm/Makefile                                        |    2 +
 mm/balloon_compaction.c                            |    8 -
 mm/damon/core.c                                    |  338 +-
 mm/damon/dbgfs.c                                   |    2 +-
 mm/damon/lru_sort.c                                |   56 +-
 mm/damon/paddr.c                                   |  157 +
 mm/damon/reclaim.c                                 |   65 +-
 mm/damon/sysfs-common.h                            |    2 +-
 mm/damon/sysfs-schemes.c                           |  127 +-
 mm/damon/sysfs-test.h                              |   10 +-
 mm/damon/sysfs.c                                   |   81 +-
 mm/damon/vaddr.c                                   |    6 +-
 mm/dmapool_test.c                                  |    1 +
 mm/fail_page_alloc.c                               |    4 +-
 mm/failslab.c                                      |   14 +-
 mm/filemap.c                                       |    8 +-
 mm/folio-compat.c                                  |    6 -
 mm/gup.c                                           |  510 +--
 mm/highmem.c                                       |   21 +-
 mm/hmm.c                                           |    2 +-
 mm/huge_memory.c                                   |  193 +-
 mm/hugetlb.c                                       |  137 +-
 mm/hugetlb_cgroup.c                                |  305 +-
 mm/hugetlb_vmemmap.c                               |   17 +-
 mm/hwpoison-inject.c                               |    1 +
 mm/internal.h                                      |   75 +-
 mm/kfence/core.c                                   |   17 +-
 mm/kfence/kfence.h                                 |    2 +-
 mm/kfence/kfence_test.c                            |    1 +
 mm/khugepaged.c                                    |   40 +-
 mm/kmemleak.c                                      |    6 +-
 mm/kmsan/core.c                                    |    5 +-
 mm/kmsan/hooks.c                                   |   38 +-
 mm/kmsan/init.c                                    |    9 +-
 mm/kmsan/instrumentation.c                         |   15 +-
 mm/kmsan/kmsan.h                                   |   39 +-
 mm/kmsan/kmsan_test.c                              |   32 +
 mm/kmsan/report.c                                  |   10 +-
 mm/kmsan/shadow.c                                  |    9 +-
 mm/ksm.c                                           |  261 +-
 mm/list_lru.c                                      |   14 +-
 mm/madvise.c                                       |    2 +-
 mm/memcontrol-v1.c                                 | 2969 +++++++++++++
 mm/memcontrol-v1.h                                 |  147 +
 mm/memcontrol.c                                    | 4417 +++-------------=
----
 mm/memfd.c                                         |   45 +
 mm/memory-failure.c                                |  259 +-
 mm/memory-tiers.c                                  |   54 +-
 mm/memory.c                                        |  376 +-
 mm/memory_hotplug.c                                |   52 +-
 mm/mempolicy.c                                     |   38 +-
 mm/migrate.c                                       |  213 +-
 mm/migrate_device.c                                |   24 +-
 mm/mincore.c                                       |    4 +-
 mm/mlock.c                                         |   19 +-
 mm/mm_init.c                                       |   96 +-
 mm/mmap.c                                          |   41 +
 mm/mmap_lock.c                                     |  175 +-
 mm/mprotect.c                                      |    4 +-
 mm/mremap.c                                        |    2 +-
 mm/page-writeback.c                                |  319 +-
 mm/page_alloc.c                                    |   78 +-
 mm/page_counter.c                                  |  173 +
 mm/page_ext.c                                      |   32 +-
 mm/page_io.c                                       |   22 +-
 mm/pagewalk.c                                      |   57 +-
 mm/percpu-internal.h                               |    6 +-
 mm/percpu.c                                        |    6 +-
 mm/readahead.c                                     |  276 +-
 mm/rmap.c                                          |  169 +-
 mm/shmem.c                                         |  359 +-
 mm/slab.h                                          |    2 +-
 mm/slab_common.c                                   |   10 +-
 mm/slub.c                                          |   51 +-
 mm/sparse-vmemmap.c                                |    8 +
 mm/sparse.c                                        |   28 +-
 mm/swap.c                                          |   51 +-
 mm/swap.h                                          |   30 +-
 mm/swap_state.c                                    |  120 +-
 mm/swapfile.c                                      |   75 +-
 mm/truncate.c                                      |   70 +-
 mm/userfaultfd.c                                   |   14 +-
 mm/util.c                                          |   17 +
 mm/vmalloc.c                                       |    9 +-
 mm/vmscan.c                                        |  188 +-
 mm/vmstat.c                                        |   26 +-
 mm/zsmalloc.c                                      |  175 +-
 mm/zswap.c                                         |  126 +-
 samples/kmemleak/kmemleak-test.c                   |    1 +
 tools/include/uapi/linux/fs.h                      |  552 +++
 tools/include/uapi/linux/prctl.h                   |  331 ++
 tools/mm/Makefile                                  |    2 +-
 tools/mm/thp_swap_allocator_test.c                 |  234 ++
 tools/objtool/check.c                              |    2 +
 tools/testing/selftests/cgroup/config              |    1 -
 tools/testing/selftests/damon/Makefile             |    3 +-
 tools/testing/selftests/damon/_damon_sysfs.py      |   65 +-
 tools/testing/selftests/damon/access_memory.c      |    2 +-
 tools/testing/selftests/damon/access_memory_even.c |   42 +
 tools/testing/selftests/damon/damon_nr_regions.py  |  145 +
 .../testing/selftests/damon/damos_tried_regions.py |   65 +
 tools/testing/selftests/drivers/dma-buf/udmabuf.c  |  214 +-
 tools/testing/selftests/exec/Makefile              |    1 -
 tools/testing/selftests/futex/functional/Makefile  |    2 +-
 tools/testing/selftests/intel_pstate/Makefile      |    2 +-
 tools/testing/selftests/iommu/Makefile             |    2 -
 tools/testing/selftests/kvm/Makefile               |    2 +-
 tools/testing/selftests/lib.mk                     |    3 +
 tools/testing/selftests/mm/.gitignore              |    1 +
 tools/testing/selftests/mm/Makefile                |    3 +
 tools/testing/selftests/mm/hugepage-mremap.c       |    2 +-
 tools/testing/selftests/mm/hugetlb-soft-offline.c  |  228 +
 tools/testing/selftests/mm/hugetlb_dio.c           |  117 +
 tools/testing/selftests/mm/ksm_functional_tests.c  |    8 +-
 tools/testing/selftests/mm/memfd_secret.c          |   14 +-
 tools/testing/selftests/mm/mkdirty.c               |    8 +-
 tools/testing/selftests/mm/mlock2.h                |    1 +
 tools/testing/selftests/mm/mseal_helpers.h         |   41 +
 tools/testing/selftests/mm/mseal_test.c            |  143 +-
 tools/testing/selftests/mm/pagemap_ioctl.c         |    6 +-
 tools/testing/selftests/mm/protection_keys.c       |    2 +-
 tools/testing/selftests/mm/run_vmtests.sh          |    7 +
 tools/testing/selftests/mm/seal_elf.c              |   37 +-
 tools/testing/selftests/mm/split_huge_page_test.c  |    3 +-
 tools/testing/selftests/mm/thuge-gen.c             |   15 +-
 tools/testing/selftests/mm/uffd-common.c           |    4 -
 tools/testing/selftests/mm/uffd-stress.c           |   31 +-
 tools/testing/selftests/mm/uffd-unit-tests.c       |   14 +-
 tools/testing/selftests/mm/va_high_addr_switch.c   |  454 +-
 tools/testing/selftests/mm/va_high_addr_switch.sh  |    4 -
 tools/testing/selftests/net/Makefile               |    2 +-
 tools/testing/selftests/net/tcp_ao/Makefile        |    2 +-
 tools/testing/selftests/proc/Makefile              |    2 +-
 tools/testing/selftests/proc/proc-pid-vm.c         |   86 +
 tools/testing/selftests/resctrl/Makefile           |    2 +-
 tools/testing/selftests/ring-buffer/Makefile       |    1 -
 tools/testing/selftests/riscv/mm/Makefile          |    2 +-
 tools/testing/selftests/sgx/Makefile               |    2 +-
 tools/testing/selftests/tmpfs/Makefile             |    1 -
 330 files changed, 12969 insertions(+), 9745 deletions(-)
 delete mode 100644 arch/powerpc/include/asm/book3s/64/pgtable-4k.h
 create mode 100644 arch/powerpc/mm/nohash/tlb_64e.c
 create mode 100644 arch/s390/boot/kmsan.c
 create mode 100644 arch/s390/include/asm/kmsan.h
 create mode 100644 mm/memcontrol-v1.c
 create mode 100644 mm/memcontrol-v1.h
 create mode 100644 tools/include/uapi/linux/fs.h
 create mode 100644 tools/include/uapi/linux/prctl.h
 create mode 100644 tools/mm/thp_swap_allocator_test.c
 create mode 100644 tools/testing/selftests/damon/access_memory_even.c
 create mode 100644 tools/testing/selftests/damon/damon_nr_regions.py
 create mode 100644 tools/testing/selftests/damon/damos_tried_regions.py
 create mode 100644 tools/testing/selftests/mm/hugetlb-soft-offline.c
 create mode 100644 tools/testing/selftests/mm/hugetlb_dio.c
 create mode 100644 tools/testing/selftests/mm/mseal_helpers.h

