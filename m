From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Mon, 13 Jan 2020 16:28:31 -0800
Message-ID: <20200113162831.f7d69e11e9e673c40005c9b0@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727382AbgANA2c (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 13 Jan 2020 19:28:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org


11 MM fixes, based on b3a987b0264d3ddbb24293ebff10eddfc472f653:


    Vlastimil Babka <vbabka@suse.cz>:
      mm, thp: tweak reclaim/compaction effort of local-only and all-node allocations

    David Hildenbrand <david@redhat.com>:
      mm/memory_hotplug: don't free usage map when removing a re-added early section

    "Kirill A. Shutemov" <kirill@shutemov.name>:
    Patch series "Fix two above-47bit hint address vs. THP bugs":
      mm/huge_memory.c: thp: fix conflict of above-47bit hint address and PMD alignment
      mm/shmem.c: thp, shmem: fix conflict of above-47bit hint address and PMD alignment

    Roman Gushchin <guro@fb.com>:
      mm: memcg/slab: fix percpu slab vmstats flushing

    Vlastimil Babka <vbabka@suse.cz>:
      mm, debug_pagealloc: don't rely on static keys too early

    Wen Yang <wenyang@linux.alibaba.com>:
    Patch series "use div64_ul() instead of div_u64() if the divisor is:
      mm/page-writeback.c: avoid potential division by zero in wb_min_max_ratio()
      mm/page-writeback.c: use div64_ul() for u64-by-unsigned-long divide
      mm/page-writeback.c: improve arithmetic divisions

    Adrian Huang <ahuang12@lenovo.com>:
      mm: memcg/slab: call flush_memcg_workqueue() only if memcg workqueue is valid

    Yang Shi <yang.shi@linux.alibaba.com>:
      mm: khugepaged: add trace status description for SCAN_PAGE_HAS_PRIVATE

 include/linux/mm.h                 |   18 +++++++++-
 include/linux/mmzone.h             |    5 +--
 include/trace/events/huge_memory.h |    3 +
 init/main.c                        |    1 
 mm/huge_memory.c                   |   38 ++++++++++++++---------
 mm/memcontrol.c                    |   37 +++++-----------------
 mm/mempolicy.c                     |   10 ++++--
 mm/page-writeback.c                |   10 +++---
 mm/page_alloc.c                    |   61 ++++++++++---------------------------
 mm/shmem.c                         |    7 ++--
 mm/slab.c                          |    4 +-
 mm/slab_common.c                   |    3 +
 mm/slub.c                          |    2 -
 mm/sparse.c                        |    9 ++++-
 mm/vmalloc.c                       |    4 +-
 15 files changed, 102 insertions(+), 110 deletions(-)
