From: akpm@linux-foundation.org
Subject: +
 memcg-put-soft-limit-reclaim-out-of-way-if-the-excess-tree-is-empty.patch
 added to -mm tree
Date: Mon, 01 Aug 2016 12:49:22 -0700
Message-ID: <579fa7c2.EtLTjjg7IdF//zfr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37915 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754877AbcHATu4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Aug 2016 15:50:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, hannes@cmpxchg.org, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: put soft limit reclaim out of way if the excess tree is empty
has been added to the -mm tree.  Its filename is
     memcg-put-soft-limit-reclaim-out-of-way-if-the-excess-tree-is-empty.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-put-soft-limit-reclaim-out-of-way-if-the-excess-tree-is-empty.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-put-soft-limit-reclaim-out-of-way-if-the-excess-tree-is-empty.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: memcg: put soft limit reclaim out of way if the excess tree is empty

We've had a report about soft lockups caused by lock bouncing in the soft
reclaim path:

[331404.849734] BUG: soft lockup - CPU#0 stuck for 22s! [kav4proxy-kavic:3128]
[331404.849920] RIP: 0010:[<ffffffff81469798>]  [<ffffffff81469798>] _raw_spin_lock+0x18/0x20
[331404.849997] Call Trace:
[331404.850010]  [<ffffffff811557ea>] mem_cgroup_soft_limit_reclaim+0x25a/0x280
[331404.850020]  [<ffffffff8111041d>] shrink_zones+0xed/0x200
[331404.850027]  [<ffffffff81111a94>] do_try_to_free_pages+0x74/0x320
[331404.850034]  [<ffffffff81112072>] try_to_free_pages+0x112/0x180
[331404.850042]  [<ffffffff81104a6f>] __alloc_pages_slowpath+0x3ff/0x820
[331404.850049]  [<ffffffff81105079>] __alloc_pages_nodemask+0x1e9/0x200
[331404.850056]  [<ffffffff81141e01>] alloc_pages_vma+0xe1/0x290
[331404.850064]  [<ffffffff8112402f>] do_wp_page+0x19f/0x840
[331404.850071]  [<ffffffff811257cd>] handle_pte_fault+0x1cd/0x230
[331404.850079]  [<ffffffff8146d3ed>] do_page_fault+0x1fd/0x4c0
[331404.850087]  [<ffffffff81469ec5>] page_fault+0x25/0x30

There are no memcgs created so there cannot be any in the soft limit
excess obviously:
[...]
memory  0       1       1

so all this just seems to be mem_cgroup_largest_soft_limit_node trying to
get spin_lock_irq(&mctz->lock) just to find out that the soft limit excess
tree is empty.  This is just pointless wasting of cycles and cache line
bouncing during heavy parallel reclaim on large machines.  The particular
machine wasn't very healthy and most probably suffering from a memory leak
which just caused the memory reclaim to trash heavily.  But bouncing on
the lock certainly didn't help...

Fix this by optimistic lockless check and bail out early if the tree is
empty.  This is theoretically racy but that shouldn't matter all that
much.  First of all soft limit is a best effort feature and it is slowly
getting deprecated and its usage should be really scarce.  Bouncing on a
lock without a good reason is surely much bigger problem, especially on
large CPU machines.

Link: http://lkml.kernel.org/r/1470073277-1056-1-git-send-email-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN mm/memcontrol.c~memcg-put-soft-limit-reclaim-out-of-way-if-the-excess-tree-is-empty mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-put-soft-limit-reclaim-out-of-way-if-the-excess-tree-is-empty
+++ a/mm/memcontrol.c
@@ -2559,6 +2559,15 @@ unsigned long mem_cgroup_soft_limit_recl
 		return 0;
 
 	mctz = soft_limit_tree_node(pgdat->node_id);
+
+	/*
+	 * Do not even bother to check the largest node if the root
+	 * is empty. Do it lockless to prevent lock bouncing. Races
+	 * are acceptable as soft limit is best effort anyway.
+	 */
+	if (RB_EMPTY_ROOT(&mctz->rb_root))
+		return 0;
+
 	/*
 	 * This loop can run a while, specially if mem_cgroup's continuously
 	 * keep exceeding their soft limit and putting the system under
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-hugetlb-fix-huge_pte_alloc-bug_on.patch
memcg-put-soft-limit-reclaim-out-of-way-if-the-excess-tree-is-empty.patch

