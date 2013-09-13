From: akpm@linux-foundation.org
Subject: [merged] memcg-add-per-cgroup-writeback-pages-accounting.patch
 removed from -mm tree
Date: Fri, 13 Sep 2013 13:02:46 -0700
Message-ID: <52336f66.+oY0SiEBssvEpTvu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38023 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755241Ab3IMUCr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Sep 2013 16:02:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, gthelen@google.com, fengguang.wu@intel.com, handai.szj@taobao.com

Subject: [merged] memcg-add-per-cgroup-writeback-pages-accounting.patch removed from -mm tree
To: handai.szj@taobao.com,fengguang.wu@intel.com,gthelen@google.com,hannes@cmpxchg.org,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 13 Sep 2013 13:02:46 -0700


The patch titled
     Subject: memcg: add per cgroup writeback pages accounting
has been removed from the -mm tree.  Its filename was
     memcg-add-per-cgroup-writeback-pages-accounting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sha Zhengju <handai.szj@taobao.com>
Subject: memcg: add per cgroup writeback pages accounting

Add memcg routines to count writeback pages, later dirty pages will also
be accounted.

After Kame's commit 89c06bd5 ("memcg: use new logic for page stat
accounting"), we can use 'struct page' flag to test page state instead of
per page_cgroup flag.  But memcg has a feature to move a page from a
cgroup to another one and may have race between "move" and "page stat
accounting".  So in order to avoid the race we have designed a new lock:

         mem_cgroup_begin_update_page_stat()
         modify page information        -->(a)
         mem_cgroup_update_page_stat()  -->(b)
         mem_cgroup_end_update_page_stat()

It requires both (a) and (b)(writeback pages accounting) to be pretected
in mem_cgroup_{begin/end}_update_page_stat().  It's full no-op for
!CONFIG_MEMCG, almost no-op if memcg is disabled (but compiled in), rcu
read lock in the most cases (no task is moving), and spin_lock_irqsave on
top in the slow path.

There're two writeback interfaces to modify: test_{clear/set}_page_writeback().
And the lock order is:
	--> memcg->move_lock
	  --> mapping->tree_lock

Signed-off-by: Sha Zhengju <handai.szj@taobao.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Reviewed-by: Greg Thelen <gthelen@google.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    1 +
 mm/memcontrol.c            |   30 +++++++++++++++++++++++-------
 mm/page-writeback.c        |   15 +++++++++++++++
 3 files changed, 39 insertions(+), 7 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-add-per-cgroup-writeback-pages-accounting include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-add-per-cgroup-writeback-pages-accounting
+++ a/include/linux/memcontrol.h
@@ -42,6 +42,7 @@ enum mem_cgroup_stat_index {
 	MEM_CGROUP_STAT_RSS,		/* # of pages charged as anon rss */
 	MEM_CGROUP_STAT_RSS_HUGE,	/* # of pages charged as anon huge */
 	MEM_CGROUP_STAT_FILE_MAPPED,	/* # of pages charged as file rss */
+	MEM_CGROUP_STAT_WRITEBACK,	/* # of pages under writeback */
 	MEM_CGROUP_STAT_SWAP,		/* # of pages, swapped out */
 	MEM_CGROUP_STAT_NSTATS,
 };
diff -puN mm/memcontrol.c~memcg-add-per-cgroup-writeback-pages-accounting mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-add-per-cgroup-writeback-pages-accounting
+++ a/mm/memcontrol.c
@@ -89,6 +89,7 @@ static const char * const mem_cgroup_sta
 	"rss",
 	"rss_huge",
 	"mapped_file",
+	"writeback",
 	"swap",
 };
 
@@ -3654,6 +3655,20 @@ void mem_cgroup_split_huge_fixup(struct
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
+static inline
+void mem_cgroup_move_account_page_stat(struct mem_cgroup *from,
+					struct mem_cgroup *to,
+					unsigned int nr_pages,
+					enum mem_cgroup_stat_index idx)
+{
+	/* Update stat data for mem_cgroup */
+	preempt_disable();
+	WARN_ON_ONCE(from->stat->count[idx] < nr_pages);
+	__this_cpu_add(from->stat->count[idx], -nr_pages);
+	__this_cpu_add(to->stat->count[idx], nr_pages);
+	preempt_enable();
+}
+
 /**
  * mem_cgroup_move_account - move account of the page
  * @page: the page
@@ -3699,13 +3714,14 @@ static int mem_cgroup_move_account(struc
 
 	move_lock_mem_cgroup(from, &flags);
 
-	if (!anon && page_mapped(page)) {
-		/* Update mapped_file data for mem_cgroup */
-		preempt_disable();
-		__this_cpu_dec(from->stat->count[MEM_CGROUP_STAT_FILE_MAPPED]);
-		__this_cpu_inc(to->stat->count[MEM_CGROUP_STAT_FILE_MAPPED]);
-		preempt_enable();
-	}
+	if (!anon && page_mapped(page))
+		mem_cgroup_move_account_page_stat(from, to, nr_pages,
+			MEM_CGROUP_STAT_FILE_MAPPED);
+
+	if (PageWriteback(page))
+		mem_cgroup_move_account_page_stat(from, to, nr_pages,
+			MEM_CGROUP_STAT_WRITEBACK);
+
 	mem_cgroup_charge_statistics(from, page, anon, -nr_pages);
 
 	/* caller should have done css_get */
diff -puN mm/page-writeback.c~memcg-add-per-cgroup-writeback-pages-accounting mm/page-writeback.c
--- a/mm/page-writeback.c~memcg-add-per-cgroup-writeback-pages-accounting
+++ a/mm/page-writeback.c
@@ -2143,11 +2143,17 @@ EXPORT_SYMBOL(account_page_dirtied);
 
 /*
  * Helper function for set_page_writeback family.
+ *
+ * The caller must hold mem_cgroup_begin/end_update_page_stat() lock
+ * while calling this function.
+ * See test_set_page_writeback for example.
+ *
  * NOTE: Unlike account_page_dirtied this does not rely on being atomic
  * wrt interrupts.
  */
 void account_page_writeback(struct page *page)
 {
+	mem_cgroup_inc_page_stat(page, MEM_CGROUP_STAT_WRITEBACK);
 	inc_zone_page_state(page, NR_WRITEBACK);
 }
 EXPORT_SYMBOL(account_page_writeback);
@@ -2364,7 +2370,10 @@ int test_clear_page_writeback(struct pag
 {
 	struct address_space *mapping = page_mapping(page);
 	int ret;
+	bool locked;
+	unsigned long memcg_flags;
 
+	mem_cgroup_begin_update_page_stat(page, &locked, &memcg_flags);
 	if (mapping) {
 		struct backing_dev_info *bdi = mapping->backing_dev_info;
 		unsigned long flags;
@@ -2385,9 +2394,11 @@ int test_clear_page_writeback(struct pag
 		ret = TestClearPageWriteback(page);
 	}
 	if (ret) {
+		mem_cgroup_dec_page_stat(page, MEM_CGROUP_STAT_WRITEBACK);
 		dec_zone_page_state(page, NR_WRITEBACK);
 		inc_zone_page_state(page, NR_WRITTEN);
 	}
+	mem_cgroup_end_update_page_stat(page, &locked, &memcg_flags);
 	return ret;
 }
 
@@ -2395,7 +2406,10 @@ int test_set_page_writeback(struct page
 {
 	struct address_space *mapping = page_mapping(page);
 	int ret;
+	bool locked;
+	unsigned long memcg_flags;
 
+	mem_cgroup_begin_update_page_stat(page, &locked, &memcg_flags);
 	if (mapping) {
 		struct backing_dev_info *bdi = mapping->backing_dev_info;
 		unsigned long flags;
@@ -2422,6 +2436,7 @@ int test_set_page_writeback(struct page
 	}
 	if (!ret)
 		account_page_writeback(page);
+	mem_cgroup_end_update_page_stat(page, &locked, &memcg_flags);
 	return ret;
 
 }
_

Patches currently in -mm which might be from handai.szj@taobao.com are

origin.patch

