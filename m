Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2D64C433DB
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:15:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47BF864F10
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:15:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbhBZBPg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:15:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:47452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229460AbhBZBPe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:15:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F14C264EDC;
        Fri, 26 Feb 2021 01:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302093;
        bh=+R3ZKlOF0BoA1D3+8H1aqwD61+kXsQSvJ4wqidfwdlM=;
        h=Date:From:To:Cc:Subject:From;
        b=ur0sqFxR2u8oR362XtLbyAZZjrXXrXEP4HOUzdSRUYv0GNN6HZuhbxuydhWWrWjyM
         Q3LrCk7HmUN+uoSsieLGQuHsmJCe7rieNji/C+NsFXocQLMxTrQ3wL+bmXruwuam6i
         +AkUVGocOC1JLR2kjjWB+/sCp1LLsk/DUb3RMB30=
Date:   Thu, 25 Feb 2021 17:14:52 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, linux-mm@kvack.org
Subject: incoming
Message-Id: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


- The rest of MM.

  Includes kfence - another runtime memory validator.  Not as
  thorough as KASAN, but it has unmeasurable overhead and is intended
  to be usable in production builds.

- Everything else


118 patches, based on 6fbd6cf85a3be127454a1ad58525a3adcf8612ab.

Subsystems affected by this patch series:

  mm/thp
  mm/cma
  mm/vmstat
  mm/memory-hotplug
  mm/mlock
  mm/rmap
  mm/zswap
  mm/zsmalloc
  mm/cleanups
  mm/kfence
  mm/kasan2
  alpha
  procfs
  sysctl
  misc
  core-kernel
  MAINTAINERS
  lib
  bitops
  checkpatch
  init
  coredump
  seq_file
  gdb
  ubsan
  initramfs
  mm/pagemap2

Subsystem: mm/thp

    "Matthew Wilcox (Oracle)" <willy@infradead.org>:
    Patch series "Overhaul multi-page lookups for THP", v4:
      mm: make pagecache tagged lookups return only head pages
      mm/shmem: use pagevec_lookup in shmem_unlock_mapping
      mm/swap: optimise get_shadow_from_swap_cache
      mm: add FGP_ENTRY
      mm/filemap: rename find_get_entry to mapping_get_entry
      mm/filemap: add helper for finding pages
      mm/filemap: add mapping_seek_hole_data
      iomap: use mapping_seek_hole_data
      mm: add and use find_lock_entries
      mm: add an 'end' parameter to find_get_entries
      mm: add an 'end' parameter to pagevec_lookup_entries
      mm: remove nr_entries parameter from pagevec_lookup_entries
      mm: pass pvec directly to find_get_entries
      mm: remove pagevec_lookup_entries

    Rik van Riel <riel@surriel.com>:
    Patch series "mm,thp,shm: limit shmem THP alloc gfp_mask", v6:
      mm,thp,shmem: limit shmem THP alloc gfp_mask
      mm,thp,shm: limit gfp mask to no more than specified
      mm,thp,shmem: make khugepaged obey tmpfs mount flags
      mm,shmem,thp: limit shmem THP allocations to requested zones

Subsystem: mm/cma

    Roman Gushchin <guro@fb.com>:
      mm: cma: allocate cma areas bottom-up

    David Hildenbrand <david@redhat.com>:
      mm/cma: expose all pages to the buddy if activation of an area fails
      mm/page_alloc: count CMA pages per zone and print them in /proc/zoneinfo

    Patrick Daly <pdaly@codeaurora.org>:
      mm: cma: print region name on failure

Subsystem: mm/vmstat

    Johannes Weiner <hannes@cmpxchg.org>:
      mm: vmstat: fix NOHZ wakeups for node stat changes
      mm: vmstat: add some comments on internal storage of byte items

    Jiang Biao <benbjiang@tencent.com>:
      mm/vmstat.c: erase latency in vmstat_shepherd

Subsystem: mm/memory-hotplug

    Dan Williams <dan.j.williams@intel.com>:
    Patch series "mm: Fix pfn_to_online_page() with respect to ZONE_DEVICE", v4:
      mm: move pfn_to_online_page() out of line
      mm: teach pfn_to_online_page() to consider subsection validity
      mm: teach pfn_to_online_page() about ZONE_DEVICE section collisions
      mm: fix memory_failure() handling of dax-namespace metadata

    Anshuman Khandual <anshuman.khandual@arm.com>:
      mm/memory_hotplug: rename all existing 'memhp' into 'mhp'

    David Hildenbrand <david@redhat.com>:
      mm/memory_hotplug: MEMHP_MERGE_RESOURCE -> MHP_MERGE_RESOURCE

    Miaohe Lin <linmiaohe@huawei.com>:
      mm/memory_hotplug: use helper function zone_end_pfn() to get end_pfn

    David Hildenbrand <david@redhat.com>:
      drivers/base/memory: don't store phys_device in memory blocks
      Documentation: sysfs/memory: clarify some memory block device properties

    Anshuman Khandual <anshuman.khandual@arm.com>:
    Patch series "mm/memory_hotplug: Pre-validate the address range with platform", v5:
      mm/memory_hotplug: prevalidate the address range being added with platform
      arm64/mm: define arch_get_mappable_range()
      s390/mm: define arch_get_mappable_range()

    David Hildenbrand <david@redhat.com>:
      virtio-mem: check against mhp_get_pluggable_range() which memory we can hotplug

Subsystem: mm/mlock

    Miaohe Lin <linmiaohe@huawei.com>:
      mm/mlock: stop counting mlocked pages when none vma is found

Subsystem: mm/rmap

    Miaohe Lin <linmiaohe@huawei.com>:
      mm/rmap: correct some obsolete comments of anon_vma
      mm/rmap: remove unneeded semicolon in page_not_mapped()
      mm/rmap: fix obsolete comment in __page_check_anon_rmap()
      mm/rmap: use page_not_mapped in try_to_unmap()
      mm/rmap: correct obsolete comment of page_get_anon_vma()
      mm/rmap: fix potential pte_unmap on an not mapped pte

Subsystem: mm/zswap

    Randy Dunlap <rdunlap@infradead.org>:
      mm: zswap: clean up confusing comment

    Tian Tao <tiantao6@hisilicon.com>:
    Patch series "Fix the compatibility of zsmalloc and zswap":
      mm/zswap: add the flag can_sleep_mapped
      mm: set the sleep_mapped to true for zbud and z3fold

Subsystem: mm/zsmalloc

    Miaohe Lin <linmiaohe@huawei.com>:
      mm/zsmalloc.c: convert to use kmem_cache_zalloc in cache_alloc_zspage()

    Rokudo Yan <wu-yan@tcl.com>:
      zsmalloc: account the number of compacted pages correctly

    Miaohe Lin <linmiaohe@huawei.com>:
      mm/zsmalloc.c: use page_private() to access page->private

Subsystem: mm/cleanups

    Guo Ren <guoren@linux.alibaba.com>:
      mm: page-flags.h: Typo fix (It -> If)

    Daniel Vetter <daniel.vetter@ffwll.ch>:
      mm/dmapool: use might_alloc()
      mm/backing-dev.c: use might_alloc()

    Stephen Zhang <stephenzhangzsd@gmail.com>:
      mm/early_ioremap.c: use __func__ instead of function name

Subsystem: mm/kfence

    Alexander Potapenko <glider@google.com>:
    Patch series "KFENCE: A low-overhead sampling-based memory safety error detector", v7:
      mm: add Kernel Electric-Fence infrastructure
      x86, kfence: enable KFENCE for x86

    Marco Elver <elver@google.com>:
      arm64, kfence: enable KFENCE for ARM64
      kfence: use pt_regs to generate stack trace on faults

    Alexander Potapenko <glider@google.com>:
      mm, kfence: insert KFENCE hooks for SLAB
      mm, kfence: insert KFENCE hooks for SLUB
      kfence, kasan: make KFENCE compatible with KASAN

    Marco Elver <elver@google.com>:
      kfence, Documentation: add KFENCE documentation
      kfence: add test suite
      MAINTAINERS: add entry for KFENCE
      kfence: report sensitive information based on no_hash_pointers

    Alexander Potapenko <glider@google.com>:
    Patch series "Add error_report_end tracepoint to KFENCE and KASAN", v3:
      tracing: add error_report_end trace point
      kfence: use error_report_end tracepoint
      kasan: use error_report_end tracepoint

Subsystem: mm/kasan2

    Andrey Konovalov <andreyknvl@google.com>:
    Patch series "kasan: optimizations and fixes for HW_TAGS", v4:
      kasan, mm: don't save alloc stacks twice
      kasan, mm: optimize kmalloc poisoning
      kasan: optimize large kmalloc poisoning
      kasan: clean up setting free info in kasan_slab_free
      kasan: unify large kfree checks
      kasan: rework krealloc tests
      kasan, mm: fail krealloc on freed objects
      kasan, mm: optimize krealloc poisoning
      kasan: ensure poisoning size alignment
      arm64: kasan: simplify and inline MTE functions
      kasan: inline HW_TAGS helper functions
      kasan: clarify that only first bug is reported in HW_TAGS

Subsystem: alpha

    Randy Dunlap <rdunlap@infradead.org>:
      alpha: remove CONFIG_EXPERIMENTAL from defconfigs

Subsystem: procfs

    Helge Deller <deller@gmx.de>:
      proc/wchan: use printk format instead of lookup_symbol_name()

    Josef Bacik <josef@toxicpanda.com>:
      proc: use kvzalloc for our kernel buffer

Subsystem: sysctl

    Lin Feng <linf@wangsu.com>:
      sysctl.c: fix underflow value setting risk in vm_table

Subsystem: misc

    Randy Dunlap <rdunlap@infradead.org>:
      include/linux: remove repeated words

    Miguel Ojeda <ojeda@kernel.org>:
      treewide: Miguel has moved

Subsystem: core-kernel

    Hubert Jasudowicz <hubert.jasudowicz@gmail.com>:
      groups: use flexible-array member in struct group_info
      groups: simplify struct group_info allocation

    Randy Dunlap <rdunlap@infradead.org>:
      kernel: delete repeated words in comments

Subsystem: MAINTAINERS

    Vlastimil Babka <vbabka@suse.cz>:
      MAINTAINERS: add uapi directories to API/ABI section

Subsystem: lib

    Huang Shijie <sjhuang@iluvatar.ai>:
      lib/genalloc.c: change return type to unsigned long for bitmap_set_ll

    Francis Laniel <laniel_francis@privacyrequired.com>:
      string.h: move fortified functions definitions in a dedicated header.

    Yogesh Lal <ylal@codeaurora.org>:
      lib: stackdepot: add support to configure STACK_HASH_SIZE

    Vijayanand Jitta <vjitta@codeaurora.org>:
      lib: stackdepot: add support to disable stack depot
      lib: stackdepot: fix ignoring return value warning

    Masahiro Yamada <masahiroy@kernel.org>:
      lib/cmdline: remove an unneeded local variable in next_arg()

Subsystem: bitops

    Geert Uytterhoeven <geert+renesas@glider.be>:
      include/linux/bitops.h: spelling s/synomyn/synonym/

Subsystem: checkpatch

    Joe Perches <joe@perches.com>:
      checkpatch: improve blank line after declaration test

    Peng Wang <rocking@linux.alibaba.com>:
      checkpatch: ignore warning designated initializers using NR_CPUS

    Dwaipayan Ray <dwaipayanray1@gmail.com>:
      checkpatch: trivial style fixes

    Joe Perches <joe@perches.com>:
      checkpatch: prefer ftrace over function entry/exit printks
      checkpatch: improve TYPECAST_INT_CONSTANT test message

    Aditya Srivastava <yashsri421@gmail.com>:
      checkpatch: add warning for avoiding .L prefix symbols in assembly files

    Joe Perches <joe@perches.com>:
      checkpatch: add kmalloc_array_node to unnecessary OOM message check

    Chris Down <chris@chrisdown.name>:
      checkpatch: don't warn about colon termination in linker scripts

    Song Liu <songliubraving@fb.com>:
      checkpatch: do not apply "initialise globals to 0" check to BPF progs

Subsystem: init

    Masahiro Yamada <masahiroy@kernel.org>:
      init/version.c: remove Version_<LINUX_VERSION_CODE> symbol
      init: clean up early_param_on_off() macro

    Bhaskar Chowdhury <unixbhaskar@gmail.com>:
      init/Kconfig: fix a typo in CC_VERSION_TEXT help text

Subsystem: coredump

    Ira Weiny <ira.weiny@intel.com>:
      fs/coredump: use kmap_local_page()

Subsystem: seq_file

    NeilBrown <neilb@suse.de>:
    Patch series "Fix some seq_file users that were recently broken":
      seq_file: document how per-entry resources are managed.
      x86: fix seq_file iteration for pat/memtype.c

Subsystem: gdb

    George Prekas <prekageo@amazon.com>:
      scripts/gdb: fix list_for_each

    Sumit Garg <sumit.garg@linaro.org>:
      kgdb: fix to kill breakpoints on initmem after boot

Subsystem: ubsan

    Andrey Ryabinin <ryabinin.a.a@gmail.com>:
      ubsan: remove overflow checks

Subsystem: initramfs

    Florian Fainelli <f.fainelli@gmail.com>:
      initramfs: panic with memory information

Subsystem: mm/pagemap2

    Huang Pei <huangpei@loongson.cn>:
      MIPS: make userspace mapping young by default

 .mailmap                                            |    1 
 CREDITS                                             |    9 
 Documentation/ABI/testing/sysfs-devices-memory      |   58 -
 Documentation/admin-guide/auxdisplay/cfag12864b.rst |    2 
 Documentation/admin-guide/auxdisplay/ks0108.rst     |    2 
 Documentation/admin-guide/kernel-parameters.txt     |    6 
 Documentation/admin-guide/mm/memory-hotplug.rst     |   20 
 Documentation/dev-tools/index.rst                   |    1 
 Documentation/dev-tools/kasan.rst                   |    8 
 Documentation/dev-tools/kfence.rst                  |  318 +++++++
 Documentation/filesystems/seq_file.rst              |    6 
 MAINTAINERS                                         |   26 
 arch/alpha/configs/defconfig                        |    1 
 arch/arm64/Kconfig                                  |    1 
 arch/arm64/include/asm/cache.h                      |    1 
 arch/arm64/include/asm/kasan.h                      |    1 
 arch/arm64/include/asm/kfence.h                     |   26 
 arch/arm64/include/asm/mte-def.h                    |    2 
 arch/arm64/include/asm/mte-kasan.h                  |   65 +
 arch/arm64/include/asm/mte.h                        |    2 
 arch/arm64/kernel/mte.c                             |   46 -
 arch/arm64/lib/mte.S                                |   16 
 arch/arm64/mm/fault.c                               |    8 
 arch/arm64/mm/mmu.c                                 |   23 
 arch/mips/mm/cache.c                                |   30 
 arch/s390/mm/init.c                                 |    1 
 arch/s390/mm/vmem.c                                 |   14 
 arch/x86/Kconfig                                    |    1 
 arch/x86/include/asm/kfence.h                       |   76 +
 arch/x86/mm/fault.c                                 |   10 
 arch/x86/mm/pat/memtype.c                           |    4 
 drivers/auxdisplay/cfag12864b.c                     |    4 
 drivers/auxdisplay/cfag12864bfb.c                   |    4 
 drivers/auxdisplay/ks0108.c                         |    4 
 drivers/base/memory.c                               |   35 
 drivers/block/zram/zram_drv.c                       |    2 
 drivers/hv/hv_balloon.c                             |    2 
 drivers/virtio/virtio_mem.c                         |   43 
 drivers/xen/balloon.c                               |    2 
 fs/coredump.c                                       |    4 
 fs/iomap/seek.c                                     |  125 --
 fs/proc/base.c                                      |   21 
 fs/proc/proc_sysctl.c                               |    4 
 include/linux/bitops.h                              |    2 
 include/linux/cfag12864b.h                          |    2 
 include/linux/cred.h                                |    2 
 include/linux/fortify-string.h                      |  302 ++++++
 include/linux/gfp.h                                 |    2 
 include/linux/init.h                                |    4 
 include/linux/kasan.h                               |   25 
 include/linux/kfence.h                              |  230 +++++
 include/linux/kgdb.h                                |    2 
 include/linux/khugepaged.h                          |    2 
 include/linux/ks0108.h                              |    2 
 include/linux/mdev.h                                |    2 
 include/linux/memory.h                              |    3 
 include/linux/memory_hotplug.h                      |   33 
 include/linux/memremap.h                            |    6 
 include/linux/mmzone.h                              |   49 -
 include/linux/page-flags.h                          |    4 
 include/linux/pagemap.h                             |   10 
 include/linux/pagevec.h                             |   10 
 include/linux/pgtable.h                             |    8 
 include/linux/ptrace.h                              |    2 
 include/linux/rmap.h                                |    3 
 include/linux/slab_def.h                            |    3 
 include/linux/slub_def.h                            |    3 
 include/linux/stackdepot.h                          |    9 
 include/linux/string.h                              |  282 ------
 include/linux/vmstat.h                              |    6 
 include/linux/zpool.h                               |    3 
 include/linux/zsmalloc.h                            |    2 
 include/trace/events/error_report.h                 |   74 +
 include/uapi/linux/firewire-cdev.h                  |    2 
 include/uapi/linux/input.h                          |    2 
 init/Kconfig                                        |    2 
 init/initramfs.c                                    |   19 
 init/main.c                                         |    6 
 init/version.c                                      |    8 
 kernel/debug/debug_core.c                           |   11 
 kernel/events/core.c                                |    8 
 kernel/events/uprobes.c                             |    2 
 kernel/groups.c                                     |    7 
 kernel/locking/rtmutex.c                            |    4 
 kernel/locking/rwsem.c                              |    2 
 kernel/locking/semaphore.c                          |    2 
 kernel/sched/fair.c                                 |    2 
 kernel/sched/membarrier.c                           |    2 
 kernel/sysctl.c                                     |    8 
 kernel/trace/Makefile                               |    1 
 kernel/trace/error_report-traces.c                  |   12 
 lib/Kconfig                                         |    9 
 lib/Kconfig.debug                                   |    1 
 lib/Kconfig.kfence                                  |   84 +
 lib/Kconfig.ubsan                                   |   17 
 lib/cmdline.c                                       |    7 
 lib/genalloc.c                                      |    3 
 lib/stackdepot.c                                    |   41 
 lib/test_kasan.c                                    |  111 ++
 lib/test_ubsan.c                                    |   49 -
 lib/ubsan.c                                         |   68 -
 mm/Makefile                                         |    1 
 mm/backing-dev.c                                    |    3 
 mm/cma.c                                            |   64 -
 mm/dmapool.c                                        |    3 
 mm/early_ioremap.c                                  |   12 
 mm/filemap.c                                        |  361 +++++---
 mm/huge_memory.c                                    |    6 
 mm/internal.h                                       |    6 
 mm/kasan/common.c                                   |  213 +++-
 mm/kasan/generic.c                                  |    3 
 mm/kasan/hw_tags.c                                  |    2 
 mm/kasan/kasan.h                                    |   97 +-
 mm/kasan/report.c                                   |    8 
 mm/kasan/shadow.c                                   |   78 +
 mm/kfence/Makefile                                  |    6 
 mm/kfence/core.c                                    |  875 +++++++++++++++++++-
 mm/kfence/kfence.h                                  |  126 ++
 mm/kfence/kfence_test.c                             |  860 +++++++++++++++++++
 mm/kfence/report.c                                  |  350 ++++++--
 mm/khugepaged.c                                     |   22 
 mm/memory-failure.c                                 |    6 
 mm/memory.c                                         |    4 
 mm/memory_hotplug.c                                 |  178 +++-
 mm/memremap.c                                       |   23 
 mm/mlock.c                                          |    2 
 mm/page_alloc.c                                     |    1 
 mm/rmap.c                                           |   24 
 mm/shmem.c                                          |  160 +--
 mm/slab.c                                           |   38 
 mm/slab_common.c                                    |   29 
 mm/slub.c                                           |   63 +
 mm/swap.c                                           |   54 -
 mm/swap_state.c                                     |    7 
 mm/truncate.c                                       |  141 ---
 mm/vmstat.c                                         |   35 
 mm/z3fold.c                                         |    1 
 mm/zbud.c                                           |    1 
 mm/zpool.c                                          |   13 
 mm/zsmalloc.c                                       |   22 
 mm/zswap.c                                          |   57 +
 samples/auxdisplay/cfag12864b-example.c             |    2 
 scripts/Makefile.ubsan                              |    2 
 scripts/checkpatch.pl                               |  152 ++-
 scripts/gdb/linux/lists.py                          |    5 
 145 files changed, 5046 insertions(+), 1682 deletions(-)

