Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51367C433DB
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:01:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D71A64F28
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:01:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235052AbhBXUAu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:00:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:53704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235136AbhBXT7H (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 14:59:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D6B5264F06;
        Wed, 24 Feb 2021 19:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614196705;
        bh=kyDpJX76VL2X4i725mrDvtfemqJZEcE0LXXClNMsIXQ=;
        h=Date:From:To:Cc:Subject:From;
        b=1zJFPL3D6HO/OygdtRJPTj5JPMAQtonEPV/0z6TsJSHcpPynNUN0dD4cvK5ydhKmC
         eqBbppzBDmrHZ8JW+aILSOhHeF2knjRK6LNhxhlxOM7rZePkg6O+y5zGYsiNa4FRsV
         5CUkJ40qDL7Ux8z3fC+QnI34P9QTRfZ71FzGBhPQ=
Date:   Wed, 24 Feb 2021 11:58:24 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-mm@kvack.org, mm-commits@vger.kernel.org
Subject: incoming
Message-Id: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


A few small subsystems and some of MM.


173 patches, based on c03c21ba6f4e95e406a1a7b4c34ef334b977c194.

Subsystems affected by this patch series:

  hexagon
  scripts
  ntfs
  ocfs2
  vfs
  mm/slab-generic
  mm/slab
  mm/slub
  mm/debug
  mm/pagecache
  mm/swap
  mm/memcg
  mm/pagemap
  mm/mprotect
  mm/mremap
  mm/page-reporting
  mm/vmalloc
  mm/kasan
  mm/pagealloc
  mm/memory-failure
  mm/hugetlb
  mm/vmscan
  mm/z3fold
  mm/compaction
  mm/mempolicy
  mm/oom-kill
  mm/hugetlbfs
  mm/migration

Subsystem: hexagon

    Randy Dunlap <rdunlap@infradead.org>:
      hexagon: remove CONFIG_EXPERIMENTAL from defconfigs

Subsystem: scripts

    tangchunyou <tangchunyou@yulong.com>:
      scripts/spelling.txt: increase error-prone spell checking

    zuoqilin <zuoqilin@yulong.com>:
      scripts/spelling.txt: check for "exeeds"

    dingsenjie <dingsenjie@yulong.com>:
      scripts/spelling.txt: add "allocted" and "exeeds" typo

    Colin Ian King <colin.king@canonical.com>:
      scripts/spelling.txt: add more spellings to spelling.txt

Subsystem: ntfs

    Randy Dunlap <rdunlap@infradead.org>:
      ntfs: layout.h: delete duplicated words

    Rustam Kovhaev <rkovhaev@gmail.com>:
      ntfs: check for valid standard information attribute

Subsystem: ocfs2

    Yi Li <yili@winhong.com>:
      ocfs2: remove redundant conditional before iput

    guozh <guozh88@chinatelecom.cn>:
      ocfs2: clean up some definitions which are not used any more

    Dan Carpenter <dan.carpenter@oracle.com>:
      ocfs2: fix a use after free on error

    Jiapeng Chong <jiapeng.chong@linux.alibaba.com>:
      ocfs2: simplify the calculation of variables

Subsystem: vfs

    Randy Dunlap <rdunlap@infradead.org>:
      fs: delete repeated words in comments

    Alexey Dobriyan <adobriyan@gmail.com>:
      ramfs: support O_TMPFILE

Subsystem: mm/slab-generic

    Jacob Wen <jian.w.wen@oracle.com>:
      mm, tracing: record slab name for kmem_cache_free()

    Nikolay Borisov <nborisov@suse.com>:
      mm/sl?b.c: remove ctor argument from kmem_cache_flags

Subsystem: mm/slab

    Zhiyuan Dai <daizhiyuan@phytium.com.cn>:
      mm/slab: minor coding style tweaks

Subsystem: mm/slub

    Johannes Berg <johannes.berg@intel.com>:
      mm/slub: disable user tracing for kmemleak caches by default

    Vlastimil Babka <vbabka@suse.cz>:
    Patch series "mm, slab, slub: remove cpu and memory hotplug locks":
      mm, slub: stop freeing kmem_cache_node structures on node offline
      mm, slab, slub: stop taking memory hotplug lock
      mm, slab, slub: stop taking cpu hotplug lock
      mm, slub: splice cpu and page freelists in deactivate_slab()
      mm, slub: remove slub_memcg_sysfs boot param and CONFIG_SLUB_MEMCG_SYSFS_ON

    Zhiyuan Dai <daizhiyuan@phytium.com.cn>:
      mm/slub: minor coding style tweaks

Subsystem: mm/debug

    "Matthew Wilcox (Oracle)" <willy@infradead.org>:
      mm/debug: improve memcg debugging

    Anshuman Khandual <anshuman.khandual@arm.com>:
    Patch series "mm/debug_vm_pgtable: Some minor updates", v3:
      mm/debug_vm_pgtable/basic: add validation for dirtiness after write protect
      mm/debug_vm_pgtable/basic: iterate over entire protection_map[]

    Miaohe Lin <linmiaohe@huawei.com>:
      mm/page_owner: use helper function zone_end_pfn() to get end_pfn

Subsystem: mm/pagecache

    Baolin Wang <baolin.wang@linux.alibaba.com>:
      mm/filemap: remove unused parameter and change to void type for replace_page_cache_page()

    Pavel Begunkov <asml.silence@gmail.com>:
      mm/filemap: don't revert iter on -EIOCBQUEUED

    "Matthew Wilcox (Oracle)" <willy@infradead.org>:
    Patch series "Refactor generic_file_buffered_read", v5:
      mm/filemap: rename generic_file_buffered_read subfunctions
      mm/filemap: remove dynamically allocated array from filemap_read
      mm/filemap: convert filemap_get_pages to take a pagevec
      mm/filemap: use head pages in generic_file_buffered_read
      mm/filemap: pass a sleep state to put_and_wait_on_page_locked
      mm/filemap: support readpage splitting a page
      mm/filemap: inline __wait_on_page_locked_async into caller
      mm/filemap: don't call ->readpage if IOCB_WAITQ is set
      mm/filemap: change filemap_read_page calling conventions
      mm/filemap: change filemap_create_page calling conventions
      mm/filemap: convert filemap_update_page to return an errno
      mm/filemap: move the iocb checks into filemap_update_page
      mm/filemap: add filemap_range_uptodate
      mm/filemap: split filemap_readahead out of filemap_get_pages
      mm/filemap: restructure filemap_get_pages
      mm/filemap: don't relock the page after calling readpage

    Christoph Hellwig <hch@lst.de>:
      mm/filemap: rename generic_file_buffered_read to filemap_read
      mm/filemap: simplify generic_file_read_iter

    Yang Guo <guoyang2@huawei.com>:
      fs/buffer.c: add checking buffer head stat before clear

    Baolin Wang <baolin.wang@linux.alibaba.com>:
      mm: backing-dev: Remove duplicated macro definition

Subsystem: mm/swap

    Yang Li <abaci-bugfix@linux.alibaba.com>:
      mm/swap_slots.c: remove redundant NULL check

    Stephen Zhang <stephenzhangzsd@gmail.com>:
      mm/swapfile.c: fix debugging information problem

    Georgi Djakov <georgi.djakov@linaro.org>:
      mm/page_io: use pr_alert_ratelimited for swap read/write errors

    Rikard Falkeborn <rikard.falkeborn@gmail.com>:
      mm/swap_state: constify static struct attribute_group

    Yu Zhao <yuzhao@google.com>:
      mm/swap: don't SetPageWorkingset unconditionally during swapin

Subsystem: mm/memcg

    Roman Gushchin <guro@fb.com>:
      mm: memcg/slab: pre-allocate obj_cgroups for slab caches with SLAB_ACCOUNT

    Muchun Song <songmuchun@bytedance.com>:
      mm: memcontrol: optimize per-lruvec stats counter memory usage
    Patch series "Convert all THP vmstat counters to pages", v6:
      mm: memcontrol: fix NR_ANON_THPS accounting in charge moving
      mm: memcontrol: convert NR_ANON_THPS account to pages
      mm: memcontrol: convert NR_FILE_THPS account to pages
      mm: memcontrol: convert NR_SHMEM_THPS account to pages
      mm: memcontrol: convert NR_SHMEM_PMDMAPPED account to pages
      mm: memcontrol: convert NR_FILE_PMDMAPPED account to pages
      mm: memcontrol: make the slab calculation consistent

    Alex Shi <alex.shi@linux.alibaba.com>:
      mm/memcg: revise the using condition of lock_page_lruvec function series
      mm/memcg: remove rcu locking for lock_page_lruvec function series

    Shakeel Butt <shakeelb@google.com>:
      mm: memcg: add swapcache stat for memcg v2

    Roman Gushchin <guro@fb.com>:
      mm: kmem: make __memcg_kmem_(un)charge static

    Feng Tang <feng.tang@intel.com>:
      mm: page_counter: re-layout structure to reduce false sharing

    Yang Li <abaci-bugfix@linux.alibaba.com>:
      mm/memcontrol: remove redundant NULL check

    Muchun Song <songmuchun@bytedance.com>:
      mm: memcontrol: replace the loop with a list_for_each_entry()

    Shakeel Butt <shakeelb@google.com>:
      mm/list_lru.c: remove kvfree_rcu_local()

    Johannes Weiner <hannes@cmpxchg.org>:
      fs: buffer: use raw page_memcg() on locked page

    Muchun Song <songmuchun@bytedance.com>:
      mm: memcontrol: fix swap undercounting in cgroup2
      mm: memcontrol: fix get_active_memcg return value
      mm: memcontrol: fix slub memory accounting

Subsystem: mm/pagemap

    Adrian Huang <ahuang12@lenovo.com>:
      mm/mmap.c: remove unnecessary local variable

    Miaohe Lin <linmiaohe@huawei.com>:
      mm/memory.c: fix potential pte_unmap_unlock pte error
      mm/pgtable-generic.c: simplify the VM_BUG_ON condition in pmdp_huge_clear_flush()
      mm/pgtable-generic.c: optimize the VM_BUG_ON condition in pmdp_huge_clear_flush()
      mm/memory.c: fix potential pte_unmap_unlock pte error

Subsystem: mm/mprotect

    Tianjia Zhang <tianjia.zhang@linux.alibaba.com>:
      mm/mprotect.c: optimize error detection in do_mprotect_pkey()

Subsystem: mm/mremap

    Li Xinhai <lixinhai.lxh@gmail.com>:
      mm: rmap: explicitly reset vma->anon_vma in unlink_anon_vmas()
      mm: mremap: unlink anon_vmas when mremap with MREMAP_DONTUNMAP success

Subsystem: mm/page-reporting

    sh <sh_def@163.com>:
      mm/page_reporting: use list_entry_is_head() in page_reporting_cycle()

Subsystem: mm/vmalloc

    Yang Li <abaci-bugfix@linux.alibaba.com>:
      vmalloc: remove redundant NULL check

Subsystem: mm/kasan

    Andrey Konovalov <andreyknvl@google.com>:
    Patch series "kasan: HW_TAGS tests support and fixes", v4:
      kasan: prefix global functions with kasan_
      kasan: clarify HW_TAGS impact on TBI
      kasan: clean up comments in tests
      kasan: add macros to simplify checking test constraints
      kasan: add match-all tag tests
      kasan, arm64: allow using KUnit tests with HW_TAGS mode
      kasan: rename CONFIG_TEST_KASAN_MODULE
      kasan: add compiler barriers to KUNIT_EXPECT_KASAN_FAIL
      kasan: adapt kmalloc_uaf2 test to HW_TAGS mode
      kasan: fix memory corruption in kasan_bitops_tags test
      kasan: move _RET_IP_ to inline wrappers
      kasan: fix bug detection via ksize for HW_TAGS mode
      kasan: add proper page allocator tests
      kasan: add a test for kmem_cache_alloc/free_bulk
      kasan: don't run tests when KASAN is not enabled

    Walter Wu <walter-zh.wu@mediatek.com>:
      kasan: remove redundant config option

Subsystem: mm/pagealloc

    Baoquan He <bhe@redhat.com>:
    Patch series "mm: clean up names and parameters of memmap_init_xxxx functions", v5:
      mm: fix prototype warning from kernel test robot
      mm: rename memmap_init() and memmap_init_zone()
      mm: simplify parater of function memmap_init_zone()
      mm: simplify parameter of setup_usemap()
      mm: remove unneeded local variable in free_area_init_core

    David Hildenbrand <david@redhat.com>:
    Patch series "mm: simplify free_highmem_page() and free_reserved_page()":
      video: fbdev: acornfb: remove free_unused_pages()
      mm: simplify free_highmem_page() and free_reserved_page()

    "Matthew Wilcox (Oracle)" <willy@infradead.org>:
      mm/gfp: add kernel-doc for gfp_t

Subsystem: mm/memory-failure

    Aili Yao <yaoaili@kingsoft.com>:
      mm,hwpoison: send SIGBUS to PF_MCE_EARLY processes on action required events

Subsystem: mm/hugetlb

    Bibo Mao <maobibo@loongson.cn>:
      mm/huge_memory.c: update tlb entry if pmd is changed
      MIPS: do not call flush_tlb_all when setting pmd entry

    Miaohe Lin <linmiaohe@huawei.com>:
      mm/hugetlb: fix potential double free in hugetlb_register_node() error path

    Li Xinhai <lixinhai.lxh@gmail.com>:
      mm/hugetlb.c: fix unnecessary address expansion of pmd sharing

    Miaohe Lin <linmiaohe@huawei.com>:
      mm/hugetlb: avoid unnecessary hugetlb_acct_memory() call
      mm/hugetlb: use helper huge_page_order and pages_per_huge_page
      mm/hugetlb: fix use after free when subpool max_hpages accounting is not enabled

    Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>:
      mm/hugetlb: simplify the calculation of variables

    Joao Martins <joao.m.martins@oracle.com>:
    Patch series "mm/hugetlb: follow_hugetlb_page() improvements", v2:
      mm/hugetlb: grab head page refcount once for group of subpages
      mm/hugetlb: refactor subpage recording

    Miaohe Lin <linmiaohe@huawei.com>:
      mm/hugetlb: fix some comment typos

    Yanfei Xu <yanfei.xu@windriver.com>:
      mm/hugetlb: remove redundant check in preparing and destroying gigantic page

    Zhiyuan Dai <daizhiyuan@phytium.com.cn>:
      mm/hugetlb.c: fix typos in comments

    Miaohe Lin <linmiaohe@huawei.com>:
      mm/huge_memory.c: remove unused return value of set_huge_zero_page()

    "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>:
      mm/pmem: avoid inserting hugepage PTE entry with fsdax if hugepage support is disabled

    Miaohe Lin <linmiaohe@huawei.com>:
      hugetlb_cgroup: use helper pages_per_huge_page() in hugetlb_cgroup
      mm/hugetlb: use helper function range_in_vma() in page_table_shareable()
      mm/hugetlb: remove unnecessary VM_BUG_ON_PAGE on putback_active_hugepage()
      mm/hugetlb: use helper huge_page_size() to get hugepage size

    Mike Kravetz <mike.kravetz@oracle.com>:
      hugetlb: fix update_and_free_page contig page struct assumption
      hugetlb: fix copy_huge_page_from_user contig page struct assumption

    Chen Wandun <chenwandun@huawei.com>:
      mm/hugetlb: suppress wrong warning info when alloc gigantic page

Subsystem: mm/vmscan

    Alex Shi <alex.shi@linux.alibaba.com>:
      mm/vmscan: __isolate_lru_page_prepare() cleanup

    Miaohe Lin <linmiaohe@huawei.com>:
      mm/workingset.c: avoid unnecessary max_nodes estimation in count_shadow_nodes()

    Yu Zhao <yuzhao@google.com>:
    Patch series "mm: lru related cleanups", v2:
      mm/vmscan.c: use add_page_to_lru_list()
      include/linux/mm_inline.h: shuffle lru list addition and deletion functions
      mm: don't pass "enum lru_list" to lru list addition functions
      mm/swap.c: don't pass "enum lru_list" to trace_mm_lru_insertion()
      mm/swap.c: don't pass "enum lru_list" to del_page_from_lru_list()
      mm: add __clear_page_lru_flags() to replace page_off_lru()
      mm: VM_BUG_ON lru page flags
      include/linux/mm_inline.h: fold page_lru_base_type() into its sole caller
      include/linux/mm_inline.h: fold __update_lru_size() into its sole caller
      mm/vmscan.c: make lruvec_lru_size() static

    Oscar Salvador <osalvador@suse.de>:
      mm: workingset: clarify eviction order and distance calculation

    Mike Kravetz <mike.kravetz@oracle.com>:
    Patch series "create hugetlb flags to consolidate state", v3:
      hugetlb: use page.private for hugetlb specific page flags
      hugetlb: convert page_huge_active() HPageMigratable flag
      hugetlb: convert PageHugeTemporary() to HPageTemporary flag
      hugetlb: convert PageHugeFreed to HPageFreed flag
      include/linux/hugetlb.h: add synchronization information for new hugetlb specific flags
      hugetlb: fix uninitialized subpool pointer

    Dave Hansen <dave.hansen@linux.intel.com>:
      mm/vmscan: restore zone_reclaim_mode ABI

Subsystem: mm/z3fold

    Miaohe Lin <linmiaohe@huawei.com>:
      z3fold: remove unused attribute for release_z3fold_page
      z3fold: simplify the zhdr initialization code in init_z3fold_page()

Subsystem: mm/compaction

    Alex Shi <alex.shi@linux.alibaba.com>:
      mm/compaction: remove rcu_read_lock during page compaction

    Miaohe Lin <linmiaohe@huawei.com>:
      mm/compaction: remove duplicated VM_BUG_ON_PAGE !PageLocked

    Charan Teja Reddy <charante@codeaurora.org>:
      mm/compaction: correct deferral logic for proactive compaction

    Wonhyuk Yang <vvghjk1234@gmail.com>:
      mm/compaction: fix misbehaviors of fast_find_migrateblock()

    Vlastimil Babka <vbabka@suse.cz>:
      mm, compaction: make fast_isolate_freepages() stay within zone

Subsystem: mm/mempolicy

    Huang Ying <ying.huang@intel.com>:
      numa balancing: migrate on fault among multiple bound nodes

    Miaohe Lin <linmiaohe@huawei.com>:
      mm/mempolicy: use helper range_in_vma() in queue_pages_test_walk()

Subsystem: mm/oom-kill

    Tang Yizhou <tangyizhou@huawei.com>:
      mm, oom: fix a comment in dump_task()

Subsystem: mm/hugetlbfs

    Mike Kravetz <mike.kravetz@oracle.com>:
      mm/hugetlb: change hugetlb_reserve_pages() to type bool
      hugetlbfs: remove special hugetlbfs_set_page_dirty()

    Miaohe Lin <linmiaohe@huawei.com>:
      hugetlbfs: remove useless BUG_ON(!inode) in hugetlbfs_setattr()
      hugetlbfs: use helper macro default_hstate in init_hugetlbfs_fs
      hugetlbfs: correct obsolete function name in hugetlbfs_read_iter()
      hugetlbfs: remove meaningless variable avoid_reserve
      hugetlbfs: make hugepage size conversion more readable
      hugetlbfs: correct some obsolete comments about inode i_mutex
      hugetlbfs: fix some comment typos
      hugetlbfs: remove unneeded return value of hugetlb_vmtruncate()

Subsystem: mm/migration

    Chengyang Fan <cy.fan@huawei.com>:
      mm/migrate: remove unneeded semicolons

 Documentation/admin-guide/cgroup-v2.rst         |    4 
 Documentation/admin-guide/kernel-parameters.txt |    8 
 Documentation/admin-guide/sysctl/vm.rst         |   10 
 Documentation/core-api/mm-api.rst               |    7 
 Documentation/dev-tools/kasan.rst               |   24 
 Documentation/vm/arch_pgtable_helpers.rst       |    8 
 arch/arm64/include/asm/memory.h                 |    1 
 arch/arm64/include/asm/mte-kasan.h              |   12 
 arch/arm64/kernel/mte.c                         |   12 
 arch/arm64/kernel/sleep.S                       |    2 
 arch/arm64/mm/fault.c                           |   20 
 arch/hexagon/configs/comet_defconfig            |    1 
 arch/ia64/include/asm/pgtable.h                 |    6 
 arch/ia64/mm/init.c                             |   18 
 arch/mips/mm/pgtable-32.c                       |    1 
 arch/mips/mm/pgtable-64.c                       |    1 
 arch/x86/kernel/acpi/wakeup_64.S                |    2 
 drivers/base/node.c                             |   33 
 drivers/video/fbdev/acornfb.c                   |   34 
 fs/block_dev.c                                  |    2 
 fs/btrfs/file.c                                 |    2 
 fs/buffer.c                                     |    7 
 fs/dcache.c                                     |    4 
 fs/direct-io.c                                  |    4 
 fs/exec.c                                       |    4 
 fs/fhandle.c                                    |    2 
 fs/fuse/dev.c                                   |    6 
 fs/hugetlbfs/inode.c                            |   72 --
 fs/ntfs/inode.c                                 |    6 
 fs/ntfs/layout.h                                |    4 
 fs/ocfs2/cluster/heartbeat.c                    |    8 
 fs/ocfs2/dlm/dlmast.c                           |   10 
 fs/ocfs2/dlm/dlmcommon.h                        |    4 
 fs/ocfs2/refcounttree.c                         |    2 
 fs/ocfs2/super.c                                |    2 
 fs/pipe.c                                       |    2 
 fs/proc/meminfo.c                               |   10 
 fs/proc/vmcore.c                                |    7 
 fs/ramfs/inode.c                                |   13 
 include/linux/fs.h                              |    4 
 include/linux/gfp.h                             |   14 
 include/linux/highmem-internal.h                |    5 
 include/linux/huge_mm.h                         |   15 
 include/linux/hugetlb.h                         |   98 ++
 include/linux/kasan-checks.h                    |    6 
 include/linux/kasan.h                           |   39 -
 include/linux/memcontrol.h                      |   43 -
 include/linux/migrate.h                         |    2 
 include/linux/mm.h                              |   28 
 include/linux/mm_inline.h                       |  123 +--
 include/linux/mmzone.h                          |   30 
 include/linux/page-flags.h                      |    6 
 include/linux/page_counter.h                    |    9 
 include/linux/pagemap.h                         |    5 
 include/linux/swap.h                            |    8 
 include/trace/events/kmem.h                     |   24 
 include/trace/events/pagemap.h                  |   11 
 include/uapi/linux/mempolicy.h                  |    4 
 init/Kconfig                                    |   14 
 lib/Kconfig.kasan                               |   14 
 lib/Makefile                                    |    2 
 lib/test_kasan.c                                |  446 ++++++++----
 lib/test_kasan_module.c                         |    5 
 mm/backing-dev.c                                |    6 
 mm/compaction.c                                 |   73 +-
 mm/debug.c                                      |   10 
 mm/debug_vm_pgtable.c                           |   86 ++
 mm/filemap.c                                    |  859 +++++++++++-------------
 mm/gup.c                                        |    5 
 mm/huge_memory.c                                |   28 
 mm/hugetlb.c                                    |  376 ++++------
 mm/hugetlb_cgroup.c                             |    6 
 mm/kasan/common.c                               |   60 -
 mm/kasan/generic.c                              |   40 -
 mm/kasan/hw_tags.c                              |   16 
 mm/kasan/kasan.h                                |   87 +-
 mm/kasan/quarantine.c                           |   22 
 mm/kasan/report.c                               |   15 
 mm/kasan/report_generic.c                       |   10 
 mm/kasan/report_hw_tags.c                       |    8 
 mm/kasan/report_sw_tags.c                       |    8 
 mm/kasan/shadow.c                               |   27 
 mm/kasan/sw_tags.c                              |   22 
 mm/khugepaged.c                                 |    6 
 mm/list_lru.c                                   |   12 
 mm/memcontrol.c                                 |  309 ++++----
 mm/memory-failure.c                             |   34 
 mm/memory.c                                     |   24 
 mm/memory_hotplug.c                             |   11 
 mm/mempolicy.c                                  |   18 
 mm/mempool.c                                    |    2 
 mm/migrate.c                                    |   10 
 mm/mlock.c                                      |    3 
 mm/mmap.c                                       |    4 
 mm/mprotect.c                                   |    7 
 mm/mremap.c                                     |    8 
 mm/oom_kill.c                                   |    5 
 mm/page_alloc.c                                 |   70 -
 mm/page_io.c                                    |   12 
 mm/page_owner.c                                 |    4 
 mm/page_reporting.c                             |    2 
 mm/pgtable-generic.c                            |    9 
 mm/rmap.c                                       |   35 
 mm/shmem.c                                      |    2 
 mm/slab.c                                       |   21 
 mm/slab.h                                       |   20 
 mm/slab_common.c                                |   40 -
 mm/slob.c                                       |    2 
 mm/slub.c                                       |  169 ++--
 mm/swap.c                                       |   54 -
 mm/swap_slots.c                                 |    3 
 mm/swap_state.c                                 |   31 
 mm/swapfile.c                                   |    8 
 mm/vmscan.c                                     |  100 +-
 mm/vmstat.c                                     |   14 
 mm/workingset.c                                 |    7 
 mm/z3fold.c                                     |   11 
 scripts/Makefile.kasan                          |   10 
 scripts/spelling.txt                            |   30 
 tools/objtool/check.c                           |    2 
 120 files changed, 2249 insertions(+), 1954 deletions(-)

