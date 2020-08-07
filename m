Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2A85C433E0
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:16:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9384D20855
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781007;
	bh=Vkr3LVhYSTU/OaDVWGisFCYuaQDCEgqzgBwGekz/X3I=;
	h=Date:From:To:Cc:Subject:Reply-To:List-ID:From;
	b=ZEVRwPCWjs+tHuplLVGH3YQ55LbVt9cvrQOOHJy9klrR81XGqCSc2/8T7Fl6N82DI
	 sRjPMxYgK0jEV4qheaO64RxgHGrKZaGkI3hEVlHtX2e9RxAdZVkYl+sJHPHupDfKwY
	 GeOUXAJNC7hivGK7Vs0al8v/G+ATXegoYvWhxpRY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725805AbgHGGQr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:16:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:52024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgHGGQq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:16:46 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC84020855;
        Fri,  7 Aug 2020 06:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781004;
        bh=Vkr3LVhYSTU/OaDVWGisFCYuaQDCEgqzgBwGekz/X3I=;
        h=Date:From:To:Cc:Subject:From;
        b=VXbAuxzpwW4P9kckPaoNPUYM0xrvqL5mELhS7u37kuSS8t1pqkyA/hXPclxJD2HvQ
         diaPatdggY7ABrZqnqTXDYGqUpack2JN1jooCJVYAxy7VoTiDbw4Autpyrg6MW3Fff
         S9dkRUaVXIYh9wzOjAV0jWbYeT+D5loj7PRkwuRM=
Date:   Thu, 6 Aug 2020 23:16:43 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, linux-mm@kvack.org
Subject: incoming
Message-Id: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


- A few MM hotfixes

- kthread, tools, scripts, ntfs and ocfs2

- Some of MM



163 patches, based on d6efb3ac3e6c19ab722b28bdb9252bae0b9676b6.

Subsystems affected by this patch series:

  mm/pagemap
  mm/hofixes
  mm/pagealloc
  kthread
  tools
  scripts
  ntfs
  ocfs2
  mm/slab-generic
  mm/slab
  mm/slub
  mm/kcsan
  mm/debug
  mm/pagecache
  mm/gup
  mm/swap
  mm/shmem
  mm/memcg
  mm/pagemap
  mm/mremap
  mm/mincore
  mm/sparsemem
  mm/vmalloc
  mm/kasan
  mm/pagealloc
  mm/hugetlb
  mm/vmscan

Subsystem: mm/pagemap

    Yang Shi <yang.shi@linux.alibaba.com>:
      mm/memory.c: avoid access flag update TLB flush for retried page fault

Subsystem: mm/hofixes

    Ralph Campbell <rcampbell@nvidia.com>:
      mm/migrate: fix migrate_pgmap_owner w/o CONFIG_MMU_NOTIFIER

Subsystem: mm/pagealloc

    David Hildenbrand <david@redhat.com>:
      mm/shuffle: don't move pages between zones and don't read garbage mem=
maps

Subsystem: kthread

    Peter Zijlstra <peterz@infradead.org>:
      mm: fix kthread_use_mm() vs TLB invalidate

    Ilias Stamatis <stamatis.iliass@gmail.com>:
      kthread: remove incorrect comment in kthread_create_on_cpu()

Subsystem: tools

    "Alexander A. Klimov" <grandmaster@al2klimov.de>:
      tools/: replace HTTP links with HTTPS ones

    Gaurav Singh <gaurav1086@gmail.com>:
      tools/testing/selftests/cgroup/cgroup_util.c: cg_read_strcmp: fix nul=
l pointer dereference

Subsystem: scripts

    Jialu Xu <xujialu@vimux.org>:
      scripts/tags.sh: collect compiled source precisely

    Nikolay Borisov <nborisov@suse.com>:
      scripts/bloat-o-meter: Support comparing library archives

    Konstantin Khlebnikov <khlebnikov@yandex-team.ru>:
      scripts/decode_stacktrace.sh: skip missing symbols
      scripts/decode_stacktrace.sh: guess basepath if not specified
      scripts/decode_stacktrace.sh: guess path to modules
      scripts/decode_stacktrace.sh: guess path to vmlinux by release name

    Joe Perches <joe@perches.com>:
      const_structs.checkpatch: add regulator_ops

    Colin Ian King <colin.king@canonical.com>:
      scripts/spelling.txt: add more spellings to spelling.txt

Subsystem: ntfs

    Luca Stefani <luca.stefani.ge1@gmail.com>:
      ntfs: fix ntfs_test_inode and ntfs_init_locked_inode function type

Subsystem: ocfs2

    Gang He <ghe@suse.com>:
      ocfs2: fix remounting needed after setfacl command

    Randy Dunlap <rdunlap@infradead.org>:
      ocfs2: suballoc.h: delete a duplicated word

    Junxiao Bi <junxiao.bi@oracle.com>:
      ocfs2: change slot number type s16 to u16

    "Alexander A. Klimov" <grandmaster@al2klimov.de>:
      ocfs2: replace HTTP links with HTTPS ones

    Pavel Machek <pavel@ucw.cz>:
      ocfs2: fix unbalanced locking

Subsystem: mm/slab-generic

    Waiman Long <longman@redhat.com>:
      mm, treewide: rename kzfree() to kfree_sensitive()

    William Kucharski <william.kucharski@oracle.com>:
      mm: ksize() should silently accept a NULL pointer

Subsystem: mm/slab

    Kees Cook <keescook@chromium.org>:
    Patch series "mm: Expand CONFIG_SLAB_FREELIST_HARDENED to include SLAB":
      mm/slab: expand CONFIG_SLAB_FREELIST_HARDENED to include SLAB
      mm/slab: add naive detection of double free

    Long Li <lonuxli.64@gmail.com>:
      mm, slab: check GFP_SLAB_BUG_MASK before alloc_pages in kmalloc_order

    Xiao Yang <yangx.jy@cn.fujitsu.com>:
      mm/slab.c: update outdated kmem_list3 in a comment

Subsystem: mm/slub

    Vlastimil Babka <vbabka@suse.cz>:
    Patch series "slub_debug fixes and improvements":
      mm, slub: extend slub_debug syntax for multiple blocks
      mm, slub: make some slub_debug related attributes read-only
      mm, slub: remove runtime allocation order changes
      mm, slub: make remaining slub_debug related attributes read-only
      mm, slub: make reclaim_account attribute read-only
      mm, slub: introduce static key for slub_debug()
      mm, slub: introduce kmem_cache_debug_flags()
      mm, slub: extend checks guarded by slub_debug static key
      mm, slab/slub: move and improve cache_from_obj()
      mm, slab/slub: improve error reporting and overhead of cache_from_obj=
()

    Sebastian Andrzej Siewior <bigeasy@linutronix.de>:
      mm/slub.c: drop lockdep_assert_held() from put_map()

Subsystem: mm/kcsan

    Marco Elver <elver@google.com>:
      mm, kcsan: instrument SLAB/SLUB free with "ASSERT_EXCLUSIVE_ACCESS"

Subsystem: mm/debug

    Anshuman Khandual <anshuman.khandual@arm.com>:
    Patch series "mm/debug_vm_pgtable: Add some more tests", v5:
      mm/debug_vm_pgtable: add tests validating arch helpers for core MM fe=
atures
      mm/debug_vm_pgtable: add tests validating advanced arch page table he=
lpers
      mm/debug_vm_pgtable: add debug prints for individual tests
      Documentation/mm: add descriptions for arch page table helpers

    "Matthew Wilcox (Oracle)" <willy@infradead.org>:
    Patch series "Improvements for dump_page()", v2:
      mm/debug: handle page->mapping better in dump_page
      mm/debug: dump compound page information on a second line
      mm/debug: print head flags in dump_page
      mm/debug: switch dump_page to get_kernel_nofault
      mm/debug: print the inode number in dump_page
      mm/debug: print hashed address of struct page

    John Hubbard <jhubbard@nvidia.com>:
      mm, dump_page: do not crash with bad compound_mapcount()

Subsystem: mm/pagecache

    Yang Shi <yang.shi@linux.alibaba.com>:
      mm: filemap: clear idle flag for writes
      mm: filemap: add missing FGP_ flags in kerneldoc comment for pagecach=
e_get_page

Subsystem: mm/gup

    Tang Yizhou <tangyizhou@huawei.com>:
      mm/gup.c: fix the comment of return value for populate_vma_page_range=
()

Subsystem: mm/swap

    Zhen Lei <thunder.leizhen@huawei.com>:
    Patch series "clean up some functions in mm/swap_slots.c":
      mm/swap_slots.c: simplify alloc_swap_slot_cache()
      mm/swap_slots.c: simplify enable_swap_slots_cache()
      mm/swap_slots.c: remove redundant check for swap_slot_cache_initializ=
ed

    Krzysztof Kozlowski <krzk@kernel.org>:
      mm: swap: fix kerneldoc of swap_vma_readahead()

    Xianting Tian <xianting_tian@126.com>:
      mm/page_io.c: use blk_io_schedule() for avoiding task hung in sync io

Subsystem: mm/shmem

    Chris Down <chris@chrisdown.name>:
    Patch series "tmpfs: inode: Reduce risk of inum overflow", v7:
      tmpfs: per-superblock i_ino support
      tmpfs: support 64-bit inums per-sb

Subsystem: mm/memcg

    Roman Gushchin <guro@fb.com>:
      mm: kmem: make memcg_kmem_enabled() irreversible
    Patch series "The new cgroup slab memory controller", v7:
      mm: memcg: factor out memcg- and lruvec-level changes out of __mod_lr=
uvec_state()
      mm: memcg: prepare for byte-sized vmstat items
      mm: memcg: convert vmstat slab counters to bytes
      mm: slub: implement SLUB version of obj_to_index()

    Johannes Weiner <hannes@cmpxchg.org>:
      mm: memcontrol: decouple reference counting from page accounting

    Roman Gushchin <guro@fb.com>:
      mm: memcg/slab: obj_cgroup API
      mm: memcg/slab: allocate obj_cgroups for non-root slab pages
      mm: memcg/slab: save obj_cgroup for non-root slab objects
      mm: memcg/slab: charge individual slab objects instead of pages
      mm: memcg/slab: deprecate memory.kmem.slabinfo
      mm: memcg/slab: move memcg_kmem_bypass() to memcontrol.h
      mm: memcg/slab: use a single set of kmem_caches for all accounted all=
ocations
      mm: memcg/slab: simplify memcg cache creation
      mm: memcg/slab: remove memcg_kmem_get_cache()
      mm: memcg/slab: deprecate slab_root_caches
      mm: memcg/slab: remove redundant check in memcg_accumulate_slabinfo()
      mm: memcg/slab: use a single set of kmem_caches for all allocations
      kselftests: cgroup: add kernel memory accounting tests
      tools/cgroup: add memcg_slabinfo.py tool

    Shakeel Butt <shakeelb@google.com>:
      mm: memcontrol: account kernel stack per node

    Roman Gushchin <guro@fb.com>:
      mm: memcg/slab: remove unused argument by charge_slab_page()
      mm: slab: rename (un)charge_slab_page() to (un)account_slab_page()
      mm: kmem: switch to static_branch_likely() in memcg_kmem_enabled()
      mm: memcontrol: avoid workload stalls when lowering memory.high

    Chris Down <chris@chrisdown.name>:
    Patch series "mm, memcg: reclaim harder before high throttling", v2:
      mm, memcg: reclaim more aggressively before high allocator throttling
      mm, memcg: unify reclaim retry limits with page allocator

    Yafang Shao <laoar.shao@gmail.com>:
    Patch series "mm, memcg: memory.{low,min} reclaim fix & cleanup", v4:
      mm, memcg: avoid stale protection values when cgroup is above protect=
ion

    Chris Down <chris@chrisdown.name>:
      mm, memcg: decouple e{low,min} state mutations from protection checks

    Yafang Shao <laoar.shao@gmail.com>:
      memcg, oom: check memcg margin for parallel oom

    Johannes Weiner <hannes@cmpxchg.org>:
      mm: memcontrol: restore proper dirty throttling when memory.high chan=
ges
      mm: memcontrol: don't count limit-setting reclaim as memory pressure

    Michal Koutn=FD <mkoutny@suse.com>:
      mm/page_counter.c: fix protection usage propagation

Subsystem: mm/pagemap

    Ralph Campbell <rcampbell@nvidia.com>:
      mm: remove redundant check non_swap_entry()

    Alex Zhang <zhangalex@google.com>:
      mm/memory.c: make remap_pfn_range() reject unaligned addr

    Mike Rapoport <rppt@linux.ibm.com>:
    Patch series "mm: cleanup usage of <asm/pgalloc.h>":
      mm: remove unneeded includes of <asm/pgalloc.h>
      opeinrisc: switch to generic version of pte allocation
      xtensa: switch to generic version of pte allocation
      asm-generic: pgalloc: provide generic pmd_alloc_one() and pmd_free_on=
e()
      asm-generic: pgalloc: provide generic pud_alloc_one() and pud_free_on=
e()
      asm-generic: pgalloc: provide generic pgd_free()
      mm: move lib/ioremap.c to mm/

    Joerg Roedel <jroedel@suse.de>:
      mm: move p?d_alloc_track to separate header file

    Zhen Lei <thunder.leizhen@huawei.com>:
      mm/mmap: optimize a branch judgment in ksys_mmap_pgoff()

    Feng Tang <feng.tang@intel.com>:
    Patch series "make vm_committed_as_batch aware of vm overcommit policy"=
, v6:
      proc/meminfo: avoid open coded reading of vm_committed_as
      mm/util.c: make vm_memory_committed() more accurate
      percpu_counter: add percpu_counter_sync()
      mm: adjust vm_committed_as_batch according to vm overcommit policy

    Anshuman Khandual <anshuman.khandual@arm.com>:
    Patch series "arm64: Enable vmemmap mapping from device memory", v4:
      mm/sparsemem: enable vmem_altmap support in vmemmap_populate_basepage=
s()
      mm/sparsemem: enable vmem_altmap support in vmemmap_alloc_block_buf()
      arm64/mm: enable vmem_altmap support for vmemmap mappings

    Miaohe Lin <linmiaohe@huawei.com>:
      mm: mmap: merge vma after call_mmap() if possible

    Peter Collingbourne <pcc@google.com>:
      mm: remove unnecessary wrapper function do_mmap_pgoff()

Subsystem: mm/mremap

    Wei Yang <richard.weiyang@linux.alibaba.com>:
    Patch series "mm/mremap: cleanup move_page_tables() a little", v5:
      mm/mremap: it is sure to have enough space when extent meets requirem=
ent
      mm/mremap: calculate extent in one place
      mm/mremap: start addresses are properly aligned

Subsystem: mm/mincore

    Ricardo Ca=F1uelo <ricardo.canuelo@collabora.com>:
      selftests: add mincore() tests

Subsystem: mm/sparsemem

    Wei Yang <richard.weiyang@linux.alibaba.com>:
      mm/sparse: never partially remove memmap for early section
      mm/sparse: only sub-section aligned range would be populated

    Mike Rapoport <rppt@linux.ibm.com>:
      mm/sparse: cleanup the code surrounding memory_present()

Subsystem: mm/vmalloc

    "Matthew Wilcox (Oracle)" <willy@infradead.org>:
      vmalloc: convert to XArray

    "Uladzislau Rezki (Sony)" <urezki@gmail.com>:
      mm/vmalloc: simplify merge_or_add_vmap_area()
      mm/vmalloc: simplify augment_tree_propagate_check()
      mm/vmalloc: switch to "propagate()" callback
      mm/vmalloc: update the header about KVA rework

    Mike Rapoport <rppt@linux.ibm.com>:
      mm: vmalloc: remove redundant assignment in unmap_kernel_range_noflus=
h()

    "Uladzislau Rezki (Sony)" <urezki@gmail.com>:
      mm/vmalloc.c: remove BUG() from the find_va_links()

Subsystem: mm/kasan

    Marco Elver <elver@google.com>:
      kasan: improve and simplify Kconfig.kasan
      kasan: update required compiler versions in documentation

    Walter Wu <walter-zh.wu@mediatek.com>:
    Patch series "kasan: memorize and print call_rcu stack", v8:
      rcu: kasan: record and print call_rcu() call stack
      kasan: record and print the free track
      kasan: add tests for call_rcu stack recording
      kasan: update documentation for generic kasan

    Vincenzo Frascino <vincenzo.frascino@arm.com>:
      kasan: remove kasan_unpoison_stack_above_sp_to()

    Walter Wu <walter-zh.wu@mediatek.com>:
      lib/test_kasan.c: fix KASAN unit tests for tag-based KASAN

    Andrey Konovalov <andreyknvl@google.com>:
    Patch series "kasan: support stack instrumentation for tag-based mode",=
 v2:
      kasan: don't tag stacks allocated with pagealloc
      efi: provide empty efi_enter_virtual_mode implementation
      kasan, arm64: don't instrument functions that enable kasan
      kasan: allow enabling stack tagging for tag-based mode
      kasan: adjust kasan_stack_oob for tag-based mode

Subsystem: mm/pagealloc

    Vlastimil Babka <vbabka@suse.cz>:
      mm, page_alloc: use unlikely() in task_capc()

    Jaewon Kim <jaewon31.kim@samsung.com>:
      page_alloc: consider highatomic reserve in watermark fast

    Charan Teja Reddy <charante@codeaurora.org>:
      mm, page_alloc: skip ->waternark_boost for atomic order-0 allocations

    David Hildenbrand <david@redhat.com>:
      mm: remove vm_total_pages
      mm/page_alloc: remove nr_free_pagecache_pages()
      mm/memory_hotplug: document why shuffle_zone() is relevant
      mm/shuffle: remove dynamic reconfiguration

    Wei Yang <richard.weiyang@linux.alibaba.com>:
      mm/page_alloc.c: replace the definition of NR_MIGRATETYPE_BITS with P=
B_migratetype_bits
      mm/page_alloc.c: extract the common part in pfn_to_bitidx()
      mm/page_alloc.c: simplify pageblock bitmap access
      mm/page_alloc.c: remove unnecessary end_bitidx for [set|get]_pfnblock=
_flags_mask()

    Qian Cai <cai@lca.pw>:
      mm/page_alloc: silence a KASAN false positive

    Wei Yang <richard.weiyang@linux.alibaba.com>:
      mm/page_alloc: fallbacks at most has 3 elements

    Muchun Song <songmuchun@bytedance.com>:
      mm/page_alloc.c: skip setting nodemask when we are in interrupt

    Joonsoo Kim <iamjoonsoo.kim@lge.com>:
      mm/page_alloc: fix memalloc_nocma_{save/restore} APIs

Subsystem: mm/hugetlb

    "Alexander A. Klimov" <grandmaster@al2klimov.de>:
      mm: thp: replace HTTP links with HTTPS ones

    Peter Xu <peterx@redhat.com>:
      mm/hugetlb: fix calculation of adjust_range_if_pmd_sharing_possible

    Hugh Dickins <hughd@google.com>:
      khugepaged: collapse_pte_mapped_thp() flush the right range
      khugepaged: collapse_pte_mapped_thp() protect the pmd lock
      khugepaged: retract_page_tables() remember to test exit
      khugepaged: khugepaged_test_exit() check mmget_still_valid()

Subsystem: mm/vmscan

    dylan-meiners <spacct.spacct@gmail.com>:
      mm/vmscan.c: fix typo

    Shakeel Butt <shakeelb@google.com>:
      mm: vmscan: consistent update to pgrefill

 Documentation/admin-guide/kernel-parameters.txt        |    2=20
 Documentation/dev-tools/kasan.rst                      |   10=20
 Documentation/filesystems/dlmfs.rst                    |    2=20
 Documentation/filesystems/ocfs2.rst                    |    2=20
 Documentation/filesystems/tmpfs.rst                    |   18=20
 Documentation/vm/arch_pgtable_helpers.rst              |  258 +++++
 Documentation/vm/memory-model.rst                      |    9=20
 Documentation/vm/slub.rst                              |   51 -
 arch/alpha/include/asm/pgalloc.h                       |   21=20
 arch/alpha/include/asm/tlbflush.h                      |    1=20
 arch/alpha/kernel/core_irongate.c                      |    1=20
 arch/alpha/kernel/core_marvel.c                        |    1=20
 arch/alpha/kernel/core_titan.c                         |    1=20
 arch/alpha/kernel/machvec_impl.h                       |    2=20
 arch/alpha/kernel/smp.c                                |    1=20
 arch/alpha/mm/numa.c                                   |    1=20
 arch/arc/mm/fault.c                                    |    1=20
 arch/arc/mm/init.c                                     |    1=20
 arch/arm/include/asm/pgalloc.h                         |   12=20
 arch/arm/include/asm/tlb.h                             |    1=20
 arch/arm/kernel/machine_kexec.c                        |    1=20
 arch/arm/kernel/smp.c                                  |    1=20
 arch/arm/kernel/suspend.c                              |    1=20
 arch/arm/mach-omap2/omap-mpuss-lowpower.c              |    1=20
 arch/arm/mm/hugetlbpage.c                              |    1=20
 arch/arm/mm/init.c                                     |    9=20
 arch/arm/mm/mmu.c                                      |    1=20
 arch/arm64/include/asm/pgalloc.h                       |   39=20
 arch/arm64/kernel/setup.c                              |    2=20
 arch/arm64/kernel/smp.c                                |    1=20
 arch/arm64/mm/hugetlbpage.c                            |    1=20
 arch/arm64/mm/init.c                                   |    6=20
 arch/arm64/mm/ioremap.c                                |    1=20
 arch/arm64/mm/mmu.c                                    |   63 -
 arch/csky/include/asm/pgalloc.h                        |    7=20
 arch/csky/kernel/smp.c                                 |    1=20
 arch/hexagon/include/asm/pgalloc.h                     |    7=20
 arch/ia64/include/asm/pgalloc.h                        |   24=20
 arch/ia64/include/asm/tlb.h                            |    1=20
 arch/ia64/kernel/process.c                             |    1=20
 arch/ia64/kernel/smp.c                                 |    1=20
 arch/ia64/kernel/smpboot.c                             |    1=20
 arch/ia64/mm/contig.c                                  |    1=20
 arch/ia64/mm/discontig.c                               |    4=20
 arch/ia64/mm/hugetlbpage.c                             |    1=20
 arch/ia64/mm/tlb.c                                     |    1=20
 arch/m68k/include/asm/mmu_context.h                    |    2=20
 arch/m68k/include/asm/sun3_pgalloc.h                   |    7=20
 arch/m68k/kernel/dma.c                                 |    2=20
 arch/m68k/kernel/traps.c                               |    3=20
 arch/m68k/mm/cache.c                                   |    2=20
 arch/m68k/mm/fault.c                                   |    1=20
 arch/m68k/mm/kmap.c                                    |    2=20
 arch/m68k/mm/mcfmmu.c                                  |    1=20
 arch/m68k/mm/memory.c                                  |    1=20
 arch/m68k/sun3x/dvma.c                                 |    2=20
 arch/microblaze/include/asm/pgalloc.h                  |    6=20
 arch/microblaze/include/asm/tlbflush.h                 |    1=20
 arch/microblaze/kernel/process.c                       |    1=20
 arch/microblaze/kernel/signal.c                        |    1=20
 arch/microblaze/mm/init.c                              |    3=20
 arch/mips/include/asm/pgalloc.h                        |   19=20
 arch/mips/kernel/setup.c                               |    8=20
 arch/mips/loongson64/numa.c                            |    1=20
 arch/mips/sgi-ip27/ip27-memory.c                       |    2=20
 arch/mips/sgi-ip32/ip32-memory.c                       |    1=20
 arch/nds32/mm/mm-nds32.c                               |    2=20
 arch/nios2/include/asm/pgalloc.h                       |    7=20
 arch/openrisc/include/asm/pgalloc.h                    |   33=20
 arch/openrisc/include/asm/tlbflush.h                   |    1=20
 arch/openrisc/kernel/or32_ksyms.c                      |    1=20
 arch/parisc/include/asm/mmu_context.h                  |    1=20
 arch/parisc/include/asm/pgalloc.h                      |   12=20
 arch/parisc/kernel/cache.c                             |    1=20
 arch/parisc/kernel/pci-dma.c                           |    1=20
 arch/parisc/kernel/process.c                           |    1=20
 arch/parisc/kernel/signal.c                            |    1=20
 arch/parisc/kernel/smp.c                               |    1=20
 arch/parisc/mm/hugetlbpage.c                           |    1=20
 arch/parisc/mm/init.c                                  |    5=20
 arch/parisc/mm/ioremap.c                               |    2=20
 arch/powerpc/include/asm/tlb.h                         |    1=20
 arch/powerpc/mm/book3s64/hash_hugetlbpage.c            |    1=20
 arch/powerpc/mm/book3s64/hash_pgtable.c                |    1=20
 arch/powerpc/mm/book3s64/hash_tlb.c                    |    1=20
 arch/powerpc/mm/book3s64/radix_hugetlbpage.c           |    1=20
 arch/powerpc/mm/init_32.c                              |    1=20
 arch/powerpc/mm/init_64.c                              |    4=20
 arch/powerpc/mm/kasan/8xx.c                            |    1=20
 arch/powerpc/mm/kasan/book3s_32.c                      |    1=20
 arch/powerpc/mm/mem.c                                  |    3=20
 arch/powerpc/mm/nohash/40x.c                           |    1=20
 arch/powerpc/mm/nohash/8xx.c                           |    1=20
 arch/powerpc/mm/nohash/fsl_booke.c                     |    1=20
 arch/powerpc/mm/nohash/kaslr_booke.c                   |    1=20
 arch/powerpc/mm/nohash/tlb.c                           |    1=20
 arch/powerpc/mm/numa.c                                 |    1=20
 arch/powerpc/mm/pgtable.c                              |    1=20
 arch/powerpc/mm/pgtable_64.c                           |    1=20
 arch/powerpc/mm/ptdump/hashpagetable.c                 |    2=20
 arch/powerpc/mm/ptdump/ptdump.c                        |    1=20
 arch/powerpc/platforms/pseries/cmm.c                   |    1=20
 arch/riscv/include/asm/pgalloc.h                       |   18=20
 arch/riscv/mm/fault.c                                  |    1=20
 arch/riscv/mm/init.c                                   |    3=20
 arch/s390/crypto/prng.c                                |    4=20
 arch/s390/include/asm/tlb.h                            |    1=20
 arch/s390/include/asm/tlbflush.h                       |    1=20
 arch/s390/kernel/machine_kexec.c                       |    1=20
 arch/s390/kernel/ptrace.c                              |    1=20
 arch/s390/kvm/diag.c                                   |    1=20
 arch/s390/kvm/priv.c                                   |    1=20
 arch/s390/kvm/pv.c                                     |    1=20
 arch/s390/mm/cmm.c                                     |    1=20
 arch/s390/mm/init.c                                    |    1=20
 arch/s390/mm/mmap.c                                    |    1=20
 arch/s390/mm/pgtable.c                                 |    1=20
 arch/sh/include/asm/pgalloc.h                          |    4=20
 arch/sh/kernel/idle.c                                  |    1=20
 arch/sh/kernel/machine_kexec.c                         |    1=20
 arch/sh/mm/cache-sh3.c                                 |    1=20
 arch/sh/mm/cache-sh7705.c                              |    1=20
 arch/sh/mm/hugetlbpage.c                               |    1=20
 arch/sh/mm/init.c                                      |    7=20
 arch/sh/mm/ioremap_fixed.c                             |    1=20
 arch/sh/mm/numa.c                                      |    3=20
 arch/sh/mm/tlb-sh3.c                                   |    1=20
 arch/sparc/include/asm/ide.h                           |    1=20
 arch/sparc/include/asm/tlb_64.h                        |    1=20
 arch/sparc/kernel/leon_smp.c                           |    1=20
 arch/sparc/kernel/process_32.c                         |    1=20
 arch/sparc/kernel/signal_32.c                          |    1=20
 arch/sparc/kernel/smp_32.c                             |    1=20
 arch/sparc/kernel/smp_64.c                             |    1=20
 arch/sparc/kernel/sun4m_irq.c                          |    1=20
 arch/sparc/mm/highmem.c                                |    1=20
 arch/sparc/mm/init_64.c                                |    1=20
 arch/sparc/mm/io-unit.c                                |    1=20
 arch/sparc/mm/iommu.c                                  |    1=20
 arch/sparc/mm/tlb.c                                    |    1=20
 arch/um/include/asm/pgalloc.h                          |    9=20
 arch/um/include/asm/pgtable-3level.h                   |    3=20
 arch/um/kernel/mem.c                                   |   17=20
 arch/x86/ia32/ia32_aout.c                              |    1=20
 arch/x86/include/asm/mmu_context.h                     |    1=20
 arch/x86/include/asm/pgalloc.h                         |   42=20
 arch/x86/kernel/alternative.c                          |    1=20
 arch/x86/kernel/apic/apic.c                            |    1=20
 arch/x86/kernel/mpparse.c                              |    1=20
 arch/x86/kernel/traps.c                                |    1=20
 arch/x86/mm/fault.c                                    |    1=20
 arch/x86/mm/hugetlbpage.c                              |    1=20
 arch/x86/mm/init_32.c                                  |    2=20
 arch/x86/mm/init_64.c                                  |   12=20
 arch/x86/mm/kaslr.c                                    |    1=20
 arch/x86/mm/pgtable_32.c                               |    1=20
 arch/x86/mm/pti.c                                      |    1=20
 arch/x86/platform/uv/bios_uv.c                         |    1=20
 arch/x86/power/hibernate.c                             |    2=20
 arch/xtensa/include/asm/pgalloc.h                      |   46=20
 arch/xtensa/kernel/xtensa_ksyms.c                      |    1=20
 arch/xtensa/mm/cache.c                                 |    1=20
 arch/xtensa/mm/fault.c                                 |    1=20
 crypto/adiantum.c                                      |    2=20
 crypto/ahash.c                                         |    4=20
 crypto/api.c                                           |    2=20
 crypto/asymmetric_keys/verify_pefile.c                 |    4=20
 crypto/deflate.c                                       |    2=20
 crypto/drbg.c                                          |   10=20
 crypto/ecc.c                                           |    8=20
 crypto/ecdh.c                                          |    2=20
 crypto/gcm.c                                           |    2=20
 crypto/gf128mul.c                                      |    4=20
 crypto/jitterentropy-kcapi.c                           |    2=20
 crypto/rng.c                                           |    2=20
 crypto/rsa-pkcs1pad.c                                  |    6=20
 crypto/seqiv.c                                         |    2=20
 crypto/shash.c                                         |    2=20
 crypto/skcipher.c                                      |    2=20
 crypto/testmgr.c                                       |    6=20
 crypto/zstd.c                                          |    2=20
 drivers/base/node.c                                    |   10=20
 drivers/block/xen-blkback/common.h                     |    1=20
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c    |    2=20
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c    |    2=20
 drivers/crypto/amlogic/amlogic-gxl-cipher.c            |    4=20
 drivers/crypto/atmel-ecc.c                             |    2=20
 drivers/crypto/caam/caampkc.c                          |   28=20
 drivers/crypto/cavium/cpt/cptvf_main.c                 |    6=20
 drivers/crypto/cavium/cpt/cptvf_reqmanager.c           |   12=20
 drivers/crypto/cavium/nitrox/nitrox_lib.c              |    4=20
 drivers/crypto/cavium/zip/zip_crypto.c                 |    6=20
 drivers/crypto/ccp/ccp-crypto-rsa.c                    |    6=20
 drivers/crypto/ccree/cc_aead.c                         |    4=20
 drivers/crypto/ccree/cc_buffer_mgr.c                   |    4=20
 drivers/crypto/ccree/cc_cipher.c                       |    6=20
 drivers/crypto/ccree/cc_hash.c                         |    8=20
 drivers/crypto/ccree/cc_request_mgr.c                  |    2=20
 drivers/crypto/marvell/cesa/hash.c                     |    2=20
 drivers/crypto/marvell/octeontx/otx_cptvf_main.c       |    6=20
 drivers/crypto/marvell/octeontx/otx_cptvf_reqmgr.h     |    2=20
 drivers/crypto/nx/nx.c                                 |    4=20
 drivers/crypto/virtio/virtio_crypto_algs.c             |   12=20
 drivers/crypto/virtio/virtio_crypto_core.c             |    2=20
 drivers/iommu/ipmmu-vmsa.c                             |    1=20
 drivers/md/dm-crypt.c                                  |   32=20
 drivers/md/dm-integrity.c                              |    6=20
 drivers/misc/ibmvmc.c                                  |    6=20
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |    2=20
 drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c         |    6=20
 drivers/net/ppp/ppp_mppe.c                             |    6=20
 drivers/net/wireguard/noise.c                          |    4=20
 drivers/net/wireguard/peer.c                           |    2=20
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c           |    2=20
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c      |    6=20
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c           |    6=20
 drivers/net/wireless/intersil/orinoco/wext.c           |    4=20
 drivers/s390/crypto/ap_bus.h                           |    4=20
 drivers/staging/ks7010/ks_hostif.c                     |    2=20
 drivers/staging/rtl8723bs/core/rtw_security.c          |    2=20
 drivers/staging/wlan-ng/p80211netdev.c                 |    2=20
 drivers/target/iscsi/iscsi_target_auth.c               |    2=20
 drivers/xen/balloon.c                                  |    1=20
 drivers/xen/privcmd.c                                  |    1=20
 fs/Kconfig                                             |   21=20
 fs/aio.c                                               |    6=20
 fs/binfmt_elf_fdpic.c                                  |    1=20
 fs/cifs/cifsencrypt.c                                  |    2=20
 fs/cifs/connect.c                                      |   10=20
 fs/cifs/dfs_cache.c                                    |    2=20
 fs/cifs/misc.c                                         |    8=20
 fs/crypto/inline_crypt.c                               |    5=20
 fs/crypto/keyring.c                                    |    6=20
 fs/crypto/keysetup_v1.c                                |    4=20
 fs/ecryptfs/keystore.c                                 |    4=20
 fs/ecryptfs/messaging.c                                |    2=20
 fs/hugetlbfs/inode.c                                   |    2=20
 fs/ntfs/dir.c                                          |    2=20
 fs/ntfs/inode.c                                        |   27=20
 fs/ntfs/inode.h                                        |    4=20
 fs/ntfs/mft.c                                          |    4=20
 fs/ocfs2/Kconfig                                       |    6=20
 fs/ocfs2/acl.c                                         |    2=20
 fs/ocfs2/blockcheck.c                                  |    2=20
 fs/ocfs2/dlmglue.c                                     |    8=20
 fs/ocfs2/ocfs2.h                                       |    4=20
 fs/ocfs2/suballoc.c                                    |    4=20
 fs/ocfs2/suballoc.h                                    |    2=20
 fs/ocfs2/super.c                                       |    4=20
 fs/proc/meminfo.c                                      |   10=20
 include/asm-generic/pgalloc.h                          |   80 +
 include/asm-generic/tlb.h                              |    1=20
 include/crypto/aead.h                                  |    2=20
 include/crypto/akcipher.h                              |    2=20
 include/crypto/gf128mul.h                              |    2=20
 include/crypto/hash.h                                  |    2=20
 include/crypto/internal/acompress.h                    |    2=20
 include/crypto/kpp.h                                   |    2=20
 include/crypto/skcipher.h                              |    2=20
 include/linux/efi.h                                    |    4=20
 include/linux/fs.h                                     |   17=20
 include/linux/huge_mm.h                                |    2=20
 include/linux/kasan.h                                  |    4=20
 include/linux/memcontrol.h                             |  209 +++-
 include/linux/mm.h                                     |   86 -
 include/linux/mm_types.h                               |    5=20
 include/linux/mman.h                                   |    4=20
 include/linux/mmu_notifier.h                           |   13=20
 include/linux/mmzone.h                                 |   54 -
 include/linux/pageblock-flags.h                        |   30=20
 include/linux/percpu_counter.h                         |    4=20
 include/linux/sched/mm.h                               |    8=20
 include/linux/shmem_fs.h                               |    3=20
 include/linux/slab.h                                   |   11=20
 include/linux/slab_def.h                               |    9=20
 include/linux/slub_def.h                               |   31=20
 include/linux/swap.h                                   |    2=20
 include/linux/vmstat.h                                 |   14=20
 init/Kconfig                                           |    9=20
 init/main.c                                            |    2=20
 ipc/shm.c                                              |    2=20
 kernel/fork.c                                          |   54 -
 kernel/kthread.c                                       |    8=20
 kernel/power/snapshot.c                                |    2=20
 kernel/rcu/tree.c                                      |    2=20
 kernel/scs.c                                           |    2=20
 kernel/sysctl.c                                        |    2=20
 lib/Kconfig.kasan                                      |   39=20
 lib/Makefile                                           |    1=20
 lib/ioremap.c                                          |  287 -----
 lib/mpi/mpiutil.c                                      |    6=20
 lib/percpu_counter.c                                   |   19=20
 lib/test_kasan.c                                       |   87 +
 mm/Kconfig                                             |    6=20
 mm/Makefile                                            |    2=20
 mm/debug.c                                             |  103 +-
 mm/debug_vm_pgtable.c                                  |  666 +++++++++++++
 mm/filemap.c                                           |    9=20
 mm/gup.c                                               |    3=20
 mm/huge_memory.c                                       |   14=20
 mm/hugetlb.c                                           |   25=20
 mm/ioremap.c                                           |  289 +++++
 mm/kasan/common.c                                      |   41=20
 mm/kasan/generic.c                                     |   43=20
 mm/kasan/generic_report.c                              |    1=20
 mm/kasan/kasan.h                                       |   25=20
 mm/kasan/quarantine.c                                  |    1=20
 mm/kasan/report.c                                      |   54 -
 mm/kasan/tags.c                                        |   37=20
 mm/khugepaged.c                                        |   75 -
 mm/memcontrol.c                                        |  832 ++++++++++--=
-----
 mm/memory.c                                            |   15=20
 mm/memory_hotplug.c                                    |   11=20
 mm/migrate.c                                           |    6=20
 mm/mm_init.c                                           |   20=20
 mm/mmap.c                                              |   45=20
 mm/mremap.c                                            |   19=20
 mm/nommu.c                                             |    6=20
 mm/oom_kill.c                                          |    2=20
 mm/page-writeback.c                                    |    6=20
 mm/page_alloc.c                                        |  226 ++--
 mm/page_counter.c                                      |    6=20
 mm/page_io.c                                           |    2=20
 mm/pgalloc-track.h                                     |   51 +
 mm/shmem.c                                             |  133 ++
 mm/shuffle.c                                           |   46=20
 mm/shuffle.h                                           |   17=20
 mm/slab.c                                              |  129 +-
 mm/slab.h                                              |  755 ++++++------=
---
 mm/slab_common.c                                       |  829 ++----------=
----
 mm/slob.c                                              |   12=20
 mm/slub.c                                              |  680 ++++---------
 mm/sparse-vmemmap.c                                    |   62 -
 mm/sparse.c                                            |   31=20
 mm/swap_slots.c                                        |   45=20
 mm/swap_state.c                                        |    2=20
 mm/util.c                                              |   52 +
 mm/vmalloc.c                                           |  176 +--
 mm/vmscan.c                                            |   39=20
 mm/vmstat.c                                            |   38=20
 mm/workingset.c                                        |    6=20
 net/atm/mpoa_caches.c                                  |    4=20
 net/bluetooth/ecdh_helper.c                            |    6=20
 net/bluetooth/smp.c                                    |   24=20
 net/core/sock.c                                        |    2=20
 net/ipv4/tcp_fastopen.c                                |    2=20
 net/mac80211/aead_api.c                                |    4=20
 net/mac80211/aes_gmac.c                                |    2=20
 net/mac80211/key.c                                     |    2=20
 net/mac802154/llsec.c                                  |   20=20
 net/sctp/auth.c                                        |    2=20
 net/sunrpc/auth_gss/gss_krb5_crypto.c                  |    4=20
 net/sunrpc/auth_gss/gss_krb5_keys.c                    |    6=20
 net/sunrpc/auth_gss/gss_krb5_mech.c                    |    2=20
 net/tipc/crypto.c                                      |   10=20
 net/wireless/core.c                                    |    2=20
 net/wireless/ibss.c                                    |    4=20
 net/wireless/lib80211_crypt_tkip.c                     |    2=20
 net/wireless/lib80211_crypt_wep.c                      |    2=20
 net/wireless/nl80211.c                                 |   24=20
 net/wireless/sme.c                                     |    6=20
 net/wireless/util.c                                    |    2=20
 net/wireless/wext-sme.c                                |    2=20
 scripts/Makefile.kasan                                 |    3=20
 scripts/bloat-o-meter                                  |    2=20
 scripts/coccinelle/free/devm_free.cocci                |    4=20
 scripts/coccinelle/free/ifnullfree.cocci               |    4=20
 scripts/coccinelle/free/kfree.cocci                    |    6=20
 scripts/coccinelle/free/kfreeaddr.cocci                |    2=20
 scripts/const_structs.checkpatch                       |    1=20
 scripts/decode_stacktrace.sh                           |   85 +
 scripts/spelling.txt                                   |   19=20
 scripts/tags.sh                                        |   18=20
 security/apparmor/domain.c                             |    4=20
 security/apparmor/include/file.h                       |    2=20
 security/apparmor/policy.c                             |   24=20
 security/apparmor/policy_ns.c                          |    6=20
 security/apparmor/policy_unpack.c                      |   14=20
 security/keys/big_key.c                                |    6=20
 security/keys/dh.c                                     |   14=20
 security/keys/encrypted-keys/encrypted.c               |   14=20
 security/keys/trusted-keys/trusted_tpm1.c              |   34=20
 security/keys/user_defined.c                           |    6=20
 tools/cgroup/memcg_slabinfo.py                         |  226 ++++
 tools/include/linux/jhash.h                            |    2=20
 tools/lib/rbtree.c                                     |    2=20
 tools/lib/traceevent/event-parse.h                     |    2=20
 tools/testing/ktest/examples/README                    |    2=20
 tools/testing/ktest/examples/crosstests.conf           |    2=20
 tools/testing/selftests/Makefile                       |    1=20
 tools/testing/selftests/cgroup/.gitignore              |    1=20
 tools/testing/selftests/cgroup/Makefile                |    2=20
 tools/testing/selftests/cgroup/cgroup_util.c           |    2=20
 tools/testing/selftests/cgroup/test_kmem.c             |  382 +++++++
 tools/testing/selftests/mincore/.gitignore             |    2=20
 tools/testing/selftests/mincore/Makefile               |    6=20
 tools/testing/selftests/mincore/mincore_selftest.c     |  361 +++++++
 397 files changed, 5547 insertions(+), 4072 deletions(-)

