Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28C84C2BB40
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:03:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D0A5722475
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:03:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726309AbgLODDU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:03:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:59490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725906AbgLODDU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:03:20 -0500
Date:   Mon, 14 Dec 2020 19:02:37 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001357;
        bh=Wxx12d85v3KMJph0wJfs2YngvkenNdnX3967b3uGe3I=;
        h=From:To:Cc:Subject:From;
        b=cVnd5Y+g1LFAmAgMPopIhYJ6hNEFnWYjJkJ+YP83ux3xv3njwfLpe+YaOEq555Hsy
         FcC0GYTcsBAnP620s9goO5UmgyVWSAwXvulHlQ+M7QBM5stM9lFobBweVm+tXtZxB4
         ZxBJORniYdiHVXyy4MMLmxUClIovZwcceCE3Rst4=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, linux-mm@kvack.org
Subject: incoming
Message-Id: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


- a few random little subsystems

- almost all of the MM patches which are staged ahead of linux-next
  material.  I'll trickle to post-linux-next work in as the dependents
  get merged up.


200 patches, based on 2c85ebc57b3e1817b6ce1a6b703928e113a90442.

Subsystems affected by this patch series:

  kthread
  kbuild
  ide
  ntfs
  ocfs2
  arch
  mm/slab-generic
  mm/slab
  mm/slub
  mm/dax
  mm/debug
  mm/pagecache
  mm/gup
  mm/swap
  mm/shmem
  mm/memcg
  mm/pagemap
  mm/mremap
  mm/hmm
  mm/vmalloc
  mm/documentation
  mm/kasan
  mm/pagealloc
  mm/memory-failure
  mm/hugetlb
  mm/vmscan
  mm/z3fold
  mm/compaction
  mm/oom-kill
  mm/migration
  mm/cma
  mm/page-poison
  mm/userfaultfd
  mm/zswap
  mm/zsmalloc
  mm/uaccess
  mm/zram
  mm/cleanups

Subsystem: kthread

    Rob Clark <robdclark@chromium.org>:
      kthread: add kthread_work tracepoints

    Petr Mladek <pmladek@suse.com>:
      kthread_worker: document CPU hotplug handling

Subsystem: kbuild

    Petr Vorel <petr.vorel@gmail.com>:
      uapi: move constants from <linux/kernel.h> to <linux/const.h>

Subsystem: ide

    Sebastian Andrzej Siewior <bigeasy@linutronix.de>:
      ide/falcon: remove in_interrupt() usage
      ide: remove BUG_ON(in_interrupt() || irqs_disabled()) from ide_unregister()

Subsystem: ntfs

    Alex Shi <alex.shi@linux.alibaba.com>:
      fs/ntfs: remove unused varibles
      fs/ntfs: remove unused variable attr_len

Subsystem: ocfs2

    Tom Rix <trix@redhat.com>:
      fs/ocfs2/cluster/tcp.c: remove unneeded break

    Mauricio Faria de Oliveira <mfo@canonical.com>:
      ocfs2: ratelimit the 'max lookup times reached' notice

Subsystem: arch

    Colin Ian King <colin.king@canonical.com>:
      arch/Kconfig: fix spelling mistakes

Subsystem: mm/slab-generic

    Hui Su <sh_def@163.com>:
      mm/slab_common.c: use list_for_each_entry in dump_unreclaimable_slab()

    Bartosz Golaszewski <bgolaszewski@baylibre.com>:
    Patch series "slab: provide and use krealloc_array()", v3:
      mm: slab: clarify krealloc()'s behavior with __GFP_ZERO
      mm: slab: provide krealloc_array()
      ALSA: pcm: use krealloc_array()
      vhost: vringh: use krealloc_array()
      pinctrl: use krealloc_array()
      edac: ghes: use krealloc_array()
      drm: atomic: use krealloc_array()
      hwtracing: intel: use krealloc_array()
      dma-buf: use krealloc_array()

    Vlastimil Babka <vbabka@suse.cz>:
      mm, slab, slub: clear the slab_cache field when freeing page

Subsystem: mm/slab

    Alexander Popov <alex.popov@linux.com>:
      mm/slab: rerform init_on_free earlier

Subsystem: mm/slub

    Vlastimil Babka <vbabka@suse.cz>:
      mm, slub: use kmem_cache_debug_flags() in deactivate_slab()

    Bharata B Rao <bharata@linux.ibm.com>:
      mm/slub: let number of online CPUs determine the slub page order

Subsystem: mm/dax

    Dan Williams <dan.j.williams@intel.com>:
      device-dax/kmem: use struct_size()

Subsystem: mm/debug

    Zhenhua Huang <zhenhuah@codeaurora.org>:
      mm: fix page_owner initializing issue for arm32

    Liam Mark <lmark@codeaurora.org>:
      mm/page_owner: record timestamp and pid

Subsystem: mm/pagecache

    Kent Overstreet <kent.overstreet@gmail.com>:
    Patch series "generic_file_buffered_read() improvements", v2:
      mm/filemap/c: break generic_file_buffered_read up into multiple functions
      mm/filemap.c: generic_file_buffered_read() now uses find_get_pages_contig

    Alex Shi <alex.shi@linux.alibaba.com>:
      mm/truncate: add parameter explanation for invalidate_mapping_pagevec

    Hailong Liu <carver4lio@163.com>:
      mm/filemap.c: remove else after a return

Subsystem: mm/gup

    John Hubbard <jhubbard@nvidia.com>:
    Patch series "selftests/vm: gup_test, hmm-tests, assorted improvements", v3:
      mm/gup_benchmark: rename to mm/gup_test
      selftests/vm: use a common gup_test.h
      selftests/vm: rename run_vmtests --> run_vmtests.sh
      selftests/vm: minor cleanup: Makefile and gup_test.c
      selftests/vm: only some gup_test items are really benchmarks
      selftests/vm: gup_test: introduce the dump_pages() sub-test
      selftests/vm: run_vmtests.sh: update and clean up gup_test invocation
      selftests/vm: hmm-tests: remove the libhugetlbfs dependency
      selftests/vm: 2x speedup for run_vmtests.sh

    Barry Song <song.bao.hua@hisilicon.com>:
      mm/gup_test.c: mark gup_test_init as __init function
      mm/gup_test: GUP_TEST depends on DEBUG_FS

    Jason Gunthorpe <jgg@nvidia.com>:
    Patch series "Add a seqcount between gup_fast and copy_page_range()", v4:
      mm/gup: reorganize internal_get_user_pages_fast()
      mm/gup: prevent gup_fast from racing with COW during fork
      mm/gup: remove the vma allocation from gup_longterm_locked()
      mm/gup: combine put_compound_head() and unpin_user_page()

Subsystem: mm/swap

    Ralph Campbell <rcampbell@nvidia.com>:
      mm: handle zone device pages in release_pages()

    Miaohe Lin <linmiaohe@huawei.com>:
      mm/swapfile.c: use helper function swap_count() in add_swap_count_continuation()
      mm/swap_state: skip meaningless swap cache readahead when ra_info.win == 0
      mm/swapfile.c: remove unnecessary out label in __swap_duplicate()
      mm/swapfile.c: use memset to fill the swap_map with SWAP_HAS_CACHE

    Jeff Layton <jlayton@kernel.org>:
      mm: remove pagevec_lookup_range_nr_tag()

Subsystem: mm/shmem

    Hui Su <sh_def@163.com>:
      mm/shmem.c: make shmem_mapping() inline

    Randy Dunlap <rdunlap@infradead.org>:
      tmpfs: fix Documentation nits

Subsystem: mm/memcg

    Johannes Weiner <hannes@cmpxchg.org>:
      mm: memcontrol: add file_thp, shmem_thp to memory.stat

    Muchun Song <songmuchun@bytedance.com>:
      mm: memcontrol: remove unused mod_memcg_obj_state()

    Miaohe Lin <linmiaohe@huawei.com>:
      mm: memcontrol: eliminate redundant check in __mem_cgroup_insert_exceeded()

    Muchun Song <songmuchun@bytedance.com>:
      mm: memcg/slab: fix return of child memcg objcg for root memcg
      mm: memcg/slab: fix use after free in obj_cgroup_charge

    Shakeel Butt <shakeelb@google.com>:
      mm/rmap: always do TTU_IGNORE_ACCESS

    Alex Shi <alex.shi@linux.alibaba.com>:
      mm/memcg: update page struct member in comments

    Roman Gushchin <guro@fb.com>:
      mm: memcg: fix obsolete code comments
    Patch series "mm: memcg: deprecate cgroup v1 non-hierarchical mode", v1:
      mm: memcg: deprecate the non-hierarchical mode
      docs: cgroup-v1: reflect the deprecation of the non-hierarchical mode
      cgroup: remove obsoleted broken_hierarchy and warned_broken_hierarchy

    Hui Su <sh_def@163.com>:
      mm/page_counter: use page_counter_read in page_counter_set_max

    Lukas Bulwahn <lukas.bulwahn@gmail.com>:
      mm: memcg: remove obsolete memcg_has_children()

    Muchun Song <songmuchun@bytedance.com>:
      mm: memcg/slab: rename *_lruvec_slab_state to *_lruvec_kmem_state

    Kaixu Xia <kaixuxia@tencent.com>:
      mm: memcontrol: sssign boolean values to a bool variable

    Alex Shi <alex.shi@linux.alibaba.com>:
      mm/memcg: remove incorrect comment

    Shakeel Butt <shakeelb@google.com>:
    Patch series "memcg: add pagetable comsumption to memory.stat", v2:
      mm: move lruvec stats update functions to vmstat.h
      mm: memcontrol: account pagetables per node

Subsystem: mm/pagemap

    Dan Williams <dan.j.williams@intel.com>:
      xen/unpopulated-alloc: consolidate pgmap manipulation

    Kalesh Singh <kaleshsingh@google.com>:
    Patch series "Speed up mremap on large regions", v4:
      kselftests: vm: add mremap tests
      mm: speedup mremap on 1GB or larger regions
      arm64: mremap speedup - enable HAVE_MOVE_PUD
      x86: mremap speedup - Enable HAVE_MOVE_PUD

    John Hubbard <jhubbard@nvidia.com>:
      mm: cleanup: remove unused tsk arg from __access_remote_vm

    Alex Shi <alex.shi@linux.alibaba.com>:
      mm/mapping_dirty_helpers: enhance the kernel-doc markups
      mm/page_vma_mapped.c: add colon to fix kernel-doc markups error for check_pte

    Axel Rasmussen <axelrasmussen@google.com>:
      mm: mmap_lock: add tracepoints around lock acquisition

    "Matthew Wilcox (Oracle)" <willy@infradead.org>:
      sparc: fix handling of page table constructor failure
      mm: move free_unref_page to mm/internal.h

Subsystem: mm/mremap

    Dmitry Safonov <dima@arista.com>:
    Patch series "mremap: move_vma() fixes":
      mm/mremap: account memory on do_munmap() failure
      mm/mremap: for MREMAP_DONTUNMAP check security_vm_enough_memory_mm()
      mremap: don't allow MREMAP_DONTUNMAP on special_mappings and aio
      vm_ops: rename .split() callback to .may_split()
      mremap: check if it's possible to split original vma
      mm: forbid splitting special mappings

Subsystem: mm/hmm

    Daniel Vetter <daniel.vetter@ffwll.ch>:
      mm: track mmu notifiers in fs_reclaim_acquire/release
      mm: extract might_alloc() debug check
      locking/selftests: add testcases for fs_reclaim

Subsystem: mm/vmalloc

    Andrew Morton <akpm@linux-foundation.org>:
      mm/vmalloc.c:__vmalloc_area_node(): avoid 32-bit overflow

    "Uladzislau Rezki (Sony)" <urezki@gmail.com>:
      mm/vmalloc: use free_vm_area() if an allocation fails
      mm/vmalloc: rework the drain logic

    Alex Shi <alex.shi@linux.alibaba.com>:
      mm/vmalloc: add 'align' parameter explanation for pvm_determine_end_from_reverse

    Baolin Wang <baolin.wang@linux.alibaba.com>:
      mm/vmalloc.c: remove unnecessary return statement

    Waiman Long <longman@redhat.com>:
      mm/vmalloc: Fix unlock order in s_stop()

Subsystem: mm/documentation

    Alex Shi <alex.shi@linux.alibaba.com>:
      docs/vm: remove unused 3 items explanation for /proc/vmstat

Subsystem: mm/kasan

    Vincenzo Frascino <vincenzo.frascino@arm.com>:
      mm/vmalloc.c: fix kasan shadow poisoning size

    Walter Wu <walter-zh.wu@mediatek.com>:
    Patch series "kasan: add workqueue stack for generic KASAN", v5:
      workqueue: kasan: record workqueue stack
      kasan: print workqueue stack
      lib/test_kasan.c: add workqueue test case
      kasan: update documentation for generic kasan

    Marco Elver <elver@google.com>:
      lkdtm: disable KASAN for rodata.o

Subsystem: mm/pagealloc

    Mike Rapoport <rppt@linux.ibm.com>:
    Patch series "arch, mm: deprecate DISCONTIGMEM", v2:
      alpha: switch from DISCONTIGMEM to SPARSEMEM
      ia64: remove custom __early_pfn_to_nid()
      ia64: remove 'ifdef CONFIG_ZONE_DMA32' statements
      ia64: discontig: paging_init(): remove local max_pfn calculation
      ia64: split virtual map initialization out of paging_init()
      ia64: forbid using VIRTUAL_MEM_MAP with FLATMEM
      ia64: make SPARSEMEM default and disable DISCONTIGMEM
      arm: remove CONFIG_ARCH_HAS_HOLES_MEMORYMODEL
      arm, arm64: move free_unused_memmap() to generic mm
      arc: use FLATMEM with freeing of unused memory map instead of DISCONTIGMEM
      m68k/mm: make node data and node setup depend on CONFIG_DISCONTIGMEM
      m68k/mm: enable use of generic memory_model.h for !DISCONTIGMEM
      m68k: deprecate DISCONTIGMEM
    Patch series "arch, mm: improve robustness of direct map manipulation", v7:
      mm: introduce debug_pagealloc_{map,unmap}_pages() helpers
      PM: hibernate: make direct map manipulations more explicit
      arch, mm: restore dependency of __kernel_map_pages() on DEBUG_PAGEALLOC
      arch, mm: make kernel_page_present() always available

    Vlastimil Babka <vbabka@suse.cz>:
    Patch series "disable pcplists during memory offline", v3:
      mm, page_alloc: clean up pageset high and batch update
      mm, page_alloc: calculate pageset high and batch once per zone
      mm, page_alloc: remove setup_pageset()
      mm, page_alloc: simplify pageset_update()
      mm, page_alloc: cache pageset high and batch in struct zone
      mm, page_alloc: move draining pcplists to page isolation users
      mm, page_alloc: disable pcplists during memory offline

    Miaohe Lin <linmiaohe@huawei.com>:
      include/linux/page-flags.h: remove unused __[Set|Clear]PagePrivate

    "Matthew Wilcox (Oracle)" <willy@infradead.org>:
      mm/page-flags: fix comment
      mm/page_alloc: add __free_pages() documentation

    Zou Wei <zou_wei@huawei.com>:
      mm/page_alloc: mark some symbols with static keyword

    David Hildenbrand <david@redhat.com>:
      mm/page_alloc: clear all pages in post_alloc_hook() with init_on_alloc=1

    Lin Feng <linf@wangsu.com>:
      init/main: fix broken buffer_init when DEFERRED_STRUCT_PAGE_INIT set

    Lorenzo Stoakes <lstoakes@gmail.com>:
      mm: page_alloc: refactor setup_per_zone_lowmem_reserve()

    Muchun Song <songmuchun@bytedance.com>:
      mm/page_alloc: speed up the iteration of max_order

Subsystem: mm/memory-failure

    Oscar Salvador <osalvador@suse.de>:
    Patch series "HWpoison: further fixes and cleanups", v5:
      mm,hwpoison: drain pcplists before bailing out for non-buddy zero-refcount page
      mm,hwpoison: take free pages off the buddy freelists
      mm,hwpoison: drop unneeded pcplist draining
    Patch series "HWPoison: Refactor get page interface", v2:
      mm,hwpoison: refactor get_any_page
      mm,hwpoison: disable pcplists before grabbing a refcount
      mm,hwpoison: remove drain_all_pages from shake_page
      mm,memory_failure: always pin the page in madvise_inject_error
      mm,hwpoison: return -EBUSY when migration fails

Subsystem: mm/hugetlb

    Hui Su <sh_def@163.com>:
      mm/hugetlb.c: just use put_page_testzero() instead of page_count()

    Ralph Campbell <rcampbell@nvidia.com>:
      include/linux/huge_mm.h: remove extern keyword

    Alex Shi <alex.shi@linux.alibaba.com>:
      khugepaged: add parameter explanations for kernel-doc markup

    Liu Xiang <liu.xiang@zlingsmart.com>:
      mm: hugetlb: fix type of delta parameter and related local variables in gather_surplus_pages()

    Oscar Salvador <osalvador@suse.de>:
      mm,hugetlb: remove unneeded initialization

    Dan Carpenter <dan.carpenter@oracle.com>:
      hugetlb: fix an error code in hugetlb_reserve_pages()

Subsystem: mm/vmscan

    Johannes Weiner <hannes@cmpxchg.org>:
      mm: don't wake kswapd prematurely when watermark boosting is disabled

    Lukas Bulwahn <lukas.bulwahn@gmail.com>:
      mm/vmscan: drop unneeded assignment in kswapd()

    "logic.yu" <hymmsx.yu@gmail.com>:
      mm/vmscan.c: remove the filename in the top of file comment

    Muchun Song <songmuchun@bytedance.com>:
      mm/page_isolation: do not isolate the max order page

Subsystem: mm/z3fold

    Vitaly Wool <vitaly.wool@konsulko.com>:
    Patch series "z3fold: stability / rt fixes":
      z3fold: simplify freeing slots
      z3fold: stricter locking and more careful reclaim
      z3fold: remove preempt disabled sections for RT

Subsystem: mm/compaction

    Yanfei Xu <yanfei.xu@windriver.com>:
      mm/compaction: rename 'start_pfn' to 'iteration_start_pfn' in compact_zone()

    Hui Su <sh_def@163.com>:
      mm/compaction: move compaction_suitable's comment to right place
      mm/compaction: make defer_compaction and compaction_deferred static

Subsystem: mm/oom-kill

    Hui Su <sh_def@163.com>:
      mm/oom_kill: change comment and rename is_dump_unreclaim_slabs()

Subsystem: mm/migration

    Long Li <lonuxli.64@gmail.com>:
      mm/migrate.c: fix comment spelling

    Ralph Campbell <rcampbell@nvidia.com>:
      mm/migrate.c: optimize migrate_vma_pages() mmu notifier

    "Matthew Wilcox (Oracle)" <willy@infradead.org>:
      mm: support THPs in zero_user_segments

    Yang Shi <shy828301@gmail.com>:
    Patch series "mm: misc migrate cleanup and improvement", v3:
      mm: truncate_complete_page() does not exist any more
      mm: migrate: simplify the logic for handling permanent failure
      mm: migrate: skip shared exec THP for NUMA balancing
      mm: migrate: clean up migrate_prep{_local}
      mm: migrate: return -ENOSYS if THP migration is unsupported

    Stephen Zhang <starzhangzsd@gmail.com>:
      mm: migrate: remove unused parameter in migrate_vma_insert_page()

Subsystem: mm/cma

    Lecopzer Chen <lecopzer.chen@mediatek.com>:
      mm/cma.c: remove redundant cma_mutex lock

    Charan Teja Reddy <charante@codeaurora.org>:
      mm: cma: improve pr_debug log in cma_release()

Subsystem: mm/page-poison

    Vlastimil Babka <vbabka@suse.cz>:
    Patch series "cleanup page poisoning", v3:
      mm, page_alloc: do not rely on the order of page_poison and init_on_alloc/free parameters
      mm, page_poison: use static key more efficiently
      kernel/power: allow hibernation with page_poison sanity checking
      mm, page_poison: remove CONFIG_PAGE_POISONING_NO_SANITY
      mm, page_poison: remove CONFIG_PAGE_POISONING_ZERO

Subsystem: mm/userfaultfd

    Lokesh Gidra <lokeshgidra@google.com>:
    Patch series "Control over userfaultfd kernel-fault handling", v6:
      userfaultfd: add UFFD_USER_MODE_ONLY
      userfaultfd: add user-mode only option to unprivileged_userfaultfd sysctl knob

    Axel Rasmussen <axelrasmussen@google.com>:
      userfaultfd: selftests: make __{s,u}64 format specifiers portable

    Peter Xu <peterx@redhat.com>:
    Patch series "userfaultfd: selftests: Small fixes":
      userfaultfd/selftests: always dump something in modes
      userfaultfd/selftests: fix retval check for userfaultfd_open()
      userfaultfd/selftests: hint the test runner on required privilege

Subsystem: mm/zswap

    Joe Perches <joe@perches.com>:
      mm/zswap: make struct kernel_param_ops definitions const

    YueHaibing <yuehaibing@huawei.com>:
      mm/zswap: fix passing zero to 'PTR_ERR' warning

    Barry Song <song.bao.hua@hisilicon.com>:
      mm/zswap: move to use crypto_acomp API for hardware acceleration

Subsystem: mm/zsmalloc

    Miaohe Lin <linmiaohe@huawei.com>:
      mm/zsmalloc.c: rework the list_add code in insert_zspage()

Subsystem: mm/uaccess

    Colin Ian King <colin.king@canonical.com>:
      mm/process_vm_access: remove redundant initialization of iov_r

Subsystem: mm/zram

    Minchan Kim <minchan@kernel.org>:
      zram: support page writeback
      zram: add stat to gather incompressible pages since zram set up

    Rui Salvaterra <rsalvaterra@gmail.com>:
      zram: break the strict dependency from lzo

Subsystem: mm/cleanups

    Mauro Carvalho Chehab <mchehab+huawei@kernel.org>:
      mm: fix kernel-doc markups

    Joe Perches <joe@perches.com>:
    Patch series "mm: Convert sysfs sprintf family to sysfs_emit", v2:
      mm: use sysfs_emit for struct kobject * uses
      mm: huge_memory: convert remaining use of sprintf to sysfs_emit and neatening
      mm:backing-dev: use sysfs_emit in macro defining functions
      mm: shmem: convert shmem_enabled_show to use sysfs_emit_at
      mm: slub: convert sysfs sprintf family to sysfs_emit/sysfs_emit_at

    "Gustavo A. R. Silva" <gustavoars@kernel.org>:
      mm: fix fall-through warnings for Clang

    Alexey Dobriyan <adobriyan@gmail.com>:
      mm: cleanup kstrto*() usage

 /mmap_lock.h                                         |  107 ++
 a/Documentation/admin-guide/blockdev/zram.rst        |    6 
 a/Documentation/admin-guide/cgroup-v1/memcg_test.rst |    8 
 a/Documentation/admin-guide/cgroup-v1/memory.rst     |   42 
 a/Documentation/admin-guide/cgroup-v2.rst            |   11 
 a/Documentation/admin-guide/mm/transhuge.rst         |   15 
 a/Documentation/admin-guide/sysctl/vm.rst            |   15 
 a/Documentation/core-api/memory-allocation.rst       |    4 
 a/Documentation/core-api/pin_user_pages.rst          |    8 
 a/Documentation/dev-tools/kasan.rst                  |    5 
 a/Documentation/filesystems/tmpfs.rst                |    8 
 a/Documentation/vm/memory-model.rst                  |    3 
 a/Documentation/vm/page_owner.rst                    |   12 
 a/arch/Kconfig                                       |   21 
 a/arch/alpha/Kconfig                                 |    8 
 a/arch/alpha/include/asm/mmzone.h                    |   14 
 a/arch/alpha/include/asm/page.h                      |    7 
 a/arch/alpha/include/asm/pgtable.h                   |   12 
 a/arch/alpha/include/asm/sparsemem.h                 |   18 
 a/arch/alpha/kernel/setup.c                          |    1 
 a/arch/arc/Kconfig                                   |    3 
 a/arch/arc/include/asm/page.h                        |   20 
 a/arch/arc/mm/init.c                                 |   29 
 a/arch/arm/Kconfig                                   |   12 
 a/arch/arm/kernel/vdso.c                             |    9 
 a/arch/arm/mach-bcm/Kconfig                          |    1 
 a/arch/arm/mach-davinci/Kconfig                      |    1 
 a/arch/arm/mach-exynos/Kconfig                       |    1 
 a/arch/arm/mach-highbank/Kconfig                     |    1 
 a/arch/arm/mach-omap2/Kconfig                        |    1 
 a/arch/arm/mach-s5pv210/Kconfig                      |    1 
 a/arch/arm/mach-tango/Kconfig                        |    1 
 a/arch/arm/mm/init.c                                 |   78 -
 a/arch/arm64/Kconfig                                 |    9 
 a/arch/arm64/include/asm/cacheflush.h                |    1 
 a/arch/arm64/include/asm/pgtable.h                   |    1 
 a/arch/arm64/kernel/vdso.c                           |   41 
 a/arch/arm64/mm/init.c                               |   68 -
 a/arch/arm64/mm/pageattr.c                           |   12 
 a/arch/ia64/Kconfig                                  |   11 
 a/arch/ia64/include/asm/meminit.h                    |    2 
 a/arch/ia64/mm/contig.c                              |   88 --
 a/arch/ia64/mm/discontig.c                           |   44 -
 a/arch/ia64/mm/init.c                                |   14 
 a/arch/ia64/mm/numa.c                                |   30 
 a/arch/m68k/Kconfig.cpu                              |   31 
 a/arch/m68k/include/asm/page.h                       |    2 
 a/arch/m68k/include/asm/page_mm.h                    |    7 
 a/arch/m68k/include/asm/virtconvert.h                |    7 
 a/arch/m68k/mm/init.c                                |   10 
 a/arch/mips/vdso/genvdso.c                           |    4 
 a/arch/nds32/mm/mm-nds32.c                           |    6 
 a/arch/powerpc/Kconfig                               |    5 
 a/arch/riscv/Kconfig                                 |    4 
 a/arch/riscv/include/asm/pgtable.h                   |    2 
 a/arch/riscv/include/asm/set_memory.h                |    1 
 a/arch/riscv/mm/pageattr.c                           |   31 
 a/arch/s390/Kconfig                                  |    4 
 a/arch/s390/configs/debug_defconfig                  |    2 
 a/arch/s390/configs/defconfig                        |    2 
 a/arch/s390/kernel/vdso.c                            |   11 
 a/arch/sparc/Kconfig                                 |    4 
 a/arch/sparc/mm/init_64.c                            |    2 
 a/arch/x86/Kconfig                                   |    5 
 a/arch/x86/entry/vdso/vma.c                          |   17 
 a/arch/x86/include/asm/set_memory.h                  |    1 
 a/arch/x86/kernel/cpu/resctrl/pseudo_lock.c          |    2 
 a/arch/x86/kernel/tboot.c                            |    1 
 a/arch/x86/mm/pat/set_memory.c                       |    6 
 a/drivers/base/node.c                                |    2 
 a/drivers/block/zram/Kconfig                         |   42 
 a/drivers/block/zram/zcomp.c                         |    2 
 a/drivers/block/zram/zram_drv.c                      |   29 
 a/drivers/block/zram/zram_drv.h                      |    1 
 a/drivers/dax/device.c                               |    4 
 a/drivers/dax/kmem.c                                 |    2 
 a/drivers/dma-buf/sync_file.c                        |    3 
 a/drivers/edac/ghes_edac.c                           |    4 
 a/drivers/firmware/efi/efi.c                         |    1 
 a/drivers/gpu/drm/drm_atomic.c                       |    3 
 a/drivers/hwtracing/intel_th/msu.c                   |    2 
 a/drivers/ide/falconide.c                            |    2 
 a/drivers/ide/ide-probe.c                            |    3 
 a/drivers/misc/lkdtm/Makefile                        |    1 
 a/drivers/pinctrl/pinctrl-utils.c                    |    2 
 a/drivers/vhost/vringh.c                             |    3 
 a/drivers/virtio/virtio_balloon.c                    |    6 
 a/drivers/xen/unpopulated-alloc.c                    |   14 
 a/fs/aio.c                                           |    5 
 a/fs/ntfs/file.c                                     |    5 
 a/fs/ntfs/inode.c                                    |    2 
 a/fs/ntfs/logfile.c                                  |    3 
 a/fs/ocfs2/cluster/tcp.c                             |    1 
 a/fs/ocfs2/namei.c                                   |    4 
 a/fs/proc/kcore.c                                    |    2 
 a/fs/proc/meminfo.c                                  |    2 
 a/fs/userfaultfd.c                                   |   20 
 a/include/linux/cgroup-defs.h                        |   15 
 a/include/linux/compaction.h                         |   12 
 a/include/linux/fs.h                                 |    2 
 a/include/linux/gfp.h                                |    2 
 a/include/linux/highmem.h                            |   19 
 a/include/linux/huge_mm.h                            |   93 --
 a/include/linux/memcontrol.h                         |  148 ---
 a/include/linux/migrate.h                            |    4 
 a/include/linux/mm.h                                 |  118 +-
 a/include/linux/mm_types.h                           |    8 
 a/include/linux/mmap_lock.h                          |   94 ++
 a/include/linux/mmzone.h                             |   50 -
 a/include/linux/page-flags.h                         |    6 
 a/include/linux/page_ext.h                           |    8 
 a/include/linux/pagevec.h                            |    3 
 a/include/linux/poison.h                             |    4 
 a/include/linux/rmap.h                               |    1 
 a/include/linux/sched/mm.h                           |   16 
 a/include/linux/set_memory.h                         |    5 
 a/include/linux/shmem_fs.h                           |    6 
 a/include/linux/slab.h                               |   18 
 a/include/linux/vmalloc.h                            |    8 
 a/include/linux/vmstat.h                             |  104 ++
 a/include/trace/events/sched.h                       |   84 +
 a/include/uapi/linux/const.h                         |    5 
 a/include/uapi/linux/ethtool.h                       |    2 
 a/include/uapi/linux/kernel.h                        |    9 
 a/include/uapi/linux/lightnvm.h                      |    2 
 a/include/uapi/linux/mroute6.h                       |    2 
 a/include/uapi/linux/netfilter/x_tables.h            |    2 
 a/include/uapi/linux/netlink.h                       |    2 
 a/include/uapi/linux/sysctl.h                        |    2 
 a/include/uapi/linux/userfaultfd.h                   |    9 
 a/init/main.c                                        |    6 
 a/ipc/shm.c                                          |    8 
 a/kernel/cgroup/cgroup.c                             |   12 
 a/kernel/fork.c                                      |    3 
 a/kernel/kthread.c                                   |   29 
 a/kernel/power/hibernate.c                           |    2 
 a/kernel/power/power.h                               |    2 
 a/kernel/power/snapshot.c                            |   52 +
 a/kernel/ptrace.c                                    |    2 
 a/kernel/workqueue.c                                 |    3 
 a/lib/locking-selftest.c                             |   47 +
 a/lib/test_kasan_module.c                            |   29 
 a/mm/Kconfig                                         |   25 
 a/mm/Kconfig.debug                                   |   28 
 a/mm/Makefile                                        |    4 
 a/mm/backing-dev.c                                   |    8 
 a/mm/cma.c                                           |    6 
 a/mm/compaction.c                                    |   29 
 a/mm/filemap.c                                       |  823 ++++++++++---------
 a/mm/gup.c                                           |  329 ++-----
 a/mm/gup_benchmark.c                                 |  210 ----
 a/mm/gup_test.c                                      |  299 ++++++
 a/mm/gup_test.h                                      |   40 
 a/mm/highmem.c                                       |   52 +
 a/mm/huge_memory.c                                   |   86 +
 a/mm/hugetlb.c                                       |   28 
 a/mm/init-mm.c                                       |    1 
 a/mm/internal.h                                      |    5 
 a/mm/kasan/generic.c                                 |    3 
 a/mm/kasan/report.c                                  |    4 
 a/mm/khugepaged.c                                    |   58 -
 a/mm/ksm.c                                           |   50 -
 a/mm/madvise.c                                       |   14 
 a/mm/mapping_dirty_helpers.c                         |    6 
 a/mm/memblock.c                                      |   80 +
 a/mm/memcontrol.c                                    |  170 +--
 a/mm/memory-failure.c                                |  322 +++----
 a/mm/memory.c                                        |   24 
 a/mm/memory_hotplug.c                                |   44 -
 a/mm/mempolicy.c                                     |    8 
 a/mm/migrate.c                                       |  183 ++--
 a/mm/mm_init.c                                       |    1 
 a/mm/mmap.c                                          |   22 
 a/mm/mmap_lock.c                                     |  230 +++++
 a/mm/mmu_notifier.c                                  |    7 
 a/mm/mmzone.c                                        |   14 
 a/mm/mremap.c                                        |  282 ++++--
 a/mm/nommu.c                                         |    8 
 a/mm/oom_kill.c                                      |   14 
 a/mm/page_alloc.c                                    |  517 ++++++-----
 a/mm/page_counter.c                                  |    4 
 a/mm/page_ext.c                                      |   10 
 a/mm/page_isolation.c                                |   18 
 a/mm/page_owner.c                                    |   17 
 a/mm/page_poison.c                                   |   56 -
 a/mm/page_vma_mapped.c                               |    9 
 a/mm/process_vm_access.c                             |    2 
 a/mm/rmap.c                                          |    9 
 a/mm/shmem.c                                         |   39 
 a/mm/slab.c                                          |   10 
 a/mm/slab.h                                          |    9 
 a/mm/slab_common.c                                   |   10 
 a/mm/slob.c                                          |    6 
 a/mm/slub.c                                          |  156 +--
 a/mm/swap.c                                          |   12 
 a/mm/swap_state.c                                    |    7 
 a/mm/swapfile.c                                      |   14 
 a/mm/truncate.c                                      |   18 
 a/mm/vmalloc.c                                       |  105 +-
 a/mm/vmscan.c                                        |   21 
 a/mm/vmstat.c                                        |    6 
 a/mm/workingset.c                                    |    8 
 a/mm/z3fold.c                                        |  215 ++--
 a/mm/zsmalloc.c                                      |   11 
 a/mm/zswap.c                                         |  193 +++-
 a/sound/core/pcm_lib.c                               |    4 
 a/tools/include/linux/poison.h                       |    6 
 a/tools/testing/selftests/vm/.gitignore              |    4 
 a/tools/testing/selftests/vm/Makefile                |   41 
 a/tools/testing/selftests/vm/check_config.sh         |   31 
 a/tools/testing/selftests/vm/config                  |    2 
 a/tools/testing/selftests/vm/gup_benchmark.c         |  143 ---
 a/tools/testing/selftests/vm/gup_test.c              |  258 +++++
 a/tools/testing/selftests/vm/hmm-tests.c             |   10 
 a/tools/testing/selftests/vm/mremap_test.c           |  344 +++++++
 a/tools/testing/selftests/vm/run_vmtests             |   51 -
 a/tools/testing/selftests/vm/userfaultfd.c           |   94 --
 217 files changed, 4817 insertions(+), 3369 deletions(-)

