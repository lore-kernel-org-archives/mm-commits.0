Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99729C433E7
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:47:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D17B21D7B
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602632821;
	bh=YFm1wzf5j7BTi53mAoq/fqdZkMwIuMTUH93iI3GLQxQ=;
	h=Date:From:To:Cc:Subject:Reply-To:List-ID:From;
	b=ChCMSG/I/eL3aNZrNGR3hzlw8QAmnRByhELt3mD/X+u9D3ThKawYHzFIkIOq5spZA
	 HX3pqYXnXABOW0FhsLc19NNFNQ14ncQex1FlbhmuG1S5QqVtcDg6dZc4uuPbuVaKp+
	 nh9z14lcf5Ca+c74NGO2WgK1uUMNrWSASeYrWJgY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729871AbgJMXrA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:47:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:58584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729851AbgJMXrA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:47:00 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E83A521582;
        Tue, 13 Oct 2020 23:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602632819;
        bh=YFm1wzf5j7BTi53mAoq/fqdZkMwIuMTUH93iI3GLQxQ=;
        h=Date:From:To:Cc:Subject:From;
        b=zBt/3ig5xy8Q8iNUHpylEgaGYON12mnrI38AXM3WwYDVo+zhqBROKs1M1VGQEexvU
         J0UQPLCPepQm5deFZDKrwTBzbap1sKBVLxMrcZyccfdVWOpXnyAKnuEpLAgNarIP3l
         bQCOk7+0OYPttMnjX19Bv3jNaia9NF8u3Odk7OBw=
Date:   Tue, 13 Oct 2020 16:46:58 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, linux-mm@kvack.org
Subject: incoming
Message-Id: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

181 patches, based on 029f56db6ac248769f2c260bfaf3c3c0e23e904c.

Subsystems affected by this patch series:

  kbuild
  scripts
  ntfs
  ocfs2
  vfs
  mm/slab
  mm/slub
  mm/kmemleak
  mm/dax
  mm/debug
  mm/pagecache
  mm/fadvise
  mm/gup
  mm/swap
  mm/memremap
  mm/memcg
  mm/selftests
  mm/pagemap
  mm/mincore
  mm/hmm
  mm/dma
  mm/memory-failure
  mm/vmalloc
  mm/documentation
  mm/kasan
  mm/pagealloc
  mm/hugetlb
  mm/vmscan
  mm/z3fold
  mm/zbud
  mm/compaction
  mm/mempolicy
  mm/mempool
  mm/memblock
  mm/oom-kill
  mm/migration

Subsystem: kbuild

    Nick Desaulniers <ndesaulniers@google.com>:
    Patch series "set clang minimum version to 10.0.1", v3:
      compiler-clang: add build check for clang 10.0.1
      Revert "kbuild: disable clang's default use of -fmerge-all-constants"
      Revert "arm64: bti: Require clang >= 10.0.1 for in-kernel BTI support"
      Revert "arm64: vdso: Fix compilation with clang older than 8"
      Partially revert "ARM: 8905/1: Emit __gnu_mcount_nc when using Clang 10.0.0 or newer"

    Marco Elver <elver@google.com>:
      kasan: remove mentions of unsupported Clang versions

    Nick Desaulniers <ndesaulniers@google.com>:
      compiler-gcc: improve version error
      compiler.h: avoid escaped section names
      export.h: fix section name for CONFIG_TRIM_UNUSED_KSYMS for Clang

    Lukas Bulwahn <lukas.bulwahn@gmail.com>:
      kbuild: doc: describe proper script invocation

Subsystem: scripts

    Wang Qing <wangqing@vivo.com>:
      scripts/spelling.txt: increase error-prone spell checking

    Naoki Hayama <naoki.hayama@lineo.co.jp>:
      scripts/spelling.txt: add "arbitrary" typo

    Borislav Petkov <bp@suse.de>:
      scripts/decodecode: add the capability to supply the program counter

Subsystem: ntfs

    Rustam Kovhaev <rkovhaev@gmail.com>:
      ntfs: add check for mft record size in superblock

Subsystem: ocfs2

    Randy Dunlap <rdunlap@infradead.org>:
      ocfs2: delete repeated words in comments

    Gang He <ghe@suse.com>:
      ocfs2: fix potential soft lockup during fstrim

Subsystem: vfs

    Randy Dunlap <rdunlap@infradead.org>:
      fs/xattr.c: fix kernel-doc warnings for setxattr & removexattr

    Luo Jiaxing <luojiaxing@huawei.com>:
      fs_parse: mark fs_param_bad_value() as static

Subsystem: mm/slab

    Mateusz Nosek <mateusznosek0@gmail.com>:
      mm/slab.c: clean code by removing redundant if condition

    tangjianqiang <wyqt1985@gmail.com>:
      include/linux/slab.h: fix a typo error in comment

Subsystem: mm/slub

    Abel Wu <wuyun.wu@huawei.com>:
      mm/slub.c: branch optimization in free slowpath
      mm/slub: fix missing ALLOC_SLOWPATH stat when bulk alloc
      mm/slub: make add_full() condition more explicit

Subsystem: mm/kmemleak

    Davidlohr Bueso <dave@stgolabs.net>:
      mm/kmemleak: rely on rcu for task stack scanning

    Hui Su <sh_def@163.com>:
      mm,kmemleak-test.c: move kmemleak-test.c to samples dir

Subsystem: mm/dax

    Dan Williams <dan.j.williams@intel.com>:
    Patch series "device-dax: Support sub-dividing soft-reserved ranges", v5:
      x86/numa: cleanup configuration dependent command-line options
      x86/numa: add 'nohmat' option
      efi/fake_mem: arrange for a resource entry per efi_fake_mem instance
      ACPI: HMAT: refactor hmat_register_target_device to hmem_register_device
      resource: report parent to walk_iomem_res_desc() callback
      mm/memory_hotplug: introduce default phys_to_target_node() implementation
      ACPI: HMAT: attach a device for each soft-reserved range
      device-dax: drop the dax_region.pfn_flags attribute
      device-dax: move instance creation parameters to 'struct dev_dax_data'
      device-dax: make pgmap optional for instance creation
      device-dax/kmem: introduce dax_kmem_range()
      device-dax/kmem: move resource name tracking to drvdata
      device-dax/kmem: replace release_resource() with release_mem_region()
      device-dax: add an allocation interface for device-dax instances
      device-dax: introduce 'struct dev_dax' typed-driver operations
      device-dax: introduce 'seed' devices
      drivers/base: make device_find_child_by_name() compatible with sysfs inputs
      device-dax: add resize support
      mm/memremap_pages: convert to 'struct range'
      mm/memremap_pages: support multiple ranges per invocation
      device-dax: add dis-contiguous resource support
      device-dax: introduce 'mapping' devices

    Joao Martins <joao.m.martins@oracle.com>:
      device-dax: make align a per-device property

    Dan Williams <dan.j.williams@intel.com>:
      device-dax: add an 'align' attribute

    Joao Martins <joao.m.martins@oracle.com>:
      dax/hmem: introduce dax_hmem.region_idle parameter
      device-dax: add a range mapping allocation attribute

Subsystem: mm/debug

    "Matthew Wilcox (Oracle)" <willy@infradead.org>:
      mm/debug.c: do not dereference i_ino blindly

    John Hubbard <jhubbard@nvidia.com>:
      mm, dump_page: rename head_mapcount() --> head_compound_mapcount()

Subsystem: mm/pagecache

    "Matthew Wilcox (Oracle)" <willy@infradead.org>:
    Patch series "Return head pages from find_*_entry", v2:
      mm: factor find_get_incore_page out of mincore_page
      mm: use find_get_incore_page in memcontrol
      mm: optimise madvise WILLNEED
      proc: optimise smaps for shmem entries
      i915: use find_lock_page instead of find_lock_entry
      mm: convert find_get_entry to return the head page
      mm/shmem: return head page from find_lock_entry
      mm: add find_lock_head
      mm/filemap: fix filemap_map_pages for THP

Subsystem: mm/fadvise

    Yafang Shao <laoar.shao@gmail.com>:
      mm, fadvise: improve the expensive remote LRU cache draining after FADV_DONTNEED

Subsystem: mm/gup

    Barry Song <song.bao.hua@hisilicon.com>:
      mm/gup_benchmark: update the documentation in Kconfig
      mm/gup_benchmark: use pin_user_pages for FOLL_LONGTERM flag
      mm/gup: don't permit users to call get_user_pages with FOLL_LONGTERM

    John Hubbard <jhubbard@nvidia.com>:
      mm/gup: protect unpin_user_pages() against npages==-ERRNO

Subsystem: mm/swap

    Gao Xiang <hsiangkao@redhat.com>:
      swap: rename SWP_FS to SWAP_FS_OPS to avoid ambiguity

    Yu Zhao <yuzhao@google.com>:
      mm: remove activate_page() from unuse_pte()
      mm: remove superfluous __ClearPageActive()

    Miaohe Lin <linmiaohe@huawei.com>:
      mm/swap.c: fix confusing comment in release_pages()
      mm/swap_slots.c: remove always zero and unused return value of enable_swap_slots_cache()
      mm/page_io.c: remove useless out label in __swap_writepage()
      mm/swap.c: fix incomplete comment in lru_cache_add_inactive_or_unevictable()
      mm/swapfile.c: remove unnecessary goto out in _swap_info_get()
      mm/swapfile.c: fix potential memory leak in sys_swapon

Subsystem: mm/memremap

    Ira Weiny <ira.weiny@intel.com>:
      mm/memremap.c: convert devmap static branch to {inc,dec}

Subsystem: mm/memcg

    "Gustavo A. R. Silva" <gustavoars@kernel.org>:
      mm: memcontrol: use flex_array_size() helper in memcpy()
      mm: memcontrol: use the preferred form for passing the size of a structure type

    Roman Gushchin <guro@fb.com>:
      mm: memcg/slab: fix racy access to page->mem_cgroup in mem_cgroup_from_obj()

    Miaohe Lin <linmiaohe@huawei.com>:
      mm: memcontrol: correct the comment of mem_cgroup_iter()

    Waiman Long <longman@redhat.com>:
    Patch series "mm/memcg: Miscellaneous cleanups and streamlining", v2:
      mm/memcg: clean up obsolete enum charge_type
      mm/memcg: simplify mem_cgroup_get_max()
      mm/memcg: unify swap and memsw page counters

    Muchun Song <songmuchun@bytedance.com>:
      mm: memcontrol: add the missing numa_stat interface for cgroup v2

    Miaohe Lin <linmiaohe@huawei.com>:
      mm/page_counter: correct the obsolete func name in the comment of page_counter_try_charge()
      mm: memcontrol: reword obsolete comment of mem_cgroup_unmark_under_oom()

    Bharata B Rao <bharata@linux.ibm.com>:
      mm: memcg/slab: uncharge during kmem_cache_free_bulk()

    Ralph Campbell <rcampbell@nvidia.com>:
      mm/memcg: fix device private memcg accounting

Subsystem: mm/selftests

    John Hubbard <jhubbard@nvidia.com>:
    Patch series "selftests/vm: fix some minor aggravating factors in the Makefile":
      selftests/vm: fix false build success on the second and later attempts
      selftests/vm: fix incorrect gcc invocation in some cases

Subsystem: mm/pagemap

    Matthew Wilcox <willy@infradead.org>:
      mm: account PMD tables like PTE tables

    Yanfei Xu <yanfei.xu@windriver.com>:
      mm/memory.c: fix typo in __do_fault() comment
      mm/memory.c: replace vmf->vma with variable vma

    Wei Yang <richard.weiyang@linux.alibaba.com>:
      mm/mmap: rename __vma_unlink_common() to __vma_unlink()
      mm/mmap: leverage vma_rb_erase_ignore() to implement vma_rb_erase()

    Chinwen Chang <chinwen.chang@mediatek.com>:
    Patch series "Try to release mmap_lock temporarily in smaps_rollup", v4:
      mmap locking API: add mmap_lock_is_contended()
      mm: smaps*: extend smap_gather_stats to support specified beginning
      mm: proc: smaps_rollup: do not stall write attempts on mmap_lock

    "Matthew Wilcox (Oracle)" <willy@infradead.org>:
    Patch series "Fix PageDoubleMap":
      mm: move PageDoubleMap bit
      mm: simplify PageDoubleMap with PF_SECOND policy

    Wei Yang <richard.weiyang@linux.alibaba.com>:
      mm/mmap: leave adjust_next as virtual address instead of page frame number

    Randy Dunlap <rdunlap@infradead.org>:
      mm/memory.c: fix spello of "function"

    Wei Yang <richard.weiyang@linux.alibaba.com>:
      mm/mmap: not necessary to check mapping separately
      mm/mmap: check on file instead of the rb_root_cached of its address_space

    Miaohe Lin <linmiaohe@huawei.com>:
      mm: use helper function mapping_allow_writable()
      mm/mmap.c: use helper function allow_write_access() in __remove_shared_vm_struct()

    Liao Pingfang <liao.pingfang@zte.com.cn>:
      mm/mmap.c: replace do_brk with do_brk_flags in comment of insert_vm_struct()

    Peter Xu <peterx@redhat.com>:
      mm: remove src/dst mm parameter in copy_page_range()

Subsystem: mm/mincore

    yuleixzhang <yulei.kernel@gmail.com>:
      include/linux/huge_mm.h: remove mincore_huge_pmd declaration

Subsystem: mm/hmm

    Ralph Campbell <rcampbell@nvidia.com>:
      tools/testing/selftests/vm/hmm-tests.c: use the new SKIP() macro
      lib/test_hmm.c: remove unused dmirror_zero_page

Subsystem: mm/dma

    Andy Shevchenko <andriy.shevchenko@linux.intel.com>:
      mm/dmapool.c: replace open-coded list_for_each_entry_safe()
      mm/dmapool.c: replace hard coded function name with __func__

Subsystem: mm/memory-failure

    Xianting Tian <tian.xianting@h3c.com>:
      mm/memory-failure: do pgoff calculation before for_each_process()

    Alex Shi <alex.shi@linux.alibaba.com>:
      mm/memory-failure.c: remove unused macro `writeback'

Subsystem: mm/vmalloc

    Hui Su <sh_def@163.com>:
      mm/vmalloc.c: update the comment in __vmalloc_area_node()
      mm/vmalloc.c: fix the comment of find_vm_area

Subsystem: mm/documentation

    Alexander Gordeev <agordeev@linux.ibm.com>:
      docs/vm: fix 'mm_count' vs 'mm_users' counter confusion

Subsystem: mm/kasan

    Patricia Alfonso <trishalfonso@google.com>:
    Patch series "KASAN-KUnit Integration", v14:
      kasan/kunit: add KUnit Struct to Current Task
      KUnit: KASAN Integration
      KASAN: port KASAN Tests to KUnit
      KASAN: Testing Documentation

    David Gow <davidgow@google.com>:
      mm: kasan: do not panic if both panic_on_warn and kasan_multishot set

Subsystem: mm/pagealloc

    David Hildenbrand <david@redhat.com>:
    Patch series "mm / virtio-mem: support ZONE_MOVABLE", v5:
      mm/page_alloc: tweak comments in has_unmovable_pages()
      mm/page_isolation: exit early when pageblock is isolated in set_migratetype_isolate()
      mm/page_isolation: drop WARN_ON_ONCE() in set_migratetype_isolate()
      mm/page_isolation: cleanup set_migratetype_isolate()
      virtio-mem: don't special-case ZONE_MOVABLE
      mm: document semantics of ZONE_MOVABLE

    Li Xinhai <lixinhai.lxh@gmail.com>:
      mm, isolation: avoid checking unmovable pages across pageblock boundary

    Mateusz Nosek <mateusznosek0@gmail.com>:
      mm/page_alloc.c: clean code by removing unnecessary initialization
      mm/page_alloc.c: micro-optimization remove unnecessary branch
      mm/page_alloc.c: fix early params garbage value accesses
      mm/page_alloc.c: clean code by merging two functions

    Yanfei Xu <yanfei.xu@windriver.com>:
      mm/page_alloc.c: __perform_reclaim should return 'unsigned long'

    Mateusz Nosek <mateusznosek0@gmail.com>:
      mmzone: clean code by removing unused macro parameter

    Ralph Campbell <rcampbell@nvidia.com>:
      mm: move call to compound_head() in release_pages()

    "Matthew Wilcox (Oracle)" <willy@infradead.org>:
      mm/page_alloc.c: fix freeing non-compound pages

    Michal Hocko <mhocko@suse.com>:
      include/linux/gfp.h: clarify usage of GFP_ATOMIC in !preemptible contexts

Subsystem: mm/hugetlb

    Baoquan He <bhe@redhat.com>:
    Patch series "mm/hugetlb: Small cleanup and improvement", v2:
      mm/hugetlb.c: make is_hugetlb_entry_hwpoisoned return bool
      mm/hugetlb.c: remove the unnecessary non_swap_entry()
      doc/vm: fix typo in the hugetlb admin documentation

    Wei Yang <richard.weiyang@linux.alibaba.com>:
    Patch series "mm/hugetlb: code refine and simplification", v4:
      mm/hugetlb: not necessary to coalesce regions recursively
      mm/hugetlb: remove VM_BUG_ON(!nrg) in get_file_region_entry_from_cache()
      mm/hugetlb: use list_splice to merge two list at once
      mm/hugetlb: count file_region to be added when regions_needed != NULL
      mm/hugetlb: a page from buddy is not on any list
      mm/hugetlb: narrow the hugetlb_lock protection area during preparing huge page
      mm/hugetlb: take the free hpage during the iteration directly

    Mike Kravetz <mike.kravetz@oracle.com>:
      hugetlb: add lockdep check for i_mmap_rwsem held in huge_pmd_share

Subsystem: mm/vmscan

    Chunxin Zang <zangchunxin@bytedance.com>:
      mm/vmscan: fix infinite loop in drop_slab_node

    Hui Su <sh_def@163.com>:
      mm/vmscan: fix comments for isolate_lru_page()

Subsystem: mm/z3fold

    Hui Su <sh_def@163.com>:
      mm/z3fold.c: use xx_zalloc instead xx_alloc and memset

Subsystem: mm/zbud

    Xiang Chen <chenxiang66@hisilicon.com>:
      mm/zbud: remove redundant initialization

Subsystem: mm/compaction

    Mateusz Nosek <mateusznosek0@gmail.com>:
      mm/compaction.c: micro-optimization remove unnecessary branch
      include/linux/compaction.h: clean code by removing unused enum value

    John Hubbard <jhubbard@nvidia.com>:
      selftests/vm: 8x compaction_test speedup

Subsystem: mm/mempolicy

    Wei Yang <richard.weiyang@linux.alibaba.com>:
      mm/mempolicy: remove or narrow the lock on current
      mm: remove unused alloc_page_vma_node()

Subsystem: mm/mempool

    Miaohe Lin <linmiaohe@huawei.com>:
      mm/mempool: add 'else' to split mutually exclusive case

Subsystem: mm/memblock

    Mike Rapoport <rppt@linux.ibm.com>:
    Patch series "memblock: seasonal cleaning^w cleanup", v3:
      KVM: PPC: Book3S HV: simplify kvm_cma_reserve()
      dma-contiguous: simplify cma_early_percent_memory()
      arm, xtensa: simplify initialization of high memory pages
      arm64: numa: simplify dummy_numa_init()
      h8300, nds32, openrisc: simplify detection of memory extents
      riscv: drop unneeded node initialization
      mircoblaze: drop unneeded NUMA and sparsemem initializations
      memblock: make for_each_memblock_type() iterator private
      memblock: make memblock_debug and related functionality private
      memblock: reduce number of parameters in for_each_mem_range()
      arch, mm: replace for_each_memblock() with for_each_mem_pfn_range()
      arch, drivers: replace for_each_membock() with for_each_mem_range()
      x86/setup: simplify initrd relocation and reservation
      x86/setup: simplify reserve_crashkernel()
      memblock: remove unused memblock_mem_size()
      memblock: implement for_each_reserved_mem_region() using __next_mem_region()
      memblock: use separate iterators for memory and reserved regions

Subsystem: mm/oom-kill

    Suren Baghdasaryan <surenb@google.com>:
      mm, oom_adj: don't loop through tasks in __set_oom_adj when not necessary

Subsystem: mm/migration

    Ralph Campbell <rcampbell@nvidia.com>:
      mm/migrate: remove cpages-- in migrate_vma_finalize()
      mm/migrate: remove obsolete comment about device public

 .clang-format                                |    7 
 Documentation/admin-guide/cgroup-v2.rst      |   69 +
 Documentation/admin-guide/mm/hugetlbpage.rst |    2 
 Documentation/dev-tools/kasan.rst            |   74 +
 Documentation/dev-tools/kmemleak.rst         |    2 
 Documentation/kbuild/makefiles.rst           |   20 
 Documentation/vm/active_mm.rst               |    2 
 Documentation/x86/x86_64/boot-options.rst    |    4 
 MAINTAINERS                                  |    2 
 Makefile                                     |    9 
 arch/arm/Kconfig                             |    2 
 arch/arm/include/asm/tlb.h                   |    1 
 arch/arm/kernel/setup.c                      |   18 
 arch/arm/mm/init.c                           |   59 -
 arch/arm/mm/mmu.c                            |   39 
 arch/arm/mm/pmsa-v7.c                        |   23 
 arch/arm/mm/pmsa-v8.c                        |   17 
 arch/arm/xen/mm.c                            |    7 
 arch/arm64/Kconfig                           |    2 
 arch/arm64/kernel/machine_kexec_file.c       |    6 
 arch/arm64/kernel/setup.c                    |    4 
 arch/arm64/kernel/vdso/Makefile              |    7 
 arch/arm64/mm/init.c                         |   11 
 arch/arm64/mm/kasan_init.c                   |   10 
 arch/arm64/mm/mmu.c                          |   11 
 arch/arm64/mm/numa.c                         |   15 
 arch/c6x/kernel/setup.c                      |    9 
 arch/h8300/kernel/setup.c                    |    8 
 arch/microblaze/mm/init.c                    |   23 
 arch/mips/cavium-octeon/dma-octeon.c         |   14 
 arch/mips/kernel/setup.c                     |   31 
 arch/mips/netlogic/xlp/setup.c               |    2 
 arch/nds32/kernel/setup.c                    |    8 
 arch/openrisc/kernel/setup.c                 |    9 
 arch/openrisc/mm/init.c                      |    8 
 arch/powerpc/kernel/fadump.c                 |   61 -
 arch/powerpc/kexec/file_load_64.c            |   16 
 arch/powerpc/kvm/book3s_hv_builtin.c         |   12 
 arch/powerpc/kvm/book3s_hv_uvmem.c           |   14 
 arch/powerpc/mm/book3s64/hash_utils.c        |   16 
 arch/powerpc/mm/book3s64/radix_pgtable.c     |   10 
 arch/powerpc/mm/kasan/kasan_init_32.c        |    8 
 arch/powerpc/mm/mem.c                        |   31 
 arch/powerpc/mm/numa.c                       |    7 
 arch/powerpc/mm/pgtable_32.c                 |    8 
 arch/riscv/mm/init.c                         |   36 
 arch/riscv/mm/kasan_init.c                   |   10 
 arch/s390/kernel/setup.c                     |   27 
 arch/s390/mm/page-states.c                   |    6 
 arch/s390/mm/vmem.c                          |    7 
 arch/sh/mm/init.c                            |    9 
 arch/sparc/mm/init_64.c                      |   12 
 arch/x86/include/asm/numa.h                  |    8 
 arch/x86/kernel/e820.c                       |   16 
 arch/x86/kernel/setup.c                      |   56 -
 arch/x86/mm/numa.c                           |   13 
 arch/x86/mm/numa_emulation.c                 |    3 
 arch/x86/xen/enlighten_pv.c                  |    2 
 arch/xtensa/mm/init.c                        |   55 -
 drivers/acpi/numa/hmat.c                     |   76 -
 drivers/acpi/numa/srat.c                     |    9 
 drivers/base/core.c                          |    2 
 drivers/bus/mvebu-mbus.c                     |   12 
 drivers/dax/Kconfig                          |    6 
 drivers/dax/Makefile                         |    3 
 drivers/dax/bus.c                            | 1237 +++++++++++++++++++++++----
 drivers/dax/bus.h                            |   34 
 drivers/dax/dax-private.h                    |   74 +
 drivers/dax/device.c                         |  164 +--
 drivers/dax/hmem.c                           |   56 -
 drivers/dax/hmem/Makefile                    |    8 
 drivers/dax/hmem/device.c                    |  100 ++
 drivers/dax/hmem/hmem.c                      |   93 +-
 drivers/dax/kmem.c                           |  236 ++---
 drivers/dax/pmem/compat.c                    |    2 
 drivers/dax/pmem/core.c                      |   36 
 drivers/firmware/efi/x86_fake_mem.c          |   12 
 drivers/gpu/drm/i915/gem/i915_gem_shmem.c    |    4 
 drivers/gpu/drm/nouveau/nouveau_dmem.c       |   15 
 drivers/irqchip/irq-gic-v3-its.c             |    2 
 drivers/nvdimm/badrange.c                    |   26 
 drivers/nvdimm/claim.c                       |   13 
 drivers/nvdimm/nd.h                          |    3 
 drivers/nvdimm/pfn_devs.c                    |   13 
 drivers/nvdimm/pmem.c                        |   27 
 drivers/nvdimm/region.c                      |   21 
 drivers/pci/p2pdma.c                         |   12 
 drivers/virtio/virtio_mem.c                  |   47 -
 drivers/xen/unpopulated-alloc.c              |   45 
 fs/fs_parser.c                               |    2 
 fs/ntfs/inode.c                              |    6 
 fs/ocfs2/alloc.c                             |    6 
 fs/ocfs2/localalloc.c                        |    2 
 fs/proc/base.c                               |    3 
 fs/proc/task_mmu.c                           |  104 +-
 fs/xattr.c                                   |   22 
 include/acpi/acpi_numa.h                     |   14 
 include/kunit/test.h                         |    5 
 include/linux/acpi.h                         |    2 
 include/linux/compaction.h                   |    3 
 include/linux/compiler-clang.h               |    8 
 include/linux/compiler-gcc.h                 |    2 
 include/linux/compiler.h                     |    2 
 include/linux/dax.h                          |    8 
 include/linux/export.h                       |    2 
 include/linux/fs.h                           |    4 
 include/linux/gfp.h                          |    6 
 include/linux/huge_mm.h                      |    3 
 include/linux/kasan.h                        |    6 
 include/linux/memblock.h                     |   90 +
 include/linux/memcontrol.h                   |   13 
 include/linux/memory_hotplug.h               |   23 
 include/linux/memremap.h                     |   15 
 include/linux/mm.h                           |   36 
 include/linux/mmap_lock.h                    |    5 
 include/linux/mmzone.h                       |   37 
 include/linux/numa.h                         |   11 
 include/linux/oom.h                          |    1 
 include/linux/page-flags.h                   |   42 
 include/linux/pagemap.h                      |   43 
 include/linux/range.h                        |    6 
 include/linux/sched.h                        |    4 
 include/linux/sched/coredump.h               |    1 
 include/linux/slab.h                         |    2 
 include/linux/swap.h                         |   10 
 include/linux/swap_slots.h                   |    2 
 kernel/dma/contiguous.c                      |   11 
 kernel/fork.c                                |   25 
 kernel/resource.c                            |   11 
 lib/Kconfig.debug                            |    9 
 lib/Kconfig.kasan                            |   31 
 lib/Makefile                                 |    5 
 lib/kunit/test.c                             |   13 
 lib/test_free_pages.c                        |   42 
 lib/test_hmm.c                               |   65 -
 lib/test_kasan.c                             |  732 ++++++---------
 lib/test_kasan_module.c                      |  111 ++
 mm/Kconfig                                   |    4 
 mm/Makefile                                  |    1 
 mm/compaction.c                              |    5 
 mm/debug.c                                   |   18 
 mm/dmapool.c                                 |   46 -
 mm/fadvise.c                                 |    9 
 mm/filemap.c                                 |   78 -
 mm/gup.c                                     |   44 
 mm/gup_benchmark.c                           |   23 
 mm/huge_memory.c                             |    4 
 mm/hugetlb.c                                 |  100 +-
 mm/internal.h                                |    3 
 mm/kasan/report.c                            |   34 
 mm/kmemleak-test.c                           |   99 --
 mm/kmemleak.c                                |    8 
 mm/madvise.c                                 |   21 
 mm/memblock.c                                |  102 --
 mm/memcontrol.c                              |  262 +++--
 mm/memory-failure.c                          |    5 
 mm/memory.c                                  |  147 +--
 mm/memory_hotplug.c                          |   10 
 mm/mempolicy.c                               |    8 
 mm/mempool.c                                 |   18 
 mm/memremap.c                                |  344 ++++---
 mm/migrate.c                                 |    3 
 mm/mincore.c                                 |   28 
 mm/mmap.c                                    |   45 
 mm/oom_kill.c                                |    2 
 mm/page_alloc.c                              |   82 -
 mm/page_counter.c                            |    2 
 mm/page_io.c                                 |   14 
 mm/page_isolation.c                          |   41 
 mm/shmem.c                                   |   19 
 mm/slab.c                                    |    4 
 mm/slab.h                                    |   50 -
 mm/slub.c                                    |   33 
 mm/sparse.c                                  |   10 
 mm/swap.c                                    |   14 
 mm/swap_slots.c                              |    3 
 mm/swap_state.c                              |   38 
 mm/swapfile.c                                |   12 
 mm/truncate.c                                |   58 -
 mm/vmalloc.c                                 |    6 
 mm/vmscan.c                                  |    5 
 mm/z3fold.c                                  |    3 
 mm/zbud.c                                    |    1 
 samples/Makefile                             |    1 
 samples/kmemleak/Makefile                    |    3 
 samples/kmemleak/kmemleak-test.c             |   99 ++
 scripts/decodecode                           |   29 
 scripts/spelling.txt                         |    4 
 tools/testing/nvdimm/dax-dev.c               |   28 
 tools/testing/nvdimm/test/iomap.c            |    2 
 tools/testing/selftests/vm/Makefile          |   17 
 tools/testing/selftests/vm/compaction_test.c |   11 
 tools/testing/selftests/vm/gup_benchmark.c   |   14 
 tools/testing/selftests/vm/hmm-tests.c       |    4 
 194 files changed, 4273 insertions(+), 2777 deletions(-)

