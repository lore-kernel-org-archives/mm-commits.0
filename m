From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcontrol-drop-unnecessary-lru-locking-from-mem_cgroup_migrate.patch
 removed from -mm tree
Date: Wed, 16 Mar 2016 12:57:25 -0700
Message-ID: <56e9baa5.dl26iaMX7IBlj5Ad%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39142 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934390AbcCPT50 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2016 15:57:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hughd@google.com, mguzik@redhat.com, mhocko@suse.com, sergey.senozhatsky.work@gmail.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: drop unnecessary lru locking from mem_cgroup_migrate()
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-drop-unnecessary-lru-locking-from-mem_cgroup_migrate.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: drop unnecessary lru locking from mem_cgroup_migrate()

Migration accounting in the memory controller used to have to handle both
oldpage and newpage being on the LRU already; fuse's page cache
replacement used to pass a recycled newpage that had been uncharged but
not freed and removed from the LRU, and the memcg migration code used to
uncharge oldpage to "pass on" the existing charge to newpage.

Nowadays, pages are no longer uncharged when truncated from the page
cache, but rather only at free time, so if a LRU page is recycled in page
cache replacement it'll also still be charged.  And we bail out of the
charge transfer altogether in that case.  Tell commit_charge() that we
know newpage is not on the LRU, to avoid taking the zone->lru_lock
unnecessarily from the migration path.

But also, oldpage is no longer uncharged inside migration.  We only use
oldpage for its page->mem_cgroup and page size, so we don't care about its
LRU state anymore either.  Remove any mention from the kernel doc.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Suggested-by: Hugh Dickins <hughd@google.com>
Acked-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Mateusz Guzik <mguzik@redhat.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-drop-unnecessary-lru-locking-from-mem_cgroup_migrate mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-drop-unnecessary-lru-locking-from-mem_cgroup_migrate
+++ a/mm/memcontrol.c
@@ -5489,7 +5489,6 @@ void mem_cgroup_uncharge_list(struct lis
  * be uncharged upon free.
  *
  * Both pages must be locked, @newpage->mapping must be set up.
- * Either or both pages might be on the LRU already.
  */
 void mem_cgroup_migrate(struct page *oldpage, struct page *newpage)
 {
@@ -5524,7 +5523,7 @@ void mem_cgroup_migrate(struct page *old
 		page_counter_charge(&memcg->memsw, nr_pages);
 	css_get_many(&memcg->css, nr_pages);
 
-	commit_charge(newpage, memcg, true);
+	commit_charge(newpage, memcg, false);
 
 	local_irq_disable();
 	mem_cgroup_charge_statistics(memcg, newpage, compound, nr_pages);
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-oom_kill-dont-ignore-oom-score-on-exiting-tasks.patch
mm-scale-kswapd-watermarks-in-proportion-to-memory.patch
mm-scale-kswapd-watermarks-in-proportion-to-memory-v3.patch
mm-memcontrol-reclaim-when-shrinking-memoryhigh-below-usage.patch
mm-memcontrol-reclaim-and-oom-kill-when-shrinking-memorymax-below-usage.patch
mm-memcontrol-clarify-the-uncharge_list-loop.patch

