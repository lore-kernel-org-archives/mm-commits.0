Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0734C433EF
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:48:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A87E610A1
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:48:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232404AbhIBVtU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:49:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:41314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232060AbhIBVtU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:49:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 013BC610A0;
        Thu,  2 Sep 2021 21:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619301;
        bh=UDPRBkPWkjUn+4EWNvw2IZ0HTiseN8qfyVneq2fL5Bw=;
        h=Date:From:To:Cc:Subject:From;
        b=S8rQWNCq5bG1/LrqaaMtuITx0+nLyhAMEaFe71T/kS2tSa63wYSGNg88cpkkW0Qfh
         VOV8e8+qeXTTATTY8AaRbmpXuc5QjhUTSp3iXD40c2gcVCgAiVHy1hNWYXfPPRwda0
         izpm7CIcm5dunPpnFfrGgV66wip8SQJvYDjueJws=
Date:   Thu, 2 Sep 2021 14:48:20 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-mm@kvack.org, mm-commits@vger.kernel.org
Subject: incoming
Message-Id: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

212 patches, based on 4a3bb4200a5958d76cc26ebe4db4257efa56812b.

Subsystems affected by this patch series:

  ia64
  ocfs2
  block
  mm/slub
  mm/debug
  mm/pagecache
  mm/gup
  mm/swap
  mm/shmem
  mm/memcg
  mm/selftests
  mm/pagemap
  mm/mremap
  mm/bootmem
  mm/sparsemem
  mm/vmalloc
  mm/kasan
  mm/pagealloc
  mm/memory-failure
  mm/hugetlb
  mm/userfaultfd
  mm/vmscan
  mm/compaction
  mm/mempolicy
  mm/memblock
  mm/oom-kill
  mm/migration
  mm/ksm
  mm/percpu
  mm/vmstat
  mm/madvise

Subsystem: ia64

    Jason Wang <wangborong@cdjrlc.com>:
      ia64: fix typo in a comment

    Geert Uytterhoeven <geert+renesas@glider.be>:
    Patch series "ia64: Miscellaneous fixes and cleanups":
      ia64: fix #endif comment for reserve_elfcorehdr()
      ia64: make reserve_elfcorehdr() static
      ia64: make num_rsvd_regions static

Subsystem: ocfs2

    Dan Carpenter <dan.carpenter@oracle.com>:
      ocfs2: remove an unnecessary condition

    Tuo Li <islituo@gmail.com>:
      ocfs2: quota_local: fix possible uninitialized-variable access in ocfs2_local_read_info()

    Gang He <ghe@suse.com>:
      ocfs2: ocfs2_downconvert_lock failure results in deadlock

Subsystem: block

    kernel test robot <lkp@intel.com>:
      arch/csky/kernel/probes/kprobes.c: fix bugon.cocci warnings

Subsystem: mm/slub

    Vlastimil Babka <vbabka@suse.cz>:
    Patch series "SLUB: reduce irq disabled scope and make it RT compatible", v4:
      mm, slub: don't call flush_all() from slab_debug_trace_open()
      mm, slub: allocate private object map for debugfs listings
      mm, slub: allocate private object map for validate_slab_cache()
      mm, slub: don't disable irq for debug_check_no_locks_freed()
      mm, slub: remove redundant unfreeze_partials() from put_cpu_partial()
      mm, slub: unify cmpxchg_double_slab() and __cmpxchg_double_slab()
      mm, slub: extract get_partial() from new_slab_objects()
      mm, slub: dissolve new_slab_objects() into ___slab_alloc()
      mm, slub: return slab page from get_partial() and set c->page afterwards
      mm, slub: restructure new page checks in ___slab_alloc()
      mm, slub: simplify kmem_cache_cpu and tid setup
      mm, slub: move disabling/enabling irqs to ___slab_alloc()
      mm, slub: do initial checks in ___slab_alloc() with irqs enabled
      mm, slub: move disabling irqs closer to get_partial() in ___slab_alloc()
      mm, slub: restore irqs around calling new_slab()
      mm, slub: validate slab from partial list or page allocator before making it cpu slab
      mm, slub: check new pages with restored irqs
      mm, slub: stop disabling irqs around get_partial()
      mm, slub: move reset of c->page and freelist out of deactivate_slab()
      mm, slub: make locking in deactivate_slab() irq-safe
      mm, slub: call deactivate_slab() without disabling irqs
      mm, slub: move irq control into unfreeze_partials()
      mm, slub: discard slabs in unfreeze_partials() without irqs disabled
      mm, slub: detach whole partial list at once in unfreeze_partials()
      mm, slub: separate detaching of partial list in unfreeze_partials() from unfreezing
      mm, slub: only disable irq with spin_lock in __unfreeze_partials()
      mm, slub: don't disable irqs in slub_cpu_dead()
      mm, slab: make flush_slab() possible to call with irqs enabled

    Sebastian Andrzej Siewior <bigeasy@linutronix.de>:
      mm: slub: move flush_cpu_slab() invocations __free_slab() invocations out of IRQ context
      mm: slub: make object_map_lock a raw_spinlock_t

    Vlastimil Babka <vbabka@suse.cz>:
      mm, slub: optionally save/restore irqs in slab_[un]lock()/
      mm, slub: make slab_lock() disable irqs with PREEMPT_RT
      mm, slub: protect put_cpu_partial() with disabled irqs instead of cmpxchg
      mm, slub: use migrate_disable() on PREEMPT_RT
      mm, slub: convert kmem_cpu_slab protection to local_lock

Subsystem: mm/debug

    Gavin Shan <gshan@redhat.com>:
    Patch series "mm/debug_vm_pgtable: Enhancements", v6:
      mm/debug_vm_pgtable: introduce struct pgtable_debug_args
      mm/debug_vm_pgtable: use struct pgtable_debug_args in basic tests
      mm/debug_vm_pgtable: use struct pgtable_debug_args in leaf and savewrite tests
      mm/debug_vm_pgtable: use struct pgtable_debug_args in protnone and devmap tests
      mm/debug_vm_pgtable: use struct pgtable_debug_args in soft_dirty and swap tests
      mm/debug_vm_pgtable: use struct pgtable_debug_args in migration and thp tests
      mm/debug_vm_pgtable: use struct pgtable_debug_args in PTE modifying tests
      mm/debug_vm_pgtable: use struct pgtable_debug_args in PMD modifying tests
      mm/debug_vm_pgtable: use struct pgtable_debug_args in PUD modifying tests
      mm/debug_vm_pgtable: use struct pgtable_debug_args in PGD and P4D modifying tests
      mm/debug_vm_pgtable: remove unused code
      mm/debug_vm_pgtable: fix corrupted page flag

    "Matthew Wilcox (Oracle)" <willy@infradead.org>:
      mm: report a more useful address for reclaim acquisition

    liuhailong <liuhailong@oppo.com>:
      mm: add kernel_misc_reclaimable in show_free_areas

Subsystem: mm/pagecache

    Jan Kara <jack@suse.cz>:
    Patch series "writeback: Fix bandwidth estimates", v4:
      writeback: track number of inodes under writeback
      writeback: reliably update bandwidth estimation
      writeback: fix bandwidth estimate for spiky workload
      writeback: rename domain_update_bandwidth()
      writeback: use READ_ONCE for unlocked reads of writeback stats

    Johannes Weiner <hannes@cmpxchg.org>:
      mm: remove irqsave/restore locking from contexts with irqs enabled
      fs: drop_caches: fix skipping over shadow cache inodes
      fs: inode: count invalidated shadow pages in pginodesteal

    Shakeel Butt <shakeelb@google.com>:
      writeback: memcg: simplify cgroup_writeback_by_id

    Jing Yangyang <jing.yangyang@zte.com.cn>:
      include/linux/buffer_head.h: fix boolreturn.cocci warnings

Subsystem: mm/gup

    Miaohe Lin <linmiaohe@huawei.com>:
    Patch series "Cleanups and fixup for gup":
      mm: gup: remove set but unused local variable major
      mm: gup: remove unneed local variable orig_refs
      mm: gup: remove useless BUG_ON in __get_user_pages()
      mm: gup: fix potential pgmap refcnt leak in __gup_device_huge()
      mm: gup: use helper PAGE_ALIGNED in populate_vma_page_range()

    John Hubbard <jhubbard@nvidia.com>:
    Patch series "A few gup refactorings and documentation updates", v3:
      mm/gup: documentation corrections for gup/pup
      mm/gup: small refactoring: simplify try_grab_page()
      mm/gup: remove try_get_page(), call try_get_compound_head() directly

Subsystem: mm/swap

    Hugh Dickins <hughd@google.com>:
      fs, mm: fix race in unlinking swapfile

    John Hubbard <jhubbard@nvidia.com>:
      mm: delete unused get_kernel_page()

Subsystem: mm/shmem

    Sebastian Andrzej Siewior <bigeasy@linutronix.de>:
      shmem: use raw_spinlock_t for ->stat_lock

    Miaohe Lin <linmiaohe@huawei.com>:
    Patch series "Cleanups for shmem":
      shmem: remove unneeded variable ret
      shmem: remove unneeded header file
      shmem: remove unneeded function forward declaration
      shmem: include header file to declare swap_info

    Hugh Dickins <hughd@google.com>:
    Patch series "huge tmpfs: shmem_is_huge() fixes and cleanups":
      huge tmpfs: fix fallocate(vanilla) advance over huge pages
      huge tmpfs: fix split_huge_page() after FALLOC_FL_KEEP_SIZE
      huge tmpfs: remove shrinklist addition from shmem_setattr()
      huge tmpfs: revert shmem's use of transhuge_vma_enabled()
      huge tmpfs: move shmem_huge_enabled() upwards
      huge tmpfs: SGP_NOALLOC to stop collapse_file() on race
      huge tmpfs: shmem_is_huge(vma, inode, index)
      huge tmpfs: decide stat.st_blksize by shmem_is_huge()
      shmem: shmem_writepage() split unlikely i915 THP

Subsystem: mm/memcg

    Suren Baghdasaryan <surenb@google.com>:
      mm, memcg: add mem_cgroup_disabled checks in vmpressure and swap-related functions
      mm, memcg: inline mem_cgroup_{charge/uncharge} to improve disabled memcg config
      mm, memcg: inline swap-related functions to improve disabled memcg config

    Vasily Averin <vvs@virtuozzo.com>:
      memcg: enable accounting for pids in nested pid namespaces

    Shakeel Butt <shakeelb@google.com>:
      memcg: switch lruvec stats to rstat
      memcg: infrastructure to flush memcg stats

    Yutian Yang <nglaive@gmail.com>:
      memcg: charge fs_context and legacy_fs_context

    Vasily Averin <vvs@virtuozzo.com>:
    Patch series "memcg accounting from OpenVZ", v7:
      memcg: enable accounting for mnt_cache entries
      memcg: enable accounting for pollfd and select bits arrays
      memcg: enable accounting for file lock caches
      memcg: enable accounting for fasync_cache
      memcg: enable accounting for new namesapces and struct nsproxy
      memcg: enable accounting of ipc resources
      memcg: enable accounting for signals
      memcg: enable accounting for posix_timers_cache slab
      memcg: enable accounting for ldt_struct objects

    Shakeel Butt <shakeelb@google.com>:
      memcg: cleanup racy sum avoidance code

    Vasily Averin <vvs@virtuozzo.com>:
      memcg: replace in_interrupt() by !in_task() in active_memcg()

    Baolin Wang <baolin.wang@linux.alibaba.com>:
      mm: memcontrol: set the correct memcg swappiness restriction

    Miaohe Lin <linmiaohe@huawei.com>:
      mm, memcg: remove unused functions
      mm, memcg: save some atomic ops when flush is already true

    Michal Hocko <mhocko@suse.com>:
      memcg: fix up drain_local_stock comment

    Shakeel Butt <shakeelb@google.com>:
      memcg: make memcg->event_list_lock irqsafe

Subsystem: mm/selftests

    Po-Hsu Lin <po-hsu.lin@canonical.com>:
      selftests/vm: use kselftest skip code for skipped tests

    Colin Ian King <colin.king@canonical.com>:
      selftests: Fix spelling mistake "cann't" -> "cannot"

Subsystem: mm/pagemap

    Nicholas Piggin <npiggin@gmail.com>:
    Patch series "shoot lazy tlbs", v4:
      lazy tlb: introduce lazy mm refcount helper functions
      lazy tlb: allow lazy tlb mm refcounting to be configurable
      lazy tlb: shoot lazies, a non-refcounting lazy tlb option
      powerpc/64s: enable MMU_LAZY_TLB_SHOOTDOWN

    Christoph Hellwig <hch@lst.de>:
    Patch series "_kernel_dcache_page fixes and removal":
      mmc: JZ4740: remove the flush_kernel_dcache_page call in jz4740_mmc_read_data
      mmc: mmc_spi: replace flush_kernel_dcache_page with flush_dcache_page
      scatterlist: replace flush_kernel_dcache_page with flush_dcache_page
      mm: remove flush_kernel_dcache_page

    Huang Ying <ying.huang@intel.com>:
      mm,do_huge_pmd_numa_page: remove unnecessary TLB flushing code

    Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
      mm: change fault_in_pages_* to have an unsigned size parameter

    Luigi Rizzo <lrizzo@google.com>:
      mm/pagemap: add mmap_assert_locked() annotations to find_vma*()

    "Liam R. Howlett" <Liam.Howlett@Oracle.com>:
      remap_file_pages: Use vma_lookup() instead of find_vma()

Subsystem: mm/mremap

    Chen Wandun <chenwandun@huawei.com>:
      mm/mremap: fix memory account on do_munmap() failure

Subsystem: mm/bootmem

    Muchun Song <songmuchun@bytedance.com>:
      mm/bootmem_info.c: mark __init on register_page_bootmem_info_section

Subsystem: mm/sparsemem

    Ohhoon Kwon <ohoono.kwon@samsung.com>:
    Patch series "mm: sparse: remove __section_nr() function", v4:
      mm: sparse: pass section_nr to section_mark_present
      mm: sparse: pass section_nr to find_memory_block
      mm: sparse: remove __section_nr() function

    Naoya Horiguchi <naoya.horiguchi@nec.com>:
      mm/sparse: set SECTION_NID_SHIFT to 6

    Matthew Wilcox <willy@infradead.org>:
      include/linux/mmzone.h: avoid a warning in sparse memory support

    Miles Chen <miles.chen@mediatek.com>:
      mm/sparse: clarify pgdat_to_phys

Subsystem: mm/vmalloc

    "Uladzislau Rezki (Sony)" <urezki@gmail.com>:
      mm/vmalloc: use batched page requests in bulk-allocator
      mm/vmalloc: remove gfpflags_allow_blocking() check
      lib/test_vmalloc.c: add a new 'nr_pages' parameter

    Chen Wandun <chenwandun@huawei.com>:
      mm/vmalloc: fix wrong behavior in vread

Subsystem: mm/kasan

    Woody Lin <woodylin@google.com>:
      mm/kasan: move kasan.fault to mm/kasan/report.c

    Andrey Konovalov <andreyknvl@gmail.com>:
    Patch series "kasan: test: avoid crashing the kernel with HW_TAGS", v2:
      kasan: test: rework kmalloc_oob_right
      kasan: test: avoid writing invalid memory
      kasan: test: avoid corrupting memory via memset
      kasan: test: disable kmalloc_memmove_invalid_size for HW_TAGS
      kasan: test: only do kmalloc_uaf_memset for generic mode
      kasan: test: clean up ksize_uaf
      kasan: test: avoid corrupting memory in copy_user_test
      kasan: test: avoid corrupting memory in kasan_rcu_uaf

Subsystem: mm/pagealloc

    Mike Rapoport <rppt@linux.ibm.com>:
    Patch series "mm: ensure consistency of memory map poisoning":
      mm/page_alloc: always initialize memory map for the holes
      microblaze: simplify pte_alloc_one_kernel()
      mm: introduce memmap_alloc() to unify memory map allocation
      memblock: stop poisoning raw allocations

    Nico Pache <npache@redhat.com>:
      mm/page_alloc.c: fix 'zone_id' may be used uninitialized in this function warning

    Mike Rapoport <rppt@linux.ibm.com>:
      mm/page_alloc: make alloc_node_mem_map() __init rather than __ref

    Vasily Averin <vvs@virtuozzo.com>:
      mm/page_alloc.c: use in_task()

    "George G. Davis" <davis.george@siemens.com>:
      mm/page_isolation: tracing: trace all test_pages_isolated failures

Subsystem: mm/memory-failure

    Miaohe Lin <linmiaohe@huawei.com>:
    Patch series "Cleanups and fixup for hwpoison":
      mm/hwpoison: remove unneeded variable unmap_success
      mm/hwpoison: fix potential pte_unmap_unlock pte error
      mm/hwpoison: change argument struct page **hpagep to *hpage
      mm/hwpoison: fix some obsolete comments

    Yang Shi <shy828301@gmail.com>:
      mm: hwpoison: don't drop slab caches for offlining non-LRU page
      doc: hwpoison: correct the support for hugepage
      mm: hwpoison: dump page for unhandlable page

    Michael Wang <yun.wang@linux.alibaba.com>:
      mm: fix panic caused by __page_handle_poison()

Subsystem: mm/hugetlb

    Mike Kravetz <mike.kravetz@oracle.com>:
      hugetlb: simplify prep_compound_gigantic_page ref count racing code
      hugetlb: drop ref count earlier after page allocation
      hugetlb: before freeing hugetlb page set dtor to appropriate value
      hugetlb: fix hugetlb cgroup refcounting during vma split

Subsystem: mm/userfaultfd

    Nadav Amit <namit@vmware.com>:
    Patch series "userfaultfd: minor bug fixes":
      userfaultfd: change mmap_changing to atomic
      userfaultfd: prevent concurrent API initialization
      selftests/vm/userfaultfd: wake after copy failure

Subsystem: mm/vmscan

    Dave Hansen <dave.hansen@linux.intel.com>:
    Patch series "Migrate Pages in lieu of discard", v11:
      mm/numa: automatically generate node migration order
      mm/migrate: update node demotion order on hotplug events

    Yang Shi <yang.shi@linux.alibaba.com>:
      mm/migrate: enable returning precise migrate_pages() success count

    Dave Hansen <dave.hansen@linux.intel.com>:
      mm/migrate: demote pages during reclaim

    Yang Shi <yang.shi@linux.alibaba.com>:
      mm/vmscan: add page demotion counter

    Dave Hansen <dave.hansen@linux.intel.com>:
      mm/vmscan: add helper for querying ability to age anonymous pages

    Keith Busch <kbusch@kernel.org>:
      mm/vmscan: Consider anonymous pages without swap

    Dave Hansen <dave.hansen@linux.intel.com>:
      mm/vmscan: never demote for memcg reclaim

    Huang Ying <ying.huang@intel.com>:
      mm/migrate: add sysfs interface to enable reclaim migration

    Hui Su <suhui@zeku.com>:
      mm/vmpressure: replace vmpressure_to_css() with vmpressure_to_memcg()

    Miaohe Lin <linmiaohe@huawei.com>:
    Patch series "Cleanups for vmscan", v2:
      mm/vmscan: remove the PageDirty check after MADV_FREE pages are page_ref_freezed
      mm/vmscan: remove misleading setting to sc->priority
      mm/vmscan: remove unneeded return value of kswapd_run()
      mm/vmscan: add 'else' to remove check_pending label

    Vlastimil Babka <vbabka@suse.cz>:
      mm, vmscan: guarantee drop_slab_node() termination

Subsystem: mm/compaction

    Charan Teja Reddy <charante@codeaurora.org>:
      mm: compaction: optimize proactive compaction deferrals
      mm: compaction: support triggering of proactive compaction by user

Subsystem: mm/mempolicy

    Baolin Wang <baolin.wang@linux.alibaba.com>:
      mm/mempolicy: use readable NUMA_NO_NODE macro instead of magic number

    Dave Hansen <dave.hansen@linux.intel.com>:
    Patch series "Introduce multi-preference mempolicy", v7:
      mm/mempolicy: add MPOL_PREFERRED_MANY for multiple preferred nodes

    Feng Tang <feng.tang@intel.com>:
      mm/memplicy: add page allocation function for MPOL_PREFERRED_MANY policy

    Ben Widawsky <ben.widawsky@intel.com>:
      mm/hugetlb: add support for mempolicy MPOL_PREFERRED_MANY
      mm/mempolicy: advertise new MPOL_PREFERRED_MANY

    Feng Tang <feng.tang@intel.com>:
      mm/mempolicy: unify the create() func for bind/interleave/prefer-many policies

    Vasily Averin <vvs@virtuozzo.com>:
      mm/mempolicy.c: use in_task() in mempolicy_slab_node()

Subsystem: mm/memblock

    Mike Rapoport <rppt@linux.ibm.com>:
      memblock: make memblock_find_in_range method private

Subsystem: mm/oom-kill

    Suren Baghdasaryan <surenb@google.com>:
      mm: introduce process_mrelease system call
      mm: wire up syscall process_mrelease

Subsystem: mm/migration

    Randy Dunlap <rdunlap@infradead.org>:
      mm/migrate: correct kernel-doc notation

Subsystem: mm/ksm

    Zhansaya Bagdauletkyzy <zhansayabagdaulet@gmail.com>:
    Patch series "add KSM selftests":
      selftests: vm: add KSM merge test
      selftests: vm: add KSM unmerge test
      selftests: vm: add KSM zero page merging test
      selftests: vm: add KSM merging across nodes test
      mm: KSM: fix data type
    Patch series "add KSM performance tests", v3:
      selftests: vm: add KSM merging time test
      selftests: vm: add COW time test for KSM pages

Subsystem: mm/percpu

    Jing Xiangfeng <jingxiangfeng@huawei.com>:
      mm/percpu,c: remove obsolete comments of pcpu_chunk_populated()

Subsystem: mm/vmstat

    Miaohe Lin <linmiaohe@huawei.com>:
    Patch series "Cleanup for vmstat":
      mm/vmstat: correct some wrong comments
      mm/vmstat: simplify the array size calculation
      mm/vmstat: remove unneeded return value

Subsystem: mm/madvise

    zhangkui <zhangkui@oppo.com>:
      mm/madvise: add MADV_WILLNEED to process_madvise()

 Documentation/ABI/testing/sysfs-kernel-mm-numa         |   24 
 Documentation/admin-guide/mm/numa_memory_policy.rst    |   15 
 Documentation/admin-guide/sysctl/vm.rst                |    3 
 Documentation/core-api/cachetlb.rst                    |   86 -
 Documentation/dev-tools/kasan.rst                      |   13 
 Documentation/translations/zh_CN/core-api/cachetlb.rst |    9 
 Documentation/vm/hwpoison.rst                          |    1 
 arch/Kconfig                                           |   28 
 arch/alpha/kernel/syscalls/syscall.tbl                 |    2 
 arch/arm/include/asm/cacheflush.h                      |    4 
 arch/arm/kernel/setup.c                                |   20 
 arch/arm/mach-rpc/ecard.c                              |    2 
 arch/arm/mm/flush.c                                    |   33 
 arch/arm/mm/nommu.c                                    |    6 
 arch/arm/tools/syscall.tbl                             |    2 
 arch/arm64/include/asm/unistd.h                        |    2 
 arch/arm64/include/asm/unistd32.h                      |    2 
 arch/arm64/kvm/hyp/reserved_mem.c                      |    9 
 arch/arm64/mm/init.c                                   |   38 
 arch/csky/abiv1/cacheflush.c                           |   11 
 arch/csky/abiv1/inc/abi/cacheflush.h                   |    4 
 arch/csky/kernel/probes/kprobes.c                      |    3 
 arch/ia64/include/asm/meminit.h                        |    2 
 arch/ia64/kernel/acpi.c                                |    2 
 arch/ia64/kernel/setup.c                               |   55 
 arch/ia64/kernel/syscalls/syscall.tbl                  |    2 
 arch/m68k/kernel/syscalls/syscall.tbl                  |    2 
 arch/microblaze/include/asm/page.h                     |    3 
 arch/microblaze/include/asm/pgtable.h                  |    2 
 arch/microblaze/kernel/syscalls/syscall.tbl            |    2 
 arch/microblaze/mm/init.c                              |   12 
 arch/microblaze/mm/pgtable.c                           |   17 
 arch/mips/include/asm/cacheflush.h                     |    8 
 arch/mips/kernel/setup.c                               |   14 
 arch/mips/kernel/syscalls/syscall_n32.tbl              |    2 
 arch/mips/kernel/syscalls/syscall_n64.tbl              |    2 
 arch/mips/kernel/syscalls/syscall_o32.tbl              |    2 
 arch/nds32/include/asm/cacheflush.h                    |    3 
 arch/nds32/mm/cacheflush.c                             |    9 
 arch/parisc/include/asm/cacheflush.h                   |    8 
 arch/parisc/kernel/cache.c                             |    3 
 arch/parisc/kernel/syscalls/syscall.tbl                |    2 
 arch/powerpc/Kconfig                                   |    1 
 arch/powerpc/kernel/smp.c                              |    2 
 arch/powerpc/kernel/syscalls/syscall.tbl               |    2 
 arch/powerpc/mm/book3s64/radix_tlb.c                   |    4 
 arch/powerpc/platforms/pseries/hotplug-memory.c        |    4 
 arch/riscv/mm/init.c                                   |   44 
 arch/s390/kernel/setup.c                               |    9 
 arch/s390/kernel/syscalls/syscall.tbl                  |    2 
 arch/s390/mm/fault.c                                   |    2 
 arch/sh/include/asm/cacheflush.h                       |    8 
 arch/sh/kernel/syscalls/syscall.tbl                    |    2 
 arch/sparc/kernel/syscalls/syscall.tbl                 |    2 
 arch/x86/entry/syscalls/syscall_32.tbl                 |    1 
 arch/x86/entry/syscalls/syscall_64.tbl                 |    1 
 arch/x86/kernel/aperture_64.c                          |    5 
 arch/x86/kernel/ldt.c                                  |    6 
 arch/x86/mm/init.c                                     |   23 
 arch/x86/mm/numa.c                                     |    5 
 arch/x86/mm/numa_emulation.c                           |    5 
 arch/x86/realmode/init.c                               |    2 
 arch/xtensa/kernel/syscalls/syscall.tbl                |    2 
 block/blk-map.c                                        |    2 
 drivers/acpi/tables.c                                  |    5 
 drivers/base/arch_numa.c                               |    5 
 drivers/base/memory.c                                  |    4 
 drivers/mmc/host/jz4740_mmc.c                          |    4 
 drivers/mmc/host/mmc_spi.c                             |    2 
 drivers/of/of_reserved_mem.c                           |   12 
 fs/drop_caches.c                                       |    3 
 fs/exec.c                                              |   12 
 fs/fcntl.c                                             |    3 
 fs/fs-writeback.c                                      |   28 
 fs/fs_context.c                                        |    4 
 fs/inode.c                                             |    2 
 fs/locks.c                                             |    6 
 fs/namei.c                                             |    8 
 fs/namespace.c                                         |    7 
 fs/ocfs2/dlmglue.c                                     |   14 
 fs/ocfs2/quota_global.c                                |    1 
 fs/ocfs2/quota_local.c                                 |    2 
 fs/pipe.c                                              |    2 
 fs/select.c                                            |    4 
 fs/userfaultfd.c                                       |  116 -
 include/linux/backing-dev-defs.h                       |    2 
 include/linux/backing-dev.h                            |   19 
 include/linux/buffer_head.h                            |    2 
 include/linux/compaction.h                             |    2 
 include/linux/highmem.h                                |    5 
 include/linux/hugetlb_cgroup.h                         |   12 
 include/linux/memblock.h                               |    2 
 include/linux/memcontrol.h                             |  118 +
 include/linux/memory.h                                 |    2 
 include/linux/mempolicy.h                              |   16 
 include/linux/migrate.h                                |   14 
 include/linux/mm.h                                     |   17 
 include/linux/mmzone.h                                 |    4 
 include/linux/page-flags.h                             |    9 
 include/linux/pagemap.h                                |    4 
 include/linux/sched/mm.h                               |   35 
 include/linux/shmem_fs.h                               |   25 
 include/linux/slub_def.h                               |    6 
 include/linux/swap.h                                   |   28 
 include/linux/syscalls.h                               |    1 
 include/linux/userfaultfd_k.h                          |    8 
 include/linux/vm_event_item.h                          |    2 
 include/linux/vmpressure.h                             |    2 
 include/linux/writeback.h                              |    4 
 include/trace/events/migrate.h                         |    3 
 include/uapi/asm-generic/unistd.h                      |    4 
 include/uapi/linux/mempolicy.h                         |    1 
 ipc/msg.c                                              |    2 
 ipc/namespace.c                                        |    2 
 ipc/sem.c                                              |    9 
 ipc/shm.c                                              |    2 
 kernel/cgroup/namespace.c                              |    2 
 kernel/cpu.c                                           |    2 
 kernel/exit.c                                          |    2 
 kernel/fork.c                                          |   51 
 kernel/kthread.c                                       |   21 
 kernel/nsproxy.c                                       |    2 
 kernel/pid_namespace.c                                 |    5 
 kernel/sched/core.c                                    |   37 
 kernel/sched/sched.h                                   |    4 
 kernel/signal.c                                        |    2 
 kernel/sys_ni.c                                        |    1 
 kernel/sysctl.c                                        |    2 
 kernel/time/namespace.c                                |    4 
 kernel/time/posix-timers.c                             |    4 
 kernel/user_namespace.c                                |    2 
 lib/scatterlist.c                                      |    5 
 lib/test_kasan.c                                       |   80 -
 lib/test_kasan_module.c                                |   20 
 lib/test_vmalloc.c                                     |    5 
 mm/backing-dev.c                                       |   11 
 mm/bootmem_info.c                                      |    4 
 mm/compaction.c                                        |   69 -
 mm/debug_vm_pgtable.c                                  |  982 +++++++++------
 mm/filemap.c                                           |   15 
 mm/gup.c                                               |  109 -
 mm/huge_memory.c                                       |   32 
 mm/hugetlb.c                                           |  173 ++
 mm/hwpoison-inject.c                                   |    2 
 mm/internal.h                                          |    9 
 mm/kasan/hw_tags.c                                     |   43 
 mm/kasan/kasan.h                                       |    1 
 mm/kasan/report.c                                      |   29 
 mm/khugepaged.c                                        |    2 
 mm/ksm.c                                               |    8 
 mm/madvise.c                                           |    1 
 mm/memblock.c                                          |   22 
 mm/memcontrol.c                                        |  234 +--
 mm/memory-failure.c                                    |   53 
 mm/memory_hotplug.c                                    |    2 
 mm/mempolicy.c                                         |  207 ++-
 mm/migrate.c                                           |  319 ++++
 mm/mmap.c                                              |    7 
 mm/mremap.c                                            |    2 
 mm/oom_kill.c                                          |   70 +
 mm/page-writeback.c                                    |  133 +-
 mm/page_alloc.c                                        |   62 
 mm/page_isolation.c                                    |   13 
 mm/percpu.c                                            |    3 
 mm/shmem.c                                             |  309 ++--
 mm/slab_common.c                                       |    2 
 mm/slub.c                                              | 1085 ++++++++++-------
 mm/sparse.c                                            |   46 
 mm/swap.c                                              |   22 
 mm/swapfile.c                                          |   14 
 mm/truncate.c                                          |   28 
 mm/userfaultfd.c                                       |   15 
 mm/vmalloc.c                                           |   79 -
 mm/vmpressure.c                                        |   10 
 mm/vmscan.c                                            |  220 ++-
 mm/vmstat.c                                            |   25 
 security/tomoyo/domain.c                               |   13 
 tools/testing/scatterlist/linux/mm.h                   |    1 
 tools/testing/selftests/vm/.gitignore                  |    1 
 tools/testing/selftests/vm/Makefile                    |    3 
 tools/testing/selftests/vm/charge_reserved_hugetlb.sh  |    5 
 tools/testing/selftests/vm/hugetlb_reparenting_test.sh |    5 
 tools/testing/selftests/vm/ksm_tests.c                 |  696 ++++++++++
 tools/testing/selftests/vm/mlock-random-test.c         |    2 
 tools/testing/selftests/vm/run_vmtests.sh              |   98 +
 tools/testing/selftests/vm/userfaultfd.c               |   13 
 186 files changed, 4488 insertions(+), 2281 deletions(-)

