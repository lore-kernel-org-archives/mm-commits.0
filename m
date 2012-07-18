From: akpm@linux-foundation.org
Subject: + memcg-add-mem_cgroup_from_css-helper.patch added to -mm tree
Date: Wed, 18 Jul 2012 14:36:18 -0700
Message-ID: <20120718213619.21ABA5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:54640 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753488Ab2GRVgW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jul 2012 17:36:22 -0400
Received: by wgbdt11 with SMTP id dt11so98800wgb.1
        for <mm-commits@vger.kernel.org>; Wed, 18 Jul 2012 14:36:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: liwanp@linux.vnet.ibm.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, shangw@linux.vnet.ibm.com


The patch titled
     Subject: memcg: add mem_cgroup_from_css() helper
has been added to the -mm tree.  Its filename is
     memcg-add-mem_cgroup_from_css-helper.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: memcg: add mem_cgroup_from_css() helper

Add a mem_cgroup_from_css() helper to replace open-coded invokations of
container_of().  To clarify the code and to add a little more type safety.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Gavin Shan <shangw@linux.vnet.ibm.com>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff -puN mm/memcontrol.c~memcg-add-mem_cgroup_from_css-helper mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-add-mem_cgroup_from_css-helper
+++ a/mm/memcontrol.c
@@ -410,6 +410,12 @@ static void mem_cgroup_put(struct mem_cg
 #include <net/sock.h>
 #include <net/ip.h>
 
+static inline
+struct mem_cgroup *mem_cgroup_from_css(struct cgroup_subsys_state *s)
+{
+	return container_of(s, struct mem_cgroup, css);
+}
+
 static bool mem_cgroup_is_root(struct mem_cgroup *memcg);
 void sock_update_memcg(struct sock *sk)
 {
@@ -862,7 +868,7 @@ static void memcg_check_events(struct me
 
 struct mem_cgroup *mem_cgroup_from_cont(struct cgroup *cont)
 {
-	return container_of(cgroup_subsys_state(cont,
+	return mem_cgroup_from_css(cgroup_subsys_state(cont,
 				mem_cgroup_subsys_id), struct mem_cgroup,
 				css);
 }
@@ -877,7 +883,7 @@ struct mem_cgroup *mem_cgroup_from_task(
 	if (unlikely(!p))
 		return NULL;
 
-	return container_of(task_subsys_state(p, mem_cgroup_subsys_id),
+	return mem_cgroup_from_css(task_subsys_state(p, mem_cgroup_subsys_id),
 				struct mem_cgroup, css);
 }
 
@@ -964,7 +970,7 @@ struct mem_cgroup *mem_cgroup_iter(struc
 		css = css_get_next(&mem_cgroup_subsys, id + 1, &root->css, &id);
 		if (css) {
 			if (css == &root->css || css_tryget(css))
-				memcg = container_of(css,
+				memcg = mem_cgroup_from_css(css,
 						     struct mem_cgroup, css);
 		} else
 			id = 0;
@@ -2494,7 +2500,7 @@ static struct mem_cgroup *mem_cgroup_loo
 	css = css_lookup(&mem_cgroup_subsys, id);
 	if (!css)
 		return NULL;
-	return container_of(css, struct mem_cgroup, css);
+	return mem_cgroup_from_css(css, struct mem_cgroup, css);
 }
 
 struct mem_cgroup *try_get_mem_cgroup_from_page(struct page *page)
_
Subject: Subject: memcg: add mem_cgroup_from_css() helper

Patches currently in -mm which might be from liwanp@linux.vnet.ibm.com are

hugetlb-cgroup-simplify-pre_destroy-callback.patch
memcg-add-mem_cgroup_from_css-helper.patch

