Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87C1FC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:02:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbiANWC1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:02:27 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:56792 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229980AbiANWC1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:02:27 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 200E5B8262E
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:02:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F859C36AE9;
        Fri, 14 Jan 2022 22:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642197744;
        bh=vtLHwSxALUhaa4k9LqGKA9KIK8DALoc00Y76xFZi+kk=;
        h=Date:From:To:Cc:Subject:From;
        b=KFy0j8N82iIWO2de2dsZp6H8mj5s2RAaXZihPszRYFzW/nAWnAtJhLx/HnXfrSJ7z
         xikb/3l6qX0qeHy9gTldO9iA2Moi8KXK5fFMTEP7/v8RAsJ0RBpNsmxsKKi2pWKmxn
         MnYeqoumUth7JWDTQfpQbtR1tw6xYpcYnVNc65Zk=
Date:   Fri, 14 Jan 2022 14:02:22 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-mm@kvack.org, mm-commits@vger.kernel.org
Subject: incoming
Message-Id: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

146 patches, based on df0cc57e057f18e44dac8e6c18aba47ab53202f9 ("Linux 5.16=
")

Subsystems affected by this patch series:

  kthread
  ia64
  scripts
  ntfs
  squashfs
  ocfs2
  vfs
  mm/slab-generic
  mm/slab
  mm/kmemleak
  mm/dax
  mm/kasan
  mm/debug
  mm/pagecache
  mm/gup
  mm/shmem
  mm/frontswap
  mm/memremap
  mm/memcg
  mm/selftests
  mm/pagemap
  mm/dma
  mm/vmalloc
  mm/memory-failure
  mm/hugetlb
  mm/userfaultfd
  mm/vmscan
  mm/mempolicy
  mm/oom-kill
  mm/hugetlbfs
  mm/migration
  mm/thp
  mm/ksm
  mm/page-poison
  mm/percpu
  mm/rmap
  mm/zswap
  mm/zram
  mm/cleanups
  mm/hmm
  mm/damon

Subsystem: kthread

    Cai Huoqing <caihuoqing@baidu.com>:
      kthread: add the helper function kthread_run_on_cpu()
      RDMA/siw: make use of the helper function kthread_run_on_cpu()
      ring-buffer: make use of the helper function kthread_run_on_cpu()
      rcutorture: make use of the helper function kthread_run_on_cpu()
      trace/osnoise: make use of the helper function kthread_run_on_cpu()
      trace/hwlat: make use of the helper function kthread_run_on_cpu()

Subsystem: ia64

    Yang Guang <yang.guang5@zte.com.cn>:
      ia64: module: use swap() to make code cleaner
      arch/ia64/kernel/setup.c: use swap() to make code cleaner

    Jason Wang <wangborong@cdjrlc.com>:
      ia64: fix typo in a comment

    Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
      ia64: topology: use default_groups in kobj_type

Subsystem: scripts

    Drew Fustini <dfustini@baylibre.com>:
      scripts/spelling.txt: add "oveflow"

Subsystem: ntfs

    Yang Li <yang.lee@linux.alibaba.com>:
      fs/ntfs/attrib.c: fix one kernel-doc comment

Subsystem: squashfs

    Zheng Liang <zhengliang6@huawei.com>:
      squashfs: provide backing_dev_info in order to disable read-ahead

Subsystem: ocfs2

    Zhang Mingyu <zhang.mingyu@zte.com.cn>:
      ocfs2: use BUG_ON instead of if condition followed by BUG.

    Joseph Qi <joseph.qi@linux.alibaba.com>:
      ocfs2: clearly handle ocfs2_grab_pages_for_write() return value

    Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
      ocfs2: use default_groups in kobj_type

    Colin Ian King <colin.i.king@gmail.com>:
      ocfs2: remove redundant assignment to pointer root_bh

    Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
      ocfs2: cluster: use default_groups in kobj_type

    Colin Ian King <colin.i.king@gmail.com>:
      ocfs2: remove redundant assignment to variable free_space

Subsystem: vfs

    Amit Daniel Kachhap <amit.kachhap@arm.com>:
      fs/ioctl: remove unnecessary __user annotation

Subsystem: mm/slab-generic

    Marco Elver <elver@google.com>:
      mm/slab_common: use WARN() if cache still has objects on destroy

Subsystem: mm/slab

    Muchun Song <songmuchun@bytedance.com>:
      mm: slab: make slab iterator functions static

Subsystem: mm/kmemleak

    Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>:
      kmemleak: fix kmemleak false positive report with HW tag-based kasan =
enable

    Calvin Zhang <calvinzhang.cool@gmail.com>:
      mm: kmemleak: alloc gray object for reserved region with direct map

    Kefeng Wang <wangkefeng.wang@huawei.com>:
      mm: defer kmemleak object creation of module_alloc()

Subsystem: mm/dax

    Joao Martins <joao.m.martins@oracle.com>:
    Patch series "mm, device-dax: Introduce compound pages in devmap", v7:
      mm/page_alloc: split prep_compound_page into head and tail subparts
      mm/page_alloc: refactor memmap_init_zone_device() page init
      mm/memremap: add ZONE_DEVICE support for compound pages
      device-dax: use ALIGN() for determining pgoff
      device-dax: use struct_size()
      device-dax: ensure dev_dax->pgmap is valid for dynamic devices
      device-dax: factor out page mapping initialization
      device-dax: set mapping prior to vmf_insert_pfn{,_pmd,pud}()
      device-dax: remove pfn from __dev_dax_{pte,pmd,pud}_fault()
      device-dax: compound devmap support

Subsystem: mm/kasan

    Marco Elver <elver@google.com>:
      kasan: test: add globals left-out-of-bounds test
      kasan: add ability to detect double-kmem_cache_destroy()
      kasan: test: add test case for double-kmem_cache_destroy()

    Andrey Konovalov <andreyknvl@google.com>:
      kasan: fix quarantine conflicting with init_on_free

Subsystem: mm/debug

    "Matthew Wilcox (Oracle)" <willy@infradead.org>:
      mm,fs: split dump_mapping() out from dump_page()

    Anshuman Khandual <anshuman.khandual@arm.com>:
      mm/debug_vm_pgtable: update comments regarding migration swap entries

Subsystem: mm/pagecache

    chiminghao <chi.minghao@zte.com.cn>:
      mm/truncate.c: remove unneeded variable

Subsystem: mm/gup

    Christophe Leroy <christophe.leroy@csgroup.eu>:
      gup: avoid multiple user access locking/unlocking in fault_in_{read/w=
rite}able

    Li Xinhai <lixinhai.lxh@gmail.com>:
      mm/gup.c: stricter check on THP migration entry during follow_pmd_mask

Subsystem: mm/shmem

    Yang Shi <shy828301@gmail.com>:
      mm: shmem: don't truncate page if memory failure happens

    Gang Li <ligang.bdlg@bytedance.com>:
      shmem: fix a race between shmem_unused_huge_shrink and shmem_evict_in=
ode

Subsystem: mm/frontswap

    Christophe JAILLET <christophe.jaillet@wanadoo.fr>:
      mm/frontswap.c: use non-atomic '__set_bit()' when possible

Subsystem: mm/memremap

Subsystem: mm/memcg

    Muchun Song <songmuchun@bytedance.com>:
      mm: memcontrol: make cgroup_memory_nokmem static

    Donghai Qiao <dqiao@redhat.com>:
      mm/page_counter: remove an incorrect call to propagate_protected_usag=
e()

    Dan Schatzberg <schatzberg.dan@gmail.com>:
      mm/memcg: add oom_group_kill memory event

    Shakeel Butt <shakeelb@google.com>:
      memcg: better bounds on the memcg stats updates

    Wang Weiyang <wangweiyang2@huawei.com>:
      mm/memcg: use struct_size() helper in kzalloc()

    Shakeel Butt <shakeelb@google.com>:
      memcg: add per-memcg vmalloc stat

Subsystem: mm/selftests

    chiminghao <chi.minghao@zte.com.cn>:
      tools/testing/selftests/vm/userfaultfd.c: use swap() to make code cle=
aner

Subsystem: mm/pagemap

    Qi Zheng <zhengqi.arch@bytedance.com>:
      mm: remove redundant check about FAULT_FLAG_ALLOW_RETRY bit

    Colin Cross <ccross@google.com>:
    Patch series "mm: rearrange madvise code to allow for reuse", v11:
      mm: rearrange madvise code to allow for reuse
      mm: add a field to store names for private anonymous memory

    Suren Baghdasaryan <surenb@google.com>:
      mm: add anonymous vma name refcounting

    Arnd Bergmann <arnd@arndb.de>:
      mm: move anon_vma declarations to linux/mm_inline.h
      mm: move tlb_flush_pending inline helpers to mm_inline.h

    Suren Baghdasaryan <surenb@google.com>:
      mm: protect free_pgtables with mmap_lock write lock in exit_mmap
      mm: document locking restrictions for vm_operations_struct::close
      mm/oom_kill: allow process_mrelease to run under mmap_lock protection

    Shuah Khan <skhan@linuxfoundation.org>:
      docs/vm: add vmalloced-kernel-stacks document

    Pasha Tatashin <pasha.tatashin@soleen.com>:
    Patch series "page table check", v3:
      mm: change page type prior to adding page table entry
      mm: ptep_clear() page table helper
      mm: page table check
      x86: mm: add x86_64 support for page table check

    "Matthew Wilcox (Oracle)" <willy@infradead.org>:
      mm: remove last argument of reuse_swap_page()
      mm: remove the total_mapcount argument from page_trans_huge_map_swapc=
ount()
      mm: remove the total_mapcount argument from page_trans_huge_mapcount()

Subsystem: mm/dma

    Christian K=F6nig <christian.koenig@amd.com>:
      mm/dmapool.c: revert "make dma pool to use kmalloc_node"

Subsystem: mm/vmalloc

    Michal Hocko <mhocko@suse.com>:
    Patch series "extend vmalloc support for constrained allocations", v2:
      mm/vmalloc: alloc GFP_NO{FS,IO} for vmalloc
      mm/vmalloc: add support for __GFP_NOFAIL
      mm/vmalloc: be more explicit about supported gfp flags.
      mm: allow !GFP_KERNEL allocations for kvmalloc
      mm: make slab and vmalloc allocators __GFP_NOLOCKDEP aware

    "NeilBrown" <neilb@suse.de>:
      mm: introduce memalloc_retry_wait()

    Suren Baghdasaryan <surenb@google.com>:
      mm/pagealloc: sysctl: change watermark_scale_factor max limit to 30%

    Changcheng Deng <deng.changcheng@zte.com.cn>:
      mm: fix boolreturn.cocci warning

    Xiongwei Song <sxwjean@gmail.com>:
      mm: page_alloc: fix building error on -Werror=3Darray-compare

    Michal Hocko <mhocko@suse.com>:
      mm: drop node from alloc_pages_vma

    Miles Chen <miles.chen@mediatek.com>:
      include/linux/gfp.h: further document GFP_DMA32

    Anshuman Khandual <anshuman.khandual@arm.com>:
      mm/page_alloc.c: modify the comment section for alloc_contig_pages()

    Baoquan He <bhe@redhat.com>:
    Patch series "Handle warning of allocation failure on DMA zone w/o mana=
ged pages", v4:
      mm_zone: add function to check if managed dma zone exists
      dma/pool: create dma atomic pool only if dma zone has managed pages
      mm/page_alloc.c: do not warn allocation failure on zone DMA if no man=
aged pages

Subsystem: mm/memory-failure

Subsystem: mm/hugetlb

    Mina Almasry <almasrymina@google.com>:
      hugetlb: add hugetlb.*.numa_stat file

    Yosry Ahmed <yosryahmed@google.com>:
      mm, hugepages: make memory size variable in hugepage-mremap selftest

    Yang Yang <yang.yang29@zte.com.cn>:
      mm/vmstat: add events for THP max_ptes_* exceeds

    Waiman Long <longman@redhat.com>:
      selftests/vm: make charge_reserved_hugetlb.sh work with existing cgro=
up setting

Subsystem: mm/userfaultfd

    Peter Xu <peterx@redhat.com>:
      selftests/uffd: allow EINTR/EAGAIN

    Mike Kravetz <mike.kravetz@oracle.com>:
      userfaultfd/selftests: clean up hugetlb allocation code

Subsystem: mm/vmscan

    Gang Li <ligang.bdlg@bytedance.com>:
      vmscan: make drop_slab_node static

    Chen Wandun <chenwandun@huawei.com>:
      mm/page_isolation: unset migratetype directly for non Buddy page

Subsystem: mm/mempolicy

    "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>:
    Patch series "mm: add new syscall set_mempolicy_home_node", v6:
      mm/mempolicy: use policy_node helper with MPOL_PREFERRED_MANY
      mm/mempolicy: add set_mempolicy_home_node syscall
      mm/mempolicy: wire up syscall set_mempolicy_home_node

    Randy Dunlap <rdunlap@infradead.org>:
      mm/mempolicy: fix all kernel-doc warnings

Subsystem: mm/oom-kill

    Jann Horn <jannh@google.com>:
      mm, oom: OOM sysrq should always kill a process

Subsystem: mm/hugetlbfs

    Sean Christopherson <seanjc@google.com>:
      hugetlbfs: fix off-by-one error in hugetlb_vmdelete_list()

Subsystem: mm/migration

    Baolin Wang <baolin.wang@linux.alibaba.com>:
    Patch series "Improve the migration stats":
      mm: migrate: fix the return value of migrate_pages()
      mm: migrate: correct the hugetlb migration stats
      mm: compaction: fix the migration stats in trace_mm_compaction_migrat=
epages()
      mm: migrate: support multiple target nodes demotion
      mm: migrate: add more comments for selecting target node randomly

    Huang Ying <ying.huang@intel.com>:
      mm/migrate: move node demotion code to near its user

    Colin Ian King <colin.i.king@gmail.com>:
      mm/migrate: remove redundant variables used in a for-loop

Subsystem: mm/thp

    Anshuman Khandual <anshuman.khandual@arm.com>:
      mm/thp: drop unused trace events hugepage_[invalidate|splitting]

Subsystem: mm/ksm

    Nanyong Sun <sunnanyong@huawei.com>:
      mm: ksm: fix use-after-free kasan report in ksm_might_need_to_copy

Subsystem: mm/page-poison

    Naoya Horiguchi <naoya.horiguchi@nec.com>:
    Patch series "mm/hwpoison: fix unpoison_memory()", v4:
      mm/hwpoison: mf_mutex for soft offline and unpoison
      mm/hwpoison: remove MF_MSG_BUDDY_2ND and MF_MSG_POISONED_HUGE
      mm/hwpoison: fix unpoison_memory()

Subsystem: mm/percpu

    Qi Zheng <zhengqi.arch@bytedance.com>:
      mm: memcg/percpu: account extra objcg space to memory cgroups

Subsystem: mm/rmap

    Huang Ying <ying.huang@intel.com>:
      mm/rmap: fix potential batched TLB flush race

Subsystem: mm/zswap

    Zhaoyu Liu <zackary.liu.pro@gmail.com>:
      zpool: remove the list of pools_head

Subsystem: mm/zram

    Luis Chamberlain <mcgrof@kernel.org>:
      zram: use ATTRIBUTE_GROUPS

Subsystem: mm/cleanups

    Quanfa Fu <fuqf0919@gmail.com>:
      mm: fix some comment errors

    Ting Liu <liuting.0x7c00@bytedance.com>:
      mm: make some vars and functions static or __init

Subsystem: mm/hmm

    Alistair Popple <apopple@nvidia.com>:
      mm/hmm.c: allow VM_MIXEDMAP to work with hmm_range_fault

Subsystem: mm/damon

    Xin Hao <xhao@linux.alibaba.com>:
    Patch series "mm/damon: Do some small changes", v4:
      mm/damon: unified access_check function naming rules
      mm/damon: add 'age' of region tracepoint support
      mm/damon/core: use abs() instead of diff_of()
      mm/damon: remove some unneeded function definitions in damon.h

    Yihao Han <hanyihao@vivo.com>:
      mm/damon/vaddr: remove swap_ranges() and replace it with swap()

    Xin Hao <xhao@linux.alibaba.com>:
      mm/damon/schemes: add the validity judgment of thresholds
      mm/damon: move damon_rand() definition into damon.h
      mm/damon: modify damon_rand() macro to static inline function

    SeongJae Park <sj@kernel.org>:
    Patch series "mm/damon: Misc cleanups":
      mm/damon: convert macro functions to static inline functions
      Docs/admin-guide/mm/damon/usage: update for scheme quotas and waterma=
rks
      Docs/admin-guide/mm/damon/usage: remove redundant information
      Docs/admin-guide/mm/damon/usage: mention tracepoint at the beginning
      Docs/admin-guide/mm/damon/usage: update for kdamond_pid and (mk|rm)_c=
ontexts
      mm/damon: remove a mistakenly added comment for a future feature
    Patch series "mm/damon/schemes: Extend stats for better online analysis=
 and tuning":
      mm/damon/schemes: account scheme actions that successfully applied
      mm/damon/schemes: account how many times quota limit has exceeded
      mm/damon/reclaim: provide reclamation statistics
      Docs/admin-guide/mm/damon/reclaim: document statistics parameters
      mm/damon/dbgfs: support all DAMOS stats
      Docs/admin-guide/mm/damon/usage: update for schemes statistics

    Baolin Wang <baolin.wang@linux.alibaba.com>:
      mm/damon: add access checking for hugetlb pages

    Guoqing Jiang <guoqing.jiang@linux.dev>:
      mm/damon: move the implementation of damon_insert_region to damon.h

    SeongJae Park <sj@kernel.org>:
    Patch series "mm/damon: Hide unnecessary information disclosures":
      mm/damon/dbgfs: remove an unnecessary variable
      mm/damon/vaddr: use pr_debug() for damon_va_three_regions() failure l=
ogging
      mm/damon/vaddr: hide kernel pointer from damon_va_three_regions() fai=
lure log
      mm/damon: hide kernel pointer from tracepoint event

 Documentation/admin-guide/cgroup-v1/hugetlb.rst        |    4=20
 Documentation/admin-guide/cgroup-v2.rst                |   11=20
 Documentation/admin-guide/mm/damon/reclaim.rst         |   25=20
 Documentation/admin-guide/mm/damon/usage.rst           |  235 +++++--
 Documentation/admin-guide/mm/numa_memory_policy.rst    |   16=20
 Documentation/admin-guide/sysctl/vm.rst                |    2=20
 Documentation/filesystems/proc.rst                     |    6=20
 Documentation/vm/arch_pgtable_helpers.rst              |   20=20
 Documentation/vm/index.rst                             |    2=20
 Documentation/vm/page_migration.rst                    |   12=20
 Documentation/vm/page_table_check.rst                  |   56 +
 Documentation/vm/vmalloced-kernel-stacks.rst           |  153 ++++
 MAINTAINERS                                            |    9=20
 arch/Kconfig                                           |    3=20
 arch/alpha/kernel/syscalls/syscall.tbl                 |    1=20
 arch/alpha/mm/fault.c                                  |   16=20
 arch/arc/mm/fault.c                                    |    3=20
 arch/arm/mm/fault.c                                    |    2=20
 arch/arm/tools/syscall.tbl                             |    1=20
 arch/arm64/include/asm/unistd.h                        |    2=20
 arch/arm64/include/asm/unistd32.h                      |    2=20
 arch/arm64/kernel/module.c                             |    4=20
 arch/arm64/mm/fault.c                                  |    6=20
 arch/hexagon/mm/vm_fault.c                             |    8=20
 arch/ia64/kernel/module.c                              |    6=20
 arch/ia64/kernel/setup.c                               |    5=20
 arch/ia64/kernel/syscalls/syscall.tbl                  |    1=20
 arch/ia64/kernel/topology.c                            |    3=20
 arch/ia64/kernel/uncached.c                            |    2=20
 arch/ia64/mm/fault.c                                   |   16=20
 arch/m68k/kernel/syscalls/syscall.tbl                  |    1=20
 arch/m68k/mm/fault.c                                   |   18=20
 arch/microblaze/kernel/syscalls/syscall.tbl            |    1=20
 arch/microblaze/mm/fault.c                             |   18=20
 arch/mips/kernel/syscalls/syscall_n32.tbl              |    1=20
 arch/mips/kernel/syscalls/syscall_n64.tbl              |    1=20
 arch/mips/kernel/syscalls/syscall_o32.tbl              |    1=20
 arch/mips/mm/fault.c                                   |   19=20
 arch/nds32/mm/fault.c                                  |   16=20
 arch/nios2/mm/fault.c                                  |   18=20
 arch/openrisc/mm/fault.c                               |   18=20
 arch/parisc/kernel/syscalls/syscall.tbl                |    1=20
 arch/parisc/mm/fault.c                                 |   18=20
 arch/powerpc/kernel/syscalls/syscall.tbl               |    1=20
 arch/powerpc/mm/fault.c                                |    6=20
 arch/riscv/mm/fault.c                                  |    2=20
 arch/s390/kernel/module.c                              |    5=20
 arch/s390/kernel/syscalls/syscall.tbl                  |    1=20
 arch/s390/mm/fault.c                                   |   28=20
 arch/sh/kernel/syscalls/syscall.tbl                    |    1=20
 arch/sh/mm/fault.c                                     |   18=20
 arch/sparc/kernel/syscalls/syscall.tbl                 |    1=20
 arch/sparc/mm/fault_32.c                               |   16=20
 arch/sparc/mm/fault_64.c                               |   16=20
 arch/um/kernel/trap.c                                  |    8=20
 arch/x86/Kconfig                                       |    1=20
 arch/x86/entry/syscalls/syscall_32.tbl                 |    1=20
 arch/x86/entry/syscalls/syscall_64.tbl                 |    1=20
 arch/x86/include/asm/pgtable.h                         |   31 -
 arch/x86/kernel/module.c                               |    7=20
 arch/x86/mm/fault.c                                    |    3=20
 arch/xtensa/kernel/syscalls/syscall.tbl                |    1=20
 arch/xtensa/mm/fault.c                                 |   17=20
 drivers/block/zram/zram_drv.c                          |   11=20
 drivers/dax/bus.c                                      |   32 +
 drivers/dax/bus.h                                      |    1=20
 drivers/dax/device.c                                   |  140 ++--
 drivers/infiniband/sw/siw/siw_main.c                   |    7=20
 drivers/of/fdt.c                                       |    6=20
 fs/ext4/extents.c                                      |    8=20
 fs/ext4/inline.c                                       |    5=20
 fs/ext4/page-io.c                                      |    9=20
 fs/f2fs/data.c                                         |    4=20
 fs/f2fs/gc.c                                           |    5=20
 fs/f2fs/inode.c                                        |    4=20
 fs/f2fs/node.c                                         |    4=20
 fs/f2fs/recovery.c                                     |    6=20
 fs/f2fs/segment.c                                      |    9=20
 fs/f2fs/super.c                                        |    5=20
 fs/hugetlbfs/inode.c                                   |    7=20
 fs/inode.c                                             |   49 +
 fs/ioctl.c                                             |    2=20
 fs/ntfs/attrib.c                                       |    2=20
 fs/ocfs2/alloc.c                                       |    2=20
 fs/ocfs2/aops.c                                        |   26=20
 fs/ocfs2/cluster/masklog.c                             |   11=20
 fs/ocfs2/dir.c                                         |    2=20
 fs/ocfs2/filecheck.c                                   |    3=20
 fs/ocfs2/journal.c                                     |    6=20
 fs/proc/task_mmu.c                                     |   13=20
 fs/squashfs/super.c                                    |   33 +
 fs/userfaultfd.c                                       |    8=20
 fs/xfs/kmem.c                                          |    3=20
 fs/xfs/xfs_buf.c                                       |    2=20
 include/linux/ceph/libceph.h                           |    1=20
 include/linux/damon.h                                  |   93 +--
 include/linux/fs.h                                     |    1=20
 include/linux/gfp.h                                    |   12=20
 include/linux/hugetlb.h                                |    4=20
 include/linux/hugetlb_cgroup.h                         |    7=20
 include/linux/kasan.h                                  |    4=20
 include/linux/kthread.h                                |   25=20
 include/linux/memcontrol.h                             |   22=20
 include/linux/mempolicy.h                              |    1=20
 include/linux/memremap.h                               |   11=20
 include/linux/mm.h                                     |   76 --
 include/linux/mm_inline.h                              |  136 ++++
 include/linux/mm_types.h                               |  252 +++-----
 include/linux/mmzone.h                                 |    9=20
 include/linux/page-flags.h                             |    6=20
 include/linux/page_idle.h                              |    1=20
 include/linux/page_table_check.h                       |  147 ++++
 include/linux/pgtable.h                                |    8=20
 include/linux/sched/mm.h                               |   26=20
 include/linux/swap.h                                   |    8=20
 include/linux/syscalls.h                               |    3=20
 include/linux/vm_event_item.h                          |    3=20
 include/linux/vmalloc.h                                |    7=20
 include/ras/ras_event.h                                |    2=20
 include/trace/events/compaction.h                      |   24=20
 include/trace/events/damon.h                           |   15=20
 include/trace/events/thp.h                             |   35 -
 include/uapi/asm-generic/unistd.h                      |    5=20
 include/uapi/linux/prctl.h                             |    3=20
 kernel/dma/pool.c                                      |    4=20
 kernel/fork.c                                          |    3=20
 kernel/kthread.c                                       |    1=20
 kernel/rcu/rcutorture.c                                |    7=20
 kernel/sys.c                                           |   63 ++
 kernel/sys_ni.c                                        |    1=20
 kernel/sysctl.c                                        |    3=20
 kernel/trace/ring_buffer.c                             |    7=20
 kernel/trace/trace_hwlat.c                             |    6=20
 kernel/trace/trace_osnoise.c                           |    3=20
 lib/test_hmm.c                                         |   24=20
 lib/test_kasan.c                                       |   30=20
 mm/Kconfig                                             |   14=20
 mm/Kconfig.debug                                       |   24=20
 mm/Makefile                                            |    1=20
 mm/compaction.c                                        |    7=20
 mm/damon/core.c                                        |   45 -
 mm/damon/dbgfs.c                                       |   20=20
 mm/damon/paddr.c                                       |   24=20
 mm/damon/prmtv-common.h                                |    4=20
 mm/damon/reclaim.c                                     |   46 +
 mm/damon/vaddr.c                                       |  186 ++++--
 mm/debug.c                                             |   52 -
 mm/debug_vm_pgtable.c                                  |    6=20
 mm/dmapool.c                                           |    2=20
 mm/frontswap.c                                         |    4=20
 mm/gup.c                                               |   31 -
 mm/hmm.c                                               |    5=20
 mm/huge_memory.c                                       |   32 -
 mm/hugetlb.c                                           |    6=20
 mm/hugetlb_cgroup.c                                    |  133 +++-
 mm/internal.h                                          |    7=20
 mm/kasan/quarantine.c                                  |   11=20
 mm/kasan/shadow.c                                      |    9=20
 mm/khugepaged.c                                        |   23=20
 mm/kmemleak.c                                          |   21=20
 mm/ksm.c                                               |    5=20
 mm/madvise.c                                           |  510 ++++++++++--=
----
 mm/mapping_dirty_helpers.c                             |    1=20
 mm/memcontrol.c                                        |   44 -
 mm/memory-failure.c                                    |  189 +++---
 mm/memory.c                                            |   12=20
 mm/mempolicy.c                                         |   95 ++-
 mm/memremap.c                                          |   18=20
 mm/migrate.c                                           |  527 ++++++++++--=
-----
 mm/mlock.c                                             |    2=20
 mm/mmap.c                                              |   55 +
 mm/mmu_gather.c                                        |    1=20
 mm/mprotect.c                                          |    2=20
 mm/oom_kill.c                                          |   30=20
 mm/page_alloc.c                                        |  198 ++++--
 mm/page_counter.c                                      |    1=20
 mm/page_ext.c                                          |    8=20
 mm/page_isolation.c                                    |    2=20
 mm/page_owner.c                                        |    4=20
 mm/page_table_check.c                                  |  270 ++++++++
 mm/percpu-internal.h                                   |   18=20
 mm/percpu.c                                            |   10=20
 mm/pgtable-generic.c                                   |    1=20
 mm/rmap.c                                              |   43 +
 mm/shmem.c                                             |   91 ++
 mm/slab.h                                              |    5=20
 mm/slab_common.c                                       |   34 -
 mm/swap.c                                              |    2=20
 mm/swapfile.c                                          |   46 -
 mm/truncate.c                                          |    5=20
 mm/userfaultfd.c                                       |    5=20
 mm/util.c                                              |   15=20
 mm/vmalloc.c                                           |   75 +-
 mm/vmscan.c                                            |    2=20
 mm/vmstat.c                                            |    3=20
 mm/zpool.c                                             |   12=20
 net/ceph/buffer.c                                      |    4=20
 net/ceph/ceph_common.c                                 |   27=20
 net/ceph/crypto.c                                      |    2=20
 net/ceph/messenger.c                                   |    2=20
 net/ceph/messenger_v2.c                                |    2=20
 net/ceph/osdmap.c                                      |   12=20
 net/sunrpc/svc_xprt.c                                  |    3=20
 scripts/spelling.txt                                   |    1=20
 tools/testing/selftests/vm/charge_reserved_hugetlb.sh  |   34 -
 tools/testing/selftests/vm/hmm-tests.c                 |   42 +
 tools/testing/selftests/vm/hugepage-mremap.c           |   46 -
 tools/testing/selftests/vm/hugetlb_reparenting_test.sh |   21=20
 tools/testing/selftests/vm/run_vmtests.sh              |    2=20
 tools/testing/selftests/vm/userfaultfd.c               |   33 -
 tools/testing/selftests/vm/write_hugetlb_memory.sh     |    2=20
 211 files changed, 3980 insertions(+), 1759 deletions(-)

