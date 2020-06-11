From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Wed, 10 Jun 2020 18:40:53 -0700
Message-ID: <20200610184053.3fa7368ab80e23bfd44de71f@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726163AbgFKBky (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Jun 2020 21:40:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, linux-mm@kvack.org


- various hotfixes and minor things

- hch's use_mm/unuse_mm clearnups

- new syscall process_madvise(): perform madvise() on a process other
  than self

25 patches, based on 6f630784cc0d92fb58ea326e2bc01aa056279ecb.

Subsystems affected by this patch series:

  mm/hugetlb
  scripts
  kcov
  lib
  nilfs
  checkpatch
  lib
  mm/debug
  ocfs2
  lib
  misc
  mm/madvise

Subsystem: mm/hugetlb

    Dan Carpenter <dan.carpenter@oracle.com>:
      khugepaged: selftests: fix timeout condition in wait_for_scan()

Subsystem: scripts

    SeongJae Park <sjpark@amazon.de>:
      scripts/spelling: add a few more typos

Subsystem: kcov

    Andrey Konovalov <andreyknvl@google.com>:
      kcov: check kcov_softirq in kcov_remote_stop()

Subsystem: lib

    Joe Perches <joe@perches.com>:
      lib/lz4/lz4_decompress.c: document deliberate use of `&'

Subsystem: nilfs

    Ryusuke Konishi <konishi.ryusuke@gmail.com>:
      nilfs2: fix null pointer dereference at nilfs_segctor_do_construct()

Subsystem: checkpatch

    Tim Froidcoeur <tim.froidcoeur@tessares.net>:
      checkpatch: correct check for kernel parameters doc

Subsystem: lib

    Alexander Gordeev <agordeev@linux.ibm.com>:
      lib: fix bitmap_parse() on 64-bit big endian archs

Subsystem: mm/debug

    "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>:
      mm/debug_vm_pgtable: fix kernel crash by checking for THP support

Subsystem: ocfs2

    Keyur Patel <iamkeyur96@gmail.com>:
      ocfs2: fix spelling mistake and grammar

    Ben Widawsky <ben.widawsky@intel.com>:
      mm: add comments on pglist_data zones

Subsystem: lib

    Wei Yang <richard.weiyang@gmail.com>:
      lib: test get_count_order/long in test_bitops.c

Subsystem: misc

    Walter Wu <walter-zh.wu@mediatek.com>:
      stacktrace: cleanup inconsistent variable type

    Christoph Hellwig <hch@lst.de>:
    Patch series "improve use_mm / unuse_mm", v2:
      kernel: move use_mm/unuse_mm to kthread.c
      kernel: move use_mm/unuse_mm to kthread.c
      kernel: better document the use_mm/unuse_mm API contract
      kernel: set USER_DS in kthread_use_mm

Subsystem: mm/madvise

    Minchan Kim <minchan@kernel.org>:
    Patch series "introduce memory hinting API for external process", v7:
      mm/madvise: pass task and mm to do_madvise
      mm/madvise: introduce process_madvise() syscall: an external memory hinting API
      mm/madvise: check fatal signal pending of target process
      pid: move pidfd_get_pid() to pid.c
      mm/madvise: support both pid and pidfd for process_madvise

    Oleksandr Natalenko <oleksandr@redhat.com>:
      mm/madvise: allow KSM hints for remote API

    Minchan Kim <minchan@kernel.org>:
      mm: support vector address ranges for process_madvise
      mm: use only pidfd for process_madvise syscall

    YueHaibing <yuehaibing@huawei.com>:
      mm/madvise.c: remove duplicated include

 arch/alpha/kernel/syscalls/syscall.tbl              |    1 
 arch/arm/tools/syscall.tbl                          |    1 
 arch/arm64/include/asm/unistd.h                     |    2 
 arch/arm64/include/asm/unistd32.h                   |    4 
 arch/ia64/kernel/syscalls/syscall.tbl               |    1 
 arch/m68k/kernel/syscalls/syscall.tbl               |    1 
 arch/microblaze/kernel/syscalls/syscall.tbl         |    1 
 arch/mips/kernel/syscalls/syscall_n32.tbl           |    3 
 arch/mips/kernel/syscalls/syscall_n64.tbl           |    1 
 arch/mips/kernel/syscalls/syscall_o32.tbl           |    3 
 arch/parisc/kernel/syscalls/syscall.tbl             |    3 
 arch/powerpc/kernel/syscalls/syscall.tbl            |    3 
 arch/powerpc/platforms/powernv/vas-fault.c          |    4 
 arch/s390/kernel/syscalls/syscall.tbl               |    3 
 arch/sh/kernel/syscalls/syscall.tbl                 |    1 
 arch/sparc/kernel/syscalls/syscall.tbl              |    3 
 arch/x86/entry/syscalls/syscall_32.tbl              |    3 
 arch/x86/entry/syscalls/syscall_64.tbl              |    5 
 arch/xtensa/kernel/syscalls/syscall.tbl             |    1 
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h          |    5 
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_arcturus.c |    1 
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v10.c  |    1 
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v7.c   |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v8.c   |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v9.c   |    2 
 drivers/gpu/drm/i915/gvt/kvmgt.c                    |    2 
 drivers/usb/gadget/function/f_fs.c                  |   10 
 drivers/usb/gadget/legacy/inode.c                   |    6 
 drivers/vfio/vfio_iommu_type1.c                     |    6 
 drivers/vhost/vhost.c                               |    8 
 fs/aio.c                                            |    1 
 fs/io-wq.c                                          |   15 -
 fs/io_uring.c                                       |   11 
 fs/nilfs2/segment.c                                 |    2 
 fs/ocfs2/mmap.c                                     |    2 
 include/linux/compat.h                              |   10 
 include/linux/kthread.h                             |    9 
 include/linux/mm.h                                  |    3 
 include/linux/mmu_context.h                         |    5 
 include/linux/mmzone.h                              |   14 
 include/linux/pid.h                                 |    1 
 include/linux/stacktrace.h                          |    2 
 include/linux/syscalls.h                            |   16 -
 include/uapi/asm-generic/unistd.h                   |    7 
 kernel/exit.c                                       |   17 -
 kernel/kcov.c                                       |   26 +
 kernel/kthread.c                                    |   95 +++++-
 kernel/pid.c                                        |   17 +
 kernel/sys_ni.c                                     |    2 
 lib/Kconfig.debug                                   |   10 
 lib/bitmap.c                                        |    9 
 lib/lz4/lz4_decompress.c                            |    3 
 lib/test_bitops.c                                   |   53 +++
 mm/Makefile                                         |    2 
 mm/debug_vm_pgtable.c                               |    6 
 mm/madvise.c                                        |  295 ++++++++++++++------
 mm/mmu_context.c                                    |   64 ----
 mm/oom_kill.c                                       |    6 
 mm/vmacache.c                                       |    4 
 scripts/checkpatch.pl                               |    4 
 scripts/spelling.txt                                |    9 
 tools/testing/selftests/vm/khugepaged.c             |    2 
 62 files changed, 526 insertions(+), 285 deletions(-)
