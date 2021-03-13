Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D1D0C433E6
	for <mm-commits@archiver.kernel.org>; Sat, 13 Mar 2021 05:07:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4989C64FA8
	for <mm-commits@archiver.kernel.org>; Sat, 13 Mar 2021 05:07:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231280AbhCMFHG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 13 Mar 2021 00:07:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:41254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229852AbhCMFGd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 13 Mar 2021 00:06:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DDADF64F76;
        Sat, 13 Mar 2021 05:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615611993;
        bh=YybuBIBkSQkpByZdqaQWq5omWSm4aWCKPmfjwsKlWSY=;
        h=Date:From:To:Cc:Subject:From;
        b=sC8m1hu/VI89OhH4+A9BEkILKZ7zTwlg+GXNIRSpsTQGeg0EaGzVRZEfRT9G4uM7z
         nVlv+S9VwMQWEeqFuxcaG4zs+DWe5An1V9n4MXh9ZJCLgD4iKOr6pdu6hQNJMgz8Zr
         saIv4SQSlDOoJwkhu76IEvyhNkQ2L3E++Gfc/2S4=
Date:   Fri, 12 Mar 2021 21:06:32 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, linux-mm@kvack.org
Subject: incoming
Message-Id: <20210312210632.9b7d62973d72a56fb13c7a03@linux-foundation.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


29 patches, based on f78d76e72a4671ea52d12752d92077788b4f5d50.

Subsystems affected by this patch series:

  mm/memblock
  core-kernel
  kconfig
  mm/pagealloc
  fork
  mm/hugetlb
  mm/highmem
  binfmt
  MAINTAINERS
  kbuild
  mm/kfence
  mm/oom-kill
  mm/madvise
  mm/kasan
  mm/userfaultfd
  mm/memory-failure
  ia64
  mm/memcg
  mm/zram

Subsystem: mm/memblock

    Arnd Bergmann <arnd@arndb.de>:
      memblock: fix section mismatch warning

Subsystem: core-kernel

    Arnd Bergmann <arnd@arndb.de>:
      stop_machine: mark helpers __always_inline

Subsystem: kconfig

    Masahiro Yamada <masahiroy@kernel.org>:
      init/Kconfig: make COMPILE_TEST depend on HAS_IOMEM

Subsystem: mm/pagealloc

    Mike Rapoport <rppt@linux.ibm.com>:
      mm/page_alloc.c: refactor initialization of struct page for holes in memory layout

Subsystem: fork

    Fenghua Yu <fenghua.yu@intel.com>:
      mm/fork: clear PASID for new mm

Subsystem: mm/hugetlb

    Peter Xu <peterx@redhat.com>:
    Patch series "mm/hugetlb: Early cow on fork, and a few cleanups", v5:
      hugetlb: dedup the code to add a new file_region
      hugetlb: break earlier in add_reservation_in_range() when we can
      mm: introduce page_needs_cow_for_dma() for deciding whether cow
      mm: use is_cow_mapping() across tree where proper
      hugetlb: do early cow when page pinned on src mm

Subsystem: mm/highmem

    OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
      mm/highmem.c: fix zero_user_segments() with start > end

Subsystem: binfmt

    Lior Ribak <liorribak@gmail.com>:
      binfmt_misc: fix possible deadlock in bm_register_write

Subsystem: MAINTAINERS

    Vlastimil Babka <vbabka@suse.cz>:
      MAINTAINERS: exclude uapi directories in API/ABI section

Subsystem: kbuild

    Arnd Bergmann <arnd@arndb.de>:
      linux/compiler-clang.h: define HAVE_BUILTIN_BSWAP*

Subsystem: mm/kfence

    Marco Elver <elver@google.com>:
      kfence: fix printk format for ptrdiff_t
      kfence, slab: fix cache_alloc_debugcheck_after() for bulk allocations
      kfence: fix reports if constant function prefixes exist

Subsystem: mm/oom-kill

    "Matthew Wilcox (Oracle)" <willy@infradead.org>:
      include/linux/sched/mm.h: use rcu_dereference in in_vfork()

Subsystem: mm/madvise

    Suren Baghdasaryan <surenb@google.com>:
      mm/madvise: replace ptrace attach requirement for process_madvise

Subsystem: mm/kasan

    Andrey Konovalov <andreyknvl@google.com>:
      kasan, mm: fix crash with HW_TAGS and DEBUG_PAGEALLOC
      kasan: fix KASAN_STACK dependency for HW_TAGS

Subsystem: mm/userfaultfd

    Nadav Amit <namit@vmware.com>:
      mm/userfaultfd: fix memory corruption due to writeprotect

Subsystem: mm/memory-failure

    Naoya Horiguchi <naoya.horiguchi@nec.com>:
      mm, hwpoison: do not lock page again when me_huge_page() successfully recovers

Subsystem: ia64

    Sergei Trofimovich <slyfox@gentoo.org>:
      ia64: fix ia64_syscall_get_set_arguments() for break-based syscalls
      ia64: fix ptrace(PTRACE_SYSCALL_INFO_EXIT) sign

Subsystem: mm/memcg

    Zhou Guanghui <zhouguanghui1@huawei.com>:
      mm/memcg: rename mem_cgroup_split_huge_fixup to split_page_memcg and add nr_pages argument
      mm/memcg: set memcg when splitting page

Subsystem: mm/zram

    Minchan Kim <minchan@kernel.org>:
      zram: fix return value on writeback_store
      zram: fix broken page writeback

 MAINTAINERS                                |    4 
 arch/ia64/include/asm/syscall.h            |    2 
 arch/ia64/kernel/ptrace.c                  |   24 +++-
 drivers/block/zram/zram_drv.c              |   17 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_page_dirty.c |    4 
 drivers/gpu/drm/vmwgfx/vmwgfx_ttm_glue.c   |    2 
 fs/binfmt_misc.c                           |   29 ++---
 fs/proc/task_mmu.c                         |    2 
 include/linux/compiler-clang.h             |    6 +
 include/linux/memblock.h                   |    4 
 include/linux/memcontrol.h                 |    6 -
 include/linux/mm.h                         |   21 +++
 include/linux/mm_types.h                   |    1 
 include/linux/sched/mm.h                   |    3 
 include/linux/stop_machine.h               |   11 +
 init/Kconfig                               |    3 
 kernel/fork.c                              |    8 +
 lib/Kconfig.kasan                          |    1 
 mm/highmem.c                               |   17 ++
 mm/huge_memory.c                           |   10 -
 mm/hugetlb.c                               |  123 +++++++++++++++------
 mm/internal.h                              |    5 
 mm/kfence/report.c                         |   30 +++--
 mm/madvise.c                               |   13 ++
 mm/memcontrol.c                            |   15 +-
 mm/memory-failure.c                        |    4 
 mm/memory.c                                |   16 +-
 mm/page_alloc.c                            |  167 ++++++++++++++---------------
 mm/slab.c                                  |    2 
 29 files changed, 334 insertions(+), 216 deletions(-)

