From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Sat, 21 Mar 2020 18:19:54 -0700
Message-ID: <20200321181954.c0564dfd5514cd742b534884@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726859AbgCVBT5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 21 Mar 2020 21:19:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org

10 fixes, based on c63c50fc2ec9afc4de21ef9ead2eac64b178cce1:


    Chunguang Xu <brookxu@tencent.com>:
      memcg: fix NULL pointer dereference in __mem_cgroup_usage_unregister_event

    Baoquan He <bhe@redhat.com>:
      mm/hotplug: fix hot remove failure in SPARSEMEM|!VMEMMAP case

    Qian Cai <cai@lca.pw>:
      page-flags: fix a crash at SetPageError(THP_SWAP)

    Chris Down <chris@chrisdown.name>:
      mm, memcg: fix corruption on 64-bit divisor in memory.high throttling
      mm, memcg: throttle allocators based on ancestral memory.high

    Michal Hocko <mhocko@suse.com>:
      mm: do not allow MADV_PAGEOUT for CoW pages

    Roman Penyaev <rpenyaev@suse.de>:
      epoll: fix possible lost wakeup on epoll_ctl() path

    Qian Cai <cai@lca.pw>:
      mm/mmu_notifier: silence PROVE_RCU_LIST warnings

    Vlastimil Babka <vbabka@suse.cz>:
      mm, slub: prevent kmalloc_node crashes and memory leaks

    Joerg Roedel <jroedel@suse.de>:
      x86/mm: split vmalloc_sync_all()

 arch/x86/mm/fault.c        |   26 ++++++++++-
 drivers/acpi/apei/ghes.c   |    2 
 fs/eventpoll.c             |    8 +--
 include/linux/page-flags.h |    2 
 include/linux/vmalloc.h    |    5 +-
 kernel/notifier.c          |    2 
 mm/madvise.c               |   12 +++--
 mm/memcontrol.c            |  105 ++++++++++++++++++++++++++++-----------------
 mm/mmu_notifier.c          |   27 +++++++----
 mm/nommu.c                 |   10 +++-
 mm/slub.c                  |   26 +++++++----
 mm/sparse.c                |    8 ++-
 mm/vmalloc.c               |   11 +++-
 13 files changed, 165 insertions(+), 79 deletions(-)
