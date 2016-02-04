From: akpm@linux-foundation.org
Subject: + mm-migrate-consolidate-mem_cgroup_migrate-calls.patch added to
 -mm tree
Date: Thu, 04 Feb 2016 13:44:44 -0800
Message-ID: <56b3c64c.4sWp7o4H+XxQ+a8F%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56705 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965728AbcBDVop (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Feb 2016 16:44:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hughd@google.com, mguzik@redhat.com, mhocko@suse.cz, sergey.senozhatsky.work@gmail.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: migrate: consolidate mem_cgroup_migrate() calls
has been added to the -mm tree.  Its filename is
     mm-migrate-consolidate-mem_cgroup_migrate-calls.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-consolidate-mem_cgroup_migrate-calls.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-consolidate-mem_cgroup_migrate-calls.patch

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
Subject: mm: migrate: consolidate mem_cgroup_migrate() calls

Rather than scattering mem_cgroup_migrate() calls all over the place, have
a single call from a safe place where every migration operation eventually
ends up in - migrate_page_copy().

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Suggested-by: Hugh Dickins <hughd@google.com>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Michal Hocko <mhocko@suse.cz>
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

