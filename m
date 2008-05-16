From: akpm@linux-foundation.org
Subject: + memcg-handle-swap-cache.patch added to -mm tree
Date: Thu, 15 May 2008 19:53:21 -0700
Message-ID: <200805160253.m4G2rLsj023235@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38048 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753950AbYEPCyX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 May 2008 22:54:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, ebiederm@xmission.com, hugh@veritas.com, lizf@cn.fujitsu.com, menage@google.com, rientjes@google.com, xemul@openvz.org, yamamoto@valinux.co.jp


The patch titled
     memcg: handle swap cache
has been added to the -mm tree.  Its filename is
     memcg-handle-swap-cache.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: handle swap cache
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Now swapcache is not accounted. (because it had some troubles.)

This is retrying account swap cache, based on remove-refcnt patch.

 * If a page is swap-cache,  mem_cgroup_uncharge_page() will *not*
   uncharge a page even if page->mapcount == 0.
 * If a page is removed from swap-cache, mem_cgroup_uncharge_page()
   is called.
 * A new swapcache page is not charged until when it's mapped. By this
   we can avoid complicated read-ahead troubles.

 A file, memory.stat,"rss" member is changed to "anon/swapcache".
 (rss is not precise name here...)
 When all processes in cgroup exits, rss/swapcache counter can have some
 numbers because of lazy behavior of LRU. So the word "rss" is confusing.

 I can easily imagine a user says "Oh, there may be memory leak..."
 Precise counting of swapcache will be tried in future (if necessary)

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: Paul Menage <menage@google.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    9 +++++----
 mm/migrate.c    |    3 ++-
 mm/swap_state.c |    1 +
 3 files changed, 8 insertions(+), 5 deletions(-)

diff -puN mm/memcontrol.c~memcg-handle-swap-cache mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-handle-swap-cache
+++ a/mm/memcontrol.c
@@ -44,10 +44,10 @@ static struct kmem_cache *page_cgroup_ca
  */
 enum mem_cgroup_stat_index {
 	/*
-	 * For MEM_CONTAINER_TYPE_ALL, usage = pagecache + rss.
+	 * For MEM_CONTAINER_TYPE_ALL, usage = pagecache + rss/swapcache.
 	 */
 	MEM_CGROUP_STAT_CACHE, 	   /* # of pages charged as cache */
-	MEM_CGROUP_STAT_RSS,	   /* # of pages charged as rss */
+	MEM_CGROUP_STAT_RSS,	   /* # of pages charged as anon/swapcache */
 	MEM_CGROUP_STAT_PGPGIN_COUNT,	/* # of pages paged in */
 	MEM_CGROUP_STAT_PGPGOUT_COUNT,	/* # of pages paged out */
 
@@ -697,7 +697,8 @@ __mem_cgroup_uncharge_common(struct page
 
 	if ((ctype == MEM_CGROUP_CHARGE_TYPE_MAPPED)
 	    && ((pc->flags & PAGE_CGROUP_FLAG_CACHE)
-		|| page_mapped(page)))
+		|| page_mapped(page)
+		|| PageSwapCache(page)))
 		goto unlock;
 
 	mz = page_cgroup_zoneinfo(pc);
@@ -904,7 +905,7 @@ static const struct mem_cgroup_stat_desc
 	u64 unit;
 } mem_cgroup_stat_desc[] = {
 	[MEM_CGROUP_STAT_CACHE] = { "cache", PAGE_SIZE, },
-	[MEM_CGROUP_STAT_RSS] = { "rss", PAGE_SIZE, },
+	[MEM_CGROUP_STAT_RSS] = { "anon/swapcache", PAGE_SIZE, },
 	[MEM_CGROUP_STAT_PGPGIN_COUNT] = {"pgpgin", 1, },
 	[MEM_CGROUP_STAT_PGPGOUT_COUNT] = {"pgpgout", 1, },
 };
diff -puN mm/migrate.c~memcg-handle-swap-cache mm/migrate.c
--- a/mm/migrate.c~memcg-handle-swap-cache
+++ a/mm/migrate.c
@@ -360,7 +360,8 @@ static int migrate_page_move_mapping(str
 	write_unlock_irq(&mapping->tree_lock);
 	if (!PageSwapCache(newpage)) {
 		mem_cgroup_uncharge_cache_page(page);
-	}
+	} else
+		mem_cgroup_uncharge_page(page);
 
 	return 0;
 }
diff -puN mm/swap_state.c~memcg-handle-swap-cache mm/swap_state.c
--- a/mm/swap_state.c~memcg-handle-swap-cache
+++ a/mm/swap_state.c
@@ -110,6 +110,7 @@ void __delete_from_swap_cache(struct pag
 	total_swapcache_pages--;
 	__dec_zone_page_state(page, NR_FILE_PAGES);
 	INC_CACHE_INFO(del_total);
+	mem_cgroup_uncharge_page(page);
 }
 
 /**
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
memory-hotplug-memmap_init_zone-called-twice.patch
memory_hotplug-check-for-walk_memory_resource-failure-in-online_pages.patch
memory_hotplug-always-initialize-pageblock-bitmap.patch
mark-res_counter_charge_locked-with-__must_check.patch
memcg-make-global-var-read_mostly.patch
memcg-avoid-unnecessary-initialization.patch
memcg-better-migration-handling.patch
memcg-remove-refcnt-from-page_cgroup.patch
memcg-handle-swap-cache.patch
memcg-helper-function-for-relcaim-from-shmem.patch
memcg-add-hints-for-branch.patch
memcg-remove-a-redundant-check.patch

