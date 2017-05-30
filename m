From: akpm@linux-foundation.org
Subject: + mm-memcontrol-use-the-node-native-slab-memory-counters.patch
 added to -mm tree
Date: Tue, 30 May 2017 13:53:47 -0700
Message-ID: <592ddbdb.O4Fj0r7F34JQwUym%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57140 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751118AbdE3Uxs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 30 May 2017 16:53:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, josef@toxicpanda.com, mhocko@suse.com, riel@redhat.com, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: use the node-native slab memory counters
has been added to the -mm tree.  Its filename is
     mm-memcontrol-use-the-node-native-slab-memory-counters.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-use-the-node-native-slab-memory-counters.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-use-the-node-native-slab-memory-counters.patch

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
Subject: mm: memcontrol: use the node-native slab memory counters

Now that the slab counters are moved from the zone to the node level we
can drop the private memcg node stats and use the official ones.

Link: http://lkml.kernel.org/r/20170530181724.27197-4-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    2 --
 mm/memcontrol.c            |    8 ++++----
 mm/slab.h                  |    4 ++--
 3 files changed, 6 insertions(+), 8 deletions(-)

diff -puN include/linux/memcontrol.h~mm-memcontrol-use-the-node-native-slab-memory-counters include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-memcontrol-use-the-node-native-slab-memory-counters
+++ a/include/linux/memcontrol.h
@@ -44,8 +44,6 @@ enum memcg_stat_item {
 	MEMCG_SOCK,
 	/* XXX: why are these zone and not node counters? */
 	MEMCG_KERNEL_STACK_KB,
-	MEMCG_SLAB_RECLAIMABLE,
-	MEMCG_SLAB_UNRECLAIMABLE,
 	MEMCG_NR_STAT,
 };
 
diff -puN mm/memcontrol.c~mm-memcontrol-use-the-node-native-slab-memory-counters mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-use-the-node-native-slab-memory-counters
+++ a/mm/memcontrol.c
@@ -5198,8 +5198,8 @@ static int memory_stat_show(struct seq_f
 	seq_printf(m, "kernel_stack %llu\n",
 		   (u64)stat[MEMCG_KERNEL_STACK_KB] * 1024);
 	seq_printf(m, "slab %llu\n",
-		   (u64)(stat[MEMCG_SLAB_RECLAIMABLE] +
-			 stat[MEMCG_SLAB_UNRECLAIMABLE]) * PAGE_SIZE);
+		   (u64)(stat[NR_SLAB_RECLAIMABLE] +
+			 stat[NR_SLAB_UNRECLAIMABLE]) * PAGE_SIZE);
 	seq_printf(m, "sock %llu\n",
 		   (u64)stat[MEMCG_SOCK] * PAGE_SIZE);
 
@@ -5223,9 +5223,9 @@ static int memory_stat_show(struct seq_f
 	}
 
 	seq_printf(m, "slab_reclaimable %llu\n",
-		   (u64)stat[MEMCG_SLAB_RECLAIMABLE] * PAGE_SIZE);
+		   (u64)stat[NR_SLAB_RECLAIMABLE] * PAGE_SIZE);
 	seq_printf(m, "slab_unreclaimable %llu\n",
-		   (u64)stat[MEMCG_SLAB_UNRECLAIMABLE] * PAGE_SIZE);
+		   (u64)stat[NR_SLAB_UNRECLAIMABLE] * PAGE_SIZE);
 
 	/* Accumulated memory events */
 
diff -puN mm/slab.h~mm-memcontrol-use-the-node-native-slab-memory-counters mm/slab.h
--- a/mm/slab.h~mm-memcontrol-use-the-node-native-slab-memory-counters
+++ a/mm/slab.h
@@ -287,7 +287,7 @@ static __always_inline int memcg_charge_
 
 	memcg_kmem_update_page_stat(page,
 			(s->flags & SLAB_RECLAIM_ACCOUNT) ?
-			MEMCG_SLAB_RECLAIMABLE : MEMCG_SLAB_UNRECLAIMABLE,
+			NR_SLAB_RECLAIMABLE : NR_SLAB_UNRECLAIMABLE,
 			1 << order);
 	return 0;
 }
@@ -300,7 +300,7 @@ static __always_inline void memcg_unchar
 
 	memcg_kmem_update_page_stat(page,
 			(s->flags & SLAB_RECLAIM_ACCOUNT) ?
-			MEMCG_SLAB_RECLAIMABLE : MEMCG_SLAB_UNRECLAIMABLE,
+			NR_SLAB_RECLAIMABLE : NR_SLAB_UNRECLAIMABLE,
 			-(1 << order));
 	memcg_kmem_uncharge(page, order);
 }
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-vmscan-delete-unused-pgdat_reclaimable_pages.patch
mm-vmstat-move-slab-statistics-from-zone-to-node-counters.patch
mm-memcontrol-use-the-node-native-slab-memory-counters.patch
mm-memcontrol-use-generic-mod_memcg_page_state-for-kmem-pages.patch
mm-memcontrol-per-lruvec-stats-infrastructure.patch
mm-memcontrol-account-slab-stats-per-lruvec.patch

