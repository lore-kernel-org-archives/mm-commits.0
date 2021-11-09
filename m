Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6164DC433EF
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:31:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D53860E97
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:31:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234623AbhKICdq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 21:33:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:49296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229999AbhKICdp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 21:33:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D6AC060E97;
        Tue,  9 Nov 2021 02:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636425060;
        bh=EWWY+wtUTybyjA80ubMOUuCiqPfzoQcgh5GDiPXLTxY=;
        h=Date:From:To:Cc:Subject:From;
        b=CfoTCzaXQQU9lsNLsyE8o4UwaBxc5GFbIjQqumGVmnTpLV0koOmYHwkd+neG2UfTY
         8dwBi+8+jWXbqLDpq2I0XpvGBq0k7+lLpyWxtm5QbmRXmBCyCoVBQ++thi0sQmXb6Q
         HgYQlS/w0BKq03D51oVBtTwwyTs23GrVMyl3iScg=
Date:   Mon, 8 Nov 2021 18:30:57 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-mm@kvack.org, mm-commits@vger.kernel.org
Subject: incoming
Message-Id: <20211108183057.809e428e841088b657a975ec@linux-foundation.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

87 patches, based on 8bb7eca972ad531c9b149c0a51ab43a417385813, plus
previously sent material.

Subsystems affected by this patch series:

  mm/pagecache
  mm/hugetlb
  procfs
  misc
  MAINTAINERS
  lib
  checkpatch
  binfmt
  kallsyms
  ramfs
  init
  codafs
  nilfs2
  hfs
  crash_dump
  signals
  seq_file
  fork
  sysvfs
  kcov
  gdb
  resource
  selftests
  ipc

Subsystem: mm/pagecache

    Johannes Weiner <hannes@cmpxchg.org>:
      vfs: keep inodes with page cache off the inode shrinker LRU

Subsystem: mm/hugetlb

    zhangyiru <zhangyiru3@huawei.com>:
      mm,hugetlb: remove mlock ulimit for SHM_HUGETLB

Subsystem: procfs

    Florian Weimer <fweimer@redhat.com>:
      procfs: do not list TID 0 in /proc/<pid>/task

    David Hildenbrand <david@redhat.com>:
      x86/xen: update xen_oldmem_pfn_is_ram() documentation
      x86/xen: simplify xen_oldmem_pfn_is_ram()
      x86/xen: print a warning when HVMOP_get_mem_type fails
      proc/vmcore: let pfn_is_ram() return a bool
      proc/vmcore: convert oldmem_pfn_is_ram callback to more generic vmcore callbacks
      virtio-mem: factor out hotplug specifics from virtio_mem_init() into virtio_mem_init_hotplug()
      virtio-mem: factor out hotplug specifics from virtio_mem_probe() into virtio_mem_init_hotplug()
      virtio-mem: factor out hotplug specifics from virtio_mem_remove() into virtio_mem_deinit_hotplug()
      virtio-mem: kdump mode to sanitize /proc/vmcore access

    Stephen Brennan <stephen.s.brennan@oracle.com>:
      proc: allow pid_revalidate() during LOOKUP_RCU

Subsystem: misc

    Andy Shevchenko <andriy.shevchenko@linux.intel.com>:
    Patch series "kernel.h further split", v5:
      kernel.h: drop unneeded <linux/kernel.h> inclusion from other headers
      kernel.h: split out container_of() and typeof_member() macros
      include/kunit/test.h: replace kernel.h with the necessary inclusions
      include/linux/list.h: replace kernel.h with the necessary inclusions
      include/linux/llist.h: replace kernel.h with the necessary inclusions
      include/linux/plist.h: replace kernel.h with the necessary inclusions
      include/media/media-entity.h: replace kernel.h with the necessary inclusions
      include/linux/delay.h: replace kernel.h with the necessary inclusions
      include/linux/sbitmap.h: replace kernel.h with the necessary inclusions
      include/linux/radix-tree.h: replace kernel.h with the necessary inclusions
      include/linux/generic-radix-tree.h: replace kernel.h with the necessary inclusions

    Stephen Rothwell <sfr@canb.auug.org.au>:
      kernel.h: split out instruction pointer accessors

    Rasmus Villemoes <linux@rasmusvillemoes.dk>:
      linux/container_of.h: switch to static_assert

    Colin Ian King <colin.i.king@googlemail.com>:
      mailmap: update email address for Colin King

Subsystem: MAINTAINERS

    Kees Cook <keescook@chromium.org>:
      MAINTAINERS: add "exec & binfmt" section with myself and Eric

    Lukas Bulwahn <lukas.bulwahn@gmail.com>:
    Patch series "Rectify file references for dt-bindings in MAINTAINERS", v5:
      MAINTAINERS: rectify entry for ARM/TOSHIBA VISCONTI ARCHITECTURE
      MAINTAINERS: rectify entry for HIKEY960 ONBOARD USB GPIO HUB DRIVER
      MAINTAINERS: rectify entry for INTEL KEEM BAY DRM DRIVER
      MAINTAINERS: rectify entry for ALLWINNER HARDWARE SPINLOCK SUPPORT

Subsystem: lib

    Imran Khan <imran.f.khan@oracle.com>:
    Patch series "lib, stackdepot: check stackdepot handle before accessing slabs", v2:
      lib, stackdepot: check stackdepot handle before accessing slabs
      lib, stackdepot: add helper to print stack entries
      lib, stackdepot: add helper to print stack entries into buffer

    Lucas De Marchi <lucas.demarchi@intel.com>:
      include/linux/string_helpers.h: add linux/string.h for strlen()

    Alexey Dobriyan <adobriyan@gmail.com>:
      lib: uninline simple_strntoull() as well

    Thomas Gleixner <tglx@linutronix.de>:
      mm/scatterlist: replace the !preemptible warning in sg_miter_stop()

Subsystem: checkpatch

    Rikard Falkeborn <rikard.falkeborn@gmail.com>:
      const_structs.checkpatch: add a few sound ops structs

    Joe Perches <joe@perches.com>:
      checkpatch: improve EXPORT_SYMBOL test for EXPORT_SYMBOL_NS uses

    Peter Ujfalusi <peter.ujfalusi@linux.intel.com>:
      checkpatch: get default codespell dictionary path from package location

Subsystem: binfmt

    Kees Cook <keescook@chromium.org>:
      binfmt_elf: reintroduce using MAP_FIXED_NOREPLACE

    Alexey Dobriyan <adobriyan@gmail.com>:
      ELF: simplify STACK_ALLOC macro

Subsystem: kallsyms

    Kefeng Wang <wangkefeng.wang@huawei.com>:
    Patch series "sections: Unify kernel sections range check and use", v4:
      kallsyms: remove arch specific text and data check
      kallsyms: fix address-checks for kernel related range
      sections: move and rename core_kernel_data() to is_kernel_core_data()
      sections: move is_kernel_inittext() into sections.h
      x86: mm: rename __is_kernel_text() to is_x86_32_kernel_text()
      sections: provide internal __is_kernel() and __is_kernel_text() helper
      mm: kasan: use is_kernel() helper
      extable: use is_kernel_text() helper
      powerpc/mm: use core_kernel_text() helper
      microblaze: use is_kernel_text() helper
      alpha: use is_kernel_text() helper

Subsystem: ramfs

    yangerkun <yangerkun@huawei.com>:
      ramfs: fix mount source show for ramfs

Subsystem: init

    Andrew Halaney <ahalaney@redhat.com>:
      init: make unknown command line param message clearer

Subsystem: codafs

    Jan Harkes <jaharkes@cs.cmu.edu>:
    Patch series "Coda updates for -next":
      coda: avoid NULL pointer dereference from a bad inode
      coda: check for async upcall request using local state

    Alex Shi <alex.shi@linux.alibaba.com>:
      coda: remove err which no one care

    Jan Harkes <jaharkes@cs.cmu.edu>:
      coda: avoid flagging NULL inodes
      coda: avoid hidden code duplication in rename
      coda: avoid doing bad things on inode type changes during revalidation

    Xiyu Yang <xiyuyang19@fudan.edu.cn>:
      coda: convert from atomic_t to refcount_t on coda_vm_ops->refcnt

    Jing Yangyang <jing.yangyang@zte.com.cn>:
      coda: use vmemdup_user to replace the open code

    Jan Harkes <jaharkes@cs.cmu.edu>:
      coda: bump module version to 7.2

Subsystem: nilfs2

    Qing Wang <wangqing@vivo.com>:
    Patch series "nilfs2 updates":
      nilfs2: replace snprintf in show functions with sysfs_emit

    Ryusuke Konishi <konishi.ryusuke@gmail.com>:
      nilfs2: remove filenames from file comments

Subsystem: hfs

    Arnd Bergmann <arnd@arndb.de>:
      hfs/hfsplus: use WARN_ON for sanity check

Subsystem: crash_dump

    Changcheng Deng <deng.changcheng@zte.com.cn>:
      crash_dump: fix boolreturn.cocci warning

    Ye Guojin <ye.guojin@zte.com.cn>:
      crash_dump: remove duplicate include in crash_dump.h

Subsystem: signals

    Ye Guojin <ye.guojin@zte.com.cn>:
      signal: remove duplicate include in signal.h

Subsystem: seq_file

    Andy Shevchenko <andriy.shevchenko@linux.intel.com>:
      seq_file: move seq_escape() to a header

    Muchun Song <songmuchun@bytedance.com>:
      seq_file: fix passing wrong private data

Subsystem: fork

    Ran Xiaokai <ran.xiaokai@zte.com.cn>:
      kernel/fork.c: unshare(): use swap() to make code cleaner

Subsystem: sysvfs

    Pavel Skripkin <paskripkin@gmail.com>:
      sysv: use BUILD_BUG_ON instead of runtime check

Subsystem: kcov

    Sebastian Andrzej Siewior <bigeasy@linutronix.de>:
    Patch series "kcov: PREEMPT_RT fixup + misc", v2:
      Documentation/kcov: include types.h in the example
      Documentation/kcov: define `ip' in the example
      kcov: allocate per-CPU memory on the relevant node
      kcov: avoid enable+disable interrupts if !in_task()
      kcov: replace local_irq_save() with a local_lock_t

Subsystem: gdb

    Douglas Anderson <dianders@chromium.org>:
      scripts/gdb: handle split debug for vmlinux

Subsystem: resource

    David Hildenbrand <david@redhat.com>:
    Patch series "virtio-mem: disallow mapping virtio-mem memory via /dev/mem", v5:
      kernel/resource: clean up and optimize iomem_is_exclusive()
      kernel/resource: disallow access to exclusive system RAM regions
      virtio-mem: disallow mapping virtio-mem memory via /dev/mem

Subsystem: selftests

    SeongJae Park <sjpark@amazon.de>:
      selftests/kselftest/runner/run_one(): allow running non-executable files

Subsystem: ipc

    Michal Clapinski <mclapinski@google.com>:
      ipc: check checkpoint_restore_ns_capable() to modify C/R proc files

    Manfred Spraul <manfred@colorfullife.com>:
      ipc/ipc_sysctl.c: remove fallback for !CONFIG_PROC_SYSCTL

 .mailmap                                             |    2 
 Documentation/dev-tools/kcov.rst                     |    5 
 MAINTAINERS                                          |   21 +
 arch/alpha/kernel/traps.c                            |    4 
 arch/microblaze/mm/pgtable.c                         |    3 
 arch/powerpc/mm/pgtable_32.c                         |    7 
 arch/riscv/lib/delay.c                               |    4 
 arch/s390/include/asm/facility.h                     |    4 
 arch/x86/kernel/aperture_64.c                        |   13 
 arch/x86/kernel/unwind_orc.c                         |    2 
 arch/x86/mm/init_32.c                                |   14 
 arch/x86/xen/mmu_hvm.c                               |   39 --
 drivers/gpu/drm/drm_dp_mst_topology.c                |    5 
 drivers/gpu/drm/drm_mm.c                             |    5 
 drivers/gpu/drm/i915/i915_vma.c                      |    5 
 drivers/gpu/drm/i915/intel_runtime_pm.c              |   20 -
 drivers/media/dvb-frontends/cxd2880/cxd2880_common.h |    1 
 drivers/virtio/Kconfig                               |    1 
 drivers/virtio/virtio_mem.c                          |  321 +++++++++++++------
 fs/binfmt_elf.c                                      |   33 +
 fs/coda/cnode.c                                      |   13 
 fs/coda/coda_linux.c                                 |   39 +-
 fs/coda/coda_linux.h                                 |    6 
 fs/coda/dir.c                                        |   20 -
 fs/coda/file.c                                       |   12 
 fs/coda/psdev.c                                      |   14 
 fs/coda/upcall.c                                     |    3 
 fs/hfs/inode.c                                       |    6 
 fs/hfsplus/inode.c                                   |   12 
 fs/hugetlbfs/inode.c                                 |   23 -
 fs/inode.c                                           |   46 +-
 fs/internal.h                                        |    1 
 fs/nilfs2/alloc.c                                    |    2 
 fs/nilfs2/alloc.h                                    |    2 
 fs/nilfs2/bmap.c                                     |    2 
 fs/nilfs2/bmap.h                                     |    2 
 fs/nilfs2/btnode.c                                   |    2 
 fs/nilfs2/btnode.h                                   |    2 
 fs/nilfs2/btree.c                                    |    2 
 fs/nilfs2/btree.h                                    |    2 
 fs/nilfs2/cpfile.c                                   |    2 
 fs/nilfs2/cpfile.h                                   |    2 
 fs/nilfs2/dat.c                                      |    2 
 fs/nilfs2/dat.h                                      |    2 
 fs/nilfs2/dir.c                                      |    2 
 fs/nilfs2/direct.c                                   |    2 
 fs/nilfs2/direct.h                                   |    2 
 fs/nilfs2/file.c                                     |    2 
 fs/nilfs2/gcinode.c                                  |    2 
 fs/nilfs2/ifile.c                                    |    2 
 fs/nilfs2/ifile.h                                    |    2 
 fs/nilfs2/inode.c                                    |    2 
 fs/nilfs2/ioctl.c                                    |    2 
 fs/nilfs2/mdt.c                                      |    2 
 fs/nilfs2/mdt.h                                      |    2 
 fs/nilfs2/namei.c                                    |    2 
 fs/nilfs2/nilfs.h                                    |    2 
 fs/nilfs2/page.c                                     |    2 
 fs/nilfs2/page.h                                     |    2 
 fs/nilfs2/recovery.c                                 |    2 
 fs/nilfs2/segbuf.c                                   |    2 
 fs/nilfs2/segbuf.h                                   |    2 
 fs/nilfs2/segment.c                                  |    2 
 fs/nilfs2/segment.h                                  |    2 
 fs/nilfs2/sufile.c                                   |    2 
 fs/nilfs2/sufile.h                                   |    2 
 fs/nilfs2/super.c                                    |    2 
 fs/nilfs2/sysfs.c                                    |   78 ++--
 fs/nilfs2/sysfs.h                                    |    2 
 fs/nilfs2/the_nilfs.c                                |    2 
 fs/nilfs2/the_nilfs.h                                |    2 
 fs/proc/base.c                                       |   21 -
 fs/proc/vmcore.c                                     |  109 ++++--
 fs/ramfs/inode.c                                     |   11 
 fs/seq_file.c                                        |   16 
 fs/sysv/super.c                                      |    6 
 include/asm-generic/sections.h                       |   75 +++-
 include/kunit/test.h                                 |   13 
 include/linux/bottom_half.h                          |    3 
 include/linux/container_of.h                         |   52 ++-
 include/linux/crash_dump.h                           |   30 +
 include/linux/delay.h                                |    2 
 include/linux/fs.h                                   |    1 
 include/linux/fwnode.h                               |    1 
 include/linux/generic-radix-tree.h                   |    3 
 include/linux/hugetlb.h                              |    6 
 include/linux/instruction_pointer.h                  |    8 
 include/linux/kallsyms.h                             |   21 -
 include/linux/kernel.h                               |   39 --
 include/linux/list.h                                 |    4 
 include/linux/llist.h                                |    4 
 include/linux/pagemap.h                              |   50 ++
 include/linux/plist.h                                |    5 
 include/linux/radix-tree.h                           |    4 
 include/linux/rwsem.h                                |    1 
 include/linux/sbitmap.h                              |   11 
 include/linux/seq_file.h                             |   19 +
 include/linux/signal.h                               |    1 
 include/linux/smp.h                                  |    1 
 include/linux/spinlock.h                             |    1 
 include/linux/stackdepot.h                           |    5 
 include/linux/string_helpers.h                       |    1 
 include/media/media-entity.h                         |    3 
 init/main.c                                          |    4 
 ipc/ipc_sysctl.c                                     |   42 +-
 ipc/shm.c                                            |    8 
 kernel/extable.c                                     |   33 -
 kernel/fork.c                                        |    9 
 kernel/kcov.c                                        |   40 +-
 kernel/locking/lockdep.c                             |    3 
 kernel/resource.c                                    |   54 ++-
 kernel/trace/ftrace.c                                |    2 
 lib/scatterlist.c                                    |   11 
 lib/stackdepot.c                                     |   46 ++
 lib/vsprintf.c                                       |    3 
 mm/Kconfig                                           |    7 
 mm/filemap.c                                         |    8 
 mm/kasan/report.c                                    |   17 -
 mm/memfd.c                                           |    4 
 mm/mmap.c                                            |    3 
 mm/page_owner.c                                      |   18 -
 mm/truncate.c                                        |   19 +
 mm/vmscan.c                                          |    7 
 mm/workingset.c                                      |   10 
 net/sysctl_net.c                                     |    2 
 scripts/checkpatch.pl                                |   33 +
 scripts/const_structs.checkpatch                     |    4 
 scripts/gdb/linux/symbols.py                         |    3 
 tools/testing/selftests/kselftest/runner.sh          |   28 +
 tools/testing/selftests/proc/.gitignore              |    1 
 tools/testing/selftests/proc/Makefile                |    2 
 tools/testing/selftests/proc/proc-tid0.c             |   81 ++++
 132 files changed, 1206 insertions(+), 681 deletions(-)

