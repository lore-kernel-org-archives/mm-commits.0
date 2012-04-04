From: akpm@linux-foundation.org
Subject: + memcg-mark-more-functions-variables-as-static.patch added to -mm tree
Date: Wed, 04 Apr 2012 14:22:07 -0700
Message-ID: <20120404212207.B441EA04F2@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:34612 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250Ab2DDVWK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Apr 2012 17:22:10 -0400
Received: by bkcjm19 with SMTP id jm19so37526bkc.1
        for <mm-commits@vger.kernel.org>; Wed, 04 Apr 2012 14:22:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kirill@shutemov.name, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz


The patch titled
     Subject: memcg: mark more functions/variables as static
has been added to the -mm tree.  Its filename is
     memcg-mark-more-functions-variables-as-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: memcg: mark more functions/variables as static

Based on sparse output.

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff -puN mm/memcontrol.c~memcg-mark-more-functions-variables-as-static mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-mark-more-functions-variables-as-static
+++ a/mm/memcontrol.c
@@ -59,7 +59,7 @@
 
 struct cgroup_subsys mem_cgroup_subsys __read_mostly;
 #define MEM_CGROUP_RECLAIM_RETRIES	5
-struct mem_cgroup *root_mem_cgroup __read_mostly;
+static struct mem_cgroup *root_mem_cgroup __read_mostly;
 
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
 /* Turned on only when memory cgroup is enabled && really_do_swap_account = 1 */
@@ -1618,7 +1618,7 @@ int mem_cgroup_select_victim_node(struct
  * unused nodes. But scan_nodes is lazily updated and may not cotain
  * enough new information. We need to do double check.
  */
-bool mem_cgroup_reclaimable(struct mem_cgroup *memcg, bool noswap)
+static bool mem_cgroup_reclaimable(struct mem_cgroup *memcg, bool noswap)
 {
 	int nid;
 
@@ -1653,7 +1653,7 @@ int mem_cgroup_select_victim_node(struct
 	return 0;
 }
 
-bool mem_cgroup_reclaimable(struct mem_cgroup *memcg, bool noswap)
+static bool mem_cgroup_reclaimable(struct mem_cgroup *memcg, bool noswap)
 {
 	return test_mem_cgroup_node_reclaimable(memcg, 0, noswap);
 }
@@ -1827,7 +1827,8 @@ static void memcg_oom_recover(struct mem
 /*
  * try to call OOM killer. returns false if we should exit memory-reclaim loop.
  */
-bool mem_cgroup_handle_oom(struct mem_cgroup *memcg, gfp_t mask, int order)
+static bool mem_cgroup_handle_oom(struct mem_cgroup *memcg, gfp_t mask,
+				  int order)
 {
 	struct oom_wait_info owait;
 	bool locked, need_to_kill;
@@ -3754,7 +3755,7 @@ try_to_free:
 	goto move_account;
 }
 
-int mem_cgroup_force_empty_write(struct cgroup *cont, unsigned int event)
+static int mem_cgroup_force_empty_write(struct cgroup *cont, unsigned int event)
 {
 	return mem_cgroup_force_empty(mem_cgroup_from_cont(cont), true);
 }
@@ -4035,7 +4036,7 @@ struct mcs_total_stat {
 	s64 stat[NR_MCS_STAT];
 };
 
-struct {
+static struct {
 	char *local_name;
 	char *total_name;
 } memcg_stat_strings[NR_MCS_STAT] = {
_
Subject: Subject: memcg: mark more functions/variables as static

Patches currently in -mm which might be from kirill@shutemov.name are

memcg-mark-more-functions-variables-as-static.patch

