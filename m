Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 478D3C433F5
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:52:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20AF661102
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:52:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347292AbhIHCxf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 22:53:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:49370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345895AbhIHCxe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 22:53:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E5DB2610C9;
        Wed,  8 Sep 2021 02:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631069547;
        bh=oM5QQc69N7GwkouaX2u7vhWifSSSzEiPfClGZEPls1Y=;
        h=Date:From:To:Cc:Subject:From;
        b=Yv0Ye7oZXkTw3/zKUGrjANJH/oU7F1BOs+mp5Mq28ERPqFLcj+fTtlKU010iWVc15
         JlVVUzbqBVvIHipcicPwq4wo29CDvvfr/g1t3ENsZOF9so0D5fTZ8kVgdSz1WTEtLD
         xcx/fXMkcOFwgbpe1p+dakhmYe7THV4WQafS872k=
Date:   Tue, 7 Sep 2021 19:52:26 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-mm@kvack.org, mm-commits@vger.kernel.org
Subject: incoming
Message-Id: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

147 patches, based on 7d2a07b769330c34b4deabeed939325c77a7ec2f.

Subsystems affected by this patch series:

  mm/slub
  mm/memory-hotplug
  mm/rmap
  mm/ioremap
  mm/highmem
  mm/cleanups
  mm/secretmem
  mm/kfence
  mm/damon
  alpha
  percpu
  procfs
  misc
  core-kernel
  MAINTAINERS
  lib
  bitops
  checkpatch
  epoll
  init
  nilfs2
  coredump
  fork
  pids
  criu
  kconfig
  selftests
  ipc
  mm/vmscan
  scripts

Subsystem: mm/slub

    Vlastimil Babka <vbabka@suse.cz>:
    Patch series "SLUB: reduce irq disabled scope and make it RT compatible", v6:
      mm, slub: don't call flush_all() from slab_debug_trace_open()
      mm, slub: allocate private object map for debugfs listings
      mm, slub: allocate private object map for validate_slab_cache()
      mm, slub: don't disable irq for debug_check_no_locks_freed()
      mm, slub: remove redundant unfreeze_partials() from put_cpu_partial()
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
      mm, slab: split out the cpu offline variant of flush_slab()

    Sebastian Andrzej Siewior <bigeasy@linutronix.de>:
      mm: slub: move flush_cpu_slab() invocations __free_slab() invocations out of IRQ context
      mm: slub: make object_map_lock a raw_spinlock_t

    Vlastimil Babka <vbabka@suse.cz>:
      mm, slub: make slab_lock() disable irqs with PREEMPT_RT
      mm, slub: protect put_cpu_partial() with disabled irqs instead of cmpxchg
      mm, slub: use migrate_disable() on PREEMPT_RT
      mm, slub: convert kmem_cpu_slab protection to local_lock

Subsystem: mm/memory-hotplug

    David Hildenbrand <david@redhat.com>:
    Patch series "memory-hotplug.rst: complete admin-guide overhaul", v3:
      memory-hotplug.rst: remove locking details from admin-guide
      memory-hotplug.rst: complete admin-guide overhaul

    Mike Rapoport <rppt@linux.ibm.com>:
    Patch series "mm: remove pfn_valid_within() and CONFIG_HOLES_IN_ZONE":
      mm: remove pfn_valid_within() and CONFIG_HOLES_IN_ZONE
      mm: memory_hotplug: cleanup after removal of pfn_valid_within()

    David Hildenbrand <david@redhat.com>:
    Patch series "mm/memory_hotplug: preparatory patches for new online policy and memory":
      mm/memory_hotplug: use "unsigned long" for PFN in zone_for_pfn_range()
      mm/memory_hotplug: remove nid parameter from arch_remove_memory()
      mm/memory_hotplug: remove nid parameter from remove_memory() and friends
      ACPI: memhotplug: memory resources cannot be enabled yet
    Patch series "mm/memory_hotplug: "auto-movable" online policy and memory groups", v3:
      mm: track present early pages per zone
      mm/memory_hotplug: introduce "auto-movable" online policy
      drivers/base/memory: introduce "memory groups" to logically group memory blocks
      mm/memory_hotplug: track present pages in memory groups
      ACPI: memhotplug: use a single static memory group for a single memory device
      dax/kmem: use a single static memory group for a single probed unit
      virtio-mem: use a single dynamic memory group for a single virtio-mem device
      mm/memory_hotplug: memory group aware "auto-movable" online policy
      mm/memory_hotplug: improved dynamic memory group aware "auto-movable" online policy

    Miaohe Lin <linmiaohe@huawei.com>:
    Patch series "Cleanup and fixups for memory hotplug":
      mm/memory_hotplug: use helper zone_is_zone_device() to simplify the code

Subsystem: mm/rmap

    Muchun Song <songmuchun@bytedance.com>:
      mm: remove redundant compound_head() calling

Subsystem: mm/ioremap

    Christoph Hellwig <hch@lst.de>:
      riscv: only select GENERIC_IOREMAP if MMU support is enabled
    Patch series "small ioremap cleanups":
      mm: move ioremap_page_range to vmalloc.c
      mm: don't allow executable ioremap mappings

    Weizhao Ouyang <o451686892@gmail.com>:
      mm/early_ioremap.c: remove redundant early_ioremap_shutdown()

Subsystem: mm/highmem

    Sebastian Andrzej Siewior <bigeasy@linutronix.de>:
      highmem: don't disable preemption on RT in kmap_atomic()

Subsystem: mm/cleanups

    Changbin Du <changbin.du@gmail.com>:
      mm: in_irq() cleanup

    Muchun Song <songmuchun@bytedance.com>:
      mm: introduce PAGEFLAGS_MASK to replace ((1UL << NR_PAGEFLAGS) - 1)

Subsystem: mm/secretmem

    Jordy Zomer <jordy@jordyzomer.github.io>:
      mm/secretmem: use refcount_t instead of atomic_t

Subsystem: mm/kfence

    Marco Elver <elver@google.com>:
      kfence: show cpu and timestamp in alloc/free info
      kfence: test: fail fast if disabled at boot

Subsystem: mm/damon

    SeongJae Park <sjpark@amazon.de>:
    Patch series "Introduce Data Access MONitor (DAMON)", v34:
      mm: introduce Data Access MONitor (DAMON)
      mm/damon/core: implement region-based sampling
      mm/damon: adaptively adjust regions
      mm/idle_page_tracking: make PG_idle reusable
      mm/damon: implement primitives for the virtual memory address spaces
      mm/damon: add a tracepoint
      mm/damon: implement a debugfs-based user space interface
      mm/damon/dbgfs: export kdamond pid to the user space
      mm/damon/dbgfs: support multiple contexts
      Documentation: add documents for DAMON
      mm/damon: add kunit tests
      mm/damon: add user space selftests
      MAINTAINERS: update for DAMON

Subsystem: alpha

    Randy Dunlap <rdunlap@infradead.org>:
      alpha: agp: make empty macros use do-while-0 style
      alpha: pci-sysfs: fix all kernel-doc warnings

Subsystem: percpu

    Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
      percpu: remove export of pcpu_base_addr

Subsystem: procfs

    Feng Zhou <zhoufeng.zf@bytedance.com>:
      fs/proc/kcore.c: add mmap interface

    Christoph Hellwig <hch@lst.de>:
      proc: stop using seq_get_buf in proc_task_name

    Ohhoon Kwon <ohoono.kwon@samsung.com>:
      connector: send event on write to /proc/[pid]/comm

Subsystem: misc

    Colin Ian King <colin.king@canonical.com>:
      arch: Kconfig: fix spelling mistake "seperate" -> "separate"

    Andy Shevchenko <andriy.shevchenko@linux.intel.com>:
      include/linux/once.h: fix trivia typo Not -> Note

    Daniel Lezcano <daniel.lezcano@linaro.org>:
    Patch series "Add Hz macros", v3:
      units: change from 'L' to 'UL'
      units: add the HZ macros
      thermal/drivers/devfreq_cooling: use HZ macros
      devfreq: use HZ macros
      iio/drivers/as73211: use HZ macros
      hwmon/drivers/mr75203: use HZ macros
      iio/drivers/hid-sensor: use HZ macros
      i2c/drivers/ov02q10: use HZ macros
      mtd/drivers/nand: use HZ macros
      phy/drivers/stm32: use HZ macros

Subsystem: core-kernel

    Yang Yang <yang.yang29@zte.com.cn>:
      kernel/acct.c: use dedicated helper to access rlimit values

    Pavel Skripkin <paskripkin@gmail.com>:
      profiling: fix shift-out-of-bounds bugs

Subsystem: MAINTAINERS

    Nathan Chancellor <nathan@kernel.org>:
      MAINTAINERS: update ClangBuiltLinux mailing list
      Documentation/llvm: update mailing list
      Documentation/llvm: update IRC location

Subsystem: lib

    Geert Uytterhoeven <geert@linux-m68k.org>:
    Patch series "math: RATIONAL and RATIONAL_KUNIT_TEST improvements":
      math: make RATIONAL tristate
      math: RATIONAL_KUNIT_TEST should depend on RATIONAL instead of selecting it

    Matteo Croce <mcroce@microsoft.com>:
    Patch series "lib/string: optimized mem* functions", v2:
      lib/string: optimized memcpy
      lib/string: optimized memmove
      lib/string: optimized memset

    Daniel Latypov <dlatypov@google.com>:
      lib/test: convert test_sort.c to use KUnit

    Randy Dunlap <rdunlap@infradead.org>:
      lib/dump_stack: correct kernel-doc notation
      lib/iov_iter.c: fix kernel-doc warnings

Subsystem: bitops

    Yury Norov <yury.norov@gmail.com>:
    Patch series "Resend bitmap patches":
      bitops: protect find_first_{,zero}_bit properly
      bitops: move find_bit_*_le functions from le.h to find.h
      include: move find.h from asm_generic to linux
      arch: remove GENERIC_FIND_FIRST_BIT entirely
      lib: add find_first_and_bit()
      cpumask: use find_first_and_bit()
      all: replace find_next{,_zero}_bit with find_first{,_zero}_bit where appropriate
      tools: sync tools/bitmap with mother linux
      cpumask: replace cpumask_next_* with cpumask_first_* where appropriate
      include/linux: move for_each_bit() macros from bitops.h to find.h
      find: micro-optimize for_each_{set,clear}_bit()
      bitops: replace for_each_*_bit_from() with for_each_*_bit() where appropriate

    Andy Shevchenko <andriy.shevchenko@linux.intel.com>:
      tools: rename bitmap_alloc() to bitmap_zalloc()

    Yury Norov <yury.norov@gmail.com>:
      mm/percpu: micro-optimize pcpu_is_populated()
      bitmap: unify find_bit operations
      lib: bitmap: add performance test for bitmap_print_to_pagebuf
      vsprintf: rework bitmap_list_string

Subsystem: checkpatch

    Joe Perches <joe@perches.com>:
      checkpatch: support wide strings

    Mimi Zohar <zohar@linux.ibm.com>:
      checkpatch: make email address check case insensitive

    Joe Perches <joe@perches.com>:
      checkpatch: improve GIT_COMMIT_ID test

Subsystem: epoll

    Nicholas Piggin <npiggin@gmail.com>:
      fs/epoll: use a per-cpu counter for user's watches count

Subsystem: init

    Rasmus Villemoes <linux@rasmusvillemoes.dk>:
      init: move usermodehelper_enable() to populate_rootfs()

    Kefeng Wang <wangkefeng.wang@huawei.com>:
      trap: cleanup trap_init()

Subsystem: nilfs2

    Nanyong Sun <sunnanyong@huawei.com>:
    Patch series "nilfs2: fix incorrect usage of kobject":
      nilfs2: fix memory leak in nilfs_sysfs_create_device_group
      nilfs2: fix NULL pointer in nilfs_##name##_attr_release
      nilfs2: fix memory leak in nilfs_sysfs_create_##name##_group
      nilfs2: fix memory leak in nilfs_sysfs_delete_##name##_group
      nilfs2: fix memory leak in nilfs_sysfs_create_snapshot_group
      nilfs2: fix memory leak in nilfs_sysfs_delete_snapshot_group

    Zhen Lei <thunder.leizhen@huawei.com>:
      nilfs2: use refcount_dec_and_lock() to fix potential UAF

Subsystem: coredump

    David Oberhollenzer <david.oberhollenzer@sigma-star.at>:
      fs/coredump.c: log if a core dump is aborted due to changed file permissions

    QiuXi <qiuxi1@huawei.com>:
      coredump: fix memleak in dump_vma_snapshot()

Subsystem: fork

    Christoph Hellwig <hch@lst.de>:
      kernel/fork.c: unexport get_{mm,task}_exe_file

Subsystem: pids

    Takahiro Itazuri <itazur@amazon.com>:
      pid: cleanup the stale comment mentioning pidmap_init().

Subsystem: criu

    Cyrill Gorcunov <gorcunov@gmail.com>:
      prctl: allow to setup brk for et_dyn executables

Subsystem: kconfig

    Zenghui Yu <yuzenghui@huawei.com>:
      configs: remove the obsolete CONFIG_INPUT_POLLDEV

    Lukas Bulwahn <lukas.bulwahn@gmail.com>:
      Kconfig.debug: drop selecting non-existing HARDLOCKUP_DETECTOR_ARCH

Subsystem: selftests

    Greg Thelen <gthelen@google.com>:
      selftests/memfd: remove unused variable

Subsystem: ipc

    Rafael Aquini <aquini@redhat.com>:
      ipc: replace costly bailout check in sysvipc_find_ipc()

Subsystem: mm/vmscan

    Randy Dunlap <rdunlap@infradead.org>:
      mm/workingset: correct kernel-doc notations

Subsystem: scripts

    Randy Dunlap <rdunlap@infradead.org>:
      scripts: check_extable: fix typo in user error message

 a/Documentation/admin-guide/mm/damon/index.rst            |   15 
 a/Documentation/admin-guide/mm/damon/start.rst            |  114 +
 a/Documentation/admin-guide/mm/damon/usage.rst            |  112 +
 a/Documentation/admin-guide/mm/index.rst                  |    1 
 a/Documentation/admin-guide/mm/memory-hotplug.rst         |  842 ++++++-----
 a/Documentation/dev-tools/kfence.rst                      |   98 -
 a/Documentation/kbuild/llvm.rst                           |    5 
 a/Documentation/vm/damon/api.rst                          |   20 
 a/Documentation/vm/damon/design.rst                       |  166 ++
 a/Documentation/vm/damon/faq.rst                          |   51 
 a/Documentation/vm/damon/index.rst                        |   30 
 a/Documentation/vm/index.rst                              |    1 
 a/MAINTAINERS                                             |   17 
 a/arch/Kconfig                                            |    2 
 a/arch/alpha/include/asm/agp.h                            |    4 
 a/arch/alpha/include/asm/bitops.h                         |    2 
 a/arch/alpha/kernel/pci-sysfs.c                           |   12 
 a/arch/arc/Kconfig                                        |    1 
 a/arch/arc/include/asm/bitops.h                           |    1 
 a/arch/arc/kernel/traps.c                                 |    5 
 a/arch/arm/configs/dove_defconfig                         |    1 
 a/arch/arm/configs/pxa_defconfig                          |    1 
 a/arch/arm/include/asm/bitops.h                           |    1 
 a/arch/arm/kernel/traps.c                                 |    5 
 a/arch/arm64/Kconfig                                      |    1 
 a/arch/arm64/include/asm/bitops.h                         |    1 
 a/arch/arm64/mm/mmu.c                                     |    3 
 a/arch/csky/include/asm/bitops.h                          |    1 
 a/arch/h8300/include/asm/bitops.h                         |    1 
 a/arch/h8300/kernel/traps.c                               |    4 
 a/arch/hexagon/include/asm/bitops.h                       |    1 
 a/arch/hexagon/kernel/traps.c                             |    4 
 a/arch/ia64/include/asm/bitops.h                          |    2 
 a/arch/ia64/mm/init.c                                     |    3 
 a/arch/m68k/include/asm/bitops.h                          |    2 
 a/arch/mips/Kconfig                                       |    1 
 a/arch/mips/configs/lemote2f_defconfig                    |    1 
 a/arch/mips/configs/pic32mzda_defconfig                   |    1 
 a/arch/mips/configs/rt305x_defconfig                      |    1 
 a/arch/mips/configs/xway_defconfig                        |    1 
 a/arch/mips/include/asm/bitops.h                          |    1 
 a/arch/nds32/kernel/traps.c                               |    5 
 a/arch/nios2/kernel/traps.c                               |    5 
 a/arch/openrisc/include/asm/bitops.h                      |    1 
 a/arch/openrisc/kernel/traps.c                            |    5 
 a/arch/parisc/configs/generic-32bit_defconfig             |    1 
 a/arch/parisc/include/asm/bitops.h                        |    2 
 a/arch/parisc/kernel/traps.c                              |    4 
 a/arch/powerpc/include/asm/bitops.h                       |    2 
 a/arch/powerpc/include/asm/cputhreads.h                   |    2 
 a/arch/powerpc/kernel/traps.c                             |    5 
 a/arch/powerpc/mm/mem.c                                   |    3 
 a/arch/powerpc/platforms/pasemi/dma_lib.c                 |    4 
 a/arch/powerpc/platforms/pseries/hotplug-memory.c         |    9 
 a/arch/riscv/Kconfig                                      |    2 
 a/arch/riscv/include/asm/bitops.h                         |    1 
 a/arch/riscv/kernel/traps.c                               |    5 
 a/arch/s390/Kconfig                                       |    1 
 a/arch/s390/include/asm/bitops.h                          |    1 
 a/arch/s390/kvm/kvm-s390.c                                |    2 
 a/arch/s390/mm/init.c                                     |    3 
 a/arch/sh/include/asm/bitops.h                            |    1 
 a/arch/sh/mm/init.c                                       |    3 
 a/arch/sparc/include/asm/bitops_32.h                      |    1 
 a/arch/sparc/include/asm/bitops_64.h                      |    2 
 a/arch/um/kernel/trap.c                                   |    4 
 a/arch/x86/Kconfig                                        |    1 
 a/arch/x86/configs/i386_defconfig                         |    1 
 a/arch/x86/configs/x86_64_defconfig                       |    1 
 a/arch/x86/include/asm/bitops.h                           |    2 
 a/arch/x86/kernel/apic/vector.c                           |    4 
 a/arch/x86/mm/init_32.c                                   |    3 
 a/arch/x86/mm/init_64.c                                   |    3 
 a/arch/x86/um/Kconfig                                     |    1 
 a/arch/xtensa/include/asm/bitops.h                        |    1 
 a/block/blk-mq.c                                          |    2 
 a/drivers/acpi/acpi_memhotplug.c                          |   46 
 a/drivers/base/memory.c                                   |  231 ++-
 a/drivers/base/node.c                                     |    2 
 a/drivers/block/rnbd/rnbd-clt.c                           |    2 
 a/drivers/dax/kmem.c                                      |   43 
 a/drivers/devfreq/devfreq.c                               |    2 
 a/drivers/dma/ti/edma.c                                   |    2 
 a/drivers/gpu/drm/etnaviv/etnaviv_gpu.c                   |    4 
 a/drivers/hwmon/ltc2992.c                                 |    3 
 a/drivers/hwmon/mr75203.c                                 |    2 
 a/drivers/iio/adc/ad7124.c                                |    2 
 a/drivers/iio/common/hid-sensors/hid-sensor-attributes.c  |    3 
 a/drivers/iio/light/as73211.c                             |    3 
 a/drivers/infiniband/hw/irdma/hw.c                        |   16 
 a/drivers/media/cec/core/cec-core.c                       |    2 
 a/drivers/media/i2c/ov02a10.c                             |    2 
 a/drivers/media/mc/mc-devnode.c                           |    2 
 a/drivers/mmc/host/renesas_sdhi_core.c                    |    2 
 a/drivers/mtd/nand/raw/intel-nand-controller.c            |    2 
 a/drivers/net/virtio_net.c                                |    2 
 a/drivers/pci/controller/dwc/pci-dra7xx.c                 |    2 
 a/drivers/phy/st/phy-stm32-usbphyc.c                      |    2 
 a/drivers/scsi/lpfc/lpfc_sli.c                            |   10 
 a/drivers/soc/fsl/qbman/bman_portal.c                     |    2 
 a/drivers/soc/fsl/qbman/qman_portal.c                     |    2 
 a/drivers/soc/ti/k3-ringacc.c                             |    4 
 a/drivers/thermal/devfreq_cooling.c                       |    2 
 a/drivers/tty/n_tty.c                                     |    2 
 a/drivers/virt/acrn/ioreq.c                               |    3 
 a/drivers/virtio/virtio_mem.c                             |   26 
 a/fs/coredump.c                                           |   15 
 a/fs/eventpoll.c                                          |   18 
 a/fs/f2fs/segment.c                                       |    8 
 a/fs/nilfs2/sysfs.c                                       |   26 
 a/fs/nilfs2/the_nilfs.c                                   |    9 
 a/fs/ocfs2/cluster/heartbeat.c                            |    2 
 a/fs/ocfs2/dlm/dlmdomain.c                                |    4 
 a/fs/ocfs2/dlm/dlmmaster.c                                |   18 
 a/fs/ocfs2/dlm/dlmrecovery.c                              |    2 
 a/fs/ocfs2/dlm/dlmthread.c                                |    2 
 a/fs/proc/array.c                                         |   18 
 a/fs/proc/base.c                                          |    5 
 a/fs/proc/kcore.c                                         |   73 
 a/include/asm-generic/bitops.h                            |    1 
 a/include/asm-generic/bitops/find.h                       |  198 --
 a/include/asm-generic/bitops/le.h                         |   64 
 a/include/asm-generic/early_ioremap.h                     |    6 
 a/include/linux/bitmap.h                                  |   34 
 a/include/linux/bitops.h                                  |   34 
 a/include/linux/cpumask.h                                 |   46 
 a/include/linux/damon.h                                   |  290 +++
 a/include/linux/find.h                                    |  134 +
 a/include/linux/highmem-internal.h                        |   27 
 a/include/linux/memory.h                                  |   55 
 a/include/linux/memory_hotplug.h                          |   40 
 a/include/linux/mmzone.h                                  |   19 
 a/include/linux/once.h                                    |    2 
 a/include/linux/page-flags.h                              |   17 
 a/include/linux/page_ext.h                                |    2 
 a/include/linux/page_idle.h                               |    6 
 a/include/linux/pagemap.h                                 |    7 
 a/include/linux/sched/user.h                              |    3 
 a/include/linux/slub_def.h                                |    6 
 a/include/linux/threads.h                                 |    2 
 a/include/linux/units.h                                   |   10 
 a/include/linux/vmalloc.h                                 |    3 
 a/include/trace/events/damon.h                            |   43 
 a/include/trace/events/mmflags.h                          |    2 
 a/include/trace/events/page_ref.h                         |    4 
 a/init/initramfs.c                                        |    2 
 a/init/main.c                                             |    3 
 a/init/noinitramfs.c                                      |    2 
 a/ipc/util.c                                              |   16 
 a/kernel/acct.c                                           |    2 
 a/kernel/fork.c                                           |    2 
 a/kernel/profile.c                                        |   21 
 a/kernel/sys.c                                            |    7 
 a/kernel/time/clocksource.c                               |    4 
 a/kernel/user.c                                           |   25 
 a/lib/Kconfig                                             |    3 
 a/lib/Kconfig.debug                                       |    9 
 a/lib/dump_stack.c                                        |    3 
 a/lib/find_bit.c                                          |   21 
 a/lib/find_bit_benchmark.c                                |   21 
 a/lib/genalloc.c                                          |    2 
 a/lib/iov_iter.c                                          |    8 
 a/lib/math/Kconfig                                        |    2 
 a/lib/math/rational.c                                     |    3 
 a/lib/string.c                                            |  130 +
 a/lib/test_bitmap.c                                       |   37 
 a/lib/test_printf.c                                       |    2 
 a/lib/test_sort.c                                         |   40 
 a/lib/vsprintf.c                                          |   26 
 a/mm/Kconfig                                              |   15 
 a/mm/Makefile                                             |    4 
 a/mm/compaction.c                                         |   20 
 a/mm/damon/Kconfig                                        |   68 
 a/mm/damon/Makefile                                       |    5 
 a/mm/damon/core-test.h                                    |  253 +++
 a/mm/damon/core.c                                         |  748 ++++++++++
 a/mm/damon/dbgfs-test.h                                   |  126 +
 a/mm/damon/dbgfs.c                                        |  631 ++++++++
 a/mm/damon/vaddr-test.h                                   |  329 ++++
 a/mm/damon/vaddr.c                                        |  672 +++++++++
 a/mm/early_ioremap.c                                      |    5 
 a/mm/highmem.c                                            |    2 
 a/mm/ioremap.c                                            |   25 
 a/mm/kfence/core.c                                        |    3 
 a/mm/kfence/kfence.h                                      |    2 
 a/mm/kfence/kfence_test.c                                 |    3 
 a/mm/kfence/report.c                                      |   19 
 a/mm/kmemleak.c                                           |    2 
 a/mm/memory_hotplug.c                                     |  396 ++++-
 a/mm/memremap.c                                           |    5 
 a/mm/page_alloc.c                                         |   27 
 a/mm/page_ext.c                                           |   12 
 a/mm/page_idle.c                                          |   10 
 a/mm/page_isolation.c                                     |    7 
 a/mm/page_owner.c                                         |   14 
 a/mm/percpu.c                                             |   36 
 a/mm/rmap.c                                               |    6 
 a/mm/secretmem.c                                          |    9 
 a/mm/slab_common.c                                        |    2 
 a/mm/slub.c                                               | 1023 +++++++++-----
 a/mm/vmalloc.c                                            |   24 
 a/mm/workingset.c                                         |    2 
 a/net/ncsi/ncsi-manage.c                                  |    4 
 a/scripts/check_extable.sh                                |    2 
 a/scripts/checkpatch.pl                                   |   93 -
 a/tools/include/linux/bitmap.h                            |    4 
 a/tools/perf/bench/find-bit-bench.c                       |    2 
 a/tools/perf/builtin-c2c.c                                |    6 
 a/tools/perf/builtin-record.c                             |    2 
 a/tools/perf/tests/bitmap.c                               |    2 
 a/tools/perf/tests/mem2node.c                             |    2 
 a/tools/perf/util/affinity.c                              |    4 
 a/tools/perf/util/header.c                                |    4 
 a/tools/perf/util/metricgroup.c                           |    2 
 a/tools/perf/util/mmap.c                                  |    4 
 a/tools/testing/selftests/damon/Makefile                  |    7 
 a/tools/testing/selftests/damon/_chk_dependency.sh        |   28 
 a/tools/testing/selftests/damon/debugfs_attrs.sh          |   75 +
 a/tools/testing/selftests/kvm/dirty_log_perf_test.c       |    2 
 a/tools/testing/selftests/kvm/dirty_log_test.c            |    4 
 a/tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c |    2 
 a/tools/testing/selftests/memfd/memfd_test.c              |    2 
 b/MAINTAINERS                                             |    2 
 b/tools/include/asm-generic/bitops.h                      |    1 
 b/tools/include/linux/bitmap.h                            |    7 
 b/tools/include/linux/find.h                              |   81 +
 b/tools/lib/find_bit.c                                    |   20 
 227 files changed, 6695 insertions(+), 1875 deletions(-)

