Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ED46C07E95
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 00:59:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80756619C8
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 00:59:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbhGHBCe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Jul 2021 21:02:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:47742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230111AbhGHBCe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 7 Jul 2021 21:02:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BBEA6619A0;
        Thu,  8 Jul 2021 00:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625705992;
        bh=7Q5B9JAxwWWyI16ztb2lq9RLO2ujePF5J+leEgsSYoU=;
        h=Date:From:To:Cc:Subject:From;
        b=iDw/4TA8TH4Hu3DFJZ8VqXTeElLKwUQGbLa4sPsICJiZZYdFk9snP2NcWd+c8EnB8
         wuDnOPOu2yllytWyfoZRVewZETanuT/2EAeDugQ8zJcL1g+lCVrFhp7uQrn6cPVqG/
         GjRpxSE0aPgYKGCXcYnsUFS9fr7NehX72axFlSF4=
Date:   Wed, 7 Jul 2021 17:59:50 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-mm@kvack.org, mm-commits@vger.kernel.org
Subject: incoming
Message-Id: <20210707175950.eceddb86c6c555555d4730e2@linux-foundation.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

54 patches, based on a931dd33d370896a683236bba67c0d6f3d01144d.

Subsystems affected by this patch series:

  lib
  mm/slub
  mm/secretmem
  mm/cleanups
  mm/init
  debug
  mm/pagemap
  mm/mremap

Subsystem: lib

    Zhen Lei <thunder.leizhen@huawei.com>:
      lib/test: fix spelling mistakes
      lib: fix spelling mistakes
      lib: fix spelling mistakes in header files

Subsystem: mm/slub

    Nathan Chancellor <nathan@kernel.org>:
    Patch series "hexagon: Fix build error with CONFIG_STACKDEPOT and select CONFIG_ARCH_WANT_LD_ORPHAN_WARN":
      hexagon: handle {,SOFT}IRQENTRY_TEXT in linker script
      hexagon: use common DISCARDS macro
      hexagon: select ARCH_WANT_LD_ORPHAN_WARN

    Oliver Glitta <glittao@gmail.com>:
      mm/slub: use stackdepot to save stack trace in objects

Subsystem: mm/secretmem

    Mike Rapoport <rppt@linux.ibm.com>:
    Patch series "mm: introduce memfd_secret system call to create "secret" memory areas", v20:
      mmap: make mlock_future_check() global
      riscv/Kconfig: make direct map manipulation options depend on MMU
      set_memory: allow querying whether set_direct_map_*() is actually enabled
      mm: introduce memfd_secret system call to create "secret" memory areas
      PM: hibernate: disable when there are active secretmem users
      arch, mm: wire up memfd_secret system call where relevant
      secretmem: test: add basic selftest for memfd_secret(2)

Subsystem: mm/cleanups

    Zhen Lei <thunder.leizhen@huawei.com>:
      mm: fix spelling mistakes in header files

Subsystem: mm/init

    Kefeng Wang <wangkefeng.wang@huawei.com>:
    Patch series "init_mm: cleanup ARCH's text/data/brk setup code", v3:
      mm: add setup_initial_init_mm() helper
      arc: convert to setup_initial_init_mm()
      arm: convert to setup_initial_init_mm()
      arm64: convert to setup_initial_init_mm()
      csky: convert to setup_initial_init_mm()
      h8300: convert to setup_initial_init_mm()
      m68k: convert to setup_initial_init_mm()
      nds32: convert to setup_initial_init_mm()
      nios2: convert to setup_initial_init_mm()
      openrisc: convert to setup_initial_init_mm()
      powerpc: convert to setup_initial_init_mm()
      riscv: convert to setup_initial_init_mm()
      s390: convert to setup_initial_init_mm()
      sh: convert to setup_initial_init_mm()
      x86: convert to setup_initial_init_mm()

Subsystem: debug

    Stephen Boyd <swboyd@chromium.org>:
    Patch series "Add build ID to stacktraces", v6:
      buildid: only consider GNU notes for build ID parsing
      buildid: add API to parse build ID out of buffer
      buildid: stash away kernels build ID on init
      dump_stack: add vmlinux build ID to stack traces
      module: add printk formats to add module build ID to stacktraces
      arm64: stacktrace: use %pSb for backtrace printing
      x86/dumpstack: use %pSb/%pBb for backtrace printing
      scripts/decode_stacktrace.sh: support debuginfod
      scripts/decode_stacktrace.sh: silence stderr messages from addr2line/nm
      scripts/decode_stacktrace.sh: indicate 'auto' can be used for base path
      buildid: mark some arguments const
      buildid: fix kernel-doc notation
      kdump: use vmlinux_build_id to simplify

Subsystem: mm/pagemap

    "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>:
      mm: rename pud_page_vaddr to pud_pgtable and make it return pmd_t *
      mm: rename p4d_page_vaddr to p4d_pgtable and make it return pud_t *

Subsystem: mm/mremap

    "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>:
    Patch series "mrermap fixes", v2:
      selftest/mremap_test: update the test to handle pagesize other than 4K
      selftest/mremap_test: avoid crash with static build
      mm/mremap: convert huge PUD move to separate helper
      mm/mremap: don't enable optimized PUD move if page table levels is 2
      mm/mremap: use pmd/pud_poplulate to update page table entries
      mm/mremap: hold the rmap lock in write mode when moving page table entries.
    Patch series "Speedup mremap on ppc64", v8:
      mm/mremap: allow arch runtime override
      powerpc/book3s64/mm: update flush_tlb_range to flush page walk cache
      powerpc/mm: enable HAVE_MOVE_PMD support

 Documentation/core-api/printk-formats.rst           |   11 
 arch/alpha/include/asm/pgtable.h                    |    8 
 arch/arc/mm/init.c                                  |    5 
 arch/arm/include/asm/pgtable-3level.h               |    2 
 arch/arm/kernel/setup.c                             |    5 
 arch/arm64/include/asm/Kbuild                       |    1 
 arch/arm64/include/asm/cacheflush.h                 |    6 
 arch/arm64/include/asm/kfence.h                     |    2 
 arch/arm64/include/asm/pgtable.h                    |    8 
 arch/arm64/include/asm/set_memory.h                 |   17 +
 arch/arm64/include/uapi/asm/unistd.h                |    1 
 arch/arm64/kernel/machine_kexec.c                   |    1 
 arch/arm64/kernel/setup.c                           |    5 
 arch/arm64/kernel/stacktrace.c                      |    2 
 arch/arm64/mm/mmu.c                                 |    7 
 arch/arm64/mm/pageattr.c                            |   13 
 arch/csky/kernel/setup.c                            |    5 
 arch/h8300/kernel/setup.c                           |    5 
 arch/hexagon/Kconfig                                |    1 
 arch/hexagon/kernel/vmlinux.lds.S                   |    9 
 arch/ia64/include/asm/pgtable.h                     |    4 
 arch/m68k/include/asm/motorola_pgtable.h            |    2 
 arch/m68k/kernel/setup_mm.c                         |    5 
 arch/m68k/kernel/setup_no.c                         |    5 
 arch/mips/include/asm/pgtable-64.h                  |    8 
 arch/nds32/kernel/setup.c                           |    5 
 arch/nios2/kernel/setup.c                           |    5 
 arch/openrisc/kernel/setup.c                        |    5 
 arch/parisc/include/asm/pgtable.h                   |    4 
 arch/powerpc/include/asm/book3s/64/pgtable.h        |   11 
 arch/powerpc/include/asm/book3s/64/tlbflush-radix.h |    2 
 arch/powerpc/include/asm/nohash/64/pgtable-4k.h     |    6 
 arch/powerpc/include/asm/nohash/64/pgtable.h        |    6 
 arch/powerpc/include/asm/tlb.h                      |    6 
 arch/powerpc/kernel/setup-common.c                  |    5 
 arch/powerpc/mm/book3s64/radix_hugetlbpage.c        |    8 
 arch/powerpc/mm/book3s64/radix_pgtable.c            |    6 
 arch/powerpc/mm/book3s64/radix_tlb.c                |   44 +-
 arch/powerpc/mm/pgtable_64.c                        |    4 
 arch/powerpc/platforms/Kconfig.cputype              |    2 
 arch/riscv/Kconfig                                  |    4 
 arch/riscv/include/asm/pgtable-64.h                 |    4 
 arch/riscv/include/asm/unistd.h                     |    1 
 arch/riscv/kernel/setup.c                           |    5 
 arch/s390/kernel/setup.c                            |    5 
 arch/sh/include/asm/pgtable-3level.h                |    4 
 arch/sh/kernel/setup.c                              |    5 
 arch/sparc/include/asm/pgtable_32.h                 |    6 
 arch/sparc/include/asm/pgtable_64.h                 |   10 
 arch/um/include/asm/pgtable-3level.h                |    2 
 arch/x86/entry/syscalls/syscall_32.tbl              |    1 
 arch/x86/entry/syscalls/syscall_64.tbl              |    1 
 arch/x86/include/asm/pgtable.h                      |    8 
 arch/x86/kernel/dumpstack.c                         |    2 
 arch/x86/kernel/setup.c                             |    5 
 arch/x86/mm/init_64.c                               |    4 
 arch/x86/mm/pat/set_memory.c                        |    4 
 arch/x86/mm/pgtable.c                               |    2 
 include/asm-generic/pgtable-nop4d.h                 |    2 
 include/asm-generic/pgtable-nopmd.h                 |    2 
 include/asm-generic/pgtable-nopud.h                 |    4 
 include/linux/bootconfig.h                          |    4 
 include/linux/buildid.h                             |   10 
 include/linux/compaction.h                          |    4 
 include/linux/cpumask.h                             |    2 
 include/linux/crash_core.h                          |   12 
 include/linux/debugobjects.h                        |    2 
 include/linux/hmm.h                                 |    2 
 include/linux/hugetlb.h                             |    6 
 include/linux/kallsyms.h                            |   21 +
 include/linux/list_lru.h                            |    4 
 include/linux/lru_cache.h                           |    8 
 include/linux/mm.h                                  |    3 
 include/linux/mmu_notifier.h                        |    8 
 include/linux/module.h                              |    9 
 include/linux/nodemask.h                            |    6 
 include/linux/percpu-defs.h                         |    2 
 include/linux/percpu-refcount.h                     |    2 
 include/linux/pgtable.h                             |    4 
 include/linux/scatterlist.h                         |    2 
 include/linux/secretmem.h                           |   54 +++
 include/linux/set_memory.h                          |   12 
 include/linux/shrinker.h                            |    2 
 include/linux/syscalls.h                            |    1 
 include/linux/vmalloc.h                             |    4 
 include/uapi/asm-generic/unistd.h                   |    7 
 include/uapi/linux/magic.h                          |    1 
 init/Kconfig                                        |    1 
 init/main.c                                         |    2 
 kernel/crash_core.c                                 |   50 ---
 kernel/kallsyms.c                                   |  104 +++++--
 kernel/module.c                                     |   42 ++
 kernel/power/hibernate.c                            |    5 
 kernel/sys_ni.c                                     |    2 
 lib/Kconfig.debug                                   |   17 -
 lib/asn1_encoder.c                                  |    2 
 lib/buildid.c                                       |   80 ++++-
 lib/devres.c                                        |    2 
 lib/dump_stack.c                                    |   13 
 lib/dynamic_debug.c                                 |    2 
 lib/fonts/font_pearl_8x8.c                          |    2 
 lib/kfifo.c                                         |    2 
 lib/list_sort.c                                     |    2 
 lib/nlattr.c                                        |    4 
 lib/oid_registry.c                                  |    2 
 lib/pldmfw/pldmfw.c                                 |    2 
 lib/reed_solomon/test_rslib.c                       |    2 
 lib/refcount.c                                      |    2 
 lib/rhashtable.c                                    |    2 
 lib/sbitmap.c                                       |    2 
 lib/scatterlist.c                                   |    4 
 lib/seq_buf.c                                       |    2 
 lib/sort.c                                          |    2 
 lib/stackdepot.c                                    |    2 
 lib/test_bitops.c                                   |    2 
 lib/test_bpf.c                                      |    2 
 lib/test_kasan.c                                    |    2 
 lib/test_kmod.c                                     |    6 
 lib/test_scanf.c                                    |    2 
 lib/vsprintf.c                                      |   10 
 mm/Kconfig                                          |    4 
 mm/Makefile                                         |    1 
 mm/gup.c                                            |   12 
 mm/init-mm.c                                        |    9 
 mm/internal.h                                       |    3 
 mm/mlock.c                                          |    3 
 mm/mmap.c                                           |    5 
 mm/mremap.c                                         |  108 ++++++-
 mm/secretmem.c                                      |  254 +++++++++++++++++
 mm/slub.c                                           |   79 +++--
 scripts/checksyscalls.sh                            |    4 
 scripts/decode_stacktrace.sh                        |   89 +++++-
 tools/testing/selftests/vm/.gitignore               |    1 
 tools/testing/selftests/vm/Makefile                 |    3 
 tools/testing/selftests/vm/memfd_secret.c           |  296 ++++++++++++++++++++
 tools/testing/selftests/vm/mremap_test.c            |  116 ++++---
 tools/testing/selftests/vm/run_vmtests.sh           |   17 +
 137 files changed, 1470 insertions(+), 442 deletions(-)

