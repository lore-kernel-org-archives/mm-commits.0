Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B885C433F5
	for <mm-commits@archiver.kernel.org>; Sat, 20 Nov 2021 00:42:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235757AbhKTApx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 Nov 2021 19:45:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:50206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235192AbhKTApx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 19 Nov 2021 19:45:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5FF66137B;
        Sat, 20 Nov 2021 00:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637368970;
        bh=3EUDTPluBp72IX8HMrvI/JADN6aekPeuYtHrCLTZTcE=;
        h=Date:From:To:Cc:Subject:From;
        b=HAHtl32gBfSU8lZewZ5edDylXNCaoudbuI7jAeHetPmjijSHYyyS960EKNB5IdRuP
         UxcdDvEHXTHCnTvZHghdFOPN+n4ZLzoSXYh+M9c3GLI+nSWHNx39GdlobIJZtSs2Em
         4qUzsX4GrpmQYrU/7tIn0NqUaxBXwraDYmRabkH8=
Date:   Fri, 19 Nov 2021 16:42:48 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-mm@kvack.org, mm-commits@vger.kernel.org
Subject: incoming
Message-Id: <20211119164248.50feee07c5d2cc6cc4addf97@linux-foundation.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

15 patches, based on a90af8f15bdc9449ee2d24e1d73fa3f7e8633f81.

Subsystems affected by this patch series:

  mm/swap
  ipc
  mm/slab-generic
  hexagon
  mm/kmemleak
  mm/hugetlb
  mm/kasan
  mm/damon
  mm/highmem
  proc

Subsystem: mm/swap

    Matthew Wilcox <willy@infradead.org>:
      mm/swap.c:put_pages_list(): reinitialise the page list

Subsystem: ipc

    Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>:
    Patch series "shm: shm_rmid_forced feature fixes":
      ipc: WARN if trying to remove ipc object which is absent
      shm: extend forced shm destroy to support objects from several IPC nses

Subsystem: mm/slab-generic

    Yunfeng Ye <yeyunfeng@huawei.com>:
      mm: emit the "free" trace report before freeing memory in kmem_cache_free()

Subsystem: hexagon

    Nathan Chancellor <nathan@kernel.org>:
    Patch series "Fixes for ARCH=hexagon allmodconfig", v2:
      hexagon: export raw I/O routines for modules
      hexagon: clean up timer-regs.h
      hexagon: ignore vmlinux.lds

Subsystem: mm/kmemleak

    Rustam Kovhaev <rkovhaev@gmail.com>:
      mm: kmemleak: slob: respect SLAB_NOLEAKTRACE flag

Subsystem: mm/hugetlb

    Bui Quang Minh <minhquangbui99@gmail.com>:
      hugetlb: fix hugetlb cgroup refcounting during mremap

    Mina Almasry <almasrymina@google.com>:
      hugetlb, userfaultfd: fix reservation restore on userfaultfd error

Subsystem: mm/kasan

    Kees Cook <keescook@chromium.org>:
      kasan: test: silence intentional read overflow warnings

Subsystem: mm/damon

    SeongJae Park <sj@kernel.org>:
    Patch series "DAMON fixes":
      mm/damon/dbgfs: use '__GFP_NOWARN' for user-specified size buffer allocation
      mm/damon/dbgfs: fix missed use of damon_dbgfs_lock

Subsystem: mm/highmem

    Ard Biesheuvel <ardb@kernel.org>:
      kmap_local: don't assume kmap PTEs are linear arrays in memory

Subsystem: proc

    David Hildenbrand <david@redhat.com>:
      proc/vmcore: fix clearing user buffer by properly using clear_user()

 arch/arm/Kconfig                      |    1 
 arch/hexagon/include/asm/timer-regs.h |   26 ----
 arch/hexagon/include/asm/timex.h      |    3 
 arch/hexagon/kernel/.gitignore        |    1 
 arch/hexagon/kernel/time.c            |   12 +-
 arch/hexagon/lib/io.c                 |    4 
 fs/proc/vmcore.c                      |   20 ++-
 include/linux/hugetlb_cgroup.h        |   12 ++
 include/linux/ipc_namespace.h         |   15 ++
 include/linux/sched/task.h            |    2 
 ipc/shm.c                             |  189 +++++++++++++++++++++++++---------
 ipc/util.c                            |    6 -
 lib/test_kasan.c                      |    2 
 mm/Kconfig                            |    3 
 mm/damon/dbgfs.c                      |   20 ++-
 mm/highmem.c                          |   32 +++--
 mm/hugetlb.c                          |   11 +
 mm/slab.c                             |    3 
 mm/slab.h                             |    2 
 mm/slob.c                             |    3 
 mm/slub.c                             |    2 
 mm/swap.c                             |    1 
 22 files changed, 254 insertions(+), 116 deletions(-)

