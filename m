From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Thu, 25 Jun 2020 20:28:07 -0700
Message-ID: <20200625202807.b630829d6fa55388148bee7d@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728259AbgFZD2K (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Jun 2020 23:28:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org

32 patches, based on 908f7d12d3ba51dfe0449b9723199b423f97ca9a.

Subsystems affected by this patch series:

  hotfixes
  mm/pagealloc
  kexec
  ocfs2
  lib
  misc
  mm/slab
  mm/slab
  mm/slub
  mm/swap
  mm/pagemap
  mm/vmalloc
  mm/memcg
  mm/gup
  mm/thp
  mm/vmscan
  x86
  mm/memory-hotplug
  MAINTAINERS

Subsystem: hotfixes

    Stafford Horne <shorne@gmail.com>:
      openrisc: fix boot oops when DEBUG_VM is enabled

    Michal Hocko <mhocko@suse.com>:
      mm: do_swap_page(): fix up the error code

Subsystem: mm/pagealloc

    Vlastimil Babka <vbabka@suse.cz>:
      mm, compaction: make capture control handling safe wrt interrupts

Subsystem: kexec

    Lianbo Jiang <lijiang@redhat.com>:
      kexec: do not verify the signature without the lockdown or mandatory signature

Subsystem: ocfs2

    Junxiao Bi <junxiao.bi@oracle.com>:
    Patch series "ocfs2: fix nfsd over ocfs2 issues", v2:
      ocfs2: avoid inode removal while nfsd is accessing it
      ocfs2: load global_inode_alloc
      ocfs2: fix panic on nfs server over ocfs2
      ocfs2: fix value of OCFS2_INVALID_SLOT

Subsystem: lib

    Randy Dunlap <rdunlap@infradead.org>:
      lib: fix test_hmm.c reference after free

Subsystem: misc

    Rikard Falkeborn <rikard.falkeborn@gmail.com>:
      linux/bits.h: fix unsigned less than zero warnings

Subsystem: mm/slab

    Waiman Long <longman@redhat.com>:
      mm, slab: fix sign conversion problem in memcg_uncharge_slab()

Subsystem: mm/slab

    Waiman Long <longman@redhat.com>:
      mm/slab: use memzero_explicit() in kzfree()

Subsystem: mm/slub

    Sebastian Andrzej Siewior <bigeasy@linutronix.de>:
      slub: cure list_slab_objects() from double fix

Subsystem: mm/swap

    Hugh Dickins <hughd@google.com>:
      mm: fix swap cache node allocation mask

Subsystem: mm/pagemap

    Arjun Roy <arjunroy@google.com>:
      mm/memory.c: properly pte_offset_map_lock/unlock in vm_insert_pages()

    Christophe Leroy <christophe.leroy@csgroup.eu>:
      mm/debug_vm_pgtable: fix build failure with powerpc 8xx

    Stephen Rothwell <sfr@canb.auug.org.au>:
      make asm-generic/cacheflush.h more standalone

    Nathan Chancellor <natechancellor@gmail.com>:
      media: omap3isp: remove cacheflush.h

Subsystem: mm/vmalloc

    Masanari Iida <standby24x7@gmail.com>:
      mm/vmalloc.c: fix a warning while make xmldocs

Subsystem: mm/memcg

    Johannes Weiner <hannes@cmpxchg.org>:
      mm: memcontrol: handle div0 crash race condition in memory.low

    Muchun Song <songmuchun@bytedance.com>:
      mm/memcontrol.c: add missed css_put()

    Chris Down <chris@chrisdown.name>:
      mm/memcontrol.c: prevent missed memory.low load tears

Subsystem: mm/gup

    Souptick Joarder <jrdr.linux@gmail.com>:
      docs: mm/gup: minor documentation update

Subsystem: mm/thp

    Yang Shi <yang.shi@linux.alibaba.com>:
      doc: THP CoW fault no longer allocate THP

Subsystem: mm/vmscan

    Johannes Weiner <hannes@cmpxchg.org>:
    Patch series "fix for "mm: balance LRU lists based on relative thrashing" patchset":
      mm: workingset: age nonresident information alongside anonymous pages

    Joonsoo Kim <iamjoonsoo.kim@lge.com>:
      mm/swap: fix for "mm: workingset: age nonresident information alongside anonymous pages"
      mm/memory: fix IO cost for anonymous page

Subsystem: x86

    Christoph Hellwig <hch@lst.de>:
    Patch series "fix a hyperv W^X violation and remove vmalloc_exec":
      x86/hyperv: allocate the hypercall page with only read and execute bits
      arm64: use PAGE_KERNEL_ROX directly in alloc_insn_page
      mm: remove vmalloc_exec

Subsystem: mm/memory-hotplug

    Ben Widawsky <ben.widawsky@intel.com>:
      mm/memory_hotplug.c: fix false softlockup during pfn range removal

Subsystem: MAINTAINERS

    Luc Van Oostenryck <luc.vanoostenryck@gmail.com>:
      MAINTAINERS: update info for sparse

 Documentation/admin-guide/cgroup-v2.rst    |    4 +-
 Documentation/admin-guide/mm/transhuge.rst |    3 -
 Documentation/core-api/pin_user_pages.rst  |    2 -
 MAINTAINERS                                |    4 +-
 arch/arm64/kernel/probes/kprobes.c         |   12 +------
 arch/openrisc/kernel/dma.c                 |    5 +++
 arch/x86/hyperv/hv_init.c                  |    4 +-
 arch/x86/include/asm/pgtable_types.h       |    2 +
 drivers/media/platform/omap3isp/isp.c      |    2 -
 drivers/media/platform/omap3isp/ispvideo.c |    1 
 fs/ocfs2/dlmglue.c                         |   17 ++++++++++
 fs/ocfs2/ocfs2.h                           |    1 
 fs/ocfs2/ocfs2_fs.h                        |    4 +-
 fs/ocfs2/suballoc.c                        |    9 +++--
 include/asm-generic/cacheflush.h           |    5 +++
 include/linux/bits.h                       |    3 +
 include/linux/mmzone.h                     |    4 +-
 include/linux/swap.h                       |    1 
 include/linux/vmalloc.h                    |    1 
 kernel/kexec_file.c                        |   36 ++++------------------
 kernel/module.c                            |    4 +-
 lib/test_hmm.c                             |    3 -
 mm/compaction.c                            |   17 ++++++++--
 mm/debug_vm_pgtable.c                      |    4 +-
 mm/memcontrol.c                            |   18 ++++++++---
 mm/memory.c                                |   33 +++++++++++++-------
 mm/memory_hotplug.c                        |   13 ++++++--
 mm/nommu.c                                 |   17 ----------
 mm/slab.h                                  |    4 +-
 mm/slab_common.c                           |    2 -
 mm/slub.c                                  |   19 ++---------
 mm/swap.c                                  |    3 -
 mm/swap_state.c                            |    4 +-
 mm/vmalloc.c                               |   21 -------------
 mm/vmscan.c                                |    3 +
 mm/workingset.c                            |   46 +++++++++++++++++------------
 36 files changed, 168 insertions(+), 163 deletions(-)
