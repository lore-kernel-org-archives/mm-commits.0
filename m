Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0549C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:34:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9FECF60E09
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:34:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbhKEUgw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:36:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:60294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230063AbhKEUgw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:36:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 434D5611C0;
        Fri,  5 Nov 2021 20:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144452;
        bh=GXpK0QnlT7FdlRsQP5MOhgZnZ1rfQiiilAweuoBJD88=;
        h=Date:From:To:Cc:Subject:From;
        b=IYLQ3vOsT0NRGTUll9hH4lrR1scjUmp+vs0pSTMr3fD8I56Hf51MUMaXPocFgpeF3
         pdm2eIYeSGjpSk+WJ8c42+7DcUej+ZPeen+vGsQg7fETp4Cge5iOmPvz8jn8MFn3QR
         7XGEQ6hpBQXj/5jnp6mI/r4p9QVoa0UXZFn8ZuE0=
Date:   Fri, 5 Nov 2021 13:34:08 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, linux-mm@kvack.org
Subject: incoming
Message-Id: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

262 patches, based on 8bb7eca972ad531c9b149c0a51ab43a417385813

Subsystems affected by this patch series:

  scripts
  ocfs2
  vfs
  mm/slab-generic
  mm/slab
  mm/slub
  mm/kconfig
  mm/dax
  mm/kasan
  mm/debug
  mm/pagecache
  mm/gup
  mm/swap
  mm/memcg
  mm/pagemap
  mm/mprotect
  mm/mremap
  mm/iomap
  mm/tracing
  mm/vmalloc
  mm/pagealloc
  mm/memory-failure
  mm/hugetlb
  mm/userfaultfd
  mm/vmscan
  mm/tools
  mm/memblock
  mm/oom-kill
  mm/hugetlbfs
  mm/migration
  mm/thp
  mm/readahead
  mm/nommu
  mm/ksm
  mm/vmstat
  mm/madvise
  mm/memory-hotplug
  mm/rmap
  mm/zsmalloc
  mm/highmem
  mm/zram
  mm/cleanups
  mm/kfence
  mm/damon

Subsystem: scripts

    Colin Ian King <colin.king@canonical.com>:
      scripts/spelling.txt: add more spellings to spelling.txt

    Sven Eckelmann <sven@narfation.org>:
      scripts/spelling.txt: fix "mistake" version of "synchronization"

    weidonghui <weidonghui@allwinnertech.com>:
      scripts/decodecode: fix faulting instruction no print when opps.file is DOS format

Subsystem: ocfs2

    Chenyuan Mi <cymi20@fudan.edu.cn>:
      ocfs2: fix handle refcount leak in two exception handling paths

    Valentin Vidic <vvidic@valentin-vidic.from.hr>:
      ocfs2: cleanup journal init and shutdown

    Colin Ian King <colin.king@canonical.com>:
      ocfs2/dlm: remove redundant assignment of variable ret

    Jan Kara <jack@suse.cz>:
    Patch series "ocfs2: Truncate data corruption fix":
      ocfs2: fix data corruption on truncate
      ocfs2: do not zero pages beyond i_size

Subsystem: vfs

    Arnd Bergmann <arnd@arndb.de>:
      fs/posix_acl.c: avoid -Wempty-body warning

    Jia He <justin.he@arm.com>:
      d_path: fix Kernel doc validator complaining

Subsystem: mm/slab-generic

    "Matthew Wilcox (Oracle)" <willy@infradead.org>:
      mm: move kvmalloc-related functions to slab.h

Subsystem: mm/slab

    Shi Lei <shi_lei@massclouds.com>:
      mm/slab.c: remove useless lines in enable_cpucache()

Subsystem: mm/slub

    Kefeng Wang <wangkefeng.wang@huawei.com>:
      slub: add back check for free nonslab objects

    Vlastimil Babka <vbabka@suse.cz>:
      mm, slub: change percpu partial accounting from objects to pages
      mm/slub: increase default cpu partial list sizes

    Hyeonggon Yoo <42.hyeyoo@gmail.com>:
      mm, slub: use prefetchw instead of prefetch

Subsystem: mm/kconfig

    Sebastian Andrzej Siewior <bigeasy@linutronix.de>:
      mm: disable NUMA_BALANCING_DEFAULT_ENABLED and TRANSPARENT_HUGEPAGE on PREEMPT_RT

Subsystem: mm/dax

    Christoph Hellwig <hch@lst.de>:
      mm: don't include <linux/dax.h> in <linux/mempolicy.h>

Subsystem: mm/kasan

    Marco Elver <elver@google.com>:
    Patch series "stackdepot, kasan, workqueue: Avoid expanding stackdepot slabs when holding raw_spin_lock", v2:
      lib/stackdepot: include gfp.h
      lib/stackdepot: remove unused function argument
      lib/stackdepot: introduce __stack_depot_save()
      kasan: common: provide can_alloc in kasan_save_stack()
      kasan: generic: introduce kasan_record_aux_stack_noalloc()
      workqueue, kasan: avoid alloc_pages() when recording stack

    "Matthew Wilcox (Oracle)" <willy@infradead.org>:
      kasan: fix tag for large allocations when using CONFIG_SLAB

    Peter Collingbourne <pcc@google.com>:
      kasan: test: add memcpy test that avoids out-of-bounds write

Subsystem: mm/debug

    Peter Xu <peterx@redhat.com>:
    Patch series "mm/smaps: Fixes and optimizations on shmem swap handling":
      mm/smaps: fix shmem pte hole swap calculation
      mm/smaps: use vma->vm_pgoff directly when counting partial swap
      mm/smaps: simplify shmem handling of pte holes

    Guo Ren <guoren@linux.alibaba.com>:
      mm: debug_vm_pgtable: don't use __P000 directly

    Kees Cook <keescook@chromium.org>:
      kasan: test: bypass __alloc_size checks
    Patch series "Add __alloc_size()", v3:
      rapidio: avoid bogus __alloc_size warning
      Compiler Attributes: add __alloc_size() for better bounds checking
      slab: clean up function prototypes
      slab: add __alloc_size attributes for better bounds checking
      mm/kvmalloc: add __alloc_size attributes for better bounds checking
      mm/vmalloc: add __alloc_size attributes for better bounds checking
      mm/page_alloc: add __alloc_size attributes for better bounds checking
      percpu: add __alloc_size attributes for better bounds checking

    Yinan Zhang <zhangyinan2019@email.szu.edu.cn>:
      mm/page_ext.c: fix a comment

Subsystem: mm/pagecache

    David Howells <dhowells@redhat.com>:
      mm: stop filemap_read() from grabbing a superfluous page

    Christoph Hellwig <hch@lst.de>:
    Patch series "simplify bdi unregistation":
      mm: export bdi_unregister
      mtd: call bdi_unregister explicitly
      fs: explicitly unregister per-superblock BDIs
      mm: don't automatically unregister bdis
      mm: simplify bdi refcounting

    Jens Axboe <axboe@kernel.dk>:
      mm: don't read i_size of inode unless we need it

    "Matthew Wilcox (Oracle)" <willy@infradead.org>:
      mm/filemap.c: remove bogus VM_BUG_ON

    Jens Axboe <axboe@kernel.dk>:
      mm: move more expensive part of XA setup out of mapping check

Subsystem: mm/gup

    John Hubbard <jhubbard@nvidia.com>:
      mm/gup: further simplify __gup_device_huge()

Subsystem: mm/swap

    Xu Wang <vulab@iscas.ac.cn>:
      mm/swapfile: remove needless request_queue NULL pointer check

    Rafael Aquini <aquini@redhat.com>:
      mm/swapfile: fix an integer overflow in swap_show()

    "Matthew Wilcox (Oracle)" <willy@infradead.org>:
      mm: optimise put_pages_list()

Subsystem: mm/memcg

    Peter Xu <peterx@redhat.com>:
      mm/memcg: drop swp_entry_t* in mc_handle_file_pte()

    Shakeel Butt <shakeelb@google.com>:
      memcg: flush stats only if updated
      memcg: unify memcg stat flushing

    Waiman Long <longman@redhat.com>:
      mm/memcg: remove obsolete memcg_free_kmem()

    Len Baker <len.baker@gmx.com>:
      mm/list_lru.c: prefer struct_size over open coded arithmetic

    Shakeel Butt <shakeelb@google.com>:
      memcg, kmem: further deprecate kmem.limit_in_bytes

    Muchun Song <songmuchun@bytedance.com>:
      mm: list_lru: remove holding lru lock
      mm: list_lru: fix the return value of list_lru_count_one()
      mm: memcontrol: remove kmemcg_id reparenting
      mm: memcontrol: remove the kmem states
      mm: list_lru: only add memcg-aware lrus to the global lru list

    Vasily Averin <vvs@virtuozzo.com>:
    Patch series "memcg: prohibit unconditional exceeding the limit of dying tasks", v3:
      mm, oom: pagefault_out_of_memory: don't force global OOM for dying tasks

    Michal Hocko <mhocko@suse.com>:
      mm, oom: do not trigger out_of_memory from the #PF

    Vasily Averin <vvs@virtuozzo.com>:
      memcg: prohibit unconditional exceeding the limit of dying tasks

Subsystem: mm/pagemap

    Peng Liu <liupeng256@huawei.com>:
      mm/mmap.c: fix a data race of mm->total_vm

    Rolf Eike Beer <eb@emlix.com>:
      mm: use __pfn_to_section() instead of open coding it

    Amit Daniel Kachhap <amit.kachhap@arm.com>:
      mm/memory.c: avoid unnecessary kernel/user pointer conversion

    Nadav Amit <namit@vmware.com>:
      mm/memory.c: use correct VMA flags when freeing page-tables

    Peter Xu <peterx@redhat.com>:
    Patch series "mm: A few cleanup patches around zap, shmem and uffd", v4:
      mm/shmem: unconditionally set pte dirty in mfill_atomic_install_pte
      mm: clear vmf->pte after pte_unmap_same() returns
      mm: drop first_index/last_index in zap_details
      mm: add zap_skip_check_mapping() helper

    Qi Zheng <zhengqi.arch@bytedance.com>:
    Patch series "Do some code cleanups related to mm", v3:
      mm: introduce pmd_install() helper
      mm: remove redundant smp_wmb()

    Tiberiu A Georgescu <tiberiu.georgescu@nutanix.com>:
      Documentation: update pagemap with shmem exceptions

    Nicholas Piggin <npiggin@gmail.com>:
    Patch series "shoot lazy tlbs", v4:
      lazy tlb: introduce lazy mm refcount helper functions
      lazy tlb: allow lazy tlb mm refcounting to be configurable
      lazy tlb: shoot lazies, a non-refcounting lazy tlb option
      powerpc/64s: enable MMU_LAZY_TLB_SHOOTDOWN

    Lukas Bulwahn <lukas.bulwahn@gmail.com>:
      memory: remove unused CONFIG_MEM_BLOCK_SIZE

Subsystem: mm/mprotect

    Liu Song <liu.song11@zte.com.cn>:
      mm/mprotect.c: avoid repeated assignment in do_mprotect_pkey()

Subsystem: mm/mremap

    Dmitry Safonov <dima@arista.com>:
      mm/mremap: don't account pages in vma_to_resize()

Subsystem: mm/iomap

    Lucas De Marchi <lucas.demarchi@intel.com>:
      include/linux/io-mapping.h: remove fallback for writecombine

Subsystem: mm/tracing

    Gang Li <ligang.bdlg@bytedance.com>:
      mm: mmap_lock: remove redundant newline  in TP_printk
      mm: mmap_lock: use DECLARE_EVENT_CLASS and DEFINE_EVENT_FN

Subsystem: mm/vmalloc

    Vasily Averin <vvs@virtuozzo.com>:
      mm/vmalloc: repair warn_alloc()s in __vmalloc_area_node()

    Peter Zijlstra <peterz@infradead.org>:
      mm/vmalloc: don't allow VM_NO_GUARD on vmap()

    Eric Dumazet <edumazet@google.com>:
      mm/vmalloc: make show_numa_info() aware of hugepage mappings
      mm/vmalloc: make sure to dump unpurged areas in /proc/vmallocinfo

    "Uladzislau Rezki (Sony)" <urezki@gmail.com>:
      mm/vmalloc: do not adjust the search size for alignment overhead
      mm/vmalloc: check various alignments when debugging

    Vasily Averin <vvs@virtuozzo.com>:
      vmalloc: back off when the current task is OOM-killed

    Kefeng Wang <wangkefeng.wang@huawei.com>:
      vmalloc: choose a better start address in vm_area_register_early()
      arm64: support page mapping percpu first chunk allocator
      kasan: arm64: fix pcpu_page_first_chunk crash with KASAN_VMALLOC

    Michal Hocko <mhocko@suse.com>:
      mm/vmalloc: be more explicit about supported gfp flags

    Chen Wandun <chenwandun@huawei.com>:
      mm/vmalloc: introduce alloc_pages_bulk_array_mempolicy to accelerate memory allocation

    Changcheng Deng <deng.changcheng@zte.com.cn>:
      lib/test_vmalloc.c: use swap() to make code cleaner

Subsystem: mm/pagealloc

    Eric Dumazet <edumazet@google.com>:
      mm/large system hash: avoid possible NULL deref in alloc_large_system_hash

    Miaohe Lin <linmiaohe@huawei.com>:
    Patch series "Cleanups and fixup for page_alloc", v2:
      mm/page_alloc.c: remove meaningless VM_BUG_ON() in pindex_to_order()
      mm/page_alloc.c: simplify the code by using macro K()
      mm/page_alloc.c: fix obsolete comment in free_pcppages_bulk()
      mm/page_alloc.c: use helper function zone_spans_pfn()
      mm/page_alloc.c: avoid allocating highmem pages via alloc_pages_exact[_nid]

    Bharata B Rao <bharata@amd.com>:
    Patch series "Fix NUMA nodes fallback list ordering":
      mm/page_alloc: print node fallback order

    Krupa Ramakrishnan <krupa.ramakrishnan@amd.com>:
      mm/page_alloc: use accumulated load when building node fallback list

    Geert Uytterhoeven <geert+renesas@glider.be>:
    Patch series "Fix NUMA without SMP":
      mm: move node_reclaim_distance to fix NUMA without SMP
      mm: move fold_vm_numa_events() to fix NUMA without SMP

    Eric Dumazet <edumazet@google.com>:
      mm/page_alloc.c: do not acquire zone lock in is_free_buddy_page()

    Feng Tang <feng.tang@intel.com>:
      mm/page_alloc: detect allocation forbidden by cpuset and bail out early

    Liangcai Fan <liangcaifan19@gmail.com>:
      mm/page_alloc.c: show watermark_boost of zone in zoneinfo

    Christophe Leroy <christophe.leroy@csgroup.eu>:
      mm: create a new system state and fix core_kernel_text()
      mm: make generic arch_is_kernel_initmem_freed() do what it says
      powerpc: use generic version of arch_is_kernel_initmem_freed()
      s390: use generic version of arch_is_kernel_initmem_freed()

    Sebastian Andrzej Siewior <bigeasy@linutronix.de>:
      mm: page_alloc: use migrate_disable() in drain_local_pages_wq()

    Wang ShaoBo <bobo.shaobowang@huawei.com>:
      mm/page_alloc: use clamp() to simplify code

Subsystem: mm/memory-failure

    Marco Elver <elver@google.com>:
      mm: fix data race in PagePoisoned()

    Rikard Falkeborn <rikard.falkeborn@gmail.com>:
      mm/memory_failure: constify static mm_walk_ops

    Yang Shi <shy828301@gmail.com>:
    Patch series "Solve silent data loss caused by poisoned page cache (shmem/tmpfs)", v5:
      mm: filemap: coding style cleanup for filemap_map_pmd()
      mm: hwpoison: refactor refcount check handling
      mm: shmem: don't truncate page if memory failure happens
      mm: hwpoison: handle non-anonymous THP correctly

Subsystem: mm/hugetlb

    Peter Xu <peterx@redhat.com>:
      mm/hugetlb: drop __unmap_hugepage_range definition from hugetlb.h

    Mike Kravetz <mike.kravetz@oracle.com>:
    Patch series "hugetlb: add demote/split page functionality", v4:
      hugetlb: add demote hugetlb page sysfs interfaces
      mm/cma: add cma_pages_valid to determine if pages are in CMA
      hugetlb: be sure to free demoted CMA pages to CMA
      hugetlb: add demote bool to gigantic page routines
      hugetlb: add hugetlb demote page support

    Liangcai Fan <liangcaifan19@gmail.com>:
      mm: khugepaged: recalculate min_free_kbytes after stopping khugepaged

    Mina Almasry <almasrymina@google.com>:
      mm, hugepages: add mremap() support for hugepage backed vma
      mm, hugepages: add hugetlb vma mremap() test

    Baolin Wang <baolin.wang@linux.alibaba.com>:
      hugetlb: support node specified when using cma for gigantic hugepages

    Ran Jianping <ran.jianping@zte.com.cn>:
      mm: remove duplicate include in hugepage-mremap.c

    Baolin Wang <baolin.wang@linux.alibaba.com>:
    Patch series "Some cleanups and improvements for hugetlb":
      hugetlb_cgroup: remove unused hugetlb_cgroup_from_counter macro
      hugetlb: replace the obsolete hugetlb_instantiation_mutex in the comments
      hugetlb: remove redundant validation in has_same_uncharge_info()
      hugetlb: remove redundant VM_BUG_ON() in add_reservation_in_range()

    Mike Kravetz <mike.kravetz@oracle.com>:
      hugetlb: remove unnecessary set_page_count in prep_compound_gigantic_page

Subsystem: mm/userfaultfd

    Axel Rasmussen <axelrasmussen@google.com>:
    Patch series "Small userfaultfd selftest fixups", v2:
      userfaultfd/selftests: don't rely on GNU extensions for random numbers
      userfaultfd/selftests: fix feature support detection
      userfaultfd/selftests: fix calculation of expected ioctls

Subsystem: mm/vmscan

    Miaohe Lin <linmiaohe@huawei.com>:
      mm/page_isolation: fix potential missing call to unset_migratetype_isolate()
      mm/page_isolation: guard against possible putback unisolated page

    Kai Song <songkai01@inspur.com>:
      mm/vmscan.c: fix -Wunused-but-set-variable warning

    Mel Gorman <mgorman@techsingularity.net>:
    Patch series "Remove dependency on congestion_wait in mm/", v5. Patch series:
      mm/vmscan: throttle reclaim until some writeback completes if congested
      mm/vmscan: throttle reclaim and compaction when too may pages are isolated
      mm/vmscan: throttle reclaim when no progress is being made
      mm/writeback: throttle based on page writeback instead of congestion
      mm/page_alloc: remove the throttling logic from the page allocator
      mm/vmscan: centralise timeout values for reclaim_throttle
      mm/vmscan: increase the timeout if page reclaim is not making progress
      mm/vmscan: delay waking of tasks throttled on NOPROGRESS

    Yuanzheng Song <songyuanzheng@huawei.com>:
      mm/vmpressure: fix data-race with memcg->socket_pressure

Subsystem: mm/tools

    Zhenliang Wei <weizhenliang@huawei.com>:
      tools/vm/page_owner_sort.c: count and sort by mem

    Naoya Horiguchi <naoya.horiguchi@nec.com>:
    Patch series "tools/vm/page-types.c: a few improvements":
      tools/vm/page-types.c: make walk_file() aware of address range option
      tools/vm/page-types.c: move show_file() to summary output
      tools/vm/page-types.c: print file offset in hexadecimal

Subsystem: mm/memblock

    Mike Rapoport <rppt@linux.ibm.com>:
    Patch series "memblock: cleanup memblock_free interface", v2:
      arch_numa: simplify numa_distance allocation
      xen/x86: free_p2m_page: use memblock_free_ptr() to free a virtual pointer
      memblock: drop memblock_free_early_nid() and memblock_free_early()
      memblock: stop aliasing __memblock_free_late with memblock_free_late
      memblock: rename memblock_free to memblock_phys_free
      memblock: use memblock_free for freeing virtual pointers

Subsystem: mm/oom-kill

    Sultan Alsawaf <sultan@kerneltoast.com>:
      mm: mark the OOM reaper thread as freezable

Subsystem: mm/hugetlbfs

    Zhenguo Yao <yaozhenguo1@gmail.com>:
      hugetlbfs: extend the definition of hugepages parameter to support node allocation

Subsystem: mm/migration

    John Hubbard <jhubbard@nvidia.com>:
      mm/migrate: de-duplicate migrate_reason strings

    Yang Shi <shy828301@gmail.com>:
      mm: migrate: make demotion knob depend on migration

Subsystem: mm/thp

    "George G. Davis" <davis.george@siemens.com>:
      selftests/vm/transhuge-stress: fix ram size thinko

    Rongwei Wang <rongwei.wang@linux.alibaba.com>:
    Patch series "fix two bugs for file THP":
      mm, thp: lock filemap when truncating page cache
      mm, thp: fix incorrect unmap behavior for private pages

Subsystem: mm/readahead

    Lin Feng <linf@wangsu.com>:
      mm/readahead.c: fix incorrect comments for get_init_ra_size

Subsystem: mm/nommu

    Kefeng Wang <wangkefeng.wang@huawei.com>:
      mm: nommu: kill arch_get_unmapped_area()

Subsystem: mm/ksm

    "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>:
      selftest/vm: fix ksm selftest to run with different NUMA topologies

    Pedro Demarchi Gomes <pedrodemargomes@gmail.com>:
      selftests: vm: add KSM huge pages merging time test

Subsystem: mm/vmstat

    Liu Shixin <liushixin2@huawei.com>:
      mm/vmstat: annotate data race for zone->free_area[order].nr_free

    Lin Feng <linf@wangsu.com>:
      mm: vmstat.c: make extfrag_index show more pretty

Subsystem: mm/madvise

    David Hildenbrand <david@redhat.com>:
      selftests/vm: make MADV_POPULATE_(READ|WRITE) use in-tree headers

Subsystem: mm/memory-hotplug

    Tang Yizhou <tangyizhou@huawei.com>:
      mm/memory_hotplug: add static qualifier for online_policy_to_str()

    David Hildenbrand <david@redhat.com>:
    Patch series "memory-hotplug.rst: document the "auto-movable" online policy":
      memory-hotplug.rst: fix two instances of "movablecore" that should be "movable_node"
      memory-hotplug.rst: fix wrong /sys/module/memory_hotplug/parameters/ path
      memory-hotplug.rst: document the "auto-movable" online policy
    Patch series "mm/memory_hotplug: Kconfig and 32 bit cleanups":
      mm/memory_hotplug: remove CONFIG_X86_64_ACPI_NUMA dependency from CONFIG_MEMORY_HOTPLUG
      mm/memory_hotplug: remove CONFIG_MEMORY_HOTPLUG_SPARSE
      mm/memory_hotplug: restrict CONFIG_MEMORY_HOTPLUG to 64 bit
      mm/memory_hotplug: remove HIGHMEM leftovers
      mm/memory_hotplug: remove stale function declarations
      x86: remove memory hotplug support on X86_32
    Patch series "mm/memory_hotplug: full support for add_memory_driver_managed() with CONFIG_ARCH_KEEP_MEMBLOCK", v2:
      mm/memory_hotplug: handle memblock_add_node() failures in add_memory_resource()
      memblock: improve MEMBLOCK_HOTPLUG documentation
      memblock: allow to specify flags with memblock_add_node()
      memblock: add MEMBLOCK_DRIVER_MANAGED to mimic IORESOURCE_SYSRAM_DRIVER_MANAGED
      mm/memory_hotplug: indicate MEMBLOCK_DRIVER_MANAGED with IORESOURCE_SYSRAM_DRIVER_MANAGED

Subsystem: mm/rmap

    Alistair Popple <apopple@nvidia.com>:
      mm/rmap.c: avoid double faults migrating device private pages

Subsystem: mm/zsmalloc

    Miaohe Lin <linmiaohe@huawei.com>:
      mm/zsmalloc.c: close race window between zs_pool_dec_isolated() and zs_unregister_migration()

Subsystem: mm/highmem

    Ira Weiny <ira.weiny@intel.com>:
      mm/highmem: remove deprecated kmap_atomic

Subsystem: mm/zram

    Jaewon Kim <jaewon31.kim@samsung.com>:
      zram_drv: allow reclaim on bio_alloc

    Dan Carpenter <dan.carpenter@oracle.com>:
      zram: off by one in read_block_state()

    Brian Geffon <bgeffon@google.com>:
      zram: introduce an aged idle interface

Subsystem: mm/cleanups

    Stephen Kitt <steve@sk2.org>:
      mm: remove HARDENED_USERCOPY_FALLBACK

    Mianhan Liu <liumh1@shanghaitech.edu.cn>:
      include/linux/mm.h: move nr_free_buffer_pages from swap.h to mm.h

Subsystem: mm/kfence

    Marco Elver <elver@google.com>:
      stacktrace: move filter_irq_stacks() to kernel/stacktrace.c
      kfence: count unexpectedly skipped allocations
      kfence: move saving stack trace of allocations into __kfence_alloc()
      kfence: limit currently covered allocations when pool nearly full
      kfence: add note to documentation about skipping covered allocations
      kfence: test: use kunit_skip() to skip tests
      kfence: shorten critical sections of alloc/free
      kfence: always use static branches to guard kfence_alloc()
      kfence: default to dynamic branch instead of static keys mode

Subsystem: mm/damon

    Geert Uytterhoeven <geert@linux-m68k.org>:
      mm/damon: grammar s/works/work/

    SeongJae Park <sjpark@amazon.de>:
      Documentation/vm: move user guides to admin-guide/mm/

    SeongJae Park <sj@kernel.org>:
      MAINTAINERS: update SeongJae's email address

    SeongJae Park <sjpark@amazon.de>:
      docs/vm/damon: remove broken reference
      include/linux/damon.h: fix kernel-doc comments for 'damon_callback'

    SeongJae Park <sj@kernel.org>:
      mm/damon/core: print kdamond start log in debug mode only

    Changbin Du <changbin.du@gmail.com>:
      mm/damon: remove unnecessary do_exit() from kdamond
      mm/damon: needn't hold kdamond_lock to print pid of kdamond

    Colin Ian King <colin.king@canonical.com>:
      mm/damon/core: nullify pointer ctx->kdamond with a NULL

    SeongJae Park <sj@kernel.org>:
    Patch series "Implement Data Access Monitoring-based Memory Operation Schemes":
      mm/damon/core: account age of target regions
      mm/damon/core: implement DAMON-based Operation Schemes (DAMOS)
      mm/damon/vaddr: support DAMON-based Operation Schemes
      mm/damon/dbgfs: support DAMON-based Operation Schemes
      mm/damon/schemes: implement statistics feature
      selftests/damon: add 'schemes' debugfs tests
      Docs/admin-guide/mm/damon: document DAMON-based Operation Schemes
    Patch series "DAMON: Support Physical Memory Address Space Monitoring::
      mm/damon/dbgfs: allow users to set initial monitoring target regions
      mm/damon/dbgfs-test: add a unit test case for 'init_regions'
      Docs/admin-guide/mm/damon: document 'init_regions' feature
      mm/damon/vaddr: separate commonly usable functions
      mm/damon: implement primitives for physical address space monitoring
      mm/damon/dbgfs: support physical memory monitoring
      Docs/DAMON: document physical memory monitoring support

    Rikard Falkeborn <rikard.falkeborn@gmail.com>:
      mm/damon/vaddr: constify static mm_walk_ops

    Rongwei Wang <rongwei.wang@linux.alibaba.com>:
      mm/damon/dbgfs: remove unnecessary variables

    SeongJae Park <sj@kernel.org>:
      mm/damon/paddr: support the pageout scheme
      mm/damon/schemes: implement size quota for schemes application speed control
      mm/damon/schemes: skip already charged targets and regions
      mm/damon/schemes: implement time quota
      mm/damon/dbgfs: support quotas of schemes
      mm/damon/selftests: support schemes quotas
      mm/damon/schemes: prioritize regions within the quotas
      mm/damon/vaddr,paddr: support pageout prioritization
      mm/damon/dbgfs: support prioritization weights
      tools/selftests/damon: update for regions prioritization of schemes
      mm/damon/schemes: activate schemes based on a watermarks mechanism
      mm/damon/dbgfs: support watermarks
      selftests/damon: support watermarks
      mm/damon: introduce DAMON-based Reclamation (DAMON_RECLAIM)
      Documentation/admin-guide/mm/damon: add a document for DAMON_RECLAIM

    Xin Hao <xhao@linux.alibaba.com>:
    Patch series "mm/damon: Fix some small bugs", v4:
      mm/damon: remove unnecessary variable initialization
      mm/damon/dbgfs: add adaptive_targets list check before enable monitor_on

    SeongJae Park <sj@kernel.org>:
    Patch series "Fix trivial nits in Documentation/admin-guide/mm":
      Docs/admin-guide/mm/damon/start: fix wrong example commands
      Docs/admin-guide/mm/damon/start: fix a wrong link
      Docs/admin-guide/mm/damon/start: simplify the content
      Docs/admin-guide/mm/pagemap: wordsmith page flags descriptions

    Changbin Du <changbin.du@gmail.com>:
      mm/damon: simplify stop mechanism

    Colin Ian King <colin.i.king@googlemail.com>:
      mm/damon: fix a few spelling mistakes in comments and a pr_debug message

    Changbin Du <changbin.du@gmail.com>:
      mm/damon: remove return value from before_terminate callback

 a/Documentation/admin-guide/blockdev/zram.rst                  |    8 
 a/Documentation/admin-guide/cgroup-v1/memory.rst               |   11 
 a/Documentation/admin-guide/kernel-parameters.txt              |   14 
 a/Documentation/admin-guide/mm/damon/index.rst                 |    1 
 a/Documentation/admin-guide/mm/damon/reclaim.rst               |  235 +++
 a/Documentation/admin-guide/mm/damon/start.rst                 |  140 +
 a/Documentation/admin-guide/mm/damon/usage.rst                 |  117 +
 a/Documentation/admin-guide/mm/hugetlbpage.rst                 |   42 
 a/Documentation/admin-guide/mm/memory-hotplug.rst              |  147 +-
 a/Documentation/admin-guide/mm/pagemap.rst                     |   75 -
 a/Documentation/core-api/memory-hotplug.rst                    |    3 
 a/Documentation/dev-tools/kfence.rst                           |   23 
 a/Documentation/translations/zh_CN/core-api/memory-hotplug.rst |    4 
 a/Documentation/vm/damon/design.rst                            |   29 
 a/Documentation/vm/damon/faq.rst                               |    5 
 a/Documentation/vm/damon/index.rst                             |    1 
 a/Documentation/vm/page_owner.rst                              |   23 
 a/MAINTAINERS                                                  |    2 
 a/Makefile                                                     |   15 
 a/arch/Kconfig                                                 |   28 
 a/arch/alpha/kernel/core_irongate.c                            |    6 
 a/arch/arc/mm/init.c                                           |    6 
 a/arch/arm/mach-hisi/platmcpm.c                                |    2 
 a/arch/arm/mach-rpc/ecard.c                                    |    2 
 a/arch/arm/mm/init.c                                           |    2 
 a/arch/arm64/Kconfig                                           |    4 
 a/arch/arm64/mm/kasan_init.c                                   |   16 
 a/arch/arm64/mm/mmu.c                                          |    4 
 a/arch/ia64/mm/contig.c                                        |    2 
 a/arch/ia64/mm/init.c                                          |    2 
 a/arch/m68k/mm/mcfmmu.c                                        |    3 
 a/arch/m68k/mm/motorola.c                                      |    6 
 a/arch/mips/loongson64/init.c                                  |    4 
 a/arch/mips/mm/init.c                                          |    6 
 a/arch/mips/sgi-ip27/ip27-memory.c                             |    3 
 a/arch/mips/sgi-ip30/ip30-setup.c                              |    6 
 a/arch/powerpc/Kconfig                                         |    1 
 a/arch/powerpc/configs/skiroot_defconfig                       |    1 
 a/arch/powerpc/include/asm/machdep.h                           |    2 
 a/arch/powerpc/include/asm/sections.h                          |   13 
 a/arch/powerpc/kernel/dt_cpu_ftrs.c                            |    8 
 a/arch/powerpc/kernel/paca.c                                   |    8 
 a/arch/powerpc/kernel/setup-common.c                           |    4 
 a/arch/powerpc/kernel/setup_64.c                               |    6 
 a/arch/powerpc/kernel/smp.c                                    |    2 
 a/arch/powerpc/mm/book3s64/radix_tlb.c                         |    4 
 a/arch/powerpc/mm/hugetlbpage.c                                |    9 
 a/arch/powerpc/platforms/powernv/pci-ioda.c                    |    4 
 a/arch/powerpc/platforms/powernv/setup.c                       |    4 
 a/arch/powerpc/platforms/pseries/setup.c                       |    2 
 a/arch/powerpc/platforms/pseries/svm.c                         |    9 
 a/arch/riscv/kernel/setup.c                                    |   10 
 a/arch/s390/include/asm/sections.h                             |   12 
 a/arch/s390/kernel/setup.c                                     |   11 
 a/arch/s390/kernel/smp.c                                       |    6 
 a/arch/s390/kernel/uv.c                                        |    2 
 a/arch/s390/mm/init.c                                          |    3 
 a/arch/s390/mm/kasan_init.c                                    |    2 
 a/arch/sh/boards/mach-ap325rxa/setup.c                         |    2 
 a/arch/sh/boards/mach-ecovec24/setup.c                         |    4 
 a/arch/sh/boards/mach-kfr2r09/setup.c                          |    2 
 a/arch/sh/boards/mach-migor/setup.c                            |    2 
 a/arch/sh/boards/mach-se/7724/setup.c                          |    4 
 a/arch/sparc/kernel/smp_64.c                                   |    4 
 a/arch/um/kernel/mem.c                                         |    4 
 a/arch/x86/Kconfig                                             |    6 
 a/arch/x86/kernel/setup.c                                      |    4 
 a/arch/x86/kernel/setup_percpu.c                               |    2 
 a/arch/x86/mm/init.c                                           |    2 
 a/arch/x86/mm/init_32.c                                        |   31 
 a/arch/x86/mm/kasan_init_64.c                                  |    4 
 a/arch/x86/mm/numa.c                                           |    2 
 a/arch/x86/mm/numa_emulation.c                                 |    2 
 a/arch/x86/xen/mmu_pv.c                                        |    8 
 a/arch/x86/xen/p2m.c                                           |    4 
 a/arch/x86/xen/setup.c                                         |    6 
 a/drivers/base/Makefile                                        |    2 
 a/drivers/base/arch_numa.c                                     |   96 +
 a/drivers/base/node.c                                          |    9 
 a/drivers/block/zram/zram_drv.c                                |   66 
 a/drivers/firmware/efi/memmap.c                                |    2 
 a/drivers/hwmon/occ/p9_sbe.c                                   |    1 
 a/drivers/macintosh/smu.c                                      |    2 
 a/drivers/mmc/core/mmc_test.c                                  |    1 
 a/drivers/mtd/mtdcore.c                                        |    1 
 a/drivers/of/kexec.c                                           |    4 
 a/drivers/of/of_reserved_mem.c                                 |    5 
 a/drivers/rapidio/devices/rio_mport_cdev.c                     |    9 
 a/drivers/s390/char/sclp_early.c                               |    4 
 a/drivers/usb/early/xhci-dbc.c                                 |   10 
 a/drivers/virtio/Kconfig                                       |    2 
 a/drivers/xen/swiotlb-xen.c                                    |    4 
 a/fs/d_path.c                                                  |    8 
 a/fs/exec.c                                                    |    4 
 a/fs/ocfs2/alloc.c                                             |   21 
 a/fs/ocfs2/dlm/dlmrecovery.c                                   |    1 
 a/fs/ocfs2/file.c                                              |    8 
 a/fs/ocfs2/inode.c                                             |    4 
 a/fs/ocfs2/journal.c                                           |   28 
 a/fs/ocfs2/journal.h                                           |    3 
 a/fs/ocfs2/super.c                                             |   40 
 a/fs/open.c                                                    |   16 
 a/fs/posix_acl.c                                               |    3 
 a/fs/proc/task_mmu.c                                           |   28 
 a/fs/super.c                                                   |    3 
 a/include/asm-generic/sections.h                               |   14 
 a/include/linux/backing-dev-defs.h                             |    3 
 a/include/linux/backing-dev.h                                  |    1 
 a/include/linux/cma.h                                          |    1 
 a/include/linux/compiler-gcc.h                                 |    8 
 a/include/linux/compiler_attributes.h                          |   10 
 a/include/linux/compiler_types.h                               |   12 
 a/include/linux/cpuset.h                                       |   17 
 a/include/linux/damon.h                                        |  258 +++
 a/include/linux/fs.h                                           |    1 
 a/include/linux/gfp.h                                          |    8 
 a/include/linux/highmem.h                                      |   28 
 a/include/linux/hugetlb.h                                      |   36 
 a/include/linux/io-mapping.h                                   |    6 
 a/include/linux/kasan.h                                        |    8 
 a/include/linux/kernel.h                                       |    1 
 a/include/linux/kfence.h                                       |   21 
 a/include/linux/memblock.h                                     |   48 
 a/include/linux/memcontrol.h                                   |    9 
 a/include/linux/memory.h                                       |   26 
 a/include/linux/memory_hotplug.h                               |    3 
 a/include/linux/mempolicy.h                                    |    5 
 a/include/linux/migrate.h                                      |   23 
 a/include/linux/migrate_mode.h                                 |   13 
 a/include/linux/mm.h                                           |   57 
 a/include/linux/mm_types.h                                     |    2 
 a/include/linux/mmzone.h                                       |   41 
 a/include/linux/node.h                                         |    4 
 a/include/linux/page-flags.h                                   |    2 
 a/include/linux/percpu.h                                       |    6 
 a/include/linux/sched/mm.h                                     |   25 
 a/include/linux/slab.h                                         |  181 +-
 a/include/linux/slub_def.h                                     |   13 
 a/include/linux/stackdepot.h                                   |    8 
 a/include/linux/stacktrace.h                                   |    1 
 a/include/linux/swap.h                                         |    1 
 a/include/linux/vmalloc.h                                      |   24 
 a/include/trace/events/mmap_lock.h                             |   50 
 a/include/trace/events/vmscan.h                                |   42 
 a/include/trace/events/writeback.h                             |    7 
 a/init/Kconfig                                                 |    2 
 a/init/initramfs.c                                             |    4 
 a/init/main.c                                                  |    6 
 a/kernel/cgroup/cpuset.c                                       |   23 
 a/kernel/cpu.c                                                 |    2 
 a/kernel/dma/swiotlb.c                                         |    6 
 a/kernel/exit.c                                                |    2 
 a/kernel/extable.c                                             |    2 
 a/kernel/fork.c                                                |   51 
 a/kernel/kexec_file.c                                          |    5 
 a/kernel/kthread.c                                             |   21 
 a/kernel/locking/lockdep.c                                     |   15 
 a/kernel/printk/printk.c                                       |    4 
 a/kernel/sched/core.c                                          |   37 
 a/kernel/sched/sched.h                                         |    4 
 a/kernel/sched/topology.c                                      |    1 
 a/kernel/stacktrace.c                                          |   30 
 a/kernel/tsacct.c                                              |    2 
 a/kernel/workqueue.c                                           |    2 
 a/lib/Kconfig.debug                                            |    2 
 a/lib/Kconfig.kfence                                           |   26 
 a/lib/bootconfig.c                                             |    2 
 a/lib/cpumask.c                                                |    6 
 a/lib/stackdepot.c                                             |   76 -
 a/lib/test_kasan.c                                             |   26 
 a/lib/test_kasan_module.c                                      |    2 
 a/lib/test_vmalloc.c                                           |    6 
 a/mm/Kconfig                                                   |   10 
 a/mm/backing-dev.c                                             |   65 
 a/mm/cma.c                                                     |   26 
 a/mm/compaction.c                                              |   12 
 a/mm/damon/Kconfig                                             |   24 
 a/mm/damon/Makefile                                            |    4 
 a/mm/damon/core.c                                              |  500 ++++++-
 a/mm/damon/dbgfs-test.h                                        |   56 
 a/mm/damon/dbgfs.c                                             |  486 +++++-
 a/mm/damon/paddr.c                                             |  275 +++
 a/mm/damon/prmtv-common.c                                      |  133 +
 a/mm/damon/prmtv-common.h                                      |   20 
 a/mm/damon/reclaim.c                                           |  356 ++++
 a/mm/damon/vaddr-test.h                                        |    2 
 a/mm/damon/vaddr.c                                             |  167 +-
 a/mm/debug.c                                                   |   20 
 a/mm/debug_vm_pgtable.c                                        |    7 
 a/mm/filemap.c                                                 |   78 -
 a/mm/gup.c                                                     |    5 
 a/mm/highmem.c                                                 |    6 
 a/mm/hugetlb.c                                                 |  713 +++++++++-
 a/mm/hugetlb_cgroup.c                                          |    3 
 a/mm/internal.h                                                |   26 
 a/mm/kasan/common.c                                            |    8 
 a/mm/kasan/generic.c                                           |   16 
 a/mm/kasan/kasan.h                                             |    2 
 a/mm/kasan/shadow.c                                            |    5 
 a/mm/kfence/core.c                                             |  214 ++-
 a/mm/kfence/kfence.h                                           |    2 
 a/mm/kfence/kfence_test.c                                      |   14 
 a/mm/khugepaged.c                                              |   10 
 a/mm/list_lru.c                                                |   58 
 a/mm/memblock.c                                                |   35 
 a/mm/memcontrol.c                                              |  217 +--
 a/mm/memory-failure.c                                          |  117 +
 a/mm/memory.c                                                  |  166 +-
 a/mm/memory_hotplug.c                                          |   57 
 a/mm/mempolicy.c                                               |  143 +-
 a/mm/migrate.c                                                 |   61 
 a/mm/mmap.c                                                    |    2 
 a/mm/mprotect.c                                                |    5 
 a/mm/mremap.c                                                  |   86 -
 a/mm/nommu.c                                                   |    6 
 a/mm/oom_kill.c                                                |   27 
 a/mm/page-writeback.c                                          |   13 
 a/mm/page_alloc.c                                              |  119 -
 a/mm/page_ext.c                                                |    2 
 a/mm/page_isolation.c                                          |   29 
 a/mm/percpu.c                                                  |   24 
 a/mm/readahead.c                                               |    2 
 a/mm/rmap.c                                                    |    8 
 a/mm/shmem.c                                                   |   44 
 a/mm/slab.c                                                    |   16 
 a/mm/slab_common.c                                             |    8 
 a/mm/slub.c                                                    |  117 -
 a/mm/sparse-vmemmap.c                                          |    2 
 a/mm/sparse.c                                                  |    6 
 a/mm/swap.c                                                    |   23 
 a/mm/swapfile.c                                                |    6 
 a/mm/userfaultfd.c                                             |    8 
 a/mm/vmalloc.c                                                 |  107 +
 a/mm/vmpressure.c                                              |    2 
 a/mm/vmscan.c                                                  |  194 ++
 a/mm/vmstat.c                                                  |   76 -
 a/mm/zsmalloc.c                                                |    7 
 a/net/ipv4/tcp.c                                               |    1 
 a/net/ipv4/udp.c                                               |    1 
 a/net/netfilter/ipvs/ip_vs_ctl.c                               |    1 
 a/net/openvswitch/meter.c                                      |    1 
 a/net/sctp/protocol.c                                          |    1 
 a/scripts/checkpatch.pl                                        |    3 
 a/scripts/decodecode                                           |    2 
 a/scripts/spelling.txt                                         |   18 
 a/security/Kconfig                                             |   14 
 a/tools/testing/selftests/damon/debugfs_attrs.sh               |   25 
 a/tools/testing/selftests/memory-hotplug/config                |    1 
 a/tools/testing/selftests/vm/.gitignore                        |    1 
 a/tools/testing/selftests/vm/Makefile                          |    1 
 a/tools/testing/selftests/vm/hugepage-mremap.c                 |  161 ++
 a/tools/testing/selftests/vm/ksm_tests.c                       |  154 ++
 a/tools/testing/selftests/vm/madv_populate.c                   |   15 
 a/tools/testing/selftests/vm/run_vmtests.sh                    |   11 
 a/tools/testing/selftests/vm/transhuge-stress.c                |    2 
 a/tools/testing/selftests/vm/userfaultfd.c                     |  157 +-
 a/tools/vm/page-types.c                                        |   38 
 a/tools/vm/page_owner_sort.c                                   |   94 +
 b/Documentation/admin-guide/mm/index.rst                       |    2 
 b/Documentation/vm/index.rst                                   |   26 
 260 files changed, 6448 insertions(+), 2327 deletions(-)

