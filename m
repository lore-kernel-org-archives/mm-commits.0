Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C15DC433FE
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:38:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbiCVVjf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:39:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbiCVVjf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:39:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A38F5E748
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:38:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C64206173C
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:38:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DA75C340EC;
        Tue, 22 Mar 2022 21:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985084;
        bh=MxRshht0r9p9BAsXFaR3fIiM/YMQ2QUx27dcxIlyREw=;
        h=Date:From:To:Cc:Subject:From;
        b=vF0tdYzAzwz5EvV4F/PoX4YJTUZZ8LmBxarmc+4W51aZRT47lvIJoyaGw5Q3dJ+oj
         J4pYz7ZZ2HfwVdY4X+Z2E/lck2HpbiYV09fB95IGmjlKZY7hAjTI+BLR2p3aIqJFuF
         Ft4stXCwXzYWnLwB2WYL3/vMzJh756gseResA1zQ=
Date:   Tue, 22 Mar 2022 14:38:03 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-mm@kvack.org, mm-commits@vger.kernel.org,
        patches@lists.linux.dev
Subject: incoming
Message-Id: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


- A few misc subsystems

- There is a lot of MM material in Willy's tree.  Folio work and
  non-folio patches which depended on that work.

  Here I send almost all the MM patches which precede the patches in
  Willy's tree.  The remaining ~100 MM patches are staged on Willy's
  tree and I'll send those along once Willy is merged up.

  I tried this batch against your current tree (as of
  51912904076680281) and a couple need some extra persuasion to apply,
  but all looks OK otherwise.


227 patches, based on f443e374ae131c168a065ea1748feac6b2e76613

Subsystems affected by this patch series:

  kthread
  scripts
  ntfs
  ocfs2
  block
  vfs
  mm/kasan
  mm/pagecache
  mm/gup
  mm/swap
  mm/shmem
  mm/memcg
  mm/selftests
  mm/pagemap
  mm/mremap
  mm/sparsemem
  mm/vmalloc
  mm/pagealloc
  mm/memory-failure
  mm/mlock
  mm/hugetlb
  mm/userfaultfd
  mm/vmscan
  mm/compaction
  mm/mempolicy
  mm/oom-kill
  mm/migration
  mm/thp
  mm/cma
  mm/autonuma
  mm/psi
  mm/ksm
  mm/page-poison
  mm/madvise
  mm/memory-hotplug
  mm/rmap
  mm/zswap
  mm/uaccess
  mm/ioremap
  mm/highmem
  mm/cleanups
  mm/kfence
  mm/hmm
  mm/damon

Subsystem: kthread

    Rasmus Villemoes <linux@rasmusvillemoes.dk>:
      linux/kthread.h: remove unused macros

Subsystem: scripts

    Colin Ian King <colin.i.king@gmail.com>:
      scripts/spelling.txt: add more spellings to spelling.txt

Subsystem: ntfs

    Dongliang Mu <mudongliangabcd@gmail.com>:
      ntfs: add sanity check on allocation size

Subsystem: ocfs2

    Joseph Qi <joseph.qi@linux.alibaba.com>:
      ocfs2: cleanup some return variables

    hongnanli <hongnan.li@linux.alibaba.com>:
      fs/ocfs2: fix comments mentioning i_mutex

Subsystem: block

    NeilBrown <neilb@suse.de>:
    Patch series "Remove remaining parts of congestion tracking code", v2:
      doc: convert 'subsection' to 'section' in gfp.h
      mm: document and polish read-ahead code
      mm: improve cleanup when ->readpages doesn't process all pages
      fuse: remove reliance on bdi congestion
      nfs: remove reliance on bdi congestion
      ceph: remove reliance on bdi congestion
      remove inode_congested()
      remove bdi_congested() and wb_congested() and related functions
      f2fs: replace congestion_wait() calls with io_schedule_timeout()
      block/bfq-iosched.c: use "false" rather than "BLK_RW_ASYNC"
      remove congestion tracking framework

Subsystem: vfs

    Anthony Iliopoulos <ailiop@suse.com>:
      mount: warn only once about timestamp range expiration

Subsystem: mm/kasan

    Miaohe Lin <linmiaohe@huawei.com>:
      mm/memremap: avoid calling kasan_remove_zero_shadow() for device private memory

Subsystem: mm/pagecache

    Miaohe Lin <linmiaohe@huawei.com>:
      filemap: remove find_get_pages()
      mm/writeback: minor clean up for highmem_dirtyable_memory

    Minchan Kim <minchan@kernel.org>:
      mm: fs: fix lru_cache_disabled race in bh_lru

Subsystem: mm/gup

    Peter Xu <peterx@redhat.com>:
    Patch series "mm/gup: some cleanups", v5:
      mm: fix invalid page pointer returned with FOLL_PIN gups

    John Hubbard <jhubbard@nvidia.com>:
      mm/gup: follow_pfn_pte(): -EEXIST cleanup
      mm/gup: remove unused pin_user_pages_locked()
      mm: change lookup_node() to use get_user_pages_fast()
      mm/gup: remove unused get_user_pages_locked()

Subsystem: mm/swap

    Bang Li <libang.linuxer@gmail.com>:
      mm/swap: fix confusing comment in folio_mark_accessed

Subsystem: mm/shmem

    Xavier Roche <xavier.roche@algolia.com>:
      tmpfs: support for file creation time

    Hugh Dickins <hughd@google.com>:
      shmem: mapping_set_exiting() to help mapped resilience
      tmpfs: do not allocate pages on read

    Miaohe Lin <linmiaohe@huawei.com>:
      mm: shmem: use helper macro __ATTR_RW

Subsystem: mm/memcg

    Shakeel Butt <shakeelb@google.com>:
      memcg: replace in_interrupt() with !in_task()

    Yosry Ahmed <yosryahmed@google.com>:
      memcg: add per-memcg total kernel memory stat

    Wei Yang <richard.weiyang@gmail.com>:
      mm/memcg: mem_cgroup_per_node is already set to 0 on allocation
      mm/memcg: retrieve parent memcg from css.parent

    Shakeel Butt <shakeelb@google.com>:
    Patch series "memcg: robust enforcement of memory.high", v2:
      memcg: refactor mem_cgroup_oom
      memcg: unify force charging conditions
      selftests: memcg: test high limit for single entry allocation
      memcg: synchronously enforce memory.high for large overcharges

    Randy Dunlap <rdunlap@infradead.org>:
      mm/memcontrol: return 1 from cgroup.memory __setup() handler

    Michal Hocko <mhocko@suse.com>:
    Patch series "mm/memcg: Address PREEMPT_RT problems instead of disabling it", v5:
      mm/memcg: revert ("mm/memcg: optimize user context object stock access")

    Sebastian Andrzej Siewior <bigeasy@linutronix.de>:
      mm/memcg: disable threshold event handlers on PREEMPT_RT
      mm/memcg: protect per-CPU counter by disabling preemption on PREEMPT_RT where needed.

    Johannes Weiner <hannes@cmpxchg.org>:
      mm/memcg: opencode the inner part of obj_cgroup_uncharge_pages() in drain_obj_stock()

    Sebastian Andrzej Siewior <bigeasy@linutronix.de>:
      mm/memcg: protect memcg_stock with a local_lock_t
      mm/memcg: disable migration instead of preemption in drain_all_stock().

    Muchun Song <songmuchun@bytedance.com>:
    Patch series "Optimize list lru memory consumption", v6:
      mm: list_lru: transpose the array of per-node per-memcg lru lists
      mm: introduce kmem_cache_alloc_lru
      fs: introduce alloc_inode_sb() to allocate filesystems specific inode
      fs: allocate inode by using alloc_inode_sb()
      f2fs: allocate inode by using alloc_inode_sb()
      mm: dcache: use kmem_cache_alloc_lru() to allocate dentry
      xarray: use kmem_cache_alloc_lru to allocate xa_node
      mm: memcontrol: move memcg_online_kmem() to mem_cgroup_css_online()
      mm: list_lru: allocate list_lru_one only when needed
      mm: list_lru: rename memcg_drain_all_list_lrus to memcg_reparent_list_lrus
      mm: list_lru: replace linear array with xarray
      mm: memcontrol: reuse memory cgroup ID for kmem ID
      mm: memcontrol: fix cannot alloc the maximum memcg ID
      mm: list_lru: rename list_lru_per_memcg to list_lru_memcg
      mm: memcontrol: rename memcg_cache_id to memcg_kmem_id

    Vasily Averin <vvs@virtuozzo.com>:
      memcg: enable accounting for tty-related objects

Subsystem: mm/selftests

    Guillaume Tucker <guillaume.tucker@collabora.com>:
      selftests, x86: fix how check_cc.sh is being invoked

Subsystem: mm/pagemap

    Anshuman Khandual <anshuman.khandual@arm.com>:
      mm: merge pte_mkhuge() call into arch_make_huge_pte()

    Stafford Horne <shorne@gmail.com>:
      mm: remove mmu_gathers storage from remaining architectures

    Muchun Song <songmuchun@bytedance.com>:
    Patch series "Fix some cache flush bugs", v5:
      mm: thp: fix wrong cache flush in remove_migration_pmd()
      mm: fix missing cache flush for all tail pages of compound page
      mm: hugetlb: fix missing cache flush in copy_huge_page_from_user()
      mm: hugetlb: fix missing cache flush in hugetlb_mcopy_atomic_pte()
      mm: shmem: fix missing cache flush in shmem_mfill_atomic_pte()
      mm: userfaultfd: fix missing cache flush in mcopy_atomic_pte() and __mcopy_atomic()
      mm: replace multiple dcache flush with flush_dcache_folio()

    Peter Xu <peterx@redhat.com>:
    Patch series "mm: Rework zap ptes on swap entries", v5:
      mm: don't skip swap entry even if zap_details specified
      mm: rename zap_skip_check_mapping() to should_zap_page()
      mm: change zap_details.zap_mapping into even_cows
      mm: rework swap handling of zap_pte_range

    Randy Dunlap <rdunlap@infradead.org>:
      mm/mmap: return 1 from stack_guard_gap __setup() handler

    Miaohe Lin <linmiaohe@huawei.com>:
      mm/memory.c: use helper function range_in_vma()
      mm/memory.c: use helper macro min and max in unmap_mapping_range_tree()

    Hugh Dickins <hughd@google.com>:
      mm: _install_special_mapping() apply VM_LOCKED_CLEAR_MASK

    Miaohe Lin <linmiaohe@huawei.com>:
      mm/mmap: remove obsolete comment in ksys_mmap_pgoff

Subsystem: mm/mremap

    Miaohe Lin <linmiaohe@huawei.com>:
      mm/mremap:: use vma_lookup() instead of find_vma()

Subsystem: mm/sparsemem

    Miaohe Lin <linmiaohe@huawei.com>:
      mm/sparse: make mminit_validate_memmodel_limits() static

Subsystem: mm/vmalloc

    Miaohe Lin <linmiaohe@huawei.com>:
      mm/vmalloc: remove unneeded function forward declaration

    "Uladzislau Rezki (Sony)" <urezki@gmail.com>:
      mm/vmalloc: Move draining areas out of caller context

    Uladzislau Rezki <uladzislau.rezki@sony.com>:
      mm/vmalloc: add adjust_search_size parameter

    "Uladzislau Rezki (Sony)" <urezki@gmail.com>:
      mm/vmalloc: eliminate an extra orig_gfp_mask

    Jiapeng Chong <jiapeng.chong@linux.alibaba.com>:
      mm/vmalloc.c: fix "unused function" warning

    Bang Li <libang.linuxer@gmail.com>:
      mm/vmalloc: fix comments about vmap_area struct

Subsystem: mm/pagealloc

    Zi Yan <ziy@nvidia.com>:
      mm: page_alloc: avoid merging non-fallbackable pageblocks with others

    Peter Collingbourne <pcc@google.com>:
      mm/mmzone.c: use try_cmpxchg() in page_cpupid_xchg_last()

    Miaohe Lin <linmiaohe@huawei.com>:
      mm/mmzone.h: remove unused macros

    Nicolas Saenz Julienne <nsaenzju@redhat.com>:
      mm/page_alloc: don't pass pfn to free_unref_page_commit()

    David Hildenbrand <david@redhat.com>:
    Patch series "mm: enforce pageblock_order < MAX_ORDER":
      cma: factor out minimum alignment requirement
      mm: enforce pageblock_order < MAX_ORDER

    Nathan Chancellor <nathan@kernel.org>:
      mm/page_alloc: mark pagesets as __maybe_unused

    Alistair Popple <apopple@nvidia.com>:
      mm/pages_alloc.c: don't create ZONE_MOVABLE beyond the end of a node

    Mel Gorman <mgorman@techsingularity.net>:
    Patch series "Follow-up on high-order PCP caching", v2:
      mm/page_alloc: fetch the correct pcp buddy during bulk free
      mm/page_alloc: track range of active PCP lists during bulk free
      mm/page_alloc: simplify how many pages are selected per pcp list during bulk free
      mm/page_alloc: drain the requested list first during bulk free
      mm/page_alloc: free pages in a single pass during bulk free
      mm/page_alloc: limit number of high-order pages on PCP during bulk free
      mm/page_alloc: do not prefetch buddies during bulk free

    Oscar Salvador <osalvador@suse.de>:
      arch/x86/mm/numa: Do not initialize nodes twice

    Suren Baghdasaryan <surenb@google.com>:
      mm: count time in drain_all_pages during direct reclaim as memory pressure

    Eric Dumazet <edumazet@google.com>:
      mm/page_alloc: call check_new_pages() while zone spinlock is not held

    Mel Gorman <mgorman@techsingularity.net>:
      mm/page_alloc: check high-order pages for corruption during PCP operations

Subsystem: mm/memory-failure

    Naoya Horiguchi <naoya.horiguchi@nec.com>:
      mm/memory-failure.c: remove obsolete comment
      mm/hwpoison: fix error page recovered but reported "not recovered"

    Rik van Riel <riel@surriel.com>:
      mm: invalidate hwpoison page cache page in fault path

    Miaohe Lin <linmiaohe@huawei.com>:
    Patch series "A few cleanup and fixup patches for memory failure", v3:
      mm/memory-failure.c: minor clean up for memory_failure_dev_pagemap
      mm/memory-failure.c: catch unexpected -EFAULT from vma_address()
      mm/memory-failure.c: rework the signaling logic in kill_proc
      mm/memory-failure.c: fix race with changing page more robustly
      mm/memory-failure.c: remove PageSlab check in hwpoison_filter_dev
      mm/memory-failure.c: rework the try_to_unmap logic in hwpoison_user_mappings()
      mm/memory-failure.c: remove obsolete comment in __soft_offline_page
      mm/memory-failure.c: remove unnecessary PageTransTail check
      mm/hwpoison-inject: support injecting hwpoison to free page

    luofei <luofei@unicloud.com>:
      mm/hwpoison: avoid the impact of hwpoison_filter() return value on mce handler
      mm/hwpoison: add in-use hugepage hwpoison filter judgement

    Miaohe Lin <linmiaohe@huawei.com>:
    Patch series "A few fixup patches for memory failure", v2:
      mm/memory-failure.c: fix race with changing page compound again
      mm/memory-failure.c: avoid calling invalidate_inode_page() with unexpected pages
      mm/memory-failure.c: make non-LRU movable pages unhandlable

    Vlastimil Babka <vbabka@suse.cz>:
      mm, fault-injection: declare should_fail_alloc_page()

Subsystem: mm/mlock

    Miaohe Lin <linmiaohe@huawei.com>:
      mm/mlock: fix potential imbalanced rlimit ucounts adjustment

Subsystem: mm/hugetlb

    Muchun Song <songmuchun@bytedance.com>:
    Patch series "Free the 2nd vmemmap page associated with each HugeTLB page", v7:
      mm: hugetlb: free the 2nd vmemmap page associated with each HugeTLB page
      mm: hugetlb: replace hugetlb_free_vmemmap_enabled with a static_key
      mm: sparsemem: use page table lock to protect kernel pmd operations
      selftests: vm: add a hugetlb test case
      mm: sparsemem: move vmemmap related to HugeTLB to CONFIG_HUGETLB_PAGE_FREE_VMEMMAP

    Anshuman Khandual <anshuman.khandual@arm.com>:
      mm/hugetlb: generalize ARCH_WANT_GENERAL_HUGETLB

    Mike Kravetz <mike.kravetz@oracle.com>:
      hugetlb: clean up potential spectre issue warnings

    Miaohe Lin <linmiaohe@huawei.com>:
      mm/hugetlb: use helper macro __ATTR_RW

    David Howells <dhowells@redhat.com>:
      mm/hugetlb.c: export PageHeadHuge()

    Miaohe Lin <linmiaohe@huawei.com>:
      mm: remove unneeded local variable follflags

Subsystem: mm/userfaultfd

    Nadav Amit <namit@vmware.com>:
      userfaultfd: provide unmasked address on page-fault

    Guo Zhengkui <guozhengkui@vivo.com>:
      userfaultfd/selftests: fix uninitialized_var.cocci warning

Subsystem: mm/vmscan

    Hugh Dickins <hughd@google.com>:
      mm/fs: delete PF_SWAPWRITE
      mm: __isolate_lru_page_prepare() in isolate_migratepages_block()

    Waiman Long <longman@redhat.com>:
      mm/list_lru: optimize memcg_reparent_list_lru_node()

    Marcelo Tosatti <mtosatti@redhat.com>:
      mm: lru_cache_disable: replace work queue synchronization with synchronize_rcu

    Sebastian Andrzej Siewior <bigeasy@linutronix.de>:
      mm: workingset: replace IRQ-off check with a lockdep assert.

    Charan Teja Kalla <quic_charante@quicinc.com>:
      mm: vmscan: fix documentation for page_check_references()

Subsystem: mm/compaction

    Baolin Wang <baolin.wang@linux.alibaba.com>:
      mm: compaction: cleanup the compaction trace events

Subsystem: mm/mempolicy

    Hugh Dickins <hughd@google.com>:
      mempolicy: mbind_range() set_policy() after vma_merge()

Subsystem: mm/oom-kill

    Miaohe Lin <linmiaohe@huawei.com>:
      mm/oom_kill: remove unneeded is_memcg_oom check

Subsystem: mm/migration

    Huang Ying <ying.huang@intel.com>:
      mm,migrate: fix establishing demotion target

    "andrew.yang" <andrew.yang@mediatek.com>:
      mm/migrate: fix race between lock page and clear PG_Isolated

Subsystem: mm/thp

    Hugh Dickins <hughd@google.com>:
      mm/thp: refix __split_huge_pmd_locked() for migration PMD

Subsystem: mm/cma

    Hari Bathini <hbathini@linux.ibm.com>:
    Patch series "powerpc/fadump: handle CMA activation failure appropriately", v3:
      mm/cma: provide option to opt out from exposing pages on activation failure
      powerpc/fadump: opt out from freeing pages on cma activation failure

Subsystem: mm/autonuma

    Huang Ying <ying.huang@intel.com>:
    Patch series "NUMA balancing: optimize memory placement for memory tiering system", v13:
      NUMA Balancing: add page promotion counter
      NUMA balancing: optimize page placement for memory tiering system
      memory tiering: skip to scan fast memory

Subsystem: mm/psi

    Johannes Weiner <hannes@cmpxchg.org>:
      mm: page_io: fix psi memory pressure error on cold swapins

Subsystem: mm/ksm

    Yang Yang <yang.yang29@zte.com.cn>:
      mm/vmstat: add event for ksm swapping in copy

    Miaohe Lin <linmiaohe@huawei.com>:
      mm/ksm: use helper macro __ATTR_RW

Subsystem: mm/page-poison

    "Matthew Wilcox (Oracle)" <willy@infradead.org>:
      mm/hwpoison: check the subpage, not the head page

Subsystem: mm/madvise

    Miaohe Lin <linmiaohe@huawei.com>:
      mm/madvise: use vma_lookup() instead of find_vma()

    Charan Teja Kalla <quic_charante@quicinc.com>:
    Patch series "mm: madvise: return correct bytes processed with:
      mm: madvise: return correct bytes advised with process_madvise
      mm: madvise: skip unmapped vma holes passed to process_madvise

Subsystem: mm/memory-hotplug

    Michal Hocko <mhocko@suse.com>:
    Patch series "mm, memory_hotplug: handle unitialized numa node gracefully":
      mm, memory_hotplug: make arch_alloc_nodedata independent on CONFIG_MEMORY_HOTPLUG
      mm: handle uninitialized numa nodes gracefully
      mm, memory_hotplug: drop arch_free_nodedata
      mm, memory_hotplug: reorganize new pgdat initialization
      mm: make free_area_init_node aware of memory less nodes

    Wei Yang <richard.weiyang@gmail.com>:
      memcg: do not tweak node in alloc_mem_cgroup_per_node_info

    David Hildenbrand <david@redhat.com>:
      drivers/base/memory: add memory block to memory group after registration succeeded
      drivers/base/node: consolidate node device subsystem initialization in node_dev_init()

    Miaohe Lin <linmiaohe@huawei.com>:
    Patch series "A few cleanup patches around memory_hotplug":
      mm/memory_hotplug: remove obsolete comment of __add_pages
      mm/memory_hotplug: avoid calling zone_intersects() for ZONE_NORMAL
      mm/memory_hotplug: clean up try_offline_node
      mm/memory_hotplug: fix misplaced comment in offline_pages

    David Hildenbrand <david@redhat.com>:
    Patch series "drivers/base/memory: determine and store zone for single-zone memory blocks", v2:
      drivers/base/node: rename link_mem_sections() to register_memory_block_under_node()
      drivers/base/memory: determine and store zone for single-zone memory blocks
      drivers/base/memory: clarify adding and removing of memory blocks

    Oscar Salvador <osalvador@suse.de>:
      mm: only re-generate demotion targets when a numa node changes its N_CPU state

Subsystem: mm/rmap

    Hugh Dickins <hughd@google.com>:
      mm/thp: ClearPageDoubleMap in first page_add_file_rmap()

Subsystem: mm/zswap

    "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>:
      mm/zswap.c: allow handling just same-value filled pages

Subsystem: mm/uaccess

    Christophe Leroy <christophe.leroy@csgroup.eu>:
      mm: remove usercopy_warn()
      mm: uninline copy_overflow()

    Randy Dunlap <rdunlap@infradead.org>:
      mm/usercopy: return 1 from hardened_usercopy __setup() handler

Subsystem: mm/ioremap

    Vlastimil Babka <vbabka@suse.cz>:
      mm/early_ioremap: declare early_memremap_pgprot_adjust()

Subsystem: mm/highmem

    Ira Weiny <ira.weiny@intel.com>:
      highmem: document kunmap_local()

    Miaohe Lin <linmiaohe@huawei.com>:
      mm/highmem: remove unnecessary done label

Subsystem: mm/cleanups

    "Dr. David Alan Gilbert" <linux@treblig.org>:
      mm/page_table_check.c: use strtobool for param parsing

Subsystem: mm/kfence

    tangmeng <tangmeng@uniontech.com>:
      mm/kfence: remove unnecessary CONFIG_KFENCE option

    Tianchen Ding <dtcccc@linux.alibaba.com>:
    Patch series "provide the flexibility to enable KFENCE", v3:
      kfence: allow re-enabling KFENCE after system startup
      kfence: alloc kfence_pool after system startup

    Peng Liu <liupeng256@huawei.com>:
    Patch series "kunit: fix a UAF bug and do some optimization", v2:
      kunit: fix UAF when run kfence test case test_gfpzero
      kunit: make kunit_test_timeout compatible with comment
      kfence: test: try to avoid test_gfpzero trigger rcu_stall

    Marco Elver <elver@google.com>:
      kfence: allow use of a deferrable timer

Subsystem: mm/hmm

    Miaohe Lin <linmiaohe@huawei.com>:
      mm/hmm.c: remove unneeded local variable ret

Subsystem: mm/damon

    SeongJae Park <sj@kernel.org>:
    Patch series "Remove the type-unclear target id concept":
      mm/damon/dbgfs/init_regions: use target index instead of target id
      Docs/admin-guide/mm/damon/usage: update for changed initail_regions file input
      mm/damon/core: move damon_set_targets() into dbgfs
      mm/damon: remove the target id concept

    Baolin Wang <baolin.wang@linux.alibaba.com>:
      mm/damon: remove redundant page validation

    SeongJae Park <sj@kernel.org>:
    Patch series "Allow DAMON user code independent of monitoring primitives":
      mm/damon: rename damon_primitives to damon_operations
      mm/damon: let monitoring operations can be registered and selected
      mm/damon/paddr,vaddr: register themselves to DAMON in subsys_initcall
      mm/damon/reclaim: use damon_select_ops() instead of damon_{v,p}a_set_operations()
      mm/damon/dbgfs: use damon_select_ops() instead of damon_{v,p}a_set_operations()
      mm/damon/dbgfs: use operations id for knowing if the target has pid
      mm/damon/dbgfs-test: fix is_target_id() change
      mm/damon/paddr,vaddr: remove damon_{p,v}a_{target_valid,set_operations}()

    tangmeng <tangmeng@uniontech.com>:
      mm/damon: remove unnecessary CONFIG_DAMON option

    SeongJae Park <sj@kernel.org>:
    Patch series "Docs/damon: Update documents for better consistency":
      Docs/vm/damon: call low level monitoring primitives the operations
      Docs/vm/damon/design: update DAMON-Idle Page Tracking interference handling
      Docs/damon: update outdated term 'regions update interval'
    Patch series "Introduce DAMON sysfs interface", v3:
      mm/damon/core: allow non-exclusive DAMON start/stop
      mm/damon/core: add number of each enum type values
      mm/damon: implement a minimal stub for sysfs-based DAMON interface
      mm/damon/sysfs: link DAMON for virtual address spaces monitoring
      mm/damon/sysfs: support the physical address space monitoring
      mm/damon/sysfs: support DAMON-based Operation Schemes
      mm/damon/sysfs: support DAMOS quotas
      mm/damon/sysfs: support schemes prioritization
      mm/damon/sysfs: support DAMOS watermarks
      mm/damon/sysfs: support DAMOS stats
      selftests/damon: add a test for DAMON sysfs interface
      Docs/admin-guide/mm/damon/usage: document DAMON sysfs interface
      Docs/ABI/testing: add DAMON sysfs interface ABI document

    Xin Hao <xhao@linux.alibaba.com>:
      mm/damon/sysfs: remove repeat container_of() in damon_sysfs_kdamond_release()

 Documentation/ABI/testing/sysfs-kernel-mm-damon  |  274 ++
 Documentation/admin-guide/cgroup-v1/memory.rst   |    2 
 Documentation/admin-guide/cgroup-v2.rst          |    5 
 Documentation/admin-guide/kernel-parameters.txt  |    2 
 Documentation/admin-guide/mm/damon/usage.rst     |  380 +++
 Documentation/admin-guide/mm/zswap.rst           |   22 
 Documentation/admin-guide/sysctl/kernel.rst      |   31 
 Documentation/core-api/mm-api.rst                |   19 
 Documentation/dev-tools/kfence.rst               |   12 
 Documentation/filesystems/porting.rst            |    6 
 Documentation/filesystems/vfs.rst                |   16 
 Documentation/vm/damon/design.rst                |   43 
 Documentation/vm/damon/faq.rst                   |    2 
 MAINTAINERS                                      |    1 
 arch/arm/Kconfig                                 |    4 
 arch/arm64/kernel/setup.c                        |    3 
 arch/arm64/mm/hugetlbpage.c                      |    1 
 arch/hexagon/mm/init.c                           |    2 
 arch/ia64/kernel/topology.c                      |   10 
 arch/ia64/mm/discontig.c                         |   11 
 arch/mips/kernel/topology.c                      |    5 
 arch/nds32/mm/init.c                             |    1 
 arch/openrisc/mm/init.c                          |    2 
 arch/powerpc/include/asm/fadump-internal.h       |    5 
 arch/powerpc/include/asm/nohash/32/hugetlb-8xx.h |    4 
 arch/powerpc/kernel/fadump.c                     |    8 
 arch/powerpc/kernel/sysfs.c                      |   17 
 arch/riscv/Kconfig                               |    4 
 arch/riscv/kernel/setup.c                        |    3 
 arch/s390/kernel/numa.c                          |    7 
 arch/sh/kernel/topology.c                        |    5 
 arch/sparc/kernel/sysfs.c                        |   12 
 arch/sparc/mm/hugetlbpage.c                      |    1 
 arch/x86/Kconfig                                 |    4 
 arch/x86/kernel/cpu/mce/core.c                   |    8 
 arch/x86/kernel/topology.c                       |    5 
 arch/x86/mm/numa.c                               |   33 
 block/bdev.c                                     |    2 
 block/bfq-iosched.c                              |    2 
 drivers/base/init.c                              |    1 
 drivers/base/memory.c                            |  149 +
 drivers/base/node.c                              |   48 
 drivers/block/drbd/drbd_int.h                    |    3 
 drivers/block/drbd/drbd_req.c                    |    3 
 drivers/dax/super.c                              |    2 
 drivers/of/of_reserved_mem.c                     |    9 
 drivers/tty/tty_io.c                             |    2 
 drivers/virtio/virtio_mem.c                      |    9 
 fs/9p/vfs_inode.c                                |    2 
 fs/adfs/super.c                                  |    2 
 fs/affs/super.c                                  |    2 
 fs/afs/super.c                                   |    2 
 fs/befs/linuxvfs.c                               |    2 
 fs/bfs/inode.c                                   |    2 
 fs/btrfs/inode.c                                 |    2 
 fs/buffer.c                                      |    8 
 fs/ceph/addr.c                                   |   22 
 fs/ceph/inode.c                                  |    2 
 fs/ceph/super.c                                  |    1 
 fs/ceph/super.h                                  |    1 
 fs/cifs/cifsfs.c                                 |    2 
 fs/coda/inode.c                                  |    2 
 fs/dcache.c                                      |    3 
 fs/ecryptfs/super.c                              |    2 
 fs/efs/super.c                                   |    2 
 fs/erofs/super.c                                 |    2 
 fs/exfat/super.c                                 |    2 
 fs/ext2/ialloc.c                                 |    5 
 fs/ext2/super.c                                  |    2 
 fs/ext4/super.c                                  |    2 
 fs/f2fs/compress.c                               |    4 
 fs/f2fs/data.c                                   |    3 
 fs/f2fs/f2fs.h                                   |    6 
 fs/f2fs/segment.c                                |    8 
 fs/f2fs/super.c                                  |   14 
 fs/fat/inode.c                                   |    2 
 fs/freevxfs/vxfs_super.c                         |    2 
 fs/fs-writeback.c                                |   40 
 fs/fuse/control.c                                |   17 
 fs/fuse/dev.c                                    |    8 
 fs/fuse/file.c                                   |   17 
 fs/fuse/inode.c                                  |    2 
 fs/gfs2/super.c                                  |    2 
 fs/hfs/super.c                                   |    2 
 fs/hfsplus/super.c                               |    2 
 fs/hostfs/hostfs_kern.c                          |    2 
 fs/hpfs/super.c                                  |    2 
 fs/hugetlbfs/inode.c                             |    2 
 fs/inode.c                                       |    2 
 fs/isofs/inode.c                                 |    2 
 fs/jffs2/super.c                                 |    2 
 fs/jfs/super.c                                   |    2 
 fs/minix/inode.c                                 |    2 
 fs/namespace.c                                   |    2 
 fs/nfs/inode.c                                   |    2 
 fs/nfs/write.c                                   |   14 
 fs/nilfs2/segbuf.c                               |   16 
 fs/nilfs2/super.c                                |    2 
 fs/ntfs/inode.c                                  |    6 
 fs/ntfs3/super.c                                 |    2 
 fs/ocfs2/alloc.c                                 |    2 
 fs/ocfs2/aops.c                                  |    2 
 fs/ocfs2/cluster/nodemanager.c                   |    2 
 fs/ocfs2/dir.c                                   |    4 
 fs/ocfs2/dlmfs/dlmfs.c                           |    2 
 fs/ocfs2/file.c                                  |   13 
 fs/ocfs2/inode.c                                 |    2 
 fs/ocfs2/localalloc.c                            |    6 
 fs/ocfs2/namei.c                                 |    2 
 fs/ocfs2/ocfs2.h                                 |    4 
 fs/ocfs2/quota_global.c                          |    2 
 fs/ocfs2/stack_user.c                            |   18 
 fs/ocfs2/super.c                                 |    2 
 fs/ocfs2/xattr.c                                 |    2 
 fs/openpromfs/inode.c                            |    2 
 fs/orangefs/super.c                              |    2 
 fs/overlayfs/super.c                             |    2 
 fs/proc/inode.c                                  |    2 
 fs/qnx4/inode.c                                  |    2 
 fs/qnx6/inode.c                                  |    2 
 fs/reiserfs/super.c                              |    2 
 fs/romfs/super.c                                 |    2 
 fs/squashfs/super.c                              |    2 
 fs/sysv/inode.c                                  |    2 
 fs/ubifs/super.c                                 |    2 
 fs/udf/super.c                                   |    2 
 fs/ufs/super.c                                   |    2 
 fs/userfaultfd.c                                 |    5 
 fs/vboxsf/super.c                                |    2 
 fs/xfs/libxfs/xfs_btree.c                        |    2 
 fs/xfs/xfs_buf.c                                 |    3 
 fs/xfs/xfs_icache.c                              |    2 
 fs/zonefs/super.c                                |    2 
 include/linux/backing-dev-defs.h                 |    8 
 include/linux/backing-dev.h                      |   50 
 include/linux/cma.h                              |   14 
 include/linux/damon.h                            |   95 
 include/linux/fault-inject.h                     |    2 
 include/linux/fs.h                               |   21 
 include/linux/gfp.h                              |   10 
 include/linux/highmem-internal.h                 |   10 
 include/linux/hugetlb.h                          |    8 
 include/linux/kthread.h                          |   22 
 include/linux/list_lru.h                         |   45 
 include/linux/memcontrol.h                       |   46 
 include/linux/memory.h                           |   12 
 include/linux/memory_hotplug.h                   |  132 -
 include/linux/migrate.h                          |    8 
 include/linux/mm.h                               |   11 
 include/linux/mmzone.h                           |   22 
 include/linux/nfs_fs_sb.h                        |    1 
 include/linux/node.h                             |   25 
 include/linux/page-flags.h                       |   96 
 include/linux/pageblock-flags.h                  |    7 
 include/linux/pagemap.h                          |    7 
 include/linux/sched.h                            |    1 
 include/linux/sched/sysctl.h                     |   10 
 include/linux/shmem_fs.h                         |    1 
 include/linux/slab.h                             |    3 
 include/linux/swap.h                             |    6 
 include/linux/thread_info.h                      |    5 
 include/linux/uaccess.h                          |    2 
 include/linux/vm_event_item.h                    |    3 
 include/linux/vmalloc.h                          |    4 
 include/linux/xarray.h                           |    9 
 include/ras/ras_event.h                          |    1 
 include/trace/events/compaction.h                |   26 
 include/trace/events/writeback.h                 |   28 
 include/uapi/linux/userfaultfd.h                 |    8 
 ipc/mqueue.c                                     |    2 
 kernel/dma/contiguous.c                          |    4 
 kernel/sched/core.c                              |   21 
 kernel/sysctl.c                                  |    2 
 lib/Kconfig.kfence                               |   12 
 lib/kunit/try-catch.c                            |    3 
 lib/xarray.c                                     |   10 
 mm/Kconfig                                       |    6 
 mm/backing-dev.c                                 |   57 
 mm/cma.c                                         |   31 
 mm/cma.h                                         |    1 
 mm/compaction.c                                  |   60 
 mm/damon/Kconfig                                 |   19 
 mm/damon/Makefile                                |    7 
 mm/damon/core-test.h                             |   23 
 mm/damon/core.c                                  |  190 +
 mm/damon/dbgfs-test.h                            |  103 
 mm/damon/dbgfs.c                                 |  264 +-
 mm/damon/ops-common.c                            |  133 +
 mm/damon/ops-common.h                            |   16 
 mm/damon/paddr.c                                 |   62 
 mm/damon/prmtv-common.c                          |  133 -
 mm/damon/prmtv-common.h                          |   16 
 mm/damon/reclaim.c                               |   11 
 mm/damon/sysfs.c                                 | 2632 ++++++++++++++++++++++-
 mm/damon/vaddr-test.h                            |    8 
 mm/damon/vaddr.c                                 |   67 
 mm/early_ioremap.c                               |    1 
 mm/fadvise.c                                     |    5 
 mm/filemap.c                                     |   17 
 mm/gup.c                                         |  103 
 mm/highmem.c                                     |    9 
 mm/hmm.c                                         |    3 
 mm/huge_memory.c                                 |   41 
 mm/hugetlb.c                                     |   23 
 mm/hugetlb_vmemmap.c                             |   74 
 mm/hwpoison-inject.c                             |    7 
 mm/internal.h                                    |   19 
 mm/kfence/Makefile                               |    2 
 mm/kfence/core.c                                 |  147 +
 mm/kfence/kfence_test.c                          |    3 
 mm/ksm.c                                         |    6 
 mm/list_lru.c                                    |  690 ++----
 mm/maccess.c                                     |    6 
 mm/madvise.c                                     |   18 
 mm/memcontrol.c                                  |  549 ++--
 mm/memory-failure.c                              |  148 -
 mm/memory.c                                      |  116 -
 mm/memory_hotplug.c                              |  136 -
 mm/mempolicy.c                                   |   29 
 mm/memremap.c                                    |    3 
 mm/migrate.c                                     |  128 -
 mm/mlock.c                                       |    1 
 mm/mmap.c                                        |    5 
 mm/mmzone.c                                      |    7 
 mm/mprotect.c                                    |   13 
 mm/mremap.c                                      |    4 
 mm/oom_kill.c                                    |    3 
 mm/page-writeback.c                              |   12 
 mm/page_alloc.c                                  |  429 +--
 mm/page_io.c                                     |    7 
 mm/page_table_check.c                            |   10 
 mm/ptdump.c                                      |   16 
 mm/readahead.c                                   |  124 +
 mm/rmap.c                                        |   15 
 mm/shmem.c                                       |   46 
 mm/slab.c                                        |   39 
 mm/slab.h                                        |   25 
 mm/slob.c                                        |    6 
 mm/slub.c                                        |   42 
 mm/sparse-vmemmap.c                              |   70 
 mm/sparse.c                                      |    2 
 mm/swap.c                                        |   25 
 mm/swapfile.c                                    |    1 
 mm/usercopy.c                                    |   16 
 mm/userfaultfd.c                                 |    3 
 mm/vmalloc.c                                     |  102 
 mm/vmscan.c                                      |  138 -
 mm/vmstat.c                                      |   19 
 mm/workingset.c                                  |    7 
 mm/zswap.c                                       |   15 
 net/socket.c                                     |    2 
 net/sunrpc/rpc_pipe.c                            |    2 
 scripts/spelling.txt                             |   16 
 tools/testing/selftests/cgroup/cgroup_util.c     |   15 
 tools/testing/selftests/cgroup/cgroup_util.h     |    1 
 tools/testing/selftests/cgroup/test_memcontrol.c |   78 
 tools/testing/selftests/damon/Makefile           |    1 
 tools/testing/selftests/damon/sysfs.sh           |  306 ++
 tools/testing/selftests/vm/.gitignore            |    1 
 tools/testing/selftests/vm/Makefile              |    7 
 tools/testing/selftests/vm/hugepage-vmemmap.c    |  144 +
 tools/testing/selftests/vm/run_vmtests.sh        |   11 
 tools/testing/selftests/vm/userfaultfd.c         |    2 
 tools/testing/selftests/x86/Makefile             |    6 
 264 files changed, 7205 insertions(+), 3090 deletions(-)

