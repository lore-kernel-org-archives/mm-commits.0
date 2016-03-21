From: akpm@linux-foundation.org
Subject: [merged]
 mm-workingset-size-shadow-nodes-lru-basing-on-file-cache-size.patch removed from -mm tree
Date: Mon, 21 Mar 2016 11:38:57 -0700
Message-ID: <56f03fc1.M5w8/4Cp/wWuriq/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53460 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932322AbcCUT4T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 15:56:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: workingset: size shadow nodes lru basing on file cache size
has been removed from the -mm tree.  Its filename was
     mm-workingset-size-shadow-nodes-lru-basing-on-file-cache-size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: mm: workingset: size shadow nodes lru basing on file cache size

A page is activated on refault if the refault distance stored in the
corresponding shadow entry is less than the number of active file pages. 
Since active file pages can't occupy more than half memory, we assume that
the maximal effective refault distance can't be greater than half the
number of present pages and size the shadow nodes lru list appropriately. 
Generally speaking, this assumption is correct, but it can result in
wasting a considerable chunk of memory on stale shadow nodes in case the
portion of file pages is small, e.g.  if a workload mostly uses anonymous
memory.

To sort this out, we need to compute the size of shadow nodes lru basing
not on the maximal possible, but the current size of file cache.  We could
take the size of active file lru for the maximal refault distance, but
active lru is pretty unstable - it can shrink dramatically at runtime
possibly disrupting workingset detection logic.

Instead we assume that the maximal refault distance equals half the total
number of file cache pages.  This will protect us against active file lru
size fluctuations while still being correct, because size of active lru is
normally maintained lower than size of inactive lru.

Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/workingset.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/workingset.c~mm-workingset-size-shadow-nodes-lru-basing-on-file-cache-size mm/workingset.c
--- a/mm/workingset.c~mm-workingset-size-shadow-nodes-lru-basing-on-file-cache-size
+++ a/mm/workingset.c
@@ -349,7 +349,9 @@ static unsigned long count_shadow_nodes(
 	shadow_nodes = list_lru_shrink_count(&workingset_shadow_nodes, sc);
 	local_irq_enable();
 
-	pages = node_present_pages(sc->nid);
+	pages = node_page_state(sc->nid, NR_ACTIVE_FILE) +
+		node_page_state(sc->nid, NR_INACTIVE_FILE);
+
 	/*
 	 * Active cache pages are limited to 50% of memory, and shadow
 	 * entries that represent a refault distance bigger than that
_

Patches currently in -mm which might be from vdavydov@virtuozzo.com are

mm-oom_reaper-implement-oom-victims-queuing-fix.patch

