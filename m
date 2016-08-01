From: akpm@linux-foundation.org
Subject: +
 mm-memcontrol-add-sanity-checks-for-memcg-idref-on-get-put.patch added to
 -mm tree
Date: Mon, 01 Aug 2016 14:13:04 -0700
Message-ID: <579fbb60.ed7d76R5UPniJSEc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42569 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485AbcHAVOk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Aug 2016 17:14:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: add sanity checks for memcg->id.ref on get/put
has been added to the -mm tree.  Its filename is
     mm-memcontrol-add-sanity-checks-for-memcg-idref-on-get-put.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-add-sanity-checks-for-memcg-idref-on-get-put.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-add-sanity-checks-for-memcg-idref-on-get-put.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: mm: memcontrol: add sanity checks for memcg->id.ref on get/put

Link: http://lkml.kernel.org/r/ad702144f24374cbfb3a35b71658a0ae24ba7d84.1470057819.git.vdavydov@virtuozzo.com
Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-add-sanity-checks-for-memcg-idref-on-get-put mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-add-sanity-checks-for-memcg-idref-on-get-put
+++ a/mm/memcontrol.c
@@ -4071,18 +4071,22 @@ static DEFINE_IDR(mem_cgroup_idr);
 
 static void mem_cgroup_id_get_many(struct mem_cgroup *memcg, unsigned int n)
 {
+	VM_BUG_ON(atomic_read(&memcg->id.ref) <= 0);
 	atomic_add(n, &memcg->id.ref);
 }
 
 static struct mem_cgroup *mem_cgroup_id_get_active(struct mem_cgroup *memcg)
 {
-	while (!atomic_inc_not_zero(&memcg->id.ref))
+	while (!atomic_inc_not_zero(&memcg->id.ref)) {
+		VM_BUG_ON(mem_cgroup_is_root(memcg));
 		memcg = parent_mem_cgroup(memcg);
+	}
 	return memcg;
 }
 
 static void mem_cgroup_id_put_many(struct mem_cgroup *memcg, unsigned int n)
 {
+	VM_BUG_ON(atomic_read(&memcg->id.ref) < n);
 	if (atomic_sub_and_test(n, &memcg->id.ref)) {
 		idr_remove(&mem_cgroup_idr, memcg->id.id);
 		memcg->id.id = 0;
@@ -4203,6 +4207,7 @@ static struct mem_cgroup *mem_cgroup_all
 	INIT_LIST_HEAD(&memcg->cgwb_list);
 #endif
 	idr_replace(&mem_cgroup_idr, memcg, memcg->id.id);
+	atomic_set(&memcg->id.ref, 1);
 	return memcg;
 fail:
 	if (memcg->id.id > 0)
@@ -4272,7 +4277,6 @@ fail:
 static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 {
 	/* Online state pins memcg ID, memcg ID pins CSS */
-	mem_cgroup_id_get(mem_cgroup_from_css(css));
 	css_get(css);
 	return 0;
 }
_

Patches currently in -mm which might be from vdavydov@virtuozzo.com are

mm-memcontrol-fix-swap-counter-leak-on-swapout-from-offline-cgroup.patch
mm-memcontrol-fix-memcg-id-ref-counter-on-swap-charge-move.patch
mm-memcontrol-add-sanity-checks-for-memcg-idref-on-get-put.patch

