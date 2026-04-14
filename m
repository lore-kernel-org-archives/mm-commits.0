Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E8F123FC41;
	Tue, 14 Apr 2026 04:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776142197; cv=none; b=dR36l6ovQFZFY6fmiGRZgdW7PjIQAuGgC0BAQzm8CTZbgspt3fbAab1StOqYVl0mf4gG9Ke0Gg1Tcm87d51TycA68quIALMC8s12K6DohZ6C+wkFjQ8D4MurghfpGT51zs9CrkpRU5fg1C2LsELkG8g0t5+HGyuwrQemdYvoUmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776142197; c=relaxed/simple;
	bh=NbzZUJId1xxI9h7thAHns+cKLjbkB/dAs1mIMpj3/rE=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=OKXmeR7zpriC1mN4ac4sUBHXb6Brefs5L1p+ucZyjdCOXO5wpN2Sn+ifdW0q7ONpsb8ZxAxuSglg0bYUEEZyZz2NJY0gesZ8RaL00SFcOOFrJ5JUBUVj4xbdDkEJ9Y5xzKEjS6zJhk/VVVKVN5kk4ayvWG0S/TQeNYlEFcKsFnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gmtVsCo4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gmtVsCo4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D738C19425;
	Tue, 14 Apr 2026 04:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776142197;
	bh=NbzZUJId1xxI9h7thAHns+cKLjbkB/dAs1mIMpj3/rE=;
	h=Date:From:To:Cc:Subject:From;
	b=gmtVsCo41Jmx9GeSt6m7kwxaY8iL/e8quQHfpRFNuUCqWFd/JPbXS3JolJLHuqhHX
	 rE5DXnGu58ublZGr5o/aic8z7UTS0o05j8WK4+yRsublxfep1ddn1zf1OFOAPvJHAp
	 sNEXOP5xzDuSa03uKWvN0K0zLk58hc+v8eZgqsJg=
Date: Mon, 13 Apr 2026 21:49:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] MM updates for 7.1-rc1
Message-Id: <20260413214952.62836ac9df0eb348ee4aeb2b@linux-foundation.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable


Linus, plesae merge the first batch of MM updates for this merge window,
thanks.


I'm seeing no conflicts at this time.  Possible upcoming conflicts and
their linux-next resolutions include:

include/net/netmem.h, vs net tree:
	https://lkml.kernel.org/r/aaGiDINfnUexT9Px@sirena.org.uk

drivers/android/binder/page_range.rs, vs char-misc tree:
	https://lkml.kernel.org/r/aarPg_AVR3TN9frW@sirena.org.uk

virt/kvm/guest_memfd.c, vs kvm-x86 tree:
	https://lkml.kernel.org/r/abGDp4jguPV2H2Mf@sirena.org.uk

init/main.c, vs tip tree:
	https://lkml.kernel.org/r/abLMq8TWJIQH5uTj@sirena.org.uk

fs/f2fs/compress.c, vs fs-next tree:
	https://lkml.kernel.org/r/acPtrrkwagtafDT8@sirena.org.uk

lib/vdso/datastore.c, vs tip tree:
	https://lkml.kernel.org/r/acbz78Mbv55Vzfh8@sirena.co.uk

fs/ocfs2/dir.c, vs fs-next tree:
	https://lkml.kernel.org/r/adOxjbi2byrIet3y@sirena.org.uk



And two possible build issues:

fs/ntfs/file.c, vs fs-next tree:
	https://lkml.kernel.org/r/aa7ZT-cQMVdQOOAj@sirena.org.uk

fs/exfat/file.c, vs fs-next tree:
	https://lkml.kernel.org/r/acbY5CCmsk8C95m5@sirena.co.uk


The following changes since commit 24f9515de8778410e4b84c85b196c9850d2c1e18:

  Merge tag 'for-linus' of git://git.kernel.org/pub/scm/virt/kvm/kvm (2026-=
03-24 13:11:26 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2026=
-04-13-21-45

for you to fetch changes up to 3bac01168982ec3e3bf87efdc1807c7933590a85:

  mm: fix deferred split queue races during migration (2026-04-05 13:53:47 =
-0700)

----------------------------------------------------------------
mm.git review status for linus..mm-stable

Everything:

Total patches:       368
Reviews/patch:       1.56
Reviewed rate:       74%

Excluding DAMON:

Total patches:       316
Reviews/patch:       1.77
Reviewed rate:       81%

Excluding DAMON and zram:

Total patches:       306
Reviews/patch:       1.81
Reviewed rate:       82%

Excluding DAMON, zram and maple_tree:

Total patches:       276
Reviews/patch:       2.01
Reviewed rate:       91%

Significant patch series in this merge:

- The 30 patch series "maple_tree: Replace big node with maple copy"
  from Liam Howlett is mainly prepararatory work for ongoing development
  but it does reduce stack usage and is an improvement.

- The 12 patch series "mm, swap: swap table phase III: remove swap_map"
  from Kairui Song offers memory savings by removing the static swap_map.
  It also yields some CPU savings and implements several cleanups.

- The 2 patch series "mm: memfd_luo: preserve file seals" from Pratyush
  Yadav adds file seal preservation to LUO's memfd code.

- The 2 patch series "mm: zswap: add per-memcg stat for incompressible
  pages" from Jiayuan Chen adds additional userspace stats reportng to
  zswap.

- The 4 patch series "arch, mm: consolidate empty_zero_page" from Mike
  Rapoport implements some cleanups for our handling of ZERO_PAGE() and
  zero_pfn.

- The 2 patch series "mm/kmemleak: Improve scan_should_stop()
  implementation" from Zhongqiu Han provides an robustness improvement and
  some cleanups in the kmemleak code.

- The 4 patch series "Improve khugepaged scan logic" from Vernon Yang
  "improves the khugepaged scan logic and reduces CPU consumption by
  prioritizing scanning tasks that access memory frequently".

- The 2 patch series "Make KHO Stateless" from Jason Miu simplifies
  Kexec Handover by "transitioning KHO from an xarray-based metadata
  tracking system with serialization to a radix tree data structure that
  can be passed directly to the next kernel"

- The 3 patch series "mm: vmscan: add PID and cgroup ID to vmscan
  tracepoints" from Thomas Ballasi and Steven Rostedt enhances vmscan's
  tracepointing.

- The 5 patch series "mm: arch/shstk: Common shadow stack mapping helper
  and VM_NOHUGEPAGE" from Catalin Marinas is a cleanup for the shadow
  stack code: remove per-arch code in favour of a generic implementation.

- The 2 patch series "Fix KASAN support for KHO restored vmalloc
  regions" from Pasha Tatashin fixes a WARN() which can be emitted the KHO
  restores a vmalloc area.

- The 4 patch series "mm: Remove stray references to pagevec" from Tal
  Zussman provides several cleanups, mainly udpating references to "struct
  pagevec", which became folio_batch three years ago.

- The 17 patch series "mm: Eliminate fake head pages from vmemmap
  optimization" from Kiryl Shutsemau simplifies the HugeTLB vmemmap
  optimization (HVO) by changing how tail pages encode their relationship
  to the head page.

- The 2 patch series "mm/damon/core: improve DAMOS quota efficiency for
  core layer filters" from SeongJae Park improves two problematic
  behaviors of DAMOS that makes it less efficient when core layer filters
  are used.

- The 3 patch series "mm/damon: strictly respect min_nr_regions" from
  SeongJae Park improves DAMON usability by extending the treatment of the
  min_nr_regions user-settable parameter.

- The 3 patch series "mm/page_alloc: pcp locking cleanup" from Vlastimil
  Babka is a proper fix for a previously hotfixed SMP=3Dn issue.  Code
  simplifications and cleanups ennsed.

- The 16 patch series "mm: cleanups around unmapping / zapping" from
  David Hildenbrand implements "a bunch of cleanups around unmapping and
  zapping.  Mostly simplifications, code movements, documentation and
  renaming of zapping functions".

- The 6 patch series "support batched checking of the young flag for
  MGLRU" from Baolin Wang supports batched checking of the young flag for
  MGLRU.  It's part cleanups; one benchmark shows large performance
  benefits for arm64.

- The 5 patch series "memcg: obj stock and slab stat caching cleanups"
  from Johannes Weiner provides memcg cleanup and robustness improvements.

- The 5 patch series "Allow order zero pages in page reporting" from
  Yuvraj Sakshith enhances page_reporting's free page reporting - it is
  presently and undesirably order-0 pages when reporting free memory.

- The 6 patch series "mm: vma flag tweaks" from Lorenzo Stoakes is
  cleanup work following from the recent conversion of the VMA flags to a
  bitmap.

- The 10 patch series "mm/damon: add optional debugging-purpose sanity
  checks" from SeongJae Park adds some more developer-facing debug checks
  into DAMON core.

- The 2 patch series "mm/damon: test and document power-of-2
  min_region_sz requirement" from SeongJae Park adds an additional DAMON
  kunit test and makes some adjustments to the addr_unit parameter
  handling.

- The 3 patch series "mm/damon/core: make passed_sample_intervals
  comparisons overflow-safe" from SeongJae Park fixes a hard-to-hit time
  overflow issue in DAMON core.

- The 7 patch series "mm/damon: improve/fixup/update ratio calculation,
  test and documentation" from SeongJae Park is a "batch of misc/minor
  improvements and fixups" for DAMON.

- The 4 patch series "mm: move vma_(kernel|mmu)_pagesize() out of
  hugetlb.c" from David Hildenbrand fixes a possible issue with dax-device
  when CONFIG_HUGETLB=3Dn.  Some code movement was required.

- The 6 patch series "zram: recompression cleanups and tweaks" from
  Sergey Senozhatsky provides "a somewhat random mix of fixups,
  recompression cleanups and improvements" in the zram code.

- The 11 patch series "mm/damon: support multiple goal-based quota
  tuning algorithms" from SeongJae Park extend DAMOS quotas goal
  auto-tuning to support multiple tuning algorithms that users can select.

- The 4 patch series "mm: thp: reduce unnecessary
  start_stop_khugepaged()" from Breno Leitao fixes the khugpaged sysfs
  handling so we no longer spam the logs with reams of junk when
  starting/stopping khugepaged.

- The 3 patch series "mm: improve map count checks" from Lorenzo Stoakes
  provides some cleanups and slight fixes in the mremap, mmap and vma
  code.

- The 5 patch series "mm/damon: support addr_unit on default monitoring
  targets for modules" from SeongJae Park extends the use of DAMON core's
  addr_unit tunable.

- The 5 patch series "mm: khugepaged cleanups and mTHP prerequisites"
  from Nico Pache provides cleanups in the khugepaged and is a base for
  Nico's planned khugepaged mTHP support.

- The 15 patch series "mm: memory hot(un)plug and SPARSEMEM cleanups"
  from David Hildenbrand implements code movement and cleanups in the
  memhotplug and sparsemem code.

- The 2 patch series "mm: remove CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE and
  cleanup CONFIG_MIGRATION" from David Hildenbrand rationalizes some
  memhotplug Kconfig support.

- The 6 patch series "change young flag check functions to return bool"
  from Baolin Wang is "a cleanup patchset to change all young flag check
  functions to return bool".

- The 3 patch series "mm/damon/sysfs: fix memory leak and NULL
  dereference issues" from Josh Law and SeongJae Park fixes a few
  potential DAMON bugs.

- The 25 patch series "mm/vma: convert vm_flags_t to vma_flags_t in vma
  code" from "converts a lot of the existing use of the legacy vm_flags_t
  data type to the new vma_flags_t type which replaces it".  Mainly in the
  vma code.

- The 21 patch series "mm: expand mmap_prepare functionality and usage"
  from Lorenzo Stoakes "expands the mmap_prepare functionality, which is
  intended to replace the deprecated f_op->mmap hook which has been the
  source of bugs and security issues for some time".  Cleanups,
  documentation, extension of mmap_prepare into filesystem drivers.

- The 13 patch series "mm/huge_memory: refactor zap_huge_pmd()" from
  Lorenzo Stoakes simplifies and cleans up zap_huge_pmd().  Additional
  cleanups around vm_normal_folio_pmd() and the softleaf functionality are
  performed.

----------------------------------------------------------------
Akinobu Mita (1):
      docs: mm: fix typo in numa_memory_policy.rst

Alexandre Ghiti (1):
      mm/swap: fix swap cache memcg accounting

Altan Hacigumus (1):
      mm/shrinker: fix refcount leak in shrink_slab_memcg()

Andrey Ryabinin (1):
      kasan: fix bug type classification for SW_TAGS mode

AnishMulay (1):
      selftests/mm: skip migration tests if NUMA is unavailable

Anshuman Khandual (2):
      mm/debug_vm_pgtable: replace WRITE_ONCE() with pxd_clear()
      mm: replace READ_ONCE() in pud_trans_unstable()

Anthony Yznaga (1):
      mm: prevent droppable mappings from being locked

Arnd Bergmann (2):
      ubsan: turn off kmsan inside of ubsan instrumentation
      bug: avoid format attribute warning for clang as well

Asier Gutierrez (2):
      mm/damon: remove unused target param of get_scheme_score()
      Docs/mm/damon/design: document DAMON actions when TRANSPARENT_HUGEPAG=
E is off

Baolin Wang (12):
      mm: use inline helper functions instead of ugly macros
      mm: rename ptep/pmdp_clear_young_notify() to ptep/pmdp_test_and_clear=
_young_notify()
      mm: rmap: add a ZONE_DEVICE folio warning in folio_referenced()
      mm: add a batched helper to clear the young flag for large folios
      mm: support batched checking of the young flag for MGLRU
      arm64: mm: implement the architecture-specific test_and_clear_young_p=
tes()
      mm: change to return bool for ptep_test_and_clear_young()
      mm: change to return bool for ptep_clear_flush_young()/clear_flush_yo=
ung_ptes()
      mm: change to return bool for pmdp_test_and_clear_young()
      mm: change to return bool for pmdp_clear_flush_young()
      mm: change to return bool for pudp_test_and_clear_young()
      mm: change to return bool for the MMU notifier's young flag check

Bing Jiao (2):
      mm/vmscan: fix unintended mtc->nmask mutation in alloc_demote_folio()
      mm/memcontrol: fix reclaim_options leak in try_charge_memcg()

Breno Leitao (4):
      mm: khugepaged: export set_recommended_min_free_kbytes()
      mm: huge_memory: refactor anon_enabled_store() with set_anon_enabled_=
mode()
      mm: huge_memory: refactor enabled_store() with set_global_enabled_mod=
e()
      mm: ratelimit min_free_kbytes adjustment messages

Byungchul Park (1):
      mm: introduce a new page type for page pool in page type

Catalin Marinas (5):
      mm: introduce vm_mmap_shadow_stack() as a helper for VM_SHADOW_STACK =
mappings
      arm64: gcs: use the new common vm_mmap_shadow_stack() helper
      riscv: shstk: use the new common vm_mmap_shadow_stack() helper
      x86: shstk: use the new common vm_mmap_shadow_stack() helper
      mm: do not map the shadow stack as THP

Chen Ni (2):
      selftests/mm: remove duplicate include of unistd.h
      mm/swapfile: remove duplicate include of swap_table.h

Chengkaitao (1):
      sparc: use vmemmap_populate_hugepages for vmemmap_populate

David Hildenbrand (Arm) (41):
      mm: centralize+fix comments about compound_mapcount() in new sync_wit=
h_folio_pmd_zap()
      mm/pagewalk: drop FW_MIGRATION
      kasan: docs: SLUB is the only remaining slab implementation
      mm/madvise: drop range checks in madvise_free_single_vma()
      mm/memory: remove "zap_details" parameter from zap_page_range_single()
      mm/memory: inline unmap_mapping_range_vma() into unmap_mapping_range_=
tree()
      mm/memory: simplify calculation in unmap_mapping_range_tree()
      mm/oom_kill: use MMU_NOTIFY_CLEAR in __oom_reap_task_mm()
      mm/oom_kill: factor out zapping of VMA into zap_vma_for_reaping()
      mm/memory: rename unmap_single_vma() to __zap_vma_range()
      mm/memory: move adjusting of address range to unmap_vmas()
      mm/memory: convert details->even_cows into details->skip_cows
      mm/memory: use __zap_vma_range() in zap_vma_for_reaping()
      mm/memory: inline unmap_page_range() into __zap_vma_range()
      mm: rename zap_vma_pages() to zap_vma()
      mm: rename zap_page_range_single_batched() to zap_vma_range_batched()
      mm: rename zap_page_range_single() to zap_vma_range()
      mm: rename zap_vma_ptes() to zap_special_vma_range()
      mm/memory: support VM_MIXEDMAP in zap_special_vma_range()
      mm: move vma_kernel_pagesize() from hugetlb to mm.h
      mm: move vma_mmu_pagesize() from hugetlb to vma.c
      KVM: remove hugetlb.h inclusion
      KVM: PPC: remove hugetlb.h inclusion
      mm/memory_hotplug: fix possible race in scan_movable_pages()
      mm/memory_hotplug: remove for_each_valid_pfn() usage
      mm/sparse: remove WARN_ONs from (online|offline)_mem_sections()
      mm/Kconfig: make CONFIG_MEMORY_HOTPLUG depend on CONFIG_SPARSEMEM_VME=
MMAP
      mm/memory_hotplug: simplify check_pfn_span()
      mm/sparse: remove !CONFIG_SPARSEMEM_VMEMMAP leftovers for CONFIG_MEMO=
RY_HOTPLUG
      mm/bootmem_info: remove handling for !CONFIG_SPARSEMEM_VMEMMAP
      mm/bootmem_info: avoid using sparse_decode_mem_map()
      mm/sparse: remove sparse_decode_mem_map()
      mm/sparse: remove CONFIG_MEMORY_HOTPLUG-specific usemap allocation ha=
ndling
      mm: prepare to move subsection_map_init() to mm/sparse-vmemmap.c
      mm/sparse: drop set_section_nid() from sparse_add_section()
      mm/sparse: move sparse_init_one_section() to internal.h
      mm/sparse: move __section_mark_present() to internal.h
      mm/sparse: move memory hotplug bits to sparse-vmemmap.c
      mm: remove CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE
      mm: introduce CONFIG_NUMA_MIGRATION and simplify CONFIG_MIGRATION
      mm/memory: fix PMD/PUD checks in follow_pfnmap_start()

Dev Jain (1):
      khugepaged: remove redundant index check for pmd-folios

Frank van der Linden (1):
      mm/page_alloc: don't increase highatomic reserve after pcp alloc

Gladyshev Ilya (1):
      mm: make ref_unless functions unless_zero only

Gregory Price (1):
      mm: name the anonymous MMOP enum as enum mmop

Harry Yoo (Oracle) (1):
      MAINTAINERS, mailmap: update email address for Harry Yoo

Hubert Mazur (1):
      mm/execmem: make the populate and alloc atomic

Hui Zhu (1):
      mm/swap: strengthen locking assertions and invariants in cluster allo=
cation

JP Kobryn (Meta) (1):
      mm: move pgscan, pgsteal, pgrefill to node stats

Jane Chu (1):
      Documentation: fix a hugetlbfs reservation statement

Jason Miu (2):
      kho: adopt radix tree for preserved memory tracking
      kho: remove finalize state and clients

Jianhui Zhou (1):
      mm/userfaultfd: fix hugetlb fault mutex hash calculation

Jiaqi Yan (1):
      fs: hugetlb: simplify remove_inode_hugepages() return type

Jiayuan Chen (2):
      mm: zswap: add per-memcg stat for incompressible pages
      selftests/cgroup: add test for zswap incompressible pages

Jinjiang Tu (1):
      mm/huge_memory: fix folio isn't locked in softleaf_to_folio()

Johannes Weiner (7):
      mm: vmalloc: streamline vmalloc memory accounting
      mm: memcontrol: switch to native NR_VMALLOC vmstat counter
      mm: memcg: factor out trylock_stock() and unlock_stock()
      mm: memcg: simplify objcg charge size and stock remainder math
      mm: memcontrol: split out __obj_cgroup_charge()
      mm: memcontrol: use __account_obj_stock() in the !locked path
      mm: memcg: separate slab stat accounting from objcg charge cache

Josh Law (4):
      mm/damon/core: document damos_commit_dests() failure semantics
      mm/damon/sysfs: fix param_ctx leak on damon_sysfs_new_test_ctx() fail=
ure
      mm/damon/sysfs: check contexts->nr before accessing contexts_arr[0]
      mm/damon/sysfs: check contexts->nr in repeat_call_fn

Kairui Song (16):
      mm, swap: speed up hibernation allocation and writeout
      mm, swap: protect si->swap_file properly and use as a mount indicator
      mm, swap: clean up swapon process and locking
      mm, swap: remove redundant arguments and locking for enabling a device
      mm, swap: consolidate bad slots setup and make it more robust
      mm/workingset: leave highest bits empty for anon shadow
      mm, swap: implement helpers for reserving data in the swap table
      mm, swap: mark bad slots in swap table directly
      mm, swap: simplify swap table sanity range check
      mm, swap: use the swap table to track the swap count
      mm, swap: no need to truncate the scan border
      mm, swap: simplify checking if a folio is swapped
      mm, swap: no need to clear the shadow explicitly
      memcg: consolidate private id refcount get/put helpers
      mm/shmem: remove unnecessary restrain unmask of swap gfp flags
      mm/zswap: remove SWP_SYNCHRONOUS_IO swapcache bypass workaround

Kaitao Cheng (1):
      mm: mark early-init static variables with __meminitdata

Kevin Lourenco (1):
      mm/fadvise: validate offset in generic_fadvise

Kexin Sun (4):
      kasan: update outdated comment
      mm: vmalloc: update outdated comment for renamed vread()
      mm: update outdated comments for removed scan_swap_map_slots()
      drivers/base/memory: fix stale reference to memory_block_add_nid()

Kiryl Shutsemau (16):
      mm: move MAX_FOLIO_ORDER definition to mmzone.h
      mm: change the interface of prep_compound_tail()
      mm: rename the 'compound_head' field in the 'struct page' to 'compoun=
d_info'
      mm: move set/clear_compound_head() next to compound_head()
      riscv/mm: align vmemmap to maximal folio size
      LoongArch/mm: align vmemmap to maximal folio size
      mm: rework compound_head() for power-of-2 sizeof(struct page)
      mm/sparse: check memmap alignment for compound_info_has_mask()
      mm/hugetlb: refactor code around vmemmap_walk
      mm/hugetlb: remove fake head pages
      mm: drop fake head checks
      hugetlb: remove VMEMMAP_SYNCHRONIZE_RCU
      mm/hugetlb: remove hugetlb_optimize_vmemmap_key static key
      mm: remove the branch from compound_head()
      hugetlb: update vmemmap_dedup.rst
      mm/slab: use compound_head() in page_slab()

Kiryl Shutsemau (Meta) (2):
      mm/hugetlb: defer vmemmap population for bootmem hugepages
      x86/vdso: undefine CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP for vdso32

Lance Yang (2):
      mm/mmu_gather: replace IPI with synchronize_rcu() when batch allocati=
on fails
      mm: fix deferred split queue races during migration

Leno Hou (1):
      mm/mglru: fix cgroup OOM during MGLRU state switching

Li RongQing (1):
      mm/mmu_notifiers: use hlist_for_each_entry_srcu() for SRCU list trave=
rsal

Liam R. Howlett (30):
      maple_tree: fix mas_dup_alloc() sparse warning
      maple_tree: move mas_spanning_rebalance loop to function
      maple_tree: extract use of big node from mas_wr_spanning_store()
      maple_tree: remove unnecessary assignment of orig_l index
      maple_tree: inline mas_spanning_rebalance() into mas_wr_spanning_reba=
lance()
      maple_tree: make ma_wr_states reliable for reuse in spanning store
      maple_tree: remove l_wr_mas from mas_wr_spanning_rebalance
      maple_tree: don't pass through height in mas_wr_spanning_store
      maple_tree: move maple_subtree_state from mas_wr_spanning_store to ma=
s_wr_spanning_rebalance
      maple_tree: correct right ma_wr_state end pivot in mas_wr_spanning_st=
ore()
      maple_tree: introduce maple_copy node and use it in mas_spanning_reba=
lance()
      maple_tree: testing update for spanning store
      maple_tree: inline mas_spanning_rebalance_loop() into mas_wr_spanning=
_rebalance()
      maple_tree: change initial big node setup in mas_wr_spanning_rebalanc=
e()
      maple_tree: introduce ma_leaf_max_gap()
      maple_tree: add gap support, slot and pivot sizes for maple copy
      maple_tree: start using maple copy node for destination
      maple_tree: inline mas_wr_spanning_rebalance()
      maple_tree: remove unnecessary return statements
      maple_tree: separate wr_split_store and wr_rebalance store type code =
path
      maple_tree: add cp_is_new_root() helper
      maple_tree: use maple copy node for mas_wr_rebalance() operation
      maple_tree: add test for rebalance calculation off-by-one
      maple_tree: add copy_tree_location() helper
      maple_tree: add cp_converged() helper
      maple_tree: use maple copy node for mas_wr_split()
      maple_tree: remove maple big node and subtree structs
      maple_tree: pass maple copy node to mas_wmb_replace()
      maple_tree: don't pass end to mas_wr_append()
      maple_tree: clean up mas_wr_node_store()

Liew Rui Yan (2):
      Docs/mm/damon: document exclusivity of special-purpose modules
      Docs/mm/damon: document min_nr_regions constraint and rationale

Lorenzo Stoakes (Oracle) (70):
      mm: rename VMA flag helpers to be more readable
      mm: add vma_desc_test_all() and use it
      mm: always inline __mk_vma_flags() and invoked functions
      mm: reintroduce vma_flags_test() as a singular flag test
      mm: reintroduce vma_desc_test() as a singular flag test
      tools/testing/vma: add test for vma_flags_test(), vma_desc_test()
      mm/mremap: correct invalid map count check
      mm: abstract reading sysctl_max_map_count, and READ_ONCE()
      mm/mremap: check map count under mmap write lock and abstract
      mm/mseal: update VMA end correctly on merge
      mm/vma: add vma_flags_empty(), vma_flags_and(), vma_flags_diff_pair()
      tools/testing/vma: add unit tests flag empty, diff_pair, and[_mask]
      mm/vma: add further vma_flags_t unions
      tools/testing/vma: convert bulk of test code to vma_flags_t
      mm/vma: use new VMA flags for sticky flags logic
      tools/testing/vma: fix VMA flag tests
      mm/vma: add append_vma_flags() helper
      tools/testing/vma: add simple test for append_vma_flags()
      mm: unexport vm_brk_flags() and eliminate vm_flags parameter
      mm/vma: introduce vma_flags_same[_mask/_pair]()
      mm/vma: introduce [vma_flags,legacy]_to_[legacy,vma_flags]() helpers
      tools/testing/vma: test that legacy flag helpers work correctly
      mm/vma: introduce vma_test[_any[_mask]](), and make inlining consiste=
nt
      tools/testing/vma: update VMA flag tests to test vma_test[_any_mask]()
      mm: introduce vma_flags_count() and vma[_flags]_test_single_mask()
      tools/testing/vma: test vma_flags_count,vma[_flags]_test_single_mask
      mm: convert do_brk_flags() to use vma_flags_t
      mm: update vma_supports_mlock() to use new VMA flags
      mm/vma: introduce vma_clear_flags[_mask]()
      tools/testing/vma: update VMA tests to test vma_clear_flags[_mask]()
      mm/vma: convert as much as we can in mm/vma.c to vma_flags_t
      tools: bitmap: add missing bitmap_copy() implementation
      mm/vma: convert vma_modify_flags[_uffd]() to use vma_flags_t
      mm/vma: convert __mmap_region() to use vma_flags_t
      mm: simplify VMA flag tests of excluded flags
      mm: various small mmap_prepare cleanups
      mm: add documentation for the mmap_prepare file operation callback
      mm: document vm_operations_struct->open the same as close()
      mm: avoid deadlock when holding rmap on mmap_prepare error
      mm: switch the rmap lock held option off in compat layer
      mm/vma: remove superfluous map->hold_file_rmap_lock
      mm: have mmap_action_complete() handle the rmap lock and unmap
      mm: add vm_ops->mapped hook
      fs: afs: revert mmap_prepare() change
      fs: afs: restore mmap_prepare implementation
      mm: add mmap_action_simple_ioremap()
      misc: open-dice: replace deprecated mmap hook with mmap_prepare
      hpet: replace deprecated mmap hook with mmap_prepare
      mtdchar: replace deprecated mmap hook with mmap_prepare, clean up
      stm: replace deprecated mmap hook with mmap_prepare
      staging: vme_user: replace deprecated mmap hook with mmap_prepare
      mm: allow handling of stacked mmap_prepare hooks in more drivers
      drivers: hv: vmbus: replace deprecated mmap hook with mmap_prepare
      uio: replace deprecated mmap hook with mmap_prepare in uio_info
      mm: add mmap_action_map_kernel_pages[_full]()
      mm: on remap assert that input range within the proposed VMA
      mm/huge_memory: simplify vma_is_specal_huge()
      mm/huge: avoid big else branch in zap_huge_pmd()
      mm/huge_memory: have zap_huge_pmd return a boolean, add kdoc
      mm/huge_memory: handle buggy PMD entry in zap_huge_pmd()
      mm/huge_memory: add a common exit path to zap_huge_pmd()
      mm/huge_memory: remove unnecessary VM_BUG_ON_PAGE()
      mm/huge_memory: deduplicate zap deposited table call
      mm/huge_memory: remove unnecessary sanity checks
      mm/huge_memory: use mm instead of tlb->mm
      mm/huge_memory: separate out the folio part of zap_huge_pmd()
      mm: add softleaf_is_valid_pmd_entry(), pmd_to_softleaf_folio()
      mm/huge_memory: add and use normal_or_softleaf_folio_pmd()
      mm/huge_memory: add and use has_deposited_pgtable()
      mm/khugepaged: fix issue with tracking lock

Maninder Singh (1):
      mm/oom_kill.c: simpilfy rcu call with guard(rcu)

Marco Elver (1):
      kfence: add kfence.fault parameter

Max Boone (1):
      mm/pagewalk: fix race between concurrent split and refault

Michal Hocko (1):
      vmalloc: support __GFP_RETRY_MAYFAIL and __GFP_NORETRY

Michal Koutn=FD (1):
      mm: do not allocate shrinker info with cgroup.memory=3Dnokmem

Mike Rapoport (Microsoft) (5):
      mm: don't special case !MMU for is_zero_pfn() and my_zero_pfn()
      mm: rename my_zero_pfn() to zero_pfn()
      arch, mm: consolidate empty_zero_page
      mm: cache struct page for empty_zero_page and return it from ZERO_PAG=
E()
      selftests/mm: pagemap_ioctl: remove hungarian notation

Miquel Sabat=E9 Sol=E0 (1):
      mm: fix typo in the comment of mod_zone_state()

Nico Pache (5):
      mm: consolidate anonymous folio PTE mapping into helpers
      mm: introduce is_pmd_order helper
      mm/khugepaged: define KHUGEPAGED_MAX_PTES_LIMIT as HPAGE_PMD_NR - 1
      mm/khugepaged: rename hpage_collapse_* to collapse_*
      mm/khugepaged: unify khugepaged and madv_collapse with collapse_singl=
e_pmd()

Pasha Tatashin (2):
      mm/vmalloc: export clear_vm_uninitialized_flag()
      kho: fix KASAN support for restored vmalloc regions

Pratyush Yadav (1):
      kho: drop restriction on maximum page order

Pratyush Yadav (Google) (4):
      memfd: export memfd_{add,get}_seals()
      mm: memfd_luo: preserve file seals
      kho: move alloc tag init to kho_init_{folio,pages}()
      kho: make sure preservations do not span multiple NUMA nodes

Ritesh Harjani (IBM) (1):
      mm/kasan: fix double free for kasan pXds

SeongJae Park (44):
      mm/damon/core: set quota-score histogram with core filters
      mm/damon/core: do non-safe region walk on kdamond_apply_schemes()
      mm/damon/core: split regions for min_nr_regions
      mm/damon/vaddr: do not split regions for min_nr_regions
      mm/damon/test/core-kunit: add damon_apply_min_nr_regions() test
      mm/damon: add CONFIG_DAMON_DEBUG_SANITY
      mm/damon/core: add damon_new_region() debug_sanity check
      mm/damon/core: add damon_del_region() debug_sanity check
      mm/damon/core: add damon_nr_regions() debug_sanity check
      mm/damon/core: add damon_merge_two_regions() debug_sanity check
      mm/damon/core: add damon_merge_regions_of() debug_sanity check
      mm/damon/core: add damon_split_region_at() debug_sanity check
      mm/damon/core: add damon_reset_aggregated() debug_sanity check
      mm/damon/tests/.kunitconifg: enable DAMON_DEBUG_SANITY
      selftests/damon/config: enable DAMON_DEBUG_SANITY
      mm/damon/tests/core-kunit: add a test for damon_commit_ctx()
      Docs/mm/damon/design: document the power-of-two limitation for addr_u=
nit
      mm/damon/core: remove damos_set_next_apply_sis() duplicates
      mm/damon/core: use time_before() for next_apply_sis
      mm/damon/core: use time_after_eq() in kdamond_fn()
      mm/damon/core: use mult_frac()
      mm/damon/tests/core-kunit: add a test for damon_is_last_region()
      mm/damon/core: clarify damon_set_attrs() usages
      mm/damon: document non-zero length damon_region assumption
      Docs/admin-guide/mm/damn/lru_sort: fix intervals autotune parameter n=
ame
      Docs/mm/damon/maintainer-profile: use flexible review cadence
      Docs/mm/damon/index: fix typo: autoamted -> automated
      mm/damon/core: introduce damos_quota_goal_tuner
      mm/damon/core: allow quota goals set zero effective size quota
      mm/damon/core: introduce DAMOS_QUOTA_GOAL_TUNER_TEMPORAL
      mm/damon/sysfs-schemes: implement quotas->goal_tuner file
      Docs/mm/damon/design: document the goal-based quota tuner selections
      Docs/admin-guide/mm/damon/usage: document goal_tuner sysfs file
      Docs/ABI/damon: update for goal_tuner
      mm/damon/tests/core-kunit: test goal_tuner commit
      selftests/damon/_damon_sysfs: support goal_tuner setup
      selftests/damon/drgn_dump_damon_status: support quota goal_tuner dump=
ing
      selftests/damon/sysfs.py: test goal_tuner commit
      mm/damon/core: fix wrong end address assignment on walk_system_ram()
      mm/damon/core: support addr_unit on damon_find_biggest_system_ram()
      mm/damon/core: receive addr_unit on damon_set_region_biggest_system_r=
am_default()
      mm/damon/core: fix wrong damon_set_regions() argument
      mm/damon/reclaim: respect addr_unit on default monitoring region setup
      mm/damon/lru_sort: respect addr_unit on default monitoring region set=
up

Seongsu Park (1):
      mm/pkeys: remove unused tsk parameter from arch_set_user_pkey_access()

Sergey Senozhatsky (8):
      zram: do not permit params change after init
      zram: do not autocorrect bad recompression parameters
      zram: drop ->num_active_comps
      zram: update recompression documentation
      zram: remove chained recompression
      zram: unify and harden algo/priority params handling
      zram: propagate read_from_bdev_async() errors
      zram: change scan_slots to return void

Shengming Hu (1):
      mm/page_alloc: avoid overcounting bulk alloc in watermark check

Shigeru Yoshida (1):
      mm/zsmalloc: copy KMSAN metadata in zs_page_migrate()

Steven Rostedt (1):
      tracing: add __event_in_*irq() helpers

Tal Zussman (4):
      mm: remove stray references to struct pagevec
      fs: remove unncessary pagevec.h includes
      folio_batch: rename pagevec.h to folio_batch.h
      folio_batch: rename PAGEVEC_SIZE to FOLIO_BATCH_SIZE

Thomas Ballasi (2):
      mm: vmscan: add cgroup IDs to vmscan tracepoints
      mm: vmscan: add PIDs to vmscan tracepoints

Uladzislau Rezki (Sony) (1):
      mm/vmalloc: fix incorrect size reporting on allocation failure

Usama Arif (2):
      mm/migrate_device: document folio_get requirement before frozen PMD s=
plit
      mm: migrate: requeue destination folio on deferred split queue

Vernon Yang (6):
      mm: khugepaged: set to next mm direct when mm has MMF_DISABLE_THP_COM=
PLETELY
      mm: khugepaged: add trace_mm_khugepaged_scan event
      mm: khugepaged: refine scan progress number
      mm-khugepaged-refine-scan-progress-number-fix
      mm: add folio_test_lazyfree helper
      mm: khugepaged: skip lazy-free folios

Vlastimil Babka (3):
      mm/page_alloc: effectively disable pcp with CONFIG_SMP=3Dn
      mm/page_alloc: remove IRQ saving/restoring from pcp locking
      mm/page_alloc: remove pcpu_spin_* wrappers

Vlastimil Babka (SUSE) (1):
      MAINTAINERS: add mm-related procfs files to MM sections

Waiman Long (1):
      selftest: memcg: skip memcg_sock test if address family not supported

Ye Liu (1):
      mm: remove unused page_is_file_lru() function

Youngjun Park (1):
      MAINTAINERS: add Youngjun Park as reviewer for SWAP

Yuvraj Sakshith (5):
      mm/page_reporting: add PAGE_REPORTING_ORDER_UNSPECIFIED
      virtio_balloon: set unspecified page reporting order
      hv_balloon: set unspecified page reporting order
      mm/page_reporting: change PAGE_REPORTING_ORDER_UNSPECIFIED to -1
      mm/page_reporting: change page_reporting_order to PAGE_REPORTING_ORDE=
R_UNSPECIFIED

Zhongqiu Han (2):
      mm/kmemleak: remove unreachable return statement in scan_should_stop()
      mm/kmemleak: use PF_KTHREAD flag to detect kernel threads

Zi Yan (1):
      selftests/mm: add folio_split() and filemap_get_entry() race test

gao xu (2):
      zram: use statically allocated compression algorithm names
      zram: optimize LZ4 dictionary compression performance

qinyu (2):
      mm/damon/ops-common: remove redudnant mmu notifier call in pmdp mkold
      mm/page_idle.c: remove redundant mmu notifier in aging code

teawater (1):
      zsmalloc: return -EBUSY for zspage migration lock contention

xu xin (1):
      ksm: initialize the addr only once in rmap_walk_ksm

 .mailmap                                           |    1 +
 Documentation/ABI/testing/sysfs-kernel-mm-damon    |    6 +
 Documentation/admin-guide/blockdev/zram.rst        |   49 +-
 Documentation/admin-guide/cgroup-v2.rst            |    5 +
 Documentation/admin-guide/kdump/vmcoreinfo.rst     |    2 +-
 Documentation/admin-guide/kernel-parameters.txt    |    6 +
 Documentation/admin-guide/mm/damon/lru_sort.rst    |   13 +-
 Documentation/admin-guide/mm/damon/reclaim.rst     |    9 +
 Documentation/admin-guide/mm/damon/stat.rst        |    5 +
 Documentation/admin-guide/mm/damon/usage.rst       |   16 +-
 Documentation/admin-guide/mm/kho.rst               |   53 +-
 .../admin-guide/mm/numa_memory_policy.rst          |    2 +-
 Documentation/core-api/kho/abi.rst                 |    6 +
 Documentation/core-api/kho/index.rst               |   18 +-
 Documentation/dev-tools/kasan.rst                  |    3 -
 Documentation/dev-tools/kfence.rst                 |    7 +
 Documentation/driver-api/vme.rst                   |    2 +-
 Documentation/filesystems/index.rst                |    1 +
 Documentation/filesystems/mmap_prepare.rst         |  168 ++
 Documentation/mm/damon/design.rst                  |   33 +-
 Documentation/mm/damon/index.rst                   |    2 +-
 Documentation/mm/damon/maintainer-profile.rst      |    8 +-
 Documentation/mm/hugetlbfs_reserv.rst              |    2 +-
 Documentation/mm/vmemmap_dedup.rst                 |   62 +-
 MAINTAINERS                                        |    9 +-
 arch/alpha/include/asm/pgtable.h                   |    6 -
 arch/arc/include/asm/page.h                        |    2 +-
 arch/arc/include/asm/pgtable.h                     |    3 -
 arch/arc/mm/init.c                                 |    2 -
 arch/arm/include/asm/page.h                        |    2 +-
 arch/arm/include/asm/pgtable.h                     |    9 -
 arch/arm/mm/mmu.c                                  |    7 -
 arch/arm/mm/nommu.c                                |    7 -
 arch/arm64/Kconfig                                 |    1 -
 arch/arm64/include/asm/page.h                      |    7 +-
 arch/arm64/include/asm/pgtable.h                   |   55 +-
 arch/arm64/include/asm/pkeys.h                     |    3 +-
 arch/arm64/mm/contpte.c                            |   14 +-
 arch/arm64/mm/gcs.c                                |   14 +-
 arch/arm64/mm/init.c                               |    5 +
 arch/arm64/mm/mmu.c                                |    9 +-
 arch/csky/include/asm/pgtable.h                    |    3 -
 arch/csky/mm/init.c                                |    3 -
 arch/hexagon/include/asm/page.h                    |    2 +-
 arch/hexagon/include/asm/pgtable.h                 |    6 -
 arch/hexagon/kernel/head.S                         |    5 -
 arch/hexagon/kernel/hexagon_ksyms.c                |    1 -
 arch/loongarch/Kconfig                             |    1 -
 arch/loongarch/include/asm/page.h                  |    2 +-
 arch/loongarch/include/asm/pgtable.h               |   12 +-
 arch/loongarch/mm/init.c                           |    3 -
 arch/m68k/include/asm/pgtable_mm.h                 |    9 -
 arch/m68k/include/asm/pgtable_no.h                 |    7 -
 arch/m68k/mm/init.c                                |    9 -
 arch/m68k/mm/mcfmmu.c                              |    2 -
 arch/m68k/mm/motorola.c                            |    6 -
 arch/m68k/mm/sun3mmu.c                             |    2 -
 arch/microblaze/include/asm/pgtable.h              |   12 +-
 arch/microblaze/kernel/head.S                      |    4 -
 arch/microblaze/kernel/microblaze_ksyms.c          |    2 -
 arch/mips/include/asm/page.h                       |    2 +-
 arch/mips/mm/init.c                                |   11 +-
 arch/nios2/include/asm/page.h                      |    2 +-
 arch/nios2/include/asm/pgtable.h                   |    7 -
 arch/nios2/kernel/head.S                           |   10 -
 arch/nios2/kernel/nios2_ksyms.c                    |    1 -
 arch/openrisc/include/asm/pgtable.h                |    4 -
 arch/openrisc/kernel/head.S                        |    3 -
 arch/openrisc/kernel/or32_ksyms.c                  |    1 -
 arch/openrisc/mm/init.c                            |    3 -
 arch/parisc/include/asm/pgtable.h                  |   20 +-
 arch/parisc/kernel/cache.c                         |    8 +-
 arch/parisc/mm/init.c                              |    6 -
 arch/powerpc/Kconfig                               |    1 -
 arch/powerpc/include/asm/book3s/32/pgtable.h       |    4 +-
 arch/powerpc/include/asm/book3s/64/pgtable.h       |   26 +-
 arch/powerpc/include/asm/nohash/64/pgtable.h       |    2 +-
 arch/powerpc/include/asm/nohash/pgtable.h          |    4 +-
 arch/powerpc/include/asm/page.h                    |    4 +-
 arch/powerpc/include/asm/page_32.h                 |    2 +-
 arch/powerpc/include/asm/page_64.h                 |   12 +-
 arch/powerpc/include/asm/pgtable.h                 |    6 -
 arch/powerpc/include/asm/pkeys.h                   |    8 +-
 arch/powerpc/kvm/book3s_hv.c                       |    1 -
 arch/powerpc/mm/book3s64/pgtable.c                 |    8 +-
 arch/powerpc/mm/book3s64/pkeys.c                   |    3 +-
 arch/powerpc/mm/mem.c                              |    3 -
 arch/powerpc/platforms/book3s/vas-api.c            |    2 +-
 arch/powerpc/platforms/pseries/vas.c               |    2 +-
 arch/riscv/Kconfig                                 |    1 -
 arch/riscv/include/asm/page.h                      |    2 +-
 arch/riscv/include/asm/pgtable.h                   |   23 +-
 arch/riscv/kernel/usercfi.c                        |   12 +-
 arch/riscv/mm/init.c                               |    7 +-
 arch/riscv/mm/pgtable.c                            |    7 +-
 arch/s390/Kconfig                                  |    1 -
 arch/s390/include/asm/page.h                       |    2 +-
 arch/s390/include/asm/pgtable.h                    |   16 +-
 arch/s390/mm/gmap_helpers.c                        |    2 +-
 arch/s390/mm/init.c                                |    4 +-
 arch/sh/include/asm/pgtable.h                      |    8 -
 arch/sh/include/asm/setup.h                        |    3 +-
 arch/sh/kernel/head_32.S                           |    4 +-
 arch/sh/kernel/sh_ksyms_32.c                       |    1 -
 arch/sh/mm/init.c                                  |    1 -
 arch/sparc/include/asm/pgtable_32.h                |    8 -
 arch/sparc/include/asm/pgtable_64.h                |    3 -
 arch/sparc/include/asm/setup.h                     |    2 -
 arch/sparc/kernel/head_32.S                        |    7 -
 arch/sparc/mm/init_32.c                            |    4 -
 arch/sparc/mm/init_64.c                            |   71 +-
 arch/um/include/asm/pgtable.h                      |    9 -
 arch/um/include/shared/kern_util.h                 |    1 -
 arch/um/kernel/mem.c                               |   16 -
 arch/um/kernel/um_arch.c                           |    1 -
 arch/x86/Kconfig                                   |    1 -
 arch/x86/entry/vdso/vdso32/fake_32bit_build.h      |    1 +
 arch/x86/include/asm/page_types.h                  |    2 +-
 arch/x86/include/asm/pgtable.h                     |   28 +-
 arch/x86/include/asm/pkeys.h                       |    3 +-
 arch/x86/kernel/cpu/sgx/encl.c                     |    2 +-
 arch/x86/kernel/fpu/xstate.c                       |    3 +-
 arch/x86/kernel/head_32.S                          |    4 -
 arch/x86/kernel/head_64.S                          |    7 -
 arch/x86/kernel/shstk.c                            |   12 +-
 arch/x86/kvm/mmu/spte.h                            |    2 +-
 arch/x86/mm/pgtable.c                              |   28 +-
 arch/x86/mm/pkeys.c                                |    3 +-
 arch/x86/um/asm/vm-flags.h                         |    4 +-
 arch/xtensa/include/asm/pgtable.h                  |   13 +-
 arch/xtensa/kernel/head.S                          |    3 -
 arch/xtensa/kernel/xtensa_ksyms.c                  |    2 -
 drivers/android/binder/page_range.rs               |    4 +-
 drivers/android/binder_alloc.c                     |    2 +-
 drivers/base/memory.c                              |    4 +-
 drivers/block/zram/backend_lz4.c                   |   29 +-
 drivers/block/zram/zcomp.c                         |    9 +-
 drivers/block/zram/zcomp.h                         |    2 +-
 drivers/block/zram/zram_drv.c                      |  269 ++-
 drivers/block/zram/zram_drv.h                      |    1 -
 drivers/char/hpet.c                                |   12 +-
 drivers/char/mem.c                                 |    2 +-
 drivers/comedi/comedi_fops.c                       |    2 +-
 drivers/dax/device.c                               |    2 +-
 drivers/gpu/drm/drm_gem.c                          |    2 +-
 drivers/gpu/drm/i915/gem/i915_gem_shmem.c          |    2 +-
 drivers/gpu/drm/i915/gt/intel_gtt.h                |    2 +-
 drivers/gpu/drm/i915/i915_gpu_error.c              |    2 +-
 drivers/gpu/drm/i915/i915_mm.c                     |    4 +-
 drivers/hv/hv_balloon.c                            |    2 +-
 drivers/hv/hyperv_vmbus.h                          |    4 +-
 drivers/hv/vmbus_drv.c                             |   31 +-
 drivers/hwtracing/stm/core.c                       |   31 +-
 drivers/infiniband/core/uverbs_main.c              |    6 +-
 drivers/misc/open-dice.c                           |   19 +-
 drivers/misc/sgi-gru/grumain.c                     |    2 +-
 drivers/mtd/mtdchar.c                              |   21 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c   |    2 +-
 drivers/staging/vme_user/vme.c                     |   20 +-
 drivers/staging/vme_user/vme.h                     |    2 +-
 drivers/staging/vme_user/vme_user.c                |   51 +-
 drivers/target/target_core_user.c                  |   26 +-
 drivers/uio/uio.c                                  |   10 +-
 drivers/uio/uio_hv_generic.c                       |   11 +-
 drivers/virtio/virtio_balloon.c                    |   10 +-
 fs/afs/file.c                                      |   36 +-
 fs/afs/internal.h                                  |    1 -
 fs/afs/write.c                                     |    1 -
 fs/binfmt_elf.c                                    |    3 +-
 fs/btrfs/compression.c                             |    2 +-
 fs/btrfs/extent_io.c                               |    6 +-
 fs/btrfs/tests/extent-io-tests.c                   |    2 +-
 fs/buffer.c                                        |    2 +-
 fs/ceph/addr.c                                     |    2 +-
 fs/dax.c                                           |    3 +-
 fs/erofs/data.c                                    |    3 +-
 fs/ext4/file.c                                     |    1 -
 fs/ext4/inode.c                                    |    2 +-
 fs/ext4/page-io.c                                  |    1 -
 fs/ext4/readpage.c                                 |    1 -
 fs/f2fs/checkpoint.c                               |    2 +-
 fs/f2fs/compress.c                                 |    2 +-
 fs/f2fs/data.c                                     |    2 +-
 fs/f2fs/f2fs.h                                     |    2 -
 fs/f2fs/file.c                                     |    1 -
 fs/f2fs/node.c                                     |    2 +-
 fs/gfs2/aops.c                                     |    2 +-
 fs/hugetlbfs/inode.c                               |   22 +-
 fs/mpage.c                                         |    1 -
 fs/netfs/buffered_write.c                          |    1 -
 fs/nfs/blocklayout/blocklayout.c                   |    1 -
 fs/nfs/dir.c                                       |    1 -
 fs/nilfs2/btree.c                                  |    2 +-
 fs/nilfs2/page.c                                   |    2 +-
 fs/nilfs2/segment.c                                |    2 +-
 fs/ntfs3/file.c                                    |    2 +-
 fs/ocfs2/refcounttree.c                            |    1 -
 fs/proc/meminfo.c                                  |    3 +-
 fs/proc/vmcore.c                                   |    2 +-
 fs/pstore/ram_core.c                               |    2 +-
 fs/ramfs/file-nommu.c                              |    2 +-
 fs/resctrl/pseudo_lock.c                           |    2 +-
 fs/smb/client/connect.c                            |    1 -
 fs/smb/client/file.c                               |    1 -
 fs/zonefs/file.c                                   |    3 +-
 include/asm-generic/tlb.h                          |    4 +
 include/linux/damon.h                              |   18 +-
 include/linux/dax.h                                |    4 +-
 include/linux/{pagevec.h =3D> folio_batch.h}         |   16 +-
 include/linux/folio_queue.h                        |    8 +-
 include/linux/fs.h                                 |   14 +-
 include/linux/huge_mm.h                            |   13 +-
 include/linux/hugetlb.h                            |   31 +-
 include/linux/hugetlb_inline.h                     |    4 +-
 include/linux/hyperv.h                             |    4 +-
 include/linux/iomap.h                              |    2 +-
 include/linux/kasan.h                              |    8 +-
 include/linux/kho/abi/kexec_handover.h             |  144 +-
 include/linux/kho/abi/memfd.h                      |   18 +-
 include/linux/kho_radix_tree.h                     |   70 +
 include/linux/ksm.h                                |   10 +-
 include/linux/leafops.h                            |   71 +-
 include/linux/maple_tree.h                         |   42 +
 include/linux/memcontrol.h                         |    2 +-
 include/linux/memfd.h                              |   12 +
 include/linux/memory-tiers.h                       |    2 +-
 include/linux/memory.h                             |    3 +-
 include/linux/memory_hotplug.h                     |   18 +-
 include/linux/mm.h                                 |  716 +++++--
 include/linux/mm_inline.h                          |   16 +-
 include/linux/mm_types.h                           |   91 +-
 include/linux/mman.h                               |   49 -
 include/linux/mmu_notifier.h                       |  130 +-
 include/linux/mmzone.h                             |   82 +-
 include/linux/page-flags.h                         |  163 +-
 include/linux/page_ref.h                           |   18 +-
 include/linux/page_reporting.h                     |    1 +
 include/linux/pagewalk.h                           |    8 +-
 include/linux/pgtable.h                            |  139 +-
 include/linux/sunrpc/svc.h                         |    2 +-
 include/linux/swap.h                               |   30 +-
 include/linux/types.h                              |    2 +-
 include/linux/uio_driver.h                         |    4 +-
 include/linux/userfaultfd_k.h                      |    3 +
 include/linux/vm_event_item.h                      |   13 -
 include/linux/vmalloc.h                            |    3 -
 include/linux/writeback.h                          |    2 +-
 include/net/netmem.h                               |   15 +-
 include/trace/events/huge_memory.h                 |   26 +
 include/trace/events/vmscan.h                      |   95 +-
 include/trace/stages/stage3_trace_output.h         |    8 +
 include/trace/stages/stage7_class_define.h         |   19 +
 init/Kconfig                                       |    2 +-
 kernel/bpf/arena.c                                 |    3 +-
 kernel/events/core.c                               |    2 +-
 kernel/liveupdate/kexec_handover.c                 |  679 ++++---
 kernel/liveupdate/kexec_handover_debugfs.c         |   26 +-
 kernel/liveupdate/kexec_handover_internal.h        |    3 -
 kernel/liveupdate/luo_core.c                       |   12 +-
 kernel/vmcore_info.c                               |    2 +-
 lib/Makefile                                       |    1 +
 lib/bug.c                                          |    7 +-
 lib/maple_tree.c                                   | 2134 +++++++++-------=
----
 lib/test_maple_tree.c                              |   55 +-
 lib/vdso/datastore.c                               |    2 +-
 mm/Kconfig                                         |   35 +-
 mm/bootmem_info.c                                  |   46 +-
 mm/damon/Kconfig                                   |   11 +
 mm/damon/core.c                                    |  362 +++-
 mm/damon/lru_sort.c                                |    7 +-
 mm/damon/ops-common.c                              |    2 +-
 mm/damon/paddr.c                                   |    3 +-
 mm/damon/reclaim.c                                 |    7 +-
 mm/damon/sysfs-schemes.c                           |   58 +
 mm/damon/sysfs.c                                   |   10 +-
 mm/damon/tests/.kunitconfig                        |    3 +
 mm/damon/tests/core-kunit.h                        |  100 +
 mm/damon/tests/vaddr-kunit.h                       |   76 -
 mm/damon/vaddr.c                                   |   73 +-
 mm/debug_vm_pgtable.c                              |    4 +-
 mm/execmem.c                                       |   55 +-
 mm/fadvise.c                                       |    2 +-
 mm/filemap.c                                       |    2 +-
 mm/gup.c                                           |    2 +-
 mm/huge_memory.c                                   |  337 ++--
 mm/hugetlb.c                                       |   48 +-
 mm/hugetlb_vmemmap.c                               |  360 ++--
 mm/internal.h                                      |  217 +-
 mm/interval_tree.c                                 |    5 -
 mm/kasan/init.c                                    |    8 +-
 mm/kasan/report.c                                  |   13 +-
 mm/kfence/core.c                                   |   23 +-
 mm/kfence/kfence.h                                 |   16 +-
 mm/kfence/report.c                                 |   49 +-
 mm/khugepaged.c                                    |  304 +--
 mm/kmemleak.c                                      |    6 +-
 mm/ksm.c                                           |   50 +-
 mm/madvise.c                                       |   34 +-
 mm/memcontrol-v1.c                                 |    5 +-
 mm/memcontrol-v1.h                                 |    4 +-
 mm/memcontrol.c                                    |  246 ++-
 mm/memfd.c                                         |    4 +-
 mm/memfd_luo.c                                     |   35 +-
 mm/memory-tiers.c                                  |   12 +-
 mm/memory.c                                        |  500 +++--
 mm/memory_hotplug.c                                |   45 +-
 mm/mempolicy.c                                     |    4 +-
 mm/migrate.c                                       |   24 +-
 mm/migrate_device.c                                |    4 +
 mm/mlock.c                                         |   46 +-
 mm/mm_init.c                                       |   34 +-
 mm/mmap.c                                          |   21 +-
 mm/mmu_gather.c                                    |   21 +-
 mm/mmu_notifier.c                                  |   41 +-
 mm/mprotect.c                                      |   51 +-
 mm/mremap.c                                        |  106 +-
 mm/mseal.c                                         |   14 +-
 mm/nommu.c                                         |    2 +-
 mm/oom_kill.c                                      |   24 +-
 mm/page-writeback.c                                |    4 +-
 mm/page_alloc.c                                    |  205 +-
 mm/page_idle.c                                     |    2 +-
 mm/page_io.c                                       |    4 +-
 mm/page_reporting.c                                |    7 +-
 mm/page_vma_mapped.c                               |   11 +-
 mm/pagewalk.c                                      |   65 +-
 mm/pgtable-generic.c                               |   14 +-
 mm/rmap.c                                          |   38 +-
 mm/secretmem.c                                     |    2 +-
 mm/shmem.c                                         |   17 +-
 mm/shrinker.c                                      |   14 +-
 mm/slab.h                                          |    8 +-
 mm/sparse-vmemmap.c                                |  414 +++-
 mm/sparse.c                                        |  544 +----
 mm/swap.c                                          |    4 +-
 mm/swap.h                                          |   22 +-
 mm/swap_state.c                                    |   85 +-
 mm/swap_table.h                                    |  138 +-
 mm/swapfile.c                                      | 1150 +++++------
 mm/truncate.c                                      |    8 +-
 mm/userfaultfd.c                                   |   27 +-
 mm/util.c                                          |  296 ++-
 mm/vma.c                                           |  289 +--
 mm/vma.h                                           |   86 +-
 mm/vma_exec.c                                      |    5 +-
 mm/vmalloc.c                                       |   58 +-
 mm/vmscan.c                                        |  157 +-
 mm/vmstat.c                                        |   29 +-
 mm/workingset.c                                    |   49 +-
 mm/zsmalloc.c                                      |   15 +-
 mm/zswap.c                                         |   19 +-
 net/core/netmem_priv.h                             |   23 +-
 net/core/page_pool.c                               |   24 +-
 net/ipv4/tcp.c                                     |    7 +-
 rust/kernel/mm/virt.rs                             |    6 +-
 security/selinux/hooks.c                           |    4 +-
 tools/include/linux/bitmap.h                       |   24 +
 tools/lib/bitmap.c                                 |   10 +
 tools/testing/radix-tree/maple.c                   |  308 ++-
 tools/testing/selftests/cgroup/test_memcontrol.c   |   11 +-
 tools/testing/selftests/cgroup/test_zswap.c        |  136 ++
 tools/testing/selftests/damon/_damon_sysfs.py      |   12 +-
 tools/testing/selftests/damon/config               |    1 +
 .../selftests/damon/drgn_dump_damon_status.py      |    1 +
 tools/testing/selftests/damon/sysfs.py             |    7 +
 tools/testing/selftests/kho/init.c                 |   20 -
 tools/testing/selftests/mm/.gitignore              |    1 +
 tools/testing/selftests/mm/Makefile                |    1 +
 tools/testing/selftests/mm/folio_split_race_test.c |  297 +++
 tools/testing/selftests/mm/memory-failure.c        |    1 -
 tools/testing/selftests/mm/migration.c             |    3 +-
 tools/testing/selftests/mm/pagemap_ioctl.c         |   20 +-
 tools/testing/selftests/mm/run_vmtests.sh          |    2 +
 tools/testing/vma/include/custom.h                 |   26 +-
 tools/testing/vma/include/dup.h                    |  492 +++--
 tools/testing/vma/include/stubs.h                  |   24 +-
 tools/testing/vma/main.c                           |    2 +
 tools/testing/vma/shared.c                         |    8 +-
 tools/testing/vma/shared.h                         |   22 +-
 tools/testing/vma/tests/merge.c                    |  311 +--
 tools/testing/vma/tests/mmap.c                     |   18 +-
 tools/testing/vma/tests/vma.c                      |  395 +++-
 tools/testing/vma/vma_internal.h                   |    6 +
 virt/kvm/kvm_main.c                                |   32 +-
 384 files changed, 9624 insertions(+), 7022 deletions(-)
 create mode 100644 Documentation/filesystems/mmap_prepare.rst
 rename include/linux/{pagevec.h =3D> folio_batch.h} (89%)
 create mode 100644 include/linux/kho_radix_tree.h
 create mode 100644 tools/testing/selftests/mm/folio_split_race_test.c

