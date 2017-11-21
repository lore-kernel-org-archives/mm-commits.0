From: akpm@linux-foundation.org
Subject: +
 mm-memcontrol-implement-lruvec-stat-functions-on-top-of-each-other.patch
 added to -mm tree
Date: Tue, 21 Nov 2017 15:57:20 -0800
Message-ID: <5a14bd60.H1mA5l+TRBOjnuCZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41236 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751494AbdKUX5V (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Nov 2017 18:57:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.com, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: implement lruvec stat functions on top of each other
has been added to the -mm tree.  Its filename is
     mm-memcontrol-implement-lruvec-stat-functions-on-top-of-each-other.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-implement-lruvec-stat-functions-on-top-of-each-other.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-implement-lruvec-stat-functions-on-top-of-each-other.patch

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
Subject: mm: memcontrol: implement lruvec stat functions on top of each other

The implementation of the lruvec stat functions and their variants for
accounting through a page, or accounting from a preemptible context, are
mostly identical and needlessly repetitive.

Implement the lruvec_page functions by looking up the page's lruvec and
then using the lruvec function.

Implement the functions for preemptible contexts by disabling preemption
before calling the atomic context functions.

Link: http://lkml.kernel.org/r/20171103153336.24044-2-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   44 +++++++++++++++++------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff -puN include/linux/memcontrol.h~mm-memcontrol-implement-lruvec-stat-functions-on-top-of-each-other include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-memcontrol-implement-lruvec-stat-functions-on-top-of-each-other
+++ a/include/linux/memcontrol.h
@@ -569,51 +569,51 @@ static inline void __mod_lruvec_state(st
 {
 	struct mem_cgroup_per_node *pn;
 
+	/* Update node */
 	__mod_node_page_state(lruvec_pgdat(lruvec), idx, val);
+
 	if (mem_cgroup_disabled())
 		return;
+
 	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
+
+	/* Update memcg */
 	__mod_memcg_state(pn->memcg, idx, val);
+
+	/* Update lruvec */
 	__this_cpu_add(pn->lruvec_stat->count[idx], val);
 }
 
 static inline void mod_lruvec_state(struct lruvec *lruvec,
 				    enum node_stat_item idx, int val)
 {
-	struct mem_cgroup_per_node *pn;
-
-	mod_node_page_state(lruvec_pgdat(lruvec), idx, val);
-	if (mem_cgroup_disabled())
-		return;
-	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
-	mod_memcg_state(pn->memcg, idx, val);
-	this_cpu_add(pn->lruvec_stat->count[idx], val);
+	preempt_disable();
+	__mod_lruvec_state(lruvec, idx, val);
+	preempt_enable();
 }
 
 static inline void __mod_lruvec_page_state(struct page *page,
 					   enum node_stat_item idx, int val)
 {
-	struct mem_cgroup_per_node *pn;
+	pg_data_t *pgdat = page_pgdat(page);
+	struct lruvec *lruvec;
 
-	__mod_node_page_state(page_pgdat(page), idx, val);
-	if (mem_cgroup_disabled() || !page->mem_cgroup)
+	/* Untracked pages have no memcg, no lruvec. Update only the node */
+	if (!page->mem_cgroup) {
+		__mod_node_page_state(pgdat, idx, val);
 		return;
-	__mod_memcg_state(page->mem_cgroup, idx, val);
-	pn = page->mem_cgroup->nodeinfo[page_to_nid(page)];
-	__this_cpu_add(pn->lruvec_stat->count[idx], val);
+	}
+
+	lruvec = mem_cgroup_lruvec(pgdat, page->mem_cgroup);
+	__mod_lruvec_state(lruvec, idx, val);
 }
 
 static inline void mod_lruvec_page_state(struct page *page,
 					 enum node_stat_item idx, int val)
 {
-	struct mem_cgroup_per_node *pn;
