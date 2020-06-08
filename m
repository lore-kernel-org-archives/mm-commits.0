From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Sun, 7 Jun 2020 21:35:52 -0700
Message-ID: <20200607213552.5139cc2d630570af627bcef8@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725945AbgFHEfy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 00:35:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, linux-mm@kvack.org


Various trees.  Mainly those parts of MM whose linux-next dependents
are now merged.  I'm still sitting on ~160 patches which await merges
from -next.


54 patches, based on 9aa900c8094dba7a60dc805ecec1e9f720744ba1.

Subsystems affected by this patch series:

  mm/proc
  ipc
  dynamic-debug
  panic
  lib
  sysctl
  mm/gup
  mm/pagemap

Subsystem: mm/proc

    SeongJae Park <sjpark@amazon.de>:
      mm/page_idle.c: skip offline pages

Subsystem: ipc

    Jules Irenge <jbi.octave@gmail.com>:
      ipc/msg: add missing annotation for freeque()

    Giuseppe Scrivano <gscrivan@redhat.com>:
      ipc/namespace.c: use a work queue to free_ipc

Subsystem: dynamic-debug

    Orson Zhai <orson.zhai@unisoc.com>:
      dynamic_debug: add an option to enable dynamic debug for modules only

Subsystem: panic

    Rafael Aquini <aquini@redhat.com>:
      kernel: add panic_on_taint

Subsystem: lib

    Manfred Spraul <manfred@colorfullife.com>:
      xarray.h: correct return code documentation for xa_store_{bh,irq}()

Subsystem: sysctl

    Vlastimil Babka <vbabka@suse.cz>:
    Patch series "support setting sysctl parameters from kernel command line", v3:
      kernel/sysctl: support setting sysctl parameters from kernel command line
      kernel/sysctl: support handling command line aliases
      kernel/hung_task convert hung_task_panic boot parameter to sysctl
      tools/testing/selftests/sysctl/sysctl.sh: support CONFIG_TEST_SYSCTL=y
      lib/test_sysctl: support testing of sysctl. boot parameter

    "Guilherme G. Piccoli" <gpiccoli@canonical.com>:
      kernel/watchdog.c: convert {soft/hard}lockup boot parameters to sysctl aliases
      kernel/hung_task.c: introduce sysctl to print all traces when a hung task is detected
      panic: add sysctl to dump all CPUs backtraces on oops event

    Rafael Aquini <aquini@redhat.com>:
      kernel/sysctl.c: ignore out-of-range taint bits introduced via kernel.tainted

Subsystem: mm/gup

    Souptick Joarder <jrdr.linux@gmail.com>:
      mm/gup.c: convert to use get_user_{page|pages}_fast_only()

    John Hubbard <jhubbard@nvidia.com>:
      mm/gup: update pin_user_pages.rst for "case 3" (mmu notifiers)
    Patch series "mm/gup: introduce pin_user_pages_locked(), use it in frame_vector.c", v2:
      mm/gup: introduce pin_user_pages_locked()
      mm/gup: frame_vector: convert get_user_pages() --> pin_user_pages()
      mm/gup: documentation fix for pin_user_pages*() APIs
    Patch series "vhost, docs: convert to pin_user_pages(), new "case 5"":
      docs: mm/gup: pin_user_pages.rst: add a "case 5"
      vhost: convert get_user_pages() --> pin_user_pages()

Subsystem: mm/pagemap

    Alexander Gordeev <agordeev@linux.ibm.com>:
      mm/mmap.c: add more sanity checks to get_unmapped_area()
      mm/mmap.c: do not allow mappings outside of allowed limits

    Christoph Hellwig <hch@lst.de>:
    Patch series "sort out the flush_icache_range mess", v2:
      arm: fix the flush_icache_range arguments in set_fiq_handler
      nds32: unexport flush_icache_page
      powerpc: unexport flush_icache_user_range
      unicore32: remove flush_cache_user_range
      asm-generic: fix the inclusion guards for cacheflush.h
      asm-generic: don't include <linux/mm.h> in cacheflush.h
      asm-generic: improve the flush_dcache_page stub
      alpha: use asm-generic/cacheflush.h
      arm64: use asm-generic/cacheflush.h
      c6x: use asm-generic/cacheflush.h
      hexagon: use asm-generic/cacheflush.h
      ia64: use asm-generic/cacheflush.h
      microblaze: use asm-generic/cacheflush.h
      m68knommu: use asm-generic/cacheflush.h
      openrisc: use asm-generic/cacheflush.h
      powerpc: use asm-generic/cacheflush.h
      riscv: use asm-generic/cacheflush.h
      arm,sparc,unicore32: remove flush_icache_user_range
      mm: rename flush_icache_user_range to flush_icache_user_page
      asm-generic: add a flush_icache_user_range stub
      sh: implement flush_icache_user_range
      xtensa: implement flush_icache_user_range
      arm: rename flush_cache_user_range to flush_icache_user_range
      m68k: implement flush_icache_user_range
      exec: only build read_code when needed
      exec: use flush_icache_user_range in read_code
      binfmt_flat: use flush_icache_user_range
      nommu: use flush_icache_user_range in brk and mmap
      module: move the set_fs hack for flush_icache_range to m68k

    Konstantin Khlebnikov <khlebnikov@yandex-team.ru>:
      doc: cgroup: update note about conditions when oom killer is invoked

 Documentation/admin-guide/cgroup-v2.rst           |   17 +-
 Documentation/admin-guide/dynamic-debug-howto.rst |    5 
 Documentation/admin-guide/kdump/kdump.rst         |    8 +
 Documentation/admin-guide/kernel-parameters.txt   |   34 +++-
 Documentation/admin-guide/sysctl/kernel.rst       |   37 ++++
 Documentation/core-api/pin_user_pages.rst         |   47 ++++--
 arch/alpha/include/asm/cacheflush.h               |   38 +----
 arch/alpha/kernel/smp.c                           |    2 
 arch/arm/include/asm/cacheflush.h                 |    7 
 arch/arm/kernel/fiq.c                             |    4 
 arch/arm/kernel/traps.c                           |    2 
 arch/arm64/include/asm/cacheflush.h               |   46 ------
 arch/c6x/include/asm/cacheflush.h                 |   19 --
 arch/hexagon/include/asm/cacheflush.h             |   19 --
 arch/ia64/include/asm/cacheflush.h                |   30 ----
 arch/m68k/include/asm/cacheflush_mm.h             |    6 
 arch/m68k/include/asm/cacheflush_no.h             |   19 --
 arch/m68k/mm/cache.c                              |   13 +
 arch/microblaze/include/asm/cacheflush.h          |   29 ---
 arch/nds32/include/asm/cacheflush.h               |    4 
 arch/nds32/mm/cacheflush.c                        |    3 
 arch/openrisc/include/asm/cacheflush.h            |   33 ----
 arch/powerpc/include/asm/cacheflush.h             |   46 +-----
 arch/powerpc/kvm/book3s_64_mmu_hv.c               |    2 
 arch/powerpc/kvm/book3s_64_mmu_radix.c            |    2 
 arch/powerpc/mm/mem.c                             |    3 
 arch/powerpc/perf/callchain_64.c                  |    4 
 arch/riscv/include/asm/cacheflush.h               |   65 --------
 arch/sh/include/asm/cacheflush.h                  |    1 
 arch/sparc/include/asm/cacheflush_32.h            |    2 
 arch/sparc/include/asm/cacheflush_64.h            |    1 
 arch/um/include/asm/tlb.h                         |    2 
 arch/unicore32/include/asm/cacheflush.h           |   11 -
 arch/x86/include/asm/cacheflush.h                 |    2 
 arch/xtensa/include/asm/cacheflush.h              |    2 
 drivers/media/platform/omap3isp/ispvideo.c        |    2 
 drivers/nvdimm/pmem.c                             |    3 
 drivers/vhost/vhost.c                             |    5 
 fs/binfmt_flat.c                                  |    2 
 fs/exec.c                                         |    5 
 fs/proc/proc_sysctl.c                             |  163 ++++++++++++++++++++--
 include/asm-generic/cacheflush.h                  |   25 +--
 include/linux/dev_printk.h                        |    6 
 include/linux/dynamic_debug.h                     |    2 
 include/linux/ipc_namespace.h                     |    2 
 include/linux/kernel.h                            |    9 +
 include/linux/mm.h                                |   12 +
 include/linux/net.h                               |    3 
 include/linux/netdevice.h                         |    6 
 include/linux/printk.h                            |    9 -
 include/linux/sched/sysctl.h                      |    7 
 include/linux/sysctl.h                            |    4 
 include/linux/xarray.h                            |    4 
 include/rdma/ib_verbs.h                           |    6 
 init/main.c                                       |    2 
 ipc/msg.c                                         |    2 
 ipc/namespace.c                                   |   24 ++-
 kernel/events/core.c                              |    4 
 kernel/events/uprobes.c                           |    2 
 kernel/hung_task.c                                |   30 ++--
 kernel/module.c                                   |    8 -
 kernel/panic.c                                    |   45 ++++++
 kernel/sysctl.c                                   |   38 ++++-
 kernel/watchdog.c                                 |   37 +---
 lib/Kconfig.debug                                 |   12 +
 lib/Makefile                                      |    2 
 lib/dynamic_debug.c                               |    9 -
 lib/test_sysctl.c                                 |   13 +
 mm/frame_vector.c                                 |    7 
 mm/gup.c                                          |   74 +++++++--
 mm/mmap.c                                         |   28 ++-
 mm/nommu.c                                        |    4 
 mm/page_alloc.c                                   |    9 -
 mm/page_idle.c                                    |    7 
 tools/testing/selftests/sysctl/sysctl.sh          |   44 +++++
 virt/kvm/kvm_main.c                               |    8 -
 76 files changed, 732 insertions(+), 517 deletions(-)
