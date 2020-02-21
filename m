From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Thu, 20 Feb 2020 20:00:30 -0800
Message-ID: <20200220200030.9eb0c74410ac165503ef2577@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729027AbgBUEAb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 20 Feb 2020 23:00:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org


- A few y2038 fixes which missed the merge window whiole dependencies
  in NFS were being sorted out.

- A bunch of fixes.  Some minor, some not.


Subsystems affected by this patch series:


    Arnd Bergmann <arnd@arndb.de>:
      y2038: remove ktime to/from timespec/timeval conversion
      y2038: remove unused time32 interfaces
      y2038: hide timeval/timespec/itimerval/itimerspec types

    Ioanna Alifieraki <ioanna-maria.alifieraki@canonical.com>:
      Revert "ipc,sem: remove uneeded sem_undo_list lock usage in exit_sem()"

    Christian Borntraeger <borntraeger@de.ibm.com>:
      include/uapi/linux/swab.h: fix userspace breakage, use __BITS_PER_LONG for swap

    SeongJae Park <sjpark@amazon.de>:
      selftests/vm: add missed tests in run_vmtests

    Joe Perches <joe@perches.com>:
      get_maintainer: remove uses of P: for maintainer name

    Douglas Anderson <dianders@chromium.org>:
      scripts/get_maintainer.pl: deprioritize old Fixes: addresses

    Christoph Hellwig <hch@lst.de>:
      mm/swapfile.c: fix a comment in sys_swapon()

    Vasily Averin <vvs@virtuozzo.com>:
      mm/memcontrol.c: lost css_put in memcg_expand_shrinker_maps()

    Alexandru Ardelean <alexandru.ardelean@analog.com>:
      lib/string.c: update match_string() doc-strings with correct behavior

    Gavin Shan <gshan@redhat.com>:
      mm/vmscan.c: don't round up scan size for online memory cgroup

    Wei Yang <richardw.yang@linux.intel.com>:
      mm/sparsemem: pfn_to_page is not valid yet on SPARSEMEM

    Alexander Potapenko <glider@google.com>:
      lib/stackdepot.c: fix global out-of-bounds in stack_slabs

    Randy Dunlap <rdunlap@infradead.org>:
      MAINTAINERS: use tabs for SAFESETID

 MAINTAINERS                            |    8 -
 include/linux/compat.h                 |   29 ------
 include/linux/ktime.h                  |   37 -------
 include/linux/time32.h                 |  154 ---------------------------------
 include/linux/timekeeping32.h          |   32 ------
 include/linux/types.h                  |    5 -
 include/uapi/asm-generic/posix_types.h |    2 
 include/uapi/linux/swab.h              |    4 
 include/uapi/linux/time.h              |   22 ++--
 ipc/sem.c                              |    6 -
 kernel/compat.c                        |   64 -------------
 kernel/time/time.c                     |   43 ---------
 lib/stackdepot.c                       |    8 +
 lib/string.c                           |   16 +++
 mm/memcontrol.c                        |    4 
 mm/sparse.c                            |    2 
 mm/swapfile.c                          |    2 
 mm/vmscan.c                            |    9 +
 scripts/get_maintainer.pl              |   32 ------
 tools/testing/selftests/vm/run_vmtests |   33 +++++++
 20 files changed, 93 insertions(+), 419 deletions(-)
