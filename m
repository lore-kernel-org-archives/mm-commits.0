Return-Path: <SRS0=Fe7N=DY=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01BBDC433DF
	for <mm-commits@archiver.kernel.org>; Sat, 17 Oct 2020 23:13:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A362020897
	for <mm-commits@archiver.kernel.org>; Sat, 17 Oct 2020 23:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602976396;
	bh=GtXLHrnT5bD13G8yWuZcMnrNeOrAahJFCssV0NKCVhk=;
	h=Date:From:To:Cc:Subject:Reply-To:List-ID:From;
	b=kX4Uuqrtd8Xdr1Ko0JWgcn3xSNGg18LBqYsNqVZWAst6dU5eOUKoPq6hzKrXaZRLt
	 HWYJguVFUs8DMTvHQc7ii3BEfTrudsOnfAEZL9rbDFbVO7zTppxyYvK+pzGSV1bZUG
	 xurfOcG5HtyXWkyJZ9PpOLbIRlULueC9dmU03eS8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439877AbgJQXNQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 17 Oct 2020 19:13:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:47054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439873AbgJQXNQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 17 Oct 2020 19:13:16 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BCC7320878;
        Sat, 17 Oct 2020 23:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602976394;
        bh=GtXLHrnT5bD13G8yWuZcMnrNeOrAahJFCssV0NKCVhk=;
        h=Date:From:To:Cc:Subject:From;
        b=NGpKpk/xFPl+BNmNipQnB8w6sLkLYHrzT4OsGgFrOLZEVmTs2GkE39KdpzCGKLpXX
         WilUWQQjV2JJkJvkFWU8+uGyY5YXI3tU2cNlo9WgDxSh+hfevWjnYNtz722N1084LW
         qyyV8jHFXNLwLyj8gdUvYk0Y2CLTBdpkv7NACz4Q=
Date:   Sat, 17 Oct 2020 16:13:14 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, linux-mm@kvack.org
Subject: incoming
Message-Id: <20201017161314.88890b87fae7446ccc13c902@linux-foundation.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


40 patches, based on 9d9af1007bc08971953ae915d88dc9bb21344b53.

Subsystems affected by this patch series:

  ia64
  mm/memcg
  mm/migration
  mm/pagemap
  mm/gup
  mm/madvise
  mm/vmalloc
  misc

Subsystem: ia64

    Krzysztof Kozlowski <krzk@kernel.org>:
      ia64: fix build error with !COREDUMP

Subsystem: mm/memcg

    Roman Gushchin <guro@fb.com>:
      mm, memcg: rework remote charging API to support nesting
    Patch series "mm: kmem: kernel memory accounting in an interrupt context":
      mm: kmem: move memcg_kmem_bypass() calls to get_mem/obj_cgroup_from_current()
      mm: kmem: remove redundant checks from get_obj_cgroup_from_current()
      mm: kmem: prepare remote memcg charging infra for interrupt contexts
      mm: kmem: enable kernel memcg accounting from interrupt contexts

Subsystem: mm/migration

    Joonsoo Kim <iamjoonsoo.kim@lge.com>:
      mm/memory-failure: remove a wrapper for alloc_migration_target()
      mm/memory_hotplug: remove a wrapper for alloc_migration_target()

    Miaohe Lin <linmiaohe@huawei.com>:
      mm/migrate: avoid possible unnecessary process right check in kernel_move_pages()

Subsystem: mm/pagemap

    "Liam R. Howlett" <Liam.Howlett@Oracle.com>:
      mm/mmap: add inline vma_next() for readability of mmap code
      mm/mmap: add inline munmap_vma_range() for code readability

Subsystem: mm/gup

    Jann Horn <jannh@google.com>:
      mm/gup_benchmark: take the mmap lock around GUP
      binfmt_elf: take the mmap lock around find_extend_vma()
      mm/gup: assert that the mmap lock is held in __get_user_pages()

    John Hubbard <jhubbard@nvidia.com>:
    Patch series "selftests/vm: gup_test, hmm-tests, assorted improvements", v2:
      mm/gup_benchmark: rename to mm/gup_test
      selftests/vm: use a common gup_test.h
      selftests/vm: rename run_vmtests --> run_vmtests.sh
      selftests/vm: minor cleanup: Makefile and gup_test.c
      selftests/vm: only some gup_test items are really benchmarks
      selftests/vm: gup_test: introduce the dump_pages() sub-test
      selftests/vm: run_vmtests.sh: update and clean up gup_test invocation
      selftests/vm: hmm-tests: remove the libhugetlbfs dependency
      selftests/vm: 10x speedup for hmm-tests

Subsystem: mm/madvise

    Minchan Kim <minchan@kernel.org>:
    Patch series "introduce memory hinting API for external process", v9:
      mm/madvise: pass mm to do_madvise
      pid: move pidfd_get_pid() to pid.c
      mm/madvise: introduce process_madvise() syscall: an external memory hinting API

Subsystem: mm/vmalloc

    "Matthew Wilcox (Oracle)" <willy@infradead.org>:
    Patch series "remove alloc_vm_area", v4:
      mm: update the documentation for vfree

    Christoph Hellwig <hch@lst.de>:
      mm: add a VM_MAP_PUT_PAGES flag for vmap
      mm: add a vmap_pfn function
      mm: allow a NULL fn callback in apply_to_page_range
      zsmalloc: switch from alloc_vm_area to get_vm_area
      drm/i915: use vmap in shmem_pin_map
      drm/i915: stop using kmap in i915_gem_object_map
      drm/i915: use vmap in i915_gem_object_map
      xen/xenbus: use apply_to_page_range directly in xenbus_map_ring_pv
      x86/xen: open code alloc_vm_area in arch_gnttab_valloc
      mm: remove alloc_vm_area
    Patch series "two small vmalloc cleanups":
      mm: cleanup the gfp_mask handling in __vmalloc_area_node
      mm: remove the filename in the top of file comment in vmalloc.c

Subsystem: misc

    Tian Tao <tiantao6@hisilicon.com>:
      mm: remove duplicate include statement in mmu.c

 Documentation/core-api/pin_user_pages.rst   |    8 
 arch/alpha/kernel/syscalls/syscall.tbl      |    1 
 arch/arm/mm/mmu.c                           |    1 
 arch/arm/tools/syscall.tbl                  |    1 
 arch/arm64/include/asm/unistd.h             |    2 
 arch/arm64/include/asm/unistd32.h           |    2 
 arch/ia64/kernel/Makefile                   |    2 
 arch/ia64/kernel/syscalls/syscall.tbl       |    1 
 arch/m68k/kernel/syscalls/syscall.tbl       |    1 
 arch/microblaze/kernel/syscalls/syscall.tbl |    1 
 arch/mips/kernel/syscalls/syscall_n32.tbl   |    1 
 arch/mips/kernel/syscalls/syscall_n64.tbl   |    1 
 arch/mips/kernel/syscalls/syscall_o32.tbl   |    1 
 arch/parisc/kernel/syscalls/syscall.tbl     |    1 
 arch/powerpc/kernel/syscalls/syscall.tbl    |    1 
 arch/s390/configs/debug_defconfig           |    2 
 arch/s390/configs/defconfig                 |    2 
 arch/s390/kernel/syscalls/syscall.tbl       |    1 
 arch/sh/kernel/syscalls/syscall.tbl         |    1 
 arch/sparc/kernel/syscalls/syscall.tbl      |    1 
 arch/x86/entry/syscalls/syscall_32.tbl      |    1 
 arch/x86/entry/syscalls/syscall_64.tbl      |    1 
 arch/x86/xen/grant-table.c                  |   27 +-
 arch/xtensa/kernel/syscalls/syscall.tbl     |    1 
 drivers/gpu/drm/i915/Kconfig                |    1 
 drivers/gpu/drm/i915/gem/i915_gem_pages.c   |  136 ++++------
 drivers/gpu/drm/i915/gt/shmem_utils.c       |   78 +-----
 drivers/xen/xenbus/xenbus_client.c          |   30 +-
 fs/binfmt_elf.c                             |    3 
 fs/buffer.c                                 |    6 
 fs/io_uring.c                               |    2 
 fs/notify/fanotify/fanotify.c               |    5 
 fs/notify/inotify/inotify_fsnotify.c        |    5 
 include/linux/memcontrol.h                  |   12 
 include/linux/mm.h                          |    2 
 include/linux/pid.h                         |    1 
 include/linux/sched/mm.h                    |   43 +--
 include/linux/syscalls.h                    |    2 
 include/linux/vmalloc.h                     |    7 
 include/uapi/asm-generic/unistd.h           |    4 
 kernel/exit.c                               |   19 -
 kernel/pid.c                                |   19 +
 kernel/sys_ni.c                             |    1 
 mm/Kconfig                                  |   24 +
 mm/Makefile                                 |    2 
 mm/gup.c                                    |    2 
 mm/gup_benchmark.c                          |  225 ------------------
 mm/gup_test.c                               |  295 +++++++++++++++++++++--
 mm/gup_test.h                               |   40 ++-
 mm/madvise.c                                |  125 ++++++++--
 mm/memcontrol.c                             |   83 ++++--
 mm/memory-failure.c                         |   18 -
 mm/memory.c                                 |   16 -
 mm/memory_hotplug.c                         |   46 +--
 mm/migrate.c                                |   71 +++--
 mm/mmap.c                                   |   74 ++++-
 mm/nommu.c                                  |    7 
 mm/percpu.c                                 |    3 
 mm/slab.h                                   |    3 
 mm/vmalloc.c                                |  147 +++++------
 mm/zsmalloc.c                               |   10 
 tools/testing/selftests/vm/.gitignore       |    3 
 tools/testing/selftests/vm/Makefile         |   40 ++-
 tools/testing/selftests/vm/check_config.sh  |   31 ++
 tools/testing/selftests/vm/config           |    2 
 tools/testing/selftests/vm/gup_benchmark.c  |  143 -----------
 tools/testing/selftests/vm/gup_test.c       |  260 ++++++++++++++++++--
 tools/testing/selftests/vm/hmm-tests.c      |   12 
 tools/testing/selftests/vm/run_vmtests      |  334 --------------------------
 tools/testing/selftests/vm/run_vmtests.sh   |  350 +++++++++++++++++++++++++++-
 70 files changed, 1580 insertions(+), 1224 deletions(-)

