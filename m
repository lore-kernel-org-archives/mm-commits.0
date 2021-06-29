Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF1AAC11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:32:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CB1C61D01
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:32:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231332AbhF2CfX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:35:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:56546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230152AbhF2CfX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:35:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD40061CCA;
        Tue, 29 Jun 2021 02:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624933976;
        bh=Q94vGXa0J7SzX4effP3s0gAf31EXsEJT5S9ekSB5YWE=;
        h=Date:From:To:Cc:Subject:From;
        b=ocuitSGbV8dAopqcKc6TPFvuUmXW1r5lORO1dz387clCkN0m7K5ShOu4jvVdwr7Ke
         gWajear9smJWyiyIAuVxF1jj8vjPkhrNnXOBuzds3p2LxIB22ZZBoJbH+0ffLB11me
         pk846OmEItJwkQnuAhDkMxINzpIpqQV3DZgh01Co=
Date:   Mon, 28 Jun 2021 19:32:56 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-mm@kvack.org, mm-commits@vger.kernel.org
Subject: incoming
Message-Id: <20210628193256.008961950a714730751c1423@linux-foundation.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

192 patches, based on 7cf3dead1ad70c72edb03e2d98e1f3dcd332cdb2.

Subsystems affected by this patch series:

  mm/gup
  mm/pagealloc
  kthread
  ia64
  scripts
  ntfs
  squashfs
  ocfs2
  z
  kernel/watchdog
  mm/slab
  mm/slub
  mm/kmemleak
  mm/dax
  mm/debug
  mm/pagecache
  mm/gup
  mm/swap
  mm/memcg
  mm/pagemap
  mm/mprotect
  mm/bootmem
  mm/dma
  mm/tracing
  mm/vmalloc
  mm/kasan
  mm/initialization
  mm/pagealloc
  mm/memory-failure

Subsystem: mm/gup

    Jann Horn <jannh@google.com>:
      mm/gup: fix try_grab_compound_head() race with split_huge_page()

Subsystem: mm/pagealloc

    Mike Rapoport <rppt@linux.ibm.com>:
      mm/page_alloc: fix memory map initialization for descending nodes

    Mel Gorman <mgorman@techsingularity.net>:
      mm/page_alloc: correct return value of populated elements if bulk arr=
ay is populated

Subsystem: kthread

    Jonathan Neusch=E4fer <j.neuschaefer@gmx.net>:
      kthread: switch to new kerneldoc syntax for named variable macro argu=
ment

    Petr Mladek <pmladek@suse.com>:
      kthread_worker: fix return value when kthread_mod_delayed_work() race=
s with kthread_cancel_delayed_work_sync()

Subsystem: ia64

    Randy Dunlap <rdunlap@infradead.org>:
      ia64: headers: drop duplicated words

    Arnd Bergmann <arnd@arndb.de>:
      ia64: mca_drv: fix incorrect array size calculation

Subsystem: scripts

    "Steven Rostedt (VMware)" <rostedt@goodmis.org>:
    Patch series "streamline_config.pl: Fix Perl spacing":
      streamline_config.pl: make spacing consistent
      streamline_config.pl: add softtabstop=3D4 for vim users

    Colin Ian King <colin.king@canonical.com>:
      scripts/spelling.txt: add more spellings to spelling.txt

Subsystem: ntfs

    Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>:
      ntfs: fix validity check for file name attribute

Subsystem: squashfs

    Vincent Whitchurch <vincent.whitchurch@axis.com>:
      squashfs: add option to panic on errors

Subsystem: ocfs2

    Yang Yingliang <yangyingliang@huawei.com>:
      ocfs2: remove unnecessary INIT_LIST_HEAD()

Subsystem: z

    Dan Carpenter <dan.carpenter@oracle.com>:
      ocfs2: fix snprintf() checking

    Colin Ian King <colin.king@canonical.com>:
      ocfs2: remove redundant assignment to pointer queue

    Wan Jiabing <wanjiabing@vivo.com>:
      ocfs2: remove repeated uptodate check for buffer

    Chen Huang <chenhuang5@huawei.com>:
      ocfs2: replace simple_strtoull() with kstrtoull()

    Colin Ian King <colin.king@canonical.com>:
      ocfs2: remove redundant initialization of variable ret

Subsystem: kernel/watchdog

    Wang Qing <wangqing@vivo.com>:
      kernel: watchdog: modify the explanation related to watchdog thread
      doc: watchdog: modify the explanation related to watchdog thread
      doc: watchdog: modify the doc related to "watchdog/%u"

Subsystem: mm/slab

    gumingtao <gumingtao1225@gmail.com>:
      slab: use __func__ to trace function name

Subsystem: mm/slub

    Vlastimil Babka <vbabka@suse.cz>:
      kunit: make test->lock irq safe

    Oliver Glitta <glittao@gmail.com>:
      mm/slub, kunit: add a KUnit test for SLUB debugging functionality
      slub: remove resiliency_test() function

    Hyeonggon Yoo <42.hyeyoo@gmail.com>:
      mm, slub: change run-time assertion in kmalloc_index() to compile-time

    Stephen Boyd <swboyd@chromium.org>:
      slub: restore slub_debug=3D- behavior
      slub: actually use 'message' in restore_bytes()

    Joe Perches <joe@perches.com>:
      slub: indicate slab_fix() uses printf formats

    Stephen Boyd <swboyd@chromium.org>:
      slub: force on no_hash_pointers when slub_debug is enabled

    Faiyaz Mohammed <faiyazm@codeaurora.org>:
      mm: slub: move sysfs slab alloc/free interfaces to debugfs

    Georgi Djakov <quic_c_gdjako@quicinc.com>:
      mm/slub: add taint after the errors are printed

Subsystem: mm/kmemleak

    Yanfei Xu <yanfei.xu@windriver.com>:
      mm/kmemleak: fix possible wrong memory scanning period

Subsystem: mm/dax

    Jan Kara <jack@suse.cz>:
      dax: fix ENOMEM handling in grab_mapping_entry()

Subsystem: mm/debug

    Tang Bin <tangbin@cmss.chinamobile.com>:
      tools/vm/page_owner_sort.c: check malloc() return

    Anshuman Khandual <anshuman.khandual@arm.com>:
      mm/debug_vm_pgtable: ensure THP availability via has_transparent_huge=
page()

    Nicolas Saenz Julienne <nsaenzju@redhat.com>:
      mm: mmap_lock: use local locks instead of disabling preemption

    Gavin Shan <gshan@redhat.com>:
    Patch series "mm/page_reporting: Make page reporting work on arm64 with=
 64KB page size", v4:
      mm/page_reporting: fix code style in __page_reporting_request()
      mm/page_reporting: export reporting order as module parameter
      mm/page_reporting: allow driver to specify reporting order
      virtio_balloon: specify page reporting order if needed

Subsystem: mm/pagecache

    Kefeng Wang <wangkefeng.wang@huawei.com>:
      mm: page-writeback: kill get_writeback_state() comments

    Chi Wu <wuchi.zero@gmail.com>:
      mm/page-writeback: Fix performance when BDI's share of ratio is 0.
      mm/page-writeback: update the comment of Dirty position control
      mm/page-writeback: use __this_cpu_inc() in account_page_dirtied()

    Roman Gushchin <guro@fb.com>:
    Patch series "cgroup, blkcg: prevent dirty inodes to pin dying memory c=
groups", v9:
      writeback, cgroup: do not switch inodes with I_WILL_FREE flag
      writeback, cgroup: add smp_mb() to cgroup_writeback_umount()
      writeback, cgroup: increment isw_nr_in_flight before grabbing an inode
      writeback, cgroup: switch to rcu_work API in inode_switch_wbs()
      writeback, cgroup: keep list of inodes attached to bdi_writeback
      writeback, cgroup: split out the functional part of inode_switch_wbs_=
work_fn()
      writeback, cgroup: support switching multiple inodes at once
      writeback, cgroup: release dying cgwbs by switching attached inodes

    Christoph Hellwig <hch@lst.de>:
    Patch series "remove the implicit .set_page_dirty default":
      fs: unexport __set_page_dirty
      fs: move ramfs_aops to libfs
      mm: require ->set_page_dirty to be explicitly wired up

    "Matthew Wilcox (Oracle)" <willy@infradead.org>:
    Patch series "Further set_page_dirty cleanups":
      mm/writeback: move __set_page_dirty() to core mm
      mm/writeback: use __set_page_dirty in __set_page_dirty_nobuffers
      iomap: use __set_page_dirty_nobuffers
      fs: remove anon_set_page_dirty()
      fs: remove noop_set_page_dirty()
      mm: move page dirtying prototypes from mm.h

Subsystem: mm/gup

    Peter Xu <peterx@redhat.com>:
    Patch series "mm/gup: Fix pin page write cache bouncing on has_pinned",=
 v2:
      mm/gup_benchmark: support threading

    Andrea Arcangeli <aarcange@redhat.com>:
      mm: gup: allow FOLL_PIN to scale in SMP
      mm: gup: pack has_pinned in MMF_HAS_PINNED

    Christophe Leroy <christophe.leroy@csgroup.eu>:
      mm: pagewalk: fix walk for hugepage tables

Subsystem: mm/swap

    Miaohe Lin <linmiaohe@huawei.com>:
    Patch series "close various race windows for swap", v6:
      mm/swapfile: use percpu_ref to serialize against concurrent swapoff
      swap: fix do_swap_page() race with swapoff
      mm/swap: remove confusing checking for non_swap_entry() in swap_ra_in=
fo()
      mm/shmem: fix shmem_swapin() race with swapoff
    Patch series "Cleanups for swap", v2:
      mm/swapfile: move get_swap_page_of_type() under CONFIG_HIBERNATION
      mm/swap: remove unused local variable nr_shadows
      mm/swap_slots.c: delete meaningless forward declarations

    Huang Ying <ying.huang@intel.com>:
      mm, swap: remove unnecessary smp_rmb() in swap_type_to_swap_info()
      mm: free idle swap cache page after COW
      swap: check mapping_empty() for swap cache before being freed

Subsystem: mm/memcg

    Waiman Long <longman@redhat.com>:
    Patch series "mm/memcg: Reduce kmemcache memory accounting overhead", v=
6:
      mm/memcg: move mod_objcg_state() to memcontrol.c
      mm/memcg: cache vmstat data in percpu memcg_stock_pcp
      mm/memcg: improve refill_obj_stock() performance
      mm/memcg: optimize user context object stock access
    Patch series "mm: memcg/slab: Fix objcg pointer array handling problem"=
, v4:
      mm: memcg/slab: properly set up gfp flags for objcg pointer array
      mm: memcg/slab: create a new set of kmalloc-cg-<n> caches
      mm: memcg/slab: disable cache merging for KMALLOC_NORMAL caches

    Muchun Song <songmuchun@bytedance.com>:
      mm: memcontrol: fix root_mem_cgroup charging
    Patch series "memcontrol code cleanup and simplification", v3:
      mm: memcontrol: fix page charging in page replacement
      mm: memcontrol: bail out early when !mm in get_mem_cgroup_from_mm
      mm: memcontrol: remove the pgdata parameter of mem_cgroup_page_lruvec
      mm: memcontrol: simplify lruvec_holds_page_lru_lock
      mm: memcontrol: rename lruvec_holds_page_lru_lock to page_matches_lru=
vec
      mm: memcontrol: simplify the logic of objcg pinning memcg
      mm: memcontrol: move obj_cgroup_uncharge_pages() out of css_set_lock
      mm: vmscan: remove noinline_for_stack

    wenhuizhang <wenhui@gwmail.gwu.edu>:
      memcontrol: use flexible-array member

    Dan Schatzberg <schatzberg.dan@gmail.com>:
    Patch series "Charge loop device i/o to issuing cgroup", v14:
      loop: use worker per cgroup instead of kworker
      mm: charge active memcg when no mm is set
      loop: charge i/o to mem and blk cg

    Huilong Deng <denghuilong@cdjrlc.com>:
      mm: memcontrol: remove trailing semicolon in macros

Subsystem: mm/pagemap

    David Hildenbrand <david@redhat.com>:
    Patch series "perf/binfmt/mm: remove in-tree usage of MAP_EXECUTABLE":
      perf: MAP_EXECUTABLE does not indicate VM_MAYEXEC
      binfmt: remove in-tree usage of MAP_EXECUTABLE
      mm: ignore MAP_EXECUTABLE in ksys_mmap_pgoff()

    Gonzalo Matias Juarez Tello <gmjuareztello@gmail.com>:
      mm/mmap.c: logic of find_vma_intersection repeated in __do_munmap

    Liam Howlett <liam.howlett@oracle.com>:
      mm/mmap: introduce unlock_range() for code cleanup
      mm/mmap: use find_vma_intersection() in do_mmap() for overlap

    Liu Xiang <liu.xiang@zlingsmart.com>:
      mm/memory.c: fix comment of finish_mkwrite_fault()

    Liam Howlett <liam.howlett@oracle.com>:
    Patch series "mm: Add vma_lookup()", v2:
      mm: add vma_lookup(), update find_vma_intersection() comments
      drm/i915/selftests: use vma_lookup() in __igt_mmap()
      arch/arc/kernel/troubleshoot: use vma_lookup() instead of find_vma()
      arch/arm64/kvm: use vma_lookup() instead of find_vma_intersection()
      arch/powerpc/kvm/book3s_hv_uvmem: use vma_lookup() instead of find_vm=
a_intersection()
      arch/powerpc/kvm/book3s: use vma_lookup() in kvmppc_hv_setup_htab_rma=
()
      arch/mips/kernel/traps: use vma_lookup() instead of find_vma()
      arch/m68k/kernel/sys_m68k: use vma_lookup() in sys_cacheflush()
      x86/sgx: use vma_lookup() in sgx_encl_find()
      virt/kvm: use vma_lookup() instead of find_vma_intersection()
      vfio: use vma_lookup() instead of find_vma_intersection()
      net/ipv5/tcp: use vma_lookup() in tcp_zerocopy_receive()
      drm/amdgpu: use vma_lookup() in amdgpu_ttm_tt_get_user_pages()
      media: videobuf2: use vma_lookup() in get_vaddr_frames()
      misc/sgi-gru/grufault: use vma_lookup() in gru_find_vma()
      kernel/events/uprobes: use vma_lookup() in find_active_uprobe()
      lib/test_hmm: use vma_lookup() in dmirror_migrate()
      mm/ksm: use vma_lookup() in find_mergeable_vma()
      mm/migrate: use vma_lookup() in do_pages_stat_array()
      mm/mremap: use vma_lookup() in vma_to_resize()
      mm/memory.c: use vma_lookup() in __access_remote_vm()
      mm/mempolicy: use vma_lookup() in __access_remote_vm()

    Chen Li <chenli@uniontech.com>:
      mm: update legacy flush_tlb_* to use vma

Subsystem: mm/mprotect

    Peter Collingbourne <pcc@google.com>:
      mm: improve mprotect(R|W) efficiency on pages referenced once

Subsystem: mm/bootmem

    Souptick Joarder <jrdr.linux@gmail.com>:
      h8300: remove unused variable

Subsystem: mm/dma

    YueHaibing <yuehaibing@huawei.com>:
      mm/dmapool: use DEVICE_ATTR_RO macro

Subsystem: mm/tracing

    Vincent Whitchurch <vincent.whitchurch@axis.com>:
      mm, tracing: unify PFN format strings

Subsystem: mm/vmalloc

    "Uladzislau Rezki (Sony)" <urezki@gmail.com>:
    Patch series "vmalloc() vs bulk allocator", v2:
      mm/page_alloc: add an alloc_pages_bulk_array_node() helper
      mm/vmalloc: switch to bulk allocator in __vmalloc_area_node()
      mm/vmalloc: print a warning message first on failure
      mm/vmalloc: remove quoted strings split across lines

    Uladzislau Rezki <urezki@gmail.com>:
      mm/vmalloc: fallback to a single page allocator

    Rafael Aquini <aquini@redhat.com>:
      mm: vmalloc: add cond_resched() in __vunmap()

Subsystem: mm/kasan

    Alexander Potapenko <glider@google.com>:
      printk: introduce dump_stack_lvl()
      kasan: use dump_stack_lvl(KERN_ERR) to print stacks

    David Gow <davidgow@google.com>:
      kasan: test: improve failure message in KUNIT_EXPECT_KASAN_FAIL()

    Daniel Axtens <dja@axtens.net>:
    Patch series "KASAN core changes for ppc64 radix KASAN", v16:
      kasan: allow an architecture to disable inline instrumentation
      kasan: allow architectures to provide an outline readiness check
      mm: define default MAX_PTRS_PER_* in include/pgtable.h
      kasan: use MAX_PTRS_PER_* for early shadow tables

    Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>:
    Patch series "kasan: add memory corruption identification support for h=
w tag-based kasan", v4:
      kasan: rename CONFIG_KASAN_SW_TAGS_IDENTIFY to CONFIG_KASAN_TAGS_IDEN=
TIFY
      kasan: integrate the common part of two KASAN tag-based modes
      kasan: add memory corruption identification support for hardware tag-=
based mode

Subsystem: mm/initialization

    Jungseung Lee <js07.lee@samsung.com>:
      mm: report which part of mem is being freed on initmem case

Subsystem: mm/pagealloc

    Mike Rapoport <rppt@linux.ibm.com>:
      mm/mmzone.h: simplify is_highmem_idx()

    "Matthew Wilcox (Oracle)" <willy@infradead.org>:
    Patch series "Constify struct page arguments":
      mm: make __dump_page static

    Aaron Tomlin <atomlin@redhat.com>:
      mm/page_alloc: bail out on fatal signal during reclaim/compaction ret=
ry attempt

    "Matthew Wilcox (Oracle)" <willy@infradead.org>:
      mm/debug: factor PagePoisoned out of __dump_page
      mm/page_owner: constify dump_page_owner
      mm: make compound_head const-preserving
      mm: constify get_pfnblock_flags_mask and get_pfnblock_migratetype
      mm: constify page_count and page_ref_count
      mm: optimise nth_page for contiguous memmap

    Heiner Kallweit <hkallweit1@gmail.com>:
      mm/page_alloc: switch to pr_debug

    Andrii Nakryiko <andrii@kernel.org>:
      kbuild: skip per-CPU BTF generation for pahole v1.18-v1.21

    Mel Gorman <mgorman@techsingularity.net>:
      mm/page_alloc: split per cpu page lists and zone stats
      mm/page_alloc: convert per-cpu list protection to local_lock
      mm/vmstat: convert NUMA statistics to basic NUMA counters
      mm/vmstat: inline NUMA event counter updates
      mm/page_alloc: batch the accounting updates in the bulk allocator
      mm/page_alloc: reduce duration that IRQs are disabled for VM counters
      mm/page_alloc: explicitly acquire the zone lock in __free_pages_ok
      mm/page_alloc: avoid conflating IRQs disabled with zone->lock
      mm/page_alloc: update PGFREE outside the zone lock in __free_pages_ok

    Minchan Kim <minchan@kernel.org>:
      mm: page_alloc: dump migrate-failed pages only at -EBUSY

    Mel Gorman <mgorman@techsingularity.net>:
    Patch series "Calculate pcp->high based on zone sizes and active CPUs",=
 v2:
      mm/page_alloc: delete vm.percpu_pagelist_fraction
      mm/page_alloc: disassociate the pcp->high from pcp->batch
      mm/page_alloc: adjust pcp->high after CPU hotplug events
      mm/page_alloc: scale the number of pages that are batch freed
      mm/page_alloc: limit the number of pages on PCP lists when reclaim is=
 active
      mm/page_alloc: introduce vm.percpu_pagelist_high_fraction

    Dong Aisheng <aisheng.dong@nxp.com>:
      mm: drop SECTION_SHIFT in code comments
      mm/page_alloc: improve memmap_pages dbg msg

    Liu Shixin <liushixin2@huawei.com>:
      mm/page_alloc: fix counting of managed_pages

    Mel Gorman <mgorman@techsingularity.net>:
    Patch series "Allow high order pages to be stored on PCP", v2:
      mm/page_alloc: move free_the_page

    Mike Rapoport <rppt@linux.ibm.com>:
    Patch series "Remove DISCONTIGMEM memory model", v3:
      alpha: remove DISCONTIGMEM and NUMA
      arc: update comment about HIGHMEM implementation
      arc: remove support for DISCONTIGMEM
      m68k: remove support for DISCONTIGMEM
      mm: remove CONFIG_DISCONTIGMEM
      arch, mm: remove stale mentions of DISCONIGMEM
      docs: remove description of DISCONTIGMEM
      mm: replace CONFIG_NEED_MULTIPLE_NODES with CONFIG_NUMA
      mm: replace CONFIG_FLAT_NODE_MEM_MAP with CONFIG_FLATMEM

    Mel Gorman <mgorman@techsingularity.net>:
      mm/page_alloc: allow high-order pages to be stored on the per-cpu lis=
ts
      mm/page_alloc: split pcp->high across all online CPUs for cpuless nod=
es

Subsystem: mm/memory-failure

    Naoya Horiguchi <naoya.horiguchi@nec.com>:
      mm,hwpoison: send SIGBUS with error virutal address
      mm,hwpoison: make get_hwpoison_page() call get_any_page()

 Documentation/admin-guide/kernel-parameters.txt    |    6=20
 Documentation/admin-guide/lockup-watchdogs.rst     |    4=20
 Documentation/admin-guide/sysctl/kernel.rst        |   10=20
 Documentation/admin-guide/sysctl/vm.rst            |   52 -
 Documentation/dev-tools/kasan.rst                  |    9=20
 Documentation/vm/memory-model.rst                  |   45=20
 arch/alpha/Kconfig                                 |   22=20
 arch/alpha/include/asm/machvec.h                   |    6=20
 arch/alpha/include/asm/mmzone.h                    |  100 --
 arch/alpha/include/asm/pgtable.h                   |    4=20
 arch/alpha/include/asm/topology.h                  |   39=20
 arch/alpha/kernel/core_marvel.c                    |   53 -
 arch/alpha/kernel/core_wildfire.c                  |   29=20
 arch/alpha/kernel/pci_iommu.c                      |   29=20
 arch/alpha/kernel/proto.h                          |    8=20
 arch/alpha/kernel/setup.c                          |   16=20
 arch/alpha/kernel/sys_marvel.c                     |    5=20
 arch/alpha/kernel/sys_wildfire.c                   |    5=20
 arch/alpha/mm/Makefile                             |    2=20
 arch/alpha/mm/init.c                               |    3=20
 arch/alpha/mm/numa.c                               |  223 ----
 arch/arc/Kconfig                                   |   13=20
 arch/arc/include/asm/mmzone.h                      |   40=20
 arch/arc/kernel/troubleshoot.c                     |    8=20
 arch/arc/mm/init.c                                 |   21=20
 arch/arm/include/asm/tlbflush.h                    |   13=20
 arch/arm/mm/tlb-v6.S                               |    2=20
 arch/arm/mm/tlb-v7.S                               |    2=20
 arch/arm64/Kconfig                                 |    2=20
 arch/arm64/kvm/mmu.c                               |    2=20
 arch/h8300/kernel/setup.c                          |    2=20
 arch/ia64/Kconfig                                  |    2=20
 arch/ia64/include/asm/pal.h                        |    2=20
 arch/ia64/include/asm/spinlock.h                   |    2=20
 arch/ia64/include/asm/uv/uv_hub.h                  |    2=20
 arch/ia64/kernel/efi_stub.S                        |    2=20
 arch/ia64/kernel/mca_drv.c                         |    2=20
 arch/ia64/kernel/topology.c                        |    5=20
 arch/ia64/mm/numa.c                                |    5=20
 arch/m68k/Kconfig.cpu                              |   10=20
 arch/m68k/include/asm/mmzone.h                     |   10=20
 arch/m68k/include/asm/page.h                       |    2=20
 arch/m68k/include/asm/page_mm.h                    |   35=20
 arch/m68k/include/asm/tlbflush.h                   |    2=20
 arch/m68k/kernel/sys_m68k.c                        |    4=20
 arch/m68k/mm/init.c                                |   20=20
 arch/mips/Kconfig                                  |    2=20
 arch/mips/include/asm/mmzone.h                     |    8=20
 arch/mips/include/asm/page.h                       |    2=20
 arch/mips/kernel/traps.c                           |    4=20
 arch/mips/mm/init.c                                |    7=20
 arch/nds32/include/asm/memory.h                    |    6=20
 arch/openrisc/include/asm/tlbflush.h               |    2=20
 arch/powerpc/Kconfig                               |    2=20
 arch/powerpc/include/asm/mmzone.h                  |    4=20
 arch/powerpc/kernel/setup_64.c                     |    2=20
 arch/powerpc/kernel/smp.c                          |    2=20
 arch/powerpc/kexec/core.c                          |    4=20
 arch/powerpc/kvm/book3s_hv.c                       |    4=20
 arch/powerpc/kvm/book3s_hv_uvmem.c                 |    2=20
 arch/powerpc/mm/Makefile                           |    2=20
 arch/powerpc/mm/mem.c                              |    4=20
 arch/riscv/Kconfig                                 |    2=20
 arch/s390/Kconfig                                  |    2=20
 arch/s390/include/asm/pgtable.h                    |    2=20
 arch/sh/include/asm/mmzone.h                       |    4=20
 arch/sh/kernel/topology.c                          |    2=20
 arch/sh/mm/Kconfig                                 |    2=20
 arch/sh/mm/init.c                                  |    2=20
 arch/sparc/Kconfig                                 |    2=20
 arch/sparc/include/asm/mmzone.h                    |    4=20
 arch/sparc/kernel/smp_64.c                         |    2=20
 arch/sparc/mm/init_64.c                            |   12=20
 arch/x86/Kconfig                                   |    2=20
 arch/x86/ia32/ia32_aout.c                          |    4=20
 arch/x86/kernel/cpu/mce/core.c                     |   13=20
 arch/x86/kernel/cpu/sgx/encl.h                     |    4=20
 arch/x86/kernel/setup_percpu.c                     |    6=20
 arch/x86/mm/init_32.c                              |    4=20
 arch/xtensa/include/asm/page.h                     |    4=20
 arch/xtensa/include/asm/tlbflush.h                 |    4=20
 drivers/base/node.c                                |   18=20
 drivers/block/loop.c                               |  270 ++++-
 drivers/block/loop.h                               |   15=20
 drivers/dax/device.c                               |    2=20
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c            |    4=20
 drivers/gpu/drm/i915/gem/selftests/i915_gem_mman.c |    2=20
 drivers/media/common/videobuf2/frame_vector.c      |    2=20
 drivers/misc/sgi-gru/grufault.c                    |    4=20
 drivers/vfio/vfio_iommu_type1.c                    |    2=20
 drivers/virtio/virtio_balloon.c                    |   17=20
 fs/adfs/inode.c                                    |    1=20
 fs/affs/file.c                                     |    2=20
 fs/bfs/file.c                                      |    1=20
 fs/binfmt_aout.c                                   |    4=20
 fs/binfmt_elf.c                                    |    2=20
 fs/binfmt_elf_fdpic.c                              |   11=20
 fs/binfmt_flat.c                                   |    2=20
 fs/block_dev.c                                     |    1=20
 fs/buffer.c                                        |   25=20
 fs/configfs/inode.c                                |    8=20
 fs/dax.c                                           |    3=20
 fs/ecryptfs/mmap.c                                 |   13=20
 fs/exfat/inode.c                                   |    1=20
 fs/ext2/inode.c                                    |    4=20
 fs/ext4/inode.c                                    |    2=20
 fs/fat/inode.c                                     |    1=20
 fs/fs-writeback.c                                  |  366 +++++---
 fs/fuse/dax.c                                      |    3=20
 fs/gfs2/aops.c                                     |    2=20
 fs/gfs2/meta_io.c                                  |    2=20
 fs/hfs/inode.c                                     |    2=20
 fs/hfsplus/inode.c                                 |    2=20
 fs/hpfs/file.c                                     |    1=20
 fs/iomap/buffered-io.c                             |   27=20
 fs/jfs/inode.c                                     |    1=20
 fs/kernfs/inode.c                                  |    8=20
 fs/libfs.c                                         |   44=20
 fs/minix/inode.c                                   |    1=20
 fs/nilfs2/mdt.c                                    |    1=20
 fs/ntfs/inode.c                                    |    2=20
 fs/ocfs2/aops.c                                    |    4=20
 fs/ocfs2/cluster/heartbeat.c                       |    7=20
 fs/ocfs2/cluster/nodemanager.c                     |    2=20
 fs/ocfs2/dlm/dlmmaster.c                           |    2=20
 fs/ocfs2/filecheck.c                               |    6=20
 fs/ocfs2/stackglue.c                               |    8=20
 fs/omfs/file.c                                     |    1=20
 fs/proc/task_mmu.c                                 |    2=20
 fs/ramfs/inode.c                                   |    9=20
 fs/squashfs/block.c                                |    5=20
 fs/squashfs/squashfs_fs_sb.h                       |    1=20
 fs/squashfs/super.c                                |   86 +
 fs/sysv/itree.c                                    |    1=20
 fs/udf/file.c                                      |    1=20
 fs/udf/inode.c                                     |    1=20
 fs/ufs/inode.c                                     |    1=20
 fs/xfs/xfs_aops.c                                  |    4=20
 fs/zonefs/super.c                                  |    4=20
 include/asm-generic/memory_model.h                 |   37=20
 include/asm-generic/pgtable-nop4d.h                |    1=20
 include/asm-generic/topology.h                     |    2=20
 include/kunit/test.h                               |    5=20
 include/linux/backing-dev-defs.h                   |   20=20
 include/linux/cpuhotplug.h                         |    2=20
 include/linux/fs.h                                 |    6=20
 include/linux/gfp.h                                |   13=20
 include/linux/iomap.h                              |    1=20
 include/linux/kasan.h                              |    7=20
 include/linux/kernel.h                             |    2=20
 include/linux/kthread.h                            |    2=20
 include/linux/memblock.h                           |    6=20
 include/linux/memcontrol.h                         |   60 -
 include/linux/mm.h                                 |   53 -
 include/linux/mm_types.h                           |   10=20
 include/linux/mman.h                               |    2=20
 include/linux/mmdebug.h                            |    3=20
 include/linux/mmzone.h                             |   96 +-
 include/linux/page-flags.h                         |   10=20
 include/linux/page_owner.h                         |    6=20
 include/linux/page_ref.h                           |    4=20
 include/linux/page_reporting.h                     |    3=20
 include/linux/pageblock-flags.h                    |    2=20
 include/linux/pagemap.h                            |    4=20
 include/linux/pgtable.h                            |   22=20
 include/linux/printk.h                             |    5=20
 include/linux/sched/coredump.h                     |    8=20
 include/linux/slab.h                               |   59 +
 include/linux/swap.h                               |   19=20
 include/linux/swapops.h                            |    5=20
 include/linux/vmstat.h                             |   69 -
 include/linux/writeback.h                          |    1=20
 include/trace/events/cma.h                         |    4=20
 include/trace/events/filemap.h                     |    2=20
 include/trace/events/kmem.h                        |   12=20
 include/trace/events/page_pool.h                   |    4=20
 include/trace/events/pagemap.h                     |    4=20
 include/trace/events/vmscan.h                      |    2=20
 kernel/cgroup/cgroup.c                             |    1=20
 kernel/crash_core.c                                |    4=20
 kernel/events/core.c                               |    2=20
 kernel/events/uprobes.c                            |    4=20
 kernel/fork.c                                      |    1=20
 kernel/kthread.c                                   |   19=20
 kernel/sysctl.c                                    |   16=20
 kernel/watchdog.c                                  |   12=20
 lib/Kconfig.debug                                  |   15=20
 lib/Kconfig.kasan                                  |   16=20
 lib/Makefile                                       |    1=20
 lib/dump_stack.c                                   |   20=20
 lib/kunit/test.c                                   |   18=20
 lib/slub_kunit.c                                   |  152 +++
 lib/test_hmm.c                                     |    5=20
 lib/test_kasan.c                                   |   11=20
 lib/vsprintf.c                                     |    2=20
 mm/Kconfig                                         |   38=20
 mm/backing-dev.c                                   |   66 +
 mm/compaction.c                                    |    2=20
 mm/debug.c                                         |   27=20
 mm/debug_vm_pgtable.c                              |   63 +
 mm/dmapool.c                                       |    5=20
 mm/filemap.c                                       |    2=20
 mm/gup.c                                           |   81 +
 mm/hugetlb.c                                       |    2=20
 mm/internal.h                                      |    9=20
 mm/kasan/Makefile                                  |    4=20
 mm/kasan/common.c                                  |    6=20
 mm/kasan/generic.c                                 |    3=20
 mm/kasan/hw_tags.c                                 |   22=20
 mm/kasan/init.c                                    |    6=20
 mm/kasan/kasan.h                                   |   12=20
 mm/kasan/report.c                                  |    6=20
 mm/kasan/report_hw_tags.c                          |    5=20
 mm/kasan/report_sw_tags.c                          |   45=20
 mm/kasan/report_tags.c                             |   51 +
 mm/kasan/shadow.c                                  |    6=20
 mm/kasan/sw_tags.c                                 |   45=20
 mm/kasan/tags.c                                    |   59 +
 mm/kfence/kfence_test.c                            |    5=20
 mm/kmemleak.c                                      |   18=20
 mm/ksm.c                                           |    6=20
 mm/memblock.c                                      |    8=20
 mm/memcontrol.c                                    |  385 ++++++--
 mm/memory-failure.c                                |  344 +++++--
 mm/memory.c                                        |   22=20
 mm/memory_hotplug.c                                |    6=20
 mm/mempolicy.c                                     |    4=20
 mm/migrate.c                                       |    4=20
 mm/mmap.c                                          |   54 -
 mm/mmap_lock.c                                     |   33=20
 mm/mprotect.c                                      |   52 +
 mm/mremap.c                                        |    5=20
 mm/nommu.c                                         |    2=20
 mm/page-writeback.c                                |   89 +
 mm/page_alloc.c                                    |  950 +++++++++++++---=
-----
 mm/page_ext.c                                      |    2=20
 mm/page_owner.c                                    |    2=20
 mm/page_reporting.c                                |   19=20
 mm/page_reporting.h                                |    5=20
 mm/pagewalk.c                                      |   58 +
 mm/shmem.c                                         |   18=20
 mm/slab.h                                          |   24=20
 mm/slab_common.c                                   |   60 -
 mm/slub.c                                          |  420 +++++----
 mm/sparse.c                                        |    2=20
 mm/swap.c                                          |    4=20
 mm/swap_slots.c                                    |    2=20
 mm/swap_state.c                                    |   20=20
 mm/swapfile.c                                      |  177 +--
 mm/vmalloc.c                                       |  181 ++--
 mm/vmscan.c                                        |   43=20
 mm/vmstat.c                                        |  282 ++----
 mm/workingset.c                                    |    2=20
 net/ipv4/tcp.c                                     |    4=20
 scripts/kconfig/streamline_config.pl               |   76 -
 scripts/link-vmlinux.sh                            |    4=20
 scripts/spelling.txt                               |   16=20
 tools/testing/selftests/vm/gup_test.c              |   96 +-
 tools/vm/page_owner_sort.c                         |    4=20
 virt/kvm/kvm_main.c                                |    2=20
 260 files changed, 3989 insertions(+), 2996 deletions(-)

