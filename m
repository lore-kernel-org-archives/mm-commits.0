From: akpm@linux-foundation.org
Subject: +
 mm-memcontrol-drop-unnecessary-lru-locking-from-mem_cgroup_migrate.patch
 added to -mm tree
Date: Thu, 04 Feb 2016 13:44:46 -0800
Message-ID: <56b3c64e.TPciaJAO6p4bQNX9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56715 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965728AbcBDVor (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Feb 2016 16:44:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hughd@google.com, mguzik@redhat.com, mhocko@suse.cz, sergey.senozhatsky.work@gmail.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: drop unnecessary lru locking from mem_cgroup_migrate()
has been added to the -mm tree.  Its filename is
     mm-memcontrol-drop-unnecessary-lru-locking-from-mem_cgroup_migrate.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-drop-unnecessary-lru-locking-from-mem_cgroup_migrate.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-drop-unnecessary-lru-locking-from-mem_cgroup_migrate.patch

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
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Michal Hocko <mhocko@suse.cz>
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

mm-memcontrol-generalize-locking-for-the-page-mem_cgroup-binding.patch
mm-workingset-define-radix-entry-eviction-mask.patch
mm-workingset-separate-shadow-unpacking-and-refault-calculation.patch
mm-workingset-eviction-buckets-for-bigmem-lowbit-machines.patch
mm-workingset-per-cgroup-cache-thrash-detection.patch
mm-migrate-do-not-touch-page-mem_cgroup-of-live-pages.patch
mm-simplify-lock_page_memcg.patch
mm-remove-unnecessary-uses-of-lock_page_memcg.patch
mm-migrate-consolidate-mem_cgroup_migrate-calls.patch
mm-memcontrol-drop-unnecessary-lru-locking-from-mem_cgroup_migrate.patch

