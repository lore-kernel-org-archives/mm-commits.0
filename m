From: akpm@linux-foundation.org
Subject: [merged] memcg-avoid-dangling-reference-count-in-creation-failure.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:53:38 -0800
Message-ID: <20130225205338.B15B45A426D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:34560 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758786Ab3BYUxk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:53:40 -0500
Received: by mail-yh0-f73.google.com with SMTP id 28so348425yhr.0
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:53:39 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: glommer@parallels.com, hannes@cmpxchg.org, kamezawa.hiroyuki@gmail.com, mhocko@suse.cz, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: avoid dangling reference count in creation failure.
has been removed from the -mm tree.  Its filename was
     memcg-avoid-dangling-reference-count-in-creation-failure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Glauber Costa <glommer@parallels.com>
Subject: memcg: avoid dangling reference count in creation failure.

When use_hierarchy is enabled, we acquire an extra reference count in our
parent during cgroup creation.  We don't release it, though, if any
failure exist in the creation process.

Signed-off-by: Glauber Costa <glommer@parallels.com>
Reported-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Tejun Heo <tj@kernel.org>
Cc: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/memcontrol.c~memcg-avoid-dangling-reference-count-in-creation-failure mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-avoid-dangling-reference-count-in-creation-failure
+++ a/mm/memcontrol.c
@@ -6196,6 +6196,8 @@ mem_cgroup_css_online(struct cgroup *con
 		 * call __mem_cgroup_free, so return directly
 		 */
 		mem_cgroup_put(memcg);
+		if (parent->use_hierarchy)
+			mem_cgroup_put(parent);
 	}
 	return error;
 }
_

Patches currently in -mm which might be from glommer@parallels.com are

origin.patch
linux-next.patch
slub-correctly-bootstrap-boot-caches.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch

