From: akpm@linux-foundation.org
Subject: [merged] mm-migrate-consolidate-mem_cgroup_migrate-calls.patch
 removed from -mm tree
Date: Wed, 16 Mar 2016 12:57:22 -0700
Message-ID: <56e9baa2.p7UAUJpU1aTr3GWp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39135 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934390AbcCPT5X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2016 15:57:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hughd@google.com, mguzik@redhat.com, mhocko@suse.com, sergey.senozhatsky.work@gmail.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: migrate: consolidate mem_cgroup_migrate() calls
has been removed from the -mm tree.  Its filename was
     mm-migrate-consolidate-mem_cgroup_migrate-calls.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: migrate: consolidate mem_cgroup_migrate() calls

Rather than scattering mem_cgroup_migrate() calls all over the place, have
a single call from a safe place where every migration operation eventually
ends up in - migrate_page_copy().

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Suggested-by: Hugh Dickins <hughd@google.com>
Acked-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Mateusz Guzik <mguzik@redhat.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff -puN mm/migrate.c~mm-migrate-consolidate-mem_cgroup_migrate-calls mm/migrate.c
--- a/mm/migrate.c~mm-migrate-consolidate-mem_cgroup_migrate-calls
+++ a/mm/migrate.c
@@ -331,8 +331,6 @@ int migrate_page_move_mapping(struct add
 		if (PageSwapBacked(page))
 			SetPageSwapBacked(newpage);
 
-		mem_cgroup_migrate(page, newpage);
-
 		return MIGRATEPAGE_SUCCESS;
 	}
 
@@ -428,8 +426,6 @@ int migrate_page_move_mapping(struct add
 	}
 	local_irq_enable();
 
-	mem_cgroup_migrate(page, newpage);
-
 	return MIGRATEPAGE_SUCCESS;
 }
 
@@ -471,8 +467,6 @@ int migrate_huge_page_move_mapping(struc
 
 	spin_unlock_irq(&mapping->tree_lock);
 
-	mem_cgroup_migrate(page, newpage);
-
 	return MIGRATEPAGE_SUCCESS;
 }
 
@@ -586,6 +580,8 @@ void migrate_page_copy(struct page *newp
 		end_page_writeback(newpage);
 
 	copy_page_owner(page, newpage);
+
+	mem_cgroup_migrate(page, newpage);
 }
 
 /************************************************************
@@ -1846,7 +1842,6 @@ fail_putback:
 	}
 
 	mlock_migrate_page(new_page, page);
-	mem_cgroup_migrate(page, new_page);
 	page_remove_rmap(page, true);
 	set_page_owner_migrate_reason(new_page, MR_NUMA_MISPLACED);
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-oom_kill-dont-ignore-oom-score-on-exiting-tasks.patch
mm-scale-kswapd-watermarks-in-proportion-to-memory.patch
mm-scale-kswapd-watermarks-in-proportion-to-memory-v3.patch
mm-memcontrol-reclaim-when-shrinking-memoryhigh-below-usage.patch
mm-memcontrol-reclaim-and-oom-kill-when-shrinking-memorymax-below-usage.patch
mm-memcontrol-clarify-the-uncharge_list-loop.patch

