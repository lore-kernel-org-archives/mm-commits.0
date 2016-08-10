From: akpm@linux-foundation.org
Subject: +
 mm-memcontrol-add-sanity-checks-for-memcg-idref-on-get-put.patch added to
 -mm tree
Date: Wed, 10 Aug 2016 15:27:25 -0700
Message-ID: <57abaa4d.wJrrBAx4H6AD3fbu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53424 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741AbcHJW10 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Aug 2016 18:27:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, hannes@cmpxchg.org, mhocko@suse.com, mm-commits@vger.kernel.org


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
@@ -4049,6 +4049,7 @@ static DEFINE_IDR(mem_cgroup_idr);
 
 static void mem_cgroup_id_get_many(struct mem_cgroup *memcg, unsigned int n)
 {
+	VM_BUG_ON(atomic_read(&memcg->id.ref) <= 0);
 	atomic_add(n, &memcg->id.ref);
 }
 
@@ -4072,6 +4073,7 @@ static struct mem_cgroup *mem_cgroup_id_
 
 static void mem_cgroup_id_put_many(struct mem_cgroup *memcg, unsigned int n)
 {
+	VM_BUG_ON(atomic_read(&memcg->id.ref) < n);
 	if (atomic_sub_and_test(n, &memcg->id.ref)) {
 		idr_remove(&mem_cgroup_idr, memcg->id.id);
 		memcg->id.id = 0;
@@ -4260,8 +4262,10 @@ fail:
 
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

Patches currently in -mm which might be from vdavydov@virtuozzo.com are

mm-memcontrol-fix-swap-counter-leak-on-swapout-from-offline-cgroup.patch
mm-memcontrol-fix-swap-counter-leak-on-swapout-from-offline-cgroup-fix.patch
mm-memcontrol-fix-memcg-id-ref-counter-on-swap-charge-move.patch
mm-oom-deduplicate-victim-selection-code-for-memcg-and-global-oom.patch
mm-memcontrol-add-sanity-checks-for-memcg-idref-on-get-put.patch

