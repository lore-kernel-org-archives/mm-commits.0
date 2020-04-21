From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Mon, 20 Apr 2020 18:13:10 -0700
Message-ID: <20200420181310.c18b3c0aa4dc5b3e5ec1be10@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726079AbgDUBNL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 20 Apr 2020 21:13:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, linux-mm@kvack.org


15 fixes, based on ae83d0b416db002fe95601e7f97f64b59514d936:


    Masahiro Yamada <masahiroy@kernel.org>:
      sh: fix build error in mm/init.c

    Kees Cook <keescook@chromium.org>:
      slub: avoid redzone when choosing freepointer location

    Peter Xu <peterx@redhat.com>:
      mm/userfaultfd: disable userfaultfd-wp on x86_32

    Bartosz Golaszewski <bgolaszewski@baylibre.com>:
      MAINTAINERS: add an entry for kfifo

    Longpeng <longpeng2@huawei.com>:
      mm/hugetlb: fix a addressing exception caused by huge_pte_offset

    Michal Hocko <mhocko@suse.com>:
      mm, gup: return EINTR when gup is interrupted by fatal signals

    Christophe JAILLET <christophe.jaillet@wanadoo.fr>:
      checkpatch: fix a typo in the regex for $allocFunctions

    George Burgess IV <gbiv@google.com>:
      tools/build: tweak unused value workaround

    Muchun Song <songmuchun@bytedance.com>:
      mm/ksm: fix NULL pointer dereference when KSM zero page is enabled

    Hugh Dickins <hughd@google.com>:
      mm/shmem: fix build without THP

    Jann Horn <jannh@google.com>:
      vmalloc: fix remap_vmalloc_range() bounds checks

    Hugh Dickins <hughd@google.com>:
      shmem: fix possible deadlocks on shmlock_user_lock

    Yang Shi <yang.shi@linux.alibaba.com>:
      mm: shmem: disable interrupt when acquiring info->lock in userfaultfd_copy path

    Sudip Mukherjee <sudipm.mukherjee@gmail.com>:
      coredump: fix null pointer dereference on coredump

    Lucas Stach <l.stach@pengutronix.de>:
      tools/vm: fix cross-compile build

 MAINTAINERS                                      |    7 +++++++
 arch/sh/mm/init.c                                |    2 +-
 arch/x86/Kconfig                                 |    2 +-
 fs/coredump.c                                    |    2 ++
 fs/proc/vmcore.c                                 |    5 +++--
 include/linux/vmalloc.h                          |    2 +-
 mm/gup.c                                         |    2 +-
 mm/hugetlb.c                                     |   14 ++++++++------
 mm/ksm.c                                         |   12 ++++++++++--
 mm/shmem.c                                       |   13 ++++++++-----
 mm/slub.c                                        |   12 ++++++++++--
 mm/vmalloc.c                                     |   16 +++++++++++++---
 samples/vfio-mdev/mdpy.c                         |    2 +-
 scripts/checkpatch.pl                            |    2 +-
 tools/build/feature/test-sync-compare-and-swap.c |    2 +-
 tools/vm/Makefile                                |    2 ++
 16 files changed, 70 insertions(+), 27 deletions(-)
