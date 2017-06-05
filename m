From: akpm@linux-foundation.org
Subject: +
 mm-vmstat-move-slab-statistics-from-zone-to-node-counters-fix.patch added
 to -mm tree
Date: Mon, 05 Jun 2017 14:38:35 -0700
Message-ID: <5935cf5b.pxDJ2XAMB9/Epwg7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51466 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751180AbdFEVig (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jun 2017 17:38:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.com, mpe@ellerman.id.au, riel@redhat.com, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmstat: move slab statistics from zone to node counters fix
has been added to the -mm tree.  Its filename is
     mm-vmstat-move-slab-statistics-from-zone-to-node-counters-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmstat-move-slab-statistics-from-zone-to-node-counters-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmstat-move-slab-statistics-from-zone-to-node-counters-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: vmstat: move slab statistics from zone to node counters fix

Unable to handle kernel paging request at virtual address 2e116007
pgd = c0004000
[2e116007] *pgd=00000000
Internal error: Oops: 5 [#1] SMP ARM
Modules linked in:
CPU: 0 PID: 0 Comm: swapper Not tainted 4.12.0-rc3-00153-gb6bc6724488a #200
Hardware name: Generic DRA74X (Flattened Device Tree)
task: c0d0adc0 task.stack: c0d00000
PC is at __mod_node_page_state+0x2c/0xc8
LR is at __per_cpu_offset+0x0/0x8
pc : [<c0271de8>]    lr : [<c0d07da4>]    psr: 600000d3
sp : c0d01eec  ip : 00000000  fp : c15782f4
r10: 00000000  r9 : c1591280  r8 : 00004000
r7 : 00000001  r6 : 00000006  r5 : 2e116000  r4 : 00000007
r3 : 00000007  r2 : 00000001  r1 : 00000006  r0 : c0dc27c0
Flags: nZCv  IRQs off  FIQs off  Mode SVC_32  ISA ARM  Segment none
Control: 10c5387d  Table: 8000406a  DAC: 00000051
Process swapper (pid: 0, stack limit = 0xc0d00218)
Stack: (0xc0d01eec to 0xc0d02000)
1ee0:                            600000d3 c0dc27c0 c0271efc 00000001 c0d58864
1f00: ef470000 00008000 00004000 c029fbb0 01000000 c1572b5c 00002000 00000000
1f20: 00000001 00000001 00008000 c029f584 00000000 c0d58864 00008000 00008000
1f40: 01008000 c0c23790 c15782f4 a00000d3 c0d58864 c02a0364 00000000 c0819388
1f60: c0d58864 000000c0 01000000 c1572a58 c0aa57a4 00000080 00002000 c0dca000
1f80: efffe980 c0c53a48 00000000 c0c23790 c1572a58 c0c59e48 c0c59de8 c1572b5c
1fa0: c0dca000 c0c257a4 00000000 ffffffff c0dca000 c0d07940 c0dca000 c0c00a9c
1fc0: ffffffff ffffffff 00000000 c0c00680 00000000 c0c53a48 c0dca214 c0d07958
1fe0: c0c53a44 c0d0caa4 8000406a 412fc0f2 00000000 8000807c 00000000 00000000
[<c0271de8>] (__mod_node_page_state) from [<c0271efc>] (mod_node_page_state+0x2c/0x4c)
[<c0271efc>] (mod_node_page_state) from [<c029fbb0>] (cache_alloc_refill+0x5b8/0x828)
[<c029fbb0>] (cache_alloc_refill) from [<c02a0364>] (kmem_cache_alloc+0x24c/0x2d0)
[<c02a0364>] (kmem_cache_alloc) from [<c0c23790>] (create_kmalloc_cache+0x20/0x8c)
[<c0c23790>] (create_kmalloc_cache) from [<c0c257a4>] (kmem_cache_init+0xac/0x11c)
[<c0c257a4>] (kmem_cache_init) from [<c0c00a9c>] (start_kernel+0x1b8/0x3c0)
[<c0c00a9c>] (start_kernel) from [<8000807c>] (0x8000807c)
Code: e79e5103 e28c3001 e0833001 e1a04003 (e19440d5)
---[ end trace 0000000000000000 ]---

The zone counters work earlier than the node counters because the
zones have special boot pagesets, whereas the nodes do not.

Add boot nodestats against which we account until the dynamic per-cpu
allocator is available.

Link: http://lkml.kernel.org/r/20170605183511.GA8915@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/page_alloc.c~mm-vmstat-move-slab-statistics-from-zone-to-node-counters-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-vmstat-move-slab-statistics-from-zone-to-node-counters-fix
+++ a/mm/page_alloc.c
@@ -5149,6 +5149,7 @@ static void build_zonelists(pg_data_t *p
  */
 static void setup_pageset(struct per_cpu_pageset *p, unsigned long batch);
 static DEFINE_PER_CPU(struct per_cpu_pageset, boot_pageset);
+static DEFINE_PER_CPU(struct per_cpu_nodestat, boot_nodestats);
 static void setup_zone_pageset(struct zone *zone);
 
 /*
@@ -6049,6 +6050,8 @@ static void __paginginit free_area_init_
 	spin_lock_init(&pgdat->lru_lock);
 	lruvec_init(node_lruvec(pgdat));
 
+	pgdat->per_cpu_nodestats = &boot_nodestats;
+
 	for (j = 0; j < MAX_NR_ZONES; j++) {
 		struct zone *zone = pgdat->node_zones + j;
 		unsigned long size, realsize, freesize, memmap_pages;
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-vmstat-move-slab-statistics-from-zone-to-node-counters.patch
mm-vmstat-move-slab-statistics-from-zone-to-node-counters-fix.patch
mm-memcontrol-use-the-node-native-slab-memory-counters.patch
mm-memcontrol-use-generic-mod_memcg_page_state-for-kmem-pages.patch
mm-memcontrol-per-lruvec-stats-infrastructure.patch
mm-memcontrol-per-lruvec-stats-infrastructure-fix.patch
mm-memcontrol-per-lruvec-stats-infrastructure-fix-2.patch
mm-memcontrol-per-lruvec-stats-infrastructure-fix-3.patch
mm-memcontrol-account-slab-stats-per-lruvec.patch

