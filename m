From: akpm@linux-foundation.org
Subject: [patch 014/127] mm: memcontrol: add sanity checks for
 memcg->id.ref on get/put
Date: Fri, 07 Oct 2016 16:57:29 -0700
Message-ID: <57f83669.1iHOGrFp56PV2t/k%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38837 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751068AbcJGX5a (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2016 19:57:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, vdavydov@virtuozzo.com, hannes@cmpxchg.org, mhocko@suse.com

From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: mm: memcontrol: add sanity checks for memcg->id.ref on get/put

Link: http://lkml.kernel.org/r/1c5ddb1c171dbdfc3262252769d6138a29b35b70.1470219853.git.vdavydov@virtuozzo.com
Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN mm/memcontrol.c~mm-memcontrol-add-sanity-checks-for-memcg-idref-on-get-put mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-add-sanity-checks-for-memcg-idref-on-get-put
+++ a/mm/memcontrol.c
@@ -4062,11 +4062,13 @@ static DEFINE_IDR(mem_cgroup_idr);
 
 static void mem_cgroup_id_get_many(struct mem_cgroup *memcg, unsigned int n)
 {
+	VM_BUG_ON(atomic_read(&memcg->id.ref) <= 0);
 	atomic_add(n, &memcg->id.ref);
 }
 
 static void mem_cgroup_id_put_many(struct mem_cgroup *memcg, unsigned int n)
 {
+	VM_BUG_ON(atomic_read(&memcg->id.ref) < n);
 	if (atomic_sub_and_test(n, &memcg->id.ref)) {
 		idr_remove(&mem_cgroup_idr, memcg->id.id);
 		memcg->id.id = 0;
@@ -4255,8 +4257,10 @@ fail:
 
 static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 {
+	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
+
 	/* Online state pins memcg ID, memcg ID pins CSS */
-	mem_cgroup_id_get(mem_cgroup_from_css(css));
+	atomic_set(&memcg->id.ref, 1);
 	css_get(css);
 	return 0;
 }
_
