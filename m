Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A85E2C433B4
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:32:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88CB9613CB
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:32:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230454AbhEEBdQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:33:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:36622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229799AbhEEBdQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:33:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C31AD613C7;
        Wed,  5 May 2021 01:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178339;
        bh=uwN86ZRW684Sd/tk+n4PtaiF29XEMcWsYkZhaizYmbo=;
        h=Date:From:To:Cc:Subject:From;
        b=Df458veIuSa/J56glVd0sKA6QzZmxWRoBlS3L70Cdy8D9ujyCK8npnMXa73xP/5wC
         J9TlFVEyVJ+y0qTHnBgEhl2QCkEAmKImBmfURF2gauoJ01AmW2EOycoaNY5BEWNoht
         NLRSFRrQijS3ahbM+z/Rxd4AWvEp2/p6Mzwd+v80=
Date:   Tue, 4 May 2021 18:32:19 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-mm@kvack.org, mm-commits@vger.kernel.org
Subject: incoming
Message-Id: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The remainder of the main mm/ queue.

143 patches, based on 8ca5297e7e38f2dc8c753d33a5092e7be181fff0, plus
previously sent patches.

Subsystems affected by this patch series:

  mm/pagecache
  mm/hugetlb
  mm/userfaultfd
  mm/vmscan
  mm/compaction
  mm/migration
  mm/cma
  mm/ksm
  mm/vmstat
  mm/mmap
  mm/kconfig
  mm/util
  mm/memory-hotplug
  mm/zswap
  mm/zsmalloc
  mm/highmem
  mm/cleanups
  mm/kfence

Subsystem: mm/pagecache

    "Matthew Wilcox (Oracle)" <willy@infradead.org>:
    Patch series "Remove nrexceptional tracking", v2:
      mm: introduce and use mapping_empty()
      mm: stop accounting shadow entries
      dax: account DAX entries as nrpages
      mm: remove nrexceptional from inode

    Hugh Dickins <hughd@google.com>:
      mm: remove nrexceptional from inode: remove BUG_ON

Subsystem: mm/hugetlb

    Peter Xu <peterx@redhat.com>:
    Patch series "hugetlb: Disable huge pmd unshare for uffd-wp", v4:
      hugetlb: pass vma into huge_pte_alloc() and huge_pmd_share()
      hugetlb/userfaultfd: forbid huge pmd sharing when uffd enabled
      mm/hugetlb: move flush_hugetlb_tlb_range() into hugetlb.h
      hugetlb/userfaultfd: unshare all pmds for hugetlbfs when register wp

    Miaohe Lin <linmiaohe@huawei.com>:
      mm/hugetlb: remove redundant reservation check condition in alloc_huge_page()

    Anshuman Khandual <anshuman.khandual@arm.com>:
      mm: generalize HUGETLB_PAGE_SIZE_VARIABLE

    Miaohe Lin <linmiaohe@huawei.com>:
    Patch series "Some cleanups for hugetlb":
      mm/hugetlb: use some helper functions to cleanup code
      mm/hugetlb: optimize the surplus state transfer code in move_hugetlb_state()
      mm/hugetlb_cgroup: remove unnecessary VM_BUG_ON_PAGE in hugetlb_cgroup_migrate()
      mm/hugetlb: simplify the code when alloc_huge_page() failed in hugetlb_no_page()
      mm/hugetlb: avoid calculating fault_mutex_hash in truncate_op case
    Patch series "Cleanup and fixup for khugepaged", v2:
      khugepaged: remove unneeded return value of khugepaged_collapse_pte_mapped_thps()
      khugepaged: reuse the smp_wmb() inside __SetPageUptodate()
      khugepaged: use helper khugepaged_test_exit() in __khugepaged_enter()
      khugepaged: fix wrong result value for trace_mm_collapse_huge_page_isolate()
      mm/huge_memory.c: remove unnecessary local variable ret2
    Patch series "Some cleanups for huge_memory", v3:
      mm/huge_memory.c: rework the function vma_adjust_trans_huge()
      mm/huge_memory.c: make get_huge_zero_page() return bool
      mm/huge_memory.c: rework the function do_huge_pmd_numa_page() slightly
      mm/huge_memory.c: remove redundant PageCompound() check
      mm/huge_memory.c: remove unused macro TRANSPARENT_HUGEPAGE_DEBUG_COW_FLAG
      mm/huge_memory.c: use helper function migration_entry_to_page()

    Yanfei Xu <yanfei.xu@windriver.com>:
      mm/khugepaged.c: replace barrier() with READ_ONCE() for a selective variable

    Miaohe Lin <linmiaohe@huawei.com>:
    Patch series "Cleanup for khugepaged":
      khugepaged: use helper function range_in_vma() in collapse_pte_mapped_thp()
      khugepaged: remove unnecessary out label in collapse_huge_page()
      khugepaged: remove meaningless !pte_present() check in khugepaged_scan_pmd()

    Zi Yan <ziy@nvidia.com>:
      mm: huge_memory: a new debugfs interface for splitting THP tests
      mm: huge_memory: debugfs for file-backed THP split

    Miaohe Lin <linmiaohe@huawei.com>:
    Patch series "Cleanup and fixup for hugetlb", v2:
      mm/hugeltb: remove redundant VM_BUG_ON() in region_add()
      mm/hugeltb: simplify the return code of __vma_reservation_common()
      mm/hugeltb: clarify (chg - freed) won't go negative in hugetlb_unreserve_pages()
      mm/hugeltb: handle the error case in hugetlb_fix_reserve_counts()
      mm/hugetlb: remove unused variable pseudo_vma in remove_inode_hugepages()

    Mike Kravetz <mike.kravetz@oracle.com>:
    Patch series "make hugetlb put_page safe for all calling contexts", v5:
      mm/cma: change cma mutex to irq safe spinlock
      hugetlb: no need to drop hugetlb_lock to call cma_release
      hugetlb: add per-hstate mutex to synchronize user adjustments
      hugetlb: create remove_hugetlb_page() to separate functionality
      hugetlb: call update_and_free_page without hugetlb_lock
      hugetlb: change free_pool_huge_page to remove_pool_huge_page
      hugetlb: make free_huge_page irq safe
      hugetlb: add lockdep_assert_held() calls for hugetlb_lock

    Oscar Salvador <osalvador@suse.de>:
    Patch series "Make alloc_contig_range handle Hugetlb pages", v10:
      mm,page_alloc: bail out earlier on -ENOMEM in alloc_contig_migrate_range
      mm,compaction: let isolate_migratepages_{range,block} return error codes
      mm,hugetlb: drop clearing of flag from prep_new_huge_page
      mm,hugetlb: split prep_new_huge_page functionality
      mm: make alloc_contig_range handle free hugetlb pages
      mm: make alloc_contig_range handle in-use hugetlb pages
      mm,page_alloc: drop unnecessary checks from pfn_range_valid_contig

Subsystem: mm/userfaultfd

    Axel Rasmussen <axelrasmussen@google.com>:
    Patch series "userfaultfd: add minor fault handling", v9:
      userfaultfd: add minor fault registration mode
      userfaultfd: disable huge PMD sharing for MINOR registered VMAs
      userfaultfd: hugetlbfs: only compile UFFD helpers if config enabled
      userfaultfd: add UFFDIO_CONTINUE ioctl
      userfaultfd: update documentation to describe minor fault handling
      userfaultfd/selftests: add test exercising minor fault handling

Subsystem: mm/vmscan

    Dave Hansen <dave.hansen@linux.intel.com>:
      mm/vmscan: move RECLAIM* bits to uapi header
      mm/vmscan: replace implicit RECLAIM_ZONE checks with explicit checks

    Yang Shi <shy828301@gmail.com>:
    Patch series "Make shrinker's nr_deferred memcg aware", v10:
      mm: vmscan: use nid from shrink_control for tracepoint
      mm: vmscan: consolidate shrinker_maps handling code
      mm: vmscan: use shrinker_rwsem to protect shrinker_maps allocation
      mm: vmscan: remove memcg_shrinker_map_size
      mm: vmscan: use kvfree_rcu instead of call_rcu
      mm: memcontrol: rename shrinker_map to shrinker_info
      mm: vmscan: add shrinker_info_protected() helper
      mm: vmscan: use a new flag to indicate shrinker is registered
      mm: vmscan: add per memcg shrinker nr_deferred
      mm: vmscan: use per memcg nr_deferred of shrinker
      mm: vmscan: don't need allocate shrinker->nr_deferred for memcg aware shrinkers
      mm: memcontrol: reparent nr_deferred when memcg offline
      mm: vmscan: shrink deferred objects proportional to priority

Subsystem: mm/compaction

    Pintu Kumar <pintu@codeaurora.org>:
      mm/compaction: remove unused variable sysctl_compact_memory

    Charan Teja Reddy <charante@codeaurora.org>:
      mm: compaction: update the COMPACT[STALL|FAIL] events properly

Subsystem: mm/migration

    Minchan Kim <minchan@kernel.org>:
      mm: disable LRU pagevec during the migration temporarily
      mm: replace migrate_[prep|finish] with lru_cache_[disable|enable]
      mm: fs: invalidate BH LRU during page migration

    Miaohe Lin <linmiaohe@huawei.com>:
    Patch series "Cleanup and fixup for mm/migrate.c", v3:
      mm/migrate.c: make putback_movable_page() static
      mm/migrate.c: remove unnecessary rc != MIGRATEPAGE_SUCCESS check in 'else' case
      mm/migrate.c: fix potential indeterminate pte entry in migrate_vma_insert_page()
      mm/migrate.c: use helper migrate_vma_collect_skip() in migrate_vma_collect_hole()
      Revert "mm: migrate: skip shared exec THP for NUMA balancing"

Subsystem: mm/cma

    Minchan Kim <minchan@kernel.org>:
      mm: vmstat: add cma statistics

    Baolin Wang <baolin.wang@linux.alibaba.com>:
      mm: cma: use pr_err_ratelimited for CMA warning

    Liam Mark <lmark@codeaurora.org>:
      mm: cma: add trace events for CMA alloc perf testing

    Minchan Kim <minchan@kernel.org>:
      mm: cma: support sysfs
      mm: cma: add the CMA instance name to cma trace events
      mm: use proper type for cma_[alloc|release]

Subsystem: mm/ksm

    Miaohe Lin <linmiaohe@huawei.com>:
    Patch series "Cleanup and fixup for ksm":
      ksm: remove redundant VM_BUG_ON_PAGE() on stable_tree_search()
      ksm: use GET_KSM_PAGE_NOLOCK to get ksm page in remove_rmap_item_from_tree()
      ksm: remove dedicated macro KSM_FLAG_MASK
      ksm: fix potential missing rmap_item for stable_node

    Chengyang Fan <cy.fan@huawei.com>:
      mm/ksm: remove unused parameter from remove_trailing_rmap_items()

Subsystem: mm/vmstat

    Hugh Dickins <hughd@google.com>:
      mm: restore node stat checking in /proc/sys/vm/stat_refresh
      mm: no more EINVAL from /proc/sys/vm/stat_refresh
      mm: /proc/sys/vm/stat_refresh skip checking known negative stats
      mm: /proc/sys/vm/stat_refresh stop checking monotonic numa stats

    Saravanan D <saravanand@fb.com>:
      x86/mm: track linear mapping split events

Subsystem: mm/mmap

    Liam Howlett <liam.howlett@oracle.com>:
      mm/mmap.c: don't unlock VMAs in remap_file_pages()

Subsystem: mm/kconfig

    Anshuman Khandual <anshuman.khandual@arm.com>:
    Patch series "mm: some config cleanups", v2:
      mm: generalize ARCH_HAS_CACHE_LINE_SIZE
      mm: generalize SYS_SUPPORTS_HUGETLBFS (rename as ARCH_SUPPORTS_HUGETLBFS)
      mm: generalize ARCH_ENABLE_MEMORY_[HOTPLUG|HOTREMOVE]
      mm: drop redundant ARCH_ENABLE_[HUGEPAGE|THP]_MIGRATION
      mm: drop redundant ARCH_ENABLE_SPLIT_PMD_PTLOCK
      mm: drop redundant HAVE_ARCH_TRANSPARENT_HUGEPAGE

Subsystem: mm/util

    Joe Perches <joe@perches.com>:
      mm/util.c: reduce mem_dump_obj() object size

    Bhaskar Chowdhury <unixbhaskar@gmail.com>:
      mm/util.c: fix typo

Subsystem: mm/memory-hotplug

    Pavel Tatashin <pasha.tatashin@soleen.com>:
    Patch series "prohibit pinning pages in ZONE_MOVABLE", v11:
      mm/gup: don't pin migrated cma pages in movable zone
      mm/gup: check every subpage of a compound page during isolation
      mm/gup: return an error on migration failure
      mm/gup: check for isolation errors
      mm cma: rename PF_MEMALLOC_NOCMA to PF_MEMALLOC_PIN
      mm: apply per-task gfp constraints in fast path
      mm: honor PF_MEMALLOC_PIN for all movable pages
      mm/gup: do not migrate zero page
      mm/gup: migrate pinned pages out of movable zone
      memory-hotplug.rst: add a note about ZONE_MOVABLE and page pinning
      mm/gup: change index type to long as it counts pages
      mm/gup: longterm pin migration cleanup
      selftests/vm: gup_test: fix test flag
      selftests/vm: gup_test: test faulting in kernel, and verify pinnable pages

    Mel Gorman <mgorman@techsingularity.net>:
      mm/memory_hotplug: remove broken locking of zone PCP structures during hot remove

    Oscar Salvador <osalvador@suse.de>:
    Patch series "Allocate memmap from hotadded memory (per device)", v10:
      drivers/base/memory: introduce memory_block_{online,offline}
      mm,memory_hotplug: relax fully spanned sections check

    David Hildenbrand <david@redhat.com>:
      mm,memory_hotplug: factor out adjusting present pages into adjust_present_page_count()

    Oscar Salvador <osalvador@suse.de>:
      mm,memory_hotplug: allocate memmap from the added memory range
      acpi,memhotplug: enable MHP_MEMMAP_ON_MEMORY when supported
      mm,memory_hotplug: add kernel boot option to enable memmap_on_memory
      x86/Kconfig: introduce ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE
      arm64/Kconfig: introduce ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE

Subsystem: mm/zswap

    Zhiyuan Dai <daizhiyuan@phytium.com.cn>:
      mm/zswap.c: switch from strlcpy to strscpy

Subsystem: mm/zsmalloc

    zhouchuangao <zhouchuangao@vivo.com>:
      mm/zsmalloc: use BUG_ON instead of if condition followed by BUG.

Subsystem: mm/highmem

    Ira Weiny <ira.weiny@intel.com>:
    Patch series "btrfs: Convert kmap/memset/kunmap to memzero_user()":
      iov_iter: lift memzero_page() to highmem.h
      btrfs: use memzero_page() instead of open coded kmap pattern

    songqiang <songqiang@uniontech.com>:
      mm/highmem.c: fix coding style issue

Subsystem: mm/cleanups

    Zhiyuan Dai <daizhiyuan@phytium.com.cn>:
      mm/mempool: minor coding style tweaks

    Zhang Yunkai <zhang.yunkai@zte.com.cn>:
      mm/process_vm_access.c: remove duplicate include

Subsystem: mm/kfence

    Marco Elver <elver@google.com>:
      kfence: zero guard page after out-of-bounds access
    Patch series "kfence: optimize timer scheduling", v2:
      kfence: await for allocation using wait_event
      kfence: maximize allocation wait timeout duration
      kfence: use power-efficient work queue to run delayed work

 Documentation/ABI/testing/sysfs-kernel-mm-cma     |   25 
 Documentation/admin-guide/kernel-parameters.txt   |   17 
 Documentation/admin-guide/mm/memory-hotplug.rst   |    9 
 Documentation/admin-guide/mm/userfaultfd.rst      |  105 +-
 arch/arc/Kconfig                                  |    9 
 arch/arm/Kconfig                                  |   10 
 arch/arm64/Kconfig                                |   34 
 arch/arm64/mm/hugetlbpage.c                       |    7 
 arch/ia64/Kconfig                                 |   14 
 arch/ia64/mm/hugetlbpage.c                        |    3 
 arch/mips/Kconfig                                 |    6 
 arch/mips/mm/hugetlbpage.c                        |    4 
 arch/parisc/Kconfig                               |    5 
 arch/parisc/mm/hugetlbpage.c                      |    2 
 arch/powerpc/Kconfig                              |   17 
 arch/powerpc/mm/hugetlbpage.c                     |    3 
 arch/powerpc/platforms/Kconfig.cputype            |   16 
 arch/riscv/Kconfig                                |    5 
 arch/s390/Kconfig                                 |   12 
 arch/s390/mm/hugetlbpage.c                        |    2 
 arch/sh/Kconfig                                   |    7 
 arch/sh/mm/Kconfig                                |    8 
 arch/sh/mm/hugetlbpage.c                          |    2 
 arch/sparc/mm/hugetlbpage.c                       |    2 
 arch/x86/Kconfig                                  |   33 
 arch/x86/mm/pat/set_memory.c                      |    8 
 drivers/acpi/acpi_memhotplug.c                    |    5 
 drivers/base/memory.c                             |  105 ++
 fs/Kconfig                                        |    5 
 fs/block_dev.c                                    |    2 
 fs/btrfs/compression.c                            |    5 
 fs/btrfs/extent_io.c                              |   22 
 fs/btrfs/inode.c                                  |   33 
 fs/btrfs/reflink.c                                |    6 
 fs/btrfs/zlib.c                                   |    5 
 fs/btrfs/zstd.c                                   |    5 
 fs/buffer.c                                       |   36 
 fs/dax.c                                          |    8 
 fs/gfs2/glock.c                                   |    3 
 fs/hugetlbfs/inode.c                              |    9 
 fs/inode.c                                        |   11 
 fs/proc/task_mmu.c                                |    3 
 fs/userfaultfd.c                                  |  149 +++
 include/linux/buffer_head.h                       |    4 
 include/linux/cma.h                               |    4 
 include/linux/compaction.h                        |    1 
 include/linux/fs.h                                |    2 
 include/linux/gfp.h                               |    2 
 include/linux/highmem.h                           |    7 
 include/linux/huge_mm.h                           |    3 
 include/linux/hugetlb.h                           |   37 
 include/linux/memcontrol.h                        |   27 
 include/linux/memory.h                            |    8 
 include/linux/memory_hotplug.h                    |   15 
 include/linux/memremap.h                          |    2 
 include/linux/migrate.h                           |   11 
 include/linux/mm.h                                |   28 
 include/linux/mmzone.h                            |   20 
 include/linux/pagemap.h                           |    5 
 include/linux/pgtable.h                           |   12 
 include/linux/sched.h                             |    2 
 include/linux/sched/mm.h                          |   27 
 include/linux/shrinker.h                          |    7 
 include/linux/swap.h                              |   21 
 include/linux/userfaultfd_k.h                     |   55 +
 include/linux/vm_event_item.h                     |    8 
 include/trace/events/cma.h                        |   92 +-
 include/trace/events/migrate.h                    |   25 
 include/trace/events/mmflags.h                    |    7 
 include/uapi/linux/mempolicy.h                    |    7 
 include/uapi/linux/userfaultfd.h                  |   36 
 init/Kconfig                                      |    5 
 kernel/sysctl.c                                   |    2 
 lib/Kconfig.kfence                                |    1 
 lib/iov_iter.c                                    |    8 
 mm/Kconfig                                        |   28 
 mm/Makefile                                       |    6 
 mm/cma.c                                          |   70 +
 mm/cma.h                                          |   25 
 mm/cma_debug.c                                    |    8 
 mm/cma_sysfs.c                                    |  112 ++
 mm/compaction.c                                   |  113 ++
 mm/filemap.c                                      |   24 
 mm/frontswap.c                                    |   12 
 mm/gup.c                                          |  264 +++---
 mm/gup_test.c                                     |   29 
 mm/gup_test.h                                     |    3 
 mm/highmem.c                                      |   11 
 mm/huge_memory.c                                  |  326 +++++++-
 mm/hugetlb.c                                      |  843 ++++++++++++++--------
 mm/hugetlb_cgroup.c                               |    9 
 mm/internal.h                                     |   10 
 mm/kfence/core.c                                  |   61 +
 mm/khugepaged.c                                   |   63 -
 mm/ksm.c                                          |   17 
 mm/list_lru.c                                     |    6 
 mm/memcontrol.c                                   |  137 ---
 mm/memory_hotplug.c                               |  220 +++++
 mm/mempolicy.c                                    |   16 
 mm/mempool.c                                      |    2 
 mm/migrate.c                                      |  103 --
 mm/mlock.c                                        |    4 
 mm/mmap.c                                         |   18 
 mm/oom_kill.c                                     |    2 
 mm/page_alloc.c                                   |   83 +-
 mm/process_vm_access.c                            |    1 
 mm/shmem.c                                        |    2 
 mm/sparse.c                                       |    4 
 mm/swap.c                                         |   69 +
 mm/swap_state.c                                   |    4 
 mm/swapfile.c                                     |    4 
 mm/truncate.c                                     |   19 
 mm/userfaultfd.c                                  |   39 -
 mm/util.c                                         |   26 
 mm/vmalloc.c                                      |    2 
 mm/vmscan.c                                       |  543 +++++++++-----
 mm/vmstat.c                                       |   45 -
 mm/workingset.c                                   |    1 
 mm/zsmalloc.c                                     |    6 
 mm/zswap.c                                        |    2 
 tools/testing/selftests/vm/.gitignore             |    1 
 tools/testing/selftests/vm/Makefile               |    1 
 tools/testing/selftests/vm/gup_test.c             |   38 
 tools/testing/selftests/vm/split_huge_page_test.c |  400 ++++++++++
 tools/testing/selftests/vm/userfaultfd.c          |  164 ++++
 125 files changed, 3596 insertions(+), 1668 deletions(-)

