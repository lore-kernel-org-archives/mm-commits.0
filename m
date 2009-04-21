From: akpm@linux-foundation.org
Subject: + memcg-add-file-based-rss-accounting.patch added to -mm tree
Date: Tue, 21 Apr 2009 13:26:01 -0700
Message-ID: <200904212026.n3LKQ1lK015067@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53768 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754787AbZDUUc1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Apr 2009 16:32:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: balbir@linux.vnet.ibm.com, dhaval@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, lizf@cn.fujitsu.cn, menage@google.com, nishimura@mxp.nes.nec.co.jp, rientjes@google.com, yamamoto@valinux.co.jp


The patch titled
     memcg: add file-based RSS accounting
has been added to the -mm tree.  Its filename is
     memcg-add-file-based-rss-accounting.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: add file-based RSS accounting
From: Balbir Singh <balbir@linux.vnet.ibm.com>

Add file RSS tracking per memory cgroup

We currently don't track file RSS, the RSS we report is actually anon RSS.
 All the file mapped pages, come in through the page cache and get
accounted there.  This patch adds support for accounting file RSS pages. 
It should

1. Help improve the metrics reported by the memory resource controller
2. Will form the basis for a future shared memory accounting heuristic
   that has been proposed by Kamezawa.

Unfortunately, we cannot rename the existing "rss" keyword used in
memory.stat to "anon_rss".  We however, add "mapped_file" data and hope to
educate the end user through documentation.

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.cn>
Cc: Paul Menage <menage@google.com>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    7 +++
 mm/memcontrol.c            |   66 ++++++++++++++++++++++++++++++++++-
 mm/rmap.c                  |    5 ++
 3 files changed, 75 insertions(+), 3 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-add-file-based-rss-accounting include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-add-file-based-rss-accounting
+++ a/include/linux/memcontrol.h
@@ -116,7 +116,7 @@ static inline bool mem_cgroup_disabled(v
 }
 
 extern bool mem_cgroup_oom_called(struct task_struct *task);
-
+void mem_cgroup_update_mapped_file_stat(struct page *page, int val);
 #else /* CONFIG_CGROUP_MEM_RES_CTLR */
 struct mem_cgroup;
 
@@ -264,6 +264,11 @@ mem_cgroup_print_oom_info(struct mem_cgr
 {
 }
 
+static inline void mem_cgroup_update_mapped_file_stat(struct page *page,
+							int val)
+{
+}
+
 #endif /* CONFIG_CGROUP_MEM_CONT */
 
 #endif /* _LINUX_MEMCONTROL_H */
diff -puN mm/memcontrol.c~memcg-add-file-based-rss-accounting mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-add-file-based-rss-accounting
+++ a/mm/memcontrol.c
@@ -62,7 +62,8 @@ enum mem_cgroup_stat_index {
 	 * For MEM_CONTAINER_TYPE_ALL, usage = pagecache + rss.
 	 */
 	MEM_CGROUP_STAT_CACHE, 	   /* # of pages charged as cache */
-	MEM_CGROUP_STAT_RSS,	   /* # of pages charged as rss */
+	MEM_CGROUP_STAT_RSS,	   /* # of pages charged as anon rss */
+	MEM_CGROUP_STAT_MAPPED_FILE,  /* # of pages charged as file rss */
 	MEM_CGROUP_STAT_PGPGIN_COUNT,	/* # of pages paged in */
 	MEM_CGROUP_STAT_PGPGOUT_COUNT,	/* # of pages paged out */
 
@@ -321,6 +322,44 @@ static bool mem_cgroup_is_obsolete(struc
 	return css_is_removed(&mem->css);
 }
 
+/*
+ * Currently used to update mapped file statistics, but the routine can be
+ * generalized to update other statistics as well.
+ */
+void mem_cgroup_update_mapped_file_stat(struct page *page, int val)
+{
+	struct mem_cgroup *mem;
+	struct mem_cgroup_stat *stat;
+	struct mem_cgroup_stat_cpu *cpustat;
+	int cpu;
+	struct page_cgroup *pc;
+
+	if (!page_is_file_cache(page))
+		return;
+
+	pc = lookup_page_cgroup(page);
+	if (unlikely(!pc))
+		return;
+
+	lock_page_cgroup(pc);
+	mem = pc->mem_cgroup;
+	if (!mem)
+		goto done;
+
+	if (!PageCgroupUsed(pc))
+		goto done;
+
+	/*
+	 * Preemption is already disabled, we don't need get_cpu()
+	 */
+	cpu = smp_processor_id();
+	stat = &mem->stat;
+	cpustat = &stat->cpustat[cpu];
+
+	__mem_cgroup_stat_add_safe(cpustat, MEM_CGROUP_STAT_MAPPED_FILE, val);
+done:
+	unlock_page_cgroup(pc);
+}
 
 /*
  * Call callback function against all cgroup under hierarchy tree.
@@ -1096,6 +1135,10 @@ static int mem_cgroup_move_account(struc
 	struct mem_cgroup_per_zone *from_mz, *to_mz;
 	int nid, zid;
 	int ret = -EBUSY;
+	struct page *page;
+	int cpu;
+	struct mem_cgroup_stat *stat;
+	struct mem_cgroup_stat_cpu *cpustat;
 
 	VM_BUG_ON(from == to);
 	VM_BUG_ON(PageLRU(pc->page));
@@ -1116,6 +1159,23 @@ static int mem_cgroup_move_account(struc
 
 	res_counter_uncharge(&from->res, PAGE_SIZE);
 	mem_cgroup_charge_statistics(from, pc, false);
+
+	page = pc->page;
+	if (page_is_file_cache(page) && page_mapped(page)) {
+		cpu = smp_processor_id();
+		/* Update mapped_file data for mem_cgroup "from" */
+		stat = &from->stat;
+		cpustat = &stat->cpustat[cpu];
+		__mem_cgroup_stat_add_safe(cpustat, MEM_CGROUP_STAT_MAPPED_FILE,
+						-1);
+
+		/* Update mapped_file data for mem_cgroup "to" */
+		stat = &to->stat;
+		cpustat = &stat->cpustat[cpu];
+		__mem_cgroup_stat_add_safe(cpustat, MEM_CGROUP_STAT_MAPPED_FILE,
+						1);
+	}
+
 	if (do_swap_account)
 		res_counter_uncharge(&from->memsw, PAGE_SIZE);
 	css_put(&from->css);
@@ -2051,6 +2111,7 @@ static int mem_cgroup_reset(struct cgrou
 enum {
 	MCS_CACHE,
 	MCS_RSS,
+	MCS_MAPPED_FILE,
 	MCS_PGPGIN,
 	MCS_PGPGOUT,
 	MCS_INACTIVE_ANON,
@@ -2071,6 +2132,7 @@ struct {
 } memcg_stat_strings[NR_MCS_STAT] = {
 	{"cache", "total_cache"},
 	{"rss", "total_rss"},
+	{"mapped_file", "total_mapped_file"},
 	{"pgpgin", "total_pgpgin"},
 	{"pgpgout", "total_pgpgout"},
 	{"inactive_anon", "total_inactive_anon"},
@@ -2091,6 +2153,8 @@ static int mem_cgroup_get_local_stat(str
 	s->stat[MCS_CACHE] += val * PAGE_SIZE;
 	val = mem_cgroup_read_stat(&mem->stat, MEM_CGROUP_STAT_RSS);
 	s->stat[MCS_RSS] += val * PAGE_SIZE;
+	val = mem_cgroup_read_stat(&mem->stat, MEM_CGROUP_STAT_MAPPED_FILE);
+	s->stat[MCS_MAPPED_FILE] += val * PAGE_SIZE;
 	val = mem_cgroup_read_stat(&mem->stat, MEM_CGROUP_STAT_PGPGIN_COUNT);
 	s->stat[MCS_PGPGIN] += val;
 	val = mem_cgroup_read_stat(&mem->stat, MEM_CGROUP_STAT_PGPGOUT_COUNT);
diff -puN mm/rmap.c~memcg-add-file-based-rss-accounting mm/rmap.c
--- a/mm/rmap.c~memcg-add-file-based-rss-accounting
+++ a/mm/rmap.c
@@ -827,8 +827,10 @@ void page_add_new_anon_rmap(struct page 
  */
 void page_add_file_rmap(struct page *page)
 {
-	if (atomic_inc_and_test(&page->_mapcount))
+	if (atomic_inc_and_test(&page->_mapcount)) {
 		__inc_zone_page_state(page, NR_FILE_MAPPED);
+		mem_cgroup_update_mapped_file_stat(page, 1);
+	}
 }
 
 #ifdef CONFIG_DEBUG_VM
@@ -877,6 +879,7 @@ void page_remove_rmap(struct page *page)
 			mem_cgroup_uncharge_page(page);
 		__dec_zone_page_state(page,
 			PageAnon(page) ? NR_ANON_PAGES : NR_FILE_MAPPED);
+		mem_cgroup_update_mapped_file_stat(page, -1);
 		/*
 		 * It would be tidy to reset the PageAnon mapping here,
 		 * but that might overwrite a racing page_add_anon_rmap
_

Patches currently in -mm which might be from balbir@linux.vnet.ibm.com are

memcg-use-rcu_dereference-to-access-mm-owner.patch
vmscanmemcg-reintroduce-sc-may_swap.patch
mm-fix-pageref-leak-in-do_swap_page.patch
linux-next.patch
memcg-add-file-based-rss-accounting.patch

