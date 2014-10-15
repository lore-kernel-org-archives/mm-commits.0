From: akpm@linux-foundation.org
Subject: +
 mm-memcontrol-convert-reclaim-iterator-to-simple-css-refcounting-fix.patch
 added to -mm tree
Date: Wed, 15 Oct 2014 12:19:12 -0700
Message-ID: <543ec8b0.9wH8FOkO2qKGmeVp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35948 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbaJOTTM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Oct 2014 15:19:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, hannes@cmpxchg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memcontrol-convert-reclaim-iterator-to-simple-css-refcounting-fix
has been added to the -mm tree.  Its filename is
     mm-memcontrol-convert-reclaim-iterator-to-simple-css-refcounting-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-convert-reclaim-iterator-to-simple-css-refcounting-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-convert-reclaim-iterator-to-simple-css-refcounting-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: mm-memcontrol-convert-reclaim-iterator-to-simple-css-refcounting-fix

Make sure that the cached reference is always released.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-convert-reclaim-iterator-to-simple-css-refcounting-fix mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-convert-reclaim-iterator-to-simple-css-refcounting-fix
+++ a/mm/memcontrol.c
@@ -1165,9 +1165,17 @@ struct mem_cgroup *mem_cgroup_iter(struc
 	}
 
 	if (reclaim) {
-		if (cmpxchg(&iter->position, pos, memcg) == pos && memcg)
-			css_get(&memcg->css);
+		if (cmpxchg(&iter->position, pos, memcg) == pos) {
+			if (memcg)
+				css_get(&memcg->css);
+			if (pos)
+				css_put(&pos->css);
+		}
 
+		/*
+		 * pairs with css_tryget when dereferencing iter->position
+		 * above.
+		 */
 		if (pos)
 			css_put(&pos->css);
 
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
cgroup-kmemleak-add-kmemleak_free-for-cgroup-deallocations.patch
mm-memcontrol-lockless-page-counters.patch
mm-hugetlb_cgroup-convert-to-lockless-page-counters.patch
kernel-res_counter-remove-the-unused-api.patch
mm-memcontrol-convert-reclaim-iterator-to-simple-css-refcounting.patch
mm-memcontrol-convert-reclaim-iterator-to-simple-css-refcounting-fix.patch
mm-memcontrol-take-a-css-reference-for-each-charged-page.patch
mm-memcontrol-remove-obsolete-kmemcg-pinning-tricks.patch
mm-memcontrol-continue-cache-reclaim-from-offlined-groups.patch
mm-memcontrol-remove-synchroneous-stock-draining-code.patch
freezer-check-oom-kill-while-being-frozen.patch
freezer-remove-obsolete-comments-in-__thaw_task.patch
oom-pm-oom-killed-task-cannot-escape-pm-suspend.patch

